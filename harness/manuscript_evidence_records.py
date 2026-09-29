#!/usr/bin/env python3
"""D113: record two facts the manuscript relies on, where the repository record disagreed or was
labelled with the wrong target.

1. Author confirmations. The manuscript cites GSFC-STD-1000H (Rule 3.07, Table 3.07-1), the Xiphos Q8
   specification sheet and the OPS-SAT platform description from originals the author read. This
   container cannot reach those hosts, so no bytes are archived and no digest is written: a digest
   of bytes nobody here holds would be a fabricated record. The E54 grades
   (`transcribed_from_directive_primary_blocked`, `mirror_adjacent_revision_fetched`) describe what
   THIS environment fetched and stay as they are; the confirmation is recorded beside them, not as
   an upgrade of them.

2. DeepAE constants. The manuscript states that the imported module's dense constants are
   byte-identical to the original model's. The comparison was made by E52 on an MLIR file stored
   under an x86-64-labelled directory. The comparison is target-independent -- it reads the
   imported MLIR and the .tflite, not a compiled artifact -- and the file it read is the one the
   AArch64 evaluated specification names as its model (same sha256). This script re-derives that
   link from the repository every time it runs, so the record cannot drift from the files.

3. GSFC-STD-1000I (v0.73.2). The manuscript (v31) states that revision I, which superseded the cited
   revision H, retains the two RAM margin values, the margin definition and the statement that the
   values are not hard limits. That was confirmed from the official PDF by the v30 manuscript review
   (2026-09-28), not by this environment (the host is still unreachable), so it is recorded like the
   author confirmations: without bytes or a digest, with the reason.

4. The artifact-only comparison. The manuscript (v31) describes the agreeing verdicts as policy
   evaluations at B_u, P and P-1 under both policies, not executed cells. The composition is
   re-derived from the E59 Part A record and the four AArch64 documents every time this runs.

Usage: python3 harness/manuscript_evidence_records.py [--check]
  default: write results/manuscript_evidence_records/records.json
  --check: re-derive and compare with the committed file (rc 1 on any difference)
"""
import hashlib
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, "results", "manuscript_evidence_records", "records.json")

E52_DIVERGENCE = "results/e52_deepae_divergence/divergence.json"
E59_PART_A = "results/e59_info_levels_aarch64/part_a.json"
E52_MLIR = "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae_infer.mlir"
AARCH64_MLIR = "results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir"
AARCH64_DOC = "results/e65_producer_check/reissued/b3_deepae/b3_deepae.contract.json"
BUDGETS = "results/e54_reference_budget/budgets.json"

