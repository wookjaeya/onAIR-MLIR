#!/usr/bin/env python3
"""E60: DeepAE's layer-wise divergence on the evaluation target (AArch64 QEMU guest).

Plan: docs/plans/E60_deepae_layers_aarch64.md (committed before the cells, 623df3b).
The x86-64 decomposition of E52 was removed from the manuscript under the AArch64-only directive;
this re-measures WHERE the divergence appears, on the target.  Every structural helper is E52's,
imported rather than copied (E44): layer_chain, deployed_constants, the float32-sequential and
float64 references, the LiteRT intermediates with their preserving-run check, and the E25 rule.

Three steps, because the host cannot execute AArch64 code and the guest has no compiler:
    python3 harness/e60_deepae_layers_aarch64.py build  --input <npy> --work <dir>
    (guest)  python3 e60_deepae_layers_aarch64.py run    --work <dir>          # iree.runtime only
    python3 harness/e60_deepae_layers_aarch64.py compare --input <npy> --work <dir>
"""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
AARCH64_MLIR = "results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir"
SAMPLE = "normal_id_04_00000043_hist_librosa_w98"
INPUT_SHA = "024c8300cd90abe8721607b9cbf8c906aeebdb59ef9c0549b87789e06fd97951"   # E45 manifest
OUT = "results/e60_deepae_layers_aarch64/layers.json"
GUEST = "results/e60_deepae_layers_aarch64/guest"      # the target's raw layer outputs + the modules' hashes
FIXTURE_MANIFEST = "results/e45_real_inputs/cells/b3_deepae/fixture/manifest.json"
PLAN = "docs/plans/E60_deepae_layers_aarch64.md (committed before the cells, 623df3b)"


def _checked_input(path=None, fetch_dir=None):
    """The failing window, from a single .npy (--input) or from a fetch_real_inputs.py directory
    (--inputs, E52's layout, so the guard can reuse E52_INPUTS).  Either way the array is pinned by
    the E45 manifest's sha256 before it is used -- the bytes are not in the repository (E45)."""
    import numpy as np
    if fetch_dir:
        fm = json.load(open(os.path.join(ROOT, FIXTURE_MANIFEST), encoding="utf-8"))
        ids = [smp["sample_id"] for smp in fm["samples"]]
        x = np.load(os.path.join(fetch_dir, "inputs", "ad01_windows_f32.npy"))[ids.index(SAMPLE)]
        x = np.ascontiguousarray(x, dtype=np.float32)
    else:
        x = np.load(path)
    got = hashlib.sha256(np.ascontiguousarray(x).tobytes()).hexdigest()
    if got != INPUT_SHA:
        raise SystemExit("input %s has array sha256 %s, not the E45 manifest's %s" % (path, got, INPUT_SHA))
    return x.astype(np.float32).reshape(1, 640)


def build(a):
    sys.path.insert(0, HERE)
    import e52_deepae_layers as e52
    text = open(os.path.join(ROOT, AARCH64_MLIR), encoding="utf-8").read()
    layers = e52.layer_chain(text)
    if len(layers) != 10:
        raise SystemExit("expected 10 layers, recovered %d" % len(layers))
    os.makedirs(a.work, exist_ok=True)
    _checked_input(a.input)
    import numpy as np
    np.save(os.path.join(a.work, "input.npy"), _checked_input(a.input))
    manifest = []
    for L in layers:
        w = e52._out_width(text, L["output_ssa"])
        ty = "tensor<1x%dxf32>" % w
        t = re.sub(r'func\.func @infer\(%arg0: tensor<1x640xf32>\) -> tensor<1x640xf32>',
                   'func.func @infer(%%arg0: tensor<1x640xf32>) -> %s' % ty, text, count=1)
        t = re.sub(r'return %\d+ : tensor<1x640xf32>', 'return %s : %s' % (L["output_ssa"], ty), t, count=1)
        src = os.path.join(a.work, "layer%d.mlir" % L["index"])
        vmfb = os.path.join(a.work, "layer%d.vmfb" % L["index"])
        open(src, "w", encoding="utf-8").write(t)
        cmd = ["iree-compile", "--iree-hal-target-backends=llvm-cpu",
               "--iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu", "--iree-llvmcpu-target-cpu=cortex-a53",
               src, "-o", vmfb]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode != 0:
            raise SystemExit("layer %d compile failed: %s" % (L["index"], r.stderr[-300:]))
        manifest.append({"index": L["index"], "width": w, "has_relu": L["has_relu"], "vmfb": os.path.basename(vmfb),
                         "vmfb_sha256": hashlib.sha256(open(vmfb, "rb").read()).hexdigest()})
    json.dump({"mlir": AARCH64_MLIR, "layers": manifest,
               "compile_flags": ["--iree-hal-target-backends=llvm-cpu", "--iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu",
                                 "--iree-llvmcpu-target-cpu=cortex-a53"]},
              open(os.path.join(a.work, "build.json"), "w"), indent=1)
    print("built %d diagnostic modules in %s" % (len(manifest), a.work))


def run(a):
    """Guest side: iree.runtime + numpy only.  One process runs all ten modules; each has its own
    context, and only outputs are read (this probe measures values, not memory)."""
    import numpy as np
    import iree.runtime as rt
    b = json.load(open(os.path.join(a.work, "build.json")))
    x = np.load(os.path.join(a.work, "input.npy")).astype(np.float32)
    out = []
    for L in b["layers"]:
        ctx = rt.SystemContext(config=rt.Config("local-sync"))
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(os.path.join(a.work, L["vmfb"]), "rb").read()))
        y = np.array(ctx.modules.module.infer(x), copy=True).reshape(-1)
        out.append({"index": L["index"], "values": [float(v) for v in y]})
        del ctx
    import platform
    json.dump({"machine": platform.machine(), "layers": out}, open(os.path.join(a.work, "guest_outputs.json"), "w"))
    print("ran %d modules on %s" % (len(out), platform.machine()))


