#!/usr/bin/env python3
"""E65 ground-side part (plan docs/plans/E65_producer_revision_and_plugin_option.md, 7b67d89).

  Q1  M1: the four earlier-revision artifacts of E59 re-analyzed by the current analyzer. The
          document must state no bound (producer check `mismatch`), keep the figures as
          diagnostics, and the header generator must refuse it; with --allow-producer-mismatch
          the header states no bound (BOUND_KNOWN 0) -- that header is the input of guest cell
          Q2(a).
  Q4  Minor 1: the four evaluated documents re-issued from their archived single-invocation
          outputs; three figures unchanged, headers byte-identical, every document now carrying
          analysis_domain (output lifetime, alignment premise) and producer check `match`.
  Q5a Minor 2: two layout-representation edits of the AArch64 ResNet entry (no recompile): a
          second transient slab, a second external (output) allocation. The analyzer must SUM
          each category and the two extractors must agree; the unedited representation is the
          control.
  Q5b Minor 2: the two-output synthetic model (harness/gen_model_multiout.py, E26c) compiled
          for the evaluation target in ONE invocation, then analyzed.

Everything runs on the development host and is ground-side analysis FOR the AArch64 target;
nothing here executes a model. Guest cells (Q2, Q3, Q6) are separate.

Usage: python3 harness/e65_producer_check.py [--part analyzer|multiout|all]
"""
import argparse
import gzip
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
import contract_negative_tests as cnt                            # noqa: E402  (IGNORE sets, flatten)
import e51_precondition_trace as e51                             # noqa: E402  (mutate: last entry print)
import e64_aarch64_evidence as e64                               # noqa: E402  (EVALUATED, mlir_in)
import make_contract as mc                                       # noqa: E402  (CHECKED_PRODUCER)
import vmfb_module_info as vmi                                   # noqa: E402

PY = sys.executable
OUT = os.path.join(ROOT, "results", "e65_producer_check")
PLAN = "docs/plans/E65_producer_revision_and_plugin_option.md (committed before any cell, 7b67d89)"
TRIPLE, CPU = "aarch64-unknown-linux-gnu", "cortex-a53"
DRIFT = "results/e59_info_levels_aarch64/drift_310"
FIG = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes", "bound_method")


def rel(p):
    return os.path.relpath(p, ROOT)


def dump_json(obj, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=1, sort_keys=True)
        f.write("\n")


def header_macro(path, name):
    if not os.path.isfile(path):
        return None
    m = re.search(r"#define\s+%s\s+(\S+)" % name, open(path, encoding="utf-8").read())
    return m.group(1) if m else None


def analyze(mlir, vmfb, layout_ir, dump_dir, elf, name, out_con):
    cmd = [PY, os.path.join(HERE, "make_contract.py"), "--mlir", mlir, "--vmfb", vmfb,
           "--layout-ir", layout_ir, "--dump-dir", dump_dir, "--triple", TRIPLE, "--cpu", CPU,
           "--model-name", name, "--elf-analysis", elf, "--out", out_con]
    if os.path.exists(out_con):
        os.unlink(out_con)
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    return r, (json.load(open(out_con)) if r.returncode == 0 and os.path.isfile(out_con) else None)


def header(con, hdr, *flags):
    if os.path.exists(hdr):
        os.unlink(hdr)
    h = subprocess.run([PY, os.path.join(HERE, "gen_contract_header.py"), con, hdr, *flags],
                       cwd=ROOT, capture_output=True, text=True)
    return {"rc": h.returncode, "written": os.path.isfile(hdr),
            "stderr_tail": (h.stderr or "").strip().splitlines()[-1:] if h.returncode else [],
            "BOUND_KNOWN": header_macro(hdr, "CONTRACT_BOUND_KNOWN"),
            "BOUNDED_BYTES": header_macro(hdr, "CONTRACT_BOUNDED_BYTES")}


