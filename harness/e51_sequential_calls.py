#!/usr/bin/env python3
"""E51 stage 2 -- sequential-call evidence, read at the call site.

`analysis_domain.required_premises.max_in_flight_calls = 1` (E40) is recorded by
E49 axis B as ARGUED_FROM_SOURCE, and E49 was explicit about why: what it counted
was task/thread CREATION calls (0/0/0 across the three deployments), and counting
creation calls is an argument, not an observation.

The twelfth external review (docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.2) asks for the
other half: read the actual call sites. That is what this tool records. It changes
NOTHING about the state -- reaching the call site does not turn an argument into an
observation, and the pre-fixed plan (docs/plans/E51_claim_preconditions.md SS2) says so
before the measurement. Promoting to OBSERVED needs call-id records at invoke
entry/exit, which this experiment deliberately does not add (SS5.2-5 permits skipping
new runtime instrumentation when the source evidence suffices).

The two halves are kept in separate fields on purpose:
  counted_thread_or_task_creation -- "the executor does not create threads itself"
  call_site_reading               -- "the external calls are sequential"
They are different claims (SS5.2-4) and the second is the one that was missing.
"""
import argparse
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

# Calls that would create a second flow of control able to re-enter the executor.
CONCURRENCY_CALLS = ("pthread_create", "CFE_ES_CreateChildTask", "OS_TaskCreate",
                     "signal(", "sigaction", "threading.", "multiprocessing",
                     "concurrent.futures", "asyncio")

C_FUNC_RE = re.compile(r"^(?:static\s+)?(?:[A-Za-z_][\w *]*?)\s+([A-Za-z_]\w*)\s*\([^;]*\)\s*\{")
PY_FUNC_RE = re.compile(r"^(\s*)def\s+([A-Za-z_]\w*)\s*\(")


def read(path):
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read().splitlines()


def c_function_at(lines, lineno):
    """Name of the C function whose opening brace is the last one before lineno."""
    best = None
    for i, ln in enumerate(lines[:lineno], start=1):
        m = C_FUNC_RE.match(ln)
        if m:
            best = (m.group(1), i)
    return best


def py_function_at(lines, lineno):
    best = None
    for i, ln in enumerate(lines[:lineno], start=1):
        m = PY_FUNC_RE.match(ln)
        if m:
            best = (m.group(2), i)
    return best


def _scrub_c(line):
    """Drop string/char literals and // comments so brace counting is not fooled by
    the JSON format strings this app prints (they contain { and } )."""
    out, i, n = [], 0, len(line)
    while i < n:
        ch = line[i]
        if ch == "\\" and i + 1 < n:
            i += 2
            continue
        if ch in "\"'":
            q = ch
            i += 1
            while i < n:
                if line[i] == "\\":
                    i += 2
                    continue
                if line[i] == q:
                    i += 1
                    break
                i += 1
            continue
        if ch == "/" and i + 1 < n and line[i + 1] == "/":
            break
        out.append(ch)
        i += 1
    return "".join(out)


def enclosing_loop(lines, lineno, func_start, lang):
    """The innermost loop that ACTUALLY CONTAINS the call site.

    The first version of this took the last loop header before the call, which named
    a PRECEDING SIBLING loop for the cFS SB call site (the one-line feature-fill for
    at :652 is not an enclosing scope of the invoke at :662). That would have put a
    false structural statement into the record, so containment is computed instead of
    guessed: braces for C (string literals scrubbed first -- this app prints JSON),
    indentation for Python. A braceless C loop body is a single statement, so it
    contains only its own line or the one right after it."""
    if lang == "c":
        pat = re.compile(r"^\s*(for|while)\s*\(")
        depth, hit = 0, None
        opens = []          # (loop_line, depth_before)
        for i in range(func_start, lineno + 1):
            raw = lines[i - 1]
            body = _scrub_c(raw)
            is_loop = bool(pat.match(raw))
            if is_loop and "{" not in body:
                # single-statement loop: contains this line and, if the statement
                # wraps, the next one
                if i in (lineno, lineno - 1) and i != lineno:
                    hit = {"line": i, "text": raw.strip(), "form": "braceless"}
                depth += body.count("{") - body.count("}")
                continue
            if is_loop:
                opens.append((i, depth, raw.strip()))
            depth += body.count("{") - body.count("}")
            # close any loop whose body brace has been popped
            opens = [o for o in opens if depth > o[1]]
        if opens:
            ln, _, txt = opens[-1]
            hit = {"line": ln, "text": txt, "form": "braced"}
        return hit
    pat = re.compile(r"^(\s*)(for|while)\s+")
    call_indent = len(lines[lineno - 1]) - len(lines[lineno - 1].lstrip())
    hit = None
    for i in range(func_start, lineno):
        m = pat.match(lines[i - 1])
        if m and len(m.group(1)) < call_indent:
            hit = {"line": i, "text": lines[i - 1].strip(), "form": "indent"}
    return hit


