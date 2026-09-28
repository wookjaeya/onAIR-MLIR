#!/usr/bin/env python3
"""E66 summary: the OnAIR plugin's document rules and budget check, on the evaluation target.

Plan: docs/plans/E66_plugin_document_rules.md (committed before any implementation or cell, ae115f3).
Q1, Q2 and Q5 come from results/e66_plugin_document_rules/ground.json (harness/e66_plugin_document_rules.py
ground); Q3 and Q4 are re-read from what the guest wrote for each cell -- the plugin's own
plugin_records.jsonl and onair_integration_check.py's run.json -- never from a runner's summary (D89).
The comparison sides are ARCHIVED records: the E62 fix-arm cells (same artifact, fixture, telemetry,
readback, budget; only the document differs) and the cFS boundary cells (E48 real-input, E53 WGAN).
Q6 and Q7 are records for the manuscript and carry no verdict.
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import mk_e36_summary as m36                                       # noqa: E402
import mk_e62_summary as m62                                       # noqa: E402  (load_cell, series, outputs)

ROOT = os.path.join(REPO, "results", "e66_plugin_document_rules")
E62_CELLS = os.path.join(REPO, "results", "e62_onair_output_release", "cells")
PLAN = "docs/plans/E66_plugin_document_rules.md"
PLAN_COMMIT = "ae115f3"
MODELS = ("b2_resnet", "b3_deepae", "smartcam", "wgan")
P = m62.P
C = {"b2_resnet": 309440, "b3_deepae": 1063424, "smartcam": 8840704, "wgan": 4283648}
CFS = {m: ("results/e48_real_inputs_aarch64/cfs/logs/%s_deny_Bm1_real.log" % m,
           "results/e48_real_inputs_aarch64/cfs/logs/%s_admit_B_real.log" % m) for m in ("b2_resnet", "b3_deepae", "smartcam")}
CFS["wgan"] = ("results/e53_wgan_aarch64/cfs/logs/cfs_Bm1.log", "results/e53_wgan_aarch64/cfs/logs/cfs_B.log")
PLUGIN_TO_CFS = {"NOT_ADMITTED": "NOT_ADMITTED", "ADMIT": "ADMIT"}


def cfs_verdict(rel):
    st = m36.stages(os.path.join(REPO, rel))
    return ((st.get("admission") or [{}])[0]).get("verdict")


def cell(dep, cells_root):
    c = m62.load_cell(cells_root, dep)
    if c is None:
        return {"deployment": dep, "present": False}
    i = c["init"]
    peaks = [p for p, _ in m62.series(c)]
    return {"deployment": dep, "present": True,
            "active": i.get("active"), "runtime_created": i.get("runtime_created"),
            "admission_verdict": (i.get("admission") or {}).get("verdict"),
            "admitted_budget_bytes": (i.get("admission") or {}).get("admitted_budget_bytes"),
            "document_acceptance": i.get("document_acceptance"),
            "inactive_reason": (i.get("inactive_reason") or "")[:240] or None,
            "inferences": len(c["inferences"]), "peaks": peaks,
            "hal_after_append": i.get("hal_after_append"),
            "onair_returncode": c["run"].get("returncode"),
            "onair_core_unmodified": (c["run"].get("onair") or {}).get("core_unmodified"),
            "_outputs": m62.outputs(c)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", help="write here instead of the committed summary (guards re-derive into a temp dir)")
    ap.add_argument("--root", default=ROOT)
    a = ap.parse_args()
    cells_root = os.path.join(a.root, "guest", "cells")
    ground = json.load(open(os.path.join(a.root, "ground.json"), encoding="utf-8"))
    s = {"experiment": "E66", "plan": PLAN, "plan_commit": PLAN_COMMIT, "generated_by": "harness/mk_e66_summary.py",
         "target": "AArch64 QEMU system guest; the IREE Python runtime of E57/E62/E65 (same wheel)",
         "Q1_parity": {k: ground["Q1_parity"][k] for k in ("n", "disagreements", "accepted", "bound_method_sets_equal",
                                                           "pass")},
         "Q2_budget": {"pass": ground["Q2_budget"]["pass"],
                       "committed_deployments_checked": ground["Q2_budget"]["committed_deployments_checked"],
                       "committed_deployments_mismatched": ground["Q2_budget"]["committed_deployments_mismatched"],
                       "committed_documents_not_as_expected": ground["Q2_budget"]["committed_documents_not_as_expected"]},
         "Q5_corpus": {k: ground["Q5_corpus"][k] for k in ("representation", "unclassified_resource_ops",
                                                           "total_representations", "total_unclassified", "pass")}}
    # ---- Q3: the re-issued documents, 8 cells ----------------------------------------------------
    q3 = {}
    ok3 = True
    for m in MODELS:
        lo, hi = cell("e66_%s_Bum1" % m, cells_root), cell("e66_%s_Bu" % m, cells_root)
        ref = m62.load_cell(E62_CELLS, "e62_%s_Bu_fix" % m)
        ref_out = m62.outputs(ref) if ref else None
        cfs_lo, cfs_hi = cfs_verdict(CFS[m][0]), cfs_verdict(CFS[m][1])
        lo_ok = (lo.get("present") and lo["admission_verdict"] == "NOT_ADMITTED" and lo["runtime_created"] is False
                 and lo["inferences"] == 0 and lo["document_acceptance"] == {"verdict": "accepted", "waived": []})
        hi_ok = (hi.get("present") and hi["admission_verdict"] == "ADMIT" and hi["runtime_created"] is True
                 and hi["document_acceptance"] == {"verdict": "accepted", "waived": []}
                 and ref is not None and hi["inferences"] == len(ref["inferences"]) > 0
                 and all(p == P[m] for p in hi["peaks"]) and len(hi["peaks"]) == hi["inferences"]
                 and hi["_outputs"] == ref_out)
        agree = PLUGIN_TO_CFS.get(lo.get("admission_verdict")) == cfs_lo and PLUGIN_TO_CFS.get(hi.get("admission_verdict")) == cfs_hi
        q3[m] = {"B_u_minus_1": {k: v for k, v in lo.items() if not k.startswith("_")},
                 "B_u": {k: (v if k != "peaks" else {"n": len(v), "all_equal_P": all(p == P[m] for p in v),
                                                      "distinct": sorted(set(v))})
                         for k, v in hi.items() if not k.startswith("_")},
                 "e62_fix_cell_inferences": len(ref["inferences"]) if ref else None,
                 "outputs_bit_identical_to_e62_fix_cell_call_by_call": (hi.get("_outputs") == ref_out) if ref else None,
                 "cfs_boundary_verdicts": {"B_u_minus_1": cfs_lo, "B_u": cfs_hi, "logs": list(CFS[m])},
                 "verdicts_agree_with_cfs": agree,
                 "pass": bool(lo_ok and hi_ok and agree)}
        ok3 = ok3 and q3[m]["pass"]
    s["Q3_reissued_documents"] = {"cells": q3, "pass": ok3,
                                  "verdict_agreement_with_cfs": "%d/8" % sum(2 for m in MODELS if q3[m]["verdicts_agree_with_cfs"])}
    # ---- Q4: refusal cells and the waiver control --------------------------------------------------
    rules = {"e66_b2_resnet_R1_unchecked": "carries no validity.producer_check",
             "e66_b2_resnet_R2_earlier_revision": "producer_check.state='mismatch'",
             "e66_b2_resnet_R3_override": "overrides_applied=['--allow-structural-mismatch']",
             "e66_b2_resnet_R4_budget_zero": "budget_bytes=0 does not resolve to a positive integer"}
    q4 = {}
    ok4 = True
    for dep, needle in rules.items():
        c = cell(dep, cells_root)
        ok = (c.get("present") and c["active"] is False and c["runtime_created"] is False
              and c["admission_verdict"] is None and c["inferences"] == 0 and needle in (c["inactive_reason"] or "")
              and c["onair_returncode"] == 0 and c["onair_core_unmodified"] is True)
        q4[dep] = dict({k: v for k, v in c.items() if not k.startswith("_") and k != "peaks"},
                       expected_reason_fragment=needle, pass_=bool(ok))
        ok4 = ok4 and ok
    c1 = cell("e66_b2_resnet_C1_waived", cells_root)
    c1_ok = (c1.get("present") and c1["admission_verdict"] == "ADMIT" and c1["inferences"] >= 1
             and c1["document_acceptance"] == {"verdict": "accepted", "waived": ["allow_unchecked_producer"]})
    q4["e66_b2_resnet_C1_waived"] = dict({k: (v if k != "peaks" else {"n": len(v), "distinct": sorted(set(v))})
                                          for k, v in c1.items() if not k.startswith("_")}, pass_=bool(c1_ok))
    s["Q4_refusals_and_waiver"] = {"cells": q4, "pass": bool(ok4 and c1_ok),
                                   "attribution_control": "Q3 e66_b2_resnet_Bu: same artifact, fixture, budget and "
                                                          "configuration; only the document differs"}
    s["Q6_vcpu_record"] = ground["Q6_vcpu_record"]
    s["Q7_inventory_record"] = {k: v for k, v in ground["Q7_inventory_record"].items()}
    s["not_claimed"] = [
        "a hand-edited document is outside the research assumption; the four hand-edited parity variants are unit cases",
        "documents without a provenance block keep the header generator's scope (accepted by both, recorded)",
        "the earlier OnAIR cells (E57, E62, E65) were not re-run; they reproduce from their configurations only with "
        "the recorded waiver",
        "latency, accuracy, the conditional policy"]
    s["verdict"] = "PASS" if all(s[k]["pass"] for k in ("Q1_parity", "Q2_budget", "Q3_reissued_documents",
                                                        "Q4_refusals_and_waiver", "Q5_corpus")) else "FAIL"
    out = a.out or os.path.join(a.root, "summary.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(s, f, indent=1, sort_keys=True)
        f.write("\n")
    print(json.dumps({k: s[k]["pass"] for k in ("Q1_parity", "Q2_budget", "Q3_reissued_documents",
                                                "Q4_refusals_and_waiver", "Q5_corpus")}), s["verdict"],
          s["Q3_reissued_documents"]["verdict_agreement_with_cfs"])


if __name__ == "__main__":
    main()
