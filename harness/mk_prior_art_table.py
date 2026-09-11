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
Each content cell is supported only to the extent its own grade says. Most are
`search_summary`: the search tool's summary prose, not an abstract and not a full text
(WebFetch is EGRESS_BLOCKED for every external host here). One row is
`fulltext_partial`: Scholar Gateway returned verbatim chunks of the paper, and the row
records WHICH chunks and how many exist -- partial full text is not a full-text check.
E39a's first pass graded every row `search_summary` because it never tried that tool;
that is corrected here rather than left standing. The table therefore
supports "in this search range the combination was not observed" and never "prior work did
not solve this". Accounting-boundary cells (A2) are left as 불명 unless the grade is
`fulltext`, because that is the axis this repository itself got wrong three times
(D2, D3, D5-D7) -- it is not an axis to settle from someone else's abstract, let alone from
a search engine's paraphrase of one.

This repo's own row is derived from the repository, not typed in.
"""
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(ROOT, "results", "e39_prior_art")
AX = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8"]


def a5_reservation():
    """A5 is derived, not typed. Runs the scanner as a subprocess so the table cannot
    accidentally depend on this module's import-time state."""
    out = os.path.join(D, "a5_reservation_scan.json")
    subprocess.run([sys.executable, os.path.join(ROOT, "harness", "budget_provenance.py"),
                    "--out", out], capture_output=True, text=True, check=False)
    with open(out, encoding="utf-8") as f:
        return json.load(f)


def this_work_row():
    """Derive the onAIR-MLIR row from the repository itself (contract + app source)."""
    a5 = a5_reservation()
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
        # E44: A5 used to be this literal string while its neighbours A2/A3 read from the
        # contract. A fact in a place no guard re-checks is D65's shape, so it is DERIVED
        # now -- harness/budget_provenance.py scans the source for reservation-capable calls
        # and the value plus its basis are printed together. A hit downgrades to `unknown`;
        # it never promotes to `enforced` (a call existing is not that call reserving THIS
        # budget -- the E28/D52 distinction).
        "A5": "**%s** — %s (예약 호출 %d건 / 소스 %d파일, `harness/budget_provenance.py`)"
              % (a5["verdict"], "예산은 앱에 부여한 값이며 물리 RAM을 예약하지 않는다"
                 if a5["verdict"] == "declared" else a5["reason"],
                 len(a5["hits"]), a5["files_scanned"]),
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
    out.append("> **증거 등급 경고.** 이 표의 내용 칸은 각 행의 `등급`이 말하는 만큼만 지지된다. "
               "대부분은 `search_summary`(검색 도구가 써 준 요약; 초록도 원문도 직접 읽지 않았다 — "
               "`WebFetch`가 전 외부 호스트에서 `EGRESS_BLOCKED`)이고, `fulltext_partial`은 "
               "Scholar Gateway가 반환한 **일부 청크 본문**이다(받은 청크 번호와 전체 청크 수를 "
               "각 행에 적었다). "
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

    # E39a 2차 정정: 총계 하나만 적고 그 뒤에 "회계 경계(A2)는 ..."를 붙이면, 8축 전체의
    # 합계를 A2 하나의 수로 읽게 된다(실제 10 = A2 5 · A5 3 · A7 1 · A8 1). 한 문장 안에서
    # 수와 설명이 서로 다른 범위를 가리키는 것이 D65의 형태이므로 축별로 세어 적는다.
    per_axis = {a: sum(1 for w in works if str(w.get(a, "")).strip() == d["unknown_token"])
                for a in AX}
    unknown = sum(per_axis.values())
    breakdown = " · ".join("%s %d" % (a, per_axis[a]) for a in AX if per_axis[a])
    out.append("## 집계\n")
    out.append("- 수록 연구: **%d건**(이 연구 포함 %d)" % (len(works) - 1, len(works)))
    out.append("- `불명`으로 남긴 칸: **%d개** (%s) — 그중 회계 경계(A2)는 **%d개**이며, "
               "이 축은 원문 근거 없이는 단정하지 않는다"
               % (unknown, breakdown, per_axis["A2"]))
    # E39a 정정: 등급을 세어서 적는다. 첫 판은 "0개"를 리터럴로 박아 두어, 실제로 원문을
    # 일부 받은 뒤에도 표가 계속 0이라고 말했을 것이다 (D68 계열 — 세지 않고 적은 값).
    grades = [ (w.get("A9") or {}).get("content") for w in works ]
    n_full = sum(1 for g in grades if g == "fulltext")
    n_part = sum(1 for g in grades if g == "fulltext_partial")
    out.append("- `fulltext`(전체 원문) 등급 칸: **%d개** · `fulltext_partial`(부분 원문) 칸: **%d개**"
               % (n_full, n_part))
    if n_part:
        out.append("  - 부분 원문은 Scholar Gateway가 반환한 청크 본문이며, 각 행의 "
                   "`fulltext_source`에 받은 청크 번호와 전체 청크 수를 적었다. **전체 원문 대조가 아니다.**")
    out.append("  - 이 코퍼스는 이 표의 IEEE·ACM·Elsevier·arXiv 항목을 담고 있지 않다(실측): "
               "같은 도구에 이 주제를 물어도 그 논문들의 본문은 나오지 않는다. "
               "따라서 나머지 행의 등급은 그대로다.")
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
    print("  works=%d (+this) · 불명 cells=%d · fulltext=%d · fulltext_partial=%d · queries=%d"
          % (len(works) - 1, unknown, n_full, n_part, len(searches["queries"])))
    return 0


if __name__ == "__main__":
    sys.exit(main())