# --------------------------------------------------------------------------- Q1
def q1_earlier_revision(work):
    cells = {}
    for name, (src, _adir, _con, _hdr) in e64.EVALUATED.items():
        d = os.path.join(DRIFT, name)
        w = os.path.join(work, "q1", name)
        mlir = e64.mlir_in(src, w, name)
        layout = os.path.join(w, name + ".layout_ir.txt")
        with gzip.open(os.path.join(ROOT, d, name + ".layout_ir.txt.gz"), "rb") as f, open(layout, "wb") as g:
            shutil.copyfileobj(f, g)
        info = vmi.read_module_info(os.path.join(ROOT, d, name + ".vmfb"))
        out_dir = os.path.join(OUT, "drift_310_reanalyzed", name)
        con = os.path.join(out_dir, name + ".contract.json")
        os.makedirs(out_dir, exist_ok=True)
        r, doc = analyze(mlir, os.path.join(d, name + ".vmfb"), layout, os.path.join(d, "dump"),
                         os.path.join(d, name + ".elf.json"), name, con)
        rec = {"artifact": os.path.join(d, name + ".vmfb"), "artifact_bytecode_version": info["bytecode_version"],
               "make_contract_rc": r.returncode, "document_written": doc is not None}
        if doc is not None:
            res, pc = doc["resources"], doc["validity"]["producer_check"]
            rec.update({
                "producer_check_state": pc["state"],
                "bound_method": res["bound_method"], "bounded_bytes": res["bounded_bytes"],
                "static_per_call_bytes": res["static_per_call_bytes"],
                "diagnostic_figures_when_bound_withheld": res["diagnostic_figures_when_bound_withheld"],
                "verification_grade": doc["provenance"]["verification_grade"],
                "e59_archived_document_bound": json.load(open(os.path.join(ROOT, d, name + ".contract.json")))
                ["resources"]["bounded_bytes"],
            })
            rec["header_default"] = header(con, os.path.join(out_dir, "refused.h"))
            rec["header_with_allow_producer_mismatch"] = header(
                con, os.path.join(out_dir, "contract_gen.%s.h" % name), "--allow-producer-mismatch")
            # the same diagnostic figures E59 recorded as the (c) value, now as diagnostics only
            dg = res["diagnostic_figures_when_bound_withheld"] or {}
            rec["diagnostic_equals_e59_c_value"] = dg.get("bounded_bytes") == rec["e59_archived_document_bound"]
        cells[name] = rec
    ok = all(c.get("producer_check_state") == "mismatch" and c.get("bound_method") == "NONE"
             and c.get("bounded_bytes") is None
             and c["header_default"]["rc"] != 0 and not c["header_default"]["written"]
             and c["header_with_allow_producer_mismatch"]["BOUND_KNOWN"] == "0"
             and c.get("diagnostic_equals_e59_c_value") is True
             for c in cells.values())
    return {"cells": cells, "pass": ok}


# --------------------------------------------------------------------------- Q4
def q4_reissue(work):
    cells = {}
    for name, (src, adir, con_name, hdr_name) in e64.EVALUATED.items():
        w = os.path.join(work, "q4", name)
        mlir = e64.mlir_in(src, w, name)
        out_dir = os.path.join(OUT, "reissued", name)
        os.makedirs(out_dir, exist_ok=True)
        con = os.path.join(out_dir, con_name)
        # RELATIVE paths, as the archived documents were made (E51/E64)
        r, doc = analyze(mlir, os.path.join(adir, name + ".vmfb"), os.path.join(adir, name + ".layout_ir.txt"),
                         os.path.join(adir, "dump"), os.path.join(adir, name + ".elf.json"), name, rel(con))
        old = json.load(open(os.path.join(ROOT, adir, con_name)))
        rec = {"archived_document": os.path.join(adir, con_name), "make_contract_rc": r.returncode,
               "archived_has_analysis_domain": "analysis_domain" in old,
               "archived_has_output_lifetime": bool(((old.get("analysis_domain") or {}).get("required_premises")
                                                     or {}).get("output_lifetime"))}
        if doc is not None:
            rec["figures_archived"] = {k: old["resources"].get(k) for k in FIG}
            rec["figures_reissued"] = {k: doc["resources"].get(k) for k in FIG}
            rec["figures_unchanged"] = rec["figures_archived"] == rec["figures_reissued"]
            rec["producer_check_state"] = doc["validity"]["producer_check"]["state"]
            prem = (doc.get("analysis_domain") or {}).get("required_premises") or {}
            cp = ((doc.get("analysis_domain") or {}).get("derived") or {}).get("constant_policy") or {}
            rec["reissued_output_lifetime"] = prem.get("output_lifetime")
            rec["reissued_max_in_flight_calls"] = prem.get("max_in_flight_calls")
            rec["reissued_states_alignment_premise"] = "64-byte aligned" in (cp.get("map_arm_precondition") or "")
            o, n = dict(cnt.flatten(old)), dict(cnt.flatten(doc))
            rec["leaf_differences_outside_ignored_keys"] = sorted(
                str(k) for k in set(o) | set(n)
                if k[-1] not in cnt.IGNORE_PROVENANCE_KEYS and not (set(k) & cnt.IGNORE_PROVENANCE_SUBTREES)
                and o.get(k) != n.get(k))
            h = header(con, os.path.join(out_dir, hdr_name))
            rec["header"] = h
            rec["header_byte_identical"] = (h["written"] and open(os.path.join(out_dir, hdr_name), "rb").read()
                                            == open(os.path.join(ROOT, adir, hdr_name), "rb").read())
        cells[name] = rec
    ok = all(c.get("figures_unchanged") and c.get("header_byte_identical")
             and c.get("producer_check_state") == "match"
             and c.get("reissued_output_lifetime") == "released_before_next_call"
             and c.get("reissued_max_in_flight_calls") == 1 and c.get("reissued_states_alignment_premise")
             for c in cells.values())
    return {"cells": cells, "pass": ok,
            "archived_documents_with_analysis_domain": sorted(n for n, c in cells.items()
                                                              if c["archived_has_analysis_domain"])}


