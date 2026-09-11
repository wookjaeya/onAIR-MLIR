#!/usr/bin/env python3
"""E36: fold the guest cFS raw logs into one verdict document.

Every cell is judged on what the app ITSELF recorded (the admission / map_branch / mem
JSON lines it writes to stdout), never on the harness's expectation of what should have
happened -- E32's D59 is the reason: a cell that reports the number it was approved on is
the only kind that can be checked afterwards.  `budget_source` in particular exists so a
run can testify which budget it judged on, and it is what caught two defects in the change
that introduced it (SS6 of the evidence)."""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CELL_DIR = os.path.join(ROOT, "results", "e36_aarch64_cfs", "smartcam")


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

def cell(name):
    p = os.path.join(CELL_DIR, name + ".log")
    if not os.path.exists(p):
        return {"error": "missing log", "log": None}
    txt = open(p, encoding="utf-8", errors="replace").read()
    st = stages(p)
    adm = (st.get("admission") or [None])[-1]
    mem = (st.get("mem") or [None])[-1]
    mb = (st.get("map_branch") or [None])[-1]
    d = {
        "log": os.path.relpath(p, ROOT),
        "verdict": adm.get("verdict") if adm else None,
        "budget_bytes": adm.get("budget") if adm else None,
        "budget_source": adm.get("budget_source") if adm else None,
        "inferences": mem.get("completed") if mem else 0,
        "run_records": record_count(st, "run"),
        "run_records_unparseable": st.get("__unparsed__", {}).get("run", 0),
        "hal_peak": mem.get("hal_peak") if mem else None,
        "admitted_budget_bytes": mem.get("admitted_budget_bytes") if mem else None,
        "peak_within_admitted_budget": mem.get("peak_within_admitted_budget") if mem else None,
        "admission_mode": mem.get("admission_mode") if mem else None,
        "budget_invalid_event": "BUDGET_INVALID" in txt,
        "exit": (re.findall(r"EXIT=(\d+)", txt) or [None])[-1],
    }
    if mb:
        d["map_branch"] = {k: mb.get(k) for k in
                           ("module_ptr_mod64", "hal_peak_after_append", "arm", "admission_mode")}
    # SS10 stage-2 criterion: the rest of cFS must keep working after a refusal
    if d["verdict"] in ("NOT_ADMITTED",) or d["budget_invalid_event"]:
        after = txt.split("AI_LEARNER")[-1] if "AI_LEARNER" in txt else ""
        tail = txt[txt.find("ExitApp"):] if "ExitApp" in txt else ""
        d["cfs_alive_after_refusal"] = {
            "exit_app_logged": "CFE_ES_ExitApp" in txt,
            "apps_loaded_after": sorted(set(re.findall(r"Loading file: /cf/(\w+)\.so", tail))),
            "log_lines_after_exit": tail.count("\n"),
        }
        del after
    return d


def main():
    cells = {n: cell(n) for n in
             ["regression_no_override", "admit_B", "deny_B_minus_1", "malformed_abc",
              "zero_budget", "cond_denied_without_optin", "cond_positive"]}
    PER_CALL, BOUNDED = 9382092, 18222796
    c = cells
    q1 = (c["deny_B_minus_1"]["verdict"] == "NOT_ADMITTED"
          and c["deny_B_minus_1"]["inferences"] == 0
          and bool(c["deny_B_minus_1"].get("cfs_alive_after_refusal", {}).get("apps_loaded_after"))
          and c["admit_B"]["verdict"] == "ADMIT" and c["admit_B"]["inferences"] > 0)
    q2 = (c["cond_positive"]["verdict"] == "ADMIT_CONDITIONAL_MAP"
          and c["cond_positive"]["hal_peak"] == PER_CALL
          and c["cond_positive"]["admitted_budget_bytes"] == PER_CALL
          and c["cond_positive"]["peak_within_admitted_budget"] is True
          and c["cond_positive"].get("map_branch", {}).get("arm") == "map"
          and c["cond_denied_without_optin"]["verdict"] == "NOT_ADMITTED")
    knob = (c["malformed_abc"]["budget_invalid_event"] and c["malformed_abc"]["inferences"] == 0
            and c["zero_budget"]["budget_invalid_event"] and c["zero_budget"]["inferences"] == 0)
    r = c["regression_no_override"]
    q4 = (r["budget_source"] == "macro" and r["budget_bytes"] == 18222797
          and r["verdict"] == "ADMIT" and r["hal_peak"] == PER_CALL
          and r["admission_mode"] == "unconditional" and r["peak_within_admitted_budget"] is True)
    doc = {
        "experiment": "E36",
        "title": "AArch64 cFS evidence completion -- the refusal cell SS10 stage 2 asked for, "
                 "and the conditional tier under a real flight model",
        "plan": "docs/plans/E36_aarch64_cfs_completion.md (committed before measurement, f3ac80c)",
        "contract": {"bounded": BOUNDED, "per_call": PER_CALL, "constants": 8840704,
                     "source": "results/e32_smartcam_aarch64/build/smartcam.contract.json",
                     "note": "not regenerated -- E32's single-invocation artefacts are reused"},
        "cells": cells,
        "verdicts": {
            "Q1_cfs_budget_refusal": "PASS" if q1 else "FAILED",
            "Q2_lifecycle_conditional": "PASS" if q2 else "FAILED",
            "Q1b_knob_is_fail_closed": "PASS" if knob else "FAILED",
            "Q4_no_override_unchanged": "PASS" if q4 else "FAILED",
            "Q3_resnet_deepae_aarch64": "NOT_RUN (deferred to E36b -- this commit does not claim it)",
            "stage_2_complete": bool(q1 and q2 and knob and q4),
        },
        "not_claimed": [
            "ResNet/DeepAE on AArch64 (Q3): not run here",
            "accuracy: no evaluation set for this model in this environment",
            "latency/throughput: FUNCTIONAL_ONLY host",
            "OnAIR on AArch64 or SBN linkage: out of scope (E33 SS9)",
            "the inference COUNT is timeout-dependent, not an invariant -- only the "
            "deterministic values (verdict, budget, peak, mode) are compared with E32",
        ],
    }
    out = os.path.join(ROOT, "results", "e36_aarch64_cfs", "summary.json")
    with open(out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, ensure_ascii=False)
    print(json.dumps(doc["verdicts"], indent=1, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
