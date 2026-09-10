#!/usr/bin/env python3
"""P1 (E30): smoke-execute a vmfb through the pip `iree.runtime` bindings and record
what happened -- entry ABI, output shape/dtype/values for two fixed inputs, and the
HAL allocator statistics after N calls with every result released (D50: holding a
returned buffer inflates the peak).

This is a FEASIBILITY record ("the artifact loads and the entry runs to completion
in this deployment"), not an equivalence judgement (P2) and not an E26 cell: the
pip runtime is one deployment, whose try_map arm E29 showed is decided by the module
image's 64-byte alignment. The HAL numbers are written next to the contract's
per_call/bounded so a reader can see which arm this process took; nothing here
claims soundness beyond this one process.

Usage: p1_smoke_pip_runtime.py MODEL.vmfb --contract MODEL.contract.json --out smoke.json
       [--entry infer] [--iters 10] [--driver local-sync]
"""
import argparse, gc, hashlib, json, sys

import numpy as np


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("vmfb")
    ap.add_argument("--contract", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--entry", default="infer")
    ap.add_argument("--iters", type=int, default=10)
    ap.add_argument("--driver", default="local-sync")
    a = ap.parse_args()
    try:
        import iree.runtime as rt
    except ImportError as e:  # explicit, never a crash (D24)
        print("p1_smoke_pip_runtime: iree.runtime not installed: %s" % e, file=sys.stderr)
        return 2

    c = json.load(open(a.contract))
    iface = c["interface"]
    inp = iface["inputs"][0] if "inputs" in iface else iface["input"]
    shape = [int(d) for d in inp["shape"]]
    assert inp.get("dtype", "f32") == "f32", inp
    mem = c["resources"]["memory"] if "memory" in c["resources"] else c["resources"]

    blob = open(a.vmfb, "rb").read()
    rec = {"tool": "harness/p1_smoke_pip_runtime.py", "vmfb": a.vmfb, "vmfb_bytes": len(blob),
           "vmfb_sha256": hashlib.sha256(blob).hexdigest(),
           "contract_artifact_sha256_matches": hashlib.sha256(blob).hexdigest() == c["artifact"]["sha256"],
           "runner": "pip iree.runtime (python bindings), one model per process", "driver": a.driver,
           "entry": a.entry, "input_shape": shape, "iters": a.iters}
    cfg = rt.Config(a.driver)
    ctx = rt.SystemContext(config=cfg)
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, blob))
    fn = ctx.modules.module[a.entry]
    rec["reflection"] = dict(getattr(fn, "vm_function", fn).reflection) if hasattr(getattr(fn, "vm_function", fn), "reflection") else None

    # Phase 1 -- HAL statistics with every result DISCARDED. Reading a result back to
    # the host through these bindings (np.asarray / to_host / map) keeps its HAL buffer
    # alive for the rest of the process (nanobind keep_alive; measured: 12 B per read
    # still "allocated" after del + gc.collect()), which is D50's observer effect in a
    # new guise. So the peak is read first, from calls whose results are never touched,
    # and only then are outputs read -- and the statistics are re-read afterwards so
    # the held bytes are visible in the record rather than hidden in the peak.
    rng = np.random.default_rng(0)
    inputs = {"zeros": np.zeros(shape, dtype=np.float32),
              "uniform01_seed0": rng.random(shape, dtype=np.float32)}
    x = inputs["uniform01_seed0"]
    for _ in range(a.iters):
        fn(x)                          # result discarded, never mapped to host
    st = {k: int(v) for k, v in dict(cfg.device.allocator.statistics).items()}
    rec["hal_statistics"] = st

    # Phase 2 -- outputs (each read holds 12 B * outputs until process exit; see above).
    def call_copy(x):
        r = fn(x)
        y = np.array(r.to_host() if hasattr(r, "to_host") else r, copy=True)
        del r
        gc.collect()
        return y
    outs = {}
    for name, xx in inputs.items():
        y = call_copy(xx)
        outs[name] = {"input_sha256": hashlib.sha256(xx.tobytes()).hexdigest(),
                      "output_shape": list(y.shape), "output_dtype": str(y.dtype),
                      "output": [float(v) for v in y.reshape(-1)[:16]],
                      "output_elems": int(y.size), "argmax": int(np.argmax(y)),
                      "sum": float(y.sum()), "finite": bool(np.isfinite(y).all())}
    rec["outputs"] = outs
    rec["deterministic_same_input"] = (call_copy(x).tobytes() == call_copy(x).tobytes())
    st2 = {k: int(v) for k, v in dict(cfg.device.allocator.statistics).items()}
    rec["hal_statistics_after_host_reads"] = dict(st2, host_reads=len(inputs) + 2,
        note="every host-side read of a result keeps its HAL buffer allocated in this binding; "
             "this is why phase 1 reads the peak from discarded results (D50)")
    rec["contract"] = {"per_call": mem["static_per_call_bytes"], "bounded": mem["bounded_bytes"],
                       "constants": mem["module_resident_constant_bytes"]}
    peak = st.get("device_bytes_peak")
    rec["observation"] = {
        "device_bytes_peak": peak,
        "peak_le_bounded": peak <= mem["bounded_bytes"],
        "peak_eq_per_call": peak == mem["static_per_call_bytes"],
        "peak_eq_bounded": peak == mem["bounded_bytes"],
        "allocated_eq_freed": st.get("device_bytes_allocated") == st.get("device_bytes_freed"),
        "note": "one deployment (pip iree.runtime); the arm is decided by the module image's "
                "64-byte alignment (E29). Not an E26 cell, not a soundness claim.",
    }
    rec["status"] = "ran"
    with open(a.out, "w") as fh:
        json.dump(rec, fh, indent=1)
    print(json.dumps({k: rec[k] for k in ("input_shape", "deterministic_same_input", "hal_statistics", "observation")}, indent=1))
    print("outputs:", {k: (v["output_shape"], v["argmax"], v["finite"]) for k, v in outs.items()})
    return 0


if __name__ == "__main__":
    sys.exit(main())
