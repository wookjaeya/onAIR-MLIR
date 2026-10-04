#!/usr/bin/env python3
"""E55/P0-4: judge the four-model conditional AArch64 cFS cells against the directive's
eight completion criteria, reading ONLY what the app itself recorded.

The directive (MANDATORY_FOLLOWUPS_v0.57_RECOMMENDATION.md SS5) fixed the criteria before any
cell ran, and the pre-registered plan (docs/plans/E55_mandatory_followups.md SS4.3) copied them
verbatim.  This generator does not restate them in its own words: each criterion below names
the raw record that answers it, and a criterion with no record is `null` with a reason -- never
False, which would read as "checked and contradicted" (D29/D51/D68).

Readers are IMPORTED from mk_e36b_summary rather than re-implemented: the repository counts a
second reader of the same raw material as a defect (E44), and D90 showed what happens when two
generators spell the same three figures differently.
"""
import argparse, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mk_e36b_summary import stages  # noqa: E402,PLC0415  (one reader, not two -- E44)

MODELS = ["b2_resnet", "b3_deepae", "smartcam", "wgan"]


def last(st, name):
    xs = st.get(name) or []
    return xs[-1] if xs else None


def cell(log_path):
    if not os.path.isfile(log_path):
        return {"log": log_path, "present": False}
    txt = open(log_path, encoding="utf-8", errors="replace").read()
    st = stages(log_path)          # stages() takes a PATH, not the text (checked, not assumed)
    return {"log": os.path.relpath(log_path, os.path.dirname(HERE)), "present": True,
            "build_config": last(st, "build_config"), "map_branch": last(st, "map_branch"),
            "admission": last(st, "admission"), "binding": last(st, "binding"),
            "mem_init": last(st, "mem_init"), "run": last(st, "run"), "mem": last(st, "mem"),
            "e25_mode": last(st, "e25_mode"),
            "exit": ("EXIT=" + txt.rsplit("EXIT=", 1)[1].split()[0]) if "EXIT=" in txt else None,
            "apps_after": txt.count("Loaded and Registered")}


