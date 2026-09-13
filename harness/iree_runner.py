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
    # E46: the first model in this repository whose OUTPUT carries a layout. SmartCam and
    # ResNet emit class scores and DeepAE emits a rank-2 reconstruction -- none has an
    # image-shaped output -- so until now "flatten the output and compare" was correct by
    # accident. The WGAN denoiser emits NCHW [1,3,224,224] while its TFLite original emits
    # NHWC [1,224,224,3]: the same numbers in a different order, which the comparator would
    # have reported as a large per-element failure with no hint that the cause was layout.
    # Like E34's --layout on the fixture, this is a VALUE, not a per-model branch.
    ap.add_argument("--output-layout", choices=["none", "nchw_to_nhwc"], default="none",
                    help="how to bring the entry's output back into the oracle's layout before "
                         "recording it; `none` records exactly what the entry returned")
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
        y_entry_shape = list(y.shape)
        if a.output_layout == "nchw_to_nhwc":
            if y.ndim != 4:
                print("iree_runner: --output-layout nchw_to_nhwc needs a rank-4 output, got %s"
                      % (y_entry_shape,), file=sys.stderr)
                return 2
            # transpose, never reshape -- and prove it round-trips, the same guard
            # model_fixture.py applies on the way in
            back = np.ascontiguousarray(y.transpose(0, 2, 3, 1))
            if not np.array_equal(back.transpose(0, 3, 1, 2), y):
                print("iree_runner: NCHW->NHWC transpose does not round-trip; refusing",
                      file=sys.stderr)
                return 2
            y = back
        rows.append({"sample_id": s["sample_id"], "kind": s["kind"],
                     "input_sha256": s["nchw"]["sha256"],
                     "output": [float(v) for v in y.reshape(-1)],
                     "output_shape": list(y.shape), "output_dtype": str(y.dtype),
                     "entry_output_shape": y_entry_shape,
                     "output_layout_applied": a.output_layout,
                     "argmax": int(np.argmax(y)), "sum": float(y.sum())})

    rec = {
        "tool": "harness/iree_runner.py",
        "runner": "pip iree.runtime (python bindings), driver=%s, entry=%s" % (a.driver, a.entry),
        "output_layout": a.output_layout,
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