# --------------------------------------------------------------------------- Q5a
AFF = "on(#hal.device.affinity<@__device_0>)"
EDITS = [
    {"id": "second_transient_slab", "adds": {"transient": 256},
     "inject": "\n  %e65_t2, %e65_t2_tp = stream.resource.alloca uninitialized " + AFF +
               " await(%1) => !stream.resource<transient>{%c256} => !stream.timepoint"},
    {"id": "second_output_allocation", "adds": {"output": 40},
     "inject": "\n  %e65_o2, %e65_o2_tp = stream.resource.alloca uninitialized " + AFF +
               " await(%1) => !stream.resource<external>{%c40} => !stream.timepoint"},
]


def q5a_layout_edits(work):
    name, adir = "b2_resnet", "results/e36b_aarch64_models/b2_resnet"
    w = os.path.join(work, "q5a")
    os.makedirs(w, exist_ok=True)
    mlir = e64.mlir_in("results/e36b_aarch64_models/b2_resnet/b2_resnet.mlir", w, name)
    ir = open(os.path.join(ROOT, adir, name + ".layout_ir.txt"), encoding="utf-8").read()
    cells = {}
    for edit in [{"id": "control_unedited", "adds": {}, "inject": None}] + EDITS:
        text = ir if edit["inject"] is None else e51.mutate(ir, edit["inject"])
        lp = os.path.join(w, "%s.%s.layout_ir.txt" % (name, edit["id"]))
        open(lp, "w", encoding="utf-8").write(text)
        con = os.path.join(w, edit["id"] + ".contract.json")
        r, doc = analyze(mlir, os.path.join(adir, name + ".vmfb"), lp, os.path.join(adir, "dump"),
                         os.path.join(adir, name + ".elf.json"), name, con)
        rec = {"inject": edit["inject"], "make_contract_rc": r.returncode, "document_written": doc is not None,
               "stderr_tail": (r.stderr or "").strip().splitlines()[-2:] if r.returncode else []}
        if doc is not None:
            res = doc["resources"]
            sw = doc["provenance"].get("structural_walker") or {}
            rec.update({"transient_slabs_post_layout": res["transient_slabs_post_layout"],
                        "static_transient_bytes": res["static_transient_bytes"],
                        "static_external_output_bytes": res["static_external_output_bytes"],
                        "static_per_call_bytes": res["static_per_call_bytes"],
                        "bounded_bytes": res["bounded_bytes"], "bound_method": res["bound_method"],
                        "structural_agrees": sw.get("agrees_with_regex_parser")})
        cells[edit["id"]] = rec
    ctl = cells["control_unedited"]
    ok = (ctl.get("static_per_call_bytes") == 309416 and ctl.get("static_transient_bytes") == 297088
          and ctl.get("static_external_output_bytes") == 40)
    for edit in EDITS:
        c = cells[edit["id"]]
        exp_t = 297088 + edit["adds"].get("transient", 0)
        exp_o = 40 + edit["adds"].get("output", 0)
        c["expected"] = {"static_transient_bytes": exp_t, "static_external_output_bytes": exp_o,
                         "static_per_call_bytes": 12288 + exp_o + exp_t}
        c["summed_as_expected"] = (c.get("static_transient_bytes") == exp_t
                                   and c.get("static_external_output_bytes") == exp_o
                                   and c.get("static_per_call_bytes") == 12288 + exp_o + exp_t
                                   and c.get("structural_agrees") is True)
        ok = ok and c["summed_as_expected"]
    return {"artifact": rel(os.path.join(ROOT, adir, name + ".vmfb")),
            "method": "one line inserted before the terminator of the entry's last print (E51's mutate); "
                      "no recompile; production make_contract.py",
            "cells": cells, "pass": ok}


