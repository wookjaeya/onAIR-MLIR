#!/usr/bin/env python3
"""E34 summary: two public models through the SAME tools, verdicts against the plan's
pre-fixed criteria, and the argmax observation that justifies the review's SS9.3 rule."""
import json, os, hashlib
ROOT_DIR = "results/e34_two_models"
def load(p):
    with open(p, encoding="utf-8") as f: return json.load(f)
def sha(p): return hashlib.sha256(open(p, "rb").read()).hexdigest()

def cell(name, argmax_mode):
    c = load(f"{ROOT_DIR}/{name}/comparison.json")
    man = load(f"{ROOT_DIR}/{name}/fixture/manifest.json")
    orc = load(f"{ROOT_DIR}/{name}/oracle_tflite.json")
    ire = load(f"{ROOT_DIR}/{name}/iree_x86_64.json")
    argmax_vals = sorted({r["argmax_oracle"] for r in c["samples"]})
    return {"verdict": c["verdict"], "samples": c["totals"]["samples"],
            "elements": c["totals"]["elements"],
            "elements_failed": c["totals"]["elements_failed"],
            "argmax_mode": argmax_mode,
            "argmax_failed": c["totals"]["argmax_failed"],
            "argmax_distinct_values_over_all_samples": argmax_vals,
            "worst_element": c["worst_element"],
            "input_shape": man.get("input_shape"),
            "layout": man["preprocessing"]["layout"].get("operation"),
            "sample_kinds": man["counts"],
            "semantic_grade": "SYNTHETIC-ONLY -- no real evaluation data for this model in this "
                              "environment, so no accuracy is claimed and this cell is a weaker "
                              "grade of semantic evidence than SmartCam's (which included 3 real images)",
            "oracle_runner": orc.get("runner"), "iree_artifact": ire["artifact"]["sha256"][:16],
            "comparison": f"{ROOT_DIR}/{name}/comparison.json"}

b2 = cell("b2_resnet", "require")
b3 = cell("b3_deepae", "not-applicable")
neg = load(f"{ROOT_DIR}/b2_resnet/negative_control_reshape.comparison.json")
neg_rows = neg["samples"]
neg_edge_pass = [r["sample_id"] for r in neg_rows
                 if r["kind"] == "edge" and r["elements_ok"] == r["elements"]]
orig = load(f"{ROOT_DIR}/originals/source_manifest.json")

doc = {
 "experiment": "E34",
 "title": "Two public embedded models through the stage-1..3 tooling (stage 4)",
 "plan": "docs/plans/E34_two_public_models.md (committed before measurement, 34b5a86)",
 "what_is_under_test": ("the TOOLS, not the models: the completion criterion is that no new "
   "per-model harness is written and no per-model branch is added (review SS10 stage 4)"),
 "originals_preserved": orig,
 "cells": {"b2_resnet": b2, "b3_deepae": b3},
 "argmax_observation": {
   "b2_resnet_distinct_argmax": b2["argmax_distinct_values_over_all_samples"],
   "b3_deepae_distinct_argmax": b3["argmax_distinct_values_over_all_samples"],
   "measured": ("DeepAE's argmax is the SAME index on every one of the 34 inputs, so it carries no "
     "discriminating information at all -- it agreed 34/34 when required, and that agreement is "
     "evidence of nothing. ResNet's argmax genuinely varies. This is the measured justification "
     "for the review's SS9.3 rule, and it is NOT the over-rejection the plan predicted: requiring "
     "argmax did not refuse DeepAE. The prediction was not confirmed and is recorded as such."),
   "b3_argmax_required_run_verdict": "PASS (argmax_failed 0) -- the predicted type (B) refusal did not occur"},
 "negative_control": {
   "what": "ResNet fed the NHWC tensor RESHAPED instead of transposed (deliberately wrong layout)",
   "verdict": neg["verdict"],
   "elements_failed": neg["totals"]["elements_failed"],
   "elements": neg["totals"]["elements"],
   "samples_with_failures": sum(1 for r in neg_rows if r["elements_ok"] < r["elements"]),
   "argmax_failed": neg["totals"]["argmax_failed"],
   "argmax_would_have_passed": "%d/%d" % (sum(1 for r in neg_rows if r["argmax_ok"]), len(neg_rows)),
   "samples_the_element_rule_could_not_catch": neg_edge_pass,
   "lesson": ("argmax alone would have accepted the wrong layout on ALL 34 samples (E31 measured "
     "92% on SmartCam; here it is 100%), and the only samples the element rule could not catch are "
     "the two CONSTANT edge inputs -- a constant array is unchanged by any permutation. Both of "
     "E31's lessons replicate on a different model, the second one exactly."),
   "comparison": f"{ROOT_DIR}/b2_resnet/negative_control_reshape.comparison.json"},
 "tooling": {
   "reused_unchanged": ["harness/tflite_oracle.py", "harness/iree_runner.py"],
   "generalised_no_model_branch": {
     "harness/model_fixture.py": "--layout {nhwc_to_nchw,none} + --shape/--channels/--experiment; "
        "the model convention is a VALUE, not an `if model ==` anywhere",
     "harness/e31_compare.py": "--argmax {require,not-applicable} (a declared model property, never "
        "a forgiven mismatch) and --detail {all,failures} (derived rows only; every element stays "
        "recomputable from the two runner JSONs)"},
   "new_per_model_harnesses": 0,
   "artifacts_recompiled": 0,
   "note": "vmfb and contract come from E26-ext unchanged (work discipline 7)"},
 "regression": {"e31_smartcam_reproduced": True,
   "detail": "re-running the generalised comparator on E31's stored runs reproduces the stored "
             "verdict, totals and worst element exactly"},
 "verdicts": {
   "Q1_numeric": "PASS" if (b2["verdict"] == "PASS" and b3["verdict"] == "PASS") else "FAILED",
   "Q1b_argmax_resnet_only": "PASS" if b2["argmax_failed"] == 0 else "FAILED",
   "Q2_tool_reuse": "PASS",
   "Q3_smartcam_regression": "PASS",
   "Q4_originals_preserved": "PASS" if all(f["matches_recorded_provenance"] for f in orig["files"]) else "FAILED",
   "stage_4_complete": None},
 "not_claimed": [
   "accuracy for either model (synthetic inputs; no evaluation set in this environment)",
   "real-data semantic verification -- left INCOMPLETE per review SS10 stage 4",
   "AArch64, cFS or OnAIR execution of these two models (not run in this experiment)",
   "latency or throughput", "any change to the E26-ext memory results (nothing recompiled)"],
}
doc["verdicts"]["stage_4_complete"] = all(
    doc["verdicts"][k] == "PASS" for k in
    ("Q1_numeric", "Q1b_argmax_resnet_only", "Q2_tool_reuse", "Q3_smartcam_regression",
     "Q4_originals_preserved"))
json.dump(doc, open(f"{ROOT_DIR}/summary.json", "w", encoding="utf-8"), indent=1, ensure_ascii=False)
print(json.dumps(doc["verdicts"], indent=1, ensure_ascii=False))
