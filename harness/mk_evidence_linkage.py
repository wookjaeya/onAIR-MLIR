#!/usr/bin/env python3
"""E37: 세 실물 모델의 증거 연결표 (기계 판독).

RESEARCH_COMPLETION_ACTIONS.md 필수 작업 B가 요구한 7항목을 모델별로 원자료에 연결한다.

  1. 원본 모델의 출처·파일 해시·입출력 규약
  2. 컴파일러 버전·타깃 옵션·VMFB·계약의 대응
  3. 입력 fixture와 전처리, 원본 실행기의 기준 출력
  4. AArch64 cFS의 승인 예산·실제 판정·추론 실행 여부
  5. 전체 출력 비교 결과
  6. HAL peak와 해당 정책의 승인 예산 비교
  7. 각 결과를 생성한 명령·원시 로그·판정 스크립트

**이 도구는 값을 지어내지 않는다.** 모든 셀 값은 저장소의 원자료 파일에서 읽고, 읽지 못하면
`status="absent"`와 그 이유(파일 부재 / 키 부재 / 값이 null)를 남긴다 — D29의 교훈대로
*신호의 부재*를 *부재라는 신호*로 바꿔 적지 않는다. 셀이 인용하는 모든 경로의 실재와 git 추적
여부도 함께 확인한다(D55의 교훈: EVIDENCE가 인용한 raw log가 저장소에 없던 적이 있다).

7번 항목만은 성격이 다르다. 명령 문자열은 원자료에 기록돼 있지 않으므로(이 도구를 만들며
실측한 사실이다) 이 파일의 `REPRODUCE` 표에 코드로 적고, 그 표가 지목하는 **스크립트와 raw log의
실재를 검사**한다. 즉 명령 자체는 사람이 쓴 기록이되 그것이 가리키는 대상은 기계가 확인한다.
`env` 필드는 그 명령을 재실행하는 데 필요한 환경이며, `rejudged_at_final_version`은 `harness/e37_reproduce_check.py`가 최종 코드로
**판정 계산을 다시 수행해** 보관 판정과 대조한 셀에만 참이다 — 게스트를 다시 돌렸다는 뜻이 아니다(필수 작업 C).
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

ITEMS = {
    "1": "원본 모델의 출처·파일 해시·입출력 규약",
    "2": "컴파일러 버전·타깃 옵션·VMFB·계약의 대응",
    "3": "입력 fixture와 전처리, 원본 실행기의 기준 출력",
    "4": "AArch64 cFS의 승인 예산·실제 판정·추론 실행 여부",
    "5": "전체 출력 비교 결과",
    "6": "HAL peak와 해당 정책의 승인 예산 비교",
    "7": "각 결과를 생성한 명령·원시 로그·판정 스크립트",
    # E48 SS3.1: 항목 8은 1~7의 개명이 아니다. 1~7은 **합성 또는 혼합 입력**으로 밟은 셀을
    # 가리키고(E31 fixture 는 실이미지 3 + 합성 32 + 경계 2), 8은 **공개 실데이터만**으로
    # 같은 경로를 다시 밟은 셀을 가리킨다. 이 저장소가 E45에서 등급으로 분리한 축
    # (모델의 실제성 / 가중치 / **입력의 실제성** / 검증한 성질) 중 세 번째가 바로 이것이라,
    # 같은 사실이 두 자리에 사는 D65 가 아니라 서로 다른 사실이다.
    "8": "공개 실입력으로 같은 경로를 다시 밟은 기록 (AArch64 native·cFS, E48)",
}


def _load(path):
    """JSON 원자료를 읽는다. 실패는 예외가 아니라 사유 문자열로 돌려준다."""
    full = os.path.join(ROOT, path)
    if not os.path.exists(full):
        return None, "file_absent"
    try:
        with open(full, "r", encoding="utf-8") as fh:
            return json.load(fh), None
    except (OSError, json.JSONDecodeError) as exc:  # 크래시로 스위트를 죽이지 않는다(D24/D25)
        return None, "unreadable: %s" % exc


def _dig(obj, locator):
    """`a.b[0].c` 형태의 키 경로를 따라간다. 못 따라가면 (None, 사유)."""
    cur = obj
    for raw in locator.split("."):
        key, _, idx = raw.partition("[")
        if key:
            if not isinstance(cur, dict) or key not in cur:
                return None, "key_absent: %s" % locator
            cur = cur[key]
        if idx:
            try:
                i = int(idx.rstrip("]"))
            except ValueError:
                return None, "bad_locator: %s" % locator
            if not isinstance(cur, list) or i >= len(cur):
                return None, "index_absent: %s" % locator
            cur = cur[i]
    return cur, None


def resolve(path, locator):
    """한 원자료 참조를 해결한다. 값이 `None`이면 present가 아니라 null_value로 분류한다."""
    obj, why = _load(path)
    if why:
        return {"path": path, "locator": locator, "status": "absent", "reason": why}
    val, why = _dig(obj, locator)
    if why:
        return {"path": path, "locator": locator, "status": "absent", "reason": why}
    if val is None:
        return {"path": path, "locator": locator, "status": "null_value",
                "reason": "키는 있으나 값이 null — '관측 못 함'과 '관측했고 없음'을 구분해야 한다"}
    return {"path": path, "locator": locator, "status": "present", "value": val}


# admission 셀이 반드시 실어야 하는 하위 키. **부모 객체 단위로 확인하면 안 된다** —
# E37의 첫 판이 `cells.<name>` 을 통째로 resolve해서 E36b DENY 셀의 `inferences` 결손을
# present 로 통과시켰다(적대적 검증이 잡았다). 키 결손과 "거부돼서 값이 없음"은 다르다.
ADMISSION_KEYS = ("verdict", "budget_bytes", "budget_source", "inferences", "hal_peak",
                  "admitted_budget_bytes", "peak_within_admitted_budget", "admission_mode")

# 승인 이후에만 존재하는 양. 거부된 셀에서는 null 이 **맞는 값**이므로 갭으로 세지 않는다.
POST_ADMISSION_KEYS = ("hal_peak", "admitted_budget_bytes", "peak_within_admitted_budget",
                       "admission_mode")
REFUSAL_VERDICTS = ("NOT_ADMITTED", None)


def resolve_cell(path, parent):
    """admission 셀 하나를 **하위 키마다** 해결한다 (부모 객체 통과 금지)."""
    obj, why = _load(path)
    if why:
        return [{"path": path, "locator": parent, "status": "absent", "reason": why}]
    cell, why = _dig(obj, parent)
    if why:
        return [{"path": path, "locator": parent, "status": "absent", "reason": why}]
    verdict = cell.get("verdict") if isinstance(cell, dict) else None
    refused = verdict in REFUSAL_VERDICTS
    # 예산 자체가 해석되지 않은 셀(BUDGET_INVALID)에는 admission 레코드가 아예 없다. 그 null 은
    # 갭이 아니라 **같은 레코드의 양성 신호가 허가하는 값**이다 — 신호의 부재가 아니라 신호가
    # 있어서 null 인 경우다. `budget_invalid_event is True` 를 명시적으로 요구해, 그 필드가
    # 없거나 false 인데 null 인 셀은 여전히 갭으로 남긴다.
    budget_invalid = cell.get("budget_invalid_event") is True if isinstance(cell, dict) else False
    out = []
    for key in ADMISSION_KEYS:
        loc = parent + "." + key
        if not isinstance(cell, dict) or key not in cell:
            out.append({"path": path, "locator": loc, "status": "absent",
                        "reason": "key_absent — 키 결손은 '값이 0/없음'이 아니다(D29)"})
            continue
        val = cell[key]
        if val is None:
            if budget_invalid:
                out.append({"path": path, "locator": loc, "status": "present", "value": None,
                            "note": ("예산이 해석되지 않아 admission 레코드가 없다 — 같은 셀의 "
                                     "budget_invalid_event=true 가 이 null 을 허가한다")})
            elif refused and key in POST_ADMISSION_KEYS:
                out.append({"path": path, "locator": loc, "status": "present",
                            "value": None,
                            "note": "거부된 셀에는 승인 근거가 없으므로 null 이 맞는 값이다"})
            else:
                out.append({"path": path, "locator": loc, "status": "null_value",
                            "reason": "승인 셀인데 값이 null — 관측 못 함과 관측했고 없음이 구분되지 않는다"})
            continue
        out.append({"path": path, "locator": loc, "status": "present", "value": val})
    return out


# --------------------------------------------------------------------------------------
# 셀 정의 — (모델, 항목) → 원자료 참조 목록. 값은 전부 여기서 읽는다.
# --------------------------------------------------------------------------------------

SMARTCAM = "results/p1_smartcam_feasibility"
E31 = "results/e31_smartcam_equivalence"
E32 = "results/e32_smartcam_aarch64"
E33 = "results/e33_onair_official"
E34 = "results/e34_two_models"
E36 = "results/e36_aarch64_cfs"
E36B = "results/e36b_aarch64_models"
E26 = "results/e26_boundary_utility"
E45 = "results/e45_real_inputs"
E48 = "results/e48_real_inputs_aarch64"

CELLS = {
    "smartcam": {
        "display": "OPS-SAT SmartCam (비행 모델)",
        "1": [
            (SMARTCAM + "/source_manifest.json", "source.repo"),
            (SMARTCAM + "/source_manifest.json", "source.commit"),
            (SMARTCAM + "/source_manifest.json", "source.path"),
            (SMARTCAM + "/source_manifest.json", "original_artifact.stored_as"),
            (SMARTCAM + "/source_manifest.json", "original_artifact.sha256"),
            (SMARTCAM + "/source_manifest.json", "original_artifact.bytes"),
            (SMARTCAM + "/source_manifest.json", "original_artifact.modified"),
            (E31 + "/summary.json", "paths.oracle.signature"),
        ],
        "2": [
            (E32 + "/build/smartcam.contract.json", "target"),
            (E32 + "/build/smartcam.contract.json", "artifact.file"),
            (E32 + "/build/smartcam.contract.json", "artifact.sha256"),
            (E32 + "/build/smartcam.contract.json", "artifact.bytes"),
            (E32 + "/build/smartcam.contract.json", "provenance.single_invocation"),
            (E32 + "/build/smartcam.contract.json", "provenance.mlir_sha256"),
            (E32 + "/build/smartcam.contract.json", "resources.bounded_bytes"),
            (E32 + "/build/smartcam.contract.json", "resources.static_per_call_bytes"),
            (E32 + "/build/smartcam.contract.json", "resources.module_resident_constant_bytes"),
            (SMARTCAM + "/build/smartcam.contract.json", "artifact.sha256"),
            (SMARTCAM + "/source_manifest.json", "tools.iree_compile_version"),
        ],
        "3": [
            (E31 + "/fixture/manifest.json", "counts"),
            (E31 + "/summary.json", "fixture.preprocessing"),
            (E31 + "/summary.json", "fixture.resize"),
            (E31 + "/summary.json", "fixture.layout"),
            (E31 + "/summary.json", "paths.oracle.runner"),
            (E31 + "/summary.json", "paths.oracle.model_sha256"),
            (E31 + "/summary.json", "criteria"),
        ],
        "4": [
            (E36 + "/summary.json", "cells.regression_no_override"),
            (E36 + "/summary.json", "cells.admit_B"),
            (E36 + "/summary.json", "cells.deny_B_minus_1"),
            (E36 + "/summary.json", "cells.cond_positive"),
            (E36 + "/summary.json", "cells.cond_denied_without_optin"),
            (E36 + "/summary.json", "cells.malformed_abc"),
            (E36 + "/summary.json", "cells.zero_budget"),
        ],
        "5": [
            (E31 + "/comparison.json", "totals"),
            (E31 + "/comparison.json", "verdict"),
            (E32 + "/native/comparison.json", "totals"),
            (E32 + "/native/comparison.json", "verdict"),
            (E32 + "/cfs/comparison.json", "totals"),
            (E32 + "/cfs/comparison.json", "verdict"),
        ],
        "6": [
            (E36 + "/summary.json", "cells.admit_B.hal_peak"),
            (E36 + "/summary.json", "cells.admit_B.admitted_budget_bytes"),
            (E36 + "/summary.json", "cells.admit_B.peak_within_admitted_budget"),
            (E36 + "/summary.json", "cells.admit_B.admission_mode"),
            (E36 + "/summary.json", "cells.cond_positive.hal_peak"),
            (E36 + "/summary.json", "cells.cond_positive.admitted_budget_bytes"),
            (E36 + "/summary.json", "cells.cond_positive.peak_within_admitted_budget"),
            (E36 + "/summary.json", "cells.cond_positive.admission_mode"),
        ],
        "8": [
            (E45 + "/cells/smartcam/fixture/manifest.json", "counts"),
            (E48 + "/smartcam/staged_inputs.json", "samples"),
            (E48 + "/smartcam/staged_inputs.json", "sha256_inputs_bin"),
            (E48 + "/smartcam/staged_inputs.json", "manifest_hashes_verified"),
            (E48 + "/smartcam/staged_inputs.json", "fixture_manifest_source"),
            (E48 + "/summary.json", "models.smartcam.semantics_native_aarch64.verdict"),
            (E48 + "/summary.json", "models.smartcam.semantics_native_aarch64.elements_failed"),
            (E48 + "/summary.json", "models.smartcam.semantics_cfs_aarch64.verdict"),
            (E48 + "/summary.json", "models.smartcam.x86_64_pip_runtime_E45.verdict"),
            (E48 + "/summary.json", "models.smartcam.verdict_agrees_with_x86"),
            (E48 + "/summary.json", "models.smartcam.cfs_admit_B.verdict"),
            (E48 + "/summary.json", "models.smartcam.cfs_admit_B.inferences"),
            (E48 + "/summary.json", "models.smartcam.cfs_deny_B_minus_1.verdict"),
            (E48 + "/summary.json", "models.smartcam.cfs_deny_B_minus_1.inferences"),
        ],
    },
    "b2_resnet": {
        "display": "MLPerf Tiny ResNet (CIFAR-10 image classification)",
        "1": [
            (E34 + "/summary.json", "originals_preserved.repo"),
            (E34 + "/summary.json", "originals_preserved.commit"),
            (E34 + "/summary.json", "originals_preserved.license"),
            (E34 + "/summary.json", "originals_preserved.files[0].file"),
            (E34 + "/summary.json", "originals_preserved.files[0].source_path"),
            (E34 + "/summary.json", "originals_preserved.files[0].sha256"),
            (E34 + "/summary.json", "originals_preserved.files[0].bytes"),
            (E34 + "/summary.json", "cells.b2_resnet.oracle_runner"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "interface"),
        ],
        "2": [
            (E36B + "/b2_resnet/b2_resnet.contract.json", "target"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "artifact.file"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "artifact.sha256"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "artifact.bytes"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "provenance.single_invocation"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "provenance.mlir_sha256"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "resources.bounded_bytes"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "resources.static_per_call_bytes"),
            (E36B + "/b2_resnet/b2_resnet.contract.json", "resources.module_resident_constant_bytes"),
            (E26 + "/x86_64/ext_b2_resnet/b2_resnet.contract.json", "artifact.sha256"),
            (E36B + "/summary.json", "models.b2_resnet.contract_identical_to_x86_64"),
        ],
        "3": [
            (E34 + "/b2_resnet/fixture/manifest.json", "counts"),
            (E34 + "/summary.json", "cells.b2_resnet.input_shape"),
            (E34 + "/summary.json", "cells.b2_resnet.layout"),
            (E34 + "/summary.json", "cells.b2_resnet.oracle_runner"),
            (E34 + "/b2_resnet/comparison.json", "criteria"),
        ],
        "4": [
            (E36B + "/summary.json", "models.b2_resnet.cfs_admit"),
            (E36B + "/summary.json", "models.b2_resnet.cfs_deny_B_minus_1"),
        ],
        "5": [
            (E34 + "/b2_resnet/comparison.json", "totals"),
            (E34 + "/b2_resnet/comparison.json", "verdict"),
            (E36B + "/b2_resnet/comparison_aarch64.json", "totals"),
            (E36B + "/b2_resnet/comparison_aarch64.json", "verdict"),
            (E36B + "/b2_resnet/comparison_cfs_aarch64.json", "totals"),
            (E36B + "/b2_resnet/comparison_cfs_aarch64.json", "verdict"),
        ],
        "6": [
            (E36B + "/summary.json", "models.b2_resnet.cfs_admit.hal_peak"),
            (E36B + "/summary.json", "models.b2_resnet.cfs_admit.budget"),
            (E36B + "/summary.json", "models.b2_resnet.cfs_admit.peak_within_admitted_budget"),
            (E36B + "/summary.json", "models.b2_resnet.cfs_admit.admission_mode"),
        ],
        "8": [
            (E45 + "/cells/b2_resnet/fixture/manifest.json", "counts"),
            (E48 + "/b2_resnet/staged_inputs.json", "samples"),
            (E48 + "/b2_resnet/staged_inputs.json", "sha256_inputs_bin"),
            (E48 + "/b2_resnet/staged_inputs.json", "manifest_hashes_verified"),
            (E48 + "/b2_resnet/staged_inputs.json", "fixture_manifest_source"),
            (E48 + "/summary.json", "models.b2_resnet.semantics_native_aarch64.verdict"),
            (E48 + "/summary.json", "models.b2_resnet.semantics_native_aarch64.elements_failed"),
            (E48 + "/summary.json", "models.b2_resnet.semantics_cfs_aarch64.verdict"),
            (E48 + "/summary.json", "models.b2_resnet.x86_64_pip_runtime_E45.verdict"),
            (E48 + "/summary.json", "models.b2_resnet.verdict_agrees_with_x86"),
            (E48 + "/summary.json", "models.b2_resnet.cfs_admit_B.verdict"),
            (E48 + "/summary.json", "models.b2_resnet.cfs_admit_B.inferences"),
            (E48 + "/summary.json", "models.b2_resnet.cfs_deny_B_minus_1.verdict"),
            (E48 + "/summary.json", "models.b2_resnet.cfs_deny_B_minus_1.inferences"),
        ],
    },
    "b3_deepae": {
        "display": "MLPerf Tiny Deep AutoEncoder (anomaly detection)",
        "1": [
            (E34 + "/summary.json", "originals_preserved.repo"),
            (E34 + "/summary.json", "originals_preserved.commit"),
            (E34 + "/summary.json", "originals_preserved.license"),
            (E34 + "/summary.json", "originals_preserved.files[1].file"),
            (E34 + "/summary.json", "originals_preserved.files[1].source_path"),
            (E34 + "/summary.json", "originals_preserved.files[1].sha256"),
            (E34 + "/summary.json", "originals_preserved.files[1].bytes"),
            (E34 + "/summary.json", "cells.b3_deepae.oracle_runner"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "interface"),
        ],
        "2": [
            (E36B + "/b3_deepae/b3_deepae.contract.json", "target"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "artifact.file"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "artifact.sha256"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "artifact.bytes"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "provenance.single_invocation"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "provenance.mlir_sha256"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "resources.bounded_bytes"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "resources.static_per_call_bytes"),
            (E36B + "/b3_deepae/b3_deepae.contract.json", "resources.module_resident_constant_bytes"),
            (E26 + "/x86_64/ext_b3_deepae/b3_deepae.contract.json", "artifact.sha256"),
            (E36B + "/summary.json", "models.b3_deepae.contract_identical_to_x86_64"),
        ],
        "3": [
            (E34 + "/b3_deepae/fixture/manifest.json", "counts"),
            (E34 + "/summary.json", "cells.b3_deepae.input_shape"),
            (E34 + "/summary.json", "cells.b3_deepae.layout"),
            (E34 + "/summary.json", "cells.b3_deepae.oracle_runner"),
            (E34 + "/b3_deepae/comparison.json", "criteria"),
        ],
        "4": [
            (E36B + "/summary.json", "models.b3_deepae.cfs_admit"),
            (E36B + "/summary.json", "models.b3_deepae.cfs_deny_B_minus_1"),
        ],
        "5": [
            (E34 + "/b3_deepae/comparison.json", "totals"),
            (E34 + "/b3_deepae/comparison.json", "verdict"),
            (E36B + "/b3_deepae/comparison_aarch64.json", "totals"),
            (E36B + "/b3_deepae/comparison_aarch64.json", "verdict"),
            (E36B + "/b3_deepae/comparison_cfs_aarch64.json", "totals"),
            (E36B + "/b3_deepae/comparison_cfs_aarch64.json", "verdict"),
        ],
        "6": [
            (E36B + "/summary.json", "models.b3_deepae.cfs_admit.hal_peak"),
            (E36B + "/summary.json", "models.b3_deepae.cfs_admit.budget"),
            (E36B + "/summary.json", "models.b3_deepae.cfs_admit.peak_within_admitted_budget"),
            (E36B + "/summary.json", "models.b3_deepae.cfs_admit.admission_mode"),
        ],
        "8": [
            (E45 + "/cells/b3_deepae/fixture/manifest.json", "counts"),
            (E48 + "/b3_deepae/staged_inputs.json", "samples"),
            (E48 + "/b3_deepae/staged_inputs.json", "sha256_inputs_bin"),
            (E48 + "/b3_deepae/staged_inputs.json", "manifest_hashes_verified"),
            (E48 + "/b3_deepae/staged_inputs.json", "fixture_manifest_source"),
            (E48 + "/summary.json", "models.b3_deepae.semantics_native_aarch64.verdict"),
            (E48 + "/summary.json", "models.b3_deepae.semantics_native_aarch64.elements_failed"),
            (E48 + "/summary.json", "models.b3_deepae.semantics_cfs_aarch64.verdict"),
            (E48 + "/summary.json", "models.b3_deepae.x86_64_pip_runtime_E45.verdict"),
            (E48 + "/summary.json", "models.b3_deepae.verdict_agrees_with_x86"),
            (E48 + "/summary.json", "models.b3_deepae.cfs_admit_B.verdict"),
            (E48 + "/summary.json", "models.b3_deepae.cfs_admit_B.inferences"),
            (E48 + "/summary.json", "models.b3_deepae.cfs_deny_B_minus_1.verdict"),
            (E48 + "/summary.json", "models.b3_deepae.cfs_deny_B_minus_1.inferences"),
        ],
    },
}


# --------------------------------------------------------------------------------------
# 항목 7 — 명령·raw log·판정 스크립트.
#
# 명령 문자열은 원자료 어디에도 기록돼 있지 않다(이 도구를 만들며 실측했다: E31~E36b의
# summary.json·EVIDENCE 본문 전부에 argv/command 필드가 0건. 유일한 선례는 E30의
# results/p1_smartcam_feasibility/import/import_log.txt다). 따라서 여기 코드로 적고,
# 이 표가 지목하는 대상은 기계가 확인한다:
#   - `script`  : 저장소에 실재해야 한다
#   - `raw`     : 실재 + git 추적돼야 한다 (D55)
#   - `controls`: (파일, 심볼) 쌍이 그 파일 안에 실제로 있어야 한다 — 게스트 셀의 독립변수가
#                 코드의 어디서 읽히는지를 못박는다 (D61: 설정이 실제 빌드·실행에 도달했는가)
# --------------------------------------------------------------------------------------

REPRODUCE = {
    "smartcam": [
        {
            "cell": "원본 반입 → 한 번의 iree-compile → 계약",
            "env": "iree-compile + 변환기 패키지(tflite/tflite2onnx/onnx)",
            "script": "harness/p1_tflite_to_onnx.py",
            "raw": SMARTCAM + "/import/import_log.txt",
            "note": "8단계 전부의 명령·rc·해시가 그 로그에 축자 기록돼 있다(이 저장소의 유일한 선례).",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "입력 fixture 생성",
            "env": "numpy + Pillow",
            "script": "harness/model_fixture.py",
            "raw": E31 + "/fixture/manifest.json",
            "command": ("python3 harness/model_fixture.py --out RESULTS/fixture --images ... "
                        "--height 224 --width 224 --channels 3 --mean 0 --std 255 "
                        "--layout nchw --synthetic 32 --seed 31 --edge"),
            "rejudged_at_final_version": None,
        },
        {
            "cell": "원본 TFLite oracle (기준 출력)",
            "env": "ai_edge_litert",
            "script": "harness/tflite_oracle.py",
            "raw": E31 + "/oracle_tflite.json",
            "command": ("python3 harness/tflite_oracle.py "
                        + SMARTCAM + "/original/model.tflite --fixture " + E31
                        + "/fixture --out " + E31 + "/oracle_tflite.json"),
            "rejudged_at_final_version": None,
        },
        {
            "cell": "x86-64 pip iree.runtime 실행 + 판정",
            "env": "iree.runtime",
            "script": "harness/e31_compare.py",
            "raw": E31 + "/comparison.json",
            "rejudge_cell": "e31_smartcam_x86_64",
            "command": ("python3 harness/e31_compare.py --oracle " + E31 + "/oracle_tflite.json --iree "
                        + E31 + "/iree_x86_64.json --out " + E31 + "/comparison.json"),
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 native(qemu-user) 실행 + 판정",
            "env": "aarch64 크로스 툴체인 + qemu-user",
            "script": "harness/e32_native_aarch64.py",
            "raw": E32 + "/native/comparison.json",
            "rejudge_cell": "e32_smartcam_native_aarch64",
            "command": ("python3 harness/e32_native_aarch64.py --binary native_learner_smartcam "
                        "--vmfb smartcam.vmfb --contract " + E32
                        + "/build/smartcam.contract.json --fixture " + E31
                        + "/fixture --qemu 'qemu-aarch64 -L /usr/aarch64-linux-gnu'"),
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 cFS 게스트 셀 7개 (승인·거부·조건부·대조군·무효 예산)",
            "env": "qemu-system-aarch64 게스트 + 크로스빌드 cFS",
            "script": "harness/mk_e36_summary.py",
            "raw": E36 + "/summary.json",
            "rejudge_cell": "e36_summary_from_guest_logs",
            "controls": [
                ("native/cfs_app/fsw/src/ai_learner.c", "AI_LEARNER_BUDGET_OVERRIDE"),
                ("native/cfs_app/fsw/src/ai_learner.c", "AI_LEARNER_ALLOW_CONDITIONAL_MAP"),
                ("scripts/51_build_cfs_aarch64.sh", "ALLOW_CONDITIONAL_MAP"),
            ],
            "note": ("셀의 독립변수는 둘뿐이다 — 빌드 시 ALLOW_CONDITIONAL_MAP(조건부 계층 opt-in)과 "
                     "실행 시 AI_LEARNER_BUDGET_OVERRIDE(예산). 각 셀이 어느 값이었는지는 로그 자신의 "
                     "budget_bytes·budget_source·admission_mode 레코드가 증언한다(D61)."),
            "rejudged_at_final_version": None,
        },
        {
            "cell": "cFS 게스트 출력 비교",
            "env": "게스트 산출물 + numpy",
            "script": "harness/e32_cfs_outputs.py",
            "raw": E32 + "/cfs/comparison.json",
            "rejudge_cell": "e32_smartcam_cfs_aarch64",
            "rejudged_at_final_version": None,
        },
    ],
    "b2_resnet": [
        {
            "cell": "원본 보존 + 한 번의 iree-compile(AArch64) → 계약",
            "env": "iree-compile",
            "script": "harness/make_contract.py",
            "raw": E36B + "/b2_resnet/b2_resnet.contract.json",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "입력 fixture + 원본 TFLite oracle",
            "env": "numpy + ai_edge_litert",
            "script": "harness/tflite_oracle.py",
            "raw": E34 + "/b2_resnet/fixture/manifest.json",
            "rejudge_cell": "e34_b2_resnet_x86_64",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 native(qemu-user) 실행 + 판정",
            "env": "aarch64 크로스 툴체인 + qemu-user",
            "script": "harness/e32_native_aarch64.py",
            "raw": E36B + "/b2_resnet/comparison_aarch64.json",
            "rejudge_cell": "e36b_b2_resnet_native_aarch64",
            "note": "D62 이후 출력 arity를 --contract에서 읽는다 — 모델별 분기 0.",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 cFS 승인·거부 셀",
            "env": "qemu-system-aarch64 게스트 + 크로스빌드 cFS",
            "script": "harness/e32_cfs_outputs.py",
            "raw": E36B + "/cfs/resnet_admit_B.log",
            "rejudge_cell": "e36b_b2_resnet_cfs_aarch64",
            "controls": [("native/cfs_app/fsw/src/ai_learner.c", "AI_LEARNER_BUDGET_OVERRIDE")],
            "rejudged_at_final_version": None,
        },
    ],
    "b3_deepae": [
        {
            "cell": "원본 보존 + 한 번의 iree-compile(AArch64) → 계약",
            "env": "iree-compile",
            "script": "harness/make_contract.py",
            "raw": E36B + "/b3_deepae/b3_deepae.contract.json",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "입력 fixture + 원본 TFLite oracle",
            "env": "numpy + ai_edge_litert",
            "script": "harness/tflite_oracle.py",
            "raw": E34 + "/b3_deepae/fixture/manifest.json",
            "rejudge_cell": "e34_b3_deepae_x86_64",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 native(qemu-user) 실행 + 판정",
            "env": "aarch64 크로스 툴체인 + qemu-user",
            "script": "harness/e32_native_aarch64.py",
            "raw": E36B + "/b3_deepae/comparison_aarch64.json",
            "rejudge_cell": "e36b_b3_deepae_native_aarch64",
            "rejudged_at_final_version": None,
        },
        {
            "cell": "AArch64 cFS 승인·거부 셀",
            "env": "qemu-system-aarch64 게스트 + 크로스빌드 cFS",
            "script": "harness/e32_cfs_outputs.py",
            "raw": E36B + "/cfs/deepae_admit_B.log",
            "rejudge_cell": "e36b_b3_deepae_cfs_aarch64",
            "controls": [("native/cfs_app/fsw/src/ai_learner.c", "AI_LEARNER_BUDGET_OVERRIDE")],
            "rejudged_at_final_version": None,
        },
    ],
}


# --------------------------------------------------------------------------------------
# 검증 등급 (필수 작업 D) — 세 축을 **분리**해 기록한다.
#   모델의 실제성 / 가중치의 출처 / 입력 데이터의 실제성 / 실제로 검증한 성질
# "공개된 실제 모델을 썼다"와 "실제 데이터셋으로 검증했다"는 다른 진술이다.
# --------------------------------------------------------------------------------------

GRADES = {
    "smartcam": {
        "model_reality": {
            "grade": "FLIGHT-ARTIFACT",
            "sources": [(SMARTCAM + "/source_manifest.json", "status_in_this_repo"),
                        (SMARTCAM + "/source_manifest.json", "original_artifact.modified")],
        },
        "weights_origin": {
            "grade": "TRAINED (원본 비행 모델에 베이킹됨)",
            "sources": [(SMARTCAM + "/source_manifest.json", "source.path")],
            "note": "가중치는 원본 flatbuffer 안에 있고 이 저장소가 학습하거나 교체하지 않았다.",
        },
        "input_reality": {
            "grade": "MIXED — 실이미지 3 + 합성 32 + 상수 경계 2",
            "sources": [(E31 + "/fixture/manifest.json", "counts"),
                        (E31 + "/fixture/manifest.json", "source.note")],
            "note": "실이미지 3장은 공개 저장소의 예제(mocks/pictures)이지 평가셋이 아니다.",
        },
        "verified_property": {
            "grade": "의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산",
            "sources": [(E31 + "/summary.json", "verdict"),
                        (E36 + "/summary.json", "verdicts")],
        },
        "not_claimed": {"sources": [(E31 + "/summary.json", "not_claimed"),
                                    (E36 + "/summary.json", "not_claimed")]},
    },
    "b2_resnet": {
        "model_reality": {
            "grade": "PUBLIC-PRETRAINED (MLPerf Tiny 참조 모델)",
            "sources": [(E34 + "/summary.json", "originals_preserved.repo"),
                        (E34 + "/summary.json", "originals_preserved.files[0].source_path")],
        },
        "weights_origin": {
            "grade": "TRAINED (MLCommons가 배포한 trained_models)",
            "sources": [(E34 + "/summary.json", "originals_preserved.files[0].source_path")],
            "note": "경로가 trained_models/ 아래이며 이 저장소는 재학습하지 않았다.",
        },
        "input_reality": {
            "grade": "SYNTHETIC-ONLY — 합성 32 + 상수 경계 2, 실데이터 0",
            "sources": [(E34 + "/b2_resnet/fixture/manifest.json", "counts"),
                        (E34 + "/summary.json", "cells.b2_resnet.semantic_grade")],
        },
        "verified_property": {
            "grade": "의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산",
            "sources": [(E36B + "/summary.json", "models.b2_resnet.semantics_cfs_aarch64.verdict"),
                        (E36B + "/summary.json", "verdicts")],
        },
        "not_claimed": {"sources": [(E34 + "/summary.json", "not_claimed"),
                                    (E36B + "/summary.json", "not_claimed")]},
    },
    "b3_deepae": {
        "model_reality": {
            "grade": "PUBLIC-PRETRAINED (MLPerf Tiny 참조 모델)",
            "sources": [(E34 + "/summary.json", "originals_preserved.repo"),
                        (E34 + "/summary.json", "originals_preserved.files[1].source_path")],
        },
        "weights_origin": {
            "grade": "TRAINED (MLCommons가 배포한 trained_models)",
            "sources": [(E34 + "/summary.json", "originals_preserved.files[1].source_path")],
            "note": "경로가 trained_models/ 아래이며 이 저장소는 재학습하지 않았다.",
        },
        "input_reality": {
            "grade": "SYNTHETIC-ONLY — 합성 32 + 상수 경계 2, 실데이터 0",
            "sources": [(E34 + "/b3_deepae/fixture/manifest.json", "counts"),
                        (E34 + "/summary.json", "cells.b3_deepae.semantic_grade")],
        },
        "verified_property": {
            "grade": "의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산",
            "sources": [(E36B + "/summary.json", "models.b3_deepae.semantics_cfs_aarch64.verdict"),
                        (E36B + "/summary.json", "verdicts")],
        },
        "not_claimed": {"sources": [(E34 + "/summary.json", "not_claimed"),
                                    (E36B + "/summary.json", "not_claimed")]},
    },
}


def _git_tracked(rel):
    """git이 이 경로를 추적하는가. git이 없거나 실패하면 None(모름) — False로 단정하지 않는다."""
    try:
        out = subprocess.run(["git", "-C", ROOT, "ls-files", "--error-unmatch", rel],
                             capture_output=True, text=True, timeout=30)
    except (OSError, subprocess.SubprocessError):
        return None
    return out.returncode == 0


REPRODUCE_CHECK = "results/evidence_linkage/reproduce_check.json"


def _rejudge_status():
    """`e37_reproduce_check.py`가 남긴 셀별 재판정 결과를 읽는다 (없으면 빈 표)."""
    data, why = _load(REPRODUCE_CHECK)
    if why:
        return {}
    return {c.get("cell"): c.get("identical") for c in data.get("cells", [])}


def _check_reproduce(entries):
    """항목 7의 표가 지목하는 스크립트·로그·제어 심볼이 실재하는지 기계로 확인한다."""
    status = _rejudge_status()
    checked = []
    for e in entries:
        row = dict(e)
        cell = e.get("rejudge_cell")
        if cell:
            # 손으로 적지 않는다 — 재현 검사가 실제로 낸 값을 그대로 읽는다.
            row["rejudged_at_final_version"] = status.get(cell)
        script = e.get("script")
        row["script_exists"] = os.path.exists(os.path.join(ROOT, script)) if script else None
        raw = e.get("raw")
        if raw:
            row["raw_exists"] = os.path.exists(os.path.join(ROOT, raw))
            row["raw_git_tracked"] = _git_tracked(raw) if row["raw_exists"] else False
        controls = []
        for path, symbol in e.get("controls", []):
            full = os.path.join(ROOT, path)
            found = False
            if os.path.exists(full):
                with open(full, "r", encoding="utf-8", errors="replace") as fh:
                    found = symbol in fh.read()
            controls.append({"file": path, "symbol": symbol, "present_in_file": found})
        if controls:
            row["controls"] = controls
        checked.append(row)
    return checked


def build():
    models = {}
    for model, spec in CELLS.items():
        items = {}
        for num in sorted(ITEMS):
            if num == "7":
                entries = _check_reproduce(REPRODUCE.get(model, []))
                bad = [e for e in entries
                       if e.get("script_exists") is False or e.get("raw_exists") is False
                       or e.get("raw_git_tracked") is False
                       or any(not c["present_in_file"] for c in e.get("controls", []))]
                items["7"] = {"item": ITEMS["7"], "entries": entries,
                              "status": "present" if entries and not bad else
                                        ("absent" if not entries else "broken_reference"),
                              "broken": [e["cell"] for e in bad]}
                continue
            if num == "4":
                resolved = []
                for p, loc in spec.get(num, []):
                    resolved.extend(resolve_cell(p, loc))
            else:
                resolved = [resolve(p, loc) for p, loc in spec.get(num, [])]
            missing = [r for r in resolved if r["status"] != "present"]
            items[num] = {
                "item": ITEMS[num],
                "sources": resolved,
                "status": "present" if resolved and not missing else
                          ("absent" if not resolved else "partial"),
                "unresolved": [r["locator"] for r in missing],
            }
        grade = {}
        for axis, gspec in GRADES.get(model, {}).items():
            g = {"sources": [resolve(p, loc) for p, loc in gspec["sources"]]}
            if "grade" in gspec:
                g["grade"] = gspec["grade"]
            if "note" in gspec:
                g["note"] = gspec["note"]
            grade[axis] = g
        models[model] = {"display": spec["display"], "items": items, "grade": grade}

    cells = [(m, n) for m in models for n in ITEMS]
    present = [(m, n) for m, n in cells if models[m]["items"][n]["status"] == "present"]
    not_present = [{"model": m, "item": n, "status": models[m]["items"][n]["status"],
                    "unresolved": models[m]["items"][n].get("unresolved")
                    or models[m]["items"][n].get("broken")}
                   for m, n in cells if models[m]["items"][n]["status"] != "present"]

    return {
        "tool": "harness/mk_evidence_linkage.py",
        "experiment": "E37",
        "purpose": ("RESEARCH_COMPLETION_ACTIONS.md 필수 작업 B — 세 실물 모델의 원본→컴파일→계약→"
                    "입력→AArch64 cFS 판정→전체 출력→HAL peak를 하나의 기계 판독 요약으로 연결한다."),
        "generation_rule": ("모든 값은 원자료 파일에서 읽는다. 읽지 못한 셀은 status=absent와 사유를 "
                            "남기고, 키는 있으나 값이 null이면 present가 아니라 null_value로 분류한다."),
        "items": ITEMS,
        "models": models,
        "totals": {"cells": len(cells), "present": len(present),
                   "not_present": len(not_present)},
        "cells_not_present": not_present,
    }


def _fmt(value, limit=180):
    s = value if isinstance(value, str) else json.dumps(value, ensure_ascii=False)
    s = s.replace("|", "\\|").replace("\n", " ")
    return s if len(s) <= limit else s[: limit - 1] + "…"


def to_markdown(data):
    out = ["# 증거 연결표 — 세 실물 모델 (E37, 자동 생성)", "",
           "이 파일은 `harness/mk_evidence_linkage.py`가 원자료에서 생성한다. **직접 편집하지 말 것.**",
           "각 셀의 값은 인용한 파일의 인용한 키에서 읽은 것이며, 읽지 못한 셀은 그 사실을 남긴다.", ""]
    t = data["totals"]
    out += ["| 셀 | 값 |", "|---|---|",
            "| 전체 | %d (3모델 × 7항목) |" % t["cells"],
            "| present | %d |" % t["present"],
            "| present 아님 | %d |" % t["not_present"], ""]
    if data["cells_not_present"]:
        out += ["## present가 아닌 셀", ""]
        for c in data["cells_not_present"]:
            out.append("- `%s` 항목 %s (%s): %s" % (c["model"], c["item"], c["status"],
                                                    _fmt(c["unresolved"], 200)))
        out.append("")

    for model, m in data["models"].items():
        out += ["## %s (`%s`)" % (m["display"], model), "",
                "### 검증 등급 (모델의 실제성 / 가중치 / 입력의 실제성 / 검증한 성질)", "",
                "| 축 | 등급 | 근거 |", "|---|---|---|"]
        for axis, g in m["grade"].items():
            src = "; ".join("`%s`:`%s`" % (s["path"], s["locator"]) for s in g["sources"])
            out.append("| %s | %s | %s |" % (axis, _fmt(g.get("grade", "—"), 120), src))
        out += ["", "### 7항목 연결", ""]
        for num in sorted(m["items"]):
            it = m["items"][num]
            out += ["#### %s. %s — **%s**" % (num, it["item"], it["status"]), "",
                    "| 값 | 원자료 | 키 |", "|---|---|---|"]
            if num == "7":
                for e in it["entries"]:
                    checks = []
                    if e.get("script_exists") is not None:
                        checks.append("script=%s" % ("있음" if e["script_exists"] else "**없음**"))
                    if e.get("raw_exists") is not None:
                        checks.append("raw=%s" % ("있음" if e["raw_exists"] else "**없음**"))
                    if e.get("raw_git_tracked") is not None:
                        checks.append("git=%s" % ("추적" if e["raw_git_tracked"] else "**미추적**"))
                    for c in e.get("controls", []):
                        checks.append("%s in %s=%s" % (c["symbol"], os.path.basename(c["file"]),
                                                       "예" if c["present_in_file"] else "**아니오**"))
                    r = e.get("rejudged_at_final_version")
                    checks.append("최종코드재판정=%s" % ({True: "동일", False: "**다름**"}.get(r, "해당없음")))
                    out.append("| %s | `%s` | %s |" % (_fmt(e["cell"], 90),
                                                       e.get("raw") or e.get("script") or "—",
                                                       _fmt(", ".join(checks), 200)))
            else:
                for s in it["sources"]:
                    val = _fmt(s.get("value", s.get("reason", ""))) 
                    out.append("| %s | `%s` | `%s` |" % (val, s["path"], s["locator"]))
            out.append("")
    return "\n".join(out) + "\n"


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out-dir", default="results/evidence_linkage")
    ap.add_argument("--check", action="store_true",
                    help="재생성해 보관본과 비교만 하고 쓰지 않는다 (회귀 시험용)")
    args = ap.parse_args(argv)

    data = build()
    md = to_markdown(data)
    out_dir = os.path.join(ROOT, args.out_dir)
    js_path = os.path.join(out_dir, "linkage.json")
    md_path = os.path.join(out_dir, "linkage.md")
    blob = json.dumps(data, ensure_ascii=False, indent=2, sort_keys=False) + "\n"

    if args.check:
        rc = 0
        for path, fresh in ((js_path, blob), (md_path, md)):
            if not os.path.exists(path):
                print("MISSING %s" % path)
                rc = 1
                continue
            with open(path, "r", encoding="utf-8") as fh:
                if fh.read() != fresh:
                    print("DIFFERS %s" % path)
                    rc = 1
        if rc == 0:
            print("보관본이 원자료에서 그대로 재생성된다 (diff 0)")
        return rc

    os.makedirs(out_dir, exist_ok=True)
    with open(js_path, "w", encoding="utf-8") as fh:
        fh.write(blob)
    with open(md_path, "w", encoding="utf-8") as fh:
        fh.write(md)
    t = data["totals"]
    # E48: the cell count used to be the literal 21 here while the total came from the data,
    # so adding item 8 printed "21셀 중 present 24" -- a line that contradicts itself. Print
    # what was counted.
    print("%s\n%s\n%d셀 중 present %d / 그 외 %d"
          % (js_path, md_path, t["cells"], t["present"], t["not_present"]))
    for c in data["cells_not_present"]:
        print("   - %s 항목 %s: %s %s" % (c["model"], c["item"], c["status"], c["unresolved"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
