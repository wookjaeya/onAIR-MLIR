#!/usr/bin/env python3
"""E57 summary: the OnAIR plugin path on the evaluation target (AArch64 QEMU guest).

Plan: docs/plans/E57_onair_aarch64.md (committed before measurement, d82f866).  Falsifiers F1-F6
are the plan's SS4 verbatim.  Every OnAIR value is read from the cell's own records
(plugin_records.jsonl written by the plugin under NASA's official loader, and run.json written by
harness/onair_integration_check.py); every cFS value is read from the archived AArch64 cFS log of
the boundary cell the plan names.  Nothing is transcribed from prose.

The output comparison at the end is SUPPLEMENTARY (not in the plan's SS3): the OnAIR cells replay
the same fixtures the archived AArch64 cFS runs replayed, on the same artifact, so their outputs can
be compared element by element.  It is reported beside the verdicts and never feeds them.
"""
import hashlib
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
ROOT = os.path.join(REPO, "results", "e57_onair_aarch64")
CONFIG = os.path.join(REPO, "configs", "deployments", "onair_deployments_e57_aarch64.json")
MODELS = ("b2_resnet", "b3_deepae", "smartcam", "wgan")
N_REQUIRED = {"b2_resnet": 50, "b3_deepae": 100, "smartcam": 50, "wgan": 3}
# archived AArch64 cFS runs that replayed the same fixture on the same artifact (supplementary)
CFS_OUTPUTS = {
    "b2_resnet": ("results/e36b_aarch64_models/b2_resnet/e25_outputs.bin",
                  "results/e36b_aarch64_models/b2_resnet/replay_order.json"),
    "b3_deepae": ("results/e36b_aarch64_models/b3_deepae/e25_outputs.bin",
                  "results/e36b_aarch64_models/b3_deepae/replay_order.json"),
    "smartcam": ("results/e37_evidence_consolidation/s_cfs_post_d61/e25_outputs.bin",
                 "results/e37_evidence_consolidation/s_cfs_post_d61/replay_order.json"),
    "wgan": ("results/e53_wgan_aarch64/cfs/logs/cfs_B.e25_outputs.bin",
             "results/e53_wgan_aarch64/replay_order_1sample.json"),
}


def cfs_records(rel):
    txt = open(os.path.join(REPO, rel), encoding="utf-8", errors="ignore").read()
    by = {}
    for m in re.finditer(r'\{"app":"AI_LEARNER"[^}]*\}', txt):
        try:
            r = json.loads(m.group(0))
        except ValueError:
            continue
        by.setdefault(r.get("stage"), []).append(r)
    return by


def onair_cell(dep):
    d = os.path.join(ROOT, "cells", dep)
    rj, rec = os.path.join(d, "run.json"), os.path.join(d, "plugin_records.jsonl")
    if not (os.path.isfile(rj) and os.path.isfile(rec)):
        return None
    run = json.load(open(rj))
    records = [json.loads(x) for x in open(rec, encoding="utf-8") if x.strip()]
    init = next((r for r in records if r.get("event") == "init"), {})
    inf = [r for r in records if r.get("event") == "inference"]
    return {"run": run, "init": init, "inferences": inf}


