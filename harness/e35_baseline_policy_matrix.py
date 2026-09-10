#!/usr/bin/env python3
"""E35 / stage 5: give the artifact-only baseline the SAME conditional knowledge and see
what the MLIR level still decides differently.

The ninth review SS8.3 names this the largest novelty risk: a hardened VMFB-only analyser
already reproduces the contract's three figures, so a comparison that lets only the MLIR
side use the conditional (map-arm) bound would measure execution POLICY, not information.
This collector therefore:

  * derives `bounded / per_call / constants` at BOTH information levels -- (c) from the
    stored contract, (b') from `harness/e27_baseline_vmfb_only_hardened.py`;
  * applies ONE policy implementation (`harness/admission_policy.py`) to both, under both
    the unconditional and the conditional tier;
  * over budget bands fixed by a model-independent RULE (B, P, P-1), so no model gets the
    budget that flatters it (review SS9.2);
  * and separately records what each level can PRODUCE at all -- a figure a level cannot
    produce is recorded as not-produced, never as zero (D51).

It measures rather than assumes the interesting availability question: the embedded ELF
lives inside the vmfb, so `elf_stack_frame.py --vmfb` can run at the artifact-only level
too. Whether it then agrees with the contract's stack figure is a measurement, not an
argument, and it is the kind of claim ("only MLIR can get this") that would be wrong.

Nothing here recompiles, runs a model, or measures memory: it compares DECISIONS.
"""
import argparse
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import admission_policy as ap                                    # noqa: E402

PY = sys.executable

MODELS = [
    ("smartcam_x86_64", "results/p1_smartcam_feasibility/build/smartcam.vmfb",
     "results/p1_smartcam_feasibility/build/smartcam.contract.json"),
    ("smartcam_aarch64", "results/e32_smartcam_aarch64/build/smartcam.vmfb",
     "results/e32_smartcam_aarch64/build/smartcam.contract.json"),
    ("b2_resnet", "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.vmfb",
     "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.contract.json"),
    ("b3_deepae", "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.vmfb",
     "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.contract.json"),
]


def run_json(cmd):
    p = subprocess.run(cmd, capture_output=True, text=True)
    if p.returncode != 0:
        return None, "rc=%d %s" % (p.returncode, (p.stderr or "")[-200:])
    try:
        return json.loads(p.stdout), None
    except ValueError as e:
        return None, "unparsable output: %s" % e


def as_contract(bounded, per_call, constants, method):
    """Wrap three figures in the shape `admission_policy.decide` reads, so BOTH levels go
    through the same decision code rather than each re-implementing the comparison."""
    return {"resources": {"bound_method": method, "bounded_bytes": bounded,
                          "static_per_call_bytes": per_call,
                          "module_resident_constant_bytes": constants}}


def bands(bounded, per_call):
    """Budget bands fixed by RULE, not per model (review SS9.2)."""
    return [("band_above_B", bounded), ("band_between", per_call),
            ("band_below_P", per_call - 1)]