def find_sites(path, patterns, lang):
    lines = read(path)
    out = []
    for i, ln in enumerate(lines, start=1):
        if any(p in ln for p in patterns):
            fn = c_function_at(lines, i) if lang == "c" else py_function_at(lines, i)
            out.append({
                "line": i, "text": ln.strip(),
                "enclosing_function": fn[0] if fn else None,
                "enclosing_function_line": fn[1] if fn else None,
                "enclosing_loop": enclosing_loop(lines, i, fn[1], lang) if fn else None,
            })
    return out


def count_calls(path):
    src = "\n".join(read(path))
    return {c: src.count(c) for c in CONCURRENCY_CALLS if src.count(c)}


def onair_core():
    """OnAIR's own dispatcher. NASA source, cloned by scripts/20_setup_onair.sh into
    ~/onair-mlir-bench/ext/OnAIR -- OUTSIDE this repository, so when it is absent the
    cell says why rather than reporting zero (D51/D68)."""
    base = os.path.expanduser("~/onair-mlir-bench/ext/OnAIR")
    if not os.path.isdir(base):
        return {"available": False,
                "unavailable_reason": ("OnAIR 체크아웃이 이 컨테이너에 없다 (%s). "
                                       "scripts/20_setup_onair.sh 가 만든다 — 저장소 내용이 아니다." % base),
                "commit": None, "sites": None, "concurrency_calls": None}
    r = subprocess.run(["git", "-C", base, "rev-parse", "--short", "HEAD"],
                       capture_output=True, text=True)
    commit = (r.stdout or "").strip() or None
    sites, conc = [], {}
    for rel, pats in (("onair/src/run_scripts/sim.py", ["self.agent.reason("]),
                      ("onair/src/reasoning/agent.py", ["self.learning_systems.render_reasoning()"]),
                      ("onair/src/systems/vehicle_rep.py", ["construct.render_reasoning()"])):
        p = os.path.join(base, rel)
        if not os.path.isfile(p):
            sites.append({"file": rel, "error": "file not found in this checkout"})
            continue
        for s in find_sites(p, pats, "py"):
            sites.append(dict(s, file=rel))
        c = count_calls(p)
        if c:
            conc[rel] = c
    return {"available": True, "checkout": base, "commit": commit,
            "sites": sites, "concurrency_calls": conc,
            "note": ("외부 체크아웃이라 저장소 내용만으로 재현되지 않는다. 커밋 해시를 함께 적어 "
                     "무엇을 읽었는지는 식별 가능하게 한다.")}


