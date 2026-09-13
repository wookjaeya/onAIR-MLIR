#!/usr/bin/env python3
"""E51 stage 1 -- does the contract-generation path actually run the premise checks?

The twelfth external review (docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.1) asks four
questions about E50's fix, and states in its own SS검토 한계 that it did NOT re-run or
verify the v0.52 repository. So this tool answers them from raw data rather than from
E50's prose:

  Q1 does the real contract-generation command CALL the supported-op check, the
     async-op check and the unclassified-allocation check?
  Q2 when a premise is violated, is a normal (bound-stating) contract file NOT issued?
  Q3 do normally-supported models still pass with the SAME contract values?
  Q4 is an audit-only tool's pass kept distinct from a deployment contract's pass?

Q1 is answered by EXECUTION, not by reading the source: build_contract() runs
in-process under sys.settrace and this tool records whether the line each check
lives on was executed. Each check is located by an ANCHOR substring searched in the
file at run time -- when the anchor is not found the cell says `anchor_not_found`
rather than `false`, because "could not look" and "looked and it was absent" are
different facts (D51, and D68 which wrote a parse failure as 0).

This tool adds NO gate. E50 shipped a type (B) over-rejection by turning this exact
condition into a hard fail (see EVIDENCE_v0.52_E50.md SS3), so stage 1's pre-fixed
plan (docs/plans/E51_claim_preconditions.md SS1) says: measure first, and only fix
what a measurement actually shows failing.
"""
import argparse
import re
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

# Each check: where it lives, the exact source text that IS the check, and what the
# check is for. The anchor is matched against the file at run time so a line-number
# drift shows up as `anchor_not_found`, never as a silent pass.
CHECKS = [
    {
        "id": "supported_ops__regex_parser",
        "question": "Q1 지원 연산",
        "file": "harness/static_mem_bound.py",
        "anchor": "unknown_ops = sorted({mm.group(1) + \".\" + mm.group(2) for mm in _OP_RE.finditer(body)}",
        "what": "entry body 안의 stream.(resource|tensor).* 중 화이트리스트 밖 op 을 unresolved 로 올린다 (D13)",
    },
    {
        "id": "supported_ops__structural_walker",
        "question": "Q1 지원 연산",
        "file": "harness/mlir_alloc_walk.py",
        "anchor": "if name not in KNOWN_ENTRY_OPS:",
        "what": "같은 검사의 두 번째 독립 구현 (E19 의 두 구현 설계)",
    },
    {
        "id": "async_ops__structural_walker",
        "question": "Q1 비동기 연산",
        "file": "harness/mlir_alloc_walk.py",
        "anchor": "if name.startswith(\"stream.async.\"):",
        "what": "post-layout entry 의 stream.async.* 를 pre_scheduling_ops + unresolved 로 보고한다 (D86)",
    },
    {
        "id": "unclassified_alloc__bound_decision",
        "question": "Q1 미분류 할당",
        "file": "harness/make_contract.py",
        "anchor": "all_static = p[\"entry_found\"] and not unresolved",
        "what": "unresolved 가 하나라도 있으면 all_static=False -> bound_method=NONE",
    },
    {
        "id": "unclassified_alloc__cross_check",
        "question": "Q1 미분류 할당",
        "file": "harness/mlir_alloc_walk.py",
        "anchor": "if bool(structural.get(\"unresolved\")) != bool(regex_based.get(\"unresolved\")):",
        "what": "두 추출기의 unresolved 유무가 다르면 diff -> make_contract 가 hard fail",
    },
]


