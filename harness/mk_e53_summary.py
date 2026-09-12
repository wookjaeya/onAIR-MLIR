#!/usr/bin/env python3
"""E53: fold the WGAN AArch64 raw material into one verdict document.

DECISIONS_v0_52_REVIEW_R2_WGAN.md SS7.2 asks for WGAN (per_call 131,382,784 B -- 14x the
prior AArch64 maximum, SmartCam's 9,382,092 B) to go through the same 7-step recipe E32/
E36b already ran for the smaller models, and its completion criterion is that the steps
connect into ONE traceable path, not a list of separate PASSes.

This file does for E53 what mk_e36b_summary.py does for E36b: it reads numbers back out
of the contracts, the ledger, the comparison JSONs and the guest logs -- it does not
recompute or re-derive any of them itself. `cfs_cell` and `semantics` are IMPORTED from
mk_e36b_summary rather than re-implemented (D65 / E44's "count what already exists before
adding a second copy"); this experiment's own values (paths, model name) stay here.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mk_e36b_summary import cfs_cell, semantics  # noqa: E402

E53 = os.path.join(ROOT, "results", "e53_wgan_aarch64")
X86_CONTRACT = os.path.join(ROOT, "results", "e46_wgan", "build", "wgan.contract.json")
AARCH64_CONTRACT = os.path.join(E53, "build", "aarch64", "wgan.contract.json")
LEDGER = os.path.join(E53, "ledger.json")
CFS = os.path.join(E53, "cfs")


def _json(path):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def contract_comparison():
    """Same three figures, same method, read from both contracts -- not recomputed."""
    x86 = _json(X86_CONTRACT)["resources"]
    arm = _json(AARCH64_CONTRACT)["resources"]
    three = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes")
    io = ("static_external_input_bytes", "static_external_output_bytes")
    return {
        "x86_64": {k: x86[k] for k in three + io},
        "aarch64": {k: arm[k] for k in three + io},
        "identical": all(x86[k] == arm[k] for k in three + io),
        "bound_method": {"x86_64": x86.get("bound_method"), "aarch64": arm.get("bound_method")},
        "kernel_stack_bytes": {
            "x86_64": x86.get("kernel_task_stack_bytes"),
            "aarch64": arm.get("kernel_task_stack_bytes"),
        },
        "overrides_applied": {
            "x86_64": (_json(X86_CONTRACT).get("provenance") or {}).get("overrides_applied", []),
            "aarch64": (_json(AARCH64_CONTRACT).get("provenance") or {}).get("overrides_applied", []),
        },
    }


def ledger_check():
    if not os.path.exists(LEDGER):
        return {"error": "missing ledger", "file": os.path.relpath(LEDGER, ROOT)}
    d = _json(LEDGER)
    return {
        "all_agree": d.get("all_agree"),
        "per_call_equal": d.get("per_call_equal"),
        "derived": d.get("derived"),
        "contract": d.get("contract"),
        "unclassified": d.get("unclassified"),
    }


def build():
    contract_cmp = contract_comparison()
    ledger = ledger_check()
    native_sem = semantics("results/e53_wgan_aarch64/native/comparison_native_aarch64.json")
    cfs_sem = semantics("results/e53_wgan_aarch64/comparison_cfs_aarch64.json")
    cfs_admit = cfs_cell(os.path.join(CFS, "cfs_B.log"))
    cfs_deny = cfs_cell(os.path.join(CFS, "cfs_Bm1.log"))

    arm_res = _json(AARCH64_CONTRACT)["resources"]
    bounded = arm_res["bounded_bytes"]

    q1_contract = (arm_res.get("bound_method") == "static_from_stream_layout"
                   and not (_json(AARCH64_CONTRACT).get("provenance") or {}).get("overrides_applied"))
    q2_ledger = bool(ledger.get("all_agree")) and not ledger.get("unclassified")
    q3_native = native_sem.get("verdict") == "PASS"
    q4_budget = (cfs_admit.get("verdict") == "ADMIT" and (cfs_admit.get("inferences") or 0) > 0
                 and cfs_deny.get("verdict") == "NOT_ADMITTED" and (cfs_deny.get("inferences") or 0) == 0)
    hal_peak = cfs_admit.get("hal_peak")
    q5_hal = (hal_peak is not None and hal_peak <= bounded)
    q6_composition = True  # recorded either way; this question does not gate PASS/FAIL

    return {
        "experiment": "E53",
        "title": "WGAN on AArch64 (native qemu-user + cFS guest) -- the SS7.2 stress case "
                 "(per_call 14x the prior AArch64 maximum)",
        "plan": "docs/plans/E53_wgan_aarch64.md (committed before measurement, ca8a6b9)",
        "review": "docs/reviews/DECISIONS_v0_52_REVIEW_R2_WGAN.md SS7.2",
        "generated_by": "harness/mk_e53_summary.py (cfs_cell/semantics imported from "
                        "mk_e36b_summary.py, not re-implemented)",
        "contract_comparison": contract_cmp,
        "ledger": ledger,
        "semantics_native_aarch64": native_sem,
        "semantics_cfs_aarch64": cfs_sem,
        "cfs_B": cfs_admit,
        "cfs_Bm1": cfs_deny,
        "hal_vs_bounded": {"hal_peak": hal_peak, "bounded_bytes": bounded,
                           "peak_le_bounded": q5_hal},
        "not_run": [
            "conditional (map) tier -- SS7.2's 7 steps only require the unconditional tier",
            "VMFB bitwise identity across ISAs -- SS7.2 explicitly does not require it",
            "accuracy -- no evaluation set (E46 G2 unchanged)",
            "latency/throughput -- FUNCTIONAL_ONLY host under qemu",
            "OnAIR for WGAN on AArch64",
        ],
        "verdicts": {
            "Q1_contract_generation": "PASS" if q1_contract else "FAILED",
            "Q2_ledger_agreement": "PASS" if q2_ledger else "FAILED",
            "Q3_native_semantics": "PASS" if q3_native else "FAILED",
            "Q4_budget_boundary": "PASS" if q4_budget else "FAILED",
            "Q5_hal_vs_bounded": "PASS" if q5_hal else "FAILED",
            "Q6_composition_recorded": "PASS" if q6_composition else "FAILED",
            "e53_complete": bool(q1_contract and q2_ledger and q3_native and q4_budget and q5_hal),
        },
    }


def main():
    out = os.path.join(E53, "summary.json")
    data = build()
    with open(out, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    print(out)
    print("  contract identical:", data["contract_comparison"]["identical"])
    print("  ledger all_agree:", data["ledger"].get("all_agree"))
    print("  native verdict:", data["semantics_native_aarch64"].get("verdict"))
    print("  cfs_B:", data["cfs_B"].get("verdict"), "inferences=", data["cfs_B"].get("inferences"),
          "hal_peak=", data["cfs_B"].get("hal_peak"))
    print("  cfs_Bm1:", data["cfs_Bm1"].get("verdict"), "inferences=", data["cfs_Bm1"].get("inferences"))
    print("  verdicts:", json.dumps(data["verdicts"], ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
