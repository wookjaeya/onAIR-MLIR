#!/usr/bin/env python3
"""E33: turn the official OnAIR run's per-inference records into the runner JSON that
`harness/e31_compare.py` judges.

The official framework has no return path for a full output vector -- `render_reasoning()`
hands the agent a summary -- so the plugin appends one JSON line per inference to the
record file named by the deployment config. This converter reads those lines and
nothing else, so the numbers judged are the ones the OnAIR run actually produced.

Records marked `stale` are not written by the plugin at all (it repeats the previous
answer without inferring), but this converter still refuses on a duplicate sample id:
scoring the same sample twice would inflate a subset comparison into looking complete.

    python3 harness/e33_onair_outputs.py \
        --records results/e33_onair_official/p_admit/plugin_records.jsonl \
        --vmfb results/p1_smartcam_feasibility/build/smartcam.vmfb \
        --out results/e33_onair_official/p_admit/iree_onair.json
"""
import argparse
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
DEF_FIXTURE = os.path.join(ROOT, "results", "e31_smartcam_equivalence", "fixture")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--records", required=True)
    ap.add_argument("--vmfb", required=True)
    ap.add_argument("--fixture", default=DEF_FIXTURE)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    from e32_native_aarch64 import load_or_regenerate, sha256_bytes    # noqa: PLC0415

    man = json.load(open(os.path.join(a.fixture, "manifest.json"), encoding="utf-8"))
    by = {sid: (kind, arr) for sid, kind, arr in load_or_regenerate(a.fixture, man)}

    inferences, init = [], None
    with open(a.records, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            r = json.loads(line)
            if r.get("event") == "inference":
                inferences.append(r)
            elif r.get("event") == "init":
                init = r

    seen, results = set(), []
    for r in inferences:
        sid = r.get("sample_id")
        if sid not in by:
            raise SystemExit("REFUSED: record names sample %r, absent from the fixture manifest" % sid)
        if sid in seen:
            raise SystemExit("REFUSED: sample %r was inferred twice; a repeated sample must not be "
                             "scored twice (the plugin marks stale calls instead)" % sid)
        seen.add(sid)
        kind, arr = by[sid]
        y = np.asarray(r["output"], dtype=np.float32)
        results.append({
            "sample_id": sid, "kind": kind,
            "input_sha256": sha256_bytes(arr.tobytes()),
            "output": [float(v) for v in y],
            "output_shape": [1, int(y.size)], "output_dtype": "float32",
            "argmax": int(np.argmax(y)), "sum": float(np.sum(y)),
        })

    doc = {
        "tool": "harness/e33_onair_outputs.py",
        "runner": "NASA OnAIR driver.py -> onair/src/util/plugin_import.import_plugins -> "
                  "plugins/compiled_learner Plugin, pip iree.runtime (local-sync), x86-64 host",
        "official_path_note": "these outputs came out of the official loader, not a direct "
                              "iree.runtime call -- the distinction v0.22.1 had to correct for E25",
        "mode": (init or {}).get("input_mode"),
        "admission": (init or {}).get("admission"),
        "binding": (init or {}).get("binding"),
        "artifact": {"path": os.path.relpath(os.path.abspath(a.vmfb), ROOT),
                     "bytes": os.path.getsize(a.vmfb),
                     "sha256": sha256_bytes(open(a.vmfb, "rb").read())},
        "fixture": {"dir": os.path.relpath(os.path.abspath(a.fixture), ROOT),
                    "total_samples": len(results)},
        "results": results,
    }
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"samples": len(results), "out": a.out}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
