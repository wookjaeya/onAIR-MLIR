#!/usr/bin/env python3
"""E48: fold the real-input AArch64 raw material into one verdict document.

Every number is read back out of what the app itself recorded in the guest log, out of the
contracts, or out of the comparison JSONs -- nothing here is typed in (D64).  The readers
are imported from `mk_e36b_summary` rather than copied, which is why E48 SS4-4 generalised
that module to take paths as values: two summaries that read the same shape of raw material
must not drift into two implementations of "what the log said".

The E45 x86-64 verdicts are quoted, not recomputed, and the quote names its source file --
E48's question is whether AArch64 agrees, and recomputing x86 here would put the same fact
in a second place that nothing cross-checks (D65).
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

from mk_e36b_summary import cfs_cell, semantics  # noqa: E402

E48 = os.path.join(ROOT, "results", "e48_real_inputs_aarch64")
CFS = os.path.join(E48, "cfs", "logs")

# Per-model VALUES (E34's convention: differences are values, never branches).
MODELS = {
    "b2_resnet": {
        "display": "MLPerf Tiny ResNet (CIFAR-10)",
        "contract": "results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json",
        "x86_cell": "results/e45_real_inputs/cells/b2_resnet/comparison.json",
        "real_inputs": "실 CIFAR-10 200장 (MLPerf Tiny perf_samples_idxs.npy 부분집합)",
    },
    "b3_deepae": {
        "display": "MLPerf Tiny Deep AutoEncoder (ToyADMOS ad01)",
        "contract": "results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json",
        "x86_cell": "results/e45_real_inputs/cells/b3_deepae/comparison.json",
        "real_inputs": "실 log-mel 34창 (EEMBC 배포 바이트는 미반입 — 해시 매니페스트 + 획득 스크립트)",
    },
    "smartcam": {
        "display": "OPS-SAT SmartCam (비행 모델)",
        "contract": "results/e32_smartcam_aarch64/build/smartcam.contract.json",
        "x86_cell": "results/e45_real_inputs/cells/smartcam/comparison.json",
        "real_inputs": "실 비행 썸네일 19장 (pristine, tier B 614x583 JPEG)",
    },
}
THREE = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes")


def _json(path):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def _maybe(path):
    full = os.path.join(ROOT, path)
    if not os.path.exists(full):
        return None
    return _json(full)


def x86_quote(rel):
    """E45 판정을 **인용**한다 — 다시 계산하지 않는다(D65). 없으면 사유를 남긴다."""
    c = _maybe(rel)
    if c is None:
        return {"error": "missing", "file": rel}
    t = c.get("totals") or {}
    return {"verdict": c.get("verdict"), "samples": t.get("samples"), "elements": t.get("elements"),
            "elements_failed": t.get("elements_failed"), "argmax_failed": t.get("argmax_failed"),
            "worst_abs": (c.get("worst_element") or {}).get("abs"), "quoted_from": rel}


def model_block(name, cfg):
    con = _json(os.path.join(ROOT, cfg["contract"]))
    res = con["resources"]
    order = _maybe("results/e48_real_inputs_aarch64/%s/replay_order.json" % name) or []
    stage = _maybe("results/e48_real_inputs_aarch64/%s/staged_inputs.json" % name)
    nat = semantics("results/e48_real_inputs_aarch64/%s/comparison_native_aarch64.json" % name)
    cfs = semantics("results/e48_real_inputs_aarch64/%s/comparison_cfs_aarch64.json" % name)
    admit = cfs_cell(os.path.join(CFS, "%s_admit_B_real.log" % name))
    deny = cfs_cell(os.path.join(CFS, "%s_deny_Bm1_real.log" % name))
    x86 = x86_quote(cfg["x86_cell"])
    return {
        "display": cfg["display"],
        "real_inputs": cfg["real_inputs"],
        "contract": {k: res[k] for k in THREE},
        "kernel_task_stack_bytes": res.get("kernel_task_stack_bytes"),
        "overrides_applied": (con.get("provenance") or {}).get("overrides_applied", []),
        "replay_samples": len(order),
        "replay_kinds": sorted({o.get("kind") for o in order}) if order else [],
        "staged_inputs": stage,
        "semantics_native_aarch64": nat,
        "semantics_cfs_aarch64": cfs,
        "x86_64_pip_runtime_E45": x86,
        "verdict_agrees_with_x86": (
            None if (nat.get("verdict") is None or x86.get("verdict") is None)
            else (nat.get("verdict") == x86.get("verdict"))),
        "cfs_admit_B": admit,
        "cfs_deny_B_minus_1": deny,
    }


def build():
    models = {n: model_block(n, c) for n, c in MODELS.items()}
    got = lambda m, k: (models[m].get(k) or {}).get("verdict")  # noqa: E731

    # Q1: does AArch64 reach the SAME verdict as x86-64 on the same real inputs?
    q1_pairs = {m: models[m]["verdict_agrees_with_x86"] for m in models}
    q1 = all(v is True for v in q1_pairs.values())
    # cFS must reach the same verdict as native on the same ISA, too.
    q1b_pairs = {m: (got(m, "semantics_cfs_aarch64") == got(m, "semantics_native_aarch64")
                     if got(m, "semantics_cfs_aarch64") and got(m, "semantics_native_aarch64") else None)
                 for m in models}
    q1b = all(v is True for v in q1b_pairs.values())

    # Q2: the contract is a function of the model, not of the inputs.
    q2 = all(models[m]["cfs_admit_B"].get("budget") == models[m]["contract"]["bounded_bytes"]
             for m in models)

    # Q3: budget boundary on the real-input cells.
    q3 = all(models[m]["cfs_admit_B"].get("verdict") == "ADMIT"
             and (models[m]["cfs_admit_B"].get("inferences") or 0) > 0
             and models[m]["cfs_deny_B_minus_1"].get("verdict") == "NOT_ADMITTED"
             and models[m]["cfs_deny_B_minus_1"].get("inferences") == 0
             for m in models)

    # Q4: the peak is compared against the budget the run was APPROVED on (D53/D59).
    q4 = all(models[m]["cfs_admit_B"].get("peak_within_admitted_budget") is True
             and models[m]["cfs_admit_B"].get("admitted_budget_bytes")
                 == models[m]["contract"]["bounded_bytes"]
             for m in models)

    # Q5 is an OBSERVATION, not a pass/fail: the plan fixed the wording before measuring.
    b3n = models["b3_deepae"]["semantics_native_aarch64"]
    b3x = models["b3_deepae"]["x86_64_pip_runtime_E45"]
    q5 = {
        "question": "DeepAE의 x86 FAIL이 AArch64에서 어떻게 나오는가",
        "x86_64": {"verdict": b3x.get("verdict"), "elements_failed": b3x.get("elements_failed")},
        "aarch64_native": {"verdict": b3n.get("verdict"), "elements_failed": b3n.get("elements_failed")},
        "aarch64_cfs": {"verdict": models["b3_deepae"]["semantics_cfs_aarch64"].get("verdict"),
                        "elements_failed": models["b3_deepae"]["semantics_cfs_aarch64"].get("elements_failed")},
        "reading": ("계획 SS7이 측정 전에 고정한 문장: 두 ISA 모두 FAIL이면 "
                    "*그 FAIL은 x86 전용 현상이 아니다*까지만 쓴다. 원인 귀속은 하지 않는다(R2/E49)."),
    }

    return {
        "experiment": "E48",
        "title": "공개 실입력의 AArch64 종단 실행 — native(qemu-user)와 cFS 게스트",
        "plan": "docs/plans/E48_real_inputs_aarch64_cfs.md (측정 이전 커밋 4cd26f5)",
        "criterion": ("원소별 abs<=1e-4 OR rel<=1e-5, 기준값은 원본 .tflite를 LiteRT로 돌린 출력. "
                      "E25에서 변경 없이 승계 — E48이 고친 것은 없다."),
        "generated_by": ("harness/mk_e48_summary.py (모든 수치는 게스트 로그·계약·비교 JSON에서 "
                         "유도. 판독기는 mk_e36b_summary 에서 import 한다 — 복사하지 않는다)"),
        "models": models,
        "verdicts": {
            "Q1_native_aarch64_agrees_with_x86_64": "PASS" if q1 else "FAILED",
            "Q1_per_model": q1_pairs,
            "Q1b_cfs_agrees_with_native": "PASS" if q1b else "FAILED",
            "Q1b_per_model": q1b_pairs,
            "Q2_contract_independent_of_inputs": "PASS" if q2 else "FAILED",
            "Q3_budget_boundary_on_real_inputs": "PASS" if q3 else "FAILED",
            "Q4_peak_vs_admitted_budget": "PASS" if q4 else "FAILED",
            "Q5_deepae_observation": q5,
        },
        "not_claimed": [
            "정확도: 세 모델 전부 범위 밖 (E45 SS5의 사유가 모델마다 다르다)",
            "지연·전력: FUNCTIONAL_ONLY 호스트의 QEMU 게스트",
            "WGAN의 AArch64: 재실행이 아니라 신규 반입이므로 별도 실험 (계획 SS5)",
            "OnAIR AArch64: 이 저장소에 AArch64 OnAIR 환경이 없다 (계획 SS5)",
            "조건부 계층: 이번엔 무조건 계층만 — SmartCam 조건부 셀은 E38의 것을 인용한다",
            "DeepAE FAIL의 원인 귀속: R2/E49의 질문이다",
        ],
    }


def main():
    data = build()
    out = os.path.join(E48, "summary.json")
    os.makedirs(E48, exist_ok=True)
    with open(out, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    print(out)
    for m, b in data["models"].items():
        print("  %-10s native=%s cfs=%s (x86 %s) | admit=%s inf=%s peak=%s | deny=%s inf=%s" % (
            m, b["semantics_native_aarch64"].get("verdict"), b["semantics_cfs_aarch64"].get("verdict"),
            b["x86_64_pip_runtime_E45"].get("verdict"),
            b["cfs_admit_B"].get("verdict"), b["cfs_admit_B"].get("inferences"),
            b["cfs_admit_B"].get("hal_peak"),
            b["cfs_deny_B_minus_1"].get("verdict"), b["cfs_deny_B_minus_1"].get("inferences")))
    print("  verdicts:", json.dumps({k: v for k, v in data["verdicts"].items()
                                     if not k.endswith("per_model") and k != "Q5_deepae_observation"},
                                    ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
