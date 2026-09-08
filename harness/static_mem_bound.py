"""E6 / P2b: derive a STATIC memory bound for a compiled model from the
compiler's own allocation schedule, instead of measuring RSS.

Why
---
E5 showed the memory axis going the wrong way against NumPy (B0) because the
measured number (RSS delta) is dominated by the IREE runtime, not by the
model. A contract does not need "small memory"; it needs a memory figure
that is KNOWN AT COMPILE TIME and provably not exceeded at run time. This
script extracts that figure.

How
---
IREE's stream dialect, after `iree-stream-schedule-allocation`, expresses every
buffer the program will touch as `stream.resource.alloca` / `stream.tensor.import`
with an explicit size operand. For static shapes those sizes are integer
constants. Transient buffers are packed into slabs by `stream.resource.pack`
with per-slice sizes. We parse that IR and report:

  static_external_input_bytes   sum of imported input resources
  static_external_output_bytes  sum of externally allocated result resources
  static_transient_bytes        conservative bound = sum of pack slice sizes
                                (exact slab size can be smaller due to
                                lifetime-based packing; the sum is a valid
                                upper bound)
  all_sizes_static              False if any size is not an integer constant;
                                then NO static bound exists and the contract
                                must say so.

The bound covers what the compiled program itself allocates. It does NOT
cover the IREE runtime context (VM, HAL device, module tables). That cost is
runtime-side, configuration-dependent, and must be characterized separately
-- which is exactly the decomposition E5 was missing.

Soundness check
---------------
When the runtime exposes HAL allocator statistics, we run the artifact and
verify peak transient bytes observed <= static_transient_bytes. A violation
would falsify the bound.
"""

import argparse
import json
import re
import subprocess
import sys
import tempfile


def dump_alloc_ir(mlir_path, extra_args):
    with tempfile.NamedTemporaryFile(suffix=".vmfb", delete=False) as f:
        out_vmfb = f.name
    cmd = ["iree-compile", mlir_path,
           "--iree-hal-target-backends=llvm-cpu",
           "--mlir-print-ir-after=iree-stream-layout-slices",
           "-o", out_vmfb] + extra_args
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(r.stderr[-2000:])
    return r.stderr, out_vmfb


# A single stream.* op can be pretty-printed across more than one line (long
# operand lists wrap). The naive "[^\n]*" window used before D13/fail-closed
# missed those and silently dropped the allocation (EVIDENCE_v0.9 SS11.9,
# reproduced by inserting a line break in a stored conv2d layout IR: outputs
# and transient_slabs both disappeared while unresolved stayed empty). This
# bounded, non-greedy "any char, but not the start of a new statement" window
# lets the match cross a line break inside ONE op's own syntax while still
# stopping before the next `%value = ...` def or a bare closing brace, so it
# cannot silently swallow an unrelated neighbouring op instead.
_CONT = r"(?:(?!\n\s*(?:%[\w.]+[,\s]|\}))[\s\S])*?"

# Resource-producing ops actually seen in the entry body across every stored
# layout IR (results/e14_aarch64_qemu/*/layout_ir/*.txt) that this parser
# either accounts for (alloca, pack, tensor.import) or that are structurally
# non-allocating (dealloca frees an existing resource; tensor.export wraps an
# already-counted resource as the return value). Anything else appearing in
# the entry body is, by construction, NOT sized by any of the scanners below
# -- so instead of silently omitting it (D13), it is pushed into `unresolved`,
# which forces bound_method to UNKNOWN_BOUND. This is a whitelist, not a
# parser: it does not understand what an unrecognized op does, only that this
# tool cannot size it.
_KNOWN_ENTRY_OPS = {"resource.alloca", "resource.pack", "resource.dealloca",
                    "tensor.import", "tensor.export"}
_OP_RE = re.compile(r"stream\.(resource|tensor)\.([A-Za-z_]+)")


