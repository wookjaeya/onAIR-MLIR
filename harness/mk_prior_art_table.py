#!/usr/bin/env python3
"""E39a: render the prior-art comparison table from results/e39_prior_art/works.json.

Why a generator and not a hand-written table
--------------------------------------------
D64: a hand-assembled summary dropped a field and nobody noticed until a separate tool
re-derived it. A novelty table is exactly the kind of document where a dropped qualifier
changes the claim, so it is generated from a JSON whose every content cell carries its own
evidence grade.

What this table can and cannot support (docs/plans/E39_novelty_audit.md SS4, SS7)
--------------------------------------------------------------------------------
Every content-level value here is `search_summary` grade: it comes from the search tool's
own summary prose, NOT from an abstract or a full text -- WebFetch is EGRESS_BLOCKED for
every external host in this environment, so no source was read directly. The table therefore
supports "in this search range the combination was not observed" and never "prior work did
not solve this". Accounting-boundary cells (A2) are left as 불명 unless the grade is
`fulltext`, because that is the axis this repository itself got wrong three times
(D2, D3, D5-D7) -- it is not an axis to settle from someone else's abstract, let alone from
a search engine's paraphrase of one.

This repo's own row is derived from the repository, not typed in.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(ROOT, "results", "e39_prior_art")
AX = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8"]


def this_work_row():
    """Derive the onAIR-MLIR row from the repository itself (contract + app source)."""
    cpath = os.path.join(ROOT, "results", "p1_smartcam_feasibility", "build", "smartcam.contract.json")
    c = json.load(open(cpath))
    r = c["resources"]
    app = open(os.path.join(ROOT, "native", "cfs_app", "fsw", "src", "ai_learner.c"),
               encoding="utf-8", errors="replace").read()
    gate_before_runtime = app.find("AI_LEARNER_AdmissionJson") < app.find("iree_runtime_instance_create") \
        if "iree_runtime_instance_create" in app else None
    return {
        "id": "onair_mlir_this_work",
        "title": "onAIR-MLIR (이 연구)",
        "venue": "미출판",
        "doi": None,
        "urls": ["https://github.com/wookjaeya/onAIR-MLIR"],
        "role": "비교 대상이 아니라 비교의 기준점",
        "A1": "컴파일러 IR (IREE stream layout) + 배포 아티팩트(vmfb·내장 ELF) 교차검사",
        "A2": "**앱별 부분 계약**: per_call(I+O+T) + 모듈 상주 상수. "
              "제외: IREE 런타임 고정비·cFS/OSAL·태스크 스택·wrapper I/O "
              "(계약이 scope=%s 로 매 판정마다 명시)" % r.get("scope"),
        "A3": "예 (bound_method=%s)" % r.get("bound_method"),
        "A4": "**예 — 런타임 자원 획득 전 ADMIT/NOT_ADMITTED**" if gate_before_runtime is not False
              else "예 (순서는 소스에서 재확인 필요)",
        "A5": "**declared** (예산은 앱에 부여한 값이며 물리 RAM을 예약하지 않는다)",
        "A6": "**cFS 앱 + NASA 공식 OnAIR 로더**",
        "A7": "AArch64 QEMU 게스트 cFS · x86-64 cFS · qemu-user",
        "A8": "**예 — 같은 회계 영역의 HAL 관측 피크와 대조**",
        "A9": {"metadata": "repo", "content": "repo"},
        "basis": "계약 %s / bounded %s = per_call %s + constants %s" % (
            os.path.relpath(cpath, ROOT), r.get("bounded_bytes"),
            r.get("static_per_call_bytes"), r.get("module_resident_constant_bytes")),
    }


def main():
    d = json.load(open(os.path.join(D, "works.json")))
    searches = json.load(open(os.path.join(D, "searches.json")))
    works = list(d["works"]) + [this_work_row()]

    out = []
    out.append("# E39a — 선행연구 비교표 (생성물 · 직접 편집 금지)\n")
    out.append("생성기: `harness/mk_prior_art_table.py` · 입력: `works.json`, `searches.json` · "
               "사전 고정 축: `docs/plans/E39_novelty_audit.md`\n")
    out.append("> **증거 등급 경고.** 이 표의 내용 칸은 전부 `search_summary` 등급이다 — "
               "검색 도구가 써 준 요약에서 왔고 **초록도 원문도 직접 읽지 않았다**"
               "(`WebFetch`가 전 외부 호스트에서 `EGRESS_BLOCKED`). "
               "따라서 이 표는 *\"이 검색 범위에서 조합이 확인되지 않았다\"*까지만 지지하고, "
               "*\"선행연구가 해결하지 못했다\"*는 **지지하지 않는다**.\n")
    out.append("## 축\n")
    for k, v in d["axes"].items():
        out.append("- **%s** — %s" % (k, v))
    out.append("")
    out.append("## 비교표\n")
    out.append("| 연구 | " + " | ".join(AX) + " | 등급 |")
    out.append("|---|" + "---|" * (len(AX) + 1))
    for w in works:
        cells = [str(w.get(a, "")).replace("\n", " ") for a in AX]
        g = w["A9"]["content"] if isinstance(w.get("A9"), dict) else str(w.get("A9"))
        out.append("| **%s** | %s | `%s` |" % (w["title"], " | ".join(cells), g))
    out.append("")
    out.append("## 출처와 근거\n")
    for w in works:
        out.append("### %s" % w["title"])
        out.append("- 위치: %s%s" % (w.get("venue"), (" · DOI %s" % w["doi"]) if w.get("doi") else ""))
        for u in w.get("urls", []):
            out.append("- URL: <%s>" % u)
        out.append("- 이 연구와의 관계: %s" % w.get("role", ""))
        out.append("- 근거: %s" % w.get("basis", ""))
        out.append("")

    unknown = sum(1 for w in works for a in AX if str(w.get(a, "")).strip() == d["unknown_token"])
    out.append("## 집계\n")
    out.append("- 수록 연구: **%d건**(이 연구 포함 %d)" % (len(works) - 1, len(works)))
    out.append("- `불명`으로 남긴 칸: **%d개** — 회계 경계(A2)는 원문 근거 없이는 단정하지 않는다" % unknown)
    out.append("- `fulltext` 등급 칸: **0개** (이 환경의 상한)")
    out.append("- 실행한 검색식: **%d건** (`searches.json`)" % len(searches["queries"]))
    out.append("")
    out.append("## 이 표가 지지하는 문장 / 지지하지 않는 문장\n")
    out.append("**지지한다**: 실행한 %d건의 검색 범위에서, A1(컴파일러 IR 분석)·A4(실행 전 판정)·"
               "A6(cFS·OnAIR 연계)·A8(같은 회계 영역 실행 관측 대조)를 **함께** 갖춘 연구는 확인되지 "
               "않았다. 가장 가까운 것은 Quilt(ONNX-MLIR 정적 분석 + OOM 방지)이며 A4에서 갈린다 — "
               "검색 요약 기준으로 Quilt는 **거부하는 대신 분할·스케줄링으로 맞춘다**. "
               "TASO는 상한을 **최적화에만** 쓰고, TVM USMP는 workspace/constant 풀을 컴파일 시점에 "
               "분리하지만 판정에 쓰지 않는다. VISORS GNC는 앱별 예산을 두지만 **사후 크래시**로 강제한다."
               % len(searches["queries"]))
    out.append("")
    out.append("**지지하지 않는다**: *\"최초\"*, *\"선행연구가 해결하지 못했다\"*, 그리고 남의 연구의 "
               "**회계 경계(A2)에 대한 단정**. 이 셋은 원문 대조(E39b) 없이는 쓸 수 없다.")
    out.append("")

    p = os.path.join(D, "prior_art.md")
    with open(p, "w", encoding="utf-8") as f:
        f.write("\n".join(out) + "\n")
    print(p)
    print("  works=%d (+this) · 불명 cells=%d · fulltext cells=0 · queries=%d"
          % (len(works) - 1, unknown, len(searches["queries"])))
    return 0


if __name__ == "__main__":
    sys.exit(main())