DEPLOYMENTS = [
    {
        "id": "cfs_ai_learner",
        "file": "native/cfs_app/fsw/src/ai_learner.c",
        "lang": "c",
        "invoke_patterns": ["iree_runtime_call_invoke("],
        "dispatcher_patterns": ["CFE_ES_RunLoop(", "CFE_SB_ReceiveBuffer("],
        "shared_across_calls": ["g.session", "g.x (single input buffer view)",
                                "static feat[]/out[]/outs[]/yv[] (D52·D75)"],
    },
    {
        "id": "native_learner",
        "file": "native/native_learner.c",
        "lang": "c",
        "invoke_patterns": ["iree_runtime_call_invoke("],
        "dispatcher_patterns": ["int main("],
        "shared_across_calls": ["session", "x (single input buffer view)"],
    },
    {
        "id": "onair_compiled_learner",
        "file": "plugins/compiled_learner/compiled_learner_plugin.py",
        "lang": "py",
        "invoke_patterns": ["out = self._fn("],
        "dispatcher_patterns": ["def render_reasoning", "def update"],
        "shared_across_calls": ["self._fn (bound module function)", "self._x", "self._weights"],
    },
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e51_claim_preconditions/stage2_sequential_calls.json")
    a = ap.parse_args()

    cells = []
    for d in DEPLOYMENTS:
        path = os.path.join(ROOT, d["file"])
        if not os.path.isfile(path):
            cells.append(dict(d, error="source file not found"))
            continue
        invokes = find_sites(path, d["invoke_patterns"], d["lang"])
        disp = find_sites(path, d["dispatcher_patterns"], d["lang"])
        conc = count_calls(path)
        phases = sorted({s["enclosing_function"] for s in invokes if s["enclosing_function"]})
        cells.append({
            "id": d["id"], "file": d["file"],
            "invoke_sites": invokes,
            "invoke_site_count": len(invokes),
            "enclosing_functions": phases,
            "dispatcher_sites": disp,
            "shared_across_calls": d["shared_across_calls"],
            "counted_thread_or_task_creation": conc,
            "counted_thread_or_task_creation_total": sum(conc.values()),
        })

    core = onair_core()

    readings = {
        "cfs_ai_learner": (
            "호출부 두 곳이 **서로 배타적인 단계**에 있다. AI_LEARNER_Init() 안의 e25 재생 루프와, "
            "AI_LEARNER_Infer() 안의 SB 구동 호출이다. Infer 는 AI_LEARNER_AppMain() 의 "
            "`while (CFE_ES_RunLoop(&run))` 에서만 불리고, 그 루프는 `CFE_SB_ReceiveBuffer` 로 한 번에 "
            "버퍼 하나를 받아 `AI_LEARNER_Infer(buf)` 를 **동기 호출**한 뒤 다음 반복으로 간다. "
            "Init 은 그 루프가 시작되기 전에 끝나므로 두 호출부가 겹칠 수 없다. cFE 앱은 자기 태스크 "
            "하나로 돌고, 이 앱은 자식 태스크도 시그널 핸들러도 등록하지 않는다(아래 계수 0). "
            "따라서 g.session 과 g.x 를 공유하는 호출이 중첩되지 않는다."),
        "native_learner": (
            "호출부 두 곳 모두 main() 아래의 단일 제어 흐름이다 — e25 재생 for 루프와 벤치마크 for "
            "루프이고, 각 반복이 invoke 를 동기 호출하고 결과를 읽은 뒤 다음 반복으로 간다. "
            "프로세스에 다른 스레드가 없다(계수 0)."),
        "onair_compiled_learner": (
            "플러그인의 invoke 는 render_reasoning() 안의 한 줄이고, 그 함수는 OnAIR 코어가 부른다. "
            "플러그인 자신은 스레드·태스크를 만들지 않는다(계수 0). 또한 `_input_fresh` 가 False 면 "
            "invoke 를 하지 않고 직전 답을 `stale` 로 돌려주므로(E33), 같은 입력에 대해 호출이 "
            "거듭 발생하지 않는다. OnAIR 코어 쪽은 아래 onair_core 를 참조 — **좁은 주장 범위**"
            "(검토 SS5.2-2)에 따라 인터페이스 호출 구조까지만 읽었다."),
    }

    distinction = {
        "claim_A_executor_creates_no_threads": {
            "how": "소스에서 태스크·스레드 생성 호출을 센다",
            "result": {c["id"]: c.get("counted_thread_or_task_creation_total") for c in cells if "id" in c},
            "what_it_does_not_say": ("실행기가 스스로 스레드를 만들지 않는다는 것은 **외부에서** 그 "
                                     "실행기를 동시에 부르지 않는다는 뜻이 아니다. E49 가 센 것이 이쪽이다."),
        },
        "claim_B_external_calls_are_sequential": {
            "how": "호출부와 그것을 구동하는 루프를 실제로 읽는다",
            "result": readings,
            "what_it_does_not_say": ("이것은 소스를 읽은 결과이지 실행 중 관측이 아니다. 중첩이 "
                                     "일어났는지 아닌지를 말하는 런타임 기록은 여전히 없다."),
        },
    }

    out = {
        "tool": "harness/e51_sequential_calls.py",
        "experiment": "E51", "stage": 2,
        "plan": "docs/plans/E51_claim_preconditions.md SS2",
        "review": "docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.2",
        "premise": "analysis_domain.required_premises.max_in_flight_calls = 1",
        "deployments": cells,
        "onair_core": core,
        "distinction_required_by_review_5_2_4": distinction,
        "reentrancy_paths_examined": {
            "child_tasks_or_threads": "0 (세 배포 전부, 위 계수)",
            "signal_handlers": "0 (세 배포 전부, 위 계수 — signal(/sigaction 포함)",
            "cfs_two_invoke_sites_overlap": ("불가능 — 하나는 Init 안, 하나는 Init 이후의 RunLoop 안이다"),
            "onair_repeat_call_without_new_input": ("invoke 하지 않고 stale 로 되돌린다 (E33 이 "
                                                    "실측한 6번째 호출 문제의 수정)"),
        },
        "state": "ARGUED_FROM_SOURCE",
        "state_unchanged_and_why": (
            "호출부까지 읽어도 관측이 되지는 않는다. OBSERVED 로 올리려면 invoke 진입·종료의 call id "
            "기록이 필요하고, 이 실험은 그것을 만들지 않는다 (검토 SS5.2-5 가 소스 근거로 충분하면 "
            "신규 계측을 생략해도 된다고 했고, 계획 SS2 가 측정 전에 이 규칙을 고정했다)."),
        "observed_value": None,
        "verdict": ("PASS" if all(c.get("invoke_site_count", 0) > 0
                                  and c.get("counted_thread_or_task_creation_total") == 0
                                  for c in cells if "id" in c) else "FAIL"),
    }
    with open(os.path.join(ROOT, a.out), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    for c in cells:
        print("%-24s invokes=%d in %s | thread/task creation=%s"
              % (c.get("id"), c.get("invoke_site_count", -1), c.get("enclosing_functions"),
                 c.get("counted_thread_or_task_creation_total")))
    print("onair core:", "commit %s, %d site(s)" % (core.get("commit"), len(core.get("sites") or []))
          if core["available"] else core["unavailable_reason"][:60])
    print("verdict:", out["verdict"], "| state:", out["state"])
    print("wrote", a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