def judge(model, ctrl, cond, P):
    """The eight criteria of directive SS5, each answered by a named raw record."""
    c = {}
    # control cell: the conditional tier is what makes the conditional cell's pass attributable
    c["control_refused"] = (ctrl.get("admission") or {}).get("verdict") == "NOT_ADMITTED" if ctrl["present"] else None
    c["control_no_runtime"] = (ctrl.get("mem_init") is None) if ctrl["present"] else None
    if not cond["present"]:
        return {"model": model, "P": P, "criteria": c,
                "verdict": None, "unavailable_reason": "conditional cell log absent"}
    bc, mb = cond.get("build_config") or {}, cond.get("map_branch") or {}
    ad, mem = cond.get("admission") or {}, cond.get("mem") or {}
    run = cond.get("run") or {}
    c["1_optin_recorded_before_verdict"] = bc.get("allow_conditional_map") == 1
    c["2_module_ptr_64B_aligned"] = mb.get("module_ptr_mod64") == 0
    c["3_no_copy_arm_alloc_after_append"] = mb.get("hal_peak_after_append") == 0
    c["4_verdict_admit_conditional_map"] = ad.get("verdict") == "ADMIT_CONDITIONAL_MAP"
    completed = run.get("completed") if run else mem.get("completed")
    c["5_at_least_one_inference"] = (completed is not None and completed >= 1)
    peak = mem.get("hal_peak")
    c["6_hal_peak_within_P"] = (peak is not None and peak <= P)
    mac = mem.get("max_active_calls")
    c["7_max_active_calls_is_1"] = (mac == 1) if mac is not None else None
    # 8: output agreement with the archived AArch64 baseline is a separate axis; this cell
    #    replays SB telemetry bytes, not the fixture, so it is recorded as not-evaluated here
    #    rather than asserted (E48/E36b own that comparison).
    c["8_output_baseline"] = None
    vals = [v for k, v in c.items() if k.startswith(("1_", "2_", "3_", "4_", "5_", "6_", "7_"))]
    return {"model": model, "P": P, "criteria": c,
            "observed": {"hal_peak": peak, "admitted_budget": mem.get("admitted_budget_bytes"),
                         "admission_mode": mem.get("admission_mode"), "arm": mb.get("arm"),
                         "completed": completed, "max_active_calls": mac,
                         "call_counter_balanced": mem.get("call_counter_balanced"),
                         "out_elems": run.get("out_elems"), "out_sha256": run.get("out_sha256"),
                         "out_full_file": run.get("out_full_file"),
                         "out_full_file_reason": run.get("out_full_file_reason"),
                         "out_record_truncates": run.get("out_record_truncates")},
            "verdict": "PASS" if all(v is True for v in vals) else "FAIL",
            "criterion_8_note": ("output agreement against the archived AArch64 baseline is E48/E36b's "
                                 "axis and is not re-derived here; this cell replays SB telemetry bytes, "
                                 "not the semantic fixture")}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cells", default="results/e55_mandatory_followups/cells/p0_4/logs")
    ap.add_argument("--contracts", default="results/e55_mandatory_followups/scenarios_p0_4.json")
    ap.add_argument("--out", default="results/e55_mandatory_followups/p0_4_summary.json")
    a = ap.parse_args()
    repo = os.path.dirname(HERE)
    P = {"b2_resnet": 309416, "b3_deepae": 6208, "smartcam": 9382092, "wgan": 131382784}
    rows = []
    for m in MODELS:
        ctrl = cell(os.path.join(repo, a.cells, "e55_%s_control.log" % m))
        cond = cell(os.path.join(repo, a.cells, "e55_%s_conditional.log" % m))
        rows.append({"cells": {"control": ctrl, "conditional": cond}, **judge(m, ctrl, cond, P[m])})
    doc = {"experiment": "E55", "item": "P0-4",
           "directive": "docs/reviews/MANDATORY_FOLLOWUPS_v0.57_RECOMMENDATION.md SS5",
           "plan": "docs/plans/E55_mandatory_followups.md SS4",
           "design": ("Per model, two cells differing ONLY in the compile-time knob "
                      "AI_LEARNER_ALLOW_CONDITIONAL_MAP (0 vs 1). Both are admitted against the SAME "
                      "budget P = static_per_call_bytes, injected at run time via "
                      "AI_LEARNER_BUDGET_OVERRIDE. The compile-time budget is bounded+1 in both trees, "
                      "because building with a budget below `bounded` lets the compiler fold the "
                      "admission failure statically and dead-code-eliminate the rest (CLAUDE.md's "
                      "trap table) -- E36 established the runtime-override route for exactly this."),
           "models": rows,
           "verdict": "PASS" if all(r.get("verdict") == "PASS" for r in rows) else "INCOMPLETE_OR_FAIL",
           "not_claimed": [
             "output semantic equivalence for these cells -- they replay SB telemetry bytes, not the "
             "E31/E48 fixture; criterion 8 is recorded as null, not as a pass",
             "that the conditional tier is worth enabling for every model -- E46 measured the gain as "
             "a function of the constant share (WGAN 1.03x is the floor)",
             "any change to DeepAE's TFLite numerical-equivalence FAIL (D74): a conditional memory "
             "verdict is not evidence about numerics, and the directive says so explicitly",
           ]}
    with open(os.path.join(repo, a.out), "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=1)
        f.write("\n")
    for r in rows:
        o = r.get("observed") or {}
        print("%-11s %-6s P=%-12s peak=%-12s arm=%-5s inf=%-5s max_active=%s"
              % (r["model"], r.get("verdict"), "{:,}".format(r["P"]),
                 "{:,}".format(o["hal_peak"]) if o.get("hal_peak") else "-",
                 o.get("arm"), o.get("completed"), o.get("max_active_calls")))
    print("verdict:", doc["verdict"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
