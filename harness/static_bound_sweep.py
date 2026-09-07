"""E6 sweep: static memory bound vs runtime peak across lowering configs and
model sizes. Reuses the config table from characterize.py so the lowering
design space is identical to E5."""
import json, os, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(__file__))
from characterize import CONFIGS, BASE_TRIPLE

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
    sizes = [int(s) for s in (sys.argv[1:] or ["256", "4096", "16384"])]
    out = []
    for h in sizes:
        shape = (9, h, 2)
        with tempfile.NamedTemporaryFile("w", suffix=".mlir", delete=False) as f:
            f.write(MLIR.format(n_in=9, n_h=h, n_out=2)); mlir = f.name
        for name, cfg in CONFIGS.items():
            extra = " ".join([f"--iree-llvmcpu-target-triple={BASE_TRIPLE}"] + cfg["flags"])
            r = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "static_mem_bound.py"),
                                mlir, "--shape", *map(str, shape), f"--extra={extra}"],
                               capture_output=True, text=True)
            try:
                j = json.loads(r.stdout[r.stdout.index("{"):])
            except Exception:
                out.append({"hidden": h, "config": name, "error": r.stderr[-300:]}); continue
            row = {"hidden": h, "config": name, "driver": cfg["driver"],
                   "dispatches": j["dispatches"],
                   "static_transient": j["static_transient_bytes"],
                   "static_total_incl_inputs": j["static_total_bytes_incl_inputs"],
                   "runtime_peak": j["runtime_check"].get("device_bytes_peak"),
                   "bound_sound": j.get("bound_sound"), "tightness": j.get("bound_tightness"),
                   "all_static": j["all_sizes_static"]}
            out.append(row)
            print(json.dumps(row))
    json.dump(out, open("results_static_bound.json", "w"), indent=2)

if __name__ == "__main__":
    main()
