#!/usr/bin/env python3
"""E29 -- conditional contract: measure which deployment property selects the
`stream.resource.try_map` arm, and whether the two-arm model is exact.

E26 (docs/EVIDENCE_v0.25_E26.md) showed that `bounded = per_call + constants` is
the maximum over the two arms IREE emits for module-resident constants, so
soundness is structural while *tightness* follows the arm the deployment lands
on -- up to 172.30x apart across deployments of the SAME vmfb (E26f).  E26 ruled
out four candidate determinants and recorded the real one as UNDETERMINED.

This collector drives harness/e29_align_probe.c, which loads the same file bytes
from pointers of controlled 64-byte alignment class and reports the HAL peak
immediately after module append -- before any input buffer or inference, so the
number is the constant block alone.  For every (model, delta) cell it records the
raw peak and compares it against the contract's own `constants` value.

Two things are checked, both stated before measurement:

  D1 (dichotomy)   every successful append lands on exactly one of
                   peak == 0  (map arm)  or  peak == contract constants (copy arm).
                   Any third value refutes the two-arm model -- a partial mapping
                   would show up here and nowhere else.
  D2 (determinant) map arm  <=>  pointer is 64-byte aligned.

A cell whose append fails is NOT a violation of either: the FlatBuffer verifier
independently requires its own alignment of the module header, and refusing to
load is neither arm.  Those cells are reported separately as `append_failed`.

Usage:
  python3 harness/e29_collect.py [--out results/e29_conditional_contract/align_sweep.json]
Environment: IREE_SRC / IREE_BUILD as in native/build.sh; CC (default gcc).
"""
import argparse
import json
import os
import subprocess
import shutil
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

# (name, vmfb, contract) -- every pair is an archived single-invocation artifact
# plus the contract produced by that same iree-compile call (discipline 7).
MODELS = [
    ("mlp16k",      "results/e14_aarch64_qemu/x86_64/vmfb/mlp16k.vmfb",
                    "results/e14_aarch64_qemu/x86_64/contracts/contract.mlp16k.x86_64.json"),
    ("conv2d",      "results/e14_aarch64_qemu/x86_64/vmfb/conv2d.vmfb",
                    "results/e14_aarch64_qemu/x86_64/contracts/contract.conv2d.x86_64.json"),
    ("multibranch", "results/e14_aarch64_qemu/x86_64/vmfb/multibranch.vmfb",
                    "results/e14_aarch64_qemu/x86_64/contracts/contract.multibranch.x86_64.json"),
    ("canonical",   "results/e25_equivalence/build/model_canonical.vmfb",
                    "results/e25_equivalence/build/model_canonical.contract.json"),
    ("multiout",    "results/e26c_multiout/multiout.vmfb",
                    "results/e26c_multiout/multiout.contract.json"),
    ("manyconst31", "results/e24c_manyconst31/manyconst31.vmfb",
                    "results/e24c_manyconst31/manyconst31.contract.json"),
    ("b2_resnet",   "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.vmfb",
                    "results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.contract.json"),
    ("b3_deepae",   "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.vmfb",
                    "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.contract.json"),
]

# 0 and 64 are aligned; 8/16/32/128+8 are not.  8-byte multiples only: the
# FlatBuffer verifier rejects anything less aligned than that before the HAL is
# reached, so finer deltas measure the verifier, not the try_map arm.
DELTAS = [0, 8, 16, 32, 64, 128, 136, 192]


def build_probe(out_bin):
    iree_src = os.environ.get("IREE_SRC", "/tmp/iree-src")
    build = os.environ.get("IREE_BUILD", os.path.join(iree_src, "build-rt"))
    cc = os.environ.get("CC", "gcc")
    if not os.path.isdir(os.path.join(build, "runtime")):
        return None, "IREE runtime build not found at %s (set IREE_SRC/IREE_BUILD)" % build
    libs = subprocess.run(["find", os.path.join(build, "runtime"), "-name", "*.a"],
                          capture_output=True, text=True).stdout.split()
    for extra in ("build_tools/third_party/flatcc/libflatcc_parsing.a",
                  "build_tools/third_party/flatcc/libflatcc_runtime.a",
                  "build_tools/third_party/printf/libprintf_printf.a"):
        libs.append(os.path.join(build, extra))
    cmd = [cc, "-O2", "-std=gnu11",
           "-I", os.path.join(iree_src, "runtime", "src"),
           "-I", os.path.join(build, "runtime", "src"),
           "-DIREE_ALLOCATOR_SYSTEM_CTL=iree_allocator_libc_ctl",
           os.path.join(HERE, "e29_align_probe.c"), "-o", out_bin,
           "-Wl,--start-group"] + libs + ["-Wl,--end-group", "-lm", "-ldl", "-lpthread"]
    p = subprocess.run(cmd, capture_output=True, text=True)
    if p.returncode != 0:
        return None, "probe build failed: %s" % p.stderr[-2000:]
    return out_bin, None


