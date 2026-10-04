#!/usr/bin/env python3
"""E69: the OnAIR readback cells (E57c/E62/E65) re-run on the final, re-issued specification documents.

Plan: docs/plans/E69_onair_readback_final_documents.md (committed before any cell).

  deployments  Write configs/deployments/onair_deployments_e69_aarch64.json. Each E69 deployment is the
               corresponding E62/E65 deployment with exactly two changes: artifact_dir points at the E66
               re-issued document directory (whose artifact link resolves to the same artifact), and the
               producer-check waiver key (allow_unchecked_producer) is removed. Telemetry, fixture, budget,
               readback, enforcement and call counts are those of the source deployment.
  summary      Read the guest's records (results/e69_onair_final_documents/) and write summary.json with
               the plan's Q0-Q8 and F1-F5. Every value comes from what the guest wrote; the cited E66
               buffer-protocol cells and the E62/E57 cells are read from their archived records.

Nothing here runs a model.
"""
import argparse
import copy
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)

PLAN = "docs/plans/E69_onair_readback_final_documents.md"
OUT = os.path.join(REPO, "results", "e69_onair_final_documents")
CONFIG = os.path.join(REPO, "configs", "deployments", "onair_deployments_e69_aarch64.json")
E62_CONFIG = os.path.join(REPO, "configs", "deployments", "onair_deployments_e62_aarch64.json")
E65_CONFIG = os.path.join(REPO, "configs", "deployments", "onair_deployments_e65_aarch64.json")
E66_CELLS = os.path.join(REPO, "results", "e66_plugin_document_rules", "guest", "cells")
E66_ENV = os.path.join(REPO, "results", "e66_plugin_document_rules", "guest", "guest_env.txt")
E62_CELLS = os.path.join(REPO, "results", "e62_onair_output_release", "cells")
E57_CELLS = os.path.join(REPO, "results", "e57_onair_aarch64", "cells")
DOCS = "../../results/e66_plugin_document_rules/docs/%s"

MODELS = ("b2_resnet", "b3_deepae", "smartcam", "wgan")
ENF_MODELS = ("b2_resnet", "b3_deepae", "smartcam")
P = {"b2_resnet": 309416, "b3_deepae": 6208, "smartcam": 9382092, "wgan": 131382784}
O = {"b2_resnet": 40, "b3_deepae": 2560, "smartcam": 12, "wgan": 602112}
BU = {"b2_resnet": 618856, "b3_deepae": 1069632, "smartcam": 18222796, "wgan": 135666432}
N = {"b2_resnet": 50, "b3_deepae": 100, "smartcam": 50, "wgan": 3}
N_LONG = 450
PREDICTED_FIRST_OVER = 417          # plan SS2 Q2: P + (n-1)O > B_u  <=>  n - 1 > 1063424 / 2560

# E69 deployment -> (source config, source deployment, overrides)
CELLS = {}
for _m in MODELS:
    CELLS["e69_%s_Bu_ctl" % _m] = ("e62", "e62_%s_Bu_ctl" % _m, {})
CELLS["e69_b2_resnet_Bu_default"] = ("e62", "e62_b2_resnet_Bu_default", {})
CELLS["e69_b3_deepae_Bu_long_ctl"] = ("e62", "e62_b3_deepae_Bu_long_fix", {"output_readback": "asarray"})
CELLS["e69_b3_deepae_Bu_long_fix"] = ("e62", "e62_b3_deepae_Bu_long_fix", {})
for _m in ENF_MODELS:
    CELLS["e69_%s_Bu_enf_ctl" % _m] = ("e62", "e62_%s_Bu_enf_ctl" % _m, {})
    CELLS["e69_%s_Bu_enf_fix" % _m] = ("e62", "e62_%s_Bu_enf_fix" % _m, {})
CELLS["e69_b2_resnet_cond_true"] = ("e65", "e65_b2_resnet_conditional_requested", {})
CELLS["e69_b2_resnet_cond_false"] = ("e65", "e65_b2_resnet_conditional_false_control", {})


def model_of(dep):
    return next(m for m in MODELS if ("_%s_" % m) in dep)