def parse_alloc_ir(ir, entry="infer"):
    """Parse the allocation schedule.

    Scoping matters (E6c lesson): baked constants are materialized in a
    util.initializer via `stream.resource.constants` / `stream.tensor.import`
    of module-resident data. Those are LOAD-TIME, module-resident bytes and
    must not be attributed to the per-call bound. So per-call inputs /
    outputs / transients are parsed only inside the public entry function,
    and constant resources are reported separately.
    """
    consts = {}
    for m in re.finditer(r"(%[\w#]+)\s*=\s*arith\.constant\s+(\d+)\s*:\s*index", ir):
        consts[m.group(1)] = int(m.group(2))

    def size_of(sym):
        if sym in consts:
            return consts[sym], True
        m = re.fullmatch(r"%c(\d+)(?:_\d+)?", sym)
        if m:
            return int(m.group(1)), True
        return None, False

    # isolate the entry function body
    # the pass-manager may print the module several times; take the LAST
    # occurrence of the entry function (the most-lowered state)
    ms = list(re.finditer(r"(util\.func|func\.func)\s+public\s+@" + re.escape(entry) + r"\b.*?\n\}", ir, re.S))
    m = ms[-1] if ms else None
    body = m.group(0) if m else ir

    result = {"inputs": [], "outputs": [], "transient_slices": [],
              "transient_slabs": [],
              "constants": [], "unresolved": [], "dispatches": 0,
              "entry_found": m is not None}

    for mm in re.finditer(r"stream\.tensor\.import" + _CONT + r"!stream\.resource<external>\{(%[\w#]+)\}", body):
        v, ok = size_of(mm.group(1))
        (result["inputs"] if ok else result["unresolved"]).append(v if ok else mm.group(1))

    for mm in re.finditer(r"stream\.resource\.alloca" + _CONT + r"!stream\.resource<(external|transient)>\{(%[\w#]+)\}", body):
        kind, sym = mm.group(1), mm.group(2)
        v, ok = size_of(sym)
        if kind == "external":
            (result["outputs"] if ok else result["unresolved"]).append(v if ok else sym)
        else:  # transient slab, post-layout: exact laid-out size incl. alignment/reuse
            (result["transient_slabs"] if ok else result["unresolved"]).append(v if ok else sym)

    for mm in re.finditer(r"stream\.resource\.pack[^{]*slices\(\{(.*?)\}\)", body, re.S):
        for s2 in re.finditer(r"\[\s*\d+\s*,\s*\d+\s*\]\s*=\s*(%[\w#]+)", mm.group(1)):
            v, ok = size_of(s2.group(1))
            (result["transient_slices"] if ok else result["unresolved"]).append(v if ok else s2.group(1))

    # fail-closed: any resource-producing op in the entry body that isn't one
    # of the ops this parser understands is an unsized allocation, not a
    # non-event (D13). Reported once per distinct unrecognized op name.
    unknown_ops = sorted({mm.group(1) + "." + mm.group(2) for mm in _OP_RE.finditer(body)}
                         - _KNOWN_ENTRY_OPS)
    for op in unknown_ops:
        result["unresolved"].append("unrecognized_op:stream.%s" % op)

    # module-resident constants (load-time). With a single --mlir-print-ir-after
    # pass the pass manager prints each function once, so the initializer (and
    # its stream.resource.constants) appears exactly once in the dump.
    for mm in re.finditer(r"!stream\.resource<constant>\{(%[\w#]+)\}\s*=\s*dense", ir):
        v, ok = size_of(mm.group(1))
        if ok:
            result["constants"].append(v)

    result["dispatches"] = len(re.findall(r"stream\.cmd\.dispatch\s+@", body))
    return result


def entry_arg_shapes(mlir_path, entry="infer"):
    """Static f32 argument shapes of the entry function, parsed from source."""
    import re
    src = open(mlir_path).read()
    m = re.search(r"func\.func\s+(?:public\s+)?@" + re.escape(entry) + r"\((.*?)\)\s*->", src, re.S)
    if not m:
        return None
    shapes = []
    for t in re.finditer(r"tensor<([0-9x?]+)xf32>", m.group(1)):
        dims = t.group(1).split("x")
        if any(d == "?" for d in dims):
            return None
        shapes.append(tuple(int(d) for d in dims))
    return shapes