def main():
    ap_ = argparse.ArgumentParser()
    ap_.add_argument("--out", default="results/e35_fair_baseline/summary.json")
    a = ap_.parse_args()

    cells, models = [], {}
    for name, vmfb, contract_p in MODELS:
        vmfb_abs = os.path.join(ROOT, vmfb)
        con_abs = os.path.join(ROOT, contract_p)
        entry = {"vmfb": vmfb, "contract": contract_p}
        if not (os.path.exists(vmfb_abs) and os.path.exists(con_abs)):
            entry["error"] = "artifact or contract missing"
            models[name] = entry
            continue

        con = json.load(open(con_abs, encoding="utf-8"))
        res = con["resources"]
        c_level = {"bounded_bytes": res["bounded_bytes"],
                   "per_call_bytes": res["static_per_call_bytes"],
                   "constants_bytes": res["module_resident_constant_bytes"],
                   # the figure the C header actually carries as CONTRACT_KERNEL_STACK_BYTES
                   "kernel_stack_bytes": res.get("kernel_task_stack_invocation_bytes"),
                   "kernel_stack_frame_bytes": res.get("kernel_task_stack_bytes"),
                   "kernel_stack_classification": res.get("kernel_stack_classification"),
                   "interface_dtypes": sorted({d.get("dtype") for d in
                                               con["interface"].get("inputs", []) +
                                               con["interface"].get("outputs", [])} - {None}),
                   "one_invocation_binding": con.get("provenance", {}).get("single_invocation"),
                   "produced_by": "harness/make_contract.py (MLIR layout IR + dump dir + ELF)"}

        b_raw, err = run_json([PY, os.path.join(HERE, "e27_baseline_vmfb_only_hardened.py"), vmfb_abs])
        if b_raw is None:
            b_level = {"status": "not_produced", "reason": err}
        else:
            b_level = {"status": b_raw.get("status"),
                       "bounded_bytes": b_raw.get("bl1_bounded"),
                       "per_call_bytes": b_raw.get("bl1_per_call"),
                       "constants_bytes": b_raw.get("bl1_constants"),
                       "interface_dtypes": None,
                       "abi_declaration": b_raw.get("abi_declaration"),
                       "refusals": b_raw.get("refusals"),
                       "produced_by": "harness/e27_baseline_vmfb_only_hardened.py "
                                      "(vmfb + iree-dump-module only)"}
            # Availability, measured rather than asserted: the embedded ELF is INSIDE the
            # vmfb, so a stack analysis is not structurally exclusive to the MLIR level.
            s_raw, s_err = run_json([PY, os.path.join(HERE, "elf_stack_frame.py"), "--vmfb", vmfb_abs])
            if s_raw is None:
                b_level["kernel_stack_bytes"] = None
                b_level["kernel_stack_note"] = "not produced: %s" % s_err
            else:
                b_level["kernel_stack_bytes"] = s_raw.get("max_dispatch_invocation_stack_bytes_with_calls")
                b_level["kernel_stack_from"] = "elf_stack_frame.py --vmfb (no dump dir)"
            # one-invocation binding has no counterpart here: with only the vmfb there is
            # nothing to bind it AGAINST. Recorded as not produced, not as a failure.
            b_level["one_invocation_binding"] = None
            b_level["one_invocation_note"] = ("not produced at this level: binding needs a second "
                                              "artifact from the same compile to cross-check against")

        same_numbers = (b_level.get("bounded_bytes") == c_level["bounded_bytes"]
                        and b_level.get("per_call_bytes") == c_level["per_call_bytes"]
                        and b_level.get("constants_bytes") == c_level["constants_bytes"])
        same_stack = (b_level.get("kernel_stack_bytes") == c_level["kernel_stack_bytes"])
        entry.update({"level_c_mlir": c_level, "level_b_artifact_only": b_level,
                      "three_figures_agree": same_numbers,
                      "kernel_stack_agrees": same_stack})
        models[name] = entry

        if not same_numbers or b_level.get("bounded_bytes") is None:
            continue
        method = res["bound_method"]
        for band_name, budget in bands(c_level["bounded_bytes"], c_level["per_call_bytes"]):
            for policy, cond in (("unconditional", False), ("conditional_map", True)):
                dc = ap.decide(as_contract(c_level["bounded_bytes"], c_level["per_call_bytes"],
                                           c_level["constants_bytes"], method), budget,
                               allow_conditional_map=cond)
                db = ap.decide(as_contract(b_level["bounded_bytes"], b_level["per_call_bytes"],
                                           b_level["constants_bytes"], method), budget,
                               allow_conditional_map=cond)
                cells.append({
                    "model": name, "band": band_name, "budget_bytes": budget, "policy": policy,
                    "level_c_verdict": dc["verdict"], "level_b_verdict": db["verdict"],
                    "level_c_admitted_budget": dc["admitted_budget_bytes"],
                    "level_b_admitted_budget": db["admitted_budget_bytes"],
                    "verdicts_agree": dc["verdict"] == db["verdict"],
                })

    disagreeing = [c for c in cells if not c["verdicts_agree"]]
    doc = {
        "tool": "harness/e35_baseline_policy_matrix.py",
        "experiment": "E35",
        "plan": "docs/plans/E35_fair_baseline.md (committed before measurement, 3bc617f)",
        "fairness": {
            "same_policy_code": "harness/admission_policy.py, applied to BOTH levels",
            "conditional_knowledge_given_to_baseline": True,
            "why": "review SS8.3: letting only the MLIR side use the map-arm bound would measure "
                   "execution policy, not information representation",
            "budget_bands": "fixed by rule (B, P, P-1) for every model, so no model receives the "
                            "budget that flatters it (review SS9.2)",
            "recompiled": 0, "models_run": 0,
        },
        "models": models,
        "cells": cells,
        "totals": {
            "cells": len(cells),
            "verdicts_agreeing": sum(1 for c in cells if c["verdicts_agree"]),
            "verdicts_disagreeing": len(disagreeing),
            "models_where_three_figures_agree": sum(1 for m in models.values()
                                                    if m.get("three_figures_agree")),
            "models_where_kernel_stack_agrees": sum(1 for m in models.values()
                                                    if m.get("kernel_stack_agrees")),
            "models_total": len(models),
        },
        "disagreeing_cells": disagreeing,
    }
    out = os.path.join(ROOT, a.out) if not os.path.isabs(a.out) else a.out
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, ensure_ascii=False)
    print(json.dumps(doc["totals"], indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