def sha256(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()


def main():
    import argparse                                                # noqa: PLC0415
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", help="write here instead of the committed summary (guards re-derive into a temp dir)")
    args = ap.parse_args()
    cfg = json.load(open(CONFIG))["deployments"]
    import numpy as np                                            # noqa: PLC0415
    cells_a, cells_b, falsified = [], [], {f: [] for f in ("F1", "F2", "F3", "F4", "F5", "F6")}
    extra_b = [("b3_deepae", "Bu_long")]      # E57c (docs/plans/E57c_deepae_long_run.md)
    for m, tag in [(m, t) for m in MODELS for t in ("Bu", "Bum1")] + extra_b:
        if True:
            dep = "e57_%s_%s" % (m, tag)
            c = onair_cell(dep)
            dcfg = cfg[dep]
            cfs_log = dcfg["_e57_cfs_cell"]
            cb = cfs_records(cfs_log)
            cfs_adm = (cb.get("admission") or [{}])[0]
            cfs_bc = (cb.get("build_config") or [{}])[0]
            cfs_bind = (cb.get("binding") or [{}])[0]
            con = json.load(open(os.path.join(REPO, "configs", "deployments", dcfg["artifact_dir"],
                                              dcfg["contract_file"])))
            art_sha = con["artifact"]["sha256"]
            if c is None:
                if tag != "Bu_long":
                    cells_a.append({"deployment": dep, "present": False})
                continue
            init, run, inf = c["init"], c["run"], c["inferences"]
            onair_verdict = (init.get("admission") or {}).get("verdict")
            onair_bind = (init.get("binding") or {})
            # F3: the artifact this OnAIR cell was decided on vs the one the cFS cell executed
            cfs_art = cfs_bc.get("contract_artifact_sha256") or ""
            cfs_bind_prefix = cfs_bind.get("artifact_sha256") or ""
            onair_art = onair_bind.get("sha256") or onair_bind.get("artifact_sha256")
            same_art = (cfs_art == art_sha or (not cfs_art and art_sha.startswith(cfs_bind_prefix) and cfs_bind_prefix)) \
                and (onair_art in (None, art_sha))
            row = {
                "deployment": dep, "model": m, "budget": dcfg["budget_bytes"], "present": True,
                "onair_verdict": onair_verdict, "cfs_verdict": cfs_adm.get("verdict"),
                "cfs_cell": cfs_log, "cfs_budget": cfs_adm.get("budget"),
                "verdicts_agree": onair_verdict == cfs_adm.get("verdict"),
                "runtime_created": init.get("runtime_created"),
                "inferences": len(inf), "active": init.get("active"),
                "binding_verdict": onair_bind.get("verdict"),
                "contract_artifact_sha256": art_sha,
                "cfs_artifact_sha256": cfs_art or (cfs_bind_prefix + "..."),
                "onair_bound_artifact_sha256": onair_art,
                "artifact_sha256_matches_cfs_cell": bool(same_art),
                "onair_core_unmodified": run.get("onair", {}).get("core_unmodified"),
                "plugin_constructed_by_official_loader": run.get("plugin_constructed"),
                "returncode": run.get("returncode"),
                "runtime_build": "iree-base-runtime 3.11.0 manylinux aarch64 wheel (cp312-abi3) -- a different "
                                 "build from the source-built C runtime the cFS cells link",
            }
            if not row["verdicts_agree"]:
                falsified["F1"].append(dep)
            if tag == "Bum1" and (row["runtime_created"] or row["inferences"] > 0):
                falsified["F2"].append(dep)
            if not row["artifact_sha256_matches_cfs_cell"]:
                falsified["F3"].append(dep)
            if tag != "Bu_long":
                cells_a.append(row)
            if tag not in ("Bu", "Bu_long"):
                continue
            # ---- experiment B: peaks over N calls, read after `del out` by the plugin ----
            ha = init.get("hal_after_append") or {}
            hals = [r.get("hal") or {} for r in inf]
            avail = bool(ha.get("available")) and all(h.get("available") for h in hals) and bool(hals)
            b = {"deployment": dep, "model": m, "N": len(inf), "N_required": N_REQUIRED[m],
                 "admitted_budget": (init.get("admission") or {}).get("admitted_budget_bytes"),
                 "P": con["resources"]["static_per_call_bytes"], "C": con["resources"]["module_resident_constant_bytes"],
                 "B_u": con["resources"]["bounded_bytes"], "statistics_available": avail}
            if not avail:
                b["unavailable_reason"] = ha.get("unavailable_reason") or next(
                    (h.get("unavailable_reason") for h in hals if not h.get("available")), "no inference records")
                falsified["F6"].append(dep)
                b.update({"peak_after_append": None, "peak_1": None, "peak_N": None})
            else:
                peaks = [h["device_bytes_peak"] for h in hals]
                lives = [h["device_bytes_live"] for h in hals]
                budget = (init.get("admission") or {}).get("admitted_budget_bytes", -1)
                over = [r.get("n") for r, h in zip(inf, hals) if h["device_bytes_peak"] > budget]
                incs = sorted(set(b2 - a2 for a2, b2 in zip(lives, lives[1:])))
                b.update({
                    "first_call_with_peak_over_admitted_budget": over[0] if over else None,
                    "live_increment_per_call": incs,
                    "O": 4 * int(np.prod(con["interface"]["output"]["shape"])),
                    "peak_after_append": ha["device_bytes_peak"], "live_after_append": ha["device_bytes_live"],
                    "peak_1": peaks[0], "peak_N": peaks[-1], "peak_max": max(peaks), "peak_min": min(peaks),
                    "live_after_each_call": sorted(set(lives)),
                    "live_returns_to_append_level_every_call": all(x == ha["device_bytes_live"] for x in lives),
                    "peak_constant_over_calls": len(set(peaks)) == 1,
                    "peak_equals_P": peaks[-1] == con["resources"]["static_per_call_bytes"],
                    "peak_within_admitted_budget": max(peaks) <= (init.get("admission") or {}).get("admitted_budget_bytes", -1),
                })
                if b["peak_N"] != b["peak_1"]:
                    falsified["F4"].append(dep)
                if not b["peak_within_admitted_budget"]:
                    falsified["F5"].append(dep)
            b["N_meets_plan"] = len(inf) >= (450 if tag == "Bu_long" else N_REQUIRED[m])
            b["role"] = "E57c extension of B-2 (designed after E57's F4)" if tag == "Bu_long" else "E57 plan cell"
            # ---- supplementary: outputs vs the archived AArch64 cFS run on the same artifact ----
            ob, oo = CFS_OUTPUTS[m]
            try:
                ref = np.fromfile(os.path.join(REPO, ob), dtype=np.float32)
                order = [x["sample_id"] for x in json.load(open(os.path.join(REPO, oo)))]
                per = ref.size // len(order)
                ref_by = {sid: ref[i * per:(i + 1) * per] for i, sid in enumerate(order)}
                compared, identical, worst = 0, 0, 0.0
                for r in inf:
                    sid = r.get("sample_id")
                    if sid in ref_by:
                        y = np.asarray(r["output"], dtype=np.float32)
                        compared += 1
                        identical += int(np.array_equal(y, ref_by[sid]))
                        worst = max(worst, float(np.max(np.abs(y - ref_by[sid]))) if y.size == ref_by[sid].size else float("inf"))
                b["supplementary_output_vs_cfs"] = {
                    "reference": ob, "inferences_compared": compared, "bit_identical": identical,
                    "worst_abs_diff": worst, "note": "same AArch64 artifact and fixture bytes; different runtime "
                                                     "builds (wheel vs source-built C runtime)"}
            except Exception as exc:                              # noqa: BLE001
                b["supplementary_output_vs_cfs"] = {"available": False, "unavailable_reason": str(exc)}
            cells_b.append(b)
    doc = {
        "experiment": "E57",
        "plan": "docs/plans/E57_onair_aarch64.md (committed before measurement, d82f866)",
        "generated_by": "harness/mk_e57_summary.py",
        "target": "aarch64 QEMU system guest (the cFS cells' guest); nothing run on the development host",
        "experiment_A": cells_a, "experiment_B": cells_b,
        "falsifiers": falsified,
        "verdict": {
            "Q1_decision_equivalence": all(c.get("verdicts_agree") for c in cells_a) and len(cells_a) == 8
            and all(c.get("present") for c in cells_a),
            "Q2_peak_stable_over_calls": bool(cells_b) and all(b.get("peak_constant_over_calls") for b in cells_b),
            "Q2_output_released_between_calls": bool(cells_b) and all(
                b.get("live_returns_to_append_level_every_call") for b in cells_b),
            "all_N_meet_plan": bool(cells_b) and all(b.get("N_meets_plan") for b in cells_b),
            "no_falsifier": not any(falsified.values()),
        },
        "defect_recorded_not_run": {
            "conditional_tier_on_plugin_path": "the plugin carries the approval half of the conditional tier "
            "(admission_policy returns ADMIT_CONDITIONAL_MAP) but not its enforcement half (no pre-append alignment "
            "check, no post-append arm check); every E57 deployment has allow_conditional_map=false. Enabling it "
            "would reproduce D53/D54 on the Python path, so it is recorded as a defect and no cell was run (plan SS5)"},
        "not_claimed": [
            "copy-arm behaviour on this path (VmModule.copy_buffer places its own aligned copy; not reachable)",
            "that OnAIR peaks and cFS peaks are one population (different runtime builds; plan SS2)",
            "latency, accuracy, SBN or OnAIR-cFS bridging",
        ],
    }
    os.makedirs(ROOT, exist_ok=True)
    with open(args.out or os.path.join(ROOT, "summary.json"), "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"verdict": doc["verdict"], "falsifiers": falsified}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
