#!/usr/bin/env python3
"""E27 collector: run four information levels over the model set and the
perturbation conditions the plan fixed BEFORE measuring.

Levels (docs/plans/E27_mlir_contribution.md §3):
  (a) source tensor-sum        harness/e27_baseline_source_tensors.py
  (b) artifact only            harness/e27_baseline_vmfb_only.py
  (c) this repository          harness/make_contract.py (MLIR layout IR + artifact binding)
  (d) runtime HAL observation  measured peaks, per deployment

The axis that decides E27 is not accuracy. It is what each level does when it
CANNOT see what it needs. Every cell is classified into exactly one of:

  value              a number was produced
  explicit_refusal   no number, and the tool says why      <- honest
  silent_wrong       a number was produced that contradicts the reference, with
                     no refusal and no flag                <- DEFECT

`silent_wrong` is the count E27 reports. A level that refuses is not penalized
here; a level that answers wrongly without saying so is.

(d) is never the reference: E26 measured the same artifact's HAL peak varying by
up to 172.3x across deployments, so it is recorded as "observed in that
deployment" and nothing else.

Usage: python3 harness/e27_collect.py --out results/e27_baselines/summary.json
"""
import argparse
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
PY = sys.executable

# Reference bounded values come from the repository's stored contracts, which are
# themselves level (c) output -- so (c) is NOT scored against them for accuracy in
# the normal condition (that would be circular). They are used only to decide
# whether another level's number contradicts what the deployment actually needs,
# and for the drift condition the reference is stated separately below.
NORMAL = [
    ("mlp16k",      "results/e14_aarch64_qemu/models/mlp16k/m16k_baked.mlir",
     "results/e14_aarch64_qemu/x86_64/vmfb/mlp16k.vmfb",
     "results/e14_aarch64_qemu/x86_64/contracts/contract.mlp16k.x86_64.json"),
    ("conv2d",      "results/e14_aarch64_qemu/models/conv2d/conv2d_baked.mlir",
     "results/e14_aarch64_qemu/x86_64/vmfb/conv2d.vmfb",
     "results/e14_aarch64_qemu/x86_64/contracts/contract.conv2d.x86_64.json"),
    ("multibranch", "results/e14_aarch64_qemu/models/multibranch/multibranch_baked.mlir",
     "results/e14_aarch64_qemu/x86_64/vmfb/multibranch.vmfb",
     "results/e14_aarch64_qemu/x86_64/contracts/contract.multibranch.x86_64.json"),
    # cross-ISA is ordinary deployment variation, not a perturbation: the same three
    # models compiled for AArch64. If an information level is fragile to the target,
    # this is where it shows.
    ("mlp16k@aarch64", "results/e14_aarch64_qemu/models/mlp16k/m16k_baked.mlir",
     "results/e14_aarch64_qemu/aarch64/vmfb/mlp16k.vmfb",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.mlp16k.aarch64.json"),
    ("conv2d@aarch64", "results/e14_aarch64_qemu/models/conv2d/conv2d_baked.mlir",
     "results/e14_aarch64_qemu/aarch64/vmfb/conv2d.vmfb",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.conv2d.aarch64.json"),
    ("multibranch@aarch64", "results/e14_aarch64_qemu/models/multibranch/multibranch_baked.mlir",
     "results/e14_aarch64_qemu/aarch64/vmfb/multibranch.vmfb",
     "results/e14_aarch64_qemu/aarch64/contracts/contract.multibranch.aarch64.json"),
    # the two real MLPerf Tiny workloads E26e/E26f brought in (16 and 10 dispatches).
    # Every model above is synthetic; if the artifact-only level only matches on
    # hand-written models, these are the rows that say so.
    ("b2_resnet",  "results/e26_boundary_utility/mlperf_tiny_resnet_fixture/resnet.mlir",
     "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.vmfb",
     "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.contract.json"),
    ("b3_deepae",  "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae_infer.mlir",
     "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.vmfb",
     "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.contract.json"),
]
DYNAMIC = ("dynamic", "results/e14_aarch64_qemu/models/dynamic/dyn_batch_mlp.mlir",
           "results/e14_aarch64_qemu/x86_64/vmfb/dynamic.vmfb",
           "results/e14_aarch64_qemu/x86_64/contracts/contract.dynamic.x86_64.json")
DRIFT_DIR = "results/e27_baselines/iree310_mlp16k"


def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT, **kw)
    return r.returncode, r.stdout, r.stderr


def _tool_error(err):
    """An uncaught traceback or a missing input is THIS COLLECTOR failing, not the
    analyzer refusing. Counting the two as one would repeat, inside the experiment
    that measures it, the exact confusion D24/D25/D28 fixed three times: a tool that
    could not look reported as a tool that looked and found nothing. The first run of
    this collector did precisely that -- a mistyped model filename came back as
    `explicit_refusal` for level (a) on mlp16k."""
    return ("Traceback (most recent call last)" in err
            or "FileNotFoundError" in err or "No such file or directory" in err)


def _missing(*paths):
    return [p for p in paths if not os.path.exists(p if os.path.isabs(p)
                                                   else os.path.join(ROOT, p))]


def level_a(mlir):
    miss = _missing(mlir)
    if miss:
        return {"status": "tool_error", "bounded": None, "why": "missing input %s" % miss}
    rc, out, err = run([PY, os.path.join(HERE, "e27_baseline_source_tensors.py"), mlir])
    if rc != 0:
        return {"status": "tool_error" if _tool_error(err) else "explicit_refusal",
                "bounded": None, "why": err.strip()[-160:]}
    d = json.loads(out)
    if d["a_bounded"] is None:
        return {"status": "explicit_refusal", "bounded": None, "why": d["a_note"]}
    return {"status": "value", "bounded": d["a_bounded"], "why": d["a_note"],
            "detail": {"constants": d["a_constant_bytes"], "live": d["a_live_tensor_bytes"]}}


def level_b(vmfb):
    miss = _missing(vmfb)
    if miss:
        return {"status": "tool_error", "bounded": None, "why": "missing input %s" % miss}
    rc, out, err = run([PY, os.path.join(HERE, "e27_baseline_vmfb_only.py"), vmfb])
    if rc != 0:
        return {"status": "tool_error" if _tool_error(err) else "explicit_refusal",
                "bounded": None, "why": err.strip()[-160:]}
    d = json.loads(out)
    if d["b2_bounded"] is None:
        return {"status": "explicit_refusal", "bounded": None,
                "why": "unresolved=%s input_bytes=%s" % (d["alloca_unresolved"], d["input_bytes"])}
    return {"status": "value", "bounded": d["b2_bounded"],
            "why": "alloca_unresolved=%s" % (d["alloca_unresolved"],),
            "detail": {"constants": d["b2_constants"], "per_call": d["b2_per_call"]}}


def level_c_stored(contract_path):
    """Normal condition: the stored contract IS level (c)'s output, regenerated
    byte-identically by the regression suite on every run."""
    p = os.path.join(ROOT, contract_path)
    if not os.path.exists(p):
        return {"status": "explicit_refusal", "bounded": None, "why": "no stored contract"}
    d = json.load(open(p))
    r = d["resources"]
    if r.get("bound_method") == "NONE" or r.get("bounded_bytes") is None:
        return {"status": "explicit_refusal", "bounded": None,
                "why": "bound_method=%s unresolved=%s" % (r.get("bound_method"),
                                                          r.get("unresolved_sizes"))}
    return {"status": "value", "bounded": r["bounded_bytes"],
            "why": "bound_method=%s" % r["bound_method"],
            "detail": {"constants": r["module_resident_constant_bytes"],
                       "per_call": r["static_per_call_bytes"]}}


def level_c_live(mlir, vmfb, layout_ir, dump_dir, elf, tmp, extra=()):
    """Perturbation conditions: run the real production entry point and see what it does."""
    out = os.path.join(tmp, "e27_c.json")
    cmd = [PY, os.path.join(HERE, "make_contract.py"), "--mlir", mlir, "--vmfb", vmfb,
           "--layout-ir", layout_ir, "--dump-dir", dump_dir,
           "--triple", "x86_64-unknown-linux-gnu", "--cpu", "generic",
           "--model-name", "e27", "--elf-analysis", elf, "--out", out] + list(extra)
    miss = _missing(mlir, vmfb, layout_ir, dump_dir, elf)
    if miss:
        return {"status": "tool_error", "bounded": None, "why": "missing input %s" % miss}
    rc, so, se = run(cmd)
    if rc != 0 or not os.path.exists(out):
        return {"status": "tool_error" if _tool_error(se) else "explicit_refusal",
                "bounded": None, "why": (se.strip().splitlines() or ["rc=%d" % rc])[-1][:200]}
    d = json.load(open(out))
    r = d["resources"]
    if r.get("bounded_bytes") is None or r.get("bound_method") == "NONE":
        return {"status": "explicit_refusal", "bounded": None,
                "why": "bound_method=%s" % r.get("bound_method")}
    return {"status": "value", "bounded": r["bounded_bytes"],
            "why": "bound_method=%s notes=%d" % (r["bound_method"],
                                                 len(d["provenance"].get("notes") or [])),
            "detail": {"constants": r["module_resident_constant_bytes"],
                       "per_call": r["static_per_call_bytes"],
                       "notes": d["provenance"].get("notes")}}


# Level (d): HAL peaks already measured by E26/E26e/E26f. Recorded, never scored.
# The plan is explicit about why: E26 measured the same artifact's peak varying by up
# to 172.3x across deployments, so (d) answers "what this deployment did", not "what
# the model needs". A comparison that treated it as ground truth would be comparing
# every other level against a number that changes when you change the runtime.
D_SOURCES = {
    "mlp16k": [("native_c", "results/e26_boundary_utility/x86_64/native/mlp16k_B.jsonl"),
               ("pip_runtime", "results/e26_boundary_utility/x86_64/pip_runtime/mlp16k.json")],
    "conv2d": [("native_c", "results/e26_boundary_utility/x86_64/native/conv2d_B.jsonl"),
               ("pip_runtime", "results/e26_boundary_utility/x86_64/pip_runtime/conv2d.json")],
    "multibranch": [("native_c", "results/e26_boundary_utility/x86_64/native/multibranch_B.jsonl"),
                    ("pip_runtime", "results/e26_boundary_utility/x86_64/pip_runtime/multibranch.json")],
    "mlp16k@aarch64": [("qemu_user_aarch64", "results/e26_boundary_utility/aarch64/native/mlp16k_B.jsonl")],
    "conv2d@aarch64": [("qemu_user_aarch64", "results/e26_boundary_utility/aarch64/native/conv2d_B.jsonl")],
    "multibranch@aarch64": [("qemu_user_aarch64", "results/e26_boundary_utility/aarch64/native/multibranch_B.jsonl")],
    "b2_resnet": [("ext_summary", "results/e26_boundary_utility/x86_64/ext_b2_resnet/summary.json")],
    "b3_deepae": [("ext_summary", "results/e26_boundary_utility/x86_64/ext_b3_deepae/summary.json")],
}


def level_d(model):
    """Observed HAL peaks per deployment. Returns a list, never a single number --
    a single number would imply there is one."""
    seen = []
    for deployment, rel in D_SOURCES.get(model, []):
        p = os.path.join(ROOT, rel)
        if not os.path.exists(p):
            continue
        if p.endswith(".jsonl"):
            for line in open(p):
                line = line.strip()
                if line.startswith("{") and '"run"' in line:
                    d = json.loads(line)
                    if d.get("hal_device_bytes_peak") is not None:
                        seen.append({"deployment": deployment, "peak": d["hal_device_bytes_peak"]})
        else:
            d = json.load(open(p))
            if "cells" in d:                       # ext summary: several deployments at once
                for c in d["cells"]:
                    if c.get("hal_device_bytes_peak") is not None:
                        seen.append({"deployment": c["runner"], "peak": c["hal_device_bytes_peak"]})
            else:
                # runtime_peak_check writes `device_bytes_peak`; the native runner and
                # the ext summaries write `hal_device_bytes_peak`. Reading only one of
                # the two names silently drops a whole deployment from this column --
                # which is how the first run of this collector reported mlp16k with the
                # native peak alone and no pip peak beside it.
                peak = d.get("hal_device_bytes_peak", d.get("device_bytes_peak"))
                if peak is not None:
                    seen.append({"deployment": deployment, "peak": peak})
    uniq, out = set(), []
    for x in seen:
        k = (x["deployment"], x["peak"])
        if k not in uniq:
            uniq.add(k)
            out.append(x)
    return out


def classify(cell, reference, direction):
    """direction: 'under' means a value below the reference is a silent under-estimate."""
    if cell["status"] != "value" or reference is None:
        return cell["status"]
    if direction == "under" and cell["bounded"] < reference:
        return "silent_wrong"
    return "value"


def main():
    import shutil
    import tempfile
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e27_baselines/summary.json")
    a = ap.parse_args()
    cells, tmp = [], tempfile.mkdtemp(prefix="e27_")
    try:
        # ---- condition 1: normal -------------------------------------------------
        for name, mlir, vmfb, contract in NORMAL:
            ref = level_c_stored(contract)["bounded"]
            for lvl, cell in (("a", level_a(mlir)), ("b", level_b(vmfb)),
                              ("c", level_c_stored(contract))):
                row = {"condition": "normal", "model": name, "level": lvl,
                       "reference_bounded": ref, "bounded": cell["bounded"],
                       "status": cell["status"],
                       "verdict": classify(cell, ref, "under"), "why": cell["why"]}
                if cell["bounded"] and ref:
                    row["over_reference"] = round(cell["bounded"] / ref, 4)
                cells.append(row)
            obs = level_d(name)
            cells.append({"condition": "normal", "model": name, "level": "d",
                          "reference_bounded": ref, "bounded": None,
                          "status": "observed" if obs else "not_measured",
                          "verdict": "not_scored", "observed_peaks": obs,
                          "why": "deployment-dependent; E26 measured up to 172.3x spread"})

        # ---- condition 2: compiler version drift (IREE 3.10 artifact) -----------
        # Reference: the 3.11 contract for the same model. The plan states plainly
        # that the 3.10 artifact's own "true" value is not established -- what IS
        # established is that a per-call figure of 36 B is impossible for a 9->16384->2
        # MLP whose hidden layer alone is 65,536 B. So the reference is used only to
        # decide "silently far below what this model can possibly need".
        ref311 = level_c_stored(NORMAL[0][3])["bounded"]
        d = os.path.join(ROOT, DRIFT_DIR)
        drift_vmfb = os.path.join(d, "mlp16k.vmfb")
        cells.append(dict({"condition": "version_drift", "model": "mlp16k", "level": "b",
                           "reference_bounded": ref311}, **{
            k: v for k, v in _flat(level_b(drift_vmfb), ref311).items()}))
        cells.append(dict({"condition": "version_drift", "model": "mlp16k", "level": "c",
                           "reference_bounded": ref311}, **{
            k: v for k, v in _flat(level_c_live(
                os.path.join(ROOT, NORMAL[0][1]), drift_vmfb,
                os.path.join(d, "mlp16k.layout_ir.txt"), os.path.join(d, "dump"),
                os.path.join(d, "elf.json"), tmp), ref311).items()}))
        # (a) reads only the source, which the compiler version cannot touch
        cells.append(dict({"condition": "version_drift", "model": "mlp16k", "level": "a",
                           "reference_bounded": ref311},
                          **{k: v for k, v in _flat(level_a(os.path.join(ROOT, NORMAL[0][1])),
                                                    ref311).items()}))

        # ---- condition 3: dumps missing ----------------------------------------
        # Only (c) consumes compiler dumps, so this condition is about (c) alone:
        # does it produce a bound when the evidence it is supposed to bind to is gone?
        name, mlir, vmfb, contract = NORMAL[0]
        ref = level_c_stored(contract)["bounded"]
        empty = os.path.join(tmp, "empty_dump")
        os.makedirs(empty, exist_ok=True)
        inv = json.load(open(os.path.join(
            ROOT, "results/e14_aarch64_qemu/x86_64/vmfb/mlp16k.invocation.json")))
        cells.append(dict({"condition": "dump_missing", "model": name, "level": "c",
                           "reference_bounded": ref},
                          **{k: v for k, v in _flat(level_c_live(
                              os.path.join(ROOT, mlir), os.path.join(ROOT, vmfb),
                              inv["layout_ir"], empty,
                              "results/e14_aarch64_qemu/x86_64/elf/mlp16k.elf_analysis.json",
                              tmp), ref).items()}))

        # ---- condition 4: dynamic shape (correct answer: every level refuses) ---
        name, mlir, vmfb, contract = DYNAMIC
        for lvl, cell in (("a", level_a(mlir)), ("b", level_b(vmfb)),
                          ("c", level_c_stored(contract))):
            cells.append({"condition": "dynamic_shape", "model": name, "level": lvl,
                          "reference_bounded": None, "bounded": cell["bounded"],
                          "status": cell["status"],
                          "verdict": "explicit_refusal" if cell["status"] != "value"
                                     else "silent_wrong",
                          "why": cell["why"]})
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    per_level = {}
    for lv in ("a", "b", "c", "d"):
        mine = [c for c in cells if c["level"] == lv]
        per_level[lv] = {
            "cells": len(mine),
            "value": sum(1 for c in mine if c["verdict"] == "value"),
            "explicit_refusal": sum(1 for c in mine if c["verdict"] == "explicit_refusal"),
            "silent_wrong": sum(1 for c in mine if c["verdict"] == "silent_wrong"),
            "tool_error": sum(1 for c in mine if c["verdict"] == "tool_error"),
        }
    summary = {"levels": {"a": "source tensor-sum", "b": "artifact only",
                          "c": "this repository (MLIR layout IR + artifact binding)",
                          "d": "runtime HAL observation -- deployment-dependent, never a reference"},
               "conditions": ["normal", "version_drift", "dump_missing", "dynamic_shape"],
               "cells": cells, "per_level": per_level,
               "headline_silent_wrong": {lv: per_level[lv]["silent_wrong"] for lv in per_level},
               "tool_errors": [c for c in cells if c["verdict"] == "tool_error"],
               "collection_clean": not any(c["verdict"] == "tool_error" for c in cells)}
    p = os.path.join(ROOT, a.out)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w").write(json.dumps(summary, indent=1) + "\n")
    for c in cells:
        print("%-14s %-12s (%s) %-16s %s" % (c["condition"], c["model"], c["level"],
                                             c["verdict"], str(c["bounded"])))
    print("\nsilent_wrong per level:", summary["headline_silent_wrong"])
    if not summary["collection_clean"]:
        print("COLLECTION NOT CLEAN -- tool errors present, these are NOT refusals:")
        for c in summary["tool_errors"]:
            print("  ", c["condition"], c["model"], "(%s)" % c["level"], c["why"][:120])
    print("wrote", p)


def _flat(cell, ref):
    return {"bounded": cell["bounded"], "status": cell["status"],
            "verdict": classify(cell, ref, "under"), "why": cell["why"]}


if __name__ == "__main__":
    main()
