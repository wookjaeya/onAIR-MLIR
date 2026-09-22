#!/usr/bin/env python3
"""E56 summary: the conditional tier's precondition-failure refusal, on the evaluation target.

Every number here is read back out of the guest raw logs.  Nothing is transcribed from prose
and nothing is carried over from the x86-64 cells this experiment replaces (E29/E29b): those
ran cFS on the development host, which the standing research directive excludes as a target
and as a validation platform.

Falsifiers F1-F5 are the ones the plan fixed before the measurement
(docs/plans/E56_conditional_refusal_aarch64.md SS4).
"""
import json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
ROOT = os.path.join(REPO, "results", "e56_conditional_refusal_aarch64")

# P and B_u come from the contracts, restated here only as the expected values the plan fixed.
MODELS = {
    "b2_resnet": dict(P=309416,    C=309440,    B_u=618856),
    "b3_deepae": dict(P=6208,      C=1063424,   B_u=1069632),
    "smartcam":  dict(P=9382092,   C=8840704,   B_u=18222796),
    "wgan":      dict(P=131382784, C=4283648,   B_u=135666432),
}


def stages(path):
    """Group the app's own JSON records by stage.  Records the app never wrote stay absent --
    absence is reported as absence, never as zero (D29/D51/D68)."""
    txt = open(path, encoding="utf-8", errors="ignore").read()
    by = {}
    for m in re.finditer(r'\{"app":"AI_LEARNER"[^}]*\}', txt):
        r = json.loads(m.group(0))
        by.setdefault(r.get("stage"), []).append(r)
    peaks = [int(x) for x in re.findall(r"hal_peak=(\d+)", txt)]
    return by, peaks, txt


def cell(model, role):
    tag = "refuse" if role == "refusal" else "admit"
    rel = os.path.join("results", "e56_conditional_refusal_aarch64", "cells", "logs",
                       "e56_%s_%s.log" % (model, tag))
    path = os.path.join(REPO, rel)
    if not os.path.isfile(path):
        return {"model": model, "role": role, "log": rel, "present": False,
                "unavailable_reason": "cell log not archived"}
    by, peaks, txt = stages(path)
    al = (by.get("blob_align") or [{}])[0]
    ad = (by.get("admission") or [{}])[0]
    bc = (by.get("build_config") or [{}])[0]
    verdicts = [r for r in by.get("map_branch", []) if "verdict" in r]
    arms = [r for r in by.get("map_branch", []) if "arm" in r]
    v = MODELS[model]
    out = {
        "model": model, "role": role, "log": rel, "present": True,
        "build_config": {"allow_conditional_map": bc.get("allow_conditional_map")},
        "blob_align": {"requested_offset": al.get("requested_offset"),
                       "state": al.get("state"),
                       "module_ptr_mod64": al.get("module_ptr_mod64")},
        "admission": {"verdict": ad.get("verdict"), "budget": ad.get("budget"),
                      "budget_source": ad.get("budget_source"), "target": ad.get("target"),
                      "bounded": ad.get("bounded"), "per_call": ad.get("per_call")},
        "map_branch_verdict": verdicts[0]["verdict"] if verdicts else None,
        "arm": arms[0].get("arm") if arms else None,
        "hal_peak_after_append": arms[0].get("hal_peak_after_append") if arms else None,
        "inferences": len(by.get("run", [])),
        # D80: "the runtime was not created" is INFERRED from the absence of mem_init.  There is
        # still no direct signal for it; the field name says which it is.
        "mem_init_present": bool(by.get("mem_init")),
        "runtime_created_inferred_from_mem_init": bool(by.get("mem_init")),
        "final_hal_peak": peaks[-1] if peaks else None,
        "cfs_reached_operational": "CFE_ES_OPERATIONAL" in txt or "OPERATIONAL" in txt,
        "exit_app": "CFE_ES_ExitApp" in txt,
    }
    if role == "refusal":
        out["falsifiers"] = {
            "F1_mem_init_present": bool(by.get("mem_init")),
            "F2_inferences_gt_0": len(by.get("run", [])) > 0,
            "F3_offset_not_applied": not (al.get("state") == "applied"
                                          and al.get("module_ptr_mod64") == 8),
            "F5_cfs_not_operational": not ("OPERATIONAL" in txt),
        }
        out["expected"] = {"admission": "ADMIT_CONDITIONAL_MAP", "budget": v["P"],
                           "map_branch_verdict": "MAP_PRECONDITION_UNMET",
                           "module_ptr_mod64": 8, "inferences": 0}
    else:
        out["falsifiers"] = {
            "F4_final_peak_ne_P": not (peaks and peaks[-1] == v["P"]),
        }
        out["expected"] = {"admission": "ADMIT_CONDITIONAL_MAP", "budget": v["P"],
                           "arm": "map", "hal_peak_after_append": 0,
                           "min_inferences": 1, "final_hal_peak": v["P"]}
    bad = [k for k, fired in out["falsifiers"].items() if fired]
    for k, want in out["expected"].items():
        got = {"admission": out["admission"]["verdict"], "budget": out["admission"]["budget"],
               "map_branch_verdict": out["map_branch_verdict"],
               "module_ptr_mod64": out["blob_align"]["module_ptr_mod64"],
               "inferences": out["inferences"], "arm": out["arm"],
               "hal_peak_after_append": out["hal_peak_after_append"],
               "final_hal_peak": out["final_hal_peak"],
               "min_inferences": out["inferences"]}.get(k)
        ok = (got >= want) if k == "min_inferences" else (got == want)
        if not ok:
            bad.append("%s: expected %r got %r" % (k, want, got))
    out["verdict"] = "PASS" if not bad else "FAIL"
    out["failed"] = bad
    return out


