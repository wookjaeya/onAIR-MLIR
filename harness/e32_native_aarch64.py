#!/usr/bin/env python3
"""E32 / step 2 of the plan: run the AArch64 vmfb through the *deployment* C path
and record the full output for every fixture sample.

Why this exists rather than reusing `harness/iree_runner.py`: that runner calls the
pip `iree.runtime` bindings on the host. This one drives `native/native_learner.c`
cross-compiled for AArch64 -- the same binary shape the cFS app links -- so the
outputs come from the gated deployment path (stack check, admission, interface
check, artifact size + sha256) and not from a bare inference harness.

The C side's "E25 equivalence mode" (argv[4..5]) is what does the work: it reads N
raw f32 vectors, runs one inference each, transfers each result back to the host,
and writes N raw f32 output vectors.  Reading every result back is the point --
plan SS3.3 / review SS9.4: the contract's call lifecycle has to hold when outputs are
CONSUMED, not only when they are discarded.

Inputs are rebuilt from the E31 fixture and every array is checked against the
manifest sha256 BEFORE it is written into the stream.  A fixture that does not
hash as recorded is refused rather than silently measured -- the sample identity
is the whole basis for comparing against the oracle.

    python3 harness/e32_native_aarch64.py --binary <native_learner_aarch64> \
        --vmfb results/e32_smartcam_aarch64/build/smartcam.vmfb \
        --budget 18222796 --out results/e32_smartcam_aarch64/native/iree_aarch64.json

Wall-clock is recorded for feasibility only.  This is qemu-user on a shared
FUNCTIONAL_ONLY host: it is NOT timing evidence (CLAUDE.md discipline 4).
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
DEF_FIXTURE = os.path.join(ROOT, "results", "e31_smartcam_equivalence", "fixture")


def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


def load_or_regenerate(fixture_dir, manifest):
    """Return [(sample_id, kind, nchw array)] in manifest order, hash-checked.

    The 32 synthetic samples are not stored (they are 38.5 MB of regenerable
    noise); they come back bit-exactly from the recorded seed, and the recipe is
    the manifest's own, not a guess -- see results/.../fixture/manifest.json.
    """
    # the seed is a recorded fact, not a constant to remember here: it lives in each
    # synthetic sample's own `detail.generator` string
    seeds = set()
    for s in manifest["samples"]:
        if s["kind"] == "synthetic":
            m = re.search(r"default_rng\((\d+)\)", s.get("detail", {}).get("generator", ""))
            if m:
                seeds.add(int(m.group(1)))
    # E46 (type B, found while auditing E45): this used to demand exactly one seed
    # UNCONDITIONALLY, so a fixture with NO synthetic samples -- which is every fixture E45
    # built from real data -- was refused with "does not record exactly one synthetic seed
    # ([])". The seed exists to REGENERATE synthetic samples that are deliberately not
    # stored; a fixture that stores every sample needs no seed, and refusing it is an
    # over-rejection, not a safety property. Three harnesses were blocked by this one
    # function (e32_native_aarch64, e32_cfs_outputs, e33_onair_outputs all import it).
    # The per-sample sha256 check below is UNCHANGED and is what actually guards integrity.
    n_synth = sum(1 for s in manifest["samples"] if s["kind"] == "synthetic")
    if n_synth and len(seeds) != 1:
        raise SystemExit("REFUSED: the manifest has %d synthetic sample(s) but does not record "
                         "exactly one seed to regenerate them (%s)" % (n_synth, sorted(seeds)))
    rng = np.random.default_rng(seeds.pop()) if seeds else None
    out = []
    for s in manifest["samples"]:
        sid, kind = s["sample_id"], s["kind"]
        p = os.path.join(fixture_dir, s["nchw"]["file"])
        if kind == "synthetic":
            # consume the stream in manifest order whether or not the file exists,
            # so a partially-stored fixture cannot shift every later sample
            if rng is None:      # unreachable while n_synth>0 forces a seed; explicit anyway
                raise SystemExit("REFUSED: synthetic sample %s with no seed recorded" % sid)
            nhwc = rng.random((1, 224, 224, 3), dtype=np.float32)
            nchw = np.ascontiguousarray(nhwc.transpose(0, 3, 1, 2))
            if os.path.exists(p):
                nchw = np.load(p)
        else:
            if not os.path.exists(p):
                raise SystemExit("fixture array missing and not regenerable: %s" % p)
            nchw = np.load(p)
        got = sha256_bytes(np.ascontiguousarray(nchw, dtype=np.float32).tobytes())
        if got != s["nchw"]["sha256"]:
            raise SystemExit("REFUSED: %s nchw sha256 %s != manifest %s"
                             % (sid, got[:16], s["nchw"]["sha256"][:16]))
        out.append((sid, kind, np.ascontiguousarray(nchw, dtype=np.float32)))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--binary", required=True, help="native_learner cross-built for aarch64")
    ap.add_argument("--vmfb", required=True)
    ap.add_argument("--budget", type=int, required=True)
    ap.add_argument("--iters", type=int, default=3,
                    help="measured inference calls AFTER the equivalence pass (peak covers both)")
    ap.add_argument("--fixture", default=DEF_FIXTURE)
    # E36b: the output arity used to be the literal 3 -- SmartCam's -- so this runner
    # silently truncated a 10-output classifier to its first three values and the
    # comparator then called a CORRECT computation a total failure.  The shape is a
    # property of the model, so it is read from the contract, never guessed.
    ap.add_argument("--contract", default=None,
                    help="contract JSON of the SAME invocation as --vmfb; its interface fixes the "
                         "output shape. Omit only for the SmartCam default (kept for reproducing E32).")
    ap.add_argument("--qemu", default="qemu-aarch64")
    ap.add_argument("--workdir", default=None)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    if shutil.which(a.qemu) is None:
        raise SystemExit("%s not on PATH" % a.qemu)
    man = json.load(open(os.path.join(a.fixture, "manifest.json"), encoding="utf-8"))
    samples = load_or_regenerate(a.fixture, man)

    work = a.workdir or os.path.join(os.path.dirname(os.path.abspath(a.out)), "_work")
    os.makedirs(work, exist_ok=True)
    in_bin = os.path.join(work, "inputs.bin")
    out_bin = os.path.join(work, "outputs.bin")
    with open(in_bin, "wb") as f:
        for _sid, _k, arr in samples:
            f.write(arr.tobytes())

    cmd = [a.qemu, os.path.abspath(a.binary), os.path.abspath(a.vmfb),
           str(a.budget), str(a.iters), in_bin, out_bin]
    t0 = time.time()
    p = subprocess.run(cmd, capture_output=True, text=True)
    wall = time.time() - t0

    stages = []
    for line in (p.stdout or "").splitlines():
        line = line.strip()
        if line.startswith("{"):
            try:
                stages.append(json.loads(line))
            except ValueError:
                pass

    out_shape = [1, 3]
    if a.contract:
        con = json.load(open(a.contract, encoding="utf-8"))
        outs = con["interface"].get("outputs") or [con["interface"]["output"]]
        if len(outs) != 1:
            raise SystemExit("REFUSED: this runner pushes one output; contract declares %d" % len(outs))
        out_shape = list(outs[0]["shape"])
        if outs[0].get("dtype") != "f32":
            raise SystemExit("REFUSED: contract output dtype is %r, not f32" % outs[0].get("dtype"))
    per = 1
    for d in out_shape:
        per *= int(d)
    if per <= 0:
        raise SystemExit("REFUSED: output element count resolved to %d" % per)

    results = []
    n_out = 0
    if os.path.exists(out_bin):
        raw = np.fromfile(out_bin, dtype=np.float32)
        if raw.size % per:
            raise SystemExit("REFUSED: %d floats written is not a multiple of the contract's %d "
                             "output elements -- refusing to slice a shape the model does not have"
                             % (raw.size, per))
        n_out = raw.size // per
        for i in range(min(n_out, len(samples))):
            sid, kind, arr = samples[i]
            y = raw[i * per:(i + 1) * per]
            results.append({
                "sample_id": sid, "kind": kind,
                "input_sha256": sha256_bytes(arr.tobytes()),
                "output": [float(v) for v in y],
                "output_shape": out_shape, "output_dtype": "float32",
                "argmax": int(np.argmax(y)), "sum": float(np.sum(y)),
            })

    doc = {
        "tool": "harness/e32_native_aarch64.py",
        "runner": "native/native_learner.c cross-built aarch64-linux-gnu, IREE C runtime "
                  "(local-sync, embedded ELF loader), executed under qemu-aarch64 (user mode)",
        "artifact": {
            "path": os.path.relpath(os.path.abspath(a.vmfb), ROOT),
            "bytes": os.path.getsize(a.vmfb),
            "sha256": sha256_bytes(open(a.vmfb, "rb").read()),
        },
        "fixture": {"dir": os.path.relpath(os.path.abspath(a.fixture), ROOT),
                    "total_samples": len(samples)},
        "budget_bytes": a.budget,
        "returncode": p.returncode,
        "stages": stages,
        "outputs_written": int(n_out),
        "wall_seconds": round(wall, 1),
        "wall_note": "qemu-user on a FUNCTIONAL_ONLY host: feasibility only, NOT timing evidence",
        "memory_note": "the HAL peak reported in `stages` is the C runtime's own allocator "
                       "statistic and it covers the output-CONSUMING equivalence pass that ran "
                       "before the measured calls (plan SS3.3).",
        "results": results,
    }
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"returncode": p.returncode, "outputs": int(n_out),
                      "samples": len(samples), "wall_seconds": round(wall, 1),
                      "stderr_tail": (p.stderr or "")[-300:]}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
