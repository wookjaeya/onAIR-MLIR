#!/usr/bin/env python3
"""E64: the four manuscript sentences whose evidence was out of scope, re-established on AArch64.

Plan: docs/plans/E64_aarch64_evidence_for_manuscript.md (committed before measurement, 6578481).

The manuscript's only experimental target is AArch64. A fact check of manuscript v25 found three
sentences resting on x86-64-target products (E51's edited mlp16k layout, a 26-file corpus of which
15 are x86-64, a compiler-statistics comparison compiled for x86-64 outside the repository) and one
sentence whose auxiliary references were computed by the development host. This harness replaces
each with AArch64 evidence; the development host only cross-compiles FOR AArch64 and copies files.

  A  probes   -- surgical edits of the archived ResNet AArch64 layout IR through the PRODUCTION
                 make_contract.py -> gen_contract_header.py path (no recompile, discipline 7).
                 Machinery imported from E51 (no second implementation -- E44).
  B  corpus   -- every archived AArch64 layout IR through the structural walker, and the four
                 EVALUATED specifications regenerated from their archived single-invocation
                 outputs (figures compared, headers compared byte for byte).
  C  stats    -- the compiler's own statistics emitted in the SAME invocation as the vmfb,
                 layout IR and dump from which the specification is made.
  D  guest    -- computed inside the AArch64 QEMU guest: sequential-f32 and float64 references
                 for the E60 window, DeepAE anomaly scores for the 34 windows on both paths,
                 and the guest environment record.

Usage (host):
  python3 harness/e64_aarch64_evidence.py probes
  python3 harness/e64_aarch64_evidence.py corpus
  python3 harness/e64_aarch64_evidence.py stats --work <scratch>
  python3 harness/e64_aarch64_evidence.py guest-prep --work <scratch> --ad01 <dir from fetch_real_inputs.py deepae>
  (guest) python3 e64_aarch64_evidence.py guest-run --work <dir>
  python3 harness/e64_aarch64_evidence.py collect --guest-json <file> --env-json <file>
  python3 harness/e64_aarch64_evidence.py summary
"""
import argparse
import glob
import gzip
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
OUT = os.path.join(ROOT, "results", "e64_aarch64_evidence")
PLAN = "docs/plans/E64_aarch64_evidence_for_manuscript.md (committed before measurement, 6578481)"
PY = sys.executable
TRIPLE, CPU, ELIDE = "aarch64-unknown-linux-gnu", "cortex-a53", 16

RESNET = "results/e36b_aarch64_models/b2_resnet"
EVALUATED = {
    # name: (mlir source, archived dir holding vmfb/layout/dump/elf, archived contract, archived header)
    "b2_resnet": ("results/e36b_aarch64_models/b2_resnet/b2_resnet.mlir", "results/e36b_aarch64_models/b2_resnet",
                  "b2_resnet.contract.json", "contract_gen.b2_resnet.h"),
    "b3_deepae": ("results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir", "results/e36b_aarch64_models/b3_deepae",
                  "b3_deepae.contract.json", "contract_gen.b3_deepae.h"),
    "smartcam": ("results/p1_smartcam_feasibility/build/smartcam.mlir.gz", "results/e32_smartcam_aarch64/build",
                 "smartcam.contract.json", "contract_gen.smartcam.h"),
    "wgan": ("results/e53_wgan_aarch64/build/aarch64/wgan.mlir", "results/e53_wgan_aarch64/build/aarch64",
             "wgan.contract.json", "contract_gen.wgan.h"),
}
DYNAMIC_MLIR = "results/e14_aarch64_qemu/models/dynamic/dyn_batch_mlp.mlir"
E60_SAMPLE = "normal_id_04_00000043_hist_librosa_w98"
E60_INPUT_SHA = "024c8300cd90abe8721607b9cbf8c906aeebdb59ef9c0549b87789e06fd97951"


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def rel(p):
    return os.path.relpath(p, ROOT)