def compare(a):
    import numpy as np
    sys.path.insert(0, HERE)
    import e52_deepae_layers as e52
    text = open(os.path.join(ROOT, AARCH64_MLIR), encoding="utf-8").read()
    layers = e52.layer_chain(text)
    consts = e52.deployed_constants(text)
    x32 = _checked_input(a.input, a.inputs)
    gpath = a.guest_outputs or os.path.join(a.work, "guest_outputs.json")
    g = json.load(open(gpath))
    if g.get("machine") != "aarch64":
        raise SystemExit("guest outputs were not produced on aarch64 (machine=%r)" % g.get("machine"))
    tgt = [np.asarray(l["values"], dtype=np.float64) for l in sorted(g["layers"], key=lambda r: r["index"])]
    lit, lit_meta = e52.litert_layers(e52.ORIGINAL_TFLITE, x32)
    seq = e52.sequential_f32_forward(consts, layers, x32)
    f64 = e52.reference_forward(consts, layers, x32.astype(np.float64))
    arch, arch_why = e52.archived_aarch64_output(SAMPLE)
    valid = arch is not None and np.array_equal(tgt[-1].astype(np.float32), arch.astype(np.float32))
    rows = []
    for i, L in enumerate(layers):
        r = {"index": i, "has_relu": L["has_relu"], "width": int(tgt[i].size)}
        r["vs_reference_runtime"] = e52.violations(tgt[i], lit[i]) if lit[i] is not None else {
            "unavailable_reason": "reference runtime intermediate not readable"}
        r["vs_sequential_f32"] = e52.violations(tgt[i], seq[i])
        r["bit_identical_to_sequential_f32"] = bool(np.array_equal(tgt[i].astype(np.float32),
                                                                   np.asarray(seq[i]).astype(np.float32).reshape(-1)))
        r["vs_float64"] = e52.violations(tgt[i], f64[i])
        rows.append(r)
    viol = [r["vs_reference_runtime"].get("violations") for r in rows]
    first = next((r["index"] for r in rows if (r["vs_reference_runtime"].get("violations") or 0) > 0), None)
    bulk = max(range(len(rows)), key=lambda i: viol[i] or 0) if any(v for v in viol if v) else None
    seq_match = [r["bit_identical_to_sequential_f32"] for r in rows]
    # E52's growth ratios with E52's formula, recorded beside the verdict and NOT part of it: the plan
    # (SS3) lets the manuscript use V and L1-L3 only.
    rv = [r["vs_reference_runtime"] for r in rows]
    thr = [max(e52.ABS_TOL, e52.REL_TOL * v.get("median_abs_value", 0.0)) for v in rv]
    supp = {"not_part_of_the_verdict": True,
            "accumulated_error_growth_L0_to_L9": (rv[-1]["worst_abs"] / rv[0]["worst_abs"])
            if rv[0].get("worst_abs") and rv[-1].get("worst_abs") else None,
            "effective_threshold_growth_L0_to_L9": thr[-1] / thr[0]}
    doc = {
        "experiment": "E60", "plan": PLAN, "target": "aarch64 QEMU system guest (iree-base-runtime 3.11.0 wheel)",
        "sample": SAMPLE, "input_sha256": INPUT_SHA, "mlir": AARCH64_MLIR,
        "guest_outputs": {"path": GUEST + "/guest_outputs.json",
                          "sha256": hashlib.sha256(open(gpath, "rb").read()).hexdigest()},
        "tolerance": {"abs": e52.ABS_TOL, "rel": e52.REL_TOL, "rule": "E25, inherited unchanged"},
        "validity": {"chain_final_equals_archived_aarch64_output": bool(valid),
                     "archived_output": "results/e48_real_inputs_aarch64/b3_deepae/native_real.json",
                     "archived_unavailable_reason": arch_why},
        "reference_runtime_intermediates": lit_meta,
        "layers": rows,
        "L1_first_layer_over_tolerance": first,
        "L2_layer_with_most_violations": bulk,
        "L3_bit_identical_to_sequential_f32_per_layer": seq_match,
        "violations_per_layer_vs_reference_runtime": viol,
        "supplementary_growth": supp,
        "not_claimed": ["mechanism (no disassembly; FMA is baseline AArch64, so E52's no-FMA control does not carry over)",
                        "a third reference value (float64 and sequential f32 are auxiliary axes)",
                        "more than the one failing window"],
    }
    os.makedirs(os.path.dirname(os.path.join(ROOT, OUT)), exist_ok=True)
    json.dump(doc, open(os.path.join(ROOT, a.out or OUT), "w"), indent=1)
    print(json.dumps({"valid": doc["validity"]["chain_final_equals_archived_aarch64_output"], "L1": first, "L2": bulk,
                      "violations": viol, "seq_match": seq_match}, indent=1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("step", choices=["build", "run", "compare"])
    ap.add_argument("--input")
    ap.add_argument("--inputs", help="fetch_real_inputs.py deepae directory (E52_INPUTS) instead of --input")
    ap.add_argument("--work")
    ap.add_argument("--guest-outputs", help="default: <work>/guest_outputs.json")
    ap.add_argument("--out")
    a = ap.parse_args()
    {"build": build, "run": run, "compare": compare}[a.step](a)


if __name__ == "__main__":
    main()
