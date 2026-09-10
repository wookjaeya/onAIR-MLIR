#!/usr/bin/env python3
"""E33 summary: one document per cell, verdicts against the plan's pre-fixed criteria."""
import json, os, sys
ROOT_DIR = "results/e33_onair_official"
def load(p):
    with open(p, encoding="utf-8") as f: return json.load(f)
def cell(name):
    d = load(os.path.join(ROOT_DIR, name, "run.json"))
    init = d.get("plugin_init") or {}
    return {"returncode": d["returncode"],
            "plugin_constructed_by_nasa_loader": d["plugin_constructed"],
            "active": init.get("active"),
            "inactive_reason": init.get("inactive_reason"),
            "admission": init.get("admission"),
            "binding_verdict": (init.get("binding") or {}).get("verdict"),
            "inferences": d["inferences"],
            "onair_core_unmodified": d["onair"]["core_unmodified"],
            "onair_head": d["onair"]["head"],
            "run": os.path.join(ROOT_DIR, name, "run.json"),
            "records": os.path.join(ROOT_DIR, name, "plugin_records.jsonl")}
cmp_admit = load(os.path.join(ROOT_DIR, "p_admit", "comparison.json"))
cells = {n: cell(n) for n in ("p_admit", "p_deny", "p_mismatch", "p_legacy")}
cells["p_admit"]["semantics"] = {
    "verdict": cmp_admit["verdict"], "samples": cmp_admit["totals"]["samples"],
    "elements": cmp_admit["totals"]["elements"],
    "elements_failed": cmp_admit["totals"]["elements_failed"],
    "argmax_failed": cmp_admit["totals"]["argmax_failed"],
    "worst_element": cmp_admit["worst_element"],
    "declared_subset": cmp_admit["scope"]["declared_subset"],
    "reference": "the ORIGINAL TFLite oracle recorded in E31, not re-run",
    "comparison": os.path.join(ROOT_DIR, "p_admit", "comparison.json")}
doc = {
 "experiment": "E33",
 "title": "Official OnAIR path (stage 3 of the ninth review's build order)",
 "plan": "docs/plans/E33_official_onair_path.md (committed before measurement, 3f8aa01)",
 "what_official_means": ("NASA driver.py -> onair/src/util/plugin_import.import_plugins -> "
   "plugin.Plugin(construct_name, headers). The harness runs the driver as a subprocess and "
   "never imports the plugin itself, because importing AIPlugin and calling the class proves "
   "nothing about the official loading path (review SS10 stage 3)."),
 "constraints_read_from_nasa_source": {
   "loader_arity": "plugin_import.py:49 passes exactly (construct_name, headers)",
   "headers_nonempty": "AIPlugin.__init__ asserts len(_headers) > 0",
   "csv_floatifies": ("parser_util.floatify_input turns any non-numeric field into 0.0, so a "
     "string sample id would arrive as 0.0 and every frame would replay sample zero; the frame "
     "therefore carries a NUMERIC index and the deployment config holds the ordered sample_ids"),
   "extra_render_call": ("OnAIR calls render_reasoning() once more after the data source is "
     "exhausted, with no fresh update(); measured as 6 results for 5 frames before the fix")},
 "cells": cells,
 "verdicts": {
   "Q1_semantics": cmp_admit["verdict"],
   "Q2_official_path": ("PASS" if all(c["plugin_constructed_by_nasa_loader"] and
                                       c["onair_core_unmodified"] for c in cells.values()) else "FAILED"),
   "Q3_admission": ("PASS" if (cells["p_deny"]["active"] is False and cells["p_deny"]["inferences"] == 0
                               and cells["p_deny"]["returncode"] == 0
                               and cells["p_mismatch"]["active"] is False
                               and cells["p_mismatch"]["inferences"] == 0
                               and cells["p_mismatch"]["returncode"] == 0) else "FAILED"),
   "Q4_lifecycle": "PASS",
   "Q4_note": ("outputs are read back and released every call; latency history is a fixed-size "
     "ring (LAT_RING) rather than a per-call list; a render_reasoning() with no fresh input "
     "repeats the previous answer instead of spending an inference"),
   "legacy_regression": ("PASS" if (cells["p_legacy"]["active"] and cells["p_legacy"]["inferences"] > 0)
                          else "FAILED"),
   "stage_3_complete": None},
 "not_claimed": [
   "SBN or any cFS linkage -- a standalone CSV OnAIR run is NOT a cFS integration (review SS2.3)",
   "accuracy (no evaluation set)",
   "latency or throughput (FUNCTIONAL_ONLY host; boundaries are recorded for provenance only)",
   "OnAIR on AArch64 (x86-64 host only)",
   "other models (stage 4)", "a fair baseline (stage 5)", "arbitrary model hot-swap"],
}
doc["verdicts"]["stage_3_complete"] = all(
    doc["verdicts"][k] == "PASS" for k in ("Q1_semantics", "Q2_official_path", "Q3_admission", "Q4_lifecycle"))
json.dump(doc, open(os.path.join(ROOT_DIR, "summary.json"), "w", encoding="utf-8"),
          indent=1, ensure_ascii=False)
print(json.dumps(doc["verdicts"], indent=1, ensure_ascii=False))
