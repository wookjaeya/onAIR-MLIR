#!/usr/bin/env python3
"""E55b: judge the four AArch64 cFS copy-path cells and build the map/copy integration table.

The directive (docs/reviews/COPY_MAP_ONAIR_RECOMMENDATION_v0.57.md) fixed both before any cell
ran: SS3.4 is the six-row completion table for a copy cell, SS4 is the four-configuration table
that ties `P`, `C`, `B_u` and `H` together across load paths and admission policies.

Two rules from the directive are structural here, not stylistic:

  * SS3.3, last line -- "분기 이름을 출력한 사실만으로 copy를 확정하지 않는다".  The app derives its
    own `arm` label from `hal_peak_after_append` (ai_learner.c:614), so accepting `arm == "copy"`
    as the evidence would be reading the app's conclusion back as an observation.  This generator
    compares the three independent facts the directive names -- the load setting
    (`module_ptr_mod64`), the post-append constant allocation, and the run result -- and reports
    `arm_label_agrees` separately from them.

  * SS4 -- "기대 결과를 실측 결과로 기입하지 않는다".  Every cell in the integration table is read
    from raw material; archived rows carry `source: "archived"` plus the file they came from, and
    a row whose raw material does not match the configuration it claims is an error, not a note.

Soundness (`H <= P+C`) and tightness (`H == P+C`) are separate fields because the directive says
so: `H < P+C` does not mean the bound is wrong.  `H > P+C` makes the verdict WITHHELD -- the raw
material is kept and no compliance claim is made for that configuration (SS3.4).

Readers are IMPORTED from mk_e36b_summary (E44: a second reader of the same raw material is a
defect; D90 showed what two spellings of the same three figures cost).
"""
import argparse, hashlib, json, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
from mk_e36b_summary import stages  # noqa: E402  (one reader, not two -- E44)


def last(st, name):
    xs = st.get(name) or []
    return xs[-1] if xs else None


def read_cell(log_path):
    """Every field a copy cell is judged on, straight out of the app's own records."""
    if not os.path.isfile(log_path):
        return {"log": os.path.relpath(log_path, REPO), "present": False}
    txt = open(log_path, encoding="utf-8", errors="replace").read()
    st = stages(log_path)
    return {"log": os.path.relpath(log_path, REPO), "present": True,
            "blob_align": last(st, "blob_align"), "build_config": last(st, "build_config"),
            "map_branch": last(st, "map_branch"), "admission": last(st, "admission"),
            "binding": last(st, "binding"), "mem_init": last(st, "mem_init"),
            "e25_equivalence": last(st, "e25_equivalence"), "e25_mode": last(st, "e25_mode"),
            "run": last(st, "run"), "mem": last(st, "mem"),
            "runtime_load_failed": last(st, "runtime_load_failed"),
            "exit": ("EXIT=" + txt.rsplit("EXIT=", 1)[1].split()[0]) if "EXIT=" in txt else None,
            "apps_after": txt.count("Loaded and Registered")}


