#!/usr/bin/env python3
"""E32: turn the cFS app's raw `/cf/e25_outputs.bin` into the runner JSON that
`harness/e31_compare.py` judges, so the guest's outputs are scored by exactly the
same pre-fixed criteria as every other path -- no second judge, no second rule.

The sample order is not inferred from the file: it is passed in explicitly and
every input array is re-hashed against the E31 fixture manifest first.  If the
order file and the manifest disagree, this refuses rather than emitting a
comparison that would silently score sample i against oracle j.

    python3 harness/e32_cfs_outputs.py --raw e25_outputs.bin --order order.json \
        --vmfb results/e32_smartcam_aarch64/build/smartcam.vmfb \
        --mode batch --out results/e32_smartcam_aarch64/cfs/iree_cfs_aarch64.json
"""
import argparse
import hashlib
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
DEF_FIXTURE = os.path.join(ROOT, "results", "e31_smartcam_equivalence", "fixture")

OUT_ELEMS = 3


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", required=True, help="raw f32 outputs written by the app")
    ap.add_argument("--order", required=True, help="JSON list of {sample_id, kind} in replay order")
    ap.add_argument("--vmfb", required=True)
    ap.add_argument("--fixture", default=DEF_FIXTURE)
    ap.add_argument("--mode", default="batch", choices=["batch", "message_replay"],
                    help="which of the app's two modes produced this file (plan SS3.4: never mixed)")
    ap.add_argument("--runner", default="native/cfs_app AI_LEARNER in cFS on the AArch64 QEMU guest, "
                                        "IREE C runtime (local-sync, embedded ELF loader)")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    from e32_native_aarch64 import load_or_regenerate, sha256_bytes   # noqa: PLC0415

    man = json.load(open(os.path.join(a.fixture, "manifest.json"), encoding="utf-8"))
    order = json.load(open(a.order, encoding="utf-8"))
    by_id = {sid: (kind, arr) for sid, kind, arr in load_or_regenerate(a.fixture, man)}
    for rec in order:
        if rec["sample_id"] not in by_id:
            raise SystemExit("REFUSED: replay order names %r, which is not in the fixture manifest"
                             % rec["sample_id"])
        if by_id[rec["sample_id"]][0] != rec["kind"]:
            raise SystemExit("REFUSED: %s is %r in the manifest but %r in the replay order"
                             % (rec["sample_id"], by_id[rec["sample_id"]][0], rec["kind"]))

    raw = np.fromfile(a.raw, dtype=np.float32)
    n = raw.size // OUT_ELEMS
    if raw.size % OUT_ELEMS or n != len(order):
        raise SystemExit("REFUSED: %s holds %d f32 (%d samples of %d), replay order has %d"
                         % (a.raw, raw.size, n, OUT_ELEMS, len(order)))

    results = []
    for i, rec in enumerate(order):
        kind, arr = by_id[rec["sample_id"]]
        y = raw[i * OUT_ELEMS:(i + 1) * OUT_ELEMS]
        results.append({
            "sample_id": rec["sample_id"], "kind": kind,
            "input_sha256": sha256_bytes(arr.tobytes()),
            "output": [float(v) for v in y],
            "output_shape": [1, OUT_ELEMS], "output_dtype": "float32",
            "argmax": int(np.argmax(y)), "sum": float(np.sum(y)),
        })

    doc = {
        "tool": "harness/e32_cfs_outputs.py",
        "runner": a.runner,
        "mode": a.mode,
        "mode_note": "the app's two modes are never mixed (plan SS3.4): `batch` replays the fixture "
                     "at initialisation; `message_replay` builds features from Software Bus "
                     "telemetry bytes and therefore CANNOT be compared to the original oracle -- "
                     "its inputs are not fixture samples.",
        "artifact": {
            "path": os.path.relpath(os.path.abspath(a.vmfb), ROOT),
            "bytes": os.path.getsize(a.vmfb),
            "sha256": sha256_bytes(open(a.vmfb, "rb").read()),
        },
        "fixture": {"dir": os.path.relpath(os.path.abspath(a.fixture), ROOT),
                    "total_samples": len(results)},
        "results": results,
    }
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"samples": len(results), "mode": a.mode, "out": a.out}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
