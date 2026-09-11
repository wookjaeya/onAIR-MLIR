#!/usr/bin/env python3
"""E38: fold the two re-run conditional cells into one verdict document.

Why they were re-run
--------------------
E36's `cond_positive` and `cond_denied_without_optin` differ only in the build-time
AI_LEARNER_ALLOW_CONDITIONAL_MAP, and nothing outside the run verdict recorded which
build served which cell: the archived `build.log` never mentions the flag, the two
trees' `build_info.json` app_knobs are byte-identical, and the archived
`ai_learner.CMakeLists.txt` spells the value as an unexpanded CMake variable.  So the
control that makes the positive cell meaningful rested on the verdict it was supposed
to explain.  The eighth external review (SS4.1) asked for an independent record; there
was none to connect, so these two cells -- and only these two -- were re-run.

What is different now
---------------------
Three records, each independent of the verdict:
  1. the app writes a `build_config` line carrying `allow_conditional_map` BEFORE any
     gate runs, so even a refusing cell states its own setting (D61's lesson, applied
     to the setting D61 did not cover);
  2. `scripts/51_build_cfs_aarch64.sh` records the knob and the actual `-D` list of the
     ai_learner.c compile in `build_info.json`;
  3. `harness/optin_witness.py` reads the setting back out of the shipped binary and
     FAILS THE BUILD if it disagrees -- and that witness is re-derivable in-tree from
     the archived binaries under results/e38_optin_record/e36_binaries/.

Like mk_e36_summary.py, every value here is read from what the app itself recorded.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
E38 = os.path.join(ROOT, "results", "e38_optin_record")
CELL_DIR = os.path.join(E38, "cells")

sys.path.insert(0, os.path.join(ROOT, "harness"))
from mk_e36_summary import stages, record_count            # noqa: E402  (same parser, D68 included)

PER_CALL, BOUNDED, CONSTANTS = 9382092, 18222796, 8840704


def cell(name, witness_file, so_sha):
    p = os.path.join(CELL_DIR, name + ".log")
    if not os.path.exists(p):
        return {"error": "missing log", "log": None}
    txt = open(p, encoding="utf-8", errors="replace").read()
    st = stages(p)
    adm = (st.get("admission") or [None])[-1]
    mem = (st.get("mem") or [None])[-1]
    mb = (st.get("map_branch") or [None])[-1]
    bc = (st.get("build_config") or [None])[-1]

    # The point of the whole cell: the setting must be stated ahead of the verdict, so
    # that the verdict is not the only thing that says what the setting was.
    i_bc = txt.find('"stage":"build_config"')
    i_adm = txt.find('"stage":"admission"')
    precedes = i_bc >= 0 and (i_adm < 0 or i_bc < i_adm)

    wpath = os.path.join(E38, witness_file)
    witness = json.load(open(wpath)) if os.path.exists(wpath) else None
    d = {
        "log": os.path.relpath(p, ROOT),
        "build_config": bc and {k: bc.get(k) for k in
                                ("allow_conditional_map", "contract_bounded_bytes",
                                 "contract_per_call_bytes", "contract_const_bytes",
                                 "contract_bound_known", "contract_artifact_sha256")},
        "build_config_precedes_admission": precedes,
        "verdict": adm.get("verdict") if adm else None,
        "budget_bytes": adm.get("budget") if adm else None,
        "budget_source": adm.get("budget_source") if adm else None,
        "inferences": mem.get("completed") if mem else 0,
        "run_records": record_count(st, "run"),
        "run_records_unparseable": st.get("__unparsed__", {}).get("run", 0),
        "hal_peak": mem.get("hal_peak") if mem else None,
        "admitted_budget_bytes": mem.get("admitted_budget_bytes") if mem else None,
        "peak_within_admitted_budget": mem.get("peak_within_admitted_budget") if mem else None,
        "admission_mode": mem.get("admission_mode") if mem else None,
        "budget_invalid_event": "BUDGET_INVALID" in txt,
        "exit": (re.findall(r"EXIT=(\d+)", txt) or [None])[-1],
        "ai_learner_so_sha256": so_sha,
        "optin_witness": witness and {k: witness.get(k) for k in
                                      ("allow_conditional_map_state", "binary_sha256",
                                       "conditional_compare_sites", "method")},
    }
    if mb:
        d["map_branch"] = {k: mb.get(k) for k in
                           ("module_ptr_mod64", "hal_peak_after_append", "arm", "admission_mode")}
    if d["verdict"] == "NOT_ADMITTED" or d["budget_invalid_event"]:
        tail = txt[txt.find("ExitApp"):] if "ExitApp" in txt else ""
        d["cfs_alive_after_refusal"] = {
            "exit_app_logged": "CFE_ES_ExitApp" in txt,
            "apps_loaded_after": sorted(set(re.findall(r"Loading file: /cf/(\w+)\.so", tail))),
            "log_lines_after_exit": tail.count("\n"),
        }
    return d


def main():
    trees = json.load(open(os.path.join(E38, "trees.json")))
    cells = {
        "cond_positive": cell("cond_positive", "trees/e38_smartcam_cond.optin_witness.json",
                              trees["e38_smartcam_cond"]["ai_learner_so_sha256"]),
        "cond_denied_without_optin": cell("cond_denied_without_optin",
                                          "trees/e38_smartcam.optin_witness.json",
                                          trees["e38_smartcam"]["ai_learner_so_sha256"]),
    }
    cp, cd = cells["cond_positive"], cells["cond_denied_without_optin"]

    # Q1: each cell states its own setting, before its own verdict.
    q1 = all(c.get("build_config", {}).get("allow_conditional_map") is not None
             and c["build_config_precedes_admission"] for c in cells.values())
    # Q2: the binary that ran each cell witnesses the same setting.
    q2 = (cp["optin_witness"]["allow_conditional_map_state"] == "1"
          and cd["optin_witness"]["allow_conditional_map_state"] == "0"
          and cp["optin_witness"]["binary_sha256"] == cp["ai_learner_so_sha256"]
          and cd["optin_witness"]["binary_sha256"] == cd["ai_learner_so_sha256"])
    # Q3: the control is still a control -- same budget, opposite verdicts.
    q3 = (cp["budget_bytes"] == cd["budget_bytes"] == PER_CALL
          and cp["verdict"] == "ADMIT_CONDITIONAL_MAP" and cd["verdict"] == "NOT_ADMITTED"
          and cd["inferences"] == 0
          and cp["ai_learner_so_sha256"] != cd["ai_learner_so_sha256"])
    # Q4: E36's measurements are unchanged by the added record.
    q4 = (cp["hal_peak"] == PER_CALL and cp["admitted_budget_bytes"] == PER_CALL
          and cp["peak_within_admitted_budget"] is True
          and cp.get("map_branch", {}).get("arm") == "map"
          and cp.get("map_branch", {}).get("module_ptr_mod64") == 0
          and cp.get("map_branch", {}).get("hal_peak_after_append") == 0)

    # Q5: the chain a log needs to be about a particular binary -- the .so the guest
    # actually loaded, hashed ON the guest, equals the one the build record names.
    q5 = all(trees[t].get("deployed_on_guest", {}).get("matches_build_info") is True
             for t in ("e38_smartcam", "e38_smartcam_cond"))

    doc = {
        "experiment": "E38",
        "title": "the conditional opt-in, recorded independently of the verdict it decides",
        "trigger": "docs/reviews/DECISIONS_v0_41_INTEGRATED_REVIEW.md SS4.1 / SS10-2",
        "why_rerun": ("SS10-2 says to connect the two conditional cells to an independent record "
                      "and to re-run them ONLY if none exists.  None existed: build.log has no "
                      "`CONDITIONAL` line, the two E36 trees' build_info app_knobs are "
                      "byte-identical and omit the flag, and the archived CMakeLists spells it "
                      "as an unexpanded ${AI_LEARNER_ALLOW_CONDITIONAL_MAP}.  So these two cells "
                      "were re-run -- and only these two."),
        "retroactive_evidence": {
            "note": ("the archived E36 binaries DO differ exactly at the opt-in branch, which "
                     "shows the build-time control was real; what was missing was the run-time "
                     "link from a log to a binary, and that is what the re-run supplies"),
            "dir": "results/e38_optin_record/e36_binaries",
        },
        "contract": {"bounded": BOUNDED, "per_call": PER_CALL, "constants": CONSTANTS,
                     "source": "results/e32_smartcam_aarch64/build/smartcam.contract.json",
                     "note": "not regenerated -- E32's single-invocation artefacts are reused"},
        "trees": trees,
        "cells": cells,
        "verdicts": {
            "Q1_setting_recorded_before_verdict": "PASS" if q1 else "FAILED",
            "Q2_binary_witnesses_same_setting": "PASS" if q2 else "FAILED",
            "Q3_control_still_a_control": "PASS" if q3 else "FAILED",
            "Q4_e36_measurements_unchanged": "PASS" if q4 else "FAILED",
            "Q5_guest_binary_matches_build_record": "PASS" if q5 else "FAILED",
            "optin_independently_recorded": bool(q1 and q2 and q3 and q4 and q5),
        },
        "not_claimed": [
            "E36's other five cells were not re-run -- they do not depend on the opt-in, and "
            "their archived results stand as evidence of the commit that produced them",
            "the inference COUNT is timeout-dependent, not an invariant; only the deterministic "
            "values (setting, verdict, budget, peak, arm) are compared with E36",
            "nothing about accuracy, latency, or any model other than SmartCam",
        ],
    }
    out = os.path.join(E38, "summary.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, ensure_ascii=False)
        f.write("\n")
    print(out)
    for k, v in doc["verdicts"].items():
        print("  %-40s %s" % (k, v))
    return 0 if doc["verdicts"]["optin_independently_recorded"] else 1


if __name__ == "__main__":
    sys.exit(main())