def f32(path):
    with open(path, "rb") as f:
        b = f.read()
    return list(struct.unpack("<%df" % (len(b) // 4), b[: (len(b) // 4) * 4]))


def compare_outputs(got_path, baseline_path):
    """Element-wise comparison against the archived AArch64 cFS map-arm output.

    Byte equality is the expectation and is reported as such, but a difference is described
    with its worst element rather than collapsed to False: the directive's row is "출력 보존",
    and "differs, worst |d| = x" is a different statement from "did not run"."""
    for p in (got_path, baseline_path):
        if not os.path.isfile(p):
            return {"compared": False, "unavailable_reason": "missing %s" % os.path.relpath(p, REPO)}
    a, b = f32(got_path), f32(baseline_path)
    if len(a) != len(b):
        return {"compared": False, "unavailable_reason": "element counts differ: %d vs %d" % (len(a), len(b))}
    worst = max((abs(x - y) for x, y in zip(a, b)), default=0.0)
    return {"compared": True, "elements": len(a), "bitwise_identical":
            hashlib.sha256(open(got_path, "rb").read()).hexdigest() ==
            hashlib.sha256(open(baseline_path, "rb").read()).hexdigest(),
            "worst_abs_diff": worst,
            "baseline": os.path.relpath(baseline_path, REPO),
            "baseline_note": ("archived AArch64 cFS run on the MAP arm over the same fixture; the "
                              "only difference between the two runs is the module image's load "
                              "alignment")}


def judge_copy(sc, cell, outputs_path):
    P, C, B = sc["e55b"]["P"], sc["e55b"]["C"], sc["e55b"]["B_u"]
    off = sc["e55b"]["align_offset"]
    if not cell["present"]:
        return {"model": sc["model"], "P": P, "C": C, "B_u": B, "verdict": None,
                "unavailable_reason": "copy cell log absent"}
    ba, mb = cell.get("blob_align") or {}, cell.get("map_branch") or {}
    ad, mem = cell.get("admission") or {}, cell.get("mem") or {}
    e25, run = cell.get("e25_equivalence") or {}, cell.get("run") or {}
    H = mem.get("hal_peak")
    loop_done = run.get("completed") if run else mem.get("completed")
    e25_done = e25.get("completed")

    rows = {}
    # SS3.4 row 1 -- load succeeded with a valid module (NOT an alignment-caused module rejection)
    rows["load_ok"] = (bool(mb) and not cell.get("runtime_load_failed"))
    # SS3.4 row 2 -- constants actually copied, and exactly C
    rows["constants_copied_equals_C"] = (mb.get("hal_peak_after_append") == C)
    # SS3.4 row 3 -- at least one inference completed (e25 replay or run loop; both reported)
    rows["ran_at_least_once"] = bool((e25_done or 0) >= 1 or (loop_done or 0) >= 1)
    # SS3.4 row 4 -- soundness
    rows["sound_H_le_P_plus_C"] = (H is not None and H <= B)
    # SS3.4 row 6 -- output preserved against the archived map-arm baseline
    cmpres = compare_outputs(outputs_path, os.path.join(REPO, sc["e55b"]["map_arm_baseline_outputs"]))
    rows["output_preserved"] = cmpres.get("bitwise_identical") if cmpres.get("compared") else None

    # SS3.3 -- the load setting is an INDEPENDENT fact from the app's own arm label
    mod64 = mb.get("module_ptr_mod64")
    load_setting = {"requested_offset": ba.get("requested_offset"), "state": ba.get("state"),
                    "module_ptr_mod64": mod64,
                    "offset_reached_the_image": (mod64 == off % 64),
                    "note": ("the app allocates the image 64-byte aligned and returns base+offset, so "
                             "mod64 must equal the requested offset; when posix_memalign fails it "
                             "falls back to malloc and mod64 is whatever the allocator gave -- which "
                             "is why this is measured, not assumed")}
    copy_arm_confirmed_independently = (load_setting["offset_reached_the_image"] is True
                                        and mod64 not in (0, None)
                                        and rows["constants_copied_equals_C"] is True
                                        and rows["ran_at_least_once"] is True)

    core = [rows[k] for k in ("load_ok", "constants_copied_equals_C", "ran_at_least_once", "sound_H_le_P_plus_C")]
    if H is not None and H > B:
        verdict = "WITHHELD"          # SS3.4: preserve the raw material, make no compliance claim
    elif all(v is True for v in core) and copy_arm_confirmed_independently:
        verdict = "PASS" if rows["output_preserved"] is not False else "FAIL"
    else:
        verdict = "FAIL"
    return {"model": sc["model"], "P": P, "C": C, "B_u": B,
            "criteria_SS3_4": rows,
            "tight_H_eq_P_plus_C": (H == B) if H is not None else None,
            "tightness_note": ("recorded separately from soundness on the directive's instruction: "
                               "H < P+C does not mean the bound is wrong"),
            "load_setting_SS3_3": load_setting,
            "copy_arm_confirmed_independently": copy_arm_confirmed_independently,
            "arm_label_agrees": (mb.get("arm") == "copy"),
            "arm_label_note": ("the app derives `arm` from hal_peak_after_append itself, so it is "
                               "reported beside the independent facts, never in place of them "
                               "(directive SS3.3)"),
            "observed": {"hal_peak": H, "hal_peak_after_append": mb.get("hal_peak_after_append"),
                         "mem_init_hal_peak": (cell.get("mem_init") or {}).get("hal_peak"),
                         "admission": ad.get("verdict"), "admitted_budget": mem.get("admitted_budget_bytes"),
                         "admission_mode": mem.get("admission_mode"),
                         "peak_within_admitted_budget": mem.get("peak_within_admitted_budget"),
                         "e25_inputs": e25.get("inputs"), "e25_completed": e25_done,
                         "loop_completed": loop_done,
                         "max_active_calls": mem.get("max_active_calls"),
                         "call_counter_balanced": mem.get("call_counter_balanced"),
                         "artifact_sha256_prefix": e25.get("artifact_sha256")},
            "output_comparison": cmpres,
            "verdict": verdict}


ARCHIVED_MAP_BU = {   # SS4 row 1: unconditional + map at M = B_u, already measured
    "b2_resnet": "results/e48_real_inputs_aarch64/cfs/logs/b2_resnet_admit_B_real.log",
    "b3_deepae": "results/e48_real_inputs_aarch64/cfs/logs/b3_deepae_admit_B_real.log",
    "smartcam":  "results/e48_real_inputs_aarch64/cfs/logs/smartcam_admit_B_real.log",
    "wgan":      "results/e53_wgan_aarch64/cfs/logs/cfs_B.log",
}
E55_CELLS = "results/e55_mandatory_followups/cells/p0_4/logs"


def config_row(name, model, cell, want, P, C, B, source, log):
    """One SS4 row, with the configuration VERIFIED against the raw material, never asserted."""
    mb, mem = cell.get("map_branch") or {}, cell.get("mem") or {}
    ad = cell.get("admission") or {}
    got = {"arm": mb.get("arm"), "admission_mode": mem.get("admission_mode"),
           "admitted_budget": mem.get("admitted_budget_bytes"), "verdict": ad.get("verdict")}
    H = mem.get("hal_peak")
    mismatch = [k for k, v in want.items() if v is not None and got.get(k) != v]
    return {"configuration": name, "model": model, "source": source, "log": log,
            "expected_configuration": want, "observed_configuration": got,
            "configuration_matches": not mismatch,
            "configuration_mismatch": mismatch or None,
            "P": P, "C": C, "B_u": B, "budget_M": got["admitted_budget"], "H": H,
            "H_le_budget": (H is not None and got["admitted_budget"] is not None
                            and H <= got["admitted_budget"]),
            "H_eq_P": (H == P) if H is not None else None,
            "H_eq_P_plus_C": (H == B) if H is not None else None,
            "inferences": (cell.get("run") or {}).get("completed") or mem.get("completed"),
            "max_active_calls": mem.get("max_active_calls")}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scenarios", default="results/e55b_copy_path/scenarios_copy.json")
    ap.add_argument("--cells", default="results/e55b_copy_path/cells/logs")
    ap.add_argument("--out", default="results/e55b_copy_path/summary.json")
    a = ap.parse_args()
    scs = json.load(open(os.path.join(REPO, a.scenarios), encoding="utf-8"))
    rows, table = [], []
    for sc in scs:
        m = sc["model"]
        log = os.path.join(REPO, a.cells, "%s.log" % sc["id"])
        outb = os.path.join(REPO, a.cells, "%s.e25_outputs.bin" % sc["id"])
        cell = read_cell(log)
        rows.append({"cell": cell, **judge_copy(sc, cell, outb)})
        P, C, B = sc["e55b"]["P"], sc["e55b"]["C"], sc["e55b"]["B_u"]

        arch = os.path.join(REPO, ARCHIVED_MAP_BU[m])
        table.append(config_row("unconditional_map_at_Bu", m, read_cell(arch),
                                {"arm": "map", "admission_mode": "unconditional", "admitted_budget": B,
                                 "verdict": "ADMIT"}, P, C, B, "archived", ARCHIVED_MAP_BU[m]))
        table.append(config_row("unconditional_copy_at_Bu", m, cell,
                                {"arm": "copy", "admission_mode": "unconditional", "admitted_budget": B,
                                 "verdict": "ADMIT"}, P, C, B, "measured_here",
                                os.path.relpath(log, REPO)))
        condp = os.path.join(REPO, E55_CELLS, "e55_%s_conditional.log" % m)
        table.append(config_row("conditional_map_at_P", m, read_cell(condp),
                                {"arm": "map", "admission_mode": "conditional_map", "admitted_budget": P,
                                 "verdict": "ADMIT_CONDITIONAL_MAP"}, P, C, B, "archived_e55",
                                os.path.relpath(condp, REPO)))
        ctlp = os.path.join(REPO, E55_CELLS, "e55_%s_control.log" % m)
        ctl = read_cell(ctlp)
        table.append({"configuration": "conditional_disabled_control_at_P", "model": m,
                      "source": "archived_e55", "log": os.path.relpath(ctlp, REPO),
                      "expected_configuration": {"verdict": "NOT_ADMITTED"},
                      "observed_configuration": {"verdict": (ctl.get("admission") or {}).get("verdict")},
                      "configuration_matches": (ctl.get("admission") or {}).get("verdict") == "NOT_ADMITTED",
                      "configuration_mismatch": None, "P": P, "C": C, "B_u": B,
                      "budget_M": P, "H": None, "H_le_budget": None, "H_eq_P": None,
                      "H_eq_P_plus_C": None,
                      "inferences": 0 if ctl.get("mem_init") is None else None,
                      "runtime_created": bool(ctl.get("mem_init")) if ctl["present"] else None,
                      "max_active_calls": None,
                      "note": ("P < B_u for every model here, so refusing is the correct behaviour of "
                               "the unconditional policy; the cell exists to make the conditional "
                               "cell's pass attributable to the tier and not to a loose budget")})

    verdicts = [r.get("verdict") for r in rows]
    doc = {"experiment": "E55b", "item": "AArch64 cFS copy path + map/copy integration",
           "directive": "docs/reviews/COPY_MAP_ONAIR_RECOMMENDATION_v0.57.md SS3-SS4",
           "plan": "docs/plans/E55b_copy_path_aarch64.md",
           "design": ("Per model one new cell: the SAME AArch64 vmfb and contract, the SAME fixture as "
                      "an archived map-arm cFS run, UNCONDITIONAL admission at M = B_u, and exactly one "
                      "changed variable -- AI_LEARNER_BLOB_ALIGN_OFFSET moves the module image off the "
                      "64-byte class so try_map's import is refused and the copy arm runs. No "
                      "recompilation (0 iree-compile calls); the app knob is fail-closed and refuses "
                      "outright when the conditional tier is enabled (plan SS2.1)."),
           "models": rows, "integration_table_SS4": table,
           "verdict": ("PASS" if verdicts and all(v == "PASS" for v in verdicts)
                       else ("WITHHELD" if "WITHHELD" in verdicts else "INCOMPLETE_OR_FAIL")),
           "not_claimed": [
             "that repeated-call long-term lifetime is verified -- four cells do not establish that "
             "(directive SS3.4, last paragraph)",
             "any change to DeepAE's TFLite numerical-equivalence FAIL (D74): the map/copy output "
             "comparison here is between two IREE runs on the same target, which is a different "
             "comparison from the original-TFLite one (directive SS4)",
             "that the copy arm is what any real deployment lands on -- E29 established that the arm "
             "follows the module image's 64-byte alignment, and this cell CONTROLS that alignment on "
             "purpose rather than reporting a deployment's natural behaviour",
             "process RSS or whole-system RAM: every figure here is HAL device-allocation scope (D78)",
           ]}
    with open(os.path.join(REPO, a.out), "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=1)
        f.write("\n")
    for r in rows:
        o = r.get("observed") or {}
        print("%-11s %-9s P+C=%-13s H=%-13s after_append=%-11s mod64=%-4s e25=%s/%s loop=%s out=%s"
              % (r["model"], r.get("verdict"), "{:,}".format(r["B_u"]),
                 "{:,}".format(o["hal_peak"]) if o.get("hal_peak") else "-",
                 "{:,}".format(o["hal_peak_after_append"]) if o.get("hal_peak_after_append") else "-",
                 (r.get("load_setting_SS3_3") or {}).get("module_ptr_mod64"),
                 o.get("e25_completed"), o.get("e25_inputs"), o.get("loop_completed"),
                 (r.get("output_comparison") or {}).get("bitwise_identical")))
    print("verdict:", doc["verdict"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
