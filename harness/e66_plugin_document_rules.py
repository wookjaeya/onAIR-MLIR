#!/usr/bin/env python3
"""E66: the OnAIR plugin's specification-document rules and budget check, aligned with the cFS path.

Plan: docs/plans/E66_plugin_document_rules.md (committed before any implementation or cell, ae115f3).

  prepare  Build results/e66_plugin_document_rules/docs/: each re-issued evaluated document (E65, byte copy)
           next to a relative symlink to the artifact it binds; the earlier-revision ResNet document and
           artifact; and one document the analyzer issued under an override flag (E64's A6 edit of the
           archived AArch64 ResNet representation, --allow-structural-mismatch). Writes docs/manifest.json.
  ground   Ground-side questions, all without the guest:
           Q1 parity -- the header generator's default verdict (rc 0 = accepted) against the plugin's
              check_document_acceptance() on the document set F of the plan;
           Q2 budget -- check_budget_option() on the plan's cases, and every committed deployment;
           Q5 corpus -- unclassified resource operations in the two-output AArch64 representation (E65);
           Q6 vCPU   -- (model, CPUs cFS reported, final HAL peak) read from the archived guest logs of the
              evaluated cells: is each model's map-arm peak the same across sessions with different CPUs?
           Q7 inventory -- the flight-software cell counts the manuscript's evidence summary states,
              recounted from the raw logs (Q6 and Q7 are records for the manuscript, not verdicts).

Nothing here runs a model. The guest cells (Q3, Q4) are summarized by harness/mk_e66_summary.py.
"""
import argparse
import copy
import glob
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(ROOT, "plugins", "compiled_learner"))
import artifact_binding as ab                                      # noqa: E402
import mk_e36_summary as m36                                       # noqa: E402  (the app's own records, D68)

PY = sys.executable
PLAN = "docs/plans/E66_plugin_document_rules.md (committed before any implementation or cell, ae115f3)"
OUT = os.path.join(ROOT, "results", "e66_plugin_document_rules")
DOCS = os.path.join(OUT, "docs")

# the evaluated AArch64 artifacts and the directories their archived (pre-E65) documents live in
MODELS = {
    "b2_resnet": "results/e36b_aarch64_models/b2_resnet",
    "b3_deepae": "results/e36b_aarch64_models/b3_deepae",
    "smartcam": "results/e32_smartcam_aarch64/build",
    "wgan": "results/e53_wgan_aarch64/build/aarch64",
}
REISSUED = "results/e65_producer_check/reissued"
EARLIER = "results/e65_producer_check/drift_310_reanalyzed"
EARLIER_VMFB = "results/e59_info_levels_aarch64/drift_310/b2_resnet/b2_resnet.vmfb"
P = {"b2_resnet": 309416, "b3_deepae": 6208, "smartcam": 9382092, "wgan": 131382784}
C = {"b2_resnet": 309440, "b3_deepae": 1063424, "smartcam": 8840704, "wgan": 4283648}


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def rel(p):
    return os.path.relpath(p, ROOT)


def dump_json(doc, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, sort_keys=True)
        f.write("\n")


def place(dst_dir, doc_src, vmfb_src, doc_name):
    """Copy the document byte for byte and point a RELATIVE symlink at the artifact it binds."""
    os.makedirs(dst_dir, exist_ok=True)
    shutil.copyfile(os.path.join(ROOT, doc_src), os.path.join(dst_dir, doc_name))
    doc = json.load(open(os.path.join(dst_dir, doc_name), encoding="utf-8"))
    link = os.path.join(dst_dir, doc["artifact"]["file"])
    if os.path.lexists(link):
        os.unlink(link)
    os.symlink(os.path.relpath(os.path.join(ROOT, vmfb_src), dst_dir), link)
    target_sha = sha256_file(link)
    return {"dir": rel(dst_dir), "document": doc_name, "document_source": doc_src,
            "document_sha256": sha256_file(os.path.join(dst_dir, doc_name)),
            "document_byte_identical_to_source": sha256_file(os.path.join(dst_dir, doc_name))
            == sha256_file(os.path.join(ROOT, doc_src)),
            "artifact_link": doc["artifact"]["file"], "artifact_link_target": os.readlink(link),
            "artifact_sha256": target_sha, "artifact_sha256_matches_document": target_sha == doc["artifact"]["sha256"],
            "bound_method": doc["resources"].get("bound_method"),
            "producer_check_state": (doc.get("validity") or {}).get("producer_check", {}).get("state"),
            "verification_grade": (doc.get("provenance") or {}).get("verification_grade"),
            "overrides_applied": (doc.get("provenance") or {}).get("overrides_applied")}


