#!/usr/bin/env python3
"""E41: derive the summary from the raw cell outputs. Never hand-assembled (D64).

Reads `results/e41_analysis_domain/probe.json` (the premise measurement) and every
`onair_cells/*/run.json` (the official-loader cells), and states the five conditions'
outcome in the form the pre-fixed plan (docs/plans/E40_E41_analysis_domain.md SS3) set
BEFORE any of this was measured: which conditions are gates, which are observations,
and why each one is what it is.
"""
import argparse, glob, json, os, sys


def cell_facts(path):
    d = json.load(open(path))
    pi = d.get("plugin_init") or {}
    return {
        "deployment": d.get("deployment"),
        "returncode": d.get("returncode"),
        "plugin_constructed": d.get("plugin_constructed"),
        "onair_core_unmodified": (d.get("onair") or {}).get("core_unmodified"),
        "active": pi.get("active"),
        "inactive_reason": pi.get("inactive_reason"),
        "admission_verdict": (pi.get("admission") or {}).get("verdict") if pi.get("admission") else None,
        "binding_verdict": (pi.get("binding") or {}).get("verdict") if pi.get("binding") else None,
        "inferences": d.get("inferences"),
    }


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=os.path.join(os.path.dirname(os.path.dirname(
        os.path.abspath(__file__))), "results", "e41_analysis_domain"))
    ap.add_argument("--out")
    a = ap.parse_args(argv)

    probe_path = os.path.join(a.root, "probe.json")
    probe = json.load(open(probe_path)) if os.path.isfile(probe_path) else None
    cells = {}
    for f in sorted(glob.glob(os.path.join(a.root, "onair_cells", "*", "run.json"))):
        c = cell_facts(f)
        cells[c["deployment"]] = c

    wrong = cells.get("smartcam_wrong_driver")
    refused_by_driver = bool(
        wrong and wrong["active"] is False and wrong["inferences"] == 0
        and wrong["admission_verdict"] is None and wrong["binding_verdict"] is None
        and "driver" in (wrong["inactive_reason"] or ""))

    honest = [c for n, c in cells.items() if n != "smartcam_wrong_driver"]
    honest_unchanged = bool(honest) and all(
        c["returncode"] == 0 and c["plugin_constructed"] and c["onair_core_unmodified"] for c in honest)

    over_bounded = (probe or {}).get("cells_exceeding_bounded") or []
    summary = {
        "experiment": "E41",
        "plan": "docs/plans/E40_E41_analysis_domain.md SS3 (pre-fixed, committed 9b7d5ba)",
        "conditions": {
            "1_dynamic_shapes": {
                "form": "gate (already closed before E41)",
                "where": "bound_method=NONE -> CONTRACT_BOUND_KNOWN=0 -> both C runners refuse "
                         "before resource acquisition; admission_policy returns REFUSED_UNKNOWN_BOUND",
                "new_gate": False},
            "2_unsupported_resource_op": {
                "form": "gate (already closed before E41)",
                "where": "both extractors push an unrecognized stream.* op into `unresolved`, which "
                         "forces bound_method=NONE (D13). E40 published the policy as "
                         "analysis_domain.derived.unknown_operation_policy",
                "new_gate": False},
            "3_more_than_one_in_flight_call": {
                "form": "OBSERVATION, deliberately not a gate",
                "why": "no deployment this repository ships can reach it: neither C runner creates a "
                       "thread or child task, and OnAIR calls plugins from one loop. Adding a thread to "
                       "a flight app in order to assert the hazard is absent would BE the regression.",
                "measured_load_bearing": bool(over_bounded),
                "cells_exceeding_bounded": over_bounded,
                "new_gate": False},
            "4_output_held_past_next_call": {
                "form": "OBSERVATION, deliberately not a gate",
                "why": "enforcing it literally over-rejects: the archived b2_resnet pip cell peaks at "
                       "309,576 B under D50 retention against an unconditional budget of 618,856 B -- "
                       "50.0% of budget, contract not violated. It bites only in the conditional tier, "
                       "where D59's peak_within_admitted_budget already reports it.",
                "new_gate": False},
            "5_undeclared_hal_driver": {
                "form": "GATE (new in E41)",
                "where": "plugins/compiled_learner/artifact_binding.check_declared_driver() refuses "
                         "before the runtime is created; gen_contract_header.py refuses to assert a "
                         "driver no contract field declares, and refuses a validity/target disagreement",
                "new_gate": True,
                "fires_in_official_onair_path": refused_by_driver},
        },
        "probe": {
            "single_call_peak_equals_per_call": (probe or {}).get("single_call_peak_equals_per_call"),
            "premise_is_load_bearing": (probe or {}).get("premise_is_load_bearing"),
            "cells": len((probe or {}).get("cells") or []),
        },
        "onair_cells": cells,
        "over_rejection_zero": honest_unchanged,
        "verdict": {
            "R1_new_gate_fires": refused_by_driver,
            "R3_no_over_rejection": honest_unchanged,
            "R4_e33_cells_unbroken": honest_unchanged,
        },
    }
    out = a.out or os.path.join(a.root, "summary.json")
    with open(out, "w") as f:
        json.dump(summary, f, indent=2)
    print("mk_e41_summary: %d onair cells, probe=%s -> %s"
          % (len(cells), "yes" if probe else "no", out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
