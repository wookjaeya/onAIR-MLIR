#!/usr/bin/env python3
"""E45: derive the summary from the raw cells. Never hand-assembled (D64).

D64 was a hand-written summary that dropped a field nobody noticed until another tool
re-derived it. Everything printed here is read out of results/e45_real_inputs/**, and a
cell this tool cannot read is reported as unreadable with its path -- not omitted, and
not defaulted to a passing value (D25/D29/D68).
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(ROOT, "results", "e45_real_inputs")

# (label, cell dir, the archived SYNTHETIC cell it is compared against)
CELLS = [
    ("b2_resnet", "cells/b2_resnet", "results/e34_two_models/b2_resnet"),
    ("b3_deepae", "cells/b3_deepae", "results/e34_two_models/b3_deepae"),
    ("smartcam", "cells/smartcam", "results/e31_smartcam_equivalence"),
]


def load(p):
    try:
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError) as e:
        return {"__unreadable__": "%s: %s" % (type(e).__name__, e), "__path__": p}


def unreadable(d):
    return isinstance(d, dict) and "__unreadable__" in d


def cell_view(path):
    """What one comparison says. Absent fields stay absent; they never become zero."""
    c = load(path)
    if unreadable(c):
        return {"readable": False, "path": path, "reason": c["__unreadable__"]}
    t = c.get("totals", {})
    return {
        "readable": True, "path": os.path.relpath(path, ROOT),
        "verdict": c.get("verdict"),
        "samples": t.get("samples"), "elements": t.get("elements"),
        "elements_failed": t.get("elements_failed"),
        "argmax_failed": t.get("argmax_failed"),
        "by_kind": t.get("by_kind"),
        "per_kind": c.get("per_kind"),
        "worst_element": c.get("worst_element"),
        "argmax_mode": (c.get("criteria") or {}).get("argmax_mode"),
        "abs_tol": (c.get("criteria") or {}).get("abs_tol"),
        "rel_tol": (c.get("criteria") or {}).get("rel_tol"),
    }


def main():
    out = {
        "experiment": "E45",
        "title": "Real evaluation inputs for the three models (G1 only)",
        "plan": "docs/plans/E45_real_inputs.md (committed before measurement, c27b8b2)",
        "goal": "G1 -- run the existing semantic-equivalence comparison on REAL inputs in each "
                "model's actual value domain. G2 (accuracy) is explicitly out of scope for all "
                "three models; the per-model reasons are in each acquisition manifest.",
        "criteria": "inherited UNCHANGED from E25 (abs_err <= 1e-4 OR rel_err <= 1e-5 per "
                    "element). A FAIL on real inputs is reported as a FAIL; the criterion is "
                    "not adjusted to produce a pass.",
        "recompilations": 0,
        "new_model_harnesses": 0,
        "cells": {}, "acquisition": {}, "negative_control": {},
    }

    for name, rel, synth in CELLS:
        real = cell_view(os.path.join(D, rel, "comparison.json"))
        prev = cell_view(os.path.join(ROOT, synth, "comparison.json"))
        nc_real = cell_view(os.path.join(D, rel, "negative_control_reshape.comparison.json"))
        nc_prev = cell_view(os.path.join(ROOT, synth, "negative_control_reshape.comparison.json"))
        out["cells"][name] = {"real_inputs": real, "archived_prior_cell": prev}
        out["negative_control"][name] = {"real_inputs": nc_real, "archived_prior_cell": nc_prev}

    for name, sub in (("b2_resnet", "b2_resnet"), ("b3_deepae", "b3_deepae"),
                      ("smartcam", "smartcam")):
        m = load(os.path.join(D, sub, "manifest.json"))
        if unreadable(m):
            out["acquisition"][name] = {"readable": False, "reason": m["__unreadable__"]}
            continue
        out["acquisition"][name] = {
            "readable": True,
            "goal": m.get("goal"),
            "bytes_vendored_in_tree": m.get("bytes_vendored_in_tree", True),
            "value_domain": m.get("value_domain"),
            "licence": m.get("licence") or m.get("why_not_vendored") or m.get("esa_credit"),
            "counts": m.get("counts") or m.get("subset") or m.get("selection_rule"),
        }

    # The question the negative control exists to answer, stated as numbers rather than prose:
    # does a layout defect get caught by argmax, and does that depend on input realism?
    rows = []
    for name in out["negative_control"]:
        for which in ("real_inputs", "archived_prior_cell"):
            v = out["negative_control"][name][which]
            if not v.get("readable") or v.get("argmax_failed") is None or not v.get("samples"):
                rows.append({"cell": name, "inputs": which, "argmax_detection": None,
                             "reason": "not readable or argmax not applicable to this model"})
                continue
            rows.append({"cell": name, "inputs": which, "samples": v["samples"],
                         "argmax_failed": v["argmax_failed"],
                         "argmax_detection": v["argmax_failed"] / float(v["samples"]),
                         "by_kind": v.get("by_kind")})
    out["negative_control_detection"] = rows

    p = os.path.join(D, "summary.json")
    with open(p, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1, ensure_ascii=False)
        f.write("\n")
    print(p)
    for name, c in out["cells"].items():
        r = c["real_inputs"]
        print("  %-10s REAL %-4s  %s samples / %s elements / %s failed"
              % (name, r.get("verdict"), r.get("samples"), r.get("elements"),
                 r.get("elements_failed")))
    for row in rows:
        if row.get("argmax_detection") is not None:
            print("  negctl %-10s %-20s argmax caught %d/%d" %
                  (row["cell"], row["inputs"], row["argmax_failed"], row["samples"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