def cmd_prepare(_a):
    entries = {}
    for m, adir in MODELS.items():
        entries[m] = place(os.path.join(DOCS, m), "%s/%s/%s.contract.json" % (REISSUED, m, m),
                           "%s/%s.vmfb" % (adir, m), "%s.contract.json" % m)
    entries["b2_resnet_earlier_revision"] = place(
        os.path.join(DOCS, "b2_resnet_earlier_revision"), "%s/b2_resnet/b2_resnet.contract.json" % EARLIER,
        EARLIER_VMFB, "b2_resnet.contract.json")
    # a document the analyzer ISSUED under an override flag -- the realistic path, not a hand edit of the
    # document: E64's A6 edit (a staging-lifetime allocation neither extractor attributes) makes the two
    # extractors disagree, and --allow-structural-mismatch issues anyway and records the waiver
    import e51_precondition_trace as e51                           # the same insertion rule as E51/E64
    import e64_aarch64_evidence as e64
    od = os.path.join(DOCS, "b2_resnet_override")
    os.makedirs(od, exist_ok=True)
    src_ir = os.path.join(ROOT, MODELS["b2_resnet"], "b2_resnet.layout_ir.txt")
    a6 = [p for p in e64.PROBES if p["id"] == "A6_other_lifetime_category"][0]
    edited = e51.mutate(open(src_ir, encoding="utf-8").read(), a6["inject"])
    ir_path = os.path.join(od, "b2_resnet.a6.layout_ir.txt")
    open(ir_path, "w", encoding="utf-8").write(edited)
    d = MODELS["b2_resnet"]
    con = os.path.join(od, "b2_resnet.contract.json")
    base = [PY, os.path.join(HERE, "make_contract.py"), "--mlir", d + "/b2_resnet.mlir", "--vmfb", d + "/b2_resnet.vmfb",
            "--layout-ir", rel(ir_path), "--dump-dir", d + "/dump", "--triple", "aarch64-unknown-linux-gnu",
            "--cpu", "cortex-a53", "--model-name", "b2_resnet", "--elf-analysis", d + "/b2_resnet.elf.json"]
    tmp = tempfile.mkdtemp(prefix="e66_noflag_")
    noflag = subprocess.run(base + ["--out", os.path.join(tmp, "x.json")], cwd=ROOT, capture_output=True, text=True)
    r = subprocess.run(base + ["--allow-structural-mismatch", "--out", rel(con)], cwd=ROOT, capture_output=True, text=True)
    shutil.rmtree(tmp, ignore_errors=True)
    link = os.path.join(od, "b2_resnet.vmfb")
    if os.path.lexists(link):
        os.unlink(link)
    os.symlink(os.path.relpath(os.path.join(ROOT, d, "b2_resnet.vmfb"), od), link)
    doc = json.load(open(con, encoding="utf-8"))
    entries["b2_resnet_override"] = {
        "dir": rel(od), "document": "b2_resnet.contract.json", "edited_layout_ir": rel(ir_path),
        "edited_layout_ir_sha256": sha256_file(ir_path), "edit": a6["inject"].strip(), "edit_source": "E64 probe A6",
        "without_flag_rc": noflag.returncode, "without_flag_stderr_tail": (noflag.stderr or "").strip().splitlines()[-1:],
        "with_flag_rc": r.returncode, "artifact_link": "b2_resnet.vmfb", "artifact_link_target": os.readlink(link),
        "artifact_sha256_matches_document": sha256_file(link) == doc["artifact"]["sha256"],
        "bound_method": doc["resources"].get("bound_method"), "bounded_bytes": doc["resources"].get("bounded_bytes"),
        "producer_check_state": doc["validity"].get("producer_check", {}).get("state"),
        "verification_grade": doc["provenance"].get("verification_grade"),
        "overrides_applied": doc["provenance"].get("overrides_applied")}
    dump_json({"experiment": "E66", "plan": PLAN, "entries": entries}, os.path.join(DOCS, "manifest.json"))
    print(json.dumps({k: {x: v.get(x) for x in ("bound_method", "producer_check_state", "verification_grade",
                                                "overrides_applied")} for k, v in entries.items()}, indent=1))


