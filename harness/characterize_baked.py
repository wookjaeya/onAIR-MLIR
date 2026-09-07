"""E6b: re-run the lowering characterization with WEIGHTS BAKED AS CONSTANTS.

Correction to E1-E5
-------------------
Those experiments passed the weight tensors as call arguments. In IREE's
Python binding every call then imports ~ (n_in*n_h + n_h*n_out)*4 bytes of
weights into device buffers (HAL stats: bytes_per_call == full input set).
A deployed model never does that -- weights are constants in the artifact.
So E1-E5 latency and per-call memory for the compiled path were inflated by
a per-call weight copy. This harness removes that confound. E1-E5 remain
valid as "weights-as-inputs" measurements but must not be cited as the
compiled path's deployment cost.
"""
import json, os, subprocess, sys, tempfile, time
sys.path.insert(0, os.path.dirname(__file__))
from characterize import CONFIGS, BASE_TRIPLE
import numpy as np

def make_src(n_in, n_h, n_out, w0, w1):
    d = lambda a: "dense<[" + ",".join(f"{v:.6e}" for v in a.reshape(-1)) + "]>"
    return f"""func.func @infer(%x: tensor<1x{n_in}xf32>) -> tensor<1x{n_out}xf32> {{
  %s0 = arith.constant dense<[{n_in}, {n_h}]> : tensor<2xi64>
  %s1 = arith.constant dense<[{n_h}, {n_out}]> : tensor<2xi64>
  %w0 = arith.constant {d(w0)} : tensor<{n_in*n_h}xf32>
  %w0r = tensor.reshape %w0(%s0) : (tensor<{n_in*n_h}xf32>, tensor<2xi64>) -> tensor<{n_in}x{n_h}xf32>
  %w1 = arith.constant {d(w1)} : tensor<{n_h*n_out}xf32>
  %w1r = tensor.reshape %w1(%s1) : (tensor<{n_h*n_out}xf32>, tensor<2xi64>) -> tensor<{n_h}x{n_out}xf32>
  %z0 = arith.constant dense<0.0> : tensor<1x{n_h}xf32>
  %h = linalg.matmul ins(%x, %w0r : tensor<1x{n_in}xf32>, tensor<{n_in}x{n_h}xf32>) outs(%z0 : tensor<1x{n_h}xf32>) -> tensor<1x{n_h}xf32>
  %z1 = arith.constant dense<0.0> : tensor<1x{n_out}xf32>
  %o = linalg.matmul ins(%h, %w1r : tensor<1x{n_h}xf32>, tensor<{n_h}x{n_out}xf32>) outs(%z1 : tensor<1x{n_out}xf32>) -> tensor<1x{n_out}xf32>
  return %o : tensor<1x{n_out}xf32>
}}
"""

def worker(spec_path):
    import resource, iree.runtime as rt
    sp = json.load(open(spec_path)); n_in, n_h, n_out = sp["shape"]
    rng = np.random.default_rng(0)
    w0 = (rng.standard_normal((n_in, n_h)) * 0.1).astype(np.float32)
    w1 = (rng.standard_normal((n_h, n_out)) * 0.1).astype(np.float32)
    x = rng.random((1, n_in), dtype=np.float32)
    def rss():
        for l in open("/proc/self/status"):
            if l.startswith("VmRSS:"): return int(l.split()[1])
    if sp["impl"] == "numpy":
        r0 = rss(); call = lambda: x @ w0 @ w1; peak = None; bpc = None; nbytes = 0
    else:
        blob = open(sp["vmfb"], "rb").read(); nbytes = len(blob)
        r0 = rss()
        cfg = rt.Config(sp["driver"]); ctx = rt.SystemContext(config=cfg)
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, blob)); fn = ctx.modules.module["infer"]
        call = lambda: fn(x); al = cfg.device.allocator
    for _ in range(sp["warmup"]): call()
    lat = []
    for _ in range(sp["iters"]):
        t0 = time.perf_counter_ns(); call(); lat.append(time.perf_counter_ns() - t0)
    r1 = rss()
    if sp["impl"] == "iree":
        st = dict(al.statistics); peak = st["device_bytes_peak"]
        bpc = st["device_bytes_allocated"] / (sp["warmup"] + sp["iters"])
        diff = float(np.abs(np.asarray(fn(x)) - (x @ w0 @ w1)).max())
    else:
        diff = 0.0
    lat.sort(); q = lambda p: lat[min(int(len(lat)*p), len(lat)-1)]/1e3
    print("###RESULT###" + json.dumps({
        "name": sp["name"], "impl": sp["impl"], "shape": sp["shape"],
        "C_median_us": q(.5), "C_p95_us": q(.95), "C_p99_us": q(.99), "C_max_us": lat[-1]/1e3,
        "n": len(lat), "M_rss_delta_kb": r1 - r0,
        "M_hal_peak_bytes": peak, "M_hal_bytes_per_call": bpc,
        "S_binary_bytes": nbytes, "max_abs_diff": diff}))