def anchor_line(rel, anchor):
    path = os.path.join(ROOT, rel)
    if not os.path.isfile(path):
        return None, "file_not_found"
    with open(path, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    hits = [i + 1 for i, ln in enumerate(lines) if anchor in ln]
    if not hits:
        return None, "anchor_not_found"
    if len(hits) > 1:
        return None, "anchor_ambiguous:%s" % hits
    return hits[0], None


def fixture(target="x86_64", model="mlp16k", root="results/e14_aarch64_qemu"):
    inv_path = os.path.join(ROOT, root, target, "vmfb", "%s.invocation.json" % model)
    with open(inv_path, encoding="utf-8") as fh:
        inv = json.load(fh)
    return {
        "invocation": os.path.relpath(inv_path, ROOT),
        "mlir": inv["mlir"], "vmfb": inv["vmfb"], "layout_ir": inv["layout_ir"],
        "dump_dir": os.path.join(root, target, "dump", model),
        "elf": os.path.join(root, target, "elf", "%s.elf_analysis.json" % model),
        "triple": "x86_64-unknown-linux-gnu" if target == "x86_64" else "aarch64-unknown-linux-gnu",
        "cpu": "generic" if target == "x86_64" else "cortex-a53",
        "model": model, "target": target,
    }


def q1_trace(fx, out_dir):
    """Run the real build_contract() under sys.settrace and record which check lines ran."""
    import make_contract as mc

    sites = []
    for c in CHECKS:
        ln, err = anchor_line(c["file"], c["anchor"])
        sites.append(dict(c, line=ln, locate_error=err))

    watched = {}
    for s in sites:
        if s["line"] is not None:
            watched.setdefault(os.path.realpath(os.path.join(ROOT, s["file"])), set()).add(s["line"])

    executed = {p: set() for p in watched}

    def tracer(frame, event, arg):
        path = frame.f_code.co_filename
        try:
            path = os.path.realpath(path)
        except OSError:
            return None
        if path not in watched:
            return None
        if event == "line" and frame.f_lineno in watched[path]:
            executed[path].add(frame.f_lineno)
        return tracer

    argv = ["--mlir", fx["mlir"], "--vmfb", fx["vmfb"], "--layout-ir", fx["layout_ir"],
            "--dump-dir", fx["dump_dir"], "--triple", fx["triple"], "--cpu", fx["cpu"],
            "--model-name", fx["model"], "--elf-analysis", fx["elf"],
            "--out", os.path.join(out_dir, "q1_trace_contract.json"),
            "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
    a = mc.parse_args(argv)
    built, build_error = None, None
    old = sys.gettrace()
    sys.settrace(tracer)
    try:
        built = mc.build_contract(a, [])
    except SystemExit as e:
        build_error = "SystemExit: %s" % (e,)
    except Exception as e:            # noqa: BLE001 -- recorded, not swallowed
        build_error = "%s: %s" % (type(e).__name__, e)
    finally:
        sys.settrace(old)

    cells = []
    for s in sites:
        if s["line"] is None:
            called = None
        else:
            called = s["line"] in executed[os.path.realpath(os.path.join(ROOT, s["file"]))]
        cells.append({"id": s["id"], "question": s["question"], "file": s["file"],
                      "anchor": s["anchor"], "line": s["line"],
                      "locate_error": s["locate_error"], "called": called,
                      "what_it_checks": s["what"]})
    return {
        "method": ("실제 production 진입점 make_contract.build_contract() 를 sys.settrace 아래에서 "
                   "in-process 실행하고, 각 검사가 사는 줄이 실행됐는지 기록한다. 줄 번호는 실행 시점에 "
                   "anchor 문자열로 찾는다 -- 못 찾으면 false 가 아니라 anchor_not_found (D51)."),
        "fixture": {k: fx[k] for k in ("invocation", "target", "model")},
        "build_succeeded": built is not None,
        "build_error": build_error,
        "bound_method": (built or {}).get("resources", {}).get("bound_method"),
        "checks": cells,
        "verdict": "PASS" if cells and all(c["called"] is True for c in cells) else "FAIL",
    }


# ---------------------------------------------------------------------------
# Q2: injected premise violations, through the production subprocess path.
# Surgical text edits of an ARCHIVED layout IR -- no recompile (E20's method,
# and the one-invocation rule in CLAUDE.md 작업 규율 7 forbids the alternative).
# ---------------------------------------------------------------------------
def entry_body_span(ir, entry="infer"):
    import re
    ms = list(re.finditer(r"(util\.func|func\.func)\s+public\s+@" + re.escape(entry) + r"\b.*?\n\}", ir, re.S))
    if not ms:
        return None
    return ms[-1].span()


VIOLATIONS = [
    {
        "id": "unrecognized_resource_op",
        "premise": "지원 연산 (화이트리스트 밖 stream.resource.* 는 크기를 알 수 없다, D13)",
        "inject": "\n  %e51_unk = stream.resource.frobnicate %c8 : index -> !stream.resource<transient>{%c8}",
    },
    {
        "id": "pre_scheduling_async_op",
        "premise": "비동기 연산 (post-layout entry 의 stream.async.* = 스케줄 미완료, D86)",
        "inject": "\n  %e51_async = stream.async.alloca : !stream.resource<transient>{%c8}",
    },
    {
        "id": "unresolvable_alloca_size",
        "premise": "미분류 할당 (지원 op 이지만 크기 피연산자가 상수로 풀리지 않는다)",
        "inject": ("\n  %e51_sz = arith.addi %c8, %c8 : index"
                   "\n  %e51_res, %e51_tp = stream.resource.alloca uninitialized "
                   "on(#hal.device.affinity<@__device_0>) await(%1) => "
                   "!stream.resource<transient>{%e51_sz} => !stream.timepoint"),
    },
]


def mutate(ir, inject, entry="infer"):
    """Insert a line into the LAST entry print, before its terminator.

    Before the terminator, not before the closing brace: the first version of this
    probe inserted after `util.return`, which is not valid MLIR, so the structural
    walker could not parse that chunk at all and silently fell back to an EARLIER
    (pre-layout) print. All three injections were then refused -- but for a reason
    that had nothing to do with what was injected (the fallback chunk's own
    stream.async.clone/dispatch). A refusal is only evidence when it is attributable,
    which is why every cell below records what each extractor said on its own."""
    span = entry_body_span(ir, entry)
    if span is None:
        return None
    s, e = span
    body = ir[s:e]
    rets = list(re.finditer(r"\n\s*util\.return\b|\n\s*func\.return\b|\n\s*return\b", body))
    if not rets:
        return None
    cut = rets[-1].start()
    return ir[:s] + body[:cut] + inject + body[cut:] + ir[e:]


def _production_run(fx, layout_ir_rel, out_dir, tag):
    """Run make_contract.py (and, if a contract comes out, gen_contract_header.py)
    exactly the way the deployment path does -- subprocess, production flags."""
    con_path = os.path.join(out_dir, "%s.contract.json" % tag)
    if os.path.exists(con_path):
        os.unlink(con_path)
    cmd = [sys.executable, os.path.join(HERE, "make_contract.py"),
           "--mlir", fx["mlir"], "--vmfb", fx["vmfb"], "--layout-ir", layout_ir_rel,
           "--dump-dir", fx["dump_dir"], "--triple", fx["triple"], "--cpu", fx["cpu"],
           "--model-name", fx["model"], "--elf-analysis", fx["elf"],
           "--out", os.path.relpath(con_path, ROOT),
           "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    written = os.path.isfile(con_path)
    bound_method, unresolved = None, None
    if written:
        with open(con_path, encoding="utf-8") as fh:
            c = json.load(fh)
        bound_method = c.get("resources", {}).get("bound_method")
        unresolved = c.get("resources", {}).get("unresolved_sizes")
    hdr_rc, hdr_written = None, None
    if written:
        hdr_path = os.path.join(out_dir, "%s.contract_gen.h" % tag)
        if os.path.exists(hdr_path):
            os.unlink(hdr_path)
        hr = subprocess.run([sys.executable, os.path.join(HERE, "gen_contract_header.py"),
                             "--contract", os.path.relpath(con_path, ROOT),
                             "--out", os.path.relpath(hdr_path, ROOT)],
                            cwd=ROOT, capture_output=True, text=True)
        hdr_rc, hdr_written = hr.returncode, os.path.isfile(hdr_path)
    return {"make_contract_rc": r.returncode, "contract_file_written": written,
            "bound_method": bound_method, "unresolved_sizes": unresolved,
            "gen_contract_header_rc": hdr_rc, "header_file_written": hdr_written,
            "stderr_head": (r.stderr or "").strip()[:500]}


def _extractor_views(mutated):
    """What each extractor says on its own -- the attribution half of Q2."""
    import static_mem_bound as smb
    import mlir_alloc_walk as maw
    p = smb.parse_alloc_ir(mutated)
    view = {"regex_parser": {"unresolved": p["unresolved"],
                             "outputs": p["outputs"], "transient_slabs": p["transient_slabs"]}}
    try:
        w = maw.parse_alloc_ir_structural(mutated, "infer")
        view["structural_walker"] = {"unresolved": w["unresolved"][:6],
                                     "pre_scheduling_ops": sorted(set(w["pre_scheduling_ops"])),
                                     "outputs": w["outputs"], "transient_slabs": w["transient_slabs"],
                                     "parse_error": None}
        view["diff_against_regex"] = maw.diff_against_regex(w, p)
        # D86 removed, simulated on the SAME extraction: does the disagreement survive?
        w2 = dict(w)
        w2["unresolved"] = [u for u in w["unresolved"] if not u.startswith("pre_scheduling_alloc_op:")]
        view["diff_if_D86_branch_removed"] = maw.diff_against_regex(w2, p)
    except Exception as e:                     # noqa: BLE001 -- recorded, not swallowed
        view["structural_walker"] = {"parse_error": "%s: %s" % (type(e).__name__, str(e)[:200])}
        view["diff_against_regex"] = None
        view["diff_if_D86_branch_removed"] = None
    return view


def q2_violations(fx, out_dir):
    ir_path = os.path.join(ROOT, fx["layout_ir"])
    with open(ir_path, encoding="utf-8", errors="replace") as fh:
        ir = fh.read()

    # POSITIVE CONTROL FIRST. Without it "rc=1" is not evidence of anything -- the
    # same rc comes out of an unrelated failure, and this project has written that
    # mistake down twice (D51, and E38's witness which refuses to say `false` until
    # its positive control is caught).
    ctrl_ir = os.path.join(out_dir, "control.layout_ir.txt")
    with open(ctrl_ir, "w", encoding="utf-8") as fh:
        fh.write(ir)
    control = _production_run(fx, os.path.relpath(ctrl_ir, ROOT), out_dir, "control")
    control["extractors"] = _extractor_views(ir)
    control["ok"] = (control["make_contract_rc"] == 0 and control["contract_file_written"]
                     and control["bound_method"] != "NONE")

    cells = []
    for v in VIOLATIONS:
        mutated = mutate(ir, v["inject"])
        if mutated is None:
            cells.append(dict(v, error="entry body / terminator not found in the archived layout IR"))
            continue
        mut_path = os.path.join(out_dir, "injected.%s.layout_ir.txt" % v["id"])
        with open(mut_path, "w", encoding="utf-8") as fh:
            fh.write(mutated)
        res = _production_run(fx, os.path.relpath(mut_path, ROOT), out_dir, "injected.%s" % v["id"])
        ex = _extractor_views(mutated)
        # which extractor actually saw THIS injection (attribution, not assertion)
        seen_by = []
        if any("e51" in str(u) or "frobnicate" in str(u) for u in ex["regex_parser"]["unresolved"]):
            seen_by.append("regex_parser")
        sw = ex["structural_walker"]
        if sw.get("parse_error") is None and any(
                "e51" in str(u) or "async.alloca" in str(u) or "arith.addi" in str(u)
                for u in sw.get("unresolved", [])):
            seen_by.append("structural_walker")
        refused_as = ("no_contract_file" if not res["contract_file_written"]
                      else ("contract_states_no_bound_and_no_header"
                            if res["bound_method"] == "NONE" and not res["header_file_written"] else None))
        cells.append(dict(v, layout_ir=os.path.relpath(mut_path, ROOT), injected_line=v["inject"].strip(),
                          seen_by_extractor=seen_by, extractors=ex, refused_as=refused_as,
                          deployable_artifact_produced=refused_as is None, **res))
    attributable = all(c.get("seen_by_extractor") for c in cells if "error" not in c)
    return {
        "method": ("보관 layout IR 을 외과적으로 편집해(재컴파일 없음 — 작업 규율 7) 전제를 하나씩 깨고 "
                   "production 서브프로세스 경로를 실제로 돌린다. 주입은 entry 의 terminator 앞에 넣는다 — "
                   "첫 판은 util.return 뒤에 넣어 MLIR 자체가 깨졌고, walker 가 조용히 이전(pre-layout) "
                   "print 로 후퇴해 세 셀 모두 '주입과 무관한 이유로' 거부됐다. 거부는 귀속될 때만 근거다."),
        "positive_control": control,
        "cells": cells,
        "refusals_attributable_to_injection": attributable,
        "verdict": ("FAIL" if not control["ok"]
                    else ("PASS" if cells and attributable
                          and all(c.get("deployable_artifact_produced") is False for c in cells)
                          else "FAIL")),
    }


def q3_archived_regeneration(out_dir):
    """Reuse contract_negative_tests.regression_check -- the 14/14 diff-0 check already
    exists there (E44: 요구된 필드가 이미 있는지 먼저 세어 보라). Do not reimplement it."""
    import tempfile
    import contract_negative_tests as cnt
    # RELATIVE root, exactly as the suite calls it. Passing an absolute path here
    # made all 14 "differ" on provenance.dump_dir alone -- a difference this call
    # created, not one the contracts have. Measured before it reached a verdict.
    with tempfile.TemporaryDirectory(prefix="e51_q3_") as tmp:
        rs = cnt.regression_check("results/e14_aarch64_qemu", tmp)
    unchanged = [r for r in rs if "contract unchanged" in r.name]
    failed = [r.name for r in rs if not r.ok and not getattr(r, "skip", False)]
    skipped = [r.name for r in rs if getattr(r, "skip", False)]
    return {
        "method": ("harness/contract_negative_tests.py::regression_check 를 그대로 호출한다 — "
                   "14/14 diff 0 은 이미 거기 있고, 두 번째 구현을 만들면 같은 사실이 서로를 "
                   "대조하지 않는 두 자리에 산다 (E44)."),
        "contracts_unchanged": sum(1 for r in unchanged if r.ok),
        "contracts_checked": len(unchanged),
        "failed": failed,
        "skipped": skipped,
        "verdict": ("SKIP" if skipped and not unchanged
                    else ("PASS" if unchanged and not failed else "FAIL")),
    }


def q4_scope_separation():
    """The audit tool's pass and the deployment contract's pass have different domains.
    Measured, not asserted: how many models the ledger was run on, whether the contract
    generator calls it at all, and how many contracts the generator produced."""
    ledger_dir = os.path.join(ROOT, "results/e49_research_audit/ledger")
    ledger_models = sorted(os.path.splitext(f)[0] for f in os.listdir(ledger_dir)) if os.path.isdir(ledger_dir) else []
    src = open(os.path.join(HERE, "make_contract.py"), encoding="utf-8").read()
    calls_ledger = ("e49_alloc_ledger" in src)
    contracts = subprocess.run(["bash", "-lc",
                                "find results -name 'contract.*.json' -o -name '*.contract.json' | wc -l"],
                               cwd=ROOT, capture_output=True, text=True)
    n_contracts = int((contracts.stdout or "0").strip() or 0)
    return {
        "question": "Q4 감사 전용 도구의 통과와 배포 계약 생성의 통과가 혼동되지 않는가",
        "audit_tool": {
            "name": "harness/e49_alloc_ledger.py",
            "role": "감사 — 같은 IR 을 독립적으로 훑어 계약의 I·O·T·C 를 대조한다",
            "models_covered": ledger_models,
            "models_covered_count": len(ledger_models),
            "invoked_by_contract_generation": calls_ledger,
            "invoked_by_evidence": ("harness/make_contract.py 소스에 'e49_alloc_ledger' 문자열 %d 건"
                                    % src.count("e49_alloc_ledger")),
            "pass_means": "이 네 모델에서 ledger 합계가 계약값과 같다",
        },
        "deployment_contract_path": {
            "name": "harness/make_contract.py",
            "role": "배포 — 계약 파일을 발행하거나 거부한다",
            "applies_to": "모든 make_contract.py 호출 (모델 목록을 갖지 않는다)",
            "archived_contracts_in_repo": n_contracts,
            "checks_wired_in": [c["id"] for c in CHECKS],
            "pass_means": "이 호출의 layout IR 에서 전제 검사가 통과했다 — 다른 모델에 대해서는 아무 말도 하지 않는다",
        },
        "why_they_are_not_the_same_pass": (
            "ledger 는 %d 개 모델만 보고 계약 생성 경로에서 호출되지 않는다(%s). 계약 생성 경로는 "
            "모델 목록이 없고 호출마다 그 입력에 대해서만 판정한다. 따라서 ledger 의 통과는 배포 "
            "계약의 통과가 아니고, 그 반대도 아니다. 저장소의 계약 %d 개 중 ledger 가 본 것은 %d 개다."
            % (len(ledger_models), "미호출" if not calls_ledger else "호출됨", n_contracts, len(ledger_models))),
        "verdict": "PASS" if (ledger_models and not calls_ledger) else "FAIL",
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e51_claim_preconditions/stage1_preconditions.json")
    # The mutated layout IRs are DETERMINISTIC regenerations of an archived IR (one
    # inserted line, before the entry terminator), so they are not stored in results/
    # -- the same rule E26d applied to the corrupted vmfb: a test regenerates them from
    # the in-tree original. Storing them also fed the D86 guard, which scans
    # results/**/ *layout_ir*.txt for async ops in an entry, injected files it was never
    # meant to see. Only the JSON record is archived.
    ap.add_argument("--out-dir", default=None,
                    help="where the mutated layout IRs go (default: a temporary directory)")
    ap.add_argument("--skip-q3", action="store_true")
    a = ap.parse_args()

    import tempfile
    tmpdir = None
    if a.out_dir:
        out_dir = os.path.join(ROOT, a.out_dir)
        os.makedirs(out_dir, exist_ok=True)
    else:
        tmpdir = tempfile.TemporaryDirectory(prefix="e51_stage1_")
        out_dir = tmpdir.name
    fx = fixture()

    q1 = q1_trace(fx, out_dir)
    q2 = q2_violations(fx, out_dir)
    q3 = ({"verdict": "SKIP", "reason": "--skip-q3"} if a.skip_q3
          else q3_archived_regeneration(out_dir))
    q4 = q4_scope_separation()

    verdicts = {"Q1": q1["verdict"], "Q2": q2["verdict"], "Q3": q3["verdict"], "Q4": q4["verdict"]}
    hard = [k for k, v in verdicts.items() if v == "FAIL"]
    out = {
        "tool": "harness/e51_precondition_trace.py",
        "experiment": "E51",
        "stage": 1,
        "plan": "docs/plans/E51_claim_preconditions.md SS1",
        "review": "docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.1",
        "purpose": ("검토서 SS5.1 의 네 질문에 원자료로 답한다. 검토서는 v0.52 저장소를 다시 "
                    "실행·검증하지 않았다고 스스로 적었으므로, E50 의 산문이 아니라 실행이 근거다."),
        "adds_no_gate": ("이 단계는 새 게이트를 만들지 않는다 — E50 이 바로 이 조건을 hard fail 로 "
                         "만들었다가 유형 (B) 과잉 거부를 냈다 (EVIDENCE_v0.52_E50.md SS3)."),
        "Q1_checks_called": q1,
        "Q2_violation_produces_no_deployable_artifact": q2,
        "Q3_archived_models_unchanged": q3,
        "Q4_audit_vs_deployment_scope": q4,
        "verdicts": verdicts,
        "mutated_layout_irs": ("결정적 재생성이라 저장하지 않는다 — 보관 IR 한 개에 한 줄을 "
                               "entry terminator 앞에 넣는 규칙이 전부다(E26d 의 손상 vmfb 와 같은 처리). "
                               "--out-dir 로 보존할 수 있다."),
        "verdict": "FAIL" if hard else "PASS",
    }
    with open(os.path.join(ROOT, a.out), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    print(json.dumps(verdicts, ensure_ascii=False), "->", out["verdict"])
    for c in q1["checks"]:
        print("  Q1 %-38s called=%s (%s:%s)" % (c["id"], c["called"], c["file"], c["line"]))
    for c in q2["cells"]:
        print("  Q2 %-28s rc=%s contract=%s bound=%s header=%s refused_as=%s"
              % (c.get("id"), c.get("make_contract_rc"), c.get("contract_file_written"),
                 c.get("bound_method"), c.get("header_file_written"), c.get("refused_as")))
    print("  wrote", a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