# --------------------------------------------------------------------------- #
# Q1 parity
# --------------------------------------------------------------------------- #
def generator_verdict(doc_path, flags=()):
    with tempfile.TemporaryDirectory(prefix="e66_hdr_") as w:
        r = subprocess.run([PY, os.path.join(HERE, "gen_contract_header.py"), doc_path, os.path.join(w, "h.h")]
                           + list(flags), cwd=ROOT, capture_output=True, text=True)
    tail = [l for l in (r.stderr or "").strip().splitlines() if l.strip()][-1:]
    return {"rc": r.returncode, "accepted": r.returncode == 0, "stderr_tail": [t[:240] for t in tail]}


def plugin_verdict(doc, allow):
    try:
        res = ab.check_document_acceptance(doc, allow)
        return {"accepted": True, "waived": res["waived"], "reason": None}
    except ab.DocumentNotAccepted as e:
        return {"accepted": False, "waived": [], "reason": str(e)[:240]}
    except Exception as e:  # noqa: BLE001 -- a crashing rule is a disagreement, not a dead suite (E26b)
        return {"accepted": None, "waived": [], "reason": "crash:%s: %s" % (type(e).__name__, str(e)[:200])}


def parity_set():
    """(case id, document path or None, document dict transform, waiver, provenance of the case)."""
    cases = []
    for m in MODELS:
        cases.append(("reissued_" + m, "%s/%s/%s.contract.json" % (REISSUED, m, m), None, False, "analyzer (E65 re-issue)"))
    for m, adir in MODELS.items():
        cases.append(("archived_" + m, "%s/%s.contract.json" % (adir, m), None, False, "analyzer (before E65)"))
    for m, adir in MODELS.items():
        cases.append(("archived_waived_" + m, "%s/%s.contract.json" % (adir, m), None, True, "analyzer (before E65)"))
    for m in MODELS:
        cases.append(("earlier_revision_" + m, "%s/%s/%s.contract.json" % (EARLIER, m, m), None, False,
                      "analyzer (earlier-revision artifact)"))
    cases.append(("override_b2_resnet", rel(os.path.join(DOCS, "b2_resnet_override", "b2_resnet.contract.json")),
                  None, False, "analyzer (--allow-structural-mismatch)"))
    base = "%s/b2_resnet/b2_resnet.contract.json" % REISSUED

    def grade_only(d):
        d["provenance"]["verification_grade"] = "overridden"
        return d

    def not_single(d):
        d["provenance"]["single_invocation"] = False
        return d

    def no_prov_no_pc(d):
        d.pop("provenance", None)
        d["validity"].pop("producer_check", None)
        return d

    def unknown_method(d):
        d["resources"]["bound_method"] = "static_from_elsewhere"
        return d
    for name, fn in (("variant_grade_only", grade_only), ("variant_single_invocation_false", not_single),
                     ("variant_no_provenance_no_producer_check", no_prov_no_pc),
                     ("variant_unrecognized_bound_method", unknown_method)):
        cases.append((name, base, fn, False, "hand-edited variant of the re-issued ResNet document (unit case)"))
    return cases


def q1_parity():
    import gen_contract_header as gch                                 # module import; main() is guarded
    rows = []
    with tempfile.TemporaryDirectory(prefix="e66_par_") as w:
        for cid, path, fn, allow, origin in parity_set():
            doc = json.load(open(os.path.join(ROOT, path), encoding="utf-8"))
            use = path
            if fn is not None:
                doc = fn(copy.deepcopy(doc))
                use = os.path.join(w, cid + ".json")
                json.dump(doc, open(use, "w"))
            g = generator_verdict(os.path.join(ROOT, use) if not os.path.isabs(use) else use,
                                  ["--allow-unchecked-producer"] if allow else [])
            p = plugin_verdict(doc, allow)
            rows.append({"case": cid, "document": path, "transform": fn.__name__ if fn else None, "origin": origin,
                         "waiver": allow, "generator": g, "plugin": p, "agree": g["accepted"] == p["accepted"]})
    wl_equal = set(gch.BOUND_METHOD_WHITELIST) == set(ab.BOUND_METHODS)
    return {"cases": rows, "n": len(rows), "disagreements": [r["case"] for r in rows if not r["agree"]],
            "accepted": [r["case"] for r in rows if r["plugin"]["accepted"]],
            "bound_method_sets_equal": wl_equal,
            "pass": wl_equal and all(r["agree"] for r in rows) and len(rows) == 21}


