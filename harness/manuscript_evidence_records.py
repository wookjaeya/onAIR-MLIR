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
   author confirmations: without bytes or a digest, with the reason. From manuscript v44 every GSFC
   citation is to revision I: the v43 manuscript review (2026-10-04) confirmed from the same PDF that
   revision I's Rule 3.07 and Table 3.07-1 carry the margin description the introduction cites (the
   PDF shows Rule 3.07's revision status as H) and the RAM row's bulk-memory note, which tracks bulk
   memory apart unless it shares undistinguished processor-card memory (v0.76.2).

4. The artifact-only comparison. The manuscript (v31) describes the agreeing verdicts as policy
   evaluations at B_u, P and P-1 under both policies, not executed cells. The composition is
   re-derived from the E59 Part A record and the four AArch64 documents every time this runs.

Usage: python3 harness/manuscript_evidence_records.py [--check]
  default: write results/manuscript_evidence_records/records.json
  --check: re-derive and compare with the committed file (rc 1 on any difference)
"""
import glob
import hashlib
import json
import math
import os
import re
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
        "manuscript_status": "not cited from manuscript v44: every use above is cited to revision I "
                             "(review_confirmations.gsfc_std_1000i), except the shortfall wording, which is dropped",
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
        "locator": "Rule 3.07; Table 3.07-1 and its RAM description, printed pages 54-56",
        "manuscript_uses": [
            "revision I retains the RAM margins used: 50% at preliminary design review, 30% at ship/flight",
            "revision I retains the margin definition, (allocated - used) / allocated",
            "revision I retains the qualification cited from revision H that the values are not hard limits "
            "(manuscript v40: 'the not-hard-limits qualification'; the review's words: the table values "
            "are not uniform hard limits)",
            "Rule 3.07 as the introduction cites it: margins maintained against the table and presented at key "
            "decision point reviews, the used resource estimated / analyzed / analyzed or measured / measured by "
            "phase (v43 review: revision I's Rule 3.07 and Table 3.07-1 carry this margin description, and the "
            "revision I PDF shows Rule 3.07's revision status as H)",
            "the RAM row's bulk-memory note as II.A cites it: bulk memory is tracked apart from RAM unless it "
            "shares processor-card memory not distinguished from RAM or non-volatile memory, in which case the "
            "margins are tracked together (v43 review)",
        ],
        "confirmations": [
            {"review": "v30 manuscript review", "on": "2026-09-28",
             "covers": ["RAM margins 50% / 30%", "margin definition", "not hard limits"]},
            {"review": "v43 manuscript review", "on": "2026-10-04",
             "covers": ["Rule 3.07 margin description cited in the introduction (Rule 3.07 revision status H "
                        "in the revision I PDF)", "RAM description: bulk memory tracked apart unless it shares "
                        "undistinguished processor-card memory"],
             "locator": "Rule 3.07; Table 3.07-1 and its RAM description, printed pages 54-56"},
        ],
        "not_confirmed_here": "the wording that a shortfall is taken up with the rule's owner was confirmed for "
                              "revision H only (author, v27); from manuscript v44 it is not cited",
        "manuscript_status": "from manuscript v44 every GSFC citation is to revision I",
        "confirmed_by": "the v30 (2026-09-28) and v43 (2026-10-04) manuscript reviews supplied by the author, "
                        "both from the official PDF",
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


DEEPAE_LAYOUT_IR = "results/e36b_aarch64_models/b3_deepae/b3_deepae.layout_ir.txt"


def worked_extraction_deepae():
    """v0.74.2: the manuscript's worked extraction (III.C) re-derived from the archived AArch64 layout
    representation of the evaluated DeepAE specification, not from the specification's own fields."""
    text = open(os.path.join(REPO, DEEPAE_LAYOUT_IR)).read()
    chunks = re.split(r"^// -----// IR Dump After [^\n]*$", text, flags=re.M)[1:]
    entry = [c for c in chunks if "util.func public @infer" in c and "stream.cmd.execute" in c][-1]
    init = [c for c in chunks if "util.initializer" in c and "stream.resource.try_map" in c][-1]
    consts = {m.group(1): int(m.group(2)) for m in re.finditer(r"(%c[\w]+) = arith.constant (\d+) : index", entry)}
    size = lambda tok: consts.get(tok)
    imp = re.findall(r"stream\.tensor\.import .*?!stream\.resource<external>\{(%c\w+)\}", entry)
    ext = re.findall(r"stream\.resource\.alloca .*?!stream\.resource<external>\{(%c\w+)\}", entry)
    tra = re.findall(r"stream\.resource\.alloca .*?!stream\.resource<transient>\{(%c\w+)\}", entry)
    writes = [(size(o), size(n)) for o, n in
              re.findall(r"wo %arg\d+\[(%c\w+) for (%c\w+)\] : !stream\.resource<transient>", entry)]
    comp = re.findall(r"#util\.composite<(\d+)xi8", init)
    doc = json.load(open(os.path.join(REPO, AARCH64_DOC)))["resources"]
    t = size(tra[0]) if len(tra) == 1 else None
    return {
        "layout_ir": {"path": DEEPAE_LAYOUT_IR, "sha256": sha256(DEEPAE_LAYOUT_IR)},
        "document": AARCH64_DOC,
        "I_input_imports": [size(x) for x in imp],
        "O_external_allocas": [size(x) for x in ext],
        "T_transient_allocas": [size(x) for x in tra],
        "transient_writes": len(writes),
        "transient_write_bytes_total": sum(n for _, n in writes),
        "transient_write_offsets": sorted({o for o, _ in writes}),
        "writes_within_slab": t is not None and all(o + n <= t for o, n in writes),
        "C_packed_composites": [int(x) for x in comp],
        "constant_subviews_in_initializer": len(re.findall(r"stream\.resource\.subview %\S+\[", init)),
        "entry_subviews": len(re.findall(r"stream\.resource\.subview", entry)),
        "map_attempt_and_copy_branch": "stream.resource.try_map" in init and "scf.if %did_map" in init
                                       and "stream.resource.alloc " in init,
        "equals_document": {
            "I": [size(x) for x in imp] == [doc["static_external_input_bytes"]],
            "O": [size(x) for x in ext] == [doc["static_external_output_bytes"]],
            "T": [t] == [doc["static_transient_bytes"]],
            "C": [int(x) for x in comp] == [doc["module_resident_constant_bytes"]],
        },
        "note": "subview containment is checked by the analyzer only in the entry; the evaluated entries have "
                "none, and the constant subviews sit in the initialization region, where they allocate nothing",
    }