def runtime_peak_check(vmfb, mlir_path, driver="local-sync", iters=200):
    """Observe HAL allocator statistics after `iters` calls with random f32
    inputs matching the entry signature. Returns device_bytes_peak (bytes the
    compiled program had live at once, including imported inputs)."""
    import numpy as np
    import iree.runtime as rt
    shapes = entry_arg_shapes(mlir_path)
    if shapes is None:
        return {"supported": False, "reason": "dynamic or unparsable entry signature"}
    rng = np.random.default_rng(0)
    args = [rng.random(sh, dtype=np.float32) for sh in shapes]
    cfg = rt.Config(driver)
    ctx = rt.SystemContext(config=cfg)
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
    fn = ctx.modules.module["infer"]
    al = cfg.device.allocator
    if not al.has_statistics:
        return {"supported": False}
    for _ in range(iters):
        fn(*args)
    st = dict(al.statistics)
    st["supported"] = True
    st["iters"] = iters
    st["bytes_per_call"] = st["device_bytes_allocated"] / iters
    st["arg_shapes"] = [list(sh) for sh in shapes]
    return st


def artifact_rodata_segments(vmfb):
    """Independent (non-IR) observation: .rodata segment sizes in the compiled
    flatbuffer, from iree-dump-module. Used to cross-check the IR constant
    total without reusing the IR figure (reviewer v0.4 §4).

    Returns (external_segments, data_segments). E14 Stage 1 (conv2d model):
    iree-dump-module stores a small constant pool (e.g. 2176 B) as `embedded`
    rather than `external`, so data_segments also includes the UNLABELED
    embedded segments; the labeled embedded strings (`hal.device.id`, ...) are
    excluded. external_segments keeps the pre-Stage-1 meaning.

    D25 (E23): returns (None, None) -- NOT ([], []) -- when iree-dump-module is
    not runnable at all, so a caller can tell "the independent observation was
    not made" from "it was made and found no segments". Previously the missing
    binary raised FileNotFoundError out of here and killed the caller."""
    try:
        r = subprocess.run(["iree-dump-module", vmfb], capture_output=True, text=True)
    except OSError:
        return None, None
    external, data = [], []
    for m in re.finditer(r"\.rodata\[\s*\d+\]\s+(external|embedded)\s+(\d+) bytes([^\n]*)", r.stdout):
        kind, n, rest = m.group(1), int(m.group(2)), m.group(3)
        if kind == "external":
            external.append(n)
            data.append(n)
        elif "`" not in rest:
            data.append(n)
    return external, data


