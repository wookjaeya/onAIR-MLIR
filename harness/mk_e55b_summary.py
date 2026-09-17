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
import argparse, hashlib, json, os, re, struct, subprocess, sys

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
        # D55: a `"log"` field is a CITATION -- the guard reads it as "here is the raw log".
        # A cell that has not run yet has no raw log to cite, so the path goes under a
        # different key: it is an EXPECTATION, not a record. (Found by the guard itself while
        # this experiment's four cells were landing one at a time.)
        return {"expected_log": os.path.relpath(log_path, REPO), "present": False,
                "absent_reason": "cell has not produced a log yet"}
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


# The cell whose OUTPUT bytes each copy cell is compared against.  This is NOT the same set of
# cells as ARCHIVED_MAP_BU below: three of the four output baselines are the archived e25 replay
# cells, and only wgan's happens to be the same log as its SS4 row-1 source.  The claim that these
# baselines ran on the MAP arm was prose in the first version of this file -- a derived statement
# shipped without the derivation (D77).  It is now READ from each baseline's own log.
OUTPUT_BASELINE_LOG = {
    "b2_resnet": "results/e36b_aarch64_models/cfs/resnet_equiv.log",
    "b3_deepae": "results/e36b_aarch64_models/cfs/deepae_equiv.log",
    "smartcam":  "results/e37_evidence_consolidation/s_cfs_post_d61/s_cfs_equiv.log",
    "wgan":      "results/e53_wgan_aarch64/cfs/logs/cfs_B.log",
}


def baseline_arm(model):
    """Read the output baseline's OWN map_branch record instead of asserting its arm.

    Returns the three independent facts (mod64, post-append allocation, the app's own label) plus
    the derived verdict.  When the log is missing the answer is `null` with a reason, never a
    silent `false` (D29/D51/D68) -- "could not look" is not "looked and it was not map"."""
    rel = OUTPUT_BASELINE_LOG.get(model)
    if not rel:
        return {"observed": None, "unavailable_reason": "no baseline log registered for %s" % model}
    f = os.path.join(REPO, rel)
    if not os.path.isfile(f):
        return {"observed": None, "unavailable_reason": "missing %s" % rel}
    mb = (read_cell(f).get("map_branch") or {})
    if not mb:
        return {"observed": None, "log": rel,
                "unavailable_reason": "the baseline log carries no map_branch record"}
    return {"observed": True, "log": rel,
            "module_ptr_mod64": mb.get("module_ptr_mod64"),
            "hal_peak_after_append": mb.get("hal_peak_after_append"),
            "arm_label": mb.get("arm"),
            "admission_mode": mb.get("admission_mode"),
            # map arm allocates NOTHING on append; copy allocates exactly C.  Requiring 0 (not
            # "!= C") keeps the test independent of the label the app itself wrote.
            "is_map_arm": (mb.get("module_ptr_mod64") == 0
                           and mb.get("hal_peak_after_append") == 0)}