FIG_DOC = "results/e66_plugin_document_rules/docs/b2_resnet/b2_resnet.contract.json"
FIG_DOC_REISSUED = "results/e65_producer_check/reissued/b2_resnet/b2_resnet.contract.json"
FIG_HDR_REISSUED = "results/e65_producer_check/reissued/b2_resnet/contract_gen.b2_resnet.h"
FIG_HDR_E36B = "results/e36b_aarch64_models/b2_resnet/contract_gen.b2_resnet.h"
FIG_TREE = "results/e48_real_inputs_aarch64/cfs/trees/e48_b2_resnet"
FIG_LOGS = {"admitted": "results/e48_real_inputs_aarch64/cfs/logs/b2_resnet_admit_B_real.log",
            "refused": "results/e48_real_inputs_aarch64/cfs/logs/b2_resnet_deny_Bm1_real.log"}


def resnet_document_and_console():
    """v0.75.1: the manuscript's two ResNet figures (the evaluated document; the flight application's console
    at B_u and B_u - 1). Re-derives the facts the accompanying sentence states: both runs used one build,
    whose C header is byte-identical to the one issued for the shown document, and each budget came from the
    runtime override, not from the compiled-in default."""
    bi = json.load(open(os.path.join(REPO, FIG_TREE, "build_info.json")))
    man = json.load(open(os.path.join(REPO, FIG_TREE, "tree_manifest.json")))
    doc = json.load(open(os.path.join(REPO, FIG_DOC)))
    runs = {}
    for k, rel in FIG_LOGS.items():
        lines = open(os.path.join(REPO, rel)).read().splitlines()
        rec = lambda st: [json.loads(l) for l in lines if l.startswith('{"app":"AI_LEARNER","stage":"%s"' % st)]
        bc, adm = rec("build_config"), rec("admission")
        runs[k] = {"log": rel, "sha256": sha256(rel),
                   "build_config": bc[0] if len(bc) == 1 else None,
                   "verdict": adm[0]["verdict"] if len(adm) == 1 else None,
                   "budget": adm[0]["budget"] if len(adm) == 1 else None,
                   "budget_source": adm[0]["budget_source"] if len(adm) == 1 else None,
                   "runtime_records": sum(1 for st in ("binding", "map_branch", "mem_init", "mem") if rec(st))}
    bc = runs["admitted"]["build_config"]
    hdr = {"reissued": sha256(FIG_HDR_REISSUED), "e36b": sha256(FIG_HDR_E36B),
           "build_record": bi["contract_header"]["sha256"], "tree_manifest": man["contract_gen_h_sha256"]}
    return {
        "document": {"path": FIG_DOC, "sha256": sha256(FIG_DOC),
                     "byte_identical_to_reissued": sha256(FIG_DOC) == sha256(FIG_DOC_REISSUED)},
        "header_sha256": hdr,
        "header_identical_to_reissued": len(set(hdr.values())) == 1,
        "build_tree": {"path": FIG_TREE, "ai_learner_so_sha256": man["ai_learner_so_sha256"],
                       "compiled_budget_default": bi["app_knobs"]["AI_LEARNER_BUDGET_BYTES"],
                       "allow_conditional_map": bi["app_knobs"]["AI_LEARNER_ALLOW_CONDITIONAL_MAP"]},
        "runs": runs,
        "both_runs_same_compiled_in_specification": runs["refused"]["build_config"] == bc and bc is not None,
        "compiled_in_matches_document": bc is not None
            and bc.get("contract_bounded_bytes") == doc["resources"]["bounded_bytes"]
            and bc.get("contract_per_call_bytes") == doc["resources"]["static_per_call_bytes"]
            and bc.get("contract_const_bytes") == doc["resources"]["module_resident_constant_bytes"]
            and bc.get("contract_artifact_sha256") == doc["artifact"]["sha256"],
        "budgets_from_override": all(r["budget_source"] == "override" for r in runs.values())
            and {r["budget"] for r in runs.values()} == {doc["resources"]["bounded_bytes"],
                                                         doc["resources"]["bounded_bytes"] - 1}
            and bi["app_knobs"]["AI_LEARNER_BUDGET_BYTES"] not in {r["budget"] for r in runs.values()},
        "note": "the figures rename the implementation's identifier prefix to the paper's term; values are the "
                "logs' own. The single-build statement rests on the archived build record and on the two logs "
                "carrying identical compiled-in records; the guest did not hash the binary in these runs.",
    }


