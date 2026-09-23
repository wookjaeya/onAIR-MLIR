#!/usr/bin/env python3
"""E63 summary: Table 7 on one application build per model, and the conditional floor M = P - 1.

Plan: docs/plans/E63_single_build_peaks_and_conditional_floor.md (commit 78dfda1, before any cell).
Every value is read from what the flight app itself wrote to its guest log (the same `stages()`
reader as E36/E38 -- D68: a truncated record still counts as present), from the guest-side sha256
list the session wrote immediately before the cells, and from the archived E55b/E56/E58 records.
Nothing is transcribed from prose.

    python3 harness/mk_e63_summary.py [--out PATH]
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from mk_e36_summary import stages, record_count      # noqa: E402

ROOT = os.path.join(REPO, "results", "e63_single_build_and_conditional_floor")
PLAN = "docs/plans/E63_single_build_peaks_and_conditional_floor.md"
PLAN_COMMIT = "78dfda1"
MODELS = ("b2_resnet", "b3_deepae", "smartcam", "wgan")
P = {"b2_resnet": 309416, "b3_deepae": 6208, "smartcam": 9382092, "wgan": 131382784}
C = {"b2_resnet": 309440, "b3_deepae": 1063424, "smartcam": 8840704, "wgan": 4283648}
T7 = "e63_wgan_map_e55b_build"


def guest_hashes():
    out = {}
    for ln in open(os.path.join(ROOT, "guest_so_sha256.txt")):
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        h, path = ln.split(None, 1)
        out[path] = h
    return out


def tree_hash_e55b(m):
    return open(os.path.join(REPO, "results", "e55b_copy_path", "trees", "e55b_%s_copy" % m,
                             "ai_learner.so.sha256")).read().split()[0]


def tree_hash_e56(m):
    return json.load(open(os.path.join(REPO, "results", "e56_conditional_refusal_aarch64", "trees",
                                       "e56_%s" % m, "so_sha256.json")))["ai_learner_so_sha256"]


def last(st, stage):
    v = st.get(stage) or []
    return v[-1] if v else None


def log_path(cell):
    return os.path.join(ROOT, "cells", "logs", cell + ".log")


def runner_record(cell):
    """The scenario runner's own record (e14_cfs_scenarios.py); used only for cfs_operational and crash lines."""
    s = os.path.join(ROOT, "cells", "summary.json")
    if not os.path.isfile(s):
        return None
    for sc in json.load(open(s)).get("scenarios", []):
        if sc.get("id") == cell:
            return sc
    return None


def cf_cell(m, gh):
    cell = "e63_%s_cond_Pm1" % m
    lp = log_path(cell)
    so = "/home/ubuntu/e56_run/variants/e56_%s/ai_learner.so" % m
    row = {"cell": cell, "log": os.path.relpath(lp, REPO), "present": os.path.isfile(lp),
           "so_guest_sha256": gh.get(so), "so_archived_sha256": tree_hash_e56(m)}
    row["V_so_matches"] = row["so_guest_sha256"] is not None and row["so_guest_sha256"] == row["so_archived_sha256"]
    if not row["present"]:
        row["holds"] = False
        return row
    txt = open(lp, encoding="utf-8", errors="replace").read()
    st = stages(lp)
    adm, bc = last(st, "admission") or {}, last(st, "build_config") or {}
    rr = runner_record(cell) or {}
    row.update({
        "allow_conditional_map": bc.get("allow_conditional_map"),
        "verdict": adm.get("verdict"), "budget": adm.get("budget"), "budget_source": adm.get("budget_source"),
        "budget_is_P_minus_1": adm.get("budget") == P[m] - 1,
        "mem_init_records": record_count(st, "mem_init"),
        "map_branch_records": record_count(st, "map_branch"),
        "run_records": record_count(st, "run"), "mem_records": record_count(st, "mem"),
        "exit_app_logged": "CFE_ES_ExitApp: Application AI_LEARNER" in txt,
        "cfs_operational": rr.get("cfs_operational"), "crash_indicators": rr.get("crash_indicators")})
    row["holds"] = (row["V_so_matches"] and row["allow_conditional_map"] == 1 and row["verdict"] == "NOT_ADMITTED"
                    and row["budget_is_P_minus_1"] and row["budget_source"] == "override"
                    and row["mem_init_records"] == 0 and row["map_branch_records"] == 0
                    and row["run_records"] == 0 and row["mem_records"] == 0
                    and row["exit_app_logged"] and row["cfs_operational"] is True and not row["crash_indicators"])
    return row


