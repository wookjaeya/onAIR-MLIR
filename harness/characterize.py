"""Lowering characterization: build the mapping that C3 (contract-guided
lowering selection) actually consumes.

    l_i  ->  (C_median, C_p95, C_p99, M_peak, S_binary)

Why this is the next experiment
-------------------------------
The claim that the proposed framework beats a NumPy/BLAS baseline cannot rest
on latency: measurements so far show the compiled path 6-9x slower. The axis
where a compiled artifact can plausibly win is bounded, statically known
resource usage. That axis has never been measured in this project -- the
contract's peak_memory_bytes field is still null. Until it is filled, the
selector has no input and the framework has no evidence.

Method notes
------------
* Each configuration is measured in a FRESH SUBPROCESS. Peak RSS is process
  global, so measuring several configurations in one process would attribute
  the high-water mark of the worst configuration to all of them.
* Two memory numbers are reported and they answer different questions:
    rss_peak_kb   - ru_maxrss of the whole worker, including the Python
                    interpreter and NumPy. Useful only for comparing workers.
    rss_delta_kb  - RSS growth from just before artifact load to after the
                    measured inference loop. This is the number attributable
                    to the deployed artifact, and it is the one a memory
                    budget in the contract should be compared against.
  Neither is a static bound. Both are marked bound_method=measured_max.
* The NumPy baseline is measured by the same worker with the same accounting,
  so B0 and B1/P memory numbers are comparable.
"""

import argparse
import json
import os
import subprocess
import sys
import time

# ---------------------------------------------------------------------------
# Lowering design space.
#
# Deliberately mixes three kinds of knob so the resulting mapping is not just
# an ISA-flag sweep (which would be indistinguishable from ordinary
# autotuning): target selection, code-generation strategy, and runtime
# execution model.
# ---------------------------------------------------------------------------
BASE_TRIPLE = "x86_64-unknown-linux-gnu"

CONFIGS = {
    # -- target selection --
    "default":        {"flags": [], "driver": "local-sync"},
    "cpu_host":       {"flags": ["--iree-llvmcpu-target-cpu=host"],
                       "driver": "local-sync"},
    "avx2":           {"flags": ["--iree-llvmcpu-target-cpu-features=+avx2,+fma"],
                       "driver": "local-sync"},
    "avx512":         {"flags": ["--iree-llvmcpu-target-cpu-features="
                                 "+avx512f,+avx512bw,+avx2,+fma"],
                       "driver": "local-sync"},
    "generic_cpu":    {"flags": ["--iree-llvmcpu-target-cpu=generic"],
                       "driver": "local-sync"},

    # -- code generation strategy --
    "no_embedded":    {"flags": ["--iree-llvmcpu-link-embedded=false"],
                       "driver": "local-sync"},
    "host_no_embed":  {"flags": ["--iree-llvmcpu-target-cpu=host",
                                 "--iree-llvmcpu-link-embedded=false"],
                       "driver": "local-sync"},
    "opt_size":       {"flags": ["--iree-llvmcpu-target-cpu=host",
                                 "--iree-opt-strip-assertions"],
                       "driver": "local-sync"},
    "no_slow_vec":    {"flags": ["--iree-llvmcpu-target-cpu=host",
                                 "--iree-llvmcpu-disable-distribution"],
                       "driver": "local-sync"},

    # -- runtime execution model (same artifact, different dispatch) --
    "host_task":      {"flags": ["--iree-llvmcpu-target-cpu=host"],
                       "driver": "local-task"},
}