# --------------------------------------------------------------------------- #
# Q2 budget
# --------------------------------------------------------------------------- #
BUDGET_CASES = [("absent", None, "none"), ("null", "__null__", "none"), ("one", 1, 1), ("resnet_Bu", 618856, 618856),
                ("zero", 0, "refuse"), ("negative", -1, "refuse"), ("true", True, "refuse"), ("false", False, "refuse"),
                ("string", "618856", "refuse"), ("float", 618856.9, "refuse"), ("list", [], "refuse")]


def q2_budget():
    rows = []
    for cid, val, exp in BUDGET_CASES:
        dep = {} if val is None else {"budget_bytes": None if val == "__null__" else val}
        try:
            got = ab.check_budget_option(dep)
            got = "none" if got is None else got
        except ab.ConfigurationError:
            got = "refuse"
        except Exception as e:  # noqa: BLE001 -- an implementation that crashes is a FAIL, not a dead suite (E26b)
            got = "crash:%s" % type(e).__name__
        rows.append({"case": cid, "value": repr(dep.get("budget_bytes", "<absent>")), "expected": exp, "got": got,
                     "ok": got == exp})
    # every committed deployment, against what it is meant to get: accepted, unless the deployment itself
    # declares an expected refusal (E66's R4 cell). A refusal nobody declared is an over-refusal (type B).
    deps = []
    for f in sorted(glob.glob(os.path.join(ROOT, "configs", "deployments", "*.json"))):
        for k, v in json.load(open(f, encoding="utf-8"))["deployments"].items():
            expected = (v.get("_e66_expected") or {}).get("budget", "accepted")
            try:
                ab.check_budget_option(v)
                got = "accepted"
            except ab.ConfigurationError:
                got = "refused"
            except Exception as e:  # noqa: BLE001
                got = "crash:%s" % type(e).__name__
            deps.append({"config": rel(f), "deployment": k, "expected": expected, "got": got})
    mism = [d for d in deps if d["got"] != d["expected"]]
    return {"cases": rows, "committed_deployments_checked": len(deps),
            "committed_deployments_expected_refused": [d["deployment"] for d in deps if d["expected"] == "refused"],
            "committed_deployments_mismatched": mism,
            "pass": all(r["ok"] for r in rows) and not mism and len(deps) > 0}


def committed_documents():
    """Every compiled-learner deployment's document, with its own waiver setting: nothing committed is refused."""
    out = []
    for f in sorted(glob.glob(os.path.join(ROOT, "configs", "deployments", "*.json"))):
        cfg_dir = os.path.dirname(f)
        for k, v in json.load(open(f, encoding="utf-8"))["deployments"].items():
            ad = v.get("artifact_dir")
            if not ad or v.get("model_file"):
                continue
            p = ad if os.path.isabs(ad) else os.path.normpath(os.path.join(cfg_dir, ad))
            doc = json.load(open(os.path.join(p, v.get("contract_file", "contract.json")), encoding="utf-8"))
            expected = (v.get("_e66_expected") or {}).get("document", "accepted")
            try:
                allow = ab.check_unchecked_producer_option(v)
                res = ab.check_document_acceptance(doc, allow)
                out.append({"config": rel(f), "deployment": k, "accepted": True, "waived": res["waived"],
                            "pinned": "_e66_pin" in v, "expected": expected})
            except ab.ConfigurationError as e:
                out.append({"config": rel(f), "deployment": k, "accepted": False, "reason": str(e)[:200],
                            "pinned": "_e66_pin" in v, "expected": expected})
            except Exception as e:  # noqa: BLE001 -- a crash is neither verdict (E26b): never as expected
                out.append({"config": rel(f), "deployment": k, "accepted": None,
                            "reason": "crash:%s: %s" % (type(e).__name__, str(e)[:160]),
                            "pinned": "_e66_pin" in v, "expected": expected})
    for d in out:
        d["as_expected"] = ((d["accepted"] is True and d["expected"] == "accepted")
                            or (d["accepted"] is False and d["expected"] == "refused"))
    return out


