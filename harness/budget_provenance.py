#!/usr/bin/env python3
"""E44: decide, FROM THE REPOSITORY, whether this research's budget is `declared` or
`enforced` -- the axis E39a pre-registered as A5.

Why this file exists rather than a new contract field
-----------------------------------------------------
The roadmap (section 6.2) asks for a `reservation_semantics: declared | enforced` field on
the deployment. The concept already exists: E39a pre-registered it as axis A5
("실제 **예약**을 하는가 | declared / enforced / 해당 없음",
docs/plans/E39_novelty_audit.md:79) and the prior-art table already prints a value for it.

But it prints a HAND-WRITTEN one. In harness/mk_prior_art_table.py the neighbouring axes
read from the contract --

    "A2": "... (계약이 scope=%s 로 매 판정마다 명시)" % r.get("scope"),
    "A3": "예 (bound_method=%s)" % r.get("bound_method"),

-- while A5 is a literal string. Adding a contract field would put the same fact in a
SECOND place that no guard cross-checks, which is exactly the shape D65 named (a
correction that lives only in prose while the machine-readable place still disagrees).

So this goes the other way: A5 is DERIVED. `declared` rests on a claim that can be checked
in the source -- that no execution path reserves physical memory for the budget -- and this
module checks it.

What "checked" means here, and what it does not
-----------------------------------------------
Finding zero reservation calls supports `declared`. Finding one does NOT support
`enforced`: a call existing is not the same as that call reserving THIS budget. That is the
same distinction E28/D52 learned about gates -- a gate that runs is not a gate that uses the
contract's number. So a hit downgrades the verdict to `unknown` and names the site, rather
than promoting it.

One line-level waiver, and why it is not a hole (D77)
----------------------------------------------------
E44 shipped this scanner together with a guard test that DEMONSTRATES the downgrade rule by
feeding `verdict()` a synthetic hit whose text is `mlock(p, n);`. That fixture line is source
code under harness/, so on the next run the scanner found it and reported `unknown` -- the
test written to prove the rule triggered the rule, and the committed artifact (declared, 0
hits) silently disagreed with the live tool. Nothing guarded that disagreement, which is the
very shape E44 said it was avoiding.

The fix is a LINE-level waiver, never a file-level one: a line carrying the marker
`budget-provenance: test-fixture` is skipped. Excluding the whole test file instead would
hide a real reservation call added to it later, and this repository logs both directions as
defects. Every waived line is copied verbatim into the output under `waived`, so a waiver
costs visibility rather than buying silence, and a regression test re-runs this scan live and
fails if it disagrees with the committed artifact.

Sources only, never logs
------------------------
The scan reads source files and skips logs and results. This is not fastidiousness: while
planning E44 the audit reported "CFE_TBL used 0 times" and a direct grep returned 15 hits --
all fifteen in cFS boot logs under native/results/, none in source. A scanner that counted
those would have reported a table service this app does not use.
"""
import argparse
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Calls that would actually reserve or pin physical memory for a budget. Each is named
# with what it would mean, so a later reader can judge the list rather than trust it.
RESERVATION_CALLS = {
    "mlock": "pins pages into RAM",
    "mlockall": "pins the whole address space",
    "MAP_POPULATE": "mmap flag that prefaults (and with MAP_LOCKED, reserves) pages",
    "MAP_LOCKED": "mmap flag that locks the mapping",
    "CFE_ES_PoolCreate": "creates a cFE memory pool, i.e. carves out a reserved region",
    "CFE_ES_GetPoolBuf": "allocates from a cFE reserved pool",
    "CFE_ES_RegisterCDS": "reserves Critical Data Store space",
    "OS_MemPoolCreate": "OSAL memory pool creation",
}

# Where the deployable code lives. Logs, archived results and the plans are not code.
SOURCE_DIRS = ("native", "plugins", "harness")
SOURCE_EXT = (".c", ".h", ".cpp", ".py", ".cmake")
SKIP_DIRS = {"results", "__pycache__", ".git", "build", "dump"}

