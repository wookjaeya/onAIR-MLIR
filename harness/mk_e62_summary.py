#!/usr/bin/env python3
"""E62 summary: the OnAIR output-buffer retention (D103), fixed and enforced, on the evaluation target.

Plan: docs/plans/E62_onair_output_release.md (commit 046a7af, before any cell). Criteria P1-P9 and
falsifiers F1-F6 are the plan's SS4-SS5. Every value is read from what the guest wrote: the probe's
own JSON (results/e62_onair_output_release/probe/), and for each OnAIR cell the plugin's
plugin_records.jsonl and harness/onair_integration_check.py's run.json. The E57 comparison side is
the ARCHIVED E57 cell records (same wheel, artifact, fixture, telemetry, budget); nothing is
transcribed from prose.
"""
import argparse
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
ROOT = os.path.join(REPO, "results", "e62_onair_output_release")
E57 = os.path.join(REPO, "results", "e57_onair_aarch64", "cells")
CONFIG = os.path.join(REPO, "configs", "deployments", "onair_deployments_e62_aarch64.json")
PLAN = "docs/plans/E62_onair_output_release.md"
PLAN_COMMIT = "046a7af"
MODELS = ("b2_resnet", "b3_deepae", "smartcam", "wgan")
P = {"b2_resnet": 309416, "b3_deepae": 6208, "smartcam": 9382092, "wgan": 131382784}
O = {"b2_resnet": 40, "b3_deepae": 2560, "smartcam": 12, "wgan": 602112}
N = {"b2_resnet": 50, "b3_deepae": 100, "smartcam": 50, "wgan": 3}
ENF_MODELS = ("b2_resnet", "b3_deepae", "smartcam")
N_LONG = 450


def load_cell(root, dep):
    d = os.path.join(root, dep)
    rj, rec = os.path.join(d, "run.json"), os.path.join(d, "plugin_records.jsonl")
    if not (os.path.isfile(rj) and os.path.isfile(rec)):
        return None
    run = json.load(open(rj))
    records = [json.loads(x) for x in open(rec, encoding="utf-8") if x.strip()]
    return {"run": run,
            "init": next((r for r in records if r.get("event") == "init"), {}),
            "inferences": [r for r in records if r.get("event") == "inference"],
            "violations": [r for r in records if r.get("event") == "precondition_violated"],
            "readback_unavailable": [r for r in records if r.get("event") == "readback_unavailable"]}


def leak_counts(run):
    """nanobind's shutdown report. Absent header = 0 leaked (the report prints only when something leaked)."""
    t = (run.get("stderr_tail") or "")
    def hdr(kind):
        m = re.search(r"nanobind: leaked (\d+) %s" % kind, t)
        return int(m.group(1)) if m else 0
    return {"instances": hdr("instances"), "keep_alive_records": hdr("keep_alive records"),
            "mapped_memory_type_listed": "MappedMemory" in t, "stderr_tail_chars": len(t)}


def series(cell):
    return [((r.get("hal") or {}).get("device_bytes_peak"), (r.get("hal") or {}).get("device_bytes_live"))
            for r in cell["inferences"]]


def outputs(cell):
    return [r.get("output") for r in cell["inferences"]]


