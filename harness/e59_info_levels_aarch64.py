#!/usr/bin/env python3
"""E59: the information-level comparison of E35/E27, redone on the evaluation target's artifacts.

Plan: docs/plans/E59_info_levels_aarch64.md (committed before measurement, 7acc660).

Part A (no recompilation) -- the four AArch64 artifacts the manuscript's component table is
built from.  One implementation: `e35_baseline_policy_matrix.collect()` is called with the
AArch64 model list, so the comparison cannot drift from the one E35 ran (E44: a second copy
of the same comparison is how two answers to one question appear).  The 24 policy cells stay
a COROLLARY of the three-figure agreement (D72), never an independent measurement.

Part B (compiler drift) -- the same four input MLIRs compiled for aarch64/cortex-a53 by the
drift compiler (IREE 3.10.0rc20260107 @ ae97779, the revision of E27's x86-64 drift
artifact), ONE iree-compile invocation per model (discipline 7), and a CONTROL compile of
the identical command with the repository compiler so that the drift cells are compared
against a like-for-like command rather than against whatever flags the archived build used.

Cells are classified value / explicit_refusal / tool_error / impossible_value.  The
impossibility floor is version-independent -- per_call < I + O, the interface tensor bytes
computed from shapes and dtypes -- because E27 itself wrote that the 3.11 figure is not
known to be the right answer for a 3.10 artifact.  The 3.11 figure is carried beside each
cell as `differs_from_311_reference`, and never promoted to a verdict.

Usage:
  python3 harness/e59_info_levels_aarch64.py --part A
  python3 harness/e59_info_levels_aarch64.py --part B --iree310 <venv>/bin/iree-compile --work <dir>
"""
import argparse
import gzip
import hashlib
import json
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import e35_baseline_policy_matrix as e35                          # noqa: E402

PY = sys.executable
OUT_DIR = "results/e59_info_levels_aarch64"
PLAN = "docs/plans/E59_info_levels_aarch64.md (committed before measurement, 7acc660)"
TRIPLE, CPU = "aarch64-unknown-linux-gnu", "cortex-a53"
ELIDE = 16  # harness/e14_matrix.py

# (name, input mlir [may be .gz], AArch64 vmfb, AArch64 contract) -- the artifacts behind the
# manuscript's component table (E36b, E32, E53).
MODELS = [
    ("b2_resnet", "results/e36b_aarch64_models/b2_resnet/b2_resnet.mlir",
     "results/e36b_aarch64_models/b2_resnet/b2_resnet.vmfb",
     "results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json"),
    ("b3_deepae", "results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir",
     "results/e36b_aarch64_models/b3_deepae/b3_deepae.vmfb",
     "results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json"),
    ("smartcam", "results/p1_smartcam_feasibility/build/smartcam.mlir.gz",
     "results/e32_smartcam_aarch64/build/smartcam.vmfb",
     "results/e32_smartcam_aarch64/build/smartcam.contract.json"),
    ("wgan", "results/e53_wgan_aarch64/build/aarch64/wgan.mlir",
     "results/e53_wgan_aarch64/build/aarch64/wgan.vmfb",
     "results/e53_wgan_aarch64/build/aarch64/wgan.contract.json"),
]

DTYPE_BYTES = {"f32": 4, "f16": 2, "i32": 4, "i8": 1, "f64": 8, "i64": 8}


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def interface_floor(contract):
    """I + O from shapes and dtypes: a lower bound on any per-call figure that no compiler
    revision can move, because the entry point receives and returns exactly these tensors."""
    tot = 0
    for d in contract["interface"]["inputs"] + contract["interface"]["outputs"]:
        n = 1
        for s in d["shape"]:
            n *= int(s)
        tot += n * DTYPE_BYTES[d["dtype"]]
    return tot