# v0.75.2 -- two facts added to the manuscript (v38) in answer to a referee. Both are re-derived from
# archived guest logs every run; nothing here is taken from the manuscript.

# (a) Earlier flight-application builds read the module into malloc() without an alignment request
# (ai_learner.c up to c086593, which introduced posix_memalign(64) and the map_branch record).
EARLY_BUILD_SOURCES = {"77a2df1": "g.blob = g.blob_len > 0 ? malloc((size_t)g.blob_len) : NULL;",
                       "e4c6371": "g.blob = malloc((size_t)g.blob_len);"}
EARLY_ALIGNED_COMMIT = "c086593"
EARLY_GUEST_CELLS = [  # (log, specification, source commit of the application build)
    ("results/e14_aarch64_qemu/cfs/logs/A1_conv2d.log",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.conv2d.aarch64.json", "77a2df1"),
    ("results/e14_aarch64_qemu/cfs/logs/A1_multibranch.log",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.multibranch.aarch64.json", "77a2df1"),
    ("results/e14_aarch64_qemu/cfs/logs/A6_mlp16k_repeat.log",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.mlp16k.aarch64.json", "77a2df1"),
    ("results/e14_aarch64_qemu/cfs/logs/A7_mlp16k_restart.log",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.mlp16k.aarch64.json", "77a2df1"),
    ("results/e26_boundary_utility/aarch64/cfs/canonical_B.log",
     "results/e25_equivalence/aarch64/model_canonical.aarch64.contract.json", "e4c6371"),
    ("results/e26_boundary_utility/aarch64/cfs/canonical_Bp1.log",
     "results/e25_equivalence/aarch64/model_canonical.aarch64.contract.json", "e4c6371"),
]
# The same malloc-era code run as the standalone runner under user-mode emulation (not the flight
# application, not the system guest). Recorded so the record shows the arm depended on placement.
EARLY_USER_MODE_GLOBS = ["results/e14_aarch64_qemu/native/logs/qemu_user/*.log",
                         "results/e26_boundary_utility/aarch64/native/*.jsonl"]


def _app_records(rel):
    out = []
    for line in open(os.path.join(REPO, rel), errors="replace"):
        j = line.find('{"app":"AI_LEARNER"')
        if j >= 0:
            try:
                out.append(json.loads(line[j:].strip()))
            except ValueError:
                pass  # a record cut by the console line buffer: not used here
    return out


def _figures(spec_rel):
    r = json.load(open(os.path.join(REPO, spec_rel)))["resources"]
    fig = {"I": r["static_external_input_bytes"], "O": r["static_external_output_bytes"],
           "T": r["static_transient_bytes"], "P": r["static_per_call_bytes"],
           "C": r["module_resident_constant_bytes"], "B_u": r["bounded_bytes"]}
    assert fig["I"] + fig["O"] + fig["T"] == fig["P"] and fig["P"] + fig["C"] == fig["B_u"]
    return fig


def earlier_build_copy_arm():
    cells = []
    for log, spec, src in EARLY_GUEST_CELLS:
        recs = _app_records(log)
        fig = _figures(spec)
        peaks = [r["hal_peak"] for r in recs if r.get("stage") == "mem"]
        inits = [r for r in recs if r.get("stage") == "mem_init"]
        cells.append({
            "log": log, "sha256": sha256(log), "specification": spec, "application_source": src,
            "model": next((r.get("model") for r in recs if r.get("model")), None),
            "target": sorted({r["target"] for r in recs if r.get("target")}),
            "admissions": [r.get("verdict") for r in recs if r.get("stage") == "admission"],
            "figures": fig, "mem_peaks": peaks,
            "all_peaks_equal_B_u": bool(peaks) and all(p == fig["B_u"] for p in peaks),
            "C_positive": fig["C"] > 0,
            "mem_init_equals_I_plus_C": [r.get("hal_allocated") == fig["I"] + fig["C"] for r in inits],
            "address_recorded": any(r.get("stage") == "map_branch" for r in recs),
        })
    user_mode = []
    for pat in EARLY_USER_MODE_GLOBS:
        for fp in sorted(glob.glob(os.path.join(REPO, pat))):
            text = open(fp, errors="replace").read()
            m = re.search(r'"model":"([a-z0-9_]+)"', text)
            peaks = [int(x) for x in re.findall(r'"(?:hal_device_bytes_peak|device_bytes_peak|hal_peak)":(\d+)', text)]
            per = re.search(r'"per_call":(\d+)', text)
            bnd = re.search(r'"bounded(?:_bytes)?":(\d+)', text)
            if not (m and peaks and per and bnd):
                continue
            pk, p, b = max(peaks), int(per.group(1)), int(bnd.group(1))
            user_mode.append({"log": os.path.relpath(fp, REPO), "model": m.group(1), "peak": pk,
                              "arm": "map" if pk == p else ("copy" if pk == b else "other")})
    arms = [c["all_peaks_equal_B_u"] and c["C_positive"] for c in cells]
    return {
        "claim": "earlier flight-application builds that read the artifact with malloc and no alignment "
                 "request peaked at exactly B_u in every archived development-model guest cell that "
                 "recorded a peak; the image address was not recorded",
        "application_sources": EARLY_BUILD_SOURCES,
        "aligned_allocation_introduced_in": EARLY_ALIGNED_COMMIT,
        "guest_cells": cells,
        "guest_cells_count": len(cells),
        "guest_cells_peak_B_u": sum(arms),
        "guest_models": sorted({c["model"] for c in cells}),
        "address_recorded_in_any": any(c["address_recorded"] for c in cells),
        "user_mode_runner_cells": user_mode,
        "user_mode_arm_counts": {a: sum(1 for u in user_mode if u["arm"] == a) for a in ("map", "copy", "other")},
        "note": "the arm is inferred from peak == P + C with C > 0; the malloc-era builds did not record the "
                "module image address. The standalone runner under user-mode emulation, with the same "
                "malloc-era code, took the map arm in some cells: the arm followed where the buffer landed. "
                "None of these cells uses one of the four public models.",
    }


# (b) The allocator's cumulative allocation in the manuscript's admitted flight-application cells.
def _e66_cells():
    sys.path.insert(0, os.path.join(REPO, "harness"))
    import e66_plugin_document_rules as e66
    return e66, [p for v in e66.EXECUTION.values() for p in v] + list(e66.ALIGNMENT)


def cumulative_allocation_identity():
    e66, cells = _e66_cells()
    rows, figs = [], {}
    tot = {"cells": 0, "init_identity": 0, "logs_with_call_reports": 0, "call_reports": 0,
           "call_reports_matching": 0, "call_reports_exact_integer": 0, "replay_calls": 0, "max_slack_bytes": 0}
    for p in cells:
        fp = e66.resolve(p)
        rel = os.path.relpath(fp, REPO)
        recs = _app_records(rel)
        model = next(r["model"] for r in recs if r.get("stage") == "mem_init")
        if model not in figs:
            figs[model] = _figures(SPEC_BY_MODEL[model])
        f = figs[model]
        init = next(r for r in recs if r.get("stage") == "mem_init")
        mb = next(r for r in recs if r.get("stage") == "map_branch")
        arm = "map" if mb["hal_peak_after_append"] == 0 else ("copy" if mb["hal_peak_after_append"] == f["C"] else "other")
        base = f["I"] + (f["C"] if arm == "copy" else 0)
        replay = sum(r.get("completed", 0) for r in recs if r.get("stage") == "e25_equivalence")
        reports = []
        for r in recs:
            if r.get("stage") != "mem":
                continue
            n, am = r["completed"], r["hal_bytes_per_call_amortized"]
            exp = base + (replay + n) * (f["O"] + f["T"])
            shown = "%.1f" % am
            ints = [c for c in range(int(n * (am - 0.06)) - 2, int(n * (am + 0.06)) + 3) if "%.1f" % (c / n) == shown]
            reports.append({"n": n, "match": "%.1f" % (exp / n) == shown, "exact": len(ints) == 1,
                            "slack": max(abs(c - exp) for c in ints) if ints else None})
        ok_init = init["hal_allocated"] == base
        tot["cells"] += 1
        tot["init_identity"] += ok_init
        tot["logs_with_call_reports"] += bool(reports)
        tot["call_reports"] += len(reports)
        tot["call_reports_matching"] += sum(x["match"] for x in reports)
        tot["call_reports_exact_integer"] += sum(x["exact"] for x in reports)
        tot["replay_calls"] += replay
        tot["max_slack_bytes"] = max([tot["max_slack_bytes"]] + [x["slack"] for x in reports if x["slack"] is not None])
        rows.append({"log": rel, "model": model, "arm": arm, "init_allocated": init["hal_allocated"],
                     "expected_init": base, "replay_calls": replay, "call_reports": len(reports),
                     "call_reports_matching": sum(x["match"] for x in reports)})
    return {
        "claim": "in the admitted flight-application cells the manuscript counts (execution and alignment cells), "
                 "the allocator's cumulative allocated bytes were I (I + C on the copy arm) before the first call "
                 "and, at each report, that plus (O + T) per completed call (replay calls included), within the "
                 "resolution of the logged one-decimal average; a byte total, not a buffer-by-buffer match",
        "cell_lists": "harness/e66_plugin_document_rules.py EXECUTION + ALIGNMENT",
        "field": "mem.hal_bytes_per_call_amortized = device_bytes_allocated / loop calls (ai_learner.c), "
                 "printed %.1f; mem_init.hal_allocated is an exact integer",
        "totals": tot,
        "cells": rows,
    }


DECIMAL_CAPACITY_BYTES = {"PA": 4 * 10**9, "PB": 10**9}  # the published "4 GB" and "1 GB" read as decimal


def reference_profiles_decimal_reading():
    """The reference profiles take the published 4 GB and 1 GB as 4 GiB and 1 GiB (budgets.json
    R_physical_bytes). Re-derive every profile budget from its own terms, confirm it reproduces the archived
    figure, then repeat with the published capacity read as decimal bytes and compare the verdicts."""
    b = json.load(open(os.path.join(REPO, BUDGETS)))
    rows, reproduced, unchanged = [], 0, 0
    for c in b["cells"]:
        prof, mod = b["profiles"][c["budget_profile_id"]], b["models"][c["model"]]
        rest = (prof["R_OS_cFS_bytes"] + prof["R_other_apps_bytes"] + prof["R_reserved_bytes"]
                + mod["R_noncontract_AI_bytes"])
        mu = prof["margin_fraction"]
        b_bin = math.floor(prof["R_physical_bytes"] * (1 - mu)) - rest
        b_dec = math.floor(DECIMAL_CAPACITY_BYTES[prof["platform"]] * (1 - mu)) - rest
        u = c["U_bounded_bytes"]
        v_bin = "ADMIT" if u <= b_bin else "NOT_ADMITTED"
        v_dec = "ADMIT" if u <= b_dec else "NOT_ADMITTED"
        reproduced += b_bin == c["B_contract_bytes"]
        unchanged += v_bin == v_dec == c["predicted_verdict"]
        rows.append({"cell": c["cell_id"], "budget_binary": b_bin, "budget_decimal": b_dec,
                     "headroom_decimal": b_dec - u, "verdict_binary": v_bin, "verdict_decimal": v_dec})
    low = min(rows, key=lambda r: r["headroom_decimal"])
    return {
        "claim": "the reference profiles read the published 4 GB and 1 GB as 4 GiB and 1 GiB, a scenario "
                 "assumption; read as decimal bytes instead, no profile verdict changes",
        "source": BUDGETS,
        "binary_capacity_bytes": {k: v["r_physical_bytes"] for k, v in b["platforms"].items()},
        "decimal_capacity_bytes": DECIMAL_CAPACITY_BYTES,
        "cells": len(rows),
        "archived_budgets_reproduced": reproduced,
        "verdicts_unchanged": unchanged,
        "smallest_decimal_headroom": {"cell": low["cell"], "bytes": low["headroom_decimal"]},
        "rows": rows,
    }


# v0.75.4 -- the manuscript (Sec. V.E) bounds the operating-system layer's addition to a configured task stack
# by 135,152 B with 4 KiB pages. OSAL's POSIX OS_TaskCreate adds OS_IMPL_STACK_EXTRA -- PTHREAD_STACK_MIN when the
# platform defines it -- and rounds up to the page size. The AArch64 build compiles that file with
# -D_XOPEN_SOURCE=600 -std=c99 (no _GNU_SOURCE), so PTHREAD_STACK_MIN is the cross toolchain header's constant,
# not glibc's dynamic sysconf form. These are recorded with where they were read (the cFS checkout and the cross
# toolchain are not in the repository); the guard re-reads them when this container has them, and the
# arithmetic below runs from repository files only, so the record is the same everywhere.
OSAL_TASK_STACK = {
    "source": "osal/src/os/posix/src/os-impl-tasks.c",
    "osal_commit": "8111e4a5cc0bef109540ef648d00924032882452",
    "source_sha256": "76497fefbb4443a30ba83b1259454befd78861f5d7c94c9337caf114107089d2",
    "lines": {"58": "#ifdef PTHREAD_STACK_MIN",
              "59": "#define OS_IMPL_STACK_EXTRA PTHREAD_STACK_MIN",
              "501": "stacksz += OS_IMPL_STACK_EXTRA;",
              "503": "stacksz += POSIX_GlobalVars.PageSize - 1;",
              "504": "stacksz -= stacksz % POSIX_GlobalVars.PageSize;"},
    "aarch64_compile_flags": ["-DSIMULATION=aarch64-linux-gnu", "-D_LINUX_OS_", "-D_POSIX_OS_",
                              "-D_XOPEN_SOURCE=600", "-std=c99"],
    "pthread_stack_min_header": "/usr/aarch64-linux-gnu/include/bits/pthread_stack_min.h",
    "pthread_stack_min_header_sha256": "6f9e3fe35ad8c096a032cce93ae485085ab47d9ca784c6e3d8ca8c422c8c60ac",
    "pthread_stack_min": 131072,
    "page_bytes": 4096,
    "page_note": "the manuscript states the 4 KiB-page condition with the figure",
}
STACK_BUILD_RECORDS = {
    "b2_resnet": "results/e55b_copy_path/trees/e55b_b2_resnet_copy/build_info.json",
    "b3_deepae": "results/e55b_copy_path/trees/e55b_b3_deepae_copy/build_info.json",
    "smartcam": "results/e55b_copy_path/trees/e55b_smartcam_copy/build_info.json",
    "wgan": "results/e55b_copy_path/trees/e55b_wgan_copy/build_info.json",
}


def os_task_stack_addition():
    """Configured task stack per model (base allowance + dispatch requirement, the R_x terms of budgets.json),
    checked against the startup-script stack each evaluation build recorded, then OSAL's addition: plus
    PTHREAD_STACK_MIN, rounded up to the page. The manuscript cites the largest addition beyond R_x."""
    b = json.load(open(os.path.join(REPO, BUDGETS)))
    rows = []
    for m in sorted(b["models"]):
        t = b["models"][m]["R_noncontract_AI_terms"]
        configured = t["task_stack_base_bytes"] + t["task_stack_kernel_bytes"]
        built = json.load(open(os.path.join(REPO, STACK_BUILD_RECORDS[m])))["task_stack"]
        osal = configured + OSAL_TASK_STACK["pthread_stack_min"]
        osal += OSAL_TASK_STACK["page_bytes"] - 1
        osal -= osal % OSAL_TASK_STACK["page_bytes"]
        rows.append({"model": m, "configured_bytes": configured,
                     "startup_script_stack_bytes": built["startup_script_stack_bytes"],
                     "configured_matches_build": configured == built["startup_script_stack_bytes"],
                     "pthread_stacksize_bytes": osal, "addition_bytes": osal - configured})
    top = max(rows, key=lambda r: r["addition_bytes"])
    return {
        "claim": "by its source code, the operating-system layer adds its minimum thread stack to the configured "
                 "task-stack size and rounds up to a page; with 4 KiB pages the addition beyond R_x is at most "
                 "135,152 B",
        "osal": OSAL_TASK_STACK,
        "configured_from": BUDGETS + " models.*.R_noncontract_AI_terms (task_stack_base_bytes + "
                                     "task_stack_kernel_bytes)",
        "build_records": STACK_BUILD_RECORDS,
        "rows": rows,
        "max_addition": {"model": top["model"], "bytes": top["addition_bytes"]},
    }


SPEC_BY_MODEL = {"b2_resnet": "results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json",
                 "b3_deepae": "results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json",
                 "smartcam": "results/e32_smartcam_aarch64/build/smartcam.contract.json",
                 "wgan": "results/e53_wgan_aarch64/build/aarch64/wgan.contract.json"}


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
        "worked_extraction_deepae": worked_extraction_deepae(),
        "resnet_document_and_console": resnet_document_and_console(),
        "earlier_build_copy_arm": earlier_build_copy_arm(),
        "cumulative_allocation_identity": cumulative_allocation_identity(),
        "reference_profiles_decimal_reading": reference_profiles_decimal_reading(),
        "os_task_stack_addition": os_task_stack_addition(),
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
