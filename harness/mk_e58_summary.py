#!/usr/bin/env python3
"""E58 summary: the constant-loading arm's determinant, measured in the flight application on
the evaluation target at all eight 8-byte alignment classes.

Plan: docs/plans/E58_alignment_sweep_aarch64.md (committed before measurement, 4d10203).
Every value is read back out of the guest raw logs (the app's own records); the stages()
reader is E56's, imported rather than copied (E44).  The criteria V, D1, D2 are the plan's
SS3 verbatim, and a cell that fails V is INVALID -- it is counted as neither arm (D29/D51).

The sweep replaces, as the manuscript's determinant evidence, the x86-64 E29 probe
(results/e29_conditional_contract/align_sweep.json), which the standing directive excludes.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from mk_e56_summary import MODELS, stages                         # noqa: E402

ROOT = os.path.join(REPO, "results", "e58_alignment_sweep_aarch64")
OFFSETS = (0, 8, 16, 24, 32, 40, 48, 56)


def cell(model, off):
    rel = os.path.join("results", "e58_alignment_sweep_aarch64", "cells", "logs",
                       "e58_%s_off%02d.log" % (model, off))
    path = os.path.join(REPO, rel)
    if not os.path.isfile(path):
        return {"model": model, "offset": off, "log": rel, "present": False,
                "valid": False, "invalid_reason": "cell log not archived"}
    by, peaks, _txt = stages(path)
    al = (by.get("blob_align") or [{}])[0]
    ad = (by.get("admission") or [{}])[0]
    bd = (by.get("binding") or [{}])[0]
    mb = (by.get("map_branch") or [None])[0]
    bc = (by.get("build_config") or [{}])[0]
    v = MODELS[model]
    why = []
    if al.get("state") != "applied":
        why.append("blob_align.state=%r" % al.get("state"))
    if al.get("module_ptr_mod64") != off:
        why.append("module_ptr_mod64=%r != requested %d" % (al.get("module_ptr_mod64"), off))
    if ad.get("verdict") != "ADMIT":
        why.append("admission=%r" % ad.get("verdict"))
    if bd.get("verdict") != "MATCH":
        why.append("binding=%r" % bd.get("verdict"))
    if mb is None:
        why.append("no map_branch record")
    if bc.get("allow_conditional_map") != 0:
        why.append("build is not unconditional (allow_conditional_map=%r)" % bc.get("allow_conditional_map"))
    append = mb.get("hal_peak_after_append") if mb else None
    return {
        "model": model, "offset": off, "log": rel, "present": True,
        "valid": not why, "invalid_reason": "; ".join(why) or None,
        "blob_align": {k: al.get(k) for k in ("requested_offset", "state", "module_ptr_mod64")},
        "admission": {k: ad.get(k) for k in ("verdict", "budget", "budget_source", "target")},
        "binding": bd.get("verdict"),
        "arm_label": mb.get("arm") if mb else None,
        "hal_peak_after_append": append,
        "C": v["C"], "P": v["P"], "B_u": v["B_u"],
        "append_is_0": append == 0, "append_is_C": append == v["C"],
        "third_value": append is not None and append not in (0, v["C"]),
        # recorded beside the verdict, never used for it: the sweep judges the append point only
        "final_hal_peak_observed": peaks[-1] if peaks else None,
        "mem_init_hal_peak": (by.get("mem_init") or [{}])[0].get("hal_peak"),
    }


def main():
    import argparse                                                # noqa: PLC0415
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", help="write here instead of the committed summary (guards re-derive into a temp dir)")
    a = ap.parse_args()
    cells = [cell(m, o) for m in MODELS for o in OFFSETS]
    valid = [c for c in cells if c["valid"]]
    d1 = all(not c["third_value"] for c in valid)
    d2 = all((c["hal_peak_after_append"] == 0) == (c["blob_align"]["module_ptr_mod64"] == 0) for c in valid)
    per_model = {}
    for m in MODELS:
        mine = [c for c in cells if c["model"] == m]
        per_model[m] = {
            "cells": len(mine), "valid": sum(c["valid"] for c in mine),
            "map_at": [c["offset"] for c in mine if c["valid"] and c["append_is_0"]],
            "copy_at": [c["offset"] for c in mine if c["valid"] and c["append_is_C"]],
            "third_values": [(c["offset"], c["hal_peak_after_append"]) for c in mine if c.get("third_value")],
        }
    doc = {
        "experiment": "E58",
        "plan": "docs/plans/E58_alignment_sweep_aarch64.md (committed before measurement, 4d10203)",
        "generated_by": "harness/mk_e58_summary.py",
        "target": "aarch64-unknown-linux-gnu, cFS AI_LEARNER in a QEMU system guest",
        "binary_note": "one E55b unconditional build per model (commit 3e746a8 source); all eight cells of a "
                       "model ran that same binary, so alignment is the only setting varied within a model",
        "replaces": "results/e29_conditional_contract/align_sweep.json (x86-64 development-host probe) as the "
                    "manuscript's determinant evidence; kept on disk, no longer cited",
        "criteria": {
            "V": "blob_align applied with module_ptr_mod64 == requested offset, ADMIT, MATCH, map_branch present, "
                 "unconditional build",
            "D1": "every valid cell: hal_peak_after_append in {0, C}",
            "D2": "every valid cell: hal_peak_after_append == 0 <=> module_ptr_mod64 == 0",
        },
        "cells": cells,
        "per_model": per_model,
        "totals": {"cells": len(cells), "valid": len(valid),
                   "map": sum(1 for c in valid if c["append_is_0"]),
                   "copy": sum(1 for c in valid if c["append_is_C"]),
                   "third_value": sum(1 for c in valid if c["third_value"])},
        "verdict": {"V_all_valid": len(valid) == len(cells) == 32, "D1": d1, "D2": d2,
                    "PASS": len(valid) == len(cells) == 32 and d1 and d2},
        "not_claimed": [
            "that alignment is the sole determinant under other drivers or IREE releases",
            "final execution peaks or output equivalence (the sweep judges the append point; the final "
            "peaks P / B_u are E55b's and the archived map-arm cells')",
            "behaviour at offsets that are not 8-byte multiples (the knob refuses them)",
            "that a deployment takes the copy arm: the app aligns its own image, so it is structurally on "
            "the map arm; this sweep controls the alignment on purpose",
        ],
    }
    out = a.out or os.path.join(ROOT, "summary.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"totals": doc["totals"], "verdict": doc["verdict"]}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
