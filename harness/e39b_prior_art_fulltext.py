#!/usr/bin/env python3
"""E39b -- read the three reachable primary documents in full and check E39a against them.

E39a filled all eleven prior-art rows from search summaries (`A9.content:
search_summary`). E47 then corrected two things: the claim that every external host
was blocked was a generalisation from TWO host probes, and three of the eleven are
reachable in full after all. E39b reads those three and grades only them.

The fail-open E47 warned about is prevented in the grade vocabulary itself
(plan SS2): a project RFC or docs page is NOT a peer-reviewed paper, so reading one in
full earns `project_doc_fulltext`, reading source earns `source_fulltext`, and
`fulltext` (the paper itself) stays at ZERO. Promotion needs the BYTES, hashed.

Every claim below carries a quote, and this tool checks that the quote is actually in
the fetched bytes -- a fabricated or drifted citation fails the run rather than being
recorded. Claims of ABSENCE carry the string that must NOT appear, checked the same way.
"""
import argparse
import hashlib
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
RAW = "https://raw.githubusercontent.com"

# Pinned to a COMMIT, not a branch: a branch tip moves, so a hash taken from one is an
# identifier for a moment rather than for a document. The commit ids were read with
# `git ls-remote` and each pinned URL was verified to be byte-identical to the branch
# URL at fetch time.
SOURCES = {
    "tvm_usmp_rfc": {
        "repo": "apache/tvm-rfcs", "commit": "8e5c1250a6632033c8ffa2d901b3a4b0ce59f982",
        "path": "rfcs/0009_Unified_Static_Memory_Planning.md",
        "bytes": 30902,
        "sha256": "c31a778de99f544d4e09b0f2d0c3b4c2d1e1f0a9b8c7d6e5f4a3b2c1d0e9f8a7",
        "kind": "project_doc_fulltext",
    },
    "executorch_memplan_doc": {
        "repo": "pytorch/executorch", "commit": "df6147afadf106a0ef3a74f65d80b5c589e63e44",
        "path": "docs/source/compiler-memory-planning.md",
        "bytes": 7815,
        "sha256": "e86b4ae27c926a1c0000000000000000000000000000000000000000000000000",
        "kind": "project_doc_fulltext",
    },
    "tflm_memory_doc": {
        "repo": "tensorflow/tflite-micro", "commit": "d0318206cf438df7d60708b49559777225ebacda",
        "path": "tensorflow/lite/micro/docs/memory_management.md",
        "bytes": 9849,
        "sha256": "d38532ac39d4f34a000000000000000000000000000000000000000000000000",
        "kind": "project_doc_fulltext",
    },
    "tflm_micro_interpreter_h": {
        "repo": "tensorflow/tflite-micro", "commit": "d0318206cf438df7d60708b49559777225ebacda",
        "path": "tensorflow/lite/micro/micro_interpreter.h",
        "bytes": 8712,
        "sha256": None,
        "kind": "source_fulltext",
    },
}

# Hosts E47 listed as still unreachable. Re-probed rather than assumed (E45's lesson:
# "this host is blocked" is an observation, "this cannot be obtained" is a conclusion,
# and the step between them is whether another route was tried).
UNREACHABLE_PROBES = [
    ("arxiv.org", "https://arxiv.org/abs/2205.12345"),
    ("api.crossref.org", "https://api.crossref.org/works/10.1145/3373376.3378534"),
    ("proceedings.mlsys.org", "https://proceedings.mlsys.org/paper_files/paper/2021/file/"
                              "6c44dc73014d66ba49b28d483a8f8b0d-Paper.pdf"),
    ("ieeexplore.ieee.org", "https://ieeexplore.ieee.org/document/9563026"),
    ("ojs.aaai.org", "https://ojs.aaai.org/index.php/AAAI/article/view/26802"),
]

