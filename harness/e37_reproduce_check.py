#!/usr/bin/env python3
"""E37: 최종 고정 버전으로 보관 원자료를 **다시 판정**해 결과가 그대로인지 확인한다.

RESEARCH_COMPLETION_ACTIONS.md 필수 작업 C — *"코드나 설정이 바뀐 경로, 재현 명령이 누락된
경로만 재실행한다"*.  E36(D61)·E36b(D62)가 `ai_learner.c`·`e32_native_aarch64.py`·
`e32_cfs_outputs.py`를 고쳤으므로, 그 이전에 측정된 셀의 **판정이 최종 코드에서도 같은가**를
실제로 돌려 확인해야 한다.

이 도구가 재현하는 것과 재현하지 않는 것을 분명히 한다.

  재현함 : 보관된 원시 산출물(게스트가 쓴 `outputs.bin`, 각 실행기의 runner JSON, 게스트 raw
           log, 계약 JSON)에서 **판정까지의 계산 전부**를 최종 코드로 다시 수행하고 보관된
           판정과 대조한다. E36b의 두 cFS 셀은 게스트가 쓴 바이트에서 시작하므로 바이트 해석
           (arity·순서·해시 대조)까지 포함한다.
  재현 안 함 : 게스트 부팅·cFS 기동·모델 추론 자체. 그것은 이 스크립트가 아니라 게스트 셀을
           다시 도는 일이며, 이 도구는 그 결과를 *다시 계산*할 뿐이다. 따라서 여기의 PASS를
           "게스트를 다시 돌렸다"로 읽으면 안 된다 — 필드 이름을 `rejudged_*`로 둔 이유다.

값이 달라지면 그것이 곧 결과다. 이 도구는 차이를 숨기지 않고 비교 대상 키를 그대로 보고한다.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HARNESS = os.path.join(ROOT, "harness")
COMPARE_KEYS = ("verdict", "totals", "worst_element")

E31 = "results/e31_smartcam_equivalence"
E32 = "results/e32_smartcam_aarch64"
E33 = "results/e33_onair_official"
E34 = "results/e34_two_models"
E36 = "results/e36_aarch64_cfs"
E36B = "results/e36b_aarch64_models"

ORACLE_SMARTCAM = E31 + "/oracle_tflite.json"


def _run(argv):
    return subprocess.run(argv, cwd=ROOT, capture_output=True, text=True, timeout=1800)


def _load(rel):
    with open(os.path.join(ROOT, rel), "r", encoding="utf-8") as fh:
        return json.load(fh)


def _cmp(stored_rel, fresh_path):
    """보관 판정과 새 판정을 지정한 키에서 비교한다."""
    stored = _load(stored_rel)
    with open(fresh_path, "r", encoding="utf-8") as fh:
        fresh = json.load(fh)
    diff = [k for k in COMPARE_KEYS if stored.get(k) != fresh.get(k)]
    return {
        "identical": not diff,
        "differing_keys": diff,
        "verdict": fresh.get("verdict"),
        "totals": fresh.get("totals"),
        "worst_abs": (fresh.get("worst_element") or {}).get("abs"),
    }


def _argmax_mode(stored_rel):
    """판정 규칙을 새로 고르지 않는다 — 보관 판정이 쓴 모드를 그대로 재사용한다."""
    return (_load(stored_rel).get("criteria") or {}).get("argmax_mode", "require")


def _subset_file(stored_rel, tmp, tag):
    """보관 판정이 선언한 subset 을 그대로 쓴다(사후에 새로 고르지 않는다)."""
    sub = (_load(stored_rel).get("scope") or {}).get("declared_subset")
    if not sub:
        return None
    path = os.path.join(tmp, tag + ".subset.json")
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(sub, fh)
    return path


def rejudge(tag, oracle, iree, stored, tmp, note=""):
    out = os.path.join(tmp, tag + ".json")
    argv = [sys.executable, os.path.join(HARNESS, "e31_compare.py"),
            "--oracle", oracle, "--iree", iree,
            "--argmax", _argmax_mode(stored), "--out", out]
    sub = _subset_file(stored, tmp, tag)
    if sub:
        argv += ["--subset", sub]
    proc = _run(argv)
    if proc.returncode != 0 or not os.path.exists(out):
        return {"cell": tag, "status": "tool_error", "note": note,
                "stderr": proc.stderr.strip()[-400:]}
    res = _cmp(stored, out)
    res.update({"cell": tag, "status": "rejudged", "stored": stored, "note": note})
    return res


def rejudge_from_guest_bytes(model, tmp):
    """게스트가 쓴 원시 f32 바이트에서 시작해 판정까지 다시 계산한다 (E36b cFS 셀)."""
    stored = "%s/%s/comparison_cfs_aarch64.json" % (E36B, model)
    runner = os.path.join(tmp, model + ".cfs_runner.json")
    proc = _run([sys.executable, os.path.join(HARNESS, "e32_cfs_outputs.py"),
                 "--raw", "%s/%s/_work/outputs.bin" % (E36B, model),
                 "--order", "%s/%s/replay_order.json" % (E36B, model),
                 "--vmfb", "%s/%s/%s.vmfb" % (E36B, model, model),
                 "--fixture", "%s/%s/fixture" % (E34, model),
                 "--contract", "%s/%s/%s.contract.json" % (E36B, model, model),
                 "--mode", "batch", "--out", runner])
    if proc.returncode != 0 or not os.path.exists(runner):
        return {"cell": "e36b_%s_cfs_aarch64" % model, "status": "tool_error",
                "stderr": proc.stderr.strip()[-400:]}
    res = rejudge("e36b_%s_cfs_aarch64" % model, "%s/%s/oracle_tflite.json" % (E34, model),
                  runner, stored, tmp,
                  note="게스트가 쓴 outputs.bin 에서 arity·순서·해시 대조를 거쳐 판정까지 재계산")
    return res


def regenerate(tag, argv, stored, tmp, keys):
    """수집기를 다시 돌려 보관 요약과 지정한 키를 대조한다."""
    out = os.path.join(tmp, tag + ".json")
    proc = _run(argv + ["--out", out])
    if proc.returncode != 0 or not os.path.exists(out):
        return {"cell": tag, "status": "tool_error", "stderr": proc.stderr.strip()[-400:]}
    a, b = _load(stored), json.load(open(out, "r", encoding="utf-8"))
    diff = [k for k in keys if a.get(k) != b.get(k)]
    return {"cell": tag, "status": "regenerated", "stored": stored,
            "identical": not diff, "differing_keys": diff,
            "totals": b.get("totals")}


def regenerate_in_place(tag, argv, stored):
    """제자리에 다시 쓰는 수집기는 **보관 내용 자체**와 대조한다.

    처음에는 `git diff` 로 판정했는데 그것은 *"HEAD 와 같은가"*를 묻는 것이라, 생성기를 정당하게
    고쳐 파일이 함께 바뀐 커밋 직전에는 항상 FAIL 이 된다 — 재현성이 아니라 커밋 시점을 재는
    셈이다. 물어야 할 것은 *"지금 있는 원자료에서 다시 만들면 지금 있는 파일과 같은가"*다."""
    path = os.path.join(ROOT, stored)
    before = open(path, "rb").read() if os.path.exists(path) else None
    proc = _run(argv)
    if proc.returncode != 0:
        return {"cell": tag, "status": "tool_error", "stderr": proc.stderr.strip()[-400:]}
    after = open(path, "rb").read() if os.path.exists(path) else None
    same = before is not None and before == after
    return {"cell": tag, "status": "regenerated_in_place", "stored": stored,
            "identical": same,
            "differing_keys": [] if same else ["재생성 결과가 보관 내용과 다르다"]}


def run_all():
    cells = []
    with tempfile.TemporaryDirectory() as tmp:
        cells.append(rejudge("e31_smartcam_x86_64", ORACLE_SMARTCAM,
                             E31 + "/iree_x86_64.json", E31 + "/comparison.json", tmp))
        cells.append(rejudge("e32_smartcam_native_aarch64", ORACLE_SMARTCAM,
                             E32 + "/native/iree_aarch64.json", E32 + "/native/comparison.json", tmp))
        cells.append(rejudge("e32_smartcam_cfs_aarch64", ORACLE_SMARTCAM,
                             E32 + "/cfs/iree_cfs_aarch64.json", E32 + "/cfs/comparison.json", tmp))
        cells.append(rejudge("e33_onair_p_admit", ORACLE_SMARTCAM,
                             E33 + "/p_admit/iree_onair.json", E33 + "/p_admit/comparison.json", tmp,
                             note="공식 OnAIR 로더 셀 — 판정만 재계산(로더 재실행 아님)"))
        for m in ("b2_resnet", "b3_deepae"):
            cells.append(rejudge("e34_%s_x86_64" % m, "%s/%s/oracle_tflite.json" % (E34, m),
                                 "%s/%s/iree_x86_64.json" % (E34, m),
                                 "%s/%s/comparison.json" % (E34, m), tmp))
            cells.append(rejudge("e36b_%s_native_aarch64" % m,
                                 "%s/%s/oracle_tflite.json" % (E34, m),
                                 "%s/%s/iree_aarch64.json" % (E36B, m),
                                 "%s/%s/comparison_aarch64.json" % (E36B, m), tmp,
                                 note="qemu-user AArch64 실행기의 보관 출력에서 판정만 재계산"))
            cells.append(rejudge_from_guest_bytes(m, tmp))
        cells.append(regenerate("e35_policy_matrix",
                                [sys.executable, os.path.join(HARNESS, "e35_baseline_policy_matrix.py")],
                                "results/e35_fair_baseline/summary.json", tmp,
                                ("totals", "disagreeing_cells", "cells", "models")))
        # 게스트를 실제로 다시 돌린 유일한 셀. 여기서는 그 실행의 보관 산출물을 최종 코드로
        # 다시 판정해, E32(D61 이전)의 값과 같은지 확인한다.
        cells.append(rejudge("e37_s_cfs_equivalence_post_d61", ORACLE_SMARTCAM,
                             "results/e37_evidence_consolidation/s_cfs_post_d61/iree_cfs_aarch64.json",
                             "results/e37_evidence_consolidation/s_cfs_post_d61/comparison.json", tmp,
                             note="D61 이후 코드로 게스트에서 실제 재실행한 셀 (§5)"))
        cells.append(regenerate_in_place("e36_summary_from_guest_logs",
                                         [sys.executable, os.path.join(HARNESS, "mk_e36_summary.py")],
                                         E36 + "/summary.json"))
        # 연결표(linkage.json)의 재생성은 여기서 하지 않는다 — 그 표가 이 파일의 결과를 읽으므로
        # 같은 실행 안에서 재생성하면 순환이 된다. 그 검사는 회귀 스위트가 별도로 수행한다.

    ok = [c for c in cells if c.get("identical") is True]
    bad = [c for c in cells if c.get("identical") is False]
    err = [c for c in cells if c.get("status") == "tool_error"]
    return {
        "tool": "harness/e37_reproduce_check.py",
        "experiment": "E37",
        "question": ("최종 고정 코드로 보관 원자료를 다시 판정했을 때 결과가 그대로인가 "
                     "(필수 작업 C)"),
        "what_is_reproduced": ("보관된 원시 산출물에서 판정까지의 계산 전부. E36b 두 셀은 게스트가 "
                              "쓴 outputs.bin 에서 시작한다."),
        "what_is_not_reproduced": ("게스트 부팅·cFS 기동·추론 자체. 이 PASS를 '게스트를 다시 "
                                   "돌렸다'로 읽으면 안 된다."),
        "cells": cells,
        "totals": {"cells": len(cells), "identical": len(ok),
                   "differing": len(bad), "tool_error": len(err)},
        "verdict": "PASS" if (not bad and not err) else "FAIL",
    }


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", default="results/evidence_linkage/reproduce_check.json")
    args = ap.parse_args(argv)
    data = run_all()
    path = os.path.join(ROOT, args.out)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
    for c in data["cells"]:
        mark = {True: "동일", False: "다름"}.get(c.get("identical"), c.get("status"))
        print("  %-34s %s %s" % (c["cell"], mark, c.get("differing_keys") or ""))
    t = data["totals"]
    print("%s\n%d셀 중 동일 %d · 다름 %d · 도구오류 %d → %s"
          % (path, t["cells"], t["identical"], t["differing"], t["tool_error"], data["verdict"]))
    return 0 if data["verdict"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