def source_baked_f32_constant_bytes(mlir_path):
    """Bytes of non-splat f32 `arith.constant dense<...>` tensors in the SOURCE
    (weights baked into the model). Diagnostic only: the compiler may inline
    constants <= 256 B into dispatch executables (they then live in the
    executable's .rodata, not in a HAL constant buffer), so this can exceed
    static_constant_bytes_module_resident. Hex (dense<"0x..">) and list
    (dense<[..]>) literals are both handled; splats (dense<0.0>) are not
    weights and are skipped."""
    src = open(mlir_path).read()
    total, pos = 0, 0
    while True:
        i = src.find("arith.constant dense<", pos)
        if i < 0:
            break
        j = i + len("arith.constant dense<")
        if src.startswith("[", j):
            end = src.find("]>", j)
        elif src.startswith('"', j):
            end = src.find('">', j)
        else:
            pos = j
            continue
        if end < 0:
            break
        m = re.match(r"\s*:\s*tensor<([0-9x]+)xf32>", src[end + 2:end + 80])
        if m:
            n = 1
            for d in m.group(1).split("x"):
                n *= int(d)
            total += n * 4
        pos = end + 2
    return total


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mlir")
    ap.add_argument("--shape", type=int, nargs=3, metavar=("N_IN", "N_H", "N_OUT"), required=True)
    ap.add_argument("--extra", default="", help="space-separated extra iree-compile flags, quoted")
    ap.add_argument("--out", default=None)
    ap.add_argument("--baked", action="store_true", help="model takes only x (weights are constants)")
    a = ap.parse_args()

    extra = a.extra.split()
    ir, vmfb = dump_alloc_ir(a.mlir, extra)
    p = parse_alloc_ir(ir)

    # D12 (EVIDENCE_v0.9 SS11.9): this standalone entry point previously
    # dropped p["entry_found"] from the condition, so an IR where the entry
    # function could not be isolated (parsed as the whole file, §63-90) but
    # happened to have no unresolved sizes was still reported
    # static_from_stream_layout -- admission_check.py:decide() would then
    # ADMIT on an analysis that never actually scoped to the entry function.
    # make_contract.py's build_contract() already required entry_found; this
    # brings the standalone CLI in line with it.
    all_static = p["entry_found"] and len(p["unresolved"]) == 0
    rep = {
        "mlir": a.mlir, "extra_args": extra, "dispatches": p["dispatches"],
        "static_external_input_bytes": sum(p["inputs"]),
        "static_external_output_bytes": sum(p["outputs"]),
        "static_transient_bytes": sum(p["transient_slabs"]),
        "transient_slabs_post_layout": p["transient_slabs"],
        "transient_slice_sum_diagnostic": sum(p["transient_slices"]),
        "transient_slices": p["transient_slices"],
        "bound_source": "post-layout transient alloca (iree-stream-layout-slices); alignment and lifetime reuse resolved by compiler",
        "static_constant_bytes_module_resident": sum(p["constants"]),
        "entry_function_found": p["entry_found"],
        "all_sizes_static": all_static,
        "unresolved_sizes": p["unresolved"],
        "bound_method": "static_from_stream_layout" if all_static else "UNKNOWN_BOUND",
        "scope": "program-allocated buffers only; excludes IREE runtime context",
    }
    rep["static_program_bytes_excl_inputs"] = (rep["static_external_output_bytes"]
                                               + rep["static_transient_bytes"])
    rep["static_total_bytes_incl_inputs"] = (rep["static_external_input_bytes"]
                                             + rep["static_program_bytes_excl_inputs"])
    ext_segs, segs = artifact_rodata_segments(vmfb)
    rep["artifact_rodata_external_segments"] = ext_segs
    rep["artifact_rodata_data_segments"] = segs   # external + unlabeled embedded
    # Diagnostic (E14 Stage 1): source-side baked f32 constant bytes vs. what
    # the compiler materialized as HAL constant buffers. A positive difference
    # is what iree-dispatch-creation inlined into dispatch executables (default
    # threshold 256 B per constant) -- those bytes are in the executable ELF,
    # i.e. in artifact.bytes, not in the HAL constant pool.
    src_c = source_baked_f32_constant_bytes(a.mlir)
    rep["source_baked_f32_constant_bytes"] = src_c
    rep["source_minus_hal_resident_constant_bytes"] = src_c - sum(p["constants"])
    # The artifact may pool several IR constants into one .rodata segment, so
    # the check is: IR constant TOTAL equals the sum of some subset of the
    # data segments (subset-sum over a handful of segments).
    total_c = sum(p["constants"])
    from itertools import combinations
    subset_sums = {0}
    for k in range(1, len(segs) + 1):
        for comb in combinations(segs, k):
            subset_sums.add(sum(comb))
    matched = total_c > 0 and total_c in subset_sums
    rep["constants_independently_confirmed_in_artifact"] = matched
    rep["constants_check_note"] = (f"IR constant total {total_c} B equals a subset-sum of flatbuffer .rodata data segments {segs} (iree-dump-module; external + unlabeled embedded)"
                                   if matched else f"IR constant total {total_c} B NOT matched by artifact segments {segs}")
    rc = runtime_peak_check(vmfb, a.mlir)
    rep["runtime_check"] = rc
    if rc.get("supported"):
        peak = rc["device_bytes_peak"]
        rep["bound_sound"] = peak <= rep["static_total_bytes_incl_inputs"]
        rep["bound_tightness"] = round(peak / rep["static_total_bytes_incl_inputs"], 4)
    if a.out:
        json.dump(rep, open(a.out, "w"), indent=2)
    print(json.dumps(rep, indent=2))


if __name__ == "__main__":
    sys.exit(main())