# --------------------------------------------------------------------------- #
# Q5 corpus
# --------------------------------------------------------------------------- #
def q5_corpus():
    import mlir_alloc_walk as maw
    p = os.path.join(ROOT, "results", "e65_producer_check", "multiout_aarch64", "multiout.layout_ir.txt")
    w = maw.parse_alloc_ir_structural(open(p, encoding="utf-8").read(), "infer")
    e64 = json.load(open(os.path.join(ROOT, "results", "e64_aarch64_evidence", "corpus.json"), encoding="utf-8"))
    b1 = e64["B1_aarch64_corpus"]
    uncls = sorted(set(w.get("unclassified_resource_ops") or []))
    return {"representation": rel(p), "sha256": sha256_file(p),
            "unclassified_resource_ops": uncls,
            "unsupported_control_ops": sorted(set(w.get("unsupported_control_ops") or [])),
            "pre_scheduling_ops": sorted(set(w.get("pre_scheduling_ops") or [])),
            "e64_corpus_cited": {"count": b1["aarch64_evaluated_revision_unedited_count"],
                                 "unclassified_total": b1["aarch64_unclassified_total"],
                                 "record": "results/e64_aarch64_evidence/corpus.json"},
            "e64_directory_list_note": ("E64 enumerates AArch64 representations by an explicit directory list "
                                        "(AARCH64_COMPILE_DIRS); E65's multiout_aarch64 directory is not in it, so the "
                                        "twelfth representation is counted here, not by re-running E64"),
            "total_representations": b1["aarch64_evaluated_revision_unedited_count"] + 1,
            "total_unclassified": b1["aarch64_unclassified_total"] + len(uncls),
            "pass": not uncls and b1["aarch64_unclassified_total"] == 0}


# --------------------------------------------------------------------------- #
# Q6 / Q7 from archived guest logs
# --------------------------------------------------------------------------- #
R = "results/"
EXECUTION = {
    "at_B_u": [R + "e48_real_inputs_aarch64/cfs/logs/%s_admit_B_real.log" % m for m in ("b2_resnet", "b3_deepae", "smartcam")]
    + [R + "e53_wgan_aarch64/cfs/logs/cfs_B.log",
       R + "e63_single_build_and_conditional_floor/cells/logs/e63_wgan_map_e55b_build.log"],
    "copy_arm": [R + "e55b_copy_path/cells/logs/e55b_%s_copy.log" % m for m in MODELS],
    "conditional": [R + "e55_mandatory_followups/cells/logs/e55_%s_conditional.log" % m for m in MODELS]
    + [R + "e56_conditional_refusal_aarch64/cells/logs/e56_%s_admit.log" % m for m in MODELS],
    "reference_profiles": [R + "e54_reference_budget/cells/logs/%s__%s.log" % (pf, m)
                           for pf in ("PA_pdr50", "PA_ship30", "PB_pdr50", "PB_ship30") for m in MODELS],
    "sensitivity_above": [R + "e54_reference_budget/cells/logs/sweep_%s_pow2_above.log" % m for m in MODELS],
}
REFUSAL = {
    "B_u_minus_1": [R + "e48_real_inputs_aarch64/cfs/logs/%s_deny_Bm1_real.log" % m for m in ("b2_resnet", "b3_deepae", "smartcam")]
    + [R + "e53_wgan_aarch64/cfs/logs/cfs_Bm1.log"],
    "conditional_control_at_P": [R + "e55_mandatory_followups/cells/logs/e55_%s_control.log" % m for m in MODELS],
    "misaligned_conditional": [R + "e56_conditional_refusal_aarch64/cells/logs/e56_%s_refuse.log" % m for m in MODELS],
    "conditional_P_minus_1": [R + "e63_single_build_and_conditional_floor/cells/logs/e63_%s_cond_Pm1.log" % m for m in MODELS],
    "sensitivity_below": [R + "e54_reference_budget/cells/logs/sweep_%s_pow2_below.log" % m for m in MODELS],
}
UNKNOWN_BOUND = [R + "e65_producer_check/guest/cells/logs/e65_drift_nobound.log",
                 R + "e14_aarch64_qemu/cfs/logs/A8_dynamic_unknown.log"]
