#!/usr/bin/env python3
"""E42/E43: derive the O0..O3 comparison table from the cells. Never hand-assembled (D64).

Two cells are MEASURED here (O0, O1) and two are CITED from earlier experiments (O2, O3).
The distinction is carried in the table itself, because the roadmap's section 7.3 reads as
four new cells and re-running the two that already exist -- then counting four -- is the
duplicate-evidence inflation D72 corrected.

Each cited cell also carries its own known limitation, so citing it does not quietly
launder it (D65: a correction that lives only in prose).
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = os.path.join(ROOT, "results", "e43_pure_onair")

MEASURED = [
    ("O0", "OnAIR + LiteRT (pure baseline)", "o0_pure_onair_litert",
     "plugins/litert_learner -- no contract, no admission, no artifact binding"),
    ("O1", "OnAIR + IREE, admission NOT evaluated", "o1_iree_no_budget",
     "plugins/compiled_learner with budget_bytes omitted -- zero new code"),
]
CITED = [
    ("O2", "OnAIR + IREE + contract, budget B", "results/e33_onair_official/p_admit",
     "E33 (v0.36). Re-run more recently as results/e41_analysis_domain/onair_cells/smartcam.",
     "the archived run.json reports `nanobind: leaked 10 instances` at interpreter shutdown; "
     "D60 withdrew the 'output buffer released' claim because of it. Memory release on this "
     "path is NOT VERIFIED -- and may not be called a leak either."),
    ("O3", "OnAIR + IREE + contract, budget B-1", "results/e33_onair_official/p_deny",
     "E33 (v0.36). Re-run more recently as results/e41_analysis_domain/onair_cells/smartcam_deny.",
     "the cell records `binding: null` and `inferences: 0`; there is no field that separately "
     "states whether the IREE runtime was created, so 'refused before the runtime existed' "
     "rests on the plugin's documented order, not on a recorded signal."),
]


def load(p):
    try:
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError) as e:
        return {"__unreadable__": "%s: %s" % (type(e).__name__, e), "__path__": p}


def records(cell_dir):
    p = os.path.join(cell_dir, "plugin_records.jsonl")
    out = []
    if os.path.exists(p):
        with open(p, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        out.append(json.loads(line))
                    except ValueError:
                        # a truncated record is an OBSERVATION, not nothing (D68)
                        out.append({"event": "__unparseable__"})
    return out


def view(cell_dir, label, kind, note, limitation=None):
    run = load(os.path.join(ROOT, cell_dir, "run.json")) if not os.path.isabs(cell_dir) \
        else load(os.path.join(cell_dir, "run.json"))
    if "__unreadable__" in run:
        return {"path": label, "readable": False, "reason": run["__unreadable__"]}
    recs = records(os.path.join(ROOT, cell_dir))
    init = next((r for r in recs if r.get("event") == "init"), {})
    infers = [r for r in recs if r.get("event") == "inference"]
    adm = (init.get("admission") or {})
    return {
        "path": label, "kind": kind, "cell": cell_dir, "note": note,
        "readable": True,
        # the roadmap's section 7.5 measurands, one column each
        "official_loader_constructed": run.get("plugin_constructed"),
        "onair_core_unmodified": (run.get("onair") or {}).get("core_unmodified"),
        "admission_verdict": adm.get("verdict"),
        "admission_reason": adm.get("reason"),
        "runtime_created": init.get("active"),
        "inferences": run.get("inferences"),
        "inference_records": len(infers),
        "process_returncode": run.get("returncode"),
        "inactive_reason": init.get("inactive_reason"),
        "has_contract": init.get("has_contract", True if init.get("entry") else None),
        "has_admission_gate": init.get("has_admission_gate",
                                       None if init.get("admission") is None else True),
        "known_limitation": limitation,
    }


def main():
    rows = []
    for pid, label, cell, note in MEASURED:
        rows.append(dict(view(os.path.join("results", "e43_pure_onair", cell),
                              "%s -- %s" % (pid, label), "MEASURED (E43)", note), id=pid))
    for pid, label, cell, note, lim in CITED:
        rows.append(dict(view(cell, "%s -- %s" % (pid, label), "CITED (not re-run)", note, lim),
                         id=pid))

    out = {
        "experiment": "E42/E43",
        "title": "Pure OnAIR baseline O0..O3",
        "plan": "docs/plans/E42_E43_pure_onair_baseline.md (committed before measurement, 766ae2a)",
        "what_this_compares": "what the proposed path ADDS to an OnAIR run, not whether OnAIR "
                              "is deficient. Pure OnAIR has no contract of this research's kind, "
                              "so 'OnAIR violated the contract' and 'OnAIR cannot manage memory' "
                              "are both forbidden statements (roadmap 7.1).",
        "cells_measured_here": sum(1 for r in rows if r.get("kind", "").startswith("MEASURED")),
        "cells_cited": sum(1 for r in rows if r.get("kind", "").startswith("CITED")),
        "not_measured_deliberately": {
            "memory": "roadmap 7.5 -- LiteRT process RSS and the partial contract value have "
                      "different accounting boundaries, so they are not compared. The O0 plugin "
                      "records no memory figure at all, which is the only version of that rule "
                      "that survives a reader.",
            "latency": "platform_check.py reports FUNCTIONAL_ONLY.",
        },
        "samples": "the same 5 that E33's p_admit replayed (3 real OPS-SAT images + 2 boundary). "
                   "The roadmap's section 7.4-3 says 37; smartcam_replay.csv has 5 rows and "
                   "p_admit inferred 5 times (plan section 1).",
        "rows": rows,
    }
    os.makedirs(D, exist_ok=True)
    p = os.path.join(D, "summary.json")
    with open(p, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1, ensure_ascii=False)
        f.write("\n")
    print(p)
    hdr = "%-4s %-12s %-9s %-16s %-9s %-7s" % ("id", "kind", "loader", "admission", "runtime", "infer")
    print(hdr); print("-" * len(hdr))
    for r in rows:
        print("%-4s %-12s %-9s %-16s %-9s %-7s"
              % (r.get("id"), (r.get("kind") or "")[:12], r.get("official_loader_constructed"),
                 r.get("admission_verdict"), r.get("runtime_created"), r.get("inferences")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