def cmd_deployments(_a):
    src = {"e62": json.load(open(E62_CONFIG))["deployments"], "e65": json.load(open(E65_CONFIG))["deployments"]}
    deps = {}
    for dep, (cfg, sdep, over) in CELLS.items():
        d = copy.deepcopy(src[cfg][sdep])
        for k in [k for k in d if k.startswith("_")] + ["allow_unchecked_producer"]:
            d.pop(k, None)
        d["artifact_dir"] = DOCS % model_of(dep)
        d.update(over)
        d["_e69_source_deployment"] = "%s (%s)" % (sdep, os.path.relpath(
            E62_CONFIG if cfg == "e62" else E65_CONFIG, REPO))
        d["_e69_changes"] = ["artifact_dir -> the E66 re-issued document directory",
                             "allow_unchecked_producer removed"] + ["%s=%r" % kv for kv in over.items()]
        deps[dep] = d
    doc = {"_note": "E69 (%s): the OnAIR readback cells re-run on the re-issued documents, no waiver. "
                    "Written by harness/e69_onair_final_documents.py deployments." % PLAN,
           "_scope": "AArch64 QEMU guest only; nothing here is run on the development host",
           "deployments": deps}
    json.dump(doc, open(CONFIG, "w"), indent=1)
    open(CONFIG, "a").write("\n")
    print("wrote %s (%d deployments)" % (os.path.relpath(CONFIG, REPO), len(deps)))


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


def series(c):
    return [((r.get("hal") or {}).get("device_bytes_peak"), (r.get("hal") or {}).get("device_bytes_live"))
            for r in c["inferences"]]


def outputs(c):
    return [r.get("output") for r in c["inferences"]]


def plugin_hashes(path):
    """sha256 lines of plugins/compiled_learner/*.py from a guest_env.txt (the files the guest imported)."""
    if not os.path.isfile(path):
        return None
    out = {}
    for line in open(path, encoding="utf-8", errors="ignore"):
        m = re.match(r"^([0-9a-f]{64})\s+(plugins/compiled_learner/\S+\.py)$", line.strip())
        if m:
            out[m.group(2)] = m.group(1)
    return out or None


def probe(root, name):
    p = os.path.join(root, "probe", name + ".json")
    return json.load(open(p)) if os.path.isfile(p) else None


