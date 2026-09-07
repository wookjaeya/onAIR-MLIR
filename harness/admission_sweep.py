"""E7 sweep: admission decisions for 10 configs x 3 sizes x {inputs, baked}
against a ladder of budgets, each decision verified at runtime.
Also E8: a dynamic-shape model to demonstrate the UNBOUNDED path."""
import json, os, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(__file__))
from characterize import CONFIGS, BASE_TRIPLE
from characterize_baked import make_src
from static_bound_sweep import MLIR as MLIR_INPUTS
import numpy as np

BUDGETS = [16 * 1024, 64 * 1024, 256 * 1024, 1024 * 1024]   # 16K 64K 256K 1M
# E10: boundary budgets around the exact bounded value M(h)=48h+44 (inputs and baked share it)
BOUNDARY = {h: [48*h+44-1, 48*h+44, 48*h+44+1] for h in (256, 4096, 16384)}

def run(mlir, shape, extra, baked, budget):
    r = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "admission_check.py"),
                        "--mlir", mlir, "--shape", *map(str, shape), f"--extra={extra}", "--budget", str(budget)]
                       + (["--baked"] if baked else []), capture_output=True, text=True)
    return json.loads(r.stdout[r.stdout.index("{"):])

def main():
    rows = []
    for h in (256, 4096, 16384):
        rng = np.random.default_rng(0)
        w0 = (rng.standard_normal((9, h)) * 0.1).astype(np.float32); w1 = (rng.standard_normal((h, 2)) * 0.1).astype(np.float32)
        srcs = {"inputs": MLIR_INPUTS.format(n_in=9, n_h=h, n_out=2), "baked": make_src(9, h, 2, w0, w1)}
        for variant, src in srcs.items():
            f = tempfile.NamedTemporaryFile("w", suffix=".mlir", delete=False); f.write(src); f.close()
            for name, cfg in CONFIGS.items():
                extra = " ".join([f"--iree-llvmcpu-target-triple={BASE_TRIPLE}"] + cfg["flags"])
                for b in BUDGETS + (BOUNDARY[h] if name == "cpu_host" else []):
                    o = run(f.name, (9, h, 2), extra, variant == "baked", b)
                    o.update({"hidden": h, "variant": variant, "config": name,
                              "boundary_test": b in BOUNDARY[h]})
                    rows.append(o)
        print(f"h={h} done ({len(rows)} decisions so far)")
    # E8: dynamic batch dimension -> sizes are not constants
    dyn = """func.func @infer(%x: tensor<?x9xf32>, %w0: tensor<9x64xf32>, %w1: tensor<64x2xf32>) -> tensor<?x2xf32> {
  %c0 = arith.constant 0 : index
  %b = tensor.dim %x, %c0 : tensor<?x9xf32>
  %e0 = tensor.empty(%b) : tensor<?x64xf32>
  %cst = arith.constant 0.0 : f32
  %z0 = linalg.fill ins(%cst : f32) outs(%e0 : tensor<?x64xf32>) -> tensor<?x64xf32>
  %h = linalg.matmul ins(%x, %w0 : tensor<?x9xf32>, tensor<9x64xf32>) outs(%z0 : tensor<?x64xf32>) -> tensor<?x64xf32>
  %e1 = tensor.empty(%b) : tensor<?x2xf32>
  %z1 = linalg.fill ins(%cst : f32) outs(%e1 : tensor<?x2xf32>) -> tensor<?x2xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<?x64xf32>, tensor<64x2xf32>) outs(%z1 : tensor<?x2xf32>) -> tensor<?x2xf32>
  return %o : tensor<?x2xf32>
}
"""
    f = tempfile.NamedTemporaryFile("w", suffix=".mlir", delete=False); f.write(dyn); f.close()
    extra = f"--iree-llvmcpu-target-triple={BASE_TRIPLE} --iree-llvmcpu-target-cpu=host"
    r = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "static_mem_bound.py"),
                        f.name, "--shape", "9", "64", "2", f"--extra={extra}"], capture_output=True, text=True)
    txt = r.stdout
    try:
        an = json.loads(txt[txt.index("{"):])
        e8 = {"all_sizes_static": an["all_sizes_static"], "unresolved": an["unresolved_sizes"],
              "transient_slices": an["transient_slices"], "bound_method": an["bound_method"]}
    except Exception:
        e8 = {"error": (r.stderr or txt)[-400:]}
    e8["verdict"] = "UNKNOWN_BOUND" if not e8.get("all_sizes_static", True) else "STATIC"
    json.dump({"budgets": BUDGETS, "decisions": rows, "E8_dynamic_shape": e8}, open("results_admission.json", "w"), indent=2)
    # summary
    from collections import Counter
    c = Counter((r["verdict"], r.get("misprediction")) for r in rows)
    print("decisions:", dict(c))
    print("E8 dynamic-shape:", e8)

if __name__ == "__main__":
    main()