def dump_json(doc, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(doc, fh, indent=1, ensure_ascii=False)
        fh.write("\n")


def mlir_in(src, work, name):
    """Materialize the compile input under its ORIGINAL basename: the dump-dir filename check
    (D10) and the vmfb symbol names both carry it."""
    os.makedirs(work, exist_ok=True)
    dst = os.path.join(work, name + ".mlir")
    if src.endswith(".gz"):
        with gzip.open(os.path.join(ROOT, src), "rb") as f, open(dst, "wb") as g:
            shutil.copyfileobj(f, g)
    else:
        shutil.copyfile(os.path.join(ROOT, src), dst)
    return dst


def header_bound_known(path):
    if not os.path.isfile(path):
        return None
    m = re.search(r"#define\s+CONTRACT_BOUND_KNOWN\s+(\d+)", open(path, encoding="utf-8").read())
    return int(m.group(1)) if m else None


# --------------------------------------------------------------------------- #
# A. probes on the ResNet AArch64 layout IR
# --------------------------------------------------------------------------- #
AFF = "on(#hal.device.affinity<@__device_0>)"
CONST = "\n  %e64_c = arith.constant 64 : index"
PROBES = [
    {"id": "A1_in_family_unrecognized_op",
     "what": "a parseable stream.resource.* op the analyzer does not recognize",
     "predicted": "specification issued with bound_method NONE; header CONTRACT_BOUND_KNOWN 0",
     "inject": "\n  %e64_sz0 = stream.resource.size %result : !stream.resource<external>"},
    {"id": "A2_out_of_family_resource_op",
     "what": "a resource-carrying op outside stream.resource/stream.tensor and outside the verified non-allocating list",
     "predicted": "no specification (walker unclassified_resource_ops, dedicated key)",
     "inject": "\n  %e64_ob = util.optimization_barrier %result : !stream.resource<external>"},
    {"id": "A3_pre_scheduling_async_alloc",
     "what": "a surviving pre-scheduling asynchronous allocation",
     "predicted": "no specification (walker pre_scheduling_ops; extractors disagree)",
     "inject": CONST + "\n  %e64_async = stream.async.alloca : !stream.resource<transient>{%e64_c}"},
    {"id": "A4_unresolvable_size",
     "what": "a supported allocation whose size operand does not resolve to a constant",
     "predicted": "specification issued with bound_method NONE; header CONTRACT_BOUND_KNOWN 0",
     "inject": CONST + "\n  %e64_sz = arith.addi %e64_c, %e64_c : index"
               "\n  %e64_res, %e64_tp = stream.resource.alloca uninitialized " + AFF +
               " await(%1) => !stream.resource<transient>{%e64_sz} => !stream.timepoint"},
    {"id": "A5_unparseable_op",
     "what": "an op the compiler interface cannot parse (E51's line, AArch64 representation)",
     "predicted": "no specification; cause recorded as found",
     "inject": CONST + "\n  %e64_unk = stream.resource.frobnicate %e64_c : index -> !stream.resource<transient>{%e64_c}"},
    {"id": "A6_other_lifetime_category",
     "what": "an allocation of a lifetime category neither extractor attributes (staging)",
     "predicted": "no specification (extractors disagree)",
     "inject": CONST + "\n  %e64_st, %e64_st_tp = stream.resource.alloca uninitialized " + AFF +
               " await(%1) => !stream.resource<staging>{%e64_c} => !stream.timepoint"},
]


def resnet_fixture(work):
    d = os.path.join(ROOT, RESNET)
    return {"mlir": os.path.join(d, "b2_resnet.mlir"), "vmfb": os.path.join(d, "b2_resnet.vmfb"),
            "dump_dir": os.path.join(d, "dump"), "elf": os.path.join(d, "b2_resnet.elf.json"),
            "model": "b2_resnet"}


def production(fx, layout_ir, work, tag):
    """make_contract.py then, if a specification comes out, gen_contract_header.py (two positional
    arguments -- D106), exactly as the deployment path runs them."""
    con = os.path.join(work, tag + ".contract.json")
    hdr = os.path.join(work, tag + ".contract_gen.h")
    for p in (con, hdr):
        if os.path.exists(p):
            os.unlink(p)
    cmd = [PY, os.path.join(HERE, "make_contract.py"), "--mlir", fx["mlir"], "--vmfb", fx["vmfb"],
           "--layout-ir", layout_ir, "--dump-dir", fx["dump_dir"], "--triple", TRIPLE, "--cpu", CPU,
           "--model-name", fx["model"], "--elf-analysis", fx["elf"], "--out", con]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    res = {"make_contract_rc": r.returncode, "specification_written": os.path.isfile(con),
           "make_contract_stderr_tail": [l for l in (r.stderr or "").strip().splitlines()[-4:]]}
    if res["specification_written"]:
        c = json.load(open(con, encoding="utf-8"))["resources"]
        res.update({"bound_method": c.get("bound_method"), "bounded_bytes": c.get("bounded_bytes"),
                    "unresolved_sizes": c.get("unresolved_sizes")})
        h = subprocess.run([PY, os.path.join(HERE, "gen_contract_header.py"), con, hdr],
                           cwd=ROOT, capture_output=True, text=True)
        res.update({"gen_contract_header_rc": h.returncode, "header_written": os.path.isfile(hdr),
                    "header_bound_known": header_bound_known(hdr)})
    else:
        res.update({"bound_method": None, "bounded_bytes": None, "unresolved_sizes": None,
                    "gen_contract_header_rc": None, "header_written": False, "header_bound_known": None})
    return res


def extractor_views(text):
    """What each extractor says on its own -- a refusal is evidence only when it is attributable."""
    sys.path.insert(0, HERE)
    import static_mem_bound as smb
    import mlir_alloc_walk as maw
    p = smb.parse_alloc_ir(text)
    view = {"regex_parser": {"unresolved": p["unresolved"][:8], "outputs": p["outputs"],
                             "transient_slabs": p["transient_slabs"], "inputs": p["inputs"]}}
    try:
        w = maw.parse_alloc_ir_structural(text, "infer")
        keep = ("unresolved", "outputs", "transient_slabs", "inputs", "pre_scheduling_ops",
                "unclassified_resource_ops", "unsupported_control_ops", "entry_chunk_rank_used",
                "entry_chunk_parse_failures")
        view["structural_walker"] = {k: (sorted(set(w[k])) if k in ("pre_scheduling_ops",
                                                                    "unclassified_resource_ops",
                                                                    "unsupported_control_ops")
                                         and isinstance(w.get(k), list) else w.get(k))
                                     for k in keep if k in w}
        view["structural_walker"]["exception"] = None
        view["diff_against_regex"] = maw.diff_against_regex(w, p)
    except Exception as exc:                                             # noqa: BLE001 -- recorded
        view["structural_walker"] = {"exception": "%s: %s" % (type(exc).__name__, str(exc)[:240])}
        view["diff_against_regex"] = None
    return view


def classify(res, view):
    """Name the path by which a cell ended -- from the records, never from the prediction."""
    sw = view.get("structural_walker") or {}
    if res["specification_written"]:
        if res["bound_method"] == "NONE" and res["header_bound_known"] == 0:
            return "specification_without_bound_header_bound_known_0"
        if res["header_bound_known"] == 1:
            return "bound_issued_header_bound_known_1"
        return "specification_written_other"
    if sw.get("unclassified_resource_ops"):
        return "refused_dedicated_key_unclassified_resource_ops"
    if sw.get("unsupported_control_ops"):
        return "refused_control_flow"
    if view.get("diff_against_regex"):
        return "refused_extractors_disagree"
    return "refused_other"


def cmd_probes(a):
    sys.path.insert(0, HERE)
    import e51_precondition_trace as e51          # the SAME insertion rule as E51 (before util.return)
    ir = open(os.path.join(ROOT, RESNET, "b2_resnet.layout_ir.txt"), encoding="utf-8").read()
    with tempfile.TemporaryDirectory(prefix="e64_probes_") as work:
        fx = resnet_fixture(work)
        ctrl_path = os.path.join(work, "A0.layout_ir.txt")
        open(ctrl_path, "w").write(ir)
        control = production(fx, ctrl_path, work, "A0")
        control["extractors"] = extractor_views(ir)
        control["path"] = classify(control, control["extractors"])
        control["ok"] = (control["path"] == "bound_issued_header_bound_known_1"
                         and control["bounded_bytes"] == 618856)
        cells = []
        for p in PROBES:
            text = e51.mutate(ir, p["inject"])
            if text is None:
                cells.append(dict(p, error="entry terminator not found"))
                continue
            path = os.path.join(work, p["id"] + ".layout_ir.txt")
            open(path, "w").write(text)
            res = production(fx, path, work, p["id"])
            view = extractor_views(text)
            cells.append(dict(p, injected=p["inject"].strip(), extractors=view,
                              path=classify(res, view), **res))
    deployable = [c["id"] for c in cells if c.get("header_bound_known") == 1]
    doc = {
        "experiment": "E64", "part": "A", "plan": PLAN,
        "source_layout_ir": RESNET + "/b2_resnet.layout_ir.txt",
        "source_sha256": sha256_file(os.path.join(ROOT, RESNET, "b2_resnet.layout_ir.txt")),
        "method": ("surgical edit of the archived AArch64 layout IR, inserted before the last util.return of the "
                   "entry's last print (E51's mutate), then the production make_contract.py and gen_contract_header.py"),
        "positive_control": control,
        "cells": cells,
        "cells_with_deployable_header": deployable,
        "control_flow_cells": "cited, not re-run: results/d105_control_flow_boundary/after.json (same AArch64 ResNet IR)",
        "verdict": ("PASS" if control["ok"] and cells and not deployable
                    and all("error" not in c for c in cells) else "FAIL"),
    }
    dump_json(doc, getattr(a, "out", None) or os.path.join(OUT, "probes.json"))
    print(json.dumps({"control": control["path"], "cells": {c["id"]: c.get("path") for c in cells},
                      "verdict": doc["verdict"]}, indent=1))


# --------------------------------------------------------------------------- #
# B. AArch64 corpus + regeneration of the four evaluated specifications
# --------------------------------------------------------------------------- #
# The layout representation carries no target marker (it precedes code generation), and for most
# models its bytes are identical across the two targets -- measured below, not assumed. What makes a
# file an AArch64 representation is therefore the invocation that produced it: the directory of an
# AArch64-target compile. Listed explicitly, with the earlier-revision (E59 drift) directory kept apart.
AARCH64_COMPILE_DIRS = ("results/e14_aarch64_qemu/aarch64/", "results/e32_smartcam_aarch64/",
                        "results/e36b_aarch64_models/", "results/e53_wgan_aarch64/build/aarch64/")
EARLIER_REVISION_DIRS = ("results/e59_info_levels_aarch64/drift_310/",)


def tracked_layout_irs():
    r = subprocess.run(["git", "ls-files", "results"], cwd=ROOT, capture_output=True, text=True)
    return sorted(p for p in r.stdout.split()
                  if "layout_ir" in os.path.basename(p) and (p.endswith(".txt") or p.endswith(".txt.gz")))


def read_ir(p):
    fp = os.path.join(ROOT, p)
    raw = gzip.open(fp, "rb").read() if p.endswith(".gz") else open(fp, "rb").read()
    return raw


def cmd_corpus(a):
    sys.path.insert(0, HERE)
    import mlir_alloc_walk as maw
    import contract_negative_tests as cnt
    files = []
    for p in tracked_layout_irs():
        raw = read_ir(p)
        text = raw.decode("utf-8", errors="replace")
        target = ("aarch64" if p.startswith(AARCH64_COMPILE_DIRS + EARLIER_REVISION_DIRS) else "x86_64")
        rec = {"path": p, "target_of_producing_compile": target, "sha256": hashlib.sha256(raw).hexdigest(),
               "earlier_compiler_revision": p.startswith(EARLIER_REVISION_DIRS)}
        try:
            w = maw.parse_alloc_ir_structural(text, "infer")
            rec.update({"unclassified_resource_ops": sorted(set(w.get("unclassified_resource_ops") or [])),
                        "unsupported_control_ops": sorted(set(w.get("unsupported_control_ops") or [])),
                        "pre_scheduling_ops": sorted(set(w.get("pre_scheduling_ops") or [])),
                        "entry_chunk_rank_used": w.get("entry_chunk_rank_used"),
                        "walker_exception": None})
        except Exception as exc:                                         # noqa: BLE001
            rec["walker_exception"] = "%s: %s" % (type(exc).__name__, str(exc)[:200])
        files.append(rec)
    by_sha = {}
    for f in files:
        by_sha.setdefault(f["sha256"], set()).add(f["target_of_producing_compile"])
    for f in files:
        f["byte_identical_file_exists_from_other_target"] = len(by_sha[f["sha256"]]) > 1
    in_scope = [f for f in files if f["target_of_producing_compile"] == "aarch64"
                and not f["earlier_compiler_revision"]]
    b1 = {
        "tracked_layout_irs": len(files),
        "by_target_of_producing_compile": {t: sum(1 for f in files if f["target_of_producing_compile"] == t)
                                           for t in ("aarch64", "x86_64")},
        "aarch64_earlier_revision": [f["path"] for f in files if f["earlier_compiler_revision"]],
        "aarch64_files_byte_identical_to_an_x86_64_compile_file": sum(
            1 for f in in_scope if f["byte_identical_file_exists_from_other_target"]),
        "aarch64_evaluated_revision_unedited": [f["path"] for f in in_scope],
        "aarch64_evaluated_revision_unedited_count": len(in_scope),
        "aarch64_unclassified_total": sum(len(f.get("unclassified_resource_ops") or []) for f in in_scope),
        "aarch64_walker_exceptions": [f["path"] for f in in_scope if f.get("walker_exception")],
        "files": files,
    }

    # B2: regenerate the four evaluated specifications from their archived single-invocation outputs
    regen = {}
    with tempfile.TemporaryDirectory(prefix="e64_regen_") as work:
        for name, (src, adir, con_name, hdr_name) in EVALUATED.items():
            mlir = mlir_in(src, os.path.join(work, name), name)
            new_con = os.path.join(work, name, "regen.contract.json")
            new_hdr = os.path.join(work, name, "regen.contract_gen.h")
            cmd = [PY, os.path.join(HERE, "make_contract.py"), "--mlir", mlir,
                   # RELATIVE paths, as the archived documents were made: an absolute root makes every
                   # document "differ" on provenance.dump_dir alone (E51 measured that before a verdict)
                   "--vmfb", os.path.join(adir, name + ".vmfb"),
                   "--layout-ir", os.path.join(adir, name + ".layout_ir.txt"),
                   "--dump-dir", os.path.join(adir, "dump"), "--triple", TRIPLE, "--cpu", CPU,
                   "--model-name", name, "--elf-analysis", os.path.join(adir, name + ".elf.json"),
                   "--out", new_con]
            r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
            rec = {"make_contract_rc": r.returncode, "stderr_tail": (r.stderr or "").strip().splitlines()[-3:]}
            if r.returncode == 0 and os.path.isfile(new_con):
                old_d = json.load(open(os.path.join(ROOT, adir, con_name)))
                new_d = json.load(open(new_con))
                fig = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes", "bound_method")
                rec["figures_archived"] = {k: old_d["resources"].get(k) for k in fig}
                rec["figures_regenerated"] = {k: new_d["resources"].get(k) for k in fig}
                rec["figures_unchanged"] = rec["figures_archived"] == rec["figures_regenerated"]
                old, new = dict(cnt.flatten(old_d)), dict(cnt.flatten(new_d))
                diffs = sorted(str(k) for k in set(old) | set(new)
                               if k[-1] not in cnt.IGNORE_PROVENANCE_KEYS
                               and not (set(k) & cnt.IGNORE_PROVENANCE_SUBTREES)
                               and old.get(k) != new.get(k))
                rec["document_leaf_differences_outside_ignored_keys"] = diffs
                # the archived dump directories were reduced after generation (E47: .o/.bc dropped by
                # .gitignore); the listing differs, the figures do not -- recorded, not ignored
                rec["dump_dir_files_listed_archived_vs_regenerated"] = [
                    len(old_d["provenance"].get("dump_dir_files") or []),
                    len(new_d["provenance"].get("dump_dir_files") or [])]
                h = subprocess.run([PY, os.path.join(HERE, "gen_contract_header.py"), new_con, new_hdr],
                                   cwd=ROOT, capture_output=True, text=True)
                rec["gen_contract_header_rc"] = h.returncode
                old_h = open(os.path.join(ROOT, adir, hdr_name), "rb").read()
                new_h = open(new_hdr, "rb").read() if os.path.isfile(new_hdr) else b""
                rec["header_byte_identical"] = old_h == new_h
                if old_h != new_h:
                    ol, nl = old_h.decode().splitlines(), new_h.decode().splitlines()
                    rec["header_lines_only_in_archived"] = [l for l in ol if l not in nl][:20]
                    rec["header_lines_only_in_regenerated"] = [l for l in nl if l not in ol][:20]
            regen[name] = rec
    b2 = {"method": ("make_contract.py and gen_contract_header.py of the current tree on each evaluated model's "
                     "archived single-invocation outputs (vmfb, layout IR, dump, ELF analysis); leaf diff uses "
                     "contract_negative_tests' IGNORE sets (no second diff implementation, E44)"),
          "models": regen,
          "figures_unchanged": all(v.get("figures_unchanged") for v in regen.values()),
          "headers_byte_identical": all(v.get("header_byte_identical") for v in regen.values())}
    doc = {"experiment": "E64", "part": "B", "plan": PLAN, "B1_aarch64_corpus": b1, "B2_evaluated_regeneration": b2,
           "verdict": ("PASS" if b1["aarch64_unclassified_total"] == 0 and not b1["aarch64_walker_exceptions"]
                       and b2["figures_unchanged"] else "FAIL")}
    dump_json(doc, os.path.join(OUT, "corpus.json"))
    print(json.dumps({"aarch64_files": b1["aarch64_evaluated_revision_unedited_count"],
                      "unclassified": b1["aarch64_unclassified_total"], "by_target": b1["by_target_of_producing_compile"],
                      "figures_unchanged": b2["figures_unchanged"],
                      "headers_byte_identical": b2["headers_byte_identical"],
                      "verdict": doc["verdict"]}, indent=1))


# --------------------------------------------------------------------------- #
# C. compiler statistics from the SAME invocation as the specification
# --------------------------------------------------------------------------- #
def compile_with_stats(mlir, work, name, fmt):
    vmfb = os.path.join(work, name + ".vmfb")
    ir = os.path.join(work, name + ".layout_ir.txt")
    dump = os.path.join(work, "dump")
    stats = os.path.join(work, "%s.stats.%s" % (name, fmt))
    if os.path.exists(dump):
        shutil.rmtree(dump)
    os.makedirs(dump)
    cmd = ["iree-compile", mlir, "--iree-hal-target-backends=llvm-cpu",
           "--iree-llvmcpu-target-triple=" + TRIPLE, "--iree-llvmcpu-target-cpu=" + CPU,
           "--mlir-print-ir-after=iree-stream-layout-slices",
           "--mlir-elide-elementsattrs-if-larger=%d" % ELIDE,
           "--iree-hal-dump-executable-files-to=" + dump,
           "--iree-scheduling-dump-statistics-format=" + fmt,
           "--iree-scheduling-dump-statistics-file=" + stats, "-o", vmfb]
    with open(ir, "w") as err:
        r = subprocess.run(cmd, stderr=err, stdout=subprocess.PIPE, text=True)
    return {"rc": r.returncode, "vmfb": vmfb, "layout_ir": ir, "dump": dump, "stats": stats,
            "argv": ["iree-compile"] + [x.replace(work + "/", "") for x in cmd[1:]]}


def spec_from(comp, mlir, work, name):
    elf = os.path.join(work, name + ".elf.json")
    r1 = subprocess.run([PY, os.path.join(HERE, "elf_stack_frame.py"), "--dump-dir", comp["dump"],
                         "--vmfb", comp["vmfb"], "--out", elf], capture_output=True, text=True)
    con = os.path.join(work, name + ".contract.json")
    r2 = subprocess.run([PY, os.path.join(HERE, "make_contract.py"), "--mlir", mlir, "--vmfb", comp["vmfb"],
                         "--layout-ir", comp["layout_ir"], "--dump-dir", comp["dump"], "--triple", TRIPLE,
                         "--cpu", CPU, "--model-name", name, "--elf-analysis", elf, "--out", con],
                        capture_output=True, text=True)
    return {"elf_rc": r1.returncode, "make_contract_rc": r2.returncode,
            "stderr_tail": (r2.stderr or "").strip().splitlines()[-3:], "contract": con if os.path.isfile(con) else None}


def cmd_stats(a):
    ver = subprocess.run(["iree-compile", "--version"], capture_output=True, text=True).stdout
    out_dir = os.path.join(OUT, "compiler_statistics")
    os.makedirs(out_dir, exist_ok=True)
    rows = {}
    jobs = [(n, v[0]) for n, v in EVALUATED.items()] + [("dynamic", DYNAMIC_MLIR)]
    for name, src in jobs:
        w = os.path.join(a.work, name)
        mlir = mlir_in(src, w, name)
        rec = {"mlir_source": src, "mlir_sha256": sha256_file(mlir)}
        comp = compile_with_stats(mlir, w, name, "json")
        rec["json_invocation"] = {"rc": comp["rc"], "argv": comp["argv"],
                                  "vmfb_sha256": sha256_file(comp["vmfb"]) if os.path.isfile(comp["vmfb"]) else None,
                                  "vmfb_elf_formats": sorted(set(re.findall(rb"embedded-elf-[a-z0-9_]+",
                                                                             open(comp["vmfb"], "rb").read())
                                                               )) if os.path.isfile(comp["vmfb"]) else None}
        rec["json_invocation"]["vmfb_elf_formats"] = [x.decode() for x in rec["json_invocation"]["vmfb_elf_formats"] or []]
        st = json.load(open(comp["stats"])) if os.path.isfile(comp["stats"]) else None
        shutil.copyfile(comp["stats"], os.path.join(out_dir, "%s.stats.json" % name)) if st else None
        spec = spec_from(comp, mlir, w, name)
        rec["specification_same_invocation"] = {k: v for k, v in spec.items() if k != "contract"}
        if st:
            agg = st.get("stream-aggregate", {})
            rec["stats"] = {"constant_size": agg.get("global", {}).get("constant-size"),
                            "transient_memory_size": agg.get("execution", {}).get("transient-memory-size")}
        if spec["contract"]:
            c = json.load(open(spec["contract"]))
            shutil.copyfile(spec["contract"], os.path.join(out_dir, "%s.contract.json" % name))
            r = c["resources"]
            T = r.get("static_transient_bytes")
            O = r.get("static_external_output_bytes")
            rec["specification"] = {"bound_method": r.get("bound_method"), "bounded_bytes": r.get("bounded_bytes"),
                                    "static_per_call_bytes": r.get("static_per_call_bytes"),
                                    "C": r.get("module_resident_constant_bytes"),
                                    "T": T, "O": O, "unresolved_sizes": r.get("unresolved_sizes")}
            if st and name != "dynamic":
                rec["constant_size_equals_C"] = rec["stats"]["constant_size"] == r.get("module_resident_constant_bytes")
                rec["transient_equals_T_plus_O"] = (T is not None and O is not None
                                                    and rec["stats"]["transient_memory_size"] == T + O)
        if name == "dynamic":
            forms = {}
            for fmt in ("csv", "pretty"):
                cf = compile_with_stats(mlir, os.path.join(w, fmt), name, fmt)
                txt = open(cf["stats"], encoding="utf-8").read() if os.path.isfile(cf["stats"]) else None
                if txt is not None:
                    open(os.path.join(out_dir, "dynamic.stats.%s" % ("txt" if fmt == "pretty" else fmt)), "w").write(txt)
                forms[fmt] = {"rc": cf["rc"], "text_excerpt": (txt or "")[:900]}
            rec["other_forms"] = forms
            if forms.get("csv", {}).get("text_excerpt"):
                lines = [l for l in forms["csv"]["text_excerpt"].splitlines() if l and not l.startswith(";")]
                hdr_i = next((i for i, l in enumerate(lines) if "Transient Size" in l), None)
                if hdr_i is not None and hdr_i + 1 < len(lines):
                    cols = [c.strip('"') for c in lines[hdr_i].split(",")]
                    vals = lines[hdr_i + 1].split(",")
                    rec["csv_transient_size"] = int(vals[cols.index("Transient Size")])
            rec["json_transient_size"] = rec.get("stats", {}).get("transient_memory_size")
            pretty = forms.get("pretty", {}).get("text_excerpt") or ""
            m = re.search(r"Submissions:.*", pretty)
            rec["pretty_submissions_line"] = m.group(0).strip() if m else None
        rows[name] = rec
    four = [rows[n] for n in EVALUATED]
    doc = {"experiment": "E64", "part": "C", "plan": PLAN, "compiler_version": " ".join(ver.split()),
           "target": {"triple": TRIPLE, "cpu": CPU},
           "note": ("statistics, vmfb, layout IR and executable dump come from ONE iree-compile invocation per "
                    "model; the specification is generated from that invocation's outputs. vmfb and dump are not "
                    "stored (not byte-reproducible; the figures are -- E26e); the statistics files and the "
                    "specifications are."),
           "models": rows,
           "verdict": ("PASS" if all(r.get("constant_size_equals_C") and r.get("transient_equals_T_plus_O")
                                     for r in four) else "FAIL")}
    dump_json(doc, os.path.join(OUT, "compiler_statistics.json"))
    print(json.dumps({n: {k: r.get(k) for k in ("constant_size_equals_C", "transient_equals_T_plus_O",
                                                 "json_transient_size", "csv_transient_size", "pretty_submissions_line")}
                      for n, r in rows.items()}, indent=1))


# --------------------------------------------------------------------------- #
# D. guest computations
# --------------------------------------------------------------------------- #
def cmd_guest_prep(a):
    import numpy as np
    sys.path.insert(0, HERE)
    import e52_deepae_layers as e52
    os.makedirs(a.work, exist_ok=True)
    text = open(os.path.join(ROOT, "results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir"), encoding="utf-8").read()
    consts = e52.deployed_constants(text)
    layers = e52.layer_chain(text)
    np.savez(os.path.join(a.work, "consts.npz"), **{k.lstrip("%"): v for k, v in consts.items()})
    json.dump([{k: L[k] for k in ("index", "weight", "bias", "has_relu")} for L in layers],
              open(os.path.join(a.work, "layers.json"), "w"), indent=1)
    # inputs: the fetched ad01 windows, accepted only after a per-window hash match (plan SS1.D2)
    man = json.load(open(os.path.join(a.ad01, "manifest.json")))
    arr = np.load(os.path.join(a.ad01, "inputs", "ad01_windows_f32.npy"))
    ids, ok = [], 0
    for i, s in enumerate(man["samples"]):
        sid = s["source_file"].replace(".bin", "") + "_w%d" % s["window_index"]
        ids.append(sid)
        ok += hashlib.sha256(arr[i].tobytes()).hexdigest() == s["window_sha256"]
    if ok != len(man["samples"]):
        raise SystemExit("input windows do not match the manifest hashes (%d/%d)" % (ok, len(man["samples"])))
    np.save(os.path.join(a.work, "windows.npy"), arr)
    json.dump(ids, open(os.path.join(a.work, "window_ids.json"), "w"))
    e60 = ids.index(E60_SAMPLE)
    if hashlib.sha256(arr[e60].tobytes()).hexdigest() != E60_INPUT_SHA:
        raise SystemExit("E60 window hash mismatch")
    # target (IREE, cFS on the guest, E48) and reference (LiteRT on the guest, E61) outputs
    iree = json.load(open(os.path.join(ROOT, "results/e48_real_inputs_aarch64/b3_deepae/iree_cfs_aarch64.json")))
    iree_by = {r["sample_id"]: r["output"] for r in iree["results"]}
    with gzip.open(os.path.join(ROOT, "results/e61_reference_on_target/guest/oracle_b3_deepae.json.gz"), "rt") as fh:
        orc = json.load(fh)
    orc_rows = orc.get("results") or orc.get("samples")
    orc_by = {r["sample_id"]: r.get("output") or r.get("outputs") for r in orc_rows}
    json.dump({"iree_cfs_E48": [iree_by[i] for i in ids], "litert_guest_E61": [orc_by[i] for i in ids],
               "sources": {"iree": "results/e48_real_inputs_aarch64/b3_deepae/iree_cfs_aarch64.json",
                           "litert": "results/e61_reference_on_target/guest/oracle_b3_deepae.json.gz"}},
              open(os.path.join(a.work, "outputs.json"), "w"))
    shutil.copyfile(os.path.join(ROOT, "results/e60_deepae_layers_aarch64/guest/guest_outputs.json"),
                    os.path.join(a.work, "e60_guest_outputs.json"))
    shutil.copyfile(os.path.join(HERE, "e52_deepae_layers.py"), os.path.join(a.work, "e52_deepae_layers.py"))
    shutil.copyfile(os.path.abspath(__file__), os.path.join(a.work, "e64_aarch64_evidence.py"))
    manifest = {f: sha256_file(os.path.join(a.work, f)) for f in sorted(os.listdir(a.work))}
    json.dump(manifest, open(os.path.join(a.work, "bundle_manifest.json"), "w"), indent=1)
    print(json.dumps({"files": len(manifest), "windows": len(ids), "e60_index": e60}, indent=1))


def _rankdata(v):
    order = sorted(range(len(v)), key=lambda i: v[i])
    r = [0] * len(v)
    for pos, i in enumerate(order):
        r[i] = pos
    return r


def _auc(scores, labels):
    pos = [s for s, l in zip(scores, labels) if l == 1]
    neg = [s for s, l in zip(scores, labels) if l == 0]
    if not pos or not neg:
        return None
    wins = sum((p > n) + 0.5 * (p == n) for p in pos for n in neg)
    return wins / (len(pos) * len(neg))


def cmd_guest_run(a):
    """Runs INSIDE the AArch64 guest. Only numpy and the copied e52 module."""
    import numpy as np
    sys.path.insert(0, a.work)
    import e52_deepae_layers as e52
    W = lambda f: os.path.join(a.work, f)                                   # noqa: E731
    man = json.load(open(W("bundle_manifest.json")))
    bad = [f for f, h in man.items() if sha256_file(W(f)) != h]
    if bad:
        raise SystemExit("bundle files changed in transit: %s" % bad)
    z = np.load(W("consts.npz"))
    consts = {"%" + k: z[k] for k in z.files}
    layers = json.load(open(W("layers.json")))
    windows = np.load(W("windows.npy"))
    ids = json.load(open(W("window_ids.json")))
    # D1 -- the E60 window
    i60 = ids.index(E60_SAMPLE)
    x32 = windows[i60].reshape(1, -1).astype(np.float32)
    g = json.load(open(W("e60_guest_outputs.json")))
    tgt = [np.asarray(l["values"], dtype=np.float64) for l in sorted(g["layers"], key=lambda r: r["index"])]
    seq = e52.sequential_f32_forward(consts, layers, x32)
    f64 = e52.reference_forward(consts, layers, x32.astype(np.float64))
    rows = []
    for i, L in enumerate(layers):
        rows.append({"index": i, "has_relu": L["has_relu"],
                     "vs_sequential_f32": e52.violations(tgt[i], seq[i]),
                     "bit_identical_to_sequential_f32": bool(np.array_equal(
                         tgt[i].astype(np.float32), np.asarray(seq[i]).astype(np.float32).reshape(-1))),
                     "vs_float64": e52.violations(tgt[i], f64[i])})
    d1 = {"sample": E60_SAMPLE,
          "input_sha256": hashlib.sha256(windows[i60].tobytes()).hexdigest(),
          "target_layer_outputs_machine": g.get("machine"),
          "layers": rows,
          "violations_vs_sequential_f32": [r["vs_sequential_f32"]["violations"] for r in rows],
          "violations_vs_float64": [r["vs_float64"]["violations"] for r in rows],
          "bit_identical_to_sequential_f32": [r["bit_identical_to_sequential_f32"] for r in rows]}
    # D2 -- anomaly scores: mean squared reconstruction error per window, both paths
    outs = json.load(open(W("outputs.json")))
    X = windows.reshape(len(ids), -1).astype(np.float64)
    Yi = np.asarray(outs["iree_cfs_E48"], dtype=np.float64).reshape(len(ids), -1)
    Yl = np.asarray(outs["litert_guest_E61"], dtype=np.float64).reshape(len(ids), -1)
    si = ((X - Yi) ** 2).mean(axis=1)
    sl = ((X - Yl) ** 2).mean(axis=1)
    si32 = ((windows.reshape(len(ids), -1) - Yi.astype(np.float32)) ** 2).mean(axis=1, dtype=np.float32)
    sl32 = ((windows.reshape(len(ids), -1) - Yl.astype(np.float32)) ** 2).mean(axis=1, dtype=np.float32)
    rel = np.abs(si - sl) / np.maximum(np.abs(sl), 1e-300)
    labels = [1 if s.startswith("anomaly") else 0 for s in ids]
    ri, rl = _rankdata(list(si)), _rankdata(list(sl))
    discordant = sum(1 for p in range(len(ids)) for q in range(p + 1, len(ids))
                     if (si[p] - si[q]) * (sl[p] - sl[q]) < 0)
    d2 = {"score": "mean squared error between the input window and the model output (640 elements), float64",
          "windows": len(ids), "labels_from_ids": {"anomaly": sum(labels), "normal": len(labels) - sum(labels)},
          "scores_iree": [float(v) for v in si], "scores_litert": [float(v) for v in sl],
          "max_abs_score_difference": float(np.max(np.abs(si - sl))),
          "max_rel_score_difference": float(rel.max()),
          "median_score": float(np.median(sl)),
          "ranks_identical": ri == rl, "discordant_pairs": int(discordant),
          "pairs": len(ids) * (len(ids) - 1) // 2,
          "float32_scores_identical": bool(np.array_equal(si32, sl32)),
          "auc_iree": _auc(list(si), labels), "auc_litert": _auc(list(sl), labels),
          "auc_note": ("computed only to test whether the two paths give the same decision-level value; 34 windows "
                       "from the performance subset are not an evaluation set and this is not an accuracy claim (E45 SS5)")}
    doc = {"experiment": "E64", "part": "D", "machine": platform.machine(), "python": platform.python_version(),
           "numpy": np.__version__, "D1_e60_window_references": d1, "D2_anomaly_scores": d2}
    json.dump(doc, open(W("guest_result.json"), "w"), indent=1)
    print(json.dumps({"machine": doc["machine"], "seq": d1["violations_vs_sequential_f32"],
                      "f64": d1["violations_vs_float64"], "bitid": d1["bit_identical_to_sequential_f32"],
                      "ranks_identical": d2["ranks_identical"], "max_rel": d2["max_rel_score_difference"]}))


def cmd_collect(a):
    g = json.load(open(a.guest_json))
    if g.get("machine") != "aarch64":
        raise SystemExit("guest result was not produced on aarch64 (machine=%r)" % g.get("machine"))
    env = json.load(open(a.env_json))
    e60 = json.load(open(os.path.join(ROOT, "results/e60_deepae_layers_aarch64/layers.json")))
    host_seq = [r["vs_sequential_f32"]["violations"] for r in e60["layers"]]
    host_f64 = [r["vs_float64"]["violations"] for r in e60["layers"]]
    host_bit = [r["bit_identical_to_sequential_f32"] for r in e60["layers"]]
    d1 = g["D1_e60_window_references"]
    g["D1_e60_window_references"]["same_as_E60_host_computation"] = {
        "violations_vs_sequential_f32": d1["violations_vs_sequential_f32"] == host_seq,
        "violations_vs_float64": d1["violations_vs_float64"] == host_f64,
        "bit_identical_to_sequential_f32": d1["bit_identical_to_sequential_f32"] == host_bit,
        "E60_host_values": {"seq": host_seq, "f64": host_f64, "bit": host_bit}}
    g["plan"] = PLAN
    dump_json(g, os.path.join(OUT, "guest_computations.json"))
    env["plan"] = PLAN
    dump_json(env, os.path.join(OUT, "guest_environment.json"))
    print(json.dumps(g["D1_e60_window_references"]["same_as_E60_host_computation"], indent=1))


def cmd_summary(a):
    P = lambda f: json.load(open(os.path.join(OUT, f)))                    # noqa: E731
    pr, co, st, gc, ge = (P("probes.json"), P("corpus.json"), P("compiler_statistics.json"),
                          P("guest_computations.json"), P("guest_environment.json"))
    d1 = gc["D1_e60_window_references"]
    doc = {
        "experiment": "E64", "plan": PLAN,
        "A_probes": {"verdict": pr["verdict"], "control": pr["positive_control"]["path"],
                     "cells": {c["id"]: c["path"] for c in pr["cells"]},
                     "cells_with_deployable_header": pr["cells_with_deployable_header"]},
        "B_corpus": {"verdict": co["verdict"],
                     "aarch64_representations": co["B1_aarch64_corpus"]["aarch64_evaluated_revision_unedited_count"],
                     "aarch64_unclassified_total": co["B1_aarch64_corpus"]["aarch64_unclassified_total"],
                     "evaluated_figures_unchanged": co["B2_evaluated_regeneration"]["figures_unchanged"],
                     "evaluated_headers_byte_identical": co["B2_evaluated_regeneration"]["headers_byte_identical"]},
        "C_statistics": {"verdict": st["verdict"],
                         "per_model": {n: {k: r.get(k) for k in ("constant_size_equals_C", "transient_equals_T_plus_O")}
                                       for n, r in st["models"].items() if n != "dynamic"},
                         "dynamic": {k: st["models"]["dynamic"].get(k) for k in
                                     ("json_transient_size", "csv_transient_size", "pretty_submissions_line")}},
        "D_guest": {"machine": gc["machine"],
                    "final_layer_vs_sequential_f32": d1["violations_vs_sequential_f32"][-1],
                    "final_layer_vs_float64": d1["violations_vs_float64"][-1],
                    "layers_bit_identical_to_sequential_f32": sum(d1["bit_identical_to_sequential_f32"]),
                    "same_as_E60_host_computation": d1["same_as_E60_host_computation"],
                    "anomaly_scores": {k: gc["D2_anomaly_scores"][k] for k in
                                       ("max_rel_score_difference", "max_abs_score_difference", "ranks_identical",
                                        "discordant_pairs", "pairs", "auc_iree", "auc_litert")},
                    "environment": {k: ge.get(k) for k in ("smp", "mem_mib", "mem_total_kb", "nproc", "os_release",
                                                           "python", "ai_edge_litert", "iree_base_runtime", "numpy",
                                                           "host_qemu")}},
    }
    dump_json(doc, os.path.join(OUT, "summary.json"))
    print(json.dumps(doc, indent=1, ensure_ascii=False))


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("probes"); s.add_argument("--out", default=None)
    sub.add_parser("corpus")
    s = sub.add_parser("stats"); s.add_argument("--work", required=True)
    s = sub.add_parser("guest-prep"); s.add_argument("--work", required=True); s.add_argument("--ad01", required=True)
    s = sub.add_parser("guest-run"); s.add_argument("--work", required=True)
    s = sub.add_parser("collect"); s.add_argument("--guest-json", required=True); s.add_argument("--env-json", required=True)
    sub.add_parser("summary")
    a = ap.parse_args()
    {"probes": cmd_probes, "corpus": cmd_corpus, "stats": cmd_stats, "guest-prep": cmd_guest_prep,
     "guest-run": cmd_guest_run, "collect": cmd_collect, "summary": cmd_summary}[a.cmd](a)


if __name__ == "__main__":
    main()