def compare_outputs(got_path, baseline_path, model):
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
            "baseline_arm_observed": baseline_arm(model),
            "baseline_note": ("archived AArch64 cFS run over the same fixture; whether it ran on "
                              "the MAP arm is READ from its own map_branch record in "
                              "`baseline_arm_observed`, not asserted here")}


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
    cmpres = compare_outputs(outputs_path,
                             os.path.join(REPO, sc["e55b"]["map_arm_baseline_outputs"]),
                             sc["model"])
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
    row = {"configuration": name, "model": model, "source": source}
    # Same D55 rule as read_cell: only a log that exists is cited under `"log"`.
    row["log" if (log and os.path.isfile(os.path.join(REPO, log))) else "expected_log"] = log
    return {**row,
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


CONTRACTS = {   # the deployed AArch64 contract each cell was admitted against
    "b2_resnet": "results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json",
    "b3_deepae": "results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json",
    "smartcam":  "results/e32_smartcam_aarch64/build/smartcam.contract.json",
    "wgan":      "results/e53_wgan_aarch64/build/aarch64/wgan.contract.json",
}


def _input_bytes(model):
    """Input tensor bytes, read from the contract's declared interface (f32)."""
    p = os.path.join(REPO, CONTRACTS[model])
    if not os.path.isfile(p):
        return None
    itf = (json.load(open(p, encoding="utf-8")).get("interface") or {}).get("input") or {}
    if itf.get("dtype") != "f32" or not itf.get("shape"):
        return None
    n = 1
    for x in itf["shape"]:
        n *= int(x)
    return n * 4


def mem_init_relation():
    """D96: `mem_init.hal_peak == hal_peak_after_append + input_bytes` is an IDENTITY, not a finding.

    E55b SS5 wrote that relation down before the copy cells ran and all four then matched it to the
    byte.  An exact match across four models is the moment to ask whether the match could have come
    out otherwise -- E35's rule, which D72 extended to the case where NO difference appears.  It
    could not:

      * `device_bytes_peak` is a high-water mark, never reset:
        `statistics->device_bytes_peak = iree_max(peak, allocated - freed)` (IREE allocator.h:777).
      * Both records read that same field of the same session allocator (ai_learner.c ~610 and ~659).
      * Between the two reads the app makes exactly one device allocation -- the input buffer,
        `CONTRACT_INPUT_ELEMS` f32 -- and frees nothing.

    So the second reading is forced to be the first plus the input bytes.  This function MEASURES
    that over every archived cell carrying both records, on both arms, and the point of publishing
    it is to stop the match being re-read later as independent confirmation of the copy arm.
    What the four matches do support is narrower and still worth having: the instrumentation is
    self-consistent and the input buffer is the only device allocation in that window."""
    import glob as _glob
    ra = re.compile(r'\{"app":"AI_LEARNER","stage":"map_branch"[^}]*\}')
    rm = re.compile(r'\{"app":"AI_LEARNER","stage":"mem_init"[^}]*\}')
    per = {}
    for f in sorted(_glob.glob(os.path.join(REPO, "results", "**", "*.log"), recursive=True)):
        txt = open(f, encoding="utf-8", errors="replace").read()
        a, m = ra.findall(txt), rm.findall(txt)
        if not a or not m:
            continue
        try:
            A, M = json.loads(a[-1]), json.loads(m[-1])
        except Exception:                                                # noqa: BLE001
            continue
        if "hal_peak_after_append" not in A or "hal_peak" not in M:
            continue
        e = per.setdefault(M.get("model"), {"deltas": set(), "arms": set(), "cells": 0})
        e["deltas"].add(M["hal_peak"] - A["hal_peak_after_append"])
        e["arms"].add(A.get("arm"))
        e["cells"] += 1
    models = {}
    for mdl, e in sorted(per.items()):
        ib = _input_bytes(mdl) if mdl in CONTRACTS else None
        models[mdl] = {"cells": e["cells"], "distinct_deltas": sorted(e["deltas"]),
                       "arms_seen": sorted(x for x in e["arms"] if x),
                       "contract_input_bytes": ib,
                       "delta_equals_input_bytes": (len(e["deltas"]) == 1 and ib is not None
                                                    and next(iter(e["deltas"])) == ib)}
    return {
      "relation": "mem_init.hal_peak == hal_peak_after_append + input_bytes",
      "status": "identity_by_construction",
      "mechanism": ["IREE allocator.h:777 device_bytes_peak = max(peak, allocated - freed) "
                    "-- a high-water mark that is never reset",
                    "both records read that same field of the same session allocator "
                    "(ai_learner.c: post-append read, then the mem_init read)",
                    "between the two reads the app allocates exactly one device buffer (the input, "
                    "CONTRACT_INPUT_ELEMS f32) and frees nothing"],
      "measured_over_every_archived_cell_with_both_records": models,
      "total_cells": sum(v["cells"] for v in models.values()),
      "is_not_evidence_for": ("which try_map arm ran. The delta is the same on both arms (see "
                              "arms_seen), so the relation cannot discriminate them; the copy arm "
                              "is established by hal_peak_after_append == C and by the end-of-run "
                              "H = P+C contrast against the archived map cells"),
      "is_evidence_for": ("instrumentation self-consistency: the input buffer is the only device "
                          "allocation between the two readings, and nothing is freed there"),
      "prediction_note": ("EVIDENCE_v0.59_E55b SS5 committed the four values before the cells ran "
                          "(commit c1aaf32) and they matched. That ordering is real, but a "
                          "pre-registered ARITHMETIC CONSEQUENCE is not a pre-registered "
                          "observation -- and a copy-arm cell carrying the same relation "
                          "(results/e29b_conditional_verify/cfs/"
                          "bigact_before_fix_condmap_shim_FAILOPEN.log: 14016 + 4096 = 18112) was "
                          "already committed at that point, four days earlier"),
    }

# D97 (found by adversarial verification of E55b itself).  "the only difference between the two
# runs is the module image's load alignment" is FALSE as written: the copy cells are built from
# today's ai_learner.c, while each output baseline was built from the commit that archived it.
# The alignment offset is the only changed SETTING, but the binary differs too -- and one of the
# intervening commits (330c4f3, D75) changed `float yv[]` to `static float yv[]` INSIDE the e25
# replay loop that writes the very outputs being compared.  That does not weaken the comparison
# (the outputs came out bit-identical, which is the stronger result), but the claim has to say
# what was actually held fixed: the vmfb, the contract, the fixture bytes, the budget and the
# admission mode -- not the app binary.
APP_SRC = "native/cfs_app/fsw/src/ai_learner.c"
BASELINE_BUILD_COMMIT = {   # the commit that archived each output baseline
    "b2_resnet": ("b6c778f", "E36b"),
    "b3_deepae": ("b6c778f", "E36b"),
    "smartcam":  ("6598cf4", "E37"),
    "wgan":      ("788234c", "E53"),
}


def _git(*argv):
    try:
        r = subprocess.run(["git"] + list(argv), cwd=REPO, capture_output=True, text=True)
    except OSError as e:                                                 # noqa: BLE001
        return None, "git unavailable: %s" % e
    if r.returncode != 0:
        return None, (r.stderr or "").strip()[:160]
    return r.stdout, None


def changed_variable_scope():
    """MEASURE how far the app source moved since each baseline instead of asserting it did not.

    When the checkout has no history (a shallow CI clone) the answer is `null` WITH a reason --
    "could not look" is not "looked and it was the same" (D29/D51/D68)."""
    held_fixed = ["AArch64 vmfb (same sha256 as the baseline cell's)", "contract (P, C, B_u)",
                  "e25 fixture bytes (sha256 declared in the scenario)", "budget M = B_u",
                  "admission mode (unconditional)"]
    per = []
    for m, (commit, exp) in BASELINE_BUILD_COMMIT.items():
        out, err = _git("diff", "--numstat", commit, "--", APP_SRC)
        if out is None:
            per.append({"model": m, "baseline_built_at": commit, "baseline_experiment": exp,
                        "app_source_delta": None, "unavailable_reason": err})
            continue
        parts = out.split()
        ins, dele = (int(parts[0]), int(parts[1])) if len(parts) >= 2 else (0, 0)
        log, _ = _git("log", "--oneline", "%s..HEAD" % commit, "--", APP_SRC)
        per.append({"model": m, "baseline_built_at": commit, "baseline_experiment": exp,
                    "app_source_delta": {"insertions": ins, "deletions": dele,
                                         "commits": len([l for l in (log or "").splitlines() if l])},
                    "command": "git diff --numstat %s -- %s" % (commit, APP_SRC)})
    return {
      "the_only_changed_setting": "AI_LEARNER_BLOB_ALIGN_OFFSET (0 -> 8)",
      "held_fixed": held_fixed,
      "NOT_held_fixed": (
          "the app binary. Each baseline was built from the commit that archived it; the copy "
          "cells are built from today's source. One intervening commit (330c4f3, D75) changed "
          "`float yv[]` to `static float yv[]` inside the e25 replay loop that writes the compared "
          "outputs, so the comparison spans a real code change, not only an alignment change."),
      "why_this_does_not_weaken_the_result": (
          "the outputs came out BIT-IDENTICAL across that span, which is a stronger statement than "
          "bit-identical across an otherwise-frozen binary would be. What cannot be written is "
          "'the only difference between the two runs is the alignment'."),
      "per_model": per,
    }


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
                                os.path.relpath(log, REPO) if cell["present"] else None))
        condp = os.path.join(REPO, E55_CELLS, "e55_%s_conditional.log" % m)
        table.append(config_row("conditional_map_at_P", m, read_cell(condp),
                                {"arm": "map", "admission_mode": "conditional_map", "admitted_budget": P,
                                 "verdict": "ADMIT_CONDITIONAL_MAP"}, P, C, B, "archived_e55",
                                os.path.relpath(condp, REPO)))
        ctlp = os.path.join(REPO, E55_CELLS, "e55_%s_control.log" % m)
        ctl = read_cell(ctlp)
        # D98: this row used to assert its budget (hardcoded P) and verify only the verdict.
        # That is the circularity E38/D69 exists to prevent -- a refusing cell emits the same
        # NOT_ADMITTED whether or not the conditional knob was on, so reading the verdict to
        # learn the setting and then citing the verdict as evidence about the setting proves
        # nothing.  The app already records the setting BEFORE any gate (`build_config`), and
        # the admission record already carries the real budget; both are now read.
        cbc, cad = ctl.get("build_config") or {}, ctl.get("admission") or {}
        want_ctl = {"verdict": "NOT_ADMITTED", "allow_conditional_map": 0, "budget": P}
        got_ctl = {"verdict": cad.get("verdict"),
                   "allow_conditional_map": cbc.get("allow_conditional_map"),
                   "budget": cad.get("budget")}
        mism_ctl = [k for k, v in want_ctl.items() if got_ctl.get(k) != v]
        table.append({"configuration": "conditional_disabled_control_at_P", "model": m,
                      "source": "archived_e55",
                      ("log" if os.path.isfile(ctlp) else "expected_log"): os.path.relpath(ctlp, REPO),
                      "expected_configuration": want_ctl,
                      "observed_configuration": got_ctl,
                      "configuration_matches": not mism_ctl and ctl["present"],
                      "configuration_mismatch": mism_ctl or None, "P": P, "C": C, "B_u": B,
                      "budget_M": cad.get("budget"), "H": None, "H_le_budget": None, "H_eq_P": None,
                      "H_eq_P_plus_C": None,
                      "inferences": 0 if ctl.get("mem_init") is None else None,
                      "runtime_created": bool(ctl.get("mem_init")) if ctl["present"] else None,
                      "max_active_calls": None,
                      "opt_in_source": ("build_config record, emitted before every gate (E38/D69) "
                                        "-- NOT inferred from the verdict"),
                      "note": ("P < B_u for every model here, so refusing is the correct behaviour of "
                               "the unconditional policy; the cell exists to make the conditional "
                               "cell's pass attributable to the tier and not to a loose budget")})

    # Plan SS5 fixed four falsification conditions BEFORE measurement. Record whether each one
    # fired, per cell, rather than leaving "none of them happened" implicit -- a pre-registered
    # falsifier that is never mentioned again is indistinguishable from one that was forgotten.
    falsifiers = []
    for sc, r in zip(scs, rows):
        c = r.get("cell") or {}
        if not c.get("present"):
            continue
        mb, mem = c.get("map_branch") or {}, c.get("mem") or {}
        ls = r.get("load_setting_SS3_3") or {}
        falsifiers.append({
          "model": r["model"],
          "F1_offset_requested_but_mod64_zero": (ls.get("requested_offset", 0) > 0
                                                 and mb.get("module_ptr_mod64") == 0),
          # F2 is NEARLY vacuous and it is recorded as such rather than counted as a test that
          # passed (D72's shape: a `false` the producing code structurally guarantees).
          # ai_learner.c:614-615 writes `arm` FROM hal_peak_after_append -- "copy" is emitted only
          # when that value already equals CONTRACT_CONST_BYTES -- so the app cannot write "copy"
          # beside a mismatched allocation.  The one way it can still fire is if the SCENARIO's
          # declared C disagrees with the C compiled into the header: a real condition, but a
          # different one from "the copy arm did not actually run".  The non-vacuous form of that
          # question is SS3.4's constants_copied_equals_C, which never reads the label.
          "F2_arm_says_copy_but_after_append_is_not_C": (mb.get("arm") == "copy"
                                                         and mb.get("hal_peak_after_append") != r["C"]),
          "F3_module_append_failed": bool(c.get("runtime_load_failed")) or not mb,
          "F4_H_exceeds_P_plus_C": (mem.get("hal_peak") is not None
                                    and mem["hal_peak"] > r["B_u"]),
        })
    any_fired = [ (f["model"], k) for f in falsifiers for k, v in f.items()
                  if k != "model" and v is True ]

    verdicts = [r.get("verdict") for r in rows]
    doc = {"experiment": "E55b", "item": "AArch64 cFS copy path + map/copy integration",
           "directive": "docs/reviews/COPY_MAP_ONAIR_RECOMMENDATION_v0.57.md SS3-SS4",
           "plan": "docs/plans/E55b_copy_path_aarch64.md",
           "design": ("Per model one new cell: the SAME AArch64 vmfb and contract, the SAME fixture as "
                      "an archived map-arm cFS run, UNCONDITIONAL admission at M = B_u, and exactly one "
                      "changed SETTING -- AI_LEARNER_BLOB_ALIGN_OFFSET moves the module image off the "
                      "64-byte class so try_map's import is refused and the copy arm runs. No "
                      "recompilation (0 iree-compile calls); the app knob is fail-closed and refuses "
                      "outright when the conditional tier is enabled (plan SS2.1). The app BINARY is "
                      "not held fixed against the archived baselines -- see changed_variable_scope."),
           "changed_variable_scope": changed_variable_scope(),
           "models": rows, "integration_table_SS4": table,
           "mem_init_relation_SS5": mem_init_relation(),
           "falsification_conditions_SS5": {
             "source": "docs/plans/E55b_copy_path_aarch64.md SS5, fixed before measurement",
             "per_cell": falsifiers,
             "fired": any_fired,
             "note": ("each condition is evaluated per cell and reported whether or not it fired; "
                      "an unfired pre-registered falsifier that is never mentioned again cannot be "
                      "told apart from a forgotten one"),
             "F2_is_near_vacuous": (
                 "ai_learner.c:614-615 derives `arm` from hal_peak_after_append, so the app cannot "
                 "emit `copy` beside a value other than CONTRACT_CONST_BYTES: F2 false is "
                 "structurally guaranteed within one cell and is NOT evidence that the copy arm "
                 "ran (D72's shape). It can still fire when the scenario's declared C disagrees "
                 "with the header's, which is a different condition. The non-vacuous check is "
                 "criteria_SS3_4.constants_copied_equals_C, which compares the measurement with "
                 "the contract and never reads the label.")},
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