def part_a():
    doc = e35.collect([(n, v, c) for n, _m, v, c in MODELS], experiment="E59 Part A", plan=PLAN)
    # binding check: the vmfb analysed IS the artifact the contract names (else the
    # comparison would be between two different files and "agree" would mean nothing)
    for n, _m, v, c in MODELS:
        con = json.load(open(os.path.join(ROOT, c), encoding="utf-8"))
        doc["models"][n]["artifact_matches_contract"] = (
            sha256_file(os.path.join(ROOT, v)) == con["artifact"]["sha256"])
    doc["totals"]["artifacts_matching_contract"] = sum(
        1 for m in doc["models"].values() if m.get("artifact_matches_contract"))
    doc["target"] = TRIPLE
    doc["corollary_note"] = ("24 policy cells agree BY CONSTRUCTION once the three figures agree "
                             "(D72: the collector feeds both levels the same numbers and the same "
                             "bound_method); the measurements are the per-model agreements")
    return doc


def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    return r.returncode, r.stdout, r.stderr


def tool_error(err):
    return ("Traceback (most recent call last)" in err or "FileNotFoundError" in err
            or "No such file or directory" in err)


def compile_one(compiler, mlir_src, work, name):
    """ONE invocation: vmfb + layout IR (stderr) + dump dir.  The input keeps its original
    basename, because the dump-dir filename check (D10) and the vmfb symbol names both carry it."""
    os.makedirs(work, exist_ok=True)
    mlir = os.path.join(work, name + ".mlir")
    if mlir_src.endswith(".gz"):
        with gzip.open(os.path.join(ROOT, mlir_src), "rb") as f, open(mlir, "wb") as g:
            shutil.copyfileobj(f, g)
    else:
        shutil.copyfile(os.path.join(ROOT, mlir_src), mlir)
    vmfb = os.path.join(work, name + ".vmfb")
    ir = os.path.join(work, name + ".layout_ir.txt")
    dump = os.path.join(work, "dump")
    if os.path.exists(dump):
        shutil.rmtree(dump)
    os.makedirs(dump)
    cmd = [compiler, mlir, "--iree-hal-target-backends=llvm-cpu",
           "--iree-llvmcpu-target-triple=" + TRIPLE, "--iree-llvmcpu-target-cpu=" + CPU,
           "--mlir-print-ir-after=iree-stream-layout-slices",
           "--mlir-elide-elementsattrs-if-larger=%d" % ELIDE,
           "--iree-hal-dump-executable-files-to=" + dump, "-o", vmfb]
    with open(ir, "w") as err:
        r = subprocess.run(cmd, stderr=err, stdout=subprocess.PIPE, text=True)
    ver = run([compiler, "--version"])[1]
    return {"rc": r.returncode, "mlir": mlir, "vmfb": vmfb, "layout_ir": ir, "dump": dump,
            "argv": [os.path.basename(cmd[0])] + [a.replace(work + "/", "") for a in cmd[1:]],
            "compiler_version": " ".join(ver.split()),
            "mlir_sha256": sha256_file(mlir),
            "vmfb_sha256": sha256_file(vmfb) if os.path.exists(vmfb) else None,
            "vmfb_bytes": os.path.getsize(vmfb) if os.path.exists(vmfb) else None}


def level_c(comp, name, entry, work):
    so = [f for f in os.listdir(comp["dump"]) if f.endswith(".so")]
    if len(so) != 1:
        return {"status": "tool_error", "why": "expected one .so in dump, found %d" % len(so)}
    elf_json = os.path.join(work, name + ".elf.json")
    rc, _o, e = run([PY, os.path.join(HERE, "elf_stack_frame.py"), "--dump-dir", comp["dump"],
                     "--vmfb", comp["vmfb"], "--out", elf_json])
    if rc != 0:
        return {"status": "tool_error" if tool_error(e) else "explicit_refusal",
                "why": "elf_stack_frame: " + (e.strip().splitlines() or ["rc=%d" % rc])[-1][:200]}
    out = os.path.join(work, name + ".contract.json")
    rc, _o, e = run([PY, os.path.join(HERE, "make_contract.py"), "--mlir", comp["mlir"],
                     "--vmfb", comp["vmfb"], "--layout-ir", comp["layout_ir"], "--dump-dir", comp["dump"],
                     "--triple", TRIPLE, "--cpu", CPU, "--model-name", name, "--entry", entry,
                     "--elf-analysis", elf_json, "--out", out])
    if rc != 0 or not os.path.exists(out):
        return {"status": "tool_error" if tool_error(e) else "explicit_refusal",
                "why": (e.strip().splitlines() or ["rc=%d" % rc])[-1][:300]}
    d = json.load(open(out))
    r = d["resources"]
    if r.get("bounded_bytes") is None or r.get("bound_method") == "NONE":
        return {"status": "explicit_refusal", "why": "bound_method=%s" % r.get("bound_method")}
    return {"status": "value", "bounded": r["bounded_bytes"], "per_call": r["static_per_call_bytes"],
            "constants": r["module_resident_constant_bytes"],
            "kernel_stack": r.get("kernel_task_stack_invocation_bytes"),
            "constants_confirmation_state": r.get("constants_confirmation_state"),
            "notes": d["provenance"].get("notes") or []}