# Recorded, not re-run: the probes need network, and a guard must not depend on it.
REPROBE_ON = "2026-09-28"
AUTHOR_CONFIRMATIONS = [
    {
        "id": "gsfc_std_1000h",
        "document": "GSFC-STD-1000H, Goddard Space Flight Center Rules for the Design, Development, "
                    "Verification, and Operation of Flight Systems (approved 15 March 2023; superseded "
                    "by GSFC-STD-1000I, approved 19 August 2025)",
        "url": "https://standards.nasa.gov/sites/default/files/standards/GSFC/H/0/GSFC-STD-1000RevH_Approved.pdf",
        "locator": "Rule 3.07; Table 3.07-1 (Flight Software Margins), RAM row",
        "manuscript_uses": [
            "margins presented at key decision point reviews; the table pairs each phase with how the "
            "used resource is obtained (estimated / analyzed / analyzed or measured / measured)",
            "bulk data storage is excluded from the RAM row",
            "mu = 0.5 (preliminary design review) and 0.3 (ship/flight) from the RAM row; margin = "
            "(allocated - used) / allocated",
            "the values are levels at which a shortfall is taken up with the rule's owner, not hard limits",
            "the cited revision H is superseded by revision I (v31: revision I retains both values, the margin "
            "definition and the not-hard-limits statement; see review_confirmations.gsfc_std_1000i)",
        ],
        "confirmed_by": "author, from the original document, during manuscript revision (v27)",
        "bytes_in_repository": False,
        "sha256": None,
        "sha256_unavailable_reason": "the document was read by the author outside this environment; "
                                     "no copy was supplied, so no digest can be computed here",
        "reprobe": {"on": REPROBE_ON, "url": "same as above", "http_code": "000",
                    "meaning": "host not reachable through this container's proxy (E55/P0-1); "
                               "not a statement about the document"},
        "repository_grades_kept": {"file": BUDGETS, "fields": ["margins.pdr50.grade", "margins.ship30.grade"],
                                   "value": "transcribed_from_directive_primary_blocked"},
    },
    {
        "id": "xiphos_q8_spec_sheet",
        "document": "Q8 Specifications, document XTI-2001-2024-i, Xiphos Systems Corporation, 13 August 2026",
        "url": "https://resources.epiqsolutions.com/hubfs/Xiphos-2023/PDFs/XTI-2001-2024-i-Q8-Rev-C-Spec-Sheet.pdf",
        "locator": "memory specification; Q8S described as the flight-model version of the Q8",
        "manuscript_uses": ["4 GB LPDDR4 DRAM with error detection and correction (R = 4 GiB profile)"],
        "confirmed_by": "author, from the original document, retrieved 28 September 2026 (v27)",
        "bytes_in_repository": False,
        "sha256": None,
        "sha256_unavailable_reason": "the document was read by the author outside this environment",
        "reprobe": {"on": REPROBE_ON, "url": "same as above", "http_code": "000",
                    "meaning": "host not reachable through this container's proxy"},
        "repository_grades_kept": {"file": BUDGETS, "fields": ["platforms.PA.source_grade"],
                                   "value": "mirror_adjacent_revision_fetched",
                                   "note": "E54 derived R from a mirror of an adjacent revision; the "
                                           "4 GB figure the manuscript cites is the same"},
    },
    {
        "id": "opssat_platform",
        "document": "Labreche et al., OPS-SAT Spacecraft Autonomy with TensorFlow Lite, Unsupervised "
                    "Learning, and Online Machine Learning, IEEE Aerospace Conference 2022",
        "url": "https://doi.org/10.1109/AERO53065.2022.9843402",
        "locator": "experimental platform design specification; later memory allocation adjustment",
        "manuscript_uses": ["800 MHz processor with 1 GB (R = 1 GiB profile, design capacity)",
                            "a later allocation adjustment after hardware degradation"],
        "confirmed_by": "author, from the paper, during manuscript revision (v27)",
        "bytes_in_repository": False,
        "sha256": None,
        "sha256_unavailable_reason": "the paper was read by the author outside this environment",
        "reprobe": None,
        "repository_grades_kept": None,
    },
]


REVIEW_CONFIRMATIONS = [
    {
        "id": "gsfc_std_1000i",
        "document": "GSFC-STD-1000I, Goddard Space Flight Center Rules for the Design, Development, "
                    "Verification, and Operation of Flight Systems (approved 19 August 2025; supersedes H)",
        "url": None,
        "url_note": "no address is recorded: the one the review supplied was a temporary upload path, not a "
                    "stable location of the document; the standard is identified by its number, issuer and "
                    "approval date (v0.73.3)",
        "locator": "Rule 3.07; Table 3.07-1, printed pages 54-55",
        "manuscript_uses": [
            "revision I retains the RAM margins used: 50% at preliminary design review, 30% at ship/flight",
            "revision I retains the margin definition, (allocated - used) / allocated",
            "revision I retains the statement that the table values are not uniform hard limits",
        ],
        "not_confirmed_here": "the phase methods of Rule 3.07 and the RAM row's bulk-storage exclusion are "
                              "still cited from revision H only",
        "confirmed_by": "the v30 manuscript review supplied by the author (2026-09-28), from the official PDF",
        "bytes_in_repository": False,
        "sha256": None,
        "sha256_unavailable_reason": "the document was read by the reviewer outside this environment; "
                                     "no copy was supplied, so no digest can be computed here",
        "reprobe": {"on": REPROBE_ON, "host": "standards.nasa.gov", "http_code": "000",
                    "webfetch": "EGRESS_BLOCKED",
                    "meaning": "host not reachable through this container's proxy (E55/P0-1); "
                               "not a statement about the document"},
        "repository_grades_kept": {"file": BUDGETS, "fields": ["margins.pdr50.grade", "margins.ship30.grade"],
                                   "value": "transcribed_from_directive_primary_blocked"},
    },
]