# ---------------------------------------------------------------------------
# Worker: runs in its own process, measures one configuration.
# ---------------------------------------------------------------------------
def worker(spec_path):
    import resource
    import numpy as np

    spec = json.load(open(spec_path))
    n_in, n_h, n_out = spec["shape"]
    iters, warmup = spec["iters"], spec["warmup"]

    rng = np.random.default_rng(0)
    x = rng.random((1, n_in), dtype=np.float32)
    w0 = (rng.standard_normal((n_in, n_h)) * 0.1).astype(np.float32)
    w1 = (rng.standard_normal((n_h, n_out)) * 0.1).astype(np.float32)

    def rss_kb():
        with open("/proc/self/status") as f:
            for line in f:
                if line.startswith("VmRSS:"):
                    return int(line.split()[1])
        return -1

    if spec["impl"] == "numpy":
        rss_before = rss_kb()
        call = lambda: x @ w0 @ w1
        binary_bytes = 0
        ref = np.asarray(x @ w0 @ w1)
        max_abs_diff = 0.0
    else:
        import iree.runtime as rt
        blob = open(spec["vmfb"], "rb").read()
        binary_bytes = len(blob)
        rss_before = rss_kb()
        ctx = rt.SystemContext(config=rt.Config(spec["driver"]))
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, blob))
        fn = ctx.modules.module["infer"]
        call = lambda: fn(x, w0, w1)
        ref = np.asarray(x @ w0 @ w1)
        max_abs_diff = float(np.abs(np.asarray(call()) - ref).max())

    for _ in range(warmup):
        call()

    lat = []
    for _ in range(iters):
        t0 = time.perf_counter_ns()
        call()
        lat.append(time.perf_counter_ns() - t0)

    rss_after = rss_kb()
    peak_kb = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss

    lat.sort()
    q = lambda p: lat[min(int(len(lat) * p), len(lat) - 1)] / 1e3
    out = {
        "name": spec["name"], "impl": spec["impl"], "driver": spec.get("driver"),
        "shape": spec["shape"],
        "C_median_us": q(0.5), "C_p95_us": q(0.95), "C_p99_us": q(0.99),
        "C_max_us": lat[-1] / 1e3, "n": len(lat),
        "dispersion_p99_over_median": round(q(0.99) / q(0.5), 3),
        "M_rss_delta_kb": rss_after - rss_before,
        "M_rss_peak_kb": peak_kb,
        "S_binary_bytes": binary_bytes,
        "max_abs_diff_vs_numpy": max_abs_diff,
    }
    print("###RESULT###" + json.dumps(out))


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------
def compile_config(name, cfg, shape, workdir):
    from iree.compiler import compile_str
    n_in, n_h, n_out = shape
    src = f"""func.func @infer(%x: tensor<1x{n_in}xf32>, %w0: tensor<{n_in}x{n_h}xf32>,
                 %w1: tensor<{n_h}x{n_out}xf32>) -> tensor<1x{n_out}xf32> {{
  %z0 = arith.constant dense<0.0> : tensor<1x{n_h}xf32>
  %h = linalg.matmul ins(%x, %w0 : tensor<1x{n_in}xf32>, tensor<{n_in}x{n_h}xf32>)
                     outs(%z0 : tensor<1x{n_h}xf32>) -> tensor<1x{n_h}xf32>
  %z1 = arith.constant dense<0.0> : tensor<1x{n_out}xf32>
  %o = linalg.matmul ins(%h, %w1 : tensor<1x{n_h}xf32>, tensor<{n_h}x{n_out}xf32>)
                     outs(%z1 : tensor<1x{n_out}xf32>) -> tensor<1x{n_out}xf32>
  return %o : tensor<1x{n_out}xf32>
}}"""
    args = [f"--iree-llvmcpu-target-triple={BASE_TRIPLE}"] + cfg["flags"]
    blob = compile_str(src, target_backends=["llvm-cpu"], extra_args=args)
    path = os.path.join(workdir, f"{name}.vmfb")
    open(path, "wb").write(blob)
    return path, args


def run_worker(spec, workdir):
    p = os.path.join(workdir, "spec.json")
    json.dump(spec, open(p, "w"))
    r = subprocess.run([sys.executable, __file__, "--worker", p],
                       capture_output=True, text=True)
    for line in r.stdout.splitlines():
        if line.startswith("###RESULT###"):
            return json.loads(line[len("###RESULT###"):])
    return {"name": spec["name"], "error": r.stderr.strip().splitlines()[-1:]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--n-in", type=int, default=9)
    ap.add_argument("--n-hidden", type=int, default=16384)
    ap.add_argument("--n-out", type=int, default=2)
    ap.add_argument("--iters", type=int, default=1500)
    ap.add_argument("--warmup", type=int, default=300)
    ap.add_argument("--workdir", default="/tmp/char_work")
    ap.add_argument("--out", default="results_characterization.json")
    a = ap.parse_args()

    os.makedirs(a.workdir, exist_ok=True)
    shape = [a.n_in, a.n_hidden, a.n_out]
    results = []

    # B0 baseline, same accounting
    results.append(run_worker(
        {"name": "B0_numpy_blas", "impl": "numpy", "shape": shape,
         "iters": a.iters, "warmup": a.warmup}, a.workdir))
    print(json.dumps(results[-1]))

    for name, cfg in CONFIGS.items():
        try:
            vmfb, args = compile_config(name, cfg, shape, a.workdir)
        except Exception as e:
            results.append({"name": name, "error": f"COMPILE_FAIL: {e}"[:200]})
            print(json.dumps(results[-1]))
            continue
        res = run_worker(
            {"name": name, "impl": "iree", "vmfb": vmfb, "shape": shape,
             "driver": cfg["driver"], "iters": a.iters, "warmup": a.warmup},
            a.workdir)
        res["flags"] = args
        results.append(res)
        print(json.dumps({k: res.get(k) for k in
                          ("name", "C_median_us", "C_p99_us",
                           "M_rss_delta_kb", "S_binary_bytes")}))

    json.dump({"shape": shape, "iters": a.iters, "results": results},
              open(a.out, "w"), indent=2)


if __name__ == "__main__":
    if len(sys.argv) > 2 and sys.argv[1] == "--worker":
        worker(sys.argv[2])
    else:
        main()