RUNTIME_LOAD = [R + "e65_producer_check/guest/cells/logs/e65_drift_legacy.log"]
ALIGNMENT = [R + "e58_alignment_sweep_aarch64/cells/logs/e58_%s_off%02d.log" % (m, o) for m in MODELS for o in range(0, 64, 8)]


def resolve(p):
    """The archived path, or the single match under the experiment's directory (some logs sit one level deeper)."""
    fp = os.path.join(ROOT, p)
    if os.path.isfile(fp):
        return fp
    exp = p.split("/")[1]
    hits = [h for h in glob.glob(os.path.join(ROOT, "results", exp, "**", os.path.basename(p)), recursive=True)
            if "undersized_window_first_attempt" not in h]
    return hits[0] if len(hits) == 1 else None


def read_cell(p):
    fp = resolve(p)
    if fp is None:
        return {"log": p, "present": False}
    txt = open(fp, encoding="utf-8", errors="replace").read()
    st = m36.stages(fp)
    cpu = re.search(r"monitoring on (\d+) CPU", txt)
    ad = (st.get("admission") or [{}])[0]
    mems = [r for r in st.get("mem", []) if (r.get("completed") or 0) >= 1]
    # the app also reports its peak in its EVS progress line ("completed=n/n ... hal_peak=X"); a cell whose
    # window held one inference has that line and no `mem` JSON record. Reading only the JSON records
    # reported "no peak" for two E58 SmartCam cells that have one (the first version of this reader, D51's
    # shape: "could not see" recorded as "saw none"). mk_e56_summary/mk_e58_summary read both.
    evs = [int(x) for x in re.findall(r"hal_peak=(\d+)", txt)]
    final_peak = evs[-1] if evs else (mems[-1].get("hal_peak") if mems else None)
    if mems and mems[-1].get("admitted_budget_bytes") is not None:
        admitted = mems[-1]["admitted_budget_bytes"]
    elif ad.get("verdict") == "ADMIT":
        admitted = ad.get("budget")
    elif ad.get("verdict") == "ADMIT_CONDITIONAL_MAP":
        admitted = ad.get("per_call")
    else:
        admitted = None
    mb = (st.get("map_branch") or [{}])[0]
    return {"log": rel(fp), "present": True, "cpus_reported": int(cpu.group(1)) if cpu else None,
            "model": ad.get("model"), "verdict": ad.get("verdict"),
            "admitted_budget": admitted,
            "final_hal_peak": final_peak,
            "hal_peak_after_append": mb.get("hal_peak_after_append"),
            "mem_init_records": m36.record_count(st, "mem_init"),
            "run_records": m36.record_count(st, "run"),
            "runtime_load_failed": [r.get("status", "")[:160] for r in st.get("runtime_load_failed", [])],
            "map_precondition_unmet": m36.record_count(st, "map_precondition") if "map_precondition" in st else 0}


def q6_vcpu(cells):
    by = {}
    for c in cells:
        if not c.get("present") or c.get("final_hal_peak") is None or c.get("model") not in P:
            continue
        if c["final_hal_peak"] != P[c["model"]]:
            continue
        by.setdefault(c["model"], {}).setdefault(str(c["cpus_reported"]), []).append(c["log"])
    out = {m: {"P": P[m], "cpus_with_final_peak_equal_P": sorted(v), "cells": v} for m, v in sorted(by.items())}
    return {"per_model": out,
            "models_observed_at_two_or_more_cpu_counts": sorted(m for m, v in out.items()
                                                                if len(v["cpus_with_final_peak_equal_P"]) >= 2),
            "note": "a record for the manuscript's Table 4 guest row, not a verdict"}


