#!/usr/bin/env python3
"""E26: turn the raw measurement logs into one machine-readable summary + a table.

The criteria this applies were fixed BEFORE any measurement, in
docs/plans/E26_boundary_utility.md section 2:

  Q1 soundness    hal_peak <= bounded_bytes                      (any violation = FAIL)
  Q3-i safety     ADMIT with hal_peak > budget = unsafe admit    (must be 0)
  Q3-ii bandwidth peak <= budget < bounded                       (reported, not graded)
  Q2 branch       peak == per_call            -> constants were MAPPED  (try_map succeeded)
                  peak == per_call+constants  -> constants were ALLOCATED (fallback branch)
                  anything else               -> the section 3 hypothesis is REFUTED for that cell

Section 3's hypothesis: bounded_bytes is the max over the two arms of the
`scf.if(%did_map)` that IREE emits around `stream.resource.try_map`, so soundness
holds structurally in both arms and only tightness depends on which arm ran.

Nothing here grades latency or RSS: this container is FUNCTIONAL_ONLY, and RSS is
carried through only as a reported bucket (CLAUDE.md working rule 4).

Usage:
  python3 harness/e26_collect.py --root results/e26_boundary_utility --out <summary.json>
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

CONTRACTS = {
    ("x86_64", m): "results/e14_aarch64_qemu/x86_64/contracts/contract.%s.x86_64.json" % m
    for m in ("conv2d", "mlp16k", "multibranch")
}
CONTRACTS.update({
    ("aarch64", m): "results/e14_aarch64_qemu/aarch64/contracts/contract.%s.aarch64.json" % m
    for m in ("conv2d", "mlp16k", "multibranch")
})


def branch_of(peak, per_call, constants):
    if peak is None or per_call is None or constants is None:
        return "unknown"
    if peak == per_call:
        return "mapped"
    if peak == per_call + constants:
        return "allocated"
    return "refutes_hypothesis"


def read_native(path):
    recs = []
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if line.startswith("{"):
                try:
                    recs.append(json.loads(line))
                except json.JSONDecodeError:
                    pass
    by = {}
    for r in recs:
        by.setdefault(r.get("stage"), []).append(r)
    return by


def read_cfs(path):
    """cFS interleaves EVS text with the app's JSON lines; recover the JSON."""
    by = {}
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            m = re.search(r'\{"app":"AI_LEARNER".*', line)
            if not m:
                continue
            frag, depth = m.group(0), 0
            for i, ch in enumerate(frag):
                if ch == "{":
                    depth += 1
                elif ch == "}":
                    depth -= 1
                    if depth == 0:
                        frag = frag[:i + 1]
                        break
            try:
                r = json.loads(frag)
            except json.JSONDecodeError:
                continue
            by.setdefault(r.get("stage"), []).append(r)
    return by


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--root", default="results/e26_boundary_utility")
    ap.add_argument("--out", default=None)
    a = ap.parse_args(argv)

    cells, notes = [], []
    for target in ("x86_64", "aarch64"):
        for runner in ("native", "cfs", "pip_runtime"):
            d = os.path.join(a.root, target, runner)
            if not os.path.isdir(d):
                continue
            for fn in sorted(os.listdir(d)):
                if not fn.endswith((".jsonl", ".log", ".json")):
                    continue
                model, _, tag = fn.rsplit(".", 1)[0].partition("_")
                cpath = CONTRACTS.get((target, model))
                if not cpath or not os.path.exists(cpath):
                    notes.append("no contract for %s/%s" % (target, model))
                    continue
                r = json.load(open(cpath))["resources"]
                bounded = r.get("bounded_bytes")
                per_call = r.get("static_per_call_bytes")
                consts = r.get("module_resident_constant_bytes")
                if runner == "pip_runtime":
                    # runtime_peak_check() is a single JSON object, not a stage log: no
                    # admission gate runs at all (it is the raw HAL observation this
                    # experiment compares the C paths against), so budget/admission stay
                    # None and Q3 is not graded for these cells.
                    rec = json.load(open(os.path.join(d, fn)))
                    peak = rec.get("device_bytes_peak")
                    cells.append(dict(
                        target=target, runner=runner, model=model, tag=tag or "peak",
                        file=os.path.join(d, fn), bounded=bounded, per_call=per_call,
                        constants=consts, budget=None, admission=None, hal_peak=peak,
                        hal_peak_after_init=None, hal_peak_after_first_call=None,
                        q1_sound=(None if peak is None or bounded is None else peak <= bounded),
                        q2_branch=branch_of(peak, per_call, consts),
                        q3_unsafe_admit=False, q3_gradeable=True,
                        q3_overconservative_band=(None if (peak is None or bounded is None)
                                                  else bounded - peak),
                        e25_mode_proven_off=True, rss=None))
                    continue
                by = read_native(os.path.join(d, fn)) if runner == "native" else read_cfs(os.path.join(d, fn))
                adm = (by.get("admission") or [{}])[-1]
                verdict = adm.get("verdict")
                # the two runners name the same field differently: native_learner.c writes
                # "budget_bytes", ai_learner.c writes "budget". Reading only one silently
                # left budget=None on half the matrix, which would have made Q3-i
                # ungradeable there -- and an ungradeable cell must never read as "ok".
                budget = adm.get("budget_bytes", adm.get("budget"))
                if runner == "native":
                    run = (by.get("run") or [None])[-1]
                    peak = run["hal_device_bytes_peak"] if run else None
                    ph = (run or {}).get("phase_hal") or {}
                    init_peak = (ph.get("after_init") or {}).get("peak")
                    first_peak = (ph.get("after_first_call") or {}).get("peak")
                    e25_off = (run or {}).get("e25_mode_active") is False
                    rss = (run or {}).get("rss_kb")
                else:
                    mem = (by.get("mem") or [None])[-1]
                    peak = mem.get("hal_peak") if mem else None
                    mi = (by.get("mem_init") or [None])[-1]
                    init_peak = mi.get("hal_peak") if mi else None
                    first = [x for x in (by.get("mem") or []) if x.get("completed") == 1]
                    first_peak = first[0]["hal_peak"] if first else None
                    e25 = (by.get("e25_mode") or [None])[-1]
                    e25_off = bool(e25) and e25.get("active") is False
                    rss = {"init_kb": (mi or {}).get("process_rss_kb"),
                           "after_session_kb": (mi or {}).get("rss_kb_after_session"),
                           "before_runtime_kb": (mi or {}).get("rss_kb_before_runtime")}
                sound = None if peak is None or bounded is None else peak <= bounded
                unsafe = bool(verdict == "ADMIT" and peak is not None and budget is not None
                              and peak > budget)
                q3_gradeable = not (verdict == "ADMIT" and (peak is None or budget is None))
                cells.append(dict(
                    target=target, runner=runner, model=model, tag=tag, file=os.path.join(d, fn),
                    bounded=bounded, per_call=per_call, constants=consts,
                    budget=budget, admission=verdict,
                    hal_peak=peak, hal_peak_after_init=init_peak, hal_peak_after_first_call=first_peak,
                    q1_sound=sound, q2_branch=branch_of(peak, per_call, consts),
                    q3_unsafe_admit=unsafe, q3_gradeable=q3_gradeable,
                    q3_overconservative_band=(None if (peak is None or bounded is None)
                                              else bounded - peak),
                    e25_mode_proven_off=e25_off, rss=rss))

    graded = [c for c in cells if c["hal_peak"] is not None]
    summary = dict(
        tool="harness/e26_collect.py",
        criteria_source="docs/plans/E26_boundary_utility.md section 2 (fixed before measurement)",
        cells=len(cells), cells_with_a_run=len(graded),
        q1_violations=[c["file"] for c in graded if c["q1_sound"] is False],
        q1_pass=all(c["q1_sound"] for c in graded) if graded else None,
        q3_unsafe_admits=[c["file"] for c in cells if c["q3_unsafe_admit"]],
        q3_pass=(not any(c["q3_unsafe_admit"] for c in cells)
                 and all(c["q3_gradeable"] for c in cells)),
        q3_ungradeable=[c["file"] for c in cells if not c["q3_gradeable"]],
        q2_branches={b: sum(1 for c in graded if c["q2_branch"] == b)
                     for b in sorted({c["q2_branch"] for c in graded})},
        q2_hypothesis_refuted=[c["file"] for c in graded if c["q2_branch"] == "refutes_hypothesis"],
        e25_mode_unproven=[c["file"] for c in graded if not c["e25_mode_proven_off"]],
        notes=notes)
    out = dict(summary=summary, cells=cells)
    if a.out:
        with open(a.out, "w") as f:
            json.dump(out, f, indent=2, sort_keys=True)
            f.write("\n")
        print("wrote %s" % a.out)
    print("%-8s %-11s %-12s %-5s %-9s %-14s %-9s %-11s %-8s %-6s %s"
          % ("target", "runner", "model", "B", "budget", "admission", "peak", "branch",
             "tight", "Q1", "Q3"))
    for c in cells:
        tight = ("%.2fx" % (c["bounded"] / c["hal_peak"])
                 if c["hal_peak"] and c["bounded"] else "-")
        print("%-8s %-11s %-12s %-5s %-9s %-14s %-9s %-11s %-8s %-6s %s"
              % (c["target"], c["runner"], c["model"], c["tag"], c["budget"], c["admission"],
                 c["hal_peak"], c["q2_branch"], tight, c["q1_sound"],
                 "UNSAFE" if c["q3_unsafe_admit"] else ("ok" if c["q3_gradeable"] else "UNGRADED")))
    print("Q1 pass=%s  Q3 pass=%s  branches=%s" % (summary["q1_pass"], summary["q3_pass"],
                                                   summary["q2_branches"]))
    return 0 if (summary["q1_pass"] is not False and summary["q3_pass"]) else 1


if __name__ == "__main__":
    sys.exit(main())