def sha256(rel):
    with open(os.path.join(REPO, rel), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def derive():
    div = json.load(open(os.path.join(REPO, E52_DIVERGENCE)))
    q1 = div["Q1_constants_bit_identical"]
    doc = json.load(open(os.path.join(REPO, AARCH64_DOC)))
    budgets = json.load(open(os.path.join(REPO, BUDGETS)))
    grades = {
        "margins.pdr50.grade": budgets["margins"]["pdr50"]["grade"],
        "margins.ship30.grade": budgets["margins"]["ship30"]["grade"],
        "platforms.PA.source_grade": budgets["platforms"]["PA"]["source_grade"],
    }
    e52_sha, a64_sha = sha256(E52_MLIR), sha256(AARCH64_MLIR)
    link = {
        "claim": "the imported DeepAE module's dense constants are byte-identical to the original model's",
        "compared_by": E52_DIVERGENCE,
        "compared_by_target_label": div.get("target"),
        "comparison_ok": bool(q1.get("ok")),
        "constants_compared": len(q1.get("rows", [])),
        "compared_mlir": {"path": E52_MLIR, "sha256": e52_sha},
        "aarch64_compile_input": {"path": AARCH64_MLIR, "sha256": a64_sha},
        "aarch64_evaluated_document": {"path": AARCH64_DOC, "model_sha256": doc["model"]["sha256"]},
        "same_mlir": e52_sha == a64_sha == doc["model"]["sha256"],
        "why_target_independent": "the comparison reads the imported MLIR and the .tflite; no compiled "
                                  "artifact or target code is involved, and the MLIR is the one the "
                                  "AArch64 evaluated specification names as its model",
    }
    part_a = json.load(open(os.path.join(REPO, E59_PART_A)))
    bands = {}
    for c in part_a["cells"]:
        bands.setdefault(c["band"], {})[c["model"]] = c["budget_bytes"]
    figures = {m: (v["level_c_mlir"]["bounded_bytes"], v["level_c_mlir"]["per_call_bytes"])
               for m, v in part_a["models"].items()}
    budgets_are_rule = all(
        bands.get("band_above_B", {}).get(m) == bu and bands.get("band_between", {}).get(m) == p
        and bands.get("band_below_P", {}).get(m) == p - 1 for m, (bu, p) in figures.items())
    artifact_only = {
        "claim": "the artifact-only and layout analyses give identical verdicts as policy evaluations at "
                 "B_u, P and P-1 under both policies, not executed cells; a corollary, not independent evidence",
        "source": E59_PART_A,
        "evaluations": len(part_a["cells"]),
        "models": sorted(figures),
        "policies": sorted({c["policy"] for c in part_a["cells"]}),
        "budgets_are_B_u_P_P_minus_1": budgets_are_rule,
        "models_run": part_a["fairness"]["models_run"],
        "recompiled": part_a["fairness"]["recompiled"],
        "verdicts_disagreeing": part_a["totals"]["verdicts_disagreeing"],
        "corollary_note_present": "BY CONSTRUCTION" in part_a.get("corollary_note", ""),
    }
    return {
        "record": "D113",
        "purpose": "align the repository record with facts the manuscript relies on",
        "author_confirmations": AUTHOR_CONFIRMATIONS,
        "review_confirmations": REVIEW_CONFIRMATIONS,
        "repository_grades_observed": grades,
        "deepae_constants_link": link,
        "artifact_only_policy_evaluations": artifact_only,
    }


def main():
    rec = derive()
    if "--check" in sys.argv:
        committed = json.load(open(OUT))
        same = committed == rec
        print("records.json", "matches re-derivation" if same else "DIFFERS from re-derivation")
        return 0 if same else 1
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(rec, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print("wrote", os.path.relpath(OUT, REPO), "same_mlir=%s" % rec["deepae_constants_link"]["same_mlir"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