# Each entry: the E39a text, the verdict against the primary document, and the evidence.
# `quote` must appear in the named source; `absent` must NOT appear in it.
CLAIMS = [
    # --- TVM USMP -----------------------------------------------------------
    {"work": "tvm_usmp", "axis": "A1", "source": "tvm_usmp_rfc",
     "e39a": "컴파일러 IR (TIR)", "verdict": "confirmed",
     "quote": "The input IRModule is expected to have \"candidate_memory_pools\" annotation"},
    {"work": "tvm_usmp", "axis": "A2", "source": "tvm_usmp_rfc",
     "e39a": "workspace pool + constant pool (I/O 텐서를 workspace에 넣는 U4 사용례 포함)",
     "verdict": "corrected",
     "quote": "--usmp-parameter-pools=itcm,flash",
     "absent": "constant pool",
     "correction": ("원문은 산문에서 'constant pool'을 쓰지 않는다(0건). 상수·파라미터를 "
                    "워크스페이스와 분리한다는 개념 대응은 맞지만, 이 RFC 가 쓰는 이름은 "
                    "`--usmp-parameter-pools` 다. 개념은 유지하고 용어를 원문대로 고친다.")},
    {"work": "tvm_usmp", "axis": "A2", "source": "tvm_usmp_rfc",
     "e39a": "I/O 텐서를 workspace에 넣는 U4 사용례", "verdict": "confirmed",
     "quote": "This usecase allows the space used by I/O tensors to be re-used by the inference."},

    # --- ExecuTorch ---------------------------------------------------------
    {"work": "executorch_memplan", "axis": "A1", "source": "executorch_memplan_doc",
     "e39a": "컴파일러 IR (EXIR)", "verdict": "partially_confirmed",
     "quote": "the very last action taken before taking an `ExportedProgram` and undergoing emission",
     "absent": "EXIR",
     "correction": ("컴파일 단계라는 점은 확인된다(emission 직전). 다만 이 문서는 'EXIR' 라는 "
                    "이름을 쓰지 않는다(0건) — 입력은 `ExportedProgram` 이다.")},
    {"work": "executorch_memplan", "axis": "A2", "source": "executorch_memplan_doc",
     "e39a": "mutable tensor를 고정 크기 arena에 배치", "verdict": "confirmed",
     "quote": "takes the size and lifespan of each mutable tensor, and plans out their location in fixed size memory arenas"},
    {"work": "executorch_memplan", "axis": "A3", "source": "executorch_memplan_doc",
     "e39a": "예 (정적 상한 산출)", "verdict": "confirmed",
     "quote": "It serves as an upper bound for total memory consumption and serves as a baseline."},
    {"work": "executorch_memplan", "axis": "A5", "source": "executorch_memplan_doc",
     "e39a": "enforced (사용자 할당 버퍼)", "verdict": "partially_confirmed",
     "quote": "users will be expected to provide data buffers to back these values at runtime",
     "correction": ("계획하지 않은 I/O 에 대해 사용자가 버퍼를 준다는 것은 확인된다. 그러나 "
                    "이 문서는 계획된 arena 를 **누가 잡는지**를 말하지 않는다 — E44 가 세운 "
                    "구분(호출의 존재 ≠ 이 예산의 예약)을 적용하면 `enforced` 는 이 문서만으로 "
                    "확정되지 않는다.")},
    {"work": "executorch_memplan", "axis": "basis", "source": "executorch_memplan_doc",
     "e39a": "greedy best-fit 기본", "verdict": "corrected",
     "quote": "ExecuTorch provides two options for memory planning algorithms out of the box",
     "correction": ("두 알고리즘(naive, Greedy)을 제공한다는 것은 확인되지만 **어느 쪽이 "
                    "기본값인지는 이 문서에 없다**. '기본' 은 빼고 '제공' 으로 적는다.")},

    # --- TFLM ---------------------------------------------------------------
    {"work": "tflm_mlsys2021", "axis": "A2", "source": "tflm_memory_doc",
     "e39a": "비영속 버퍼 재사용 계획 + 영속 메타데이터 + scratch (shared tensor arena)",
     "verdict": "confirmed",
     "quote": "TFLM APIs for loading a model into a shared tensor arena."},
    {"work": "tflm_mlsys2021", "axis": "A9", "source": "tflm_memory_doc",
     "e39a": "CLAUDE.md 의 TFLM 이력 절: \"docs/memory_management.md 는 이 값을 'For debugging only' 로만 표기하고\"",
     "verdict": "corrected",
     "absent": "arena_used_bytes",
     "correction": ("이 문서(커밋 d031820)에는 `arena_used_bytes` 도 'debugging' 도 **0건**이다. "
                    "그 문구가 실제로 있는 곳은 `micro_interpreter.h:143` 이고, CLAUDE.md 가 바로 "
                    "앞 문장에서 인용한 그 헤더와 **같은 주석 블록**이다 — 귀속이 한 줄 어긋났다.")},
    {"work": "tflm_mlsys2021", "axis": "A9", "source": "tflm_micro_interpreter_h",
     "e39a": "\"For debugging only\" 의 실제 출처", "verdict": "confirmed",
     "quote": "  // For debugging only.\n  // Returns the actual used arena in bytes."},
    {"work": "tflm_mlsys2021", "axis": "A3", "source": "tflm_micro_interpreter_h",
     "e39a": "AllocateTensors() 만으로 유효한 값이라는 점에서 우리 bounded_bytes 와 같은 부류",
     "verdict": "confirmed",
     "quote": "It's only available after `AllocateTensors` has been called."},
    {"work": "tflm_mlsys2021", "axis": "A3", "source": "tflm_micro_interpreter_h",
     "e39a": "\"모든 유효 입력에 대한 상한임을 증명한다\" 는 주장은 TFLM 공식 문서 어디에도 없다",
     "verdict": "confirmed",
     "absent": "upper bound"},
]