# A line carrying this marker is a fixture that FEEDS this scanner, not a use of the call.
# Line-level on purpose (D77): excluding a whole file would hide a later real call in it.
FIXTURE_MARKER = "budget-provenance: test-fixture"


def scan(root=ROOT):
    """Return (hits, files_scanned, waived). A hit is (call, file, line_no, line_text)."""
    hits, waived, n = [], [], 0
    for top in SOURCE_DIRS:
        base = os.path.join(root, top)
        if not os.path.isdir(base):
            continue
        for dirpath, dirnames, filenames in os.walk(base):
            dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
            for fn in sorted(filenames):
                if not fn.endswith(SOURCE_EXT):
                    continue
                p = os.path.join(dirpath, fn)
                rel = os.path.relpath(p, root)
                n += 1
                if rel == os.path.join("harness", "budget_provenance.py"):
                    # this module's own table and marker constant are not uses of the calls.
                    # Done at file level so the marker's own definition is not counted as a
                    # waiver -- a waiver must mean "a fixture elsewhere", not "this file".
                    continue
                try:
                    with open(p, encoding="utf-8", errors="replace") as f:
                        for i, line in enumerate(f, 1):
                            if FIXTURE_MARKER in line:
                                # recorded, not hidden: the waiver is visible in the artifact
                                waived.append({"file": rel, "line": i,
                                               "text": line.strip()[:200],
                                               "why": "line marked as a fixture that feeds this "
                                                      "scanner (D77)"})
                                continue
                            for call in RESERVATION_CALLS:
                                # word-boundary match so `mlock` does not fire on `mlocked_note`
                                if re.search(r"\b%s\b" % re.escape(call), line):
                                    hits.append({"call": call, "file": rel, "line": i,
                                                 "text": line.strip()[:160],
                                                 "means": RESERVATION_CALLS[call]})
                except OSError:
                    continue
    return hits, n, waived


def verdict(hits):
    """declared when nothing reserves; unknown when something might. NEVER `enforced`.

    Promoting a hit to `enforced` would assert that the found call reserves THIS budget,
    which the scan cannot know. Downgrading to `unknown` is the honest direction and the
    one that costs a claim rather than inventing one.
    """
    if not hits:
        return "declared", ("no reservation call appears in any source file, so the budget is a "
                            "number compared against a contract, not a reservation of physical "
                            "memory")
    return "unknown", ("%d reservation-capable call site(s) found; the scan cannot tell whether "
                       "any of them reserves THIS budget, so the axis is not asserted either way"
                       % len(hits))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    hits, n, waived = scan()
    v, why = verdict(hits)
    doc = {
        "tool": "harness/budget_provenance.py",
        "axis": "A5 (E39a pre-registered): 실제 예약을 하는가 -- declared / enforced / 해당 없음",
        "verdict": v,
        "reason": why,
        "files_scanned": n,
        "reservation_calls_looked_for": RESERVATION_CALLS,
        "hits": hits,
        "waived": waived,
        "waived_count": len(waived),
        "why_waivers_are_line_level": "a line carrying the marker %r feeds this scanner instead "
                                      "of using the call. Excluding a whole file would hide a "
                                      "real call added to it later, so the waiver is one line "
                                      "wide and is copied verbatim here (D77)." % FIXTURE_MARKER,
        "scan_scope": {"dirs": list(SOURCE_DIRS), "extensions": list(SOURCE_EXT),
                       "skipped": sorted(SKIP_DIRS),
                       "why_sources_only": "logs are not code. While planning E44 an audit "
                                           "reported 'CFE_TBL used 0 times' and a direct grep "
                                           "returned 15 hits -- all fifteen in cFS boot logs, "
                                           "none in source."},
        "never_promotes": "a hit downgrades to `unknown`; it never yields `enforced`, because a "
                          "call existing is not that call reserving this budget (E28/D52).",
    }
    if a.out:
        os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
        with open(a.out, "w", encoding="utf-8") as f:
            json.dump(doc, f, indent=1, ensure_ascii=False)
            f.write("\n")
        print(a.out)
    print(json.dumps({"verdict": v, "files_scanned": n, "hits": len(hits),
                      "waived": len(waived)}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