def cmd_summary(a):
    root = a.root
    cells = {dep: load_cell(os.path.join(root, "cells"), dep) for dep in CELLS}
    e66 = {m: load_cell(E66_CELLS, "e66_%s_Bu" % m) for m in MODELS}
    s = {"experiment": "E69", "plan": PLAN, "generated_by": "harness/e69_onair_final_documents.py summary",
         "target": "AArch64 QEMU system guest; iree-base-runtime 3.11.0 aarch64 wheel (as E57/E62/E66)",
         "criteria": {}, "falsifiers": {}, "supplementary": {}}
    crit, fals = s["criteria"], s["falsifiers"]

    # ---- Q0: final documents only, plugin as E66, core untouched
    ph, ph66 = plugin_hashes(os.path.join(root, "guest_env.txt")), plugin_hashes(E66_ENV)
    acc = {}
    for dep, c in cells.items():
        if c is None:
            acc[dep] = None
            continue
        da = c["init"].get("document_acceptance")
        acc[dep] = {"document_acceptance": da,
                    "waiver_requested": c["init"].get("allow_unchecked_producer_requested"),
                    "onair_core_unmodified": (c["run"].get("onair") or {}).get("core_unmodified")}
    cond_true = "e69_b2_resnet_cond_true"
    ok0 = all(v is not None for v in acc.values()) and all(
        v["waiver_requested"] in (None, False) and v["onair_core_unmodified"] is True and
        (dep == cond_true or (v["document_acceptance"] or {}).get("verdict") == "accepted"
         and (v["document_acceptance"] or {}).get("waived") == [])
        for dep, v in acc.items())
    crit["Q0_final_documents_only"] = {"cells": acc, "plugin_sha256_guest": ph, "plugin_sha256_e66": ph66,
                                       "plugin_files_as_e66": ph is not None and ph == ph66,
                                       "holds": ok0 and ph is not None and ph == ph66}
    fals["F1_waiver_used"] = any(v and ((v["document_acceptance"] or {}).get("waived") or v["waiver_requested"])
                                 for v in acc.values())

    # ---- Q1/Q2: retention on the first readback
    q1 = {}
    ok1 = True
    for dep in ["e69_%s_Bu_ctl" % m for m in MODELS] + ["e69_b3_deepae_Bu_long_ctl"]:
        m = model_of(dep)
        c = cells.get(dep)
        want = N_LONG if "long" in dep else N[m]
        if c is None:
            q1[dep] = {"present": False}
            ok1 = False
            continue
        ser = series(c)
        base = (c["init"].get("hal_after_append") or {}).get("device_bytes_live")
        budget = (c["init"].get("admission") or {}).get("admitted_budget_bytes")
        over = [i + 1 for i, (pk, _) in enumerate(ser) if pk is not None and budget is not None and pk > budget]
        live_ok = all(lv == (k + 1) * O[m] for k, (_, lv) in enumerate(ser))
        peak_ok = all(pk == P[m] + k * O[m] for k, (pk, _) in enumerate(ser))
        row = {"inferences": len(ser), "post_append_live": base, "admitted_budget": budget,
               "live_after_call_k_eq_kO": live_ok, "peak_after_call_n_eq_P_plus_n_minus_1_O": peak_ok,
               "first_call_over_admitted_budget": over[0] if over else None,
               "peak_first": ser[0][0] if ser else None, "peak_last": ser[-1][0] if ser else None,
               "readback": c["init"].get("output_readback")}
        if "long" not in dep:
            row["all_within_budget"] = not over
        q1[dep] = row
        ok1 &= (len(ser) == want and base == 0 and live_ok and peak_ok and row["readback"] == "asarray"
                and ("long" in dep or row["all_within_budget"]))
    crit["Q1_first_readback_retains"] = {"cells": q1, "holds": ok1}
    lc = q1.get("e69_b3_deepae_Bu_long_ctl") or {}
    crit["Q2_first_over_budget_call"] = {"predicted": PREDICTED_FIRST_OVER,
                                         "observed": lc.get("first_call_over_admitted_budget"),
                                         "holds": lc.get("first_call_over_admitted_budget") == PREDICTED_FIRST_OVER}
    fals["F2_retention_differs"] = not (ok1 and crit["Q2_first_over_budget_call"]["holds"])

    # ---- Q3: second readback (long fix run here; the four B_u cells cited from E66)
    q3, ok3 = {}, True
    fixes = {"e69_b3_deepae_Bu_long_fix": cells.get("e69_b3_deepae_Bu_long_fix")}
    fixes.update({"e66_%s_Bu" % m: e66[m] for m in MODELS})
    for dep, c in fixes.items():
        m = model_of(dep)
        want = N_LONG if "long" in dep else N[m]
        if c is None:
            q3[dep] = {"present": False}
            ok3 = False
            continue
        ser = series(c)
        row = {"inferences": len(ser), "readback": c["init"].get("output_readback"),
               "all_peak_eq_P_live_0": all(pk == P[m] and lv == 0 for pk, lv in ser),
               "max_peak": max((pk for pk, _ in ser), default=None),
               "source": "run here" if dep.startswith("e69") else "cited: E66 final-document cell"}
        q3[dep] = row
        ok3 &= len(ser) == want and row["readback"] == "buffer_protocol" and row["all_peak_eq_P_live_0"]
    crit["Q3_second_readback_releases"] = {"cells": q3, "holds": ok3}
    fals["F3_fix_exceeds_P"] = not ok3

    # ---- Q4: outputs identical between the two readbacks, per call
    q4, ok4 = {}, True
    pairs = [("e69_%s_Bu_ctl" % m, "e66_%s_Bu" % m, cells.get("e69_%s_Bu_ctl" % m), e66[m]) for m in MODELS]
    pairs.append(("e69_b3_deepae_Bu_long_ctl", "e69_b3_deepae_Bu_long_fix",
                  cells.get("e69_b3_deepae_Bu_long_ctl"), cells.get("e69_b3_deepae_Bu_long_fix")))
    for a_, b_, ca, cb in pairs:
        if ca is None or cb is None:
            q4["%s vs %s" % (a_, b_)] = None
            ok4 = False
            continue
        ia, ib = ca["inferences"], cb["inferences"]
        same = sum(1 for x, y in zip(ia, ib) if x.get("sample_id") == y.get("sample_id") and x.get("output") == y.get("output"))
        q4["%s vs %s" % (a_, b_)] = {"compared": min(len(ia), len(ib)), "bit_identical": same}
        ok4 &= same == len(ia) == len(ib)
    crit["Q4_outputs_identical_across_readbacks"] = {"pairs": q4, "holds": ok4}
    fals["F4_outputs_differ"] = not ok4

    # ---- Q5: per-call check
    q5, ok5 = {}, True
    for m in ENF_MODELS:
        c = cells.get("e69_%s_Bu_enf_ctl" % m)
        if c is None:
            q5["e69_%s_Bu_enf_ctl" % m] = None
            ok5 = False
        else:
            v = c["violations"]
            row = {"inferences": len(c["inferences"]), "violations": len(v),
                   "violation_live": v[0].get("device_bytes_live") if v else None,
                   "violation_post_append": v[0].get("post_append_live") if v else None,
                   "max_peak": max((pk for pk, _ in series(c)), default=None)}
            row["holds"] = (row["inferences"] == 1 and row["violations"] == 1 and row["violation_live"] == O[m]
                            and row["violation_post_append"] == 0 and row["max_peak"] == P[m])
            q5["e69_%s_Bu_enf_ctl" % m] = row
            ok5 &= row["holds"]
        c = cells.get("e69_%s_Bu_enf_fix" % m)
        if c is None:
            q5["e69_%s_Bu_enf_fix" % m] = None
            ok5 = False
        else:
            ser = series(c)
            row = {"inferences": len(ser), "violations": len(c["violations"]),
                   "all_peak_eq_P_live_0": all(pk == P[m] and lv == 0 for pk, lv in ser)}
            row["holds"] = row["inferences"] == N[m] and row["violations"] == 0 and row["all_peak_eq_P_live_0"]
            q5["e69_%s_Bu_enf_fix" % m] = row
            ok5 &= row["holds"]
    crit["Q5_per_call_check"] = {"cells": q5, "holds": ok5}

    # ---- Q6: default readback
    c = cells.get("e69_b2_resnet_Bu_default")
    q6 = {"present": c is not None}
    if c:
        ser = series(c)
        q6.update({"init_output_readback": c["init"].get("output_readback"), "inferences": len(ser),
                   "all_peak_eq_P_live_0": all(pk == P["b2_resnet"] and lv == 0 for pk, lv in ser)})
        q6["holds"] = (q6["init_output_readback"] == "buffer_protocol" and len(ser) == N["b2_resnet"]
                       and q6["all_peak_eq_P_live_0"])
    else:
        q6["holds"] = False
    crit["Q6_default_is_buffer_protocol"] = q6

    # ---- Q7: conditional option
    ct, cf = cells.get(cond_true), cells.get("e69_b2_resnet_cond_false")
    q7 = {"present": bool(ct and cf)}
    if ct and cf:
        i = ct["init"]
        q7["true"] = {"active": i.get("active"), "inactive_reason": i.get("inactive_reason"),
                      "runtime_created": i.get("runtime_created"), "inferences": len(ct["inferences"]),
                      "admission": i.get("admission"), "binding": i.get("binding"),
                      "document_acceptance": i.get("document_acceptance")}
        q7["false"] = {"active": cf["init"].get("active"),
                       "verdict": (cf["init"].get("admission") or {}).get("verdict"),
                       "inferences": len(cf["inferences"])}
        q7["holds"] = (i.get("active") is False and "ConfigurationError" in (i.get("inactive_reason") or "")
                       and i.get("runtime_created") is False and len(ct["inferences"]) == 0
                       and i.get("admission") is None and i.get("binding") is None
                       and not i.get("document_acceptance")
                       and q7["false"]["active"] is True and q7["false"]["verdict"] == "ADMIT"
                       and q7["false"]["inferences"] == N["b2_resnet"])
    else:
        q7["holds"] = False
    crit["Q7_conditional_option"] = q7
    fals["F5_conditional_true_ran"] = bool(ct) and (ct["init"].get("runtime_created") is not False or bool(ct["inferences"]))

    # ---- Q8: mechanism probe
    ra, rb = probe(root, "refcount_asarray"), probe(root, "refcount_bufproto")
    q8 = {"present": bool(ra and rb)}
    if ra and rb:
        q8.update({"asarray_refcount": ra["refcount"],
                   "asarray_live_after_all_dropped": ra["after_all_references_dropped"]["live"],
                   "bufproto_refcount": rb["refcount"],
                   "bufproto_live_after_all_dropped": rb["after_all_references_dropped"]["live"],
                   "same_output": ra["output_sha256"] == rb["output_sha256"]})
        q8["holds"] = (ra["refcount"]["delta_after"] == 1 and q8["asarray_live_after_all_dropped"] == O["b3_deepae"]
                       and rb["refcount"]["delta_after"] == 0 and q8["bufproto_live_after_all_dropped"] == 0
                       and q8["same_output"])
    else:
        q8["holds"] = False
    crit["Q8_mechanism_probe"] = q8

    # ---- supplementary (not verdicts): same series/outputs as the earlier-document cells; vs the flight app
    sup = {}
    for dep, (cfg, sdep, _over) in CELLS.items():
        c = cells.get(dep)
        if c is None or cfg != "e62":
            continue
        e = load_cell(E62_CELLS, sdep) if dep != "e69_b3_deepae_Bu_long_ctl" else load_cell(E57_CELLS, "e57_b3_deepae_Bu_long")
        if e is None:
            sup[dep] = {"earlier_cell": None}
            continue
        sup[dep] = {"earlier_cell": "e57_b3_deepae_Bu_long" if dep.endswith("long_ctl") else sdep,
                    "series_equal": series(c) == series(e),
                    "outputs_bitidentical": sum(1 for x, y in zip(outputs(c), outputs(e)) if x == y),
                    "inferences": len(c["inferences"])}
    s["supplementary"]["vs_earlier_document_cells"] = sup
    try:
        import numpy as np                                          # noqa: PLC0415
        import mk_e57_summary as m57                                # noqa: PLC0415
        vs = {}
        for dep in ["e69_%s_Bu_ctl" % m for m in MODELS] + ["e69_b3_deepae_Bu_long_ctl", "e69_b3_deepae_Bu_long_fix"]:
            c = cells.get(dep)
            if c is None:
                continue
            ob, oo = m57.CFS_OUTPUTS[model_of(dep)]
            ref = np.fromfile(os.path.join(REPO, ob), dtype=np.float32)
            order = [x["sample_id"] for x in json.load(open(os.path.join(REPO, oo)))]
            per = ref.size // len(order)
            ref_by = {sid: ref[i * per:(i + 1) * per] for i, sid in enumerate(order)}
            compared = identical = 0
            for r in c["inferences"]:
                if r.get("sample_id") in ref_by:
                    compared += 1
                    identical += int(np.array_equal(np.asarray(r["output"], dtype=np.float32), ref_by[r["sample_id"]]))
            vs[dep] = {"reference": ob, "compared": compared, "bit_identical": identical}
        s["supplementary"]["vs_flight_application"] = vs
    except Exception as exc:                                        # noqa: BLE001
        s["supplementary"]["vs_flight_application"] = {"available": False, "unavailable_reason": str(exc)}

    holds = {k: v.get("holds") for k, v in crit.items()}
    s["holds"] = holds
    s["verdict"] = "PASS" if all(holds.values()) else "FAIL"
    s["not_claimed"] = [
        "an IREE upstream defect confirmed, reported or fixed; other wheels, revisions or drivers",
        "latency (the guest is FUNCTIONAL_ONLY); process RSS (D78)",
        "per-call check on WGAN (not run, as E62)"]
    out = a.out or os.path.join(root, "summary.json")
    json.dump(s, open(out, "w"), indent=1)
    open(out, "a").write("\n")
    print(json.dumps({"verdict": s["verdict"], "holds": holds}))


def main():
    ap = argparse.ArgumentParser()
    sp = ap.add_subparsers(dest="cmd", required=True)
    sp.add_parser("deployments")
    p = sp.add_parser("summary")
    p.add_argument("--root", default=OUT)
    p.add_argument("--out")
    a = ap.parse_args()
    {"deployments": cmd_deployments, "summary": cmd_summary}[a.cmd](a)


if __name__ == "__main__":
    main()