# --------------------------------------------------------------------------- Q5b
def q5b_multiout(work):
    w = os.path.join(work, "q5b")
    os.makedirs(w, exist_ok=True)
    mlir = os.path.join(w, "multiout.mlir")
    shutil.copyfile(os.path.join(ROOT, "results", "e26c_multiout", "multiout.mlir"), mlir)
    vmfb, layout, dump = (os.path.join(w, "multiout.vmfb"), os.path.join(w, "multiout.layout_ir.txt"),
                          os.path.join(w, "dump"))
    os.makedirs(dump, exist_ok=True)
    cmd = ["iree-compile", mlir, "--iree-hal-target-backends=llvm-cpu",
           "--iree-llvmcpu-target-triple=" + TRIPLE, "--iree-llvmcpu-target-cpu=" + CPU,
           "--mlir-print-ir-after=iree-stream-layout-slices", "--mlir-elide-elementsattrs-if-larger=16",
           "--iree-hal-dump-executable-files-to=" + dump, "-o", vmfb]
    with open(layout, "w") as err:
        c = subprocess.run(cmd, stderr=err, stdout=subprocess.PIPE, text=True)
    rec = {"compile_argv": ["iree-compile"] + [x.replace(w + "/", "") for x in cmd[1:]], "compile_rc": c.returncode}
    if c.returncode != 0:
        return {**rec, "pass": False}
    elf = os.path.join(w, "multiout.elf.json")
    e = subprocess.run([PY, os.path.join(HERE, "elf_stack_frame.py"), "--dump-dir", dump, "--vmfb", vmfb,
                        "--out", elf], cwd=ROOT, capture_output=True, text=True)
    rec["elf_rc"] = e.returncode
    con = os.path.join(w, "multiout.contract.json")
    r, doc = analyze(mlir, vmfb, layout, dump, elf, "multiout", con)
    rec["make_contract_rc"] = r.returncode
    if doc is not None:
        res = doc["resources"]
        ent = e51.mutate  # noqa: F841  (the edit helper is not used here: no edit)
        txt = open(layout, encoding="utf-8").read()
        rec.update({
            "outputs_declared": [o["shape"] for o in doc["interface"]["outputs"]],
            "output_tensor_bytes": sum(4 * _prod(o["shape"]) for o in doc["interface"]["outputs"]),
            "static_external_output_bytes": res["static_external_output_bytes"],
            "static_per_call_bytes": res["static_per_call_bytes"], "bounded_bytes": res["bounded_bytes"],
            "module_resident_constant_bytes": res["module_resident_constant_bytes"],
            "bound_method": res["bound_method"],
            "overrides_applied": doc["provenance"]["overrides_applied"],
            "producer_check_state": doc["validity"]["producer_check"]["state"],
            "structural_agrees": (doc["provenance"].get("structural_walker") or {}).get("agrees_with_regex_parser"),
            "subviews_in_layout_ir": txt.count("stream.resource.subview"),
        })
        rec["header"] = header(con, os.path.join(w, "multiout.h"))
        keep = os.path.join(OUT, "multiout_aarch64")
        os.makedirs(keep, exist_ok=True)
        for f in ("multiout.mlir", "multiout.vmfb", "multiout.layout_ir.txt", "multiout.elf.json",
                  "multiout.contract.json"):
            shutil.copyfile(os.path.join(w, f), os.path.join(keep, f))
        e64_red = os.path.join(keep, "dump")
        if os.path.exists(e64_red):
            shutil.rmtree(e64_red)
        os.makedirs(e64_red)
        for f in sorted(os.listdir(dump)):
            if f.endswith((".mlir", ".so")):
                shutil.copyfile(os.path.join(dump, f), os.path.join(e64_red, f))
    rec["pass"] = bool(doc is not None and rec.get("bound_method") != "NONE"
                       and rec.get("overrides_applied") == [] and rec.get("structural_agrees") is True
                       and rec.get("subviews_in_layout_ir", 0) >= 2
                       and rec.get("static_external_output_bytes", 0) >= rec.get("output_tensor_bytes", 1 << 40))
    return rec


def _prod(shape):
    n = 1
    for v in shape:
        n *= int(v)
    return n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--part", choices=["analyzer", "multiout", "all"], default="all")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="e65_") as work:
        if a.part in ("analyzer", "all"):
            doc = {"experiment": "E65", "plan": PLAN, "target": TRIPLE, "cpu": CPU,
                   "checked_producer": mc.CHECKED_PRODUCER,
                   "Q1_earlier_revision": q1_earlier_revision(work),
                   "Q4_reissue": q4_reissue(work),
                   "Q5a_layout_edits": q5a_layout_edits(work)}
            dump_json(doc, os.path.join(OUT, "analyzer.json"))
            print(json.dumps({k: doc[k]["pass"] for k in ("Q1_earlier_revision", "Q4_reissue", "Q5a_layout_edits")}))
        if a.part in ("multiout", "all"):
            doc = {"experiment": "E65", "plan": PLAN, "target": TRIPLE, "cpu": CPU, "Q5b_multiout": q5b_multiout(work)}
            dump_json(doc, os.path.join(OUT, "multiout.json"))
            print(json.dumps({"Q5b": doc["Q5b_multiout"]["pass"]}))


if __name__ == "__main__":
    main()
