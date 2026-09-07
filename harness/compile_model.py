"""Compile an MLIR model to an IREE artifact under a named lowering profile.

Profiles are the independent variable for RQ2/H2. Keep them explicit so the
experiment records exactly which flags produced each artifact.
"""
import argparse, hashlib, json, pathlib, subprocess, sys
from iree.compiler import compile_file

PROFILES = {
    # throughput-oriented default
    "fast":        {"extra": []},
    # determinism-oriented: single dispatch thread at runtime (see run_learner.py
    # local-sync driver) plus no runtime-selected microkernels
    "predictable": {"extra": ["--iree-llvmcpu-link-embedded=false"]},
}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mlir")
    ap.add_argument("--profile", choices=PROFILES, default="fast")
    ap.add_argument("--triple", default="x86_64-unknown-linux-gnu")
    ap.add_argument("--out", default="model.vmfb")
    ap.add_argument("--contract-out", default=None)
    a = ap.parse_args()

    args = [f"--iree-llvmcpu-target-triple={a.triple}"] + PROFILES[a.profile]["extra"]
    blob = compile_file(a.mlir, target_backends=["llvm-cpu"], extra_args=args)
    pathlib.Path(a.out).write_bytes(blob)

    manifest = {
        "artifact": {"file": a.out, "bytes": len(blob),
                     "sha256": hashlib.sha256(blob).hexdigest()},
        "source": {"mlir": a.mlir,
                   "sha256": hashlib.sha256(pathlib.Path(a.mlir).read_bytes()).hexdigest()},
        "target": {"triple": a.triple, "profile": a.profile, "extra_args": args},
        # Deliberately absent: execution_bound_us. It is NOT produced by the
        # compiler. It is filled in by the timing-characterization stage and
        # must carry bound_method (measured | static_wcet).
        "timing": {"execution_bound_us": None, "bound_method": None},
    }
    out = a.contract_out or (a.out + ".manifest.json")
    pathlib.Path(out).write_text(json.dumps(manifest, indent=2))
    print(json.dumps(manifest["artifact"], indent=2))

if __name__ == "__main__":
    sys.exit(main())