def main():
    cells = [cell(m, r) for m in sorted(MODELS) for r in ("refusal", "positive_control")]
    ran = [c for c in cells if c.get("present")]
    doc = {
        "experiment": "E56",
        "title": "Conditional-tier precondition-failure refusal on the evaluation target (AArch64 cFS)",
        "plan": "docs/plans/E56_conditional_refusal_aarch64.md",
        "generated_by": "harness/mk_e56_summary.py",
        "target": "aarch64-unknown-linux-gnu, cFS AI_LEARNER in a QEMU system guest",
        "why": ("Until E56 the only cells exercising this refusal ran cFS on the x86-64 development "
                "host, on a synthetic model, and needed a shim that defeats the app's own 64-byte "
                "alignment. The standing research directive excludes x86-64 as a target and as a "
                "validation platform, so those cells could not carry the claim."),
        "replaces": {
            "cells": ["results/e29_conditional_contract/cfs/b3_deepae_conditional_map_PRECONDITION_FAILED.log",
                      "results/e29b_conditional_verify/cfs/bigact_after_fix_condmap_shim_REFUSED.log"],
            "note": ("Those two x86-64 cells are kept on disk but are no longer cited as evidence. "
                     "The replacement is stronger on three axes: evaluation target instead of the "
                     "development host, four real models instead of one synthetic model plus DeepAE, "
                     "and the application's own knob instead of a shim that defeats its alignment."),
        },
        "enabled_by": {
            "change": "native/cfs_app/fsw/src/ai_learner.c -- AI_LEARNER_BlobAlignOffset",
            "kind": "type (B) over-rejection, narrowed",
            "detail": ("E55b refused every non-zero offset on a build with "
                       "AI_LEARNER_ALLOW_CONDITIONAL_MAP=1, reasoning the knob must not walk around "
                       "the conditional gate. It cannot: with the tier enabled a non-zero offset is "
                       "what makes module_ptr_mod64 != 0, and the pre-append check refuses before any "
                       "runtime exists. The combination is the only way to make the gate fire."),
            "unchanged": ["the knob's other six fail-closed axes",
                          "the pre-append MAP_PRECONDITION_UNMET defence",
                          "the post-append MAP_PRECONDITION_FAILED defence",
                          "unconditional builds (the #if never compiles there)"],
        },
        "cells": cells,
        "verdicts": {
            "cells_run": len(ran),
            "cells_expected": len(cells),
            "refusal_pass": sum(1 for c in ran if c["role"] == "refusal" and c["verdict"] == "PASS"),
            "positive_pass": sum(1 for c in ran if c["role"] == "positive_control" and c["verdict"] == "PASS"),
            "any_falsifier_fired": sorted({k for c in ran for k, v in c["falsifiers"].items() if v}),
            "overall": ("PASS" if ran and len(ran) == len(cells)
                        and all(c["verdict"] == "PASS" for c in ran) else "INCOMPLETE_OR_FAIL"),
        },
        "not_claimed": [
            "Nothing was run on x86-64 for this experiment.",
            ("The refusal preceding runtime creation is INFERRED from the absence of a mem_init "
             "record (D80). The application still emits no direct signal for it."),
            "No accuracy, latency or power claim: platform_check.py reports FUNCTIONAL_ONLY here.",
            ("The positive controls use Software Bus telemetry as features, so they do not replay "
             "the E31/E48 output fixtures and make no output-equivalence claim."),
        ],
    }
    out = os.path.join(ROOT, "summary.json")
    json.dump(doc, open(out, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    print("wrote %s" % os.path.relpath(out, REPO))
    print("overall: %s (refusal %d/4, positive %d/4, falsifiers fired: %s)"
          % (doc["verdicts"]["overall"], doc["verdicts"]["refusal_pass"],
             doc["verdicts"]["positive_pass"], doc["verdicts"]["any_falsifier_fired"] or "none"))
    return 0 if doc["verdicts"]["overall"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