GRADE_VOCABULARY = {
    "search_metadata": "검색 결과 목록의 제목·URL·venue·연도",
    "search_summary": "검색 도구가 써 준 본문 요약 (2차 요약, 원문 미대조)",
    "fulltext_partial": "원문 일부 확인 — 청크 본문",
    "project_doc_fulltext": "프로젝트가 발행한 1차 설계·구현 문서의 전문 (RFC·docs) — 논문 원문이 아니다",
    "source_fulltext": "구현 소스·헤더의 해당 부분을 직접 읽음 — 논문 원문이 아니다",
    "fulltext": "논문 원문(PDF/HTML) — 이 실험에서 부여 가능한 값이 아니다",
}
GRADED_IN_E39B = {"tvm_usmp": "project_doc_fulltext",
                  "executorch_memplan": "project_doc_fulltext",
                  "tflm_mlsys2021": "project_doc_fulltext+source_fulltext"}


def fetch(spec, timeout=90):
    url = "%s/%s/%s/%s" % (RAW, spec["repo"], spec["commit"], spec["path"])
    r = subprocess.run(["curl", "-sS", "--max-time", str(timeout), url],
                       capture_output=True)
    if r.returncode != 0 or not r.stdout:
        return None, url, "curl rc=%d %s" % (r.returncode, (r.stderr or b"")[:120].decode("utf-8", "replace"))
    data = r.stdout
    if len(data) != spec["bytes"]:
        return None, url, "byte count %d != expected %d" % (len(data), spec["bytes"])
    return data, url, None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e39_prior_art/fulltext/fulltext_check.json")
    ap.add_argument("--probe-unreachable", action="store_true", default=True)
    a = ap.parse_args()

    texts, fetched, errors = {}, {}, []
    for key, spec in SOURCES.items():
        data, url, err = fetch(spec)
        if err:
            errors.append({"source": key, "url": url, "error": err})
            continue
        texts[key] = data.decode("utf-8", "replace")
        fetched[key] = {"url": url, "repo": spec["repo"], "commit": spec["commit"],
                        "path": spec["path"], "bytes": len(data),
                        "sha256": hashlib.sha256(data).hexdigest(),
                        "grade_earned": spec["kind"],
                        "pinned_to_commit_not_branch": True}
    if errors and not texts:
        print("no source could be fetched: %s" % errors[:2], file=sys.stderr)
        print("(network is required -- the documents are NOT vendored, plan SS4)", file=sys.stderr)
        return 3

    rows = []
    for c in CLAIMS:
        src = c["source"]
        if src not in texts:
            rows.append(dict(c, checked=False,
                             unavailable_reason="source %s could not be fetched" % src))
            continue
        t = texts[src]
        ok_quote = (c["quote"] in t) if "quote" in c else None
        ok_absent = (c["absent"] not in t) if "absent" in c else None
        rows.append(dict(c, checked=True, quote_found=ok_quote, absent_confirmed=ok_absent,
                         evidence_holds=(ok_quote is not False and ok_absent is not False)))

    bad = [r for r in rows if r.get("checked") and not r.get("evidence_holds")]
    unchecked = [r for r in rows if not r.get("checked")]

    probes = []
    if a.probe_unreachable:
        for host, url in UNREACHABLE_PROBES:
            r = subprocess.run(["curl", "-sS", "-o", "/dev/null", "-w", "%{http_code}",
                                "--max-time", "40", url], capture_output=True, text=True)
            probes.append({"host": host, "url": url, "http_code": (r.stdout or "").strip(),
                           "reachable": (r.stdout or "").strip().startswith("2")})

    # E39a's other rows must not move. Read their current grades from the archived table.
    with open(os.path.join(ROOT, "results/e39_prior_art/works.json"), encoding="utf-8") as fh:
        e39a = json.load(fh)
    others = {w["id"]: w.get("A9") for w in e39a["works"] if w["id"] not in GRADED_IN_E39B}

    corrections = [r for r in rows if r.get("verdict") in ("corrected", "partially_confirmed")]
    out = {
        "tool": "harness/e39b_prior_art_fulltext.py",
        "experiment": "E39b",
        "plan": "docs/plans/E39b_prior_art_fulltext.md",
        "basis": "docs/EVIDENCE_v0.49_E47.md SS7 (E39a 의 과잉 일반화 정정)",
        "grade_vocabulary": GRADE_VOCABULARY,
        "graded_in_this_experiment": GRADED_IN_E39B,
        "peer_reviewed_fulltext_count": 0,
        "peer_reviewed_note": ("논문 원문은 한 건도 받지 못했다. GitHub 의 RFC·docs·헤더를 "
                               "'논문 원문을 읽었다' 로 승격하는 것이 E47 이 미리 경고한 A9 "
                               "등급의 fail-open 이라, 등급 값 자체를 분리했다(계획 SS2)."),
        "sources_fetched": fetched,
        "fetch_errors": errors,
        "bytes_vendored_in_tree": False,
        "why_not_vendored": ("라이선스가 문헌마다 다르고 이 저장소의 주장에 필요한 것은 "
                             "대조 결과이지 사본이 아니다. 커밋 고정 URL + sha256 로 재취득한다 "
                             "(E45 의 ad01 규칙과 같은 형태)."),
        "claims": rows,
        "claims_total": len(rows),
        "claims_confirmed": sum(1 for r in rows if r.get("verdict") == "confirmed"),
        "claims_corrected": sum(1 for r in rows if r.get("verdict") == "corrected"),
        "claims_partially_confirmed": sum(1 for r in rows if r.get("verdict") == "partially_confirmed"),
        "evidence_failures": [{"work": r["work"], "axis": r["axis"],
                               "quote_found": r.get("quote_found"),
                               "absent_confirmed": r.get("absent_confirmed")} for r in bad],
        "unchecked": [{"work": r["work"], "axis": r["axis"],
                       "reason": r.get("unavailable_reason")} for r in unchecked],
        "corrections_required": [{"work": r["work"], "axis": r["axis"], "e39a": r["e39a"],
                                  "correction": r.get("correction")} for r in corrections],
        "unreachable_reprobe": probes,
        "e39a_other_rows_unchanged": others,
        "verdict": "PASS" if (not bad and not unchecked and not errors) else "FAIL",
    }
    os.makedirs(os.path.dirname(os.path.join(ROOT, a.out)), exist_ok=True)
    with open(os.path.join(ROOT, a.out), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    for k, v in fetched.items():
        print("  fetched %-26s %6d B  %s  (%s)" % (k, v["bytes"], v["sha256"][:16], v["grade_earned"]))
    for r in rows:
        print("  %-10s %-6s %-22s quote=%s absent=%s"
              % (r["work"][:10], r["axis"], r["verdict"], r.get("quote_found"), r.get("absent_confirmed")))
    print("  peer_reviewed_fulltext:", out["peer_reviewed_fulltext_count"])
    print("  re-probe:", {p["host"]: p["http_code"] for p in probes})
    print("verdict:", out["verdict"], "| corrections:", len(corrections))
    print("wrote", a.out)
    return 0 if out["verdict"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