def level_b(vmfb):
    rc, o, e = run([PY, os.path.join(HERE, "e27_baseline_vmfb_only.py"), vmfb])
    if rc != 0:
        return {"status": "tool_error" if tool_error(e) else "explicit_refusal", "why": e.strip()[-200:]}
    d = json.loads(o)
    if d.get("b2_bounded") is None:
        return {"status": "explicit_refusal",
                "why": "unresolved=%s input_bytes=%s" % (d.get("alloca_unresolved"), d.get("input_bytes"))}
    return {"status": "value", "bounded": d["b2_bounded"], "per_call": d["b2_per_call"],
            "constants": d["b2_constants"], "why": "alloca_unresolved=%s" % (d.get("alloca_unresolved"),)}


def level_bprime(vmfb):
    rc, o, e = run([PY, os.path.join(HERE, "e27_baseline_vmfb_only_hardened.py"), vmfb])
    if rc != 0:
        return {"status": "tool_error" if tool_error(e) else "explicit_refusal", "why": e.strip()[-200:]}
    d = json.loads(o)
    if d.get("bl1_bounded") is None:
        # the hardened analyzer names its refusal in `refusal_code` + `refusal`; the first run of
        # this collector read a key it does not emit and wrote `refusals=None` -- a refusal whose
        # reason was not read is recorded here with the reason, never as a reasonless one (D51)
        return {"status": "explicit_refusal", "refusal_code": d.get("refusal_code"),
                "why": "%s: %s" % (d.get("refusal_code"), (d.get("refusal") or "")[:220])}
    return {"status": "value", "bounded": d["bl1_bounded"], "per_call": d["bl1_per_call"],
            "constants": d["bl1_constants"], "why": "refusals=%s" % (d.get("refusals"),)}


def classify(cell, floor, ref):
    if cell["status"] != "value":
        return cell["status"]
    if cell["per_call"] is None or cell["per_call"] < floor or (cell.get("constants") or 0) < 0:
        return "impossible_value"
    return "value"


def reduce_dump(src, dst):
    """Keep what the contract generator reads (executable .mlir sources and the embedded .so);
    drop .o/.bc/.s/.ll, which are large and which E26c showed are not needed to regenerate."""
    if os.path.exists(dst):
        shutil.rmtree(dst)
    os.makedirs(dst)
    for f in sorted(os.listdir(src)):
        if f.endswith((".mlir", ".so")):
            shutil.copyfile(os.path.join(src, f), os.path.join(dst, f))


