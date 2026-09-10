"""Generate a model triple (MLIR, weights, contract) for a given size.

The model-size sweep is the go/no-go experiment: it locates the crossover
point where compiled inference starts to beat interpreted inference at the
boundary the cFS task actually pays (L2b), not just at L1.
"""
import argparse, hashlib, json, os, pathlib
import numpy as np

MLIR = """func.func @infer(%x: tensor<1x{n_in}xf32>, %w0: tensor<{n_in}x{n_h}xf32>,
                 %w1: tensor<{n_h}x{n_out}xf32>) -> tensor<1x{n_out}xf32> {{
  %z0 = arith.constant dense<0.0> : tensor<1x{n_h}xf32>
  %h = linalg.matmul ins(%x, %w0 : tensor<1x{n_in}xf32>, tensor<{n_in}x{n_h}xf32>)
                     outs(%z0 : tensor<1x{n_h}xf32>) -> tensor<1x{n_h}xf32>
  %z1 = arith.constant dense<0.0> : tensor<1x{n_out}xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<1x{n_h}xf32>, tensor<{n_h}x{n_out}xf32>)
                     outs(%z1 : tensor<1x{n_out}xf32>) -> tensor<1x{n_out}xf32>
  return %o : tensor<1x{n_out}xf32>
}}
"""

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n-in", type=int, default=9)
    ap.add_argument("--n-hidden", type=int, default=64)
    ap.add_argument("--n-out", type=int, default=2)
    ap.add_argument("--profile", default="fast", choices=["fast", "predictable"])
    ap.add_argument("--triple", default="x86_64-unknown-linux-gnu")
    ap.add_argument("--outdir", required=True)
    a = ap.parse_args()

    out = pathlib.Path(a.outdir); out.mkdir(parents=True, exist_ok=True)
    src = MLIR.format(n_in=a.n_in, n_h=a.n_hidden, n_out=a.n_out)
    mlir_path = out / "model.mlir"; mlir_path.write_text(src)

    rng = np.random.default_rng(0)
    w0 = (rng.standard_normal((a.n_in, a.n_hidden)) * 0.1).astype(np.float32)
    w1 = (rng.standard_normal((a.n_hidden, a.n_out)) * 0.1).astype(np.float32)
    np.savez(out / "weights.npz", w0=w0, w1=w1)

    from iree.compiler import compile_file
    extra = [f"--iree-llvmcpu-target-triple={a.triple}"]
    if a.profile == "predictable":
        extra += ["--iree-llvmcpu-link-embedded=false"]
    blob = compile_file(str(mlir_path), target_backends=["llvm-cpu"], extra_args=extra)
    (out / "model.vmfb").write_bytes(blob)

    contract = {
        "model": {"name": f"mlp_{a.n_in}x{a.n_hidden}x{a.n_out}",
                  "sha256": hashlib.sha256(src.encode()).hexdigest()},
        "interface": {"input": {"shape": [1, a.n_in], "dtype": "f32"},
                      "output": {"shape": [1, a.n_out], "dtype": "f32"}},
        "target": {"triple": a.triple, "profile": a.profile,
                   "driver": "local-sync", "extra_args": extra},
        "resources": {"binary_size_bytes": len(blob), "peak_memory_bytes": None},
        # Filled by the timing-characterization stage, never by the compiler.
        "timing": {"boundary": None, "execution_bound_us": None,
                   "bound_method": None, "sample_count": None,
                   "platform_timing_grade": None},
        # N5 (external review v0.18-followup, E24): `bytes` is what
        # plugins/compiled_learner/artifact_binding.py checks FIRST (size
        # precheck before the hash, mirroring the C path), and E23 correctly
        # made its absence a refusal. This generator never wrote it, so every
        # runtime directory it produced -- including the one harness/sweep.py
        # regenerates on each step -- was refused by the plugin's own gate.
        # Fixing the shipped fixture alone would have been volatile: sweep.py
        # rewrites that directory from here.
        "artifact": {"file": "model.vmfb",
                     "bytes": len(blob),
                     "sha256": hashlib.sha256(blob).hexdigest()},
    }
    (out / "contract.json").write_text(json.dumps(contract, indent=2))
    print(json.dumps({"outdir": str(out), "vmfb_bytes": len(blob),
                      "shape": [a.n_in, a.n_hidden, a.n_out]}))

if __name__ == "__main__":
    main()