def main():
    sizes = [int(s) for s in sys.argv[1:] or ["4096", "16384"]]
    from iree.compiler import compile_str
    work = "/tmp/baked_work"; os.makedirs(work, exist_ok=True)
    out = []
    for h in sizes:
        shape = [9, h, 2]; rng = np.random.default_rng(0)
        w0 = (rng.standard_normal((9, h)) * 0.1).astype(np.float32)
        w1 = (rng.standard_normal((h, 2)) * 0.1).astype(np.float32)
        src = make_src(9, h, 2, w0, w1)
        iters, warm = (1500, 300) if h >= 16384 else (3000, 500)
        spec = {"name": "B0_numpy_blas", "impl": "numpy", "shape": shape, "iters": iters, "warmup": warm}
        json.dump(spec, open(f"{work}/spec.json", "w"))
        r = subprocess.run([sys.executable, __file__, "--worker", f"{work}/spec.json"], capture_output=True, text=True)
        res = json.loads([l for l in r.stdout.splitlines() if l.startswith("###RESULT###")][0][12:]); res["hidden"] = h
        out.append(res); print(json.dumps({k: res[k] for k in ("hidden", "name", "C_median_us", "C_p99_us", "M_rss_delta_kb")}))
        for name, cfg in CONFIGS.items():
            args = [f"--iree-llvmcpu-target-triple={BASE_TRIPLE}"] + cfg["flags"]
            try:
                blob = compile_str(src, target_backends=["llvm-cpu"], extra_args=args)
            except Exception as e:
                out.append({"hidden": h, "name": name, "error": str(e)[:200]}); continue
            vmfb = f"{work}/{name}_{h}.vmfb"; open(vmfb, "wb").write(blob)
            spec = {"name": name, "impl": "iree", "vmfb": vmfb, "driver": cfg["driver"], "shape": shape, "iters": iters, "warmup": warm}
            json.dump(spec, open(f"{work}/spec.json", "w"))
            r = subprocess.run([sys.executable, __file__, "--worker", f"{work}/spec.json"], capture_output=True, text=True)
            lines = [l for l in r.stdout.splitlines() if l.startswith("###RESULT###")]
            if not lines:
                out.append({"hidden": h, "name": name, "error": r.stderr[-300:]}); continue
            res = json.loads(lines[0][12:]); res["hidden"] = h; res["flags"] = args; out.append(res)
            print(json.dumps({k: res[k] for k in ("hidden", "name", "C_median_us", "C_p99_us", "M_rss_delta_kb", "M_hal_peak_bytes", "S_binary_bytes")}))
    json.dump(out, open("results_characterization_baked.json", "w"), indent=2)

if __name__ == "__main__":
    if len(sys.argv) > 2 and sys.argv[1] == "--worker": worker(sys.argv[2])
    else: main()