def part_b(iree310, work_root):
    cells, per_model = [], {}
    for name, mlir_src, _v, contract_p in MODELS:
        con = json.load(open(os.path.join(ROOT, contract_p), encoding="utf-8"))
        floor = interface_floor(con)
        ref = {"bounded": con["resources"]["bounded_bytes"],
               "per_call": con["resources"]["static_per_call_bytes"],
               "constants": con["resources"]["module_resident_constant_bytes"]}
        entry = con["model"].get("entry") or "infer"
        pm = {"interface_floor_I_plus_O": floor, "reference_311_contract": ref}
        for rev, compiler in (("control_311", "iree-compile"), ("drift_310", iree310)):
            work = os.path.join(work_root, name, rev)
            comp = compile_one(compiler, mlir_src, work, name)
            rec = {"compile": {k: comp[k] for k in ("rc", "argv", "compiler_version", "mlir_sha256",
                                                       "vmfb_sha256", "vmfb_bytes")}}
            rec["compile"]["mlir_matches_contract"] = comp["mlir_sha256"] == con["provenance"]["mlir_sha256"]
            if comp["rc"] != 0:
                rec["levels"] = {"c": {"status": "explicit_refusal", "why": "iree-compile rc=%d" % comp["rc"]}}
                pm[rev] = rec
                continue
            lv = {"c": level_c(comp, name, entry, work), "b": level_b(comp["vmfb"]),
                  "b_prime": level_bprime(comp["vmfb"])}
            for k, cell in lv.items():
                cell["verdict"] = classify(cell, floor, ref)
                if cell["status"] == "value":
                    cell["differs_from_311_reference"] = any(
                        cell.get(f) != ref[f] for f in ("bounded", "per_call", "constants"))
                if rev == "drift_310":
                    cells.append({"model": name, "level": k, **{x: cell.get(x) for x in
                                  ("status", "verdict", "bounded", "per_call", "constants", "why",
                                   "differs_from_311_reference")}})
            rec["levels"] = lv
            pm[rev] = rec
            if rev == "drift_310":
                keep = os.path.join(ROOT, OUT_DIR, "drift_310", name)
                os.makedirs(keep, exist_ok=True)
                shutil.copyfile(comp["vmfb"], os.path.join(keep, name + ".vmfb"))
                with open(comp["layout_ir"], "rb") as f, gzip.open(
                        os.path.join(keep, name + ".layout_ir.txt.gz"), "wb", compresslevel=9) as g:
                    shutil.copyfileobj(f, g)
                reduce_dump(comp["dump"], os.path.join(keep, "dump"))
                for extra in (name + ".elf.json", name + ".contract.json"):
                    if os.path.exists(os.path.join(work, extra)):
                        shutil.copyfile(os.path.join(work, extra), os.path.join(keep, extra))
        # control: does the identical command reproduce the archived contract's three figures?
        c_ctl = (pm.get("control_311") or {}).get("levels", {}).get("c", {})
        pm["control_reproduces_archived_figures"] = (
            c_ctl.get("status") == "value"
            and all(c_ctl.get(f) == ref[f] for f in ("bounded", "per_call", "constants")))
        per_model[name] = pm
    per_level = {}
    for lvl in ("c", "b", "b_prime"):
        mine = [c for c in cells if c["level"] == lvl]
        per_level[lvl] = {v: sum(1 for c in mine if c["verdict"] == v)
                          for v in ("value", "explicit_refusal", "tool_error", "impossible_value")}
    return {"per_model": per_model, "drift_cells": cells, "per_level": per_level,
            "collection_clean": all(c["verdict"] != "tool_error" for c in cells),
            "controls_reproducing": sum(1 for m in per_model.values()
                                        if m.get("control_reproduces_archived_figures"))}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--part", choices=["A", "B"], required=True)
    ap.add_argument("--iree310", help="iree-compile of IREE 3.10.0rc20260107 (Part B)")
    ap.add_argument("--work", help="scratch dir for Part B compiles")
    ap.add_argument("--out", help="write the part's JSON here instead of the committed record "
                                  "(regression guards re-run into a temp dir, never over the record)")
    a = ap.parse_args()
    os.makedirs(os.path.join(ROOT, OUT_DIR), exist_ok=True)
    if a.part == "A":
        doc = part_a()
        out = os.path.join(ROOT, OUT_DIR, "part_a.json")
    else:
        if not (a.iree310 and a.work):
            ap.error("--part B needs --iree310 and --work")
        doc = {"experiment": "E59 Part B", "plan": PLAN, "target": TRIPLE, "cpu": CPU,
               **part_b(a.iree310, a.work)}
        out = os.path.join(ROOT, OUT_DIR, "part_b.json")
    if a.out:
        out = a.out
    with open(out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, ensure_ascii=False)
    print(json.dumps(doc.get("totals") or {"per_level": doc.get("per_level"),
                                             "controls_reproducing": doc.get("controls_reproducing"),
                                             "collection_clean": doc.get("collection_clean")}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