def q7_inventory():
    ex = {k: [read_cell(p) for p in v] for k, v in EXECUTION.items()}
    rf = {k: [read_cell(p) for p in v] for k, v in REFUSAL.items()}
    ub = [read_cell(p) for p in UNKNOWN_BOUND]
    rl = [read_cell(p) for p in RUNTIME_LOAD]
    al = [read_cell(p) for p in ALIGNMENT]
    exec_cells = [c for v in ex.values() for c in v]
    ref_cells = [c for v in rf.values() for c in v]
    bound_of = lambda c: (c.get("admitted_budget") or 0)                                  # noqa: E731
    doc = {
        "execution_cells": {k: len(v) for k, v in ex.items()},
        "execution_cells_total": len(exec_cells),
        "execution_cells_all_present": all(c["present"] for c in exec_cells),
        "execution_cells_peak_within_admitted_budget": sum(1 for c in exec_cells if c.get("final_hal_peak") is not None
                                                           and c["final_hal_peak"] <= bound_of(c)),
        "distinct_execution_peaks": sorted({c["final_hal_peak"] for c in exec_cells if c.get("final_hal_peak") is not None}),
        "refusal_cells": {k: len(v) for k, v in rf.items()},
        "refusal_cells_total": len(ref_cells),
        "refusal_cells_without_runtime_or_inference": sum(1 for c in ref_cells if c["present"]
                                                          and c["mem_init_records"] == 0 and c["run_records"] == 0),
        "refusal_verdicts": sorted({c.get("verdict") for c in ref_cells}),
        "unknown_bound_cells": [{k: c.get(k) for k in ("log", "verdict", "mem_init_records", "run_records")} for c in ub],
        "runtime_load_refusal_cells": [{k: c.get(k) for k in ("log", "verdict", "mem_init_records", "run_records",
                                                              "runtime_load_failed")} for c in rl],
        "alignment_cells_total": len(al),
        "alignment_cells_with_final_peak": sum(1 for c in al if c.get("final_hal_peak") is not None),
        "alignment_final_peaks_within_B_u": all(c["final_hal_peak"] <= P[c["model"]] + C[c["model"]]
                                                for c in al if c.get("final_hal_peak") is not None),
        "alignment_final_peaks_by_arm": {
            "offset_0_equals_P": sum(1 for c in al if c.get("final_hal_peak") is not None
                                     and c["log"].endswith("off00.log") and c["final_hal_peak"] == P[c["model"]]),
            "other_offsets_equal_P_plus_C": sum(1 for c in al if c.get("final_hal_peak") is not None
                                                and not c["log"].endswith("off00.log")
                                                and c["final_hal_peak"] == P[c["model"]] + C[c["model"]])},
        "note": "counts for the manuscript's evidence summary, recounted from the raw logs; not a verdict",
    }
    return doc, exec_cells + al


def cmd_ground(_a):
    q1 = q1_parity()
    q2 = q2_budget()
    q2["committed_documents"] = committed_documents()
    q2["committed_documents_not_as_expected"] = [d for d in q2["committed_documents"] if not d["as_expected"]]
    q2["pass"] = q2["pass"] and not q2["committed_documents_not_as_expected"]
    q5 = q5_corpus()
    q7, peak_cells = q7_inventory()
    q6 = q6_vcpu(peak_cells)
    doc = {"experiment": "E66", "plan": PLAN, "Q1_parity": q1, "Q2_budget": q2, "Q5_corpus": q5,
           "Q6_vcpu_record": q6, "Q7_inventory_record": q7}
    dump_json(doc, os.path.join(OUT, "ground.json"))
    print(json.dumps({"Q1": [q1["pass"], q1["n"], q1["disagreements"]], "Q2": [q2["pass"], q2["committed_deployments_checked"],
                      len(q2["committed_documents_not_as_expected"])], "Q5": [q5["pass"], q5["total_representations"]],
                      "Q6": q6["models_observed_at_two_or_more_cpu_counts"],
                      "Q7": {k: q7[k] for k in ("execution_cells_total", "refusal_cells_total",
                                                "alignment_cells_with_final_peak", "execution_cells_peak_within_admitted_budget",
                                                "refusal_cells_without_runtime_or_inference")}}, indent=1))


