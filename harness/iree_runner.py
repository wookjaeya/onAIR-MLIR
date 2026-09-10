#!/usr/bin/env python3
"""E31 / P2: run the IMPORTED model (vmfb) on the same fixture and record its full output.

Companion to harness/tflite_oracle.py: same samples, same preprocessing, but the NCHW tensor
and the vmfb E30 compiled in one iree-compile invocation. No recompilation happens here.

Every output element is recorded (SS9.3: argmax agreement is not equivalence). Results are
copied to the host and released each call, following D50's discipline -- and because the
E30 smoke measured that a host-side read pins that buffer, this runner does NOT report a HAL
peak: measuring memory is not this experiment's question and mixing the two would misreport it.

Usage:
  iree_runner.py MODEL.vmfb --fixture <fixture-dir> --out iree.json [--entry infer] [--driver local-sync]
"""
import argparse, hashlib, json, os, sys

import numpy as np


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("vmfb")
    ap.add_argument("--fixture", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--entry", default="infer")
    ap.add_argument("--driver", default="local-sync")
    a = ap.parse_args()
    try:
        import iree.runtime as rt
    except ImportError as e:          # a decision, not a crash (D24/D25)
        print("iree_runner: iree.runtime not installed: %s" % e, file=sys.stderr)
        return 2

    blob = open(a.vmfb, "rb").read()
    manifest = json.load(open(os.path.join(a.fixture, "manifest.json")))
    cfg = rt.Config(a.driver)
    ctx = rt.SystemContext(config=cfg)
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, blob))
    fn = ctx.modules.module[a.entry]

    rows = []
    for s in manifest["samples"]:
        x = np.load(os.path.join(a.fixture, s["nchw"]["file"]))
        r = fn(x)
        y = np.array(r.to_host() if hasattr(r, "to_host") else r, copy=True)
        del r
        rows.append({"sample_id": s["sample_id"], "kind": s["kind"],
                     "input_sha256": s["nchw"]["sha256"],
                     "output": [float(v) for v in y.reshape(-1)],
                     "output_shape": list(y.shape), "output_dtype": str(y.dtype),
                     "argmax": int(np.argmax(y)), "sum": float(y.sum())})

    rec = {
        "tool": "harness/iree_runner.py",
        "runner": "pip iree.runtime (python bindings), driver=%s, entry=%s" % (a.driver, a.entry),
        "artifact": {"path": a.vmfb, "bytes": len(blob), "sha256": hashlib.sha256(blob).hexdigest()},
        "fixture": {"dir": a.fixture, "total_samples": manifest["total_samples"]},
        "memory_note": "this runner deliberately reports no HAL peak: reading outputs back to the host "
                       "pins their buffers in this binding (D50/E30), and memory is not this experiment's "
                       "question. E26/E29 are where allocation is measured.",
        "results": rows,
    }
    with open(a.out, "w") as fh:
        json.dump(rec, fh, indent=1)
    print(json.dumps({"artifact_sha256": rec["artifact"]["sha256"][:16], "samples": len(rows)}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