def t7_cell(gh):
    lp = log_path(T7)
    so = "/home/ubuntu/e55_run/variants/e55b_wgan_copy/ai_learner.so"
    row = {"cell": T7, "log": os.path.relpath(lp, REPO), "present": os.path.isfile(lp),
           "so_guest_sha256": gh.get(so), "so_archived_sha256": tree_hash_e55b("wgan")}
    row["V_so_matches"] = row["so_guest_sha256"] is not None and row["so_guest_sha256"] == row["so_archived_sha256"]
    if not row["present"]:
        row["holds"] = False
        return row
    st = stages(lp)
    adm, bnd = last(st, "admission") or {}, last(st, "binding") or {}
    ba, mb, mem = last(st, "blob_align") or {}, last(st, "map_branch") or {}, last(st, "mem") or {}
    bc = last(st, "build_config") or {}
    rr = runner_record(T7) or {}
    row.update({
        "allow_conditional_map": bc.get("allow_conditional_map"),
        "verdict": adm.get("verdict"), "budget": adm.get("budget"), "budget_source": adm.get("budget_source"),
        "binding": bnd.get("verdict"),
        "blob_align": {k: ba.get(k) for k in ("requested_offset", "state", "module_ptr_mod64")},
        "hal_peak_after_append": mb.get("hal_peak_after_append"), "arm_label": mb.get("arm"),
        "completed": mem.get("completed"), "final_hal_peak": mem.get("hal_peak"),
        "max_active_calls": mem.get("max_active_calls"),
        "cfs_operational": rr.get("cfs_operational"), "crash_indicators": rr.get("crash_indicators")})
    # supplementary (not a criterion): outputs vs the E55b copy cell that replayed the same one-sample fixture
    mine = os.path.join(ROOT, "cells", "logs", T7 + ".e25_outputs.bin")
    ref = os.path.join(REPO, "results", "e55b_copy_path", "cells", "logs", "e55b_wgan_copy.e25_outputs.bin")
    if os.path.isfile(mine) and os.path.isfile(ref):
        a, b = open(mine, "rb").read(), open(ref, "rb").read()
        row["supplementary_outputs_bitidentical_to_e55b_copy"] = (a == b)
        row["supplementary_output_bytes"] = [len(a), len(b)]
    else:
        row["supplementary_outputs_bitidentical_to_e55b_copy"] = None
        row["supplementary_unavailable_reason"] = "fetched output file absent" if not os.path.isfile(mine) \
            else "archived E55b output file absent"
    row["holds"] = (row["V_so_matches"] and row["verdict"] == "ADMIT" and row["binding"] == "MATCH"
                    and row["blob_align"]["module_ptr_mod64"] == 0 and row["hal_peak_after_append"] == 0
                    and (row["completed"] or 0) >= 1 and row["final_hal_peak"] == P["wgan"]
                    and row["cfs_operational"] is True and not row["crash_indicators"])
    return row


def table7(t7, gh):
    """Both columns of the manuscript's Table 7 from ONE binary per model: map = E58 offset-0 cells (three models)
    and this T7 cell (WGAN); copy = the E55b copy cells. The binary identity is the guest sha256 at the path both
    loaded (E58 scenarios `so` == E55b scenarios `so`)."""
    e58 = json.load(open(os.path.join(REPO, "results", "e58_alignment_sweep_aarch64", "summary.json")))
    e58_so = {x["model"]: x["so"] for x in json.load(open(os.path.join(REPO, "results", "e58_alignment_sweep_aarch64",
                                                                        "scenarios.json")))}
    e55b_so = {x["model"]: x["so"] for x in json.load(open(os.path.join(REPO, "results", "e55b_copy_path",
                                                                         "scenarios_copy.json")))}
    rows = {}
    for m in MODELS:
        so_rel = "variants/e55b_%s_copy/ai_learner.so" % m
        g = gh.get("/home/ubuntu/e55_run/" + so_rel)
        if m == "wgan":
            map_peak, map_src = t7.get("final_hal_peak"), "E63 " + T7
        else:
            c0 = next(c for c in e58["cells"] if c["model"] == m and c["offset"] == 0)
            map_peak, map_src = c0.get("final_hal_peak_observed"), "E58 " + os.path.basename(c0["log"])
        lp = os.path.join(REPO, "results", "e55b_copy_path", "cells", "logs", "e55b_%s_copy.log" % m)
        mem = last(stages(lp), "mem") or {}
        rows[m] = {"binary_path": so_rel, "e58_used_same_path": e58_so.get(m) == so_rel,
                   "e55b_used_same_path": e55b_so.get(m) == so_rel,
                   "guest_sha256": g, "archived_sha256": tree_hash_e55b(m),
                   "same_binary": (g is not None and g == tree_hash_e55b(m) and e58_so.get(m) == so_rel
                                   and e55b_so.get(m) == so_rel),
                   "map_final_peak": map_peak, "map_source": map_src, "map_eq_P": map_peak == P[m],
                   "copy_final_peak": mem.get("hal_peak"), "copy_source": "E55b " + os.path.basename(lp),
                   "copy_eq_P_plus_C": mem.get("hal_peak") == P[m] + C[m]}
    ok = all(r["same_binary"] and r["map_eq_P"] and r["copy_eq_P_plus_C"] for r in rows.values())
    return {"rows": rows, "one_build_per_model_and_values_hold": ok}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out")
    a = ap.parse_args()
    gh = guest_hashes()
    cf = {m: cf_cell(m, gh) for m in MODELS}
    t7 = t7_cell(gh)
    t = table7(t7, gh)
    q1 = bool(t7["holds"])
    q2 = all(r["holds"] for r in cf.values())
    s = {"experiment": "E63", "plan": PLAN, "plan_commit": PLAN_COMMIT, "generated_by": "harness/mk_e63_summary.py",
         "target": "AArch64 QEMU system guest, cFS AI_LEARNER; no recompilation, no new build",
         "Q1_table7_single_build": {"cell": t7, "holds": q1},
         "Q2_conditional_floor": {"cells": cf, "holds": q2},
         "table7_one_build_per_model": t,
         "verdict": {"Q1": "PASS" if q1 else "FAIL", "Q2": "PASS" if q2 else "FAIL"},
         "not_claimed": [
             "the conditional tier's refusal AFTER module append (a copy arm for a reason other than alignment) -- still not run",
             "latency (the guest is FUNCTIONAL_ONLY); the OnAIR path (E62)",
             "that 'runtime not created' is recorded directly: it is inferred from the absence of mem_init and map_branch "
             "records (D80), as in E56"]}
    out = a.out or os.path.join(ROOT, "summary.json")
    json.dump(s, open(out, "w"), indent=1)
    open(out, "a").write("\n")
    print(json.dumps({"Q1": s["verdict"]["Q1"], "Q2": s["verdict"]["Q2"],
                      "table7": t["one_build_per_model_and_values_hold"]}))


if __name__ == "__main__":
    main()
