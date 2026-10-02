#!/usr/bin/env python3
"""E54: fold the reference-budget admission cells into one verdict document.

Every per-cell number is read back out of what the app itself recorded in the guest log; the
reader is IMPORTED from `mk_e36b_summary` rather than copied, so two summaries reading the
same raw material cannot drift into two implementations of "what the log said" (E48 SS4-4).

Budgets are quoted from the committed `budgets.json`, never recomputed here -- recomputing
would put the same fact in a second place that nothing cross-checks (D65/E44), and would
also let a later edit silently change what the cells were judged against.

Part 1 (reference profiles) and Part 2 (power-of-two sensitivity sweep) are kept in separate
blocks with separate verdicts.  The directive forbids presenting them as one deployment case,
so this generator cannot emit a combined table even by accident.
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from mk_e36b_summary import cfs_cell  # noqa: E402

E54 = os.path.join(ROOT, "results", "e54_reference_budget")


def _json(p):
    with open(p, encoding="utf-8") as fh:
        return json.load(fh)


def collect(parts):
    """parts: list of (scenarios_file, cells_dir).  Returns cell records keyed by cell id."""
    out = {}
    for scen_file, cells_dir in parts:
        scen = _json(os.path.join(E54, scen_file))
        logdir = os.path.join(E54, "cells", cells_dir, "logs")
        for s in scen:
            log = os.path.join(logdir, s["id"] + ".log")
            rec = cfs_cell(log)
            rec.update({
                "cell_id": s["id"], "part": s["part"], "model": s["model"],
                "budget_requested_bytes": int(s["env"]["AI_LEARNER_BUDGET_OVERRIDE"]),
                "expect": s["expect"], "window_seconds": s["seconds"],
            })
            out[s["id"]] = rec
    return out


def judge(rec, u_bytes):
    """Plan SS4, fixed before measurement.

    A cell passes only if the verdict matches what U vs the ADMITTED budget implies, the
    inference count matches (>=1 admitted / exactly 0 refused), the app actually reports the
    budget it was given (not a silent fall back to the compile-time macro -- E36/D61), and an
    admitted cell's HAL peak stays within THE BUDGET IT WAS ADMITTED ON, not within `bounded`
    (D53/D59: the number you approved on and the number you verify against must be the same).
    Runtime creation is witnessed by the `mem` record, never by `stack` (D80).
    """
    fails = []
    want_admit = u_bytes <= rec["budget_requested_bytes"]
    want = "ADMIT" if want_admit else "NOT_ADMITTED"
    if rec.get("verdict") != want:
        fails.append(f"verdict {rec.get('verdict')} != {want}")
    if rec.get("budget_source") != "override":
        fails.append(f"budget_source {rec.get('budget_source')!r} != 'override' "
                     f"(a silent fall back to the macro would make the budget unknowable)")
    if rec.get("budget_bytes") != rec["budget_requested_bytes"]:
        fails.append(f"app recorded budget {rec.get('budget_bytes')} != requested "
                     f"{rec['budget_requested_bytes']}")
    n = rec.get("inferences") or 0
    if want_admit:
        if n < 1:
            fails.append(f"admitted cell ran {n} inferences, needs >= 1")
        if rec.get("hal_peak") is None:
            fails.append("admitted cell has no mem record (runtime creation unwitnessed)")
        else:
            ab = rec.get("admitted_budget_bytes")
            if ab != rec["budget_requested_bytes"]:
                fails.append(f"admitted_budget_bytes {ab} != the budget it was admitted on "
                             f"{rec['budget_requested_bytes']}")
            if rec["hal_peak"] > rec["budget_requested_bytes"]:
                fails.append(f"HAL peak {rec['hal_peak']} > admitted budget "
                             f"{rec['budget_requested_bytes']}")
            if rec.get("peak_within_admitted_budget") is not True:
                fails.append(f"peak_within_admitted_budget={rec.get('peak_within_admitted_budget')}")
    else:
        if n != 0:
            fails.append(f"refused cell ran {n} inferences, must be 0")
        if rec.get("hal_peak") is not None:
            fails.append("refused cell HAS a mem record -- the runtime was created despite refusal")
        alive = rec.get("cfs_alive_after_refusal") or {}
        if not alive.get("exit_app_logged"):
            fails.append("refused cell did not log CFE_ES_ExitApp")
    rec["fails"] = fails
    rec["pass"] = not fails
    return rec


def main():
    b = _json(os.path.join(E54, "budgets.json"))
    u = {m: v["U_bounded_bytes"] for m, v in b["models"].items()}
    by_cell = {c["cell_id"]: c for c in b["cells"]}

    recs = collect([
        ("scenarios_cfs_e48_part1.json", "cfs_e48_part1"),
        ("scenarios_e53_wgan_part1.json", "e53_wgan_part1"),
        ("scenarios_cfs_e48_part2.json", "cfs_e48_part2"),
        ("scenarios_e53_wgan_part2.json", "e53_wgan_part2"),
    ])
    for cid, r in recs.items():
        judge(r, u[r["model"]])
        if cid in by_cell:
            r["predicted_verdict"] = by_cell[cid]["predicted_verdict"]
            r["B_contract_bytes"] = by_cell[cid]["B_contract_bytes"]
            r["headroom_bytes"] = by_cell[cid]["headroom_bytes"]
            r["prediction_held"] = (r.get("verdict") == r["predicted_verdict"])

    p1 = [r for r in recs.values() if r["part"] == "part1_reference_profile"]
    p2 = [r for r in recs.values() if r["part"] == "part2_sensitivity_sweep"]
    ran = lambda rows: [r for r in rows if r.get("verdict") is not None or r.get("error") is None]

    def block(rows, name):
        done = [r for r in rows if not r.get("error")]
        return {
            "name": name,
            "cells_defined": len(rows),
            "cells_run": len(done),
            "cells_not_run": sorted(r["cell_id"] for r in rows if r.get("error")),
            "pass": sum(1 for r in done if r["pass"]),
            "fail": sorted(r["cell_id"] for r in done if not r["pass"]),
            "verdicts": {v: sum(1 for r in done if r.get("verdict") == v)
                         for v in sorted({r.get("verdict") for r in done} - {None})},
            "cells": sorted(done, key=lambda r: r["cell_id"]),
        }

    out = {
        "experiment": "E54",
        "plan": "docs/plans/E54_reference_budget_admission.md",
        "directive": "docs/reviews/BUDGET_BASED_ADMISSION_ANALYSIS.md",
        "budgets_committed_before_cells": "results/e54_reference_budget/budgets.json",
        "part1": block(p1, "reference budget profiles (the experiment's main evidence)"),
        "part2": block(p2, "power-of-two sensitivity sweep -- NOT a mission budget"),
        "separation_note": "Part 1 and Part 2 are reported separately and must never be merged "
                           "into one deployment case (directive SS9).",
        "prediction_check": {
            "note": "budgets.json predicted each Part 1 verdict BEFORE the cell ran; this "
                    "compares the prediction with what the guest actually did.",
            "checked": sum(1 for r in p1 if "prediction_held" in r),
            "held": sum(1 for r in p1 if r.get("prediction_held")),
            "broke": sorted(r["cell_id"] for r in p1 if "prediction_held" in r
                            and not r["prediction_held"]),
        },
    }
    dest = os.path.join(E54, "summary.json")
    with open(dest, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"wrote results/e54_reference_budget/summary.json")
    for part in ("part1", "part2"):
        bl = out[part]
        print(f"  {part}: {bl['cells_run']}/{bl['cells_defined']} run, "
              f"pass {bl['pass']}, fail {bl['fail']}, verdicts {bl['verdicts']}")
        if bl["cells_not_run"]:
            print(f"    not run: {bl['cells_not_run']}")
    pc = out["prediction_check"]
    print(f"  prediction: {pc['held']}/{pc['checked']} held, broke {pc['broke']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