def probe(name, root=None):
    p = os.path.join(root or ROOT, "probe", name + ".json")
    return json.load(open(p)) if os.path.isfile(p) else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", help="write here instead of the committed summary (guards re-derive into a temp dir)")
    ap.add_argument("--root", default=ROOT, help="results root holding probe/ and cells/ (default: the committed one)")
    a = ap.parse_args()
    cells_root = os.path.join(a.root, "cells")
    s = {"experiment": "E62", "plan": PLAN, "plan_commit": PLAN_COMMIT,
         "generated_by": "harness/mk_e62_summary.py",
         "target": "AArch64 QEMU system guest; iree-base-runtime 3.11.0 cp312-abi3 aarch64 wheel (same as E57)",
         "criteria": {}, "falsifiers": {}}
    crit, fals = s["criteria"], s["falsifiers"]

    # ---- P1: mechanism
    ra, rb = probe("refcount_asarray", a.root), probe("refcount_bufproto", a.root)
    p1 = {"present": bool(ra and rb)}
    if ra and rb:
        p1.update({
            "asarray_refcount": ra["refcount"], "asarray_live_after_all_dropped":
                ra["after_all_references_dropped"]["live"],
            "bufproto_refcount": rb["refcount"], "bufproto_live_after_all_dropped":
                rb["after_all_references_dropped"]["live"],
            "same_output": ra["output_sha256"] == rb["output_sha256"]})
        p1["holds"] = (ra["refcount"]["delta_after"] == 1 and p1["asarray_live_after_all_dropped"] == O["b3_deepae"]
                       and rb["refcount"]["delta_after"] == 0 and p1["bufproto_live_after_all_dropped"] == 0
                       and p1["same_output"])
    else:
        p1["holds"] = False
    crit["P1_mechanism"] = p1
    fals["F4_mechanism_refuted"] = bool(ra) and ra["refcount"]["delta_after"] == 0

    # ---- P2: probe loops through the production readback
    la, lb = probe("loop_asarray", a.root), probe("loop_buffer_protocol", a.root)
    p2 = {"present": bool(la and lb)}
    if la and lb:
        ra_rows, rb_rows = la["rows"], lb["rows"]
        p2.update({
            "calls": [len(ra_rows), len(rb_rows)],
            "bufproto_all_live_0_peak_P": all(r["live"] == 0 and r["peak"] == P["b3_deepae"] for r in rb_rows),
            "asarray_live_k_times_O": all(r["live"] == r["call"] * O["b3_deepae"] for r in ra_rows),
            "outputs_identical_per_call": sum(x["output_sha256"] == y["output_sha256"]
                                              for x, y in zip(ra_rows, rb_rows)),
            "asarray_last": ra_rows[-1], "bufproto_last": rb_rows[-1]})
        p2["holds"] = (p2["calls"] == [20, 20] and p2["bufproto_all_live_0_peak_P"]
                       and p2["asarray_live_k_times_O"] and p2["outputs_identical_per_call"] == 20)
    else:
        p2["holds"] = False
    crit["P2_probe_loops"] = p2

    cells = {}
    cfg = json.load(open(CONFIG))["deployments"]
    for dep in cfg:
        cells[dep] = load_cell(cells_root, dep)

    def e57_of(dep):
        src = cfg[dep].get("_e62_source_deployment")
        return src, (load_cell(E57, src) if src else None)

    # ---- P3 / P4 / P6 on the fix arm (+ long)
    fix_rows, all_ok_p3, all_ok_p4 = {}, True, True
    fix_deps = ["e62_%s_Bu_fix" % m for m in MODELS] + ["e62_b3_deepae_Bu_long_fix"]
    for dep in fix_deps:
        m = next(x for x in MODELS if ("_%s_" % x) in dep)
        c = cells.get(dep)
        want_n = N_LONG if dep.endswith("long_fix") else N[m]
        if c is None:
            fix_rows[dep] = {"present": False}
            all_ok_p3 = all_ok_p4 = False
            continue
        ser = series(c)
        base = (c["init"].get("hal_after_append") or {}).get("device_bytes_live")
        rb_ok = all(r.get("output_readback") == "buffer_protocol" for r in c["inferences"])
        ok3 = (len(ser) == want_n and base == 0 and rb_ok and
               all(pk == P[m] and lv == base for pk, lv in ser) and not c["readback_unavailable"])
        src, e = e57_of(dep)
        same = sum(1 for x, y in zip(outputs(c), outputs(e) if e else []) if x == y) if e else None
        ok4 = e is not None and same == want_n == len(outputs(e))
        max_peak = max((pk for pk, _ in ser), default=None)
        fix_rows[dep] = {"present": True, "inferences": len(ser), "post_append_live": base,
                         "all_peak_eq_P_live_eq_post_append": ok3, "max_peak": max_peak,
                         "admitted_budget": c["init"].get("admission", {}).get("admitted_budget_bytes"),
                         "any_call_over_admitted_budget": (max_peak is not None and max_peak >
                                                           (c["init"].get("admission", {}).get("admitted_budget_bytes") or 0)),
                         "outputs_bitidentical_to_e57": same, "e57_source": src,
                         "leaks": leak_counts(c["run"]), "returncode": c["run"].get("returncode"),
                         "onair_core_unmodified": (c["run"].get("onair") or {}).get("core_unmodified")}
        all_ok_p3 &= ok3
        all_ok_p4 &= ok4
    crit["P3_fix_arm"] = {"cells": fix_rows, "holds": all_ok_p3}
    fals["F1_fix_insufficient"] = not all_ok_p3
    fals["F5_readback_unavailable"] = any((cells.get(d) or {}).get("readback_unavailable") for d in fix_deps)

    # ---- P5 control arm reproduces E57
    ctl_rows, ok5 = {}, True
    for m in MODELS:
        dep = "e62_%s_Bu_ctl" % m
        c = cells.get(dep)
        src, e = e57_of(dep)
        if c is None or e is None:
            ctl_rows[dep] = {"present": c is not None, "e57_present": e is not None}
            ok5 = False
            continue
        sc, se = series(c), series(e)
        same_series = sc == se and len(sc) == N[m]
        same_out = sum(1 for x, y in zip(outputs(c), outputs(e)) if x == y)
        ctl_rows[dep] = {"inferences": len(sc), "series_equal_e57": same_series,
                         "outputs_bitidentical_to_e57": same_out, "last": sc[-1] if sc else None,
                         "leaks": leak_counts(c["run"]), "e57_leaks": leak_counts(e["run"])}
        ok5 &= same_series
        all_ok_p4 &= same_out == N[m]
    crit["P5_control_reproduces_e57"] = {"cells": ctl_rows, "holds": ok5}
    fals["F3_control_differs_from_e57"] = not ok5

    # ---- P4 values unchanged (fix + long + ctl + default)
    dflt = cells.get("e62_b2_resnet_Bu_default")
    _, e_d = e57_of("e62_b2_resnet_Bu_default")
    same_d = sum(1 for x, y in zip(outputs(dflt), outputs(e_d)) if x == y) if (dflt and e_d) else None
    all_ok_p4 &= same_d == N["b2_resnet"]
    crit["P4_values_unchanged"] = {"holds": all_ok_p4, "default_cell_bitidentical": same_d}
    fals["F2_output_differs"] = not all_ok_p4

    # ---- P6 shutdown leak report
    fix_leak = {d: (fix_rows.get(d) or {}).get("leaks") for d in fix_deps}
    ctl_leak = {d: (ctl_rows.get(d) or {}).get("leaks") for d in ctl_rows}
    ok6 = all(v and v["instances"] == 0 and v["keep_alive_records"] == 0 for v in fix_leak.values()) and \
        all(v and v["instances"] == 2 * N[m] and v["keep_alive_records"] == N[m]
            for m, v in zip(MODELS, [ctl_leak.get("e62_%s_Bu_ctl" % m) for m in MODELS]))
    # D51: an absent report in a fix cell reads as "nothing leaked" only if the same harness demonstrably captured
    # stderr -- the control cells, run by the same tool in the same guest, carry the report in their stderr_tail
    captured = bool(ctl_leak) and all(v and v["stderr_tail_chars"] > 0 and v["mapped_memory_type_listed"]
                                      for v in ctl_leak.values())
    ok6 = ok6 and captured
    crit["P6_shutdown_leak_report"] = {"fix": fix_leak, "control": ctl_leak,
                                       "stderr_capture_demonstrated_by_control": captured, "holds": ok6}

    # ---- P7 default
    p7 = {"present": dflt is not None}
    if dflt:
        ser = series(dflt)
        p7.update({"init_output_readback": dflt["init"].get("output_readback"), "inferences": len(ser),
                   "all_peak_eq_P_live_0": all(pk == P["b2_resnet"] and lv == 0 for pk, lv in ser)})
        p7["holds"] = (p7["init_output_readback"] == "buffer_protocol" and len(ser) == N["b2_resnet"]
                       and p7["all_peak_eq_P_live_0"])
    else:
        p7["holds"] = False
    crit["P7_default_is_fix"] = p7

    # ---- P8 decision half and core untouched
    deny = {}
    for m in MODELS:
        c = cells.get("e62_%s_Bum1" % m)
        deny[m] = None if c is None else {
            "verdict": (c["init"].get("admission") or {}).get("verdict"),
            "runtime_created": c["init"].get("runtime_created"),
            "inferences": len(c["inferences"]), "active": c["init"].get("active")}
    core = {d: ((c or {}).get("run", {}).get("onair") or {}).get("core_unmodified") for d, c in cells.items()}
    ok8 = all(v and v["verdict"] == "NOT_ADMITTED" and v["runtime_created"] is False and v["inferences"] == 0
              for v in deny.values()) and all(v is True for v in core.values())
    crit["P8_decision_half_and_core"] = {"deny": deny, "onair_core_unmodified_all": all(v is True for v in core.values()),
                                          "holds": ok8}

    # ---- P9 enforcement
    enf = {}
    ok9_ctl = ok9_fix = True
    for m in ENF_MODELS:
        c = cells.get("e62_%s_Bu_enf_ctl" % m)
        if c is None:
            enf["e62_%s_Bu_enf_ctl" % m] = None
            ok9_ctl = False
        else:
            v = c["violations"]
            ser = series(c)
            row = {"inferences": len(c["inferences"]), "violations": len(v),
                   "violation_live": v[0].get("device_bytes_live") if v else None,
                   "violation_post_append": v[0].get("post_append_live") if v else None,
                   "max_peak": max((pk for pk, _ in ser), default=None),
                   "returncode": c["run"].get("returncode")}
            row["holds"] = (row["inferences"] == 1 and row["violations"] == 1 and row["violation_live"] == O[m]
                            and row["violation_post_append"] == 0 and row["max_peak"] == P[m]
                            and row["returncode"] == 0)
            enf["e62_%s_Bu_enf_ctl" % m] = row
            ok9_ctl &= row["holds"]
        c = cells.get("e62_%s_Bu_enf_fix" % m)
        if c is None:
            enf["e62_%s_Bu_enf_fix" % m] = None
            ok9_fix = False
        else:
            ser = series(c)
            row = {"inferences": len(ser), "violations": len(c["violations"]),
                   "all_peak_eq_P_live_0": all(pk == P[m] and lv == 0 for pk, lv in ser)}
            row["holds"] = row["inferences"] == N[m] and row["violations"] == 0 and row["all_peak_eq_P_live_0"]
            enf["e62_%s_Bu_enf_fix" % m] = row
            ok9_fix &= row["holds"]
    crit["P9_enforcement"] = {"cells": enf, "holds": ok9_ctl and ok9_fix,
                              "scope": "three models; WGAN enforcement cells not run (plan SS3)"}
    fals["F6_enforcement_wrong"] = {"type_B_blocks_honest_run": not ok9_fix, "type_A_misses_violation": not ok9_ctl}

    holds = {k: v.get("holds") for k, v in crit.items()}
    if all(holds.values()):
        verdict = "PASS"
    elif not holds["P1_mechanism"] and all(v for k, v in holds.items() if k != "P1_mechanism"):
        verdict = "FIX_PASS_MECHANISM_UNCONFIRMED"
    else:
        verdict = "FAIL"
    s["holds"] = holds
    s["verdict"] = verdict
    s["not_claimed"] = [
        "an IREE upstream defect confirmed, reported or fixed; other wheels, revisions or drivers",
        "results that are not host-mappable (the device-copy path also goes through asarray; the fix refuses it)",
        "latency (the guest is FUNCTIONAL_ONLY); the cFS path (unaffected); the conditional tier",
        "process RSS (D78): the measured quantity is the HAL allocator statistic",
        "enforcement on WGAN (not run)"]
    out = a.out or os.path.join(a.root, "summary.json")
    json.dump(s, open(out, "w"), indent=1)
    open(out, "a").write("\n")
    print(json.dumps({"verdict": verdict, "holds": holds}))


if __name__ == "__main__":
    main()