# --------------------------------------------------------------------------- #
# guest deployments (Q3, Q4)
# --------------------------------------------------------------------------- #
CONFIG = os.path.join(ROOT, "configs", "deployments", "onair_deployments_e66_aarch64.json")
B_U = {m: P[m] + C[m] for m in MODELS}


def cmd_deployments(_a):
    """Every E66 deployment is an E62 fix-arm deployment (same fixture, telemetry, readback, statistics) with
    only the document, the budget and -- in C1 alone -- the waiver changed. Written, not hand-edited."""
    e62 = json.load(open(os.path.join(ROOT, "configs", "deployments", "onair_deployments_e62_aarch64.json"),
                         encoding="utf-8"))["deployments"]
    docs_rel = "../../results/e66_plugin_document_rules/docs/"

    def base(m):
        d = copy.deepcopy(e62["e62_%s_Bu_fix" % m])
        for k in [k for k in d if k.startswith("_")] + [ab.UNCHECKED_PRODUCER_KEY]:
            d.pop(k, None)
        d["_e66_source_deployment"] = "e62_%s_Bu_fix (configs/deployments/onair_deployments_e62_aarch64.json)" % m
        return d
    deps = {}
    for m in MODELS:
        for tag, budget in (("Bum1", B_U[m] - 1), ("Bu", B_U[m])):
            d = base(m)
            d.update({"artifact_dir": docs_rel + m, "contract_file": "%s.contract.json" % m, "budget_bytes": budget,
                      "_e66_role": "Q3: the re-issued document (E65, producer check match) at %s" %
                                   ("B_u - 1" if tag == "Bum1" else "B_u")})
            deps["e66_%s_%s" % (m, tag)] = d
    r = base("b2_resnet")
    cells = {
        "e66_b2_resnet_R1_unchecked": {"artifact_dir": "../../" + MODELS["b2_resnet"],
                                       "_e66_expected": {"document": "refused"},
                                       "_e66_role": "Q4 R1: the archived document (states a bound, no producer check)"},
        "e66_b2_resnet_R2_earlier_revision": {"artifact_dir": docs_rel + "b2_resnet_earlier_revision",
                                              "_e66_expected": {"document": "refused"},
                                              "_e66_role": "Q4 R2: the earlier-revision artifact and its document (producer check mismatch)"},
        "e66_b2_resnet_R3_override": {"artifact_dir": docs_rel + "b2_resnet_override",
                                      "_e66_expected": {"document": "refused"},
                                      "_e66_role": "Q4 R3: a document the analyzer issued under --allow-structural-mismatch"},
        "e66_b2_resnet_R4_budget_zero": {"artifact_dir": docs_rel + "b2_resnet", "budget_bytes": 0,
                                         "_e66_expected": {"budget": "refused"},
                                         "_e66_role": "Q4 R4: the re-issued document with a budget of 0"},
        "e66_b2_resnet_C1_waived": {"artifact_dir": "../../" + MODELS["b2_resnet"], ab.UNCHECKED_PRODUCER_KEY: True,
                                    "_e66_role": "Q4 C1: R1's document with the waiver (the historical configuration)"},
    }
    for name, over in cells.items():
        d = copy.deepcopy(r)
        d.update({"contract_file": "b2_resnet.contract.json", "budget_bytes": B_U["b2_resnet"]})
        d.update(over)
        deps[name] = d
    doc = {"_note": ("E66 (%s): Q3 re-issued documents at B_u - 1 and B_u for the four models, Q4 refusal cells R1-R4 "
                     "and the waiver control C1 on ResNet. Written by harness/e66_plugin_document_rules.py deployments." % PLAN),
           "_scope": "AArch64 QEMU guest only; nothing here is run on the development host",
           "deployments": deps}
    with open(CONFIG, "w", encoding="utf-8") as f:
        f.write(json.dumps(doc, indent=1, ensure_ascii=False) + "\n")
    print(rel(CONFIG), len(deps))


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("prepare")
    sub.add_parser("ground")
    sub.add_parser("deployments")
    a = ap.parse_args()
    {"prepare": cmd_prepare, "ground": cmd_ground, "deployments": cmd_deployments}[a.cmd](a)


if __name__ == "__main__":
    main()
