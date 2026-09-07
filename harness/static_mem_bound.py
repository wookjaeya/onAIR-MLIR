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
           "--mlir-print-ir-after=iree-stream-schedule-allocation",
           "-o", out_vmfb] + extra_args
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(r.stderr[-2000:])
    return r.stderr, out_vmfb


def parse_alloc_ir(ir):
    # constants: %c65536 = arith.constant 65536 : index   (also %c0_0 etc.)
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

    result = {"inputs": [], "outputs": [], "transient_slices": [],
              "unresolved": [], "dispatches": 0}

    for m in re.finditer(r"stream\.tensor\.import[^\n]*!stream\.resource<external>\{(%[\w#]+)\}", ir):
        v, ok = size_of(m.group(1))
        (result["inputs"] if ok else result["unresolved"]).append(v if ok else m.group(1))

    for m in re.finditer(r"stream\.resource\.alloca[^\n]*!stream\.resource<(external|transient)>\{(%[\w#]+)\}", ir):
        kind, sym = m.group(1), m.group(2)
        v, ok = size_of(sym)
        if kind == "external":
            (result["outputs"] if ok else result["unresolved"]).append(v if ok else sym)
        # transient allocas are sized by pack results; handled via slices below

    for m in re.finditer(r"stream\.resource\.pack[^{]*slices\(\{(.*?)\}\)", ir, re.S):
        for s in re.finditer(r"\[\s*\d+\s*,\s*\d+\s*\]\s*=\s*(%[\w#]+)", m.group(1)):
            v, ok = size_of(s.group(1))
            (result["transient_slices"] if ok else result["unresolved"]).append(v if ok else s.group(1))

    result["dispatches"] = len(re.findall(r"stream\.cmd\.dispatch\s+@", ir))
    return result


def runtime_peak_check(vmfb, shape, driver="local-sync", iters=200):
    """Observe HAL allocator statistics after `iters` calls.

    Returns device_bytes_peak (bytes the compiled program had live at once,
    including imported inputs) so it can be compared with the static bound.
    """
    import numpy as np
    import iree.runtime as rt
    n_in, n_h, n_out = shape
    rng = np.random.default_rng(0)
    x = rng.random((1, n_in), dtype=np.float32)
    w0 = rng.random((n_in, n_h), dtype=np.float32)
    w1 = rng.random((n_h, n_out), dtype=np.float32)
    cfg = rt.Config(driver)
    ctx = rt.SystemContext(config=cfg)
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
    fn = ctx.modules.module["infer"]
    al = cfg.device.allocator
    if not al.has_statistics:
        return {"supported": False}
    for _ in range(iters):
        fn(x, w0, w1)
    st = dict(al.statistics)
    st["supported"] = True
    st["iters"] = iters
    st["bytes_per_call"] = st["device_bytes_allocated"] / iters
    return st


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mlir")
    ap.add_argument("--shape", type=int, nargs=3, metavar=("N_IN", "N_H", "N_OUT"), required=True)
    ap.add_argument("--extra", default="", help="space-separated extra iree-compile flags, quoted")
    ap.add_argument("--out", default=None)
    a = ap.parse_args()

    extra = a.extra.split()
    ir, vmfb = dump_alloc_ir(a.mlir, extra)
    p = parse_alloc_ir(ir)

    all_static = len(p["unresolved"]) == 0
    rep = {
        "mlir": a.mlir, "extra_args": extra, "dispatches": p["dispatches"],
        "static_external_input_bytes": sum(p["inputs"]),
        "static_external_output_bytes": sum(p["outputs"]),
        "static_transient_bytes": sum(p["transient_slices"]),
        "transient_slices": p["transient_slices"],
        "all_sizes_static": all_static,
        "unresolved_sizes": p["unresolved"],
        "bound_method": "static_from_stream_schedule" if all_static else "NONE",
        "scope": "program-allocated buffers only; excludes IREE runtime context",
    }
    rep["static_program_bytes_excl_inputs"] = (rep["static_external_output_bytes"]
                                               + rep["static_transient_bytes"])
    rep["static_total_bytes_incl_inputs"] = (rep["static_external_input_bytes"]
                                             + rep["static_program_bytes_excl_inputs"])
    rc = runtime_peak_check(vmfb, a.shape)
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
