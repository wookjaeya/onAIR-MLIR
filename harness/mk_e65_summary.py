#!/usr/bin/env python3
"""E65: derive every verdict from the raw records (plan docs/plans/E65_producer_revision_and_plugin_option.md).

Q1/Q4/Q5 come from the ground-side records written by harness/e65_producer_check.py; Q2 is
re-read from the two cFS guest logs (not from the runner's summary -- D89: a guard that reads only
a summary passes when the raw data is reverted); Q3 from the OnAIR plugin's own init records;
Q6 from the guest environment record. Nothing is typed in by hand.

Usage: python3 harness/mk_e65_summary.py [--out results/e65_producer_check/summary.json]
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import mk_e36_summary as m36                                      # noqa: E402  (stages: the app's own records, D68)
import make_contract as mc                                        # noqa: E402  (CHECKED_PRODUCER)

D = os.path.join(ROOT, "results", "e65_producer_check")
PLAN = "docs/plans/E65_producer_revision_and_plugin_option.md (committed before any cell, 7b67d89)"


def load(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def q2():
    logs = os.path.join(D, "guest", "cells", "logs")
    so = {}
    for line in open(os.path.join(D, "guest", "guest_so_sha256.txt"), encoding="utf-8"):
        h, p = line.split()
        so[p.split("/")[-2]] = h
    cells = {}
    for tag in ("e65_drift_nobound", "e65_drift_legacy"):
        text = open(os.path.join(logs, tag + ".log"), encoding="utf-8", errors="replace").read()
        st = m36.stages(os.path.join(logs, tag + ".log"))
        adm = [r.get("verdict") for r in st.get("admission", [])]
        rlf = st.get("runtime_load_failed", [])
        exit_at = [m.start() for m in re.finditer(r"CFE_ES_ExitApp: Application AI_LEARNER", text)]
        later_apps = (len(re.findall(r"Application initialized", text[exit_at[0]:])) if exit_at else 0)
        built = open(os.path.join(D, "guest", "trees", tag, "so_sha256.txt")).read().strip()
        cells[tag] = {
            "log": os.path.relpath(os.path.join(logs, tag + ".log"), ROOT),
            "build_config_bound_known": [r.get("contract_bound_known") for r in st.get("build_config", [])],
            "admission": adm,
            "binding": [r.get("verdict") for r in st.get("binding", [])],
            "runtime_load_failed_status": [r.get("status") for r in rlf],
            "mem_init_records": len(st.get("mem_init", [])),
            "run_records": len(st.get("run", [])) + st["__unparsed__"].get("run", 0),
            "cleanup_records": len(st.get("cleanup", [])),
            "apps_initialized_after_ai_learner_exit": later_apps,
            "guest_so_sha256": so.get(tag), "built_so_sha256": built,
            "so_sha256_matches_build": so.get(tag) == built,
        }
    a, b = cells["e65_drift_nobound"], cells["e65_drift_legacy"]
    a["pass"] = (a["so_sha256_matches_build"] and a["build_config_bound_known"] == [False]
                 and a["admission"] == ["UNKNOWN_BOUND"] and a["mem_init_records"] == 0
                 and a["run_records"] == 0 and a["apps_initialized_after_ai_learner_exit"] > 0)
    msg = (b["runtime_load_failed_status"] or [""])[0]
    b["pass"] = (b["so_sha256_matches_build"] and b["build_config_bound_known"] == [True]
                 and b["admission"] == ["ADMIT"] and b["binding"] == ["MATCH"]
                 and "bytecode version mismatch" in msg and "module has 16.0" in msg
                 and "supports 17.0" in msg and b["mem_init_records"] == 0 and b["run_records"] == 0
                 and b["apps_initialized_after_ai_learner_exit"] > 0)
    return {"cells": cells, "pass": a["pass"] and b["pass"]}


def q3():
    base = os.path.join(D, "guest", "onair")
    cells = {}
    for dep in ("e65_b2_resnet_conditional_requested", "e65_b2_resnet_conditional_false_control"):
        recs = [json.loads(l) for l in open(os.path.join(base, dep, "plugin_records.jsonl"), encoding="utf-8") if l.strip()]
        init = [r for r in recs if r.get("event") == "init"]
        infer = [r for r in recs if r.get("event") != "init" and "output" in r]
        cfg = load(os.path.join(base, dep, "deployment.json"))["deployments"][dep]
        run = load(os.path.join(base, dep, "run.json"))
        i0 = init[0] if len(init) == 1 else {}
        cells[dep] = {"allow_conditional_map_configured": cfg.get("allow_conditional_map"),
                      "budget_bytes": cfg.get("budget_bytes"),
                      "init_records": len(init), "active": i0.get("active"),
                      "inactive_reason": i0.get("inactive_reason"),
                      "runtime_created": i0.get("runtime_created"),
                      "admission_verdict": (i0.get("admission") or {}).get("verdict"),
                      "inference_records": len(infer), "onair_returncode": run.get("returncode"),
                      "onair_core_unmodified": run["onair"].get("core_unmodified")}
    r, c = cells["e65_b2_resnet_conditional_requested"], cells["e65_b2_resnet_conditional_false_control"]
    others = {k: v for k, v in load(os.path.join(base, "e65_b2_resnet_conditional_requested", "deployment.json"))
              ["deployments"].items()}
    r["pass"] = (r["allow_conditional_map_configured"] is True and r["active"] is False
                 and (r["inactive_reason"] or "").startswith("ConfigurationError:")
                 and r["runtime_created"] is False and r["admission_verdict"] is None
                 and r["inference_records"] == 0 and r["onair_returncode"] == 0 and r["onair_core_unmodified"])
    c["pass"] = (c["allow_conditional_map_configured"] is False and c["active"] is True
                 and c["runtime_created"] is True and c["admission_verdict"] == "ADMIT"
                 and c["inference_records"] >= 1 and c["onair_returncode"] == 0 and c["onair_core_unmodified"])
    return {"cells": cells, "pass": r["pass"] and c["pass"], "_deployments_in_cell_config": sorted(others)}


def q6():
    txt = open(os.path.join(D, "guest", "onair", "guest_env.txt"), encoding="utf-8").read()
    v = re.search(r'^VERSION = "([^"]+)"', txt, re.M)
    rv = re.search(r'"IREE": "([0-9a-f]+)"', txt)
    rec = {"source": "results/e65_producer_check/guest/onair/guest_env.txt (iree/_runtime_libs/version.py read in the guest)",
           "python_runtime_version": v.group(1) if v else None,
           "python_runtime_iree_revision": rv.group(1) if rv else None,
           "compiler_revision_checked": mc.CHECKED_PRODUCER["compiler_commit"],
           "c_runtime_revision": "e4a3b0405d7d23554da26403658d0e8c3c5ecf25 (scripts/40/61 build from the iree-src "
                                 "checkout at that commit; CLAUDE.md environment section)"}
    rec["same_revision_as_compiler"] = rec["python_runtime_iree_revision"] == rec["compiler_revision_checked"]
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(D, "summary.json"))
    a = ap.parse_args()
    an = load(os.path.join(D, "analyzer.json"))
    mo = load(os.path.join(D, "multiout.json"))
    doc = {"experiment": "E65", "plan": PLAN,
           "checked_producer": mc.CHECKED_PRODUCER,
           "Q1_earlier_revision_reanalysis": {"pass": an["Q1_earlier_revision"]["pass"],
                                              "record": "results/e65_producer_check/analyzer.json"},
           "Q2_guest_cells": q2(),
           "Q3_onair_conditional_option": q3(),
           "Q4_reissue": {"pass": an["Q4_reissue"]["pass"], "record": "results/e65_producer_check/analyzer.json"},
           "Q5a_layout_edits": {"pass": an["Q5a_layout_edits"]["pass"], "record": "results/e65_producer_check/analyzer.json"},
           "Q5b_multiout": {"pass": mo["Q5b_multiout"]["pass"], "record": "results/e65_producer_check/multiout.json"},
           "Q6_runtime_revision": q6(),
           "not_claimed": [
               "the bytecode-version check does not distinguish compiler revisions that emit the same bytecode version",
               "K was not checked over the earlier revision; Q2(b) shows only that the runtime does not load that module",
               "multi-slab / multi-output execution peaks (Q5 is analyzer-level)",
               "latency, accuracy"]}
    doc["verdict"] = ("PASS" if all(doc[k]["pass"] for k in ("Q1_earlier_revision_reanalysis", "Q2_guest_cells",
                                                              "Q3_onair_conditional_option", "Q4_reissue",
                                                              "Q5a_layout_edits", "Q5b_multiout"))
                      and doc["Q6_runtime_revision"]["same_revision_as_compiler"] else "FAIL")
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, sort_keys=True)
        f.write("\n")
    print(json.dumps({k: (v.get("pass") if isinstance(v, dict) and "pass" in v else None)
                      for k, v in doc.items() if k.startswith("Q")}), doc["verdict"])


if __name__ == "__main__":
    main()
