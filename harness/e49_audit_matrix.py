#!/usr/bin/env python3
"""E49: the premise / accounting-scope / admission matrices the validation guide asks for.

`docs/reviews/MEMORY_CONTRACT_CORE_VALIDATION_GUIDE.md` asks for three tables this repository
had the ingredients for but never assembled:

  * SS6 + SS7 (PRE-1..3) -- for each premise the contract declares, is it OBSERVED, only
    ARGUED from source, or not checked at all?
  * SS9 + SS8 (ACC-1..3) -- do `U`, `B` and `H` name the same accounting scope, and what is
    explicitly outside it?
  * SS10 (ADM-1..8) -- does the decision function produce the expected verdict AND the
    expected "did inference start" for each policy cell?

The rule the guide sets in SS11 is the one this repository already learned the hard way
(D29 / D68 / D51): a field that was not measured is `null` with an `unavailable_reason`,
never 0 and never false.  So `max_active_calls_observed` is null here -- the two C runners
create no tasks and the OnAIR plugin no threads (counted, 0/0/0), but counting calls in the
SOURCE is an argument, not an observation, and this file says which of the two it has.

ADM cells are evaluated against the REAL decision function (`harness/admission_policy.py`),
not a restatement of it, so a change in the policy shows up here as a changed cell.
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

import admission_policy as ap                                       # noqa: E402

DEPLOY_SOURCES = {
    "cfs_app": "native/cfs_app/fsw/src/ai_learner.c",
    "native_runner": "native/native_learner.c",
    "onair_plugin": "plugins/compiled_learner/compiled_learner_plugin.py",
}
SPAWN_CALLS = ("pthread_create", "CFE_ES_CreateChildTask", "OS_TaskCreate",
               "threading.Thread", "multiprocessing")


def _read(rel):
    p = os.path.join(ROOT, rel)
    if not os.path.exists(p):
        return None
    with open(p, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def _json(rel):
    p = os.path.join(ROOT, rel)
    if not os.path.exists(p):
        return None
    with open(p, encoding="utf-8") as fh:
        return json.load(fh)


def premise_matrix():
    """PRE-1..3 -- observed vs argued vs unchecked, per premise."""
    spawn = {}
    for name, rel in DEPLOY_SOURCES.items():
        txt = _read(rel)
        if txt is None:
            spawn[name] = {"source_present": False}
            continue
        spawn[name] = {"source_present": True,
                       "spawn_calls": {c: txt.count(c) for c in SPAWN_CALLS},
                       "total": sum(txt.count(c) for c in SPAWN_CALLS)}

    # the conditional tier DOES observe its own premise, and E38 recorded it
    cond = _json("results/e38_optin_record/summary.json") or {}
    cells = cond.get("cells") or {}
    cp = cells.get("cond_positive") or {}
    arm = (cp.get("map_branch") or {})

    return {
        "static_shapes": {
            "status": "OBSERVED",
            "how": "계약 생성기가 entry ABI 에서 유도하고, 동적 형상은 계약이 생성되지 않는다",
            "evidence": "results/e14_aarch64_qemu/*/contracts/contract.dynamic.* "
                        "(bound_method NONE, REFUSED_UNKNOWN_BOUND)",
        },
        "supported_resource_ops": {
            "status": "OBSERVED",
            "how": "E49 allocation ledger 가 네 실물 모델의 entry op 을 전수 분류하고 "
                   "미분류 0 · stream.async.* 0 을 확인한다(D84)",
            "evidence": "results/e49_research_audit/ledger/*.json",
        },
        "max_in_flight_calls_is_1": {
            "status": "ARGUED_FROM_SOURCE",
            "observed_value": None,
            "unavailable_reason": ("배포 경로가 IREE invoke 의 진입·종료에 call id 를 기록하지 "
                                   "않는다. 세어 본 것은 **작업 생성 호출 수**이고 그것은 논증이지 "
                                   "관측이 아니다(지침 PRE-1 은 max_active_calls 관측을 요구한다)."),
            "spawn_call_counts": spawn,
            "measured_elsewhere": ("E41 이 별도 프로브로 N 스레드 동시 호출의 HAL 피크를 쟀다 — "
                                   "그것은 전제를 **어겼을 때** 무슨 일이 생기는지의 측정이지 "
                                   "배포가 전제를 지킨다는 관측이 아니다."),
        },
        "output_released_before_next_call": {
            "status": "SPLIT",
            "c_runners": {"status": "ARGUED_FROM_SOURCE",
                          "how": "두 C 실행기가 호출마다 버퍼뷰를 release 한다(소스 검사)"},
            "onair_plugin": {"status": "NOT_VERIFIED",
                             "observed_value": None,
                             "unavailable_reason": ("D60: p_admit 원자료가 종료 시점 "
                                                    "`nanobind: leaked 10 instances` 를 남긴다. "
                                                    "해제됐다고도, 누수라고도 쓸 수 없다."),
                             "raw": "results/e33_onair_official/p_admit/run.json"},
        },
        "declared_driver_matches_deployment": {
            "status": "OBSERVED",
            "how": "OnAIR 플러그인이 admission·binding 보다 먼저 계약 선언과 배포 driver 를 대조하고 "
                   "선언이 하나도 없으면 거부한다(E41 조건 5)",
            "evidence": "plugins/compiled_learner/artifact_binding.py::check_declared_driver",
        },
        "conditional_map_arm": {
            "status": "OBSERVED" if arm else "NOT_FOUND",
            "observed": {k: arm.get(k) for k in
                         ("module_ptr_mod64", "hal_peak_after_append", "arm", "admission_mode")} or None,
            "how": ("앱이 런타임 생성 **전에** 정렬을 검사하고 append 직후 피크로 분기를 확정한다"
                    "(E29b). 전제 불충족이면 추론 0 으로 거부."),
            "evidence": "results/e38_optin_record/summary.json cells.cond_positive",
        },
    }


def accounting_matrix():
    """ACC-1..3 -- U / B / H and what is outside the scope."""
    con = _json("results/e46_wgan/build/wgan.contract.json") or {}
    ad = (con.get("analysis_domain") or {})
    ar = (con.get("accounting_rules") or {})
    # how many archived contracts actually carry the E40 declaration?
    import glob as _glob                                            # noqa: PLC0415
    tot = carry = 0
    for p in _glob.glob(os.path.join(ROOT, "results", "**", "*.json"), recursive=True):
        try:
            with open(p, encoding="utf-8") as fh:
                c = json.load(fh)
        except Exception:                                           # noqa: BLE001
            continue
        if not isinstance(c, dict) or "resources" not in c or "artifact" not in c:
            continue
        tot += 1
        if c.get("analysis_domain"):
            carry += 1
    return {
        "U_static_bound": {"produced_by": "harness/make_contract.py", "unit": "byte",
                           "time": "compile-time",
                           "includes": "I + O_slab + T_slab (+ C in the unconditional value)",
                           "excludes": (ar.get("excluded") if ar else None)},
        "B_budget": {"produced_by": "배포 설정 (macro / override / argv / deployment_config / none)",
                     "unit": "byte", "time": "admission-time",
                     "scope": "per_app_local_budget",
                     "reservation_semantics": "declared (예약 능력이 있는 호출 0건 — E44)"},
        "H_observed": {"produced_by": "IREE HAL allocator statistics", "unit": "byte",
                       "time": "runtime",
                       "excludes": "allocator 밖 메모리(프로세스 RSS·모듈 이미지·태스크 스택)"},
        "same_scope_id": {
            "declared_in_contract": bool(ad),
            "archived_contracts_total": tot,
            "archived_contracts_carrying_analysis_domain": carry,
            "note": ("E40 이 신설한 `analysis_domain`/`accounting_rules` 는 그 이후에 만든 계약만 "
                     "싣는다 — 보관 계약 %d 개 중 %d 개다. 배포에 쓰인 세 실물 모델의 계약에는 **없다**. "
                     "게이트를 약화시키지는 않는다(driver 검사는 세 자리 중 하나도 없으면 거부 = "
                     "fail-closed)지만, *'계약이 두 분기와 정렬 전제를 선언한다'* 는 서술의 범위가 "
                     "**그 이후 생성분**임을 여기에 적는다. 소급 재생성은 E47 이 실측으로 거부했다"
                     "(축소 dump 에서 재생성하면 provenance 두 필드가 퇴화한다)." % (tot, carry)),
        },
        "module_image_excluded": (ad.get("derived", {}) or {}).get("constant_policy", {}).get(
            "map_arm_scope_note") if ad else None,
    }


def admission_matrix():
    """ADM-1..8 against the REAL decision function."""
    U, P, C = 1000, 400, 600                     # U = P + C, a self-consistent contract
    def contract(bounded=U, per_call=P, consts=C, method="static_from_stream_layout"):
        return {"resources": {"bounded_bytes": bounded, "static_per_call_bytes": per_call,
                              "module_resident_constant_bytes": consts, "bound_method": method}}
    cells = []

    def cell(cid, desc, budget, optin, con, expect_verdict, expect_runs):
        try:
            d = ap.decide(con, budget, allow_conditional_map=optin)
            got, err = d["verdict"], None
        except ap.AdmissionInputError as exc:
            got, err = "INPUT_ERROR", str(exc)[:120]
            d = {}
        # D87 (external review 2026-09-12 SS4.2): this is DERIVED from the verdict
        # by the same policy module the row above calls -- it is not an observation
        # that a runtime started an inference. The old name (`inference_starts`)
        # read like one, which is the D51/D68 shape: a derived value wearing an
        # observation's name. Renamed to say what it is. The observed article is
        # E48's execution logs (inferences actually run / not run per cell); this
        # table's job is the policy function's decision, and the two must not be
        # read as one measurement.
        runs = ap.admitted(got) if err is None else False
        cells.append({"id": cid, "description": desc, "budget": budget, "opt_in": optin,
                      "expected_verdict": expect_verdict, "verdict": got,
                      "expected_execution_authorized_by_policy": expect_runs,
                      "execution_authorized_by_policy": runs,
                      "derived_not_observed": ("execution_authorized_by_policy is computed from the verdict "
                                               "via admission_policy.admitted(); observed inference counts "
                                               "live in E48/E36 run logs, not here"),
                      "admitted_budget_bytes": d.get("admitted_budget_bytes"),
                      "input_error": err,
                      "ok": got == expect_verdict and runs == expect_runs})

    cell("ADM-1", "known bound, B >= U", U, False, contract(), ap.ADMIT, True)
    cell("ADM-2", "known bound, B < P, no opt-in", P - 1, False, contract(), ap.NOT_ADMITTED, False)
    cell("ADM-3", "known bound, P <= B < U, no opt-in", P, False, contract(), ap.NOT_ADMITTED, False)
    cell("ADM-4", "known bound, P <= B < U, opt-in", P, True, contract(), ap.ADMIT_CONDITIONAL_MAP, True)
    cell("ADM-5", "opt-in but B < P (arm cannot help)", P - 1, True, contract(), ap.NOT_ADMITTED, False)
    cell("ADM-6", "unknown bound", U, False, contract(method="NONE"), ap.REFUSED_UNKNOWN_BOUND, False)
    cell("ADM-7", "malformed budget (not an int)", "x", False, contract(), "INPUT_ERROR", False)
    cell("ADM-8", "self-inconsistent contract (U != P + C)", U, False,
         contract(bounded=U + 1), "INPUT_ERROR", False)
    return {"cells": cells, "all_ok": all(c["ok"] for c in cells),
            "policy": "harness/admission_policy.py (the real decision function, not a restatement)",
            "note": ("ADM-5 는 지침 표의 *'copy arm / 전제 실패'* 와 다르다 — 정책 함수는 전제를 "
                     "보지 않는다. 전제 검증은 **런타임**이 하고(E29b: append 전 정렬 검사, "
                     "append 후 피크 != 0 거부) 그것이 D53/D54 가 고친 자리다. 정책 층에서 "
                     "B < P 이면 arm 과 무관하게 거부된다는 것이 여기서 고정하는 사실이다."),
            }


def main():
    out = {
        "tool": "harness/e49_audit_matrix.py",
        "experiment": "E49",
        "guide": "docs/reviews/MEMORY_CONTRACT_CORE_VALIDATION_GUIDE.md (SS6~SS10)",
        "rule": ("측정하지 않은 값은 null + unavailable_reason 이며 0 이나 false 로 대체하지 "
                 "않는다(지침 SS11; 이 저장소의 D29·D51·D68)."),
        "premises": premise_matrix(),
        "accounting_scope": accounting_matrix(),
        "admission_matrix": admission_matrix(),
    }
    d = os.path.join(ROOT, "results", "e49_research_audit")
    os.makedirs(d, exist_ok=True)
    p = os.path.join(d, "audit_matrix.json")
    with open(p, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    print(p)
    for k, v in out["premises"].items():
        print("  premise %-38s %s" % (k, v.get("status")))
    am = out["admission_matrix"]
    print("  ADM cells: %d, all_ok=%s" % (len(am["cells"]), am["all_ok"]))
    for c in am["cells"]:
        if not c["ok"]:
            print("    FAIL", c["id"], c["verdict"], c["expected_verdict"])
    sc = out["accounting_scope"]["same_scope_id"]
    print("  계약 %d개 중 analysis_domain 보유 %d개"
          % (sc["archived_contracts_total"], sc["archived_contracts_carrying_analysis_domain"]))
    return 0 if am["all_ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
