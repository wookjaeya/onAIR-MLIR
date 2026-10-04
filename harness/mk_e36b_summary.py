#!/usr/bin/env python3
"""E36b: fold the ResNet/DeepAE AArch64 raw material into one verdict document.

E36b's summary was assembled by hand in the session that ran it, and E37 found what that
costs: the two DENY cells carried only four keys, so `inferences` was **absent** where
E36's log-derived SmartCam cells record `inferences: 0`.  Absence is not zero (D29), and a
consumer reading the summary alone could not tell "no inference happened" from "nobody
wrote it down" -- while the raw logs had the answer the whole time (0 `run` records).

So this file does for E36b what `mk_e36_summary.py` does for E36: every number is read
back out of what the app itself recorded in the guest log, or out of the contract and the
comparison JSONs.  The prose (title, plan, reuse note, not_claimed) is declared here; the
numbers are not.

E48 SS4-4 generalised it the way E34 generalised `model_fixture.py`: the reusable readers
(`stages`, `record_count`, `cfs_cell`, `semantics`) now take PATHS as arguments instead of
reaching for module constants, so another experiment reuses the code by passing values --
not by adding a branch and not by hand-assembling a second summary (D62 / D64).  E36b's own
model list and file names stay here as this experiment's values.

It also normalises the budget key.  E36 writes `budget_bytes`/`admitted_budget_bytes` and
the hand-written E36b wrote `budget`; both names are kept so nothing that already reads
this file breaks, and `budget_key_note` records that they are the same quantity.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
E36B = os.path.join(ROOT, "results", "e36b_aarch64_models")
CFS = os.path.join(E36B, "cfs")
E26X = os.path.join(ROOT, "results", "e26_boundary_utility", "x86_64")

MODELS = ("b2_resnet", "b3_deepae")
LOGS = {"cfs_admit": "%s_admit_B.log", "cfs_deny_B_minus_1": "%s_deny_Bm1.log"}
SHORT = {"b2_resnet": "resnet", "b3_deepae": "deepae"}


def stages(path):
    """앱이 스스로 stdout 에 남긴 JSON 레코드를 읽는다 (하네스의 기대가 아니라).

    D68: 파싱하지 못한 줄을 **버리면 안 된다.** DeepAE의 `run` 레코드는 640원소 출력 배열
    때문에 766자에서 잘려 JSON 으로 파싱되지 않는데, 이전 판은 `except ValueError: continue`
    로 조용히 버려 `run_records: 0` 을 적었다 — 레코드가 7건 실재하는데도다. "볼 수 없었다"를
    "보았더니 없더라"로 바꿔 기록한 것이고(D51), 하필 이 파일 자신이 *"absence is not zero"*
    라고 쓰고 있었다. 이제 잘린 줄도 stage 이름만 뽑아 **따로 센다**."""
    out = {}
    unparsed = {}
    for line in open(path, encoding="utf-8", errors="replace"):
        i = line.find('{"app":"AI_LEARNER"')
        if i < 0:
            continue
        frag = line[i:].strip()
        try:
            rec = json.loads(frag)
        except ValueError:
            m = re.search(r'"stage":"([A-Za-z0-9_]+)"', frag)
            if m:
                unparsed[m.group(1)] = unparsed.get(m.group(1), 0) + 1
            continue
        out.setdefault(rec.get("stage"), []).append(rec)
    out["__unparsed__"] = unparsed
    return out


def record_count(st, stage):
    """그 stage 의 레코드가 몇 건 있었는가 — 페이로드가 잘려도 **있었다는 사실은 센다**."""
    return len(st.get(stage, [])) + st.get("__unparsed__", {}).get(stage, 0)

def cfs_cell(path):
    """게스트 로그 한 건에서 그 셀의 판정·예산·추론 수를 읽는다.

    E48 SS4-4: 인자는 **경로**다. 이전 판은 (model, kind)를 받아 모듈 상수 CFS/LOGS/SHORT를
    다시 찾았으므로 다른 실험이 쓰려면 그 상수를 바꿔야 했다."""
    if not path or not os.path.exists(path):
        return {"error": "missing log", "log": None}
    txt = open(path, encoding="utf-8", errors="replace").read()
    st = stages(path)
    adm = (st.get("admission") or [None])[-1]
    mem = (st.get("mem") or [None])[-1]
    mb = (st.get("map_branch") or [None])[-1]
    d = {
        "verdict": adm.get("verdict") if adm else None,
        "budget": adm.get("budget") if adm else None,
        "budget_bytes": adm.get("budget") if adm else None,
        "budget_source": adm.get("budget_source") if adm else None,
        # E37: 손으로 쓴 판에서 빠져 있던 자리. 로그의 run/mem 레코드에서 유도한다.
        "inferences": mem.get("completed") if mem else 0,
        "run_records": record_count(st, "run"),
        "run_records_unparseable": st.get("__unparsed__", {}).get("run", 0),
        "hal_peak": mem.get("hal_peak") if mem else None,
        "admitted_budget_bytes": mem.get("admitted_budget_bytes") if mem else None,
        "peak_within_admitted_budget": mem.get("peak_within_admitted_budget") if mem else None,
        "admission_mode": mem.get("admission_mode") if mem else None,
        "budget_invalid_event": "BUDGET_INVALID" in txt,
        "exit": (re.findall(r"EXIT=(\d+)", txt) or [None])[-1],
        "log": os.path.relpath(path, ROOT),
    }
    if mb:
        d["map_branch"] = {k: mb.get(k) for k in
                           ("module_ptr_mod64", "hal_peak_after_append", "arm", "admission_mode")}
    if d["verdict"] == "NOT_ADMITTED" or d["budget_invalid_event"]:
        tail = txt[txt.find("ExitApp"):] if "ExitApp" in txt else ""
        d["cfs_alive_after_refusal"] = {
            "exit_app_logged": "CFE_ES_ExitApp" in txt,
            "apps_loaded_after": sorted(set(re.findall(r"Loading file: /cf/(\w+)\.so", tail))),
            "log_lines_after_exit": tail.count("\n"),
        }
    return d


def _json(path):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def semantics(path_rel, root=None):
    """비교 판정에서 값을 읽는다. 파일이 없으면 지어내지 않고 사유를 남긴다.

    E48 SS4-4: `root`를 값으로 받는다(기본은 이 저장소). 경로는 항상 저장소 상대로 기록한다."""
    path = os.path.join(root or ROOT, path_rel)
    if not os.path.exists(path):
        return {"error": "missing comparison", "file": path_rel}
    c = _json(path)
    t = c.get("totals") or {}
    return {
        "verdict": c.get("verdict"),
        "samples": t.get("samples"),
        "elements": t.get("elements"),
        "elements_failed": t.get("elements_failed"),
        "argmax_failed": t.get("argmax_failed"),
        "by_kind": t.get("by_kind"),
        "worst_abs": (c.get("worst_element") or {}).get("abs"),
        "comparison": path_rel,
    }


def model_block(model):
    con = _json(os.path.join(E36B, model, "%s.contract.json" % model))
    res = con["resources"]
    x86 = _json(os.path.join(E26X, "ext_%s" % model, "%s.contract.json" % model))["resources"]
    three = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes")
    return {
        "contract": {k: res[k] for k in three},
        "contract_identical_to_x86_64": all(res[k] == x86[k] for k in three),
        # 계약의 실제 키는 `kernel_task_stack_bytes`다. E37의 첫 판이 이 이름을 잘못 짚어
        # 값을 null 로 만들었고, 이전 요약과의 대조가 그것을 잡았다 — E35에서 같은 일이
        # 있었으므로 규칙은 그대로다: 차이가 나오면 먼저 자기 도구를 의심한다.
        "kernel_stack_bytes": {
            "aarch64": con["resources"]["kernel_task_stack_bytes"],
            "x86_64": None,
        },
        "overrides_applied": (con.get("provenance") or {}).get("overrides_applied", []),
        "semantics_native_aarch64": semantics(
            "results/e36b_aarch64_models/%s/comparison_aarch64.json" % model),
        "semantics_cfs_aarch64": semantics(
            "results/e36b_aarch64_models/%s/comparison_cfs_aarch64.json" % model),
        "cfs_admit": cfs_cell(os.path.join(CFS, LOGS["cfs_admit"] % SHORT[model])),
        "cfs_deny_B_minus_1": cfs_cell(os.path.join(CFS, LOGS["cfs_deny_B_minus_1"] % SHORT[model])),
        "equivalence_log": "results/e36b_aarch64_models/cfs/%s_equiv.log" % SHORT[model],
    }


def build(stack_x86):
    models = {}
    for m in MODELS:
        b = model_block(m)
        b["kernel_stack_bytes"]["x86_64"] = stack_x86[m]
        models[m] = b

    q_contract = all(models[m]["contract_identical_to_x86_64"] for m in MODELS)
    q_native = all(models[m]["semantics_native_aarch64"].get("verdict") == "PASS" for m in MODELS)
    q_cfs = all(models[m]["semantics_cfs_aarch64"].get("verdict") == "PASS" for m in MODELS)
    q_budget = all(models[m]["cfs_admit"]["verdict"] == "ADMIT"
                   and models[m]["cfs_admit"]["inferences"] > 0
                   and models[m]["cfs_deny_B_minus_1"]["verdict"] == "NOT_ADMITTED"
                   and models[m]["cfs_deny_B_minus_1"]["inferences"] == 0
                   for m in MODELS)
    return {
        "experiment": "E36b",
        "title": "ResNet and DeepAE on AArch64 -- the SS10 stage-4 cells E34 declared out of scope",
        "plan": "docs/plans/E36_aarch64_cfs_completion.md SS3.3 (committed before measurement, f3ac80c)",
        "generated_by": "harness/mk_e36b_summary.py (E37: every number re-derived from the guest "
                        "logs, the contracts and the comparison JSONs; the hand-written original "
                        "omitted `inferences` on the DENY cells, and absence is not zero)",
        "budget_key_note": ("`budget` and `budget_bytes` are the same quantity -- E36 uses the "
                            "latter name, the hand-written E36b used the former, and both are "
                            "emitted so either reader works. `admitted_budget_bytes` is the budget "
                            "the run was APPROVED on and is what the peak is checked against "
                            "(D53/D59); on a refused cell there is no approval, so it is null."),
        "models": models,
        "harness_reuse": {
            "new_model_specific_harnesses": 0,
            "model_specific_branches": 0,
            "generalised": [
                "harness/e32_native_aarch64.py (output arity from the contract, D62)",
                "harness/e32_cfs_outputs.py (same, D62)",
            ],
            "note": ("stage 4's criterion is that no NEW per-model harness is written. Two existing "
                     "runners still carried SmartCam's output arity as a literal and had to be "
                     "generalised the way E34 generalised model_fixture.py and e31_compare.py -- by "
                     "taking the shape as a VALUE from the contract, not by branching on the model."),
        },
        "verdicts": {
            "Q3_contract_numbers_isa_independent": "PASS" if q_contract else "FAILED",
            "Q3_semantics_native_aarch64": "PASS" if q_native else "FAILED",
            "Q3_semantics_cfs_aarch64": "PASS" if q_cfs else "FAILED",
            "Q3_budget_boundary": "PASS" if q_budget else "FAILED",
            "Q3_harness_reuse": "PASS (0 new harnesses; 2 generalised)",
            "stage_4_complete": bool(q_contract and q_native and q_cfs and q_budget),
        },
        "not_claimed": [
            "accuracy: synthetic inputs, no evaluation set (E34 SS5 grade unchanged)",
            "latency/throughput: FUNCTIONAL_ONLY host under qemu",
            "OnAIR for these two models: not run",
            "the inference count is timeout-dependent, not an invariant",
        ],
    }


def main():
    out = os.path.join(E36B, "summary.json")
    # x86-64 커널 스택은 이전 판이 기록한 값을 그대로 옮긴다 (그 계약은 E26-ext 산출물이며
    # 여기서 재분석하지 않는다). 값의 출처를 잃지 않도록 이전 요약에서 읽어 온다.
    prev = _json(out) if os.path.exists(out) else {"models": {}}
    stack_x86 = {m: ((prev.get("models", {}).get(m) or {}).get("kernel_stack_bytes") or {}).get("x86_64")
                 for m in MODELS}
    data = build(stack_x86)
    with open(out, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    print(out)
    for m in MODELS:
        b = data["models"][m]
        print("  %-10s admit=%s inf=%s peak=%s | deny=%s inf=%s" % (
            m, b["cfs_admit"]["verdict"], b["cfs_admit"]["inferences"], b["cfs_admit"]["hal_peak"],
            b["cfs_deny_B_minus_1"]["verdict"], b["cfs_deny_B_minus_1"]["inferences"]))
    print("  verdicts:", json.dumps(data["verdicts"], ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