def contract_numbers(path):
    with open(path) as fh:
        c = json.load(fh)
    r = c.get("resources", c)
    mem = r.get("memory", r)
    def pick(*keys):
        for k in keys:
            for src in (c, r, mem):
                if isinstance(src, dict) and k in src and isinstance(src[k], int):
                    return src[k]
        return None
    return {
        "per_call": pick("static_per_call_bytes", "per_call_bytes"),
        "constants": pick("module_resident_constant_bytes", "constant_bytes"),
        "bounded": pick("bounded_bytes"),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(ROOT, "results/e29_conditional_contract/align_sweep.json"))
    ap.add_argument("--probe-bin", default=None)
    a = ap.parse_args()

    probe = a.probe_bin
    build_err = None
    tmpdir = None
    if not probe:
        os.makedirs(os.path.dirname(a.out), exist_ok=True)
        # the probe binary is a build artifact, not evidence: build it outside
        # the results tree so the committed fixture stays the measurements only.
        tmpdir = tempfile.mkdtemp(prefix="e29probe-")
        probe, build_err = build_probe(os.path.join(tmpdir, "e29_align_probe"))
    if not probe:
        print("SKIP: %s" % build_err, file=sys.stderr)
        json.dump({"skipped": build_err}, open(a.out, "w"), indent=1)
        return 0

    cells, notes = [], []
    for name, vmfb, contract in MODELS:
        vp, cp = os.path.join(ROOT, vmfb), os.path.join(ROOT, contract)
        if not (os.path.exists(vp) and os.path.exists(cp)):
            notes.append("missing input for %s" % name)
            continue
        nums = contract_numbers(cp)
        p = subprocess.run([probe, vp] + [str(d) for d in DELTAS], capture_output=True, text=True)
        for line in p.stdout.splitlines():
            line = line.strip()
            if not line.startswith("{"):
                continue
            rec = json.loads(line)
            rec["model"] = name
            rec["contract_constants"] = nums["constants"]
            rec["contract_per_call"] = nums["per_call"]
            rec["contract_bounded"] = nums["bounded"]
            rec["aligned64"] = (rec["blob_ptr_mod64"] == 0)
            if not rec["append_ok"]:
                rec["arm"] = "append_failed"
            elif rec["init_peak"] == 0:
                rec["arm"] = "map"
            elif rec["init_peak"] == nums["constants"]:
                rec["arm"] = "copy"
            else:
                rec["arm"] = "OTHER"
            cells.append(rec)
        if p.returncode != 0:
            notes.append("%s: probe rc=%d %s" % (name, p.returncode, p.stderr[-300:]))

    graded = [c for c in cells if c["arm"] != "append_failed"]
    d1_violations = [c for c in graded if c["arm"] == "OTHER"]
    d2_violations = [c for c in graded
                     if (c["arm"] == "map") != c["aligned64"]]
    summary = {
        "tool": "harness/e29_collect.py",
        "probe": "harness/e29_align_probe.c",
        "deltas": DELTAS,
        "models": [m[0] for m in MODELS],
        "cells": len(cells),
        "graded_cells": len(graded),
        "append_failed": len(cells) - len(graded),
        "arms": {arm: sum(1 for c in graded if c["arm"] == arm) for arm in ("map", "copy", "OTHER")},
        "D1_dichotomy_holds": not d1_violations,
        "D1_violations": d1_violations,
        "D2_alignment_is_determinant": not d2_violations,
        "D2_violations": d2_violations,
        "notes": notes,
    }
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    with open(a.out, "w") as fh:
        json.dump({"summary": summary, "cells": cells}, fh, indent=1, sort_keys=True)
    if tmpdir:
        shutil.rmtree(tmpdir, ignore_errors=True)
    print(json.dumps(summary, indent=1))
    return 0 if (summary["D1_dichotomy_holds"] and summary["D2_alignment_is_determinant"]) else 1


if __name__ == "__main__":
    sys.exit(main())
