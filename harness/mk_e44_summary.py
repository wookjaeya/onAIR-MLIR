#!/usr/bin/env python3
"""E44: derive the budget-provenance summary from the three deployment paths.

Never hand-assembled (D64). Each row's value is read out of a record the path itself
wrote -- not out of this file -- so a path that stops labelling its budget shows up as a
missing value rather than as a sentence that is still true in the summary.
"""
import glob
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(ROOT, "results", "e44_budget_provenance")


def load(p):
    try:
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError) as e:
        return {"__unreadable__": "%s: %s" % (type(e).__name__, e), "__path__": p}


def onair_row(cell, label):
    d = load(os.path.join(D, cell, "run.json"))
    if "__unreadable__" in d:
        return {"path": label, "readable": False, "reason": d["__unreadable__"]}
    a = (d.get("plugin_init") or {}).get("admission") or {}
    return {"path": label, "readable": True, "mechanism": "OnAIR deployment JSON",
            "verdict": a.get("verdict"), "budget_bytes": a.get("admitted_budget_bytes"),
            "budget_source": a.get("budget_source"),
            "detail": a.get("budget_source_detail") or a.get("budget_source_note"),
            "cell": os.path.join("results", "e44_budget_provenance", cell)}


def native_row():
    """Read the admission line this executor printed, from the archived native run."""
    p = os.path.join(D, "native_admission.jsonl")
    if not os.path.exists(p):
        return {"path": "native executor", "readable": False,
                "reason": "no archived native admission record"}
    with open(p, encoding="utf-8") as f:
        rec = json.loads(f.readline())
    return {"path": "native executor", "readable": True, "mechanism": "argv[2]",
            "verdict": rec.get("verdict"), "budget_bytes": rec.get("budget_bytes"),
            "budget_source": rec.get("budget_source"),
            "detail": "harness-free C executor; the budget is a command-line argument",
            "cell": "results/e44_budget_provenance/native_admission.jsonl"}


def _admission_lines(path):
    """Yield parsed admission records that carry budget_source, from one log."""
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            if '"stage":"admission"' in line and '"budget_source"' in line:
                try:
                    yield json.loads(line[line.index("{"):].strip())
                except ValueError:
                    continue


def cfs_row():
    """Cited, not re-run: the cFS app has recorded budget_source since E36/E38."""
    # The first version of this glob had one directory level too many
    # (cells/*/*.log) and reported "no archived cFS admission line carrying
    # budget_source was found". The lines were there; the generator could not see
    # them. That is D51's distinction -- "could not observe" recorded as "observed
    # and there was none" -- so the search is now broad and the match is on content.
    #
    # The SECOND version then took the first sorted match, which landed on
    # results/e36_aarch64_cfs/cache_leak_bug/deny_B_minus_1.log -- a log this
    # repository keeps precisely because it REPRODUCES a defect (D61(b): a leaked
    # CMake cache value turned a cell that had to deny into ADMIT_CONDITIONAL_MAP).
    # The record does carry budget_source, so the claim stayed true, but `detail`
    # said "cited from E38's re-run cells" while `cell` pointed somewhere else:
    # two fields of one row disagreeing is the shape this repository logs as D65.
    # The citation is now deliberate -- E38's re-run cells first -- and when the
    # fallback fires it says so instead of reading like the preferred source.
    preferred = sorted(glob.glob(os.path.join(
        ROOT, "results", "e38_optin_record", "cells", "*.log")))
    others = [p for p in sorted(glob.glob(os.path.join(ROOT, "results", "**", "*.log"),
                                          recursive=True)) if p not in preferred]
    carriers = [p for p in preferred + others if any(_admission_lines(p))]
    for cand in preferred + others:
        for rec in _admission_lines(cand):
            cited = "e38_rerun" if cand in preferred else "fallback_scan"
            return {"path": "cFS app", "readable": True,
                    "mechanism": "compile-time macro, or runtime override (E36)",
                    "verdict": rec.get("verdict"),
                    "budget_bytes": rec.get("budget") or rec.get("budget_bytes"),
                    "budget_source": rec.get("budget_source"),
                    "detail": ("cited from E38's re-run cells, not re-run here"
                               if cited == "e38_rerun" else
                               "E38's re-run cells carried no such record; cited from "
                               "another archived cFS log, not re-run here"),
                    "cited_from": cited,
                    # How many archived logs carry the field at all. "We found one"
                    # and "only one exists" are different statements; say which.
                    "archived_logs_carrying_budget_source": len(carriers),
                    "cell": os.path.relpath(cand, ROOT)}
    return {"path": "cFS app", "readable": False,
            "reason": "no archived cFS admission line carrying budget_source was found",
            "logs_searched": len(preferred) + len(others)}


def main():
    rows = [onair_row("onair_budget_labelled", "OnAIR plugin (budget declared)"),
            onair_row("onair_no_budget", "OnAIR plugin (no budget)"),
            native_row(), cfs_row()]
    a5 = load(os.path.join(ROOT, "results", "e39_prior_art", "a5_reservation_scan.json"))
    table = open(os.path.join(ROOT, "results", "e39_prior_art", "prior_art.md"),
                 encoding="utf-8").read()
    m = re.search(r"\*\*(declared|enforced|unknown)\*\* — .*?`harness/budget_provenance\.py`", table)

    out = {
        "experiment": "E44",
        "title": "Budget provenance",
        "plan": "docs/plans/E44_budget_provenance.md (committed before measurement, 2aa93cf)",
        "what_was_narrowed": {
            "budget_source": "ALREADY EXISTED (cFS app since E36, pinned in 5 tests). Extended "
                             "to the two paths that labelled nothing; no value renamed.",
            "budget_scope": "NOT ADDED -- resources.scope, accounting_rules.excluded (E40) and "
                            "the admission record's per_app_local_budget already carry it. A "
                            "fourth name for one concept is D65's pattern.",
            "reservation_semantics": "NOT ADDED as a contract field -- E39a pre-registered the "
                                     "same concept as axis A5, and a contract field would put "
                                     "the fact in a second place no guard re-checks. A5 is "
                                     "DERIVED instead.",
            "roadmap_enum_rejected": "{mission configuration, cFS table, experiment override} -- "
                                     "'cFS table' has no implementation (CFE_TBL appears only in "
                                     "cFS boot logs, never in source) and 'mission configuration' "
                                     "would promote a CMake macro into an unearned claim.",
        },
        "paths": rows,
        "all_paths_label_their_budget": all(
            r.get("readable") and r.get("budget_source") for r in rows),
        "a5_axis": {
            "verdict": a5.get("verdict"), "reason": a5.get("reason"),
            "files_scanned": a5.get("files_scanned"), "hits": len(a5.get("hits") or []),
            "derived_in_table": bool(m),
            "table_cell": m.group(0)[:160] if m else None,
            "never_promotes": a5.get("never_promotes"),
        },
    }
    os.makedirs(D, exist_ok=True)
    p = os.path.join(D, "summary.json")
    with open(p, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1, ensure_ascii=False)
        f.write("\n")
    print(p)
    for r in rows:
        print("  %-32s %-22s %s" % (r["path"], r.get("budget_source"), r.get("mechanism", "")))
    print("  A5: %s (%d hits / %d files, derived_in_table=%s)"
          % (out["a5_axis"]["verdict"], out["a5_axis"]["hits"],
             out["a5_axis"]["files_scanned"], out["a5_axis"]["derived_in_table"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
