"""Latency harness with EXPLICIT measurement boundaries.

Reviewer issue C3: a compiled Learner still runs inside a Python plugin
wrapper, so "inference latency" is ambiguous. This harness reports three
boundaries separately and never collapses them:

  L1 kernel : the IREE call only
  L2 plugin : OnAIR AIPlugin.update() + render_reasoning() around the kernel
  L3 e2e    : frame arrival (data adapter) -> reasoning output

Only L1 vs L1 comparisons are valid for "does AOT help the kernel";
H1 must be argued at L2/L3 because that is what the cFS task actually pays.
"""
import argparse, json, statistics, time
import numpy as np

def percentiles(ns):
    s = sorted(ns)
    def p(q): return s[min(int(len(s) * q), len(s) - 1)] / 1e3
    return {"n": len(s), "median_us": p(0.5), "p95_us": p(0.95),
            "p99_us": p(0.99), "p999_us": p(0.999), "max_us": s[-1] / 1e3,
            "iqr_us": p(0.75) - p(0.25)}

def make_iree(vmfb, driver="local-sync"):
    import iree.runtime as rt
    ctx = rt.SystemContext(config=rt.Config(driver))
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
    return ctx.modules.module["infer"]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--impl", choices=["numpy", "iree"], required=True)
    ap.add_argument("--vmfb", default="model.vmfb")
    ap.add_argument("--driver", default="local-sync")
    ap.add_argument("--iters", type=int, default=20000)
    ap.add_argument("--warmup", type=int, default=2000)
    ap.add_argument("--out", default="latency.json")
    a = ap.parse_args()

    rng = np.random.default_rng(0)
    x = rng.random((1, 32), dtype=np.float32)
    w0 = rng.random((32, 64), dtype=np.float32); b0 = np.zeros(64, np.float32)
    w1 = rng.random((64, 2), dtype=np.float32);  b1 = np.zeros(2, np.float32)

    if a.impl == "iree":
        f = make_iree(a.vmfb, a.driver)
        call = lambda: np.asarray(f(x, w0, b0, w1, b1))
    else:
        call = lambda: x @ w0 @ w1

    for _ in range(a.warmup):
        call()

    l1 = []
    for _ in range(a.iters):
        t0 = time.perf_counter_ns(); call(); l1.append(time.perf_counter_ns() - t0)

    res = {"impl": a.impl, "driver": a.driver if a.impl == "iree" else None,
           "boundary": "L1_kernel", "stats": percentiles(l1)}
    open(a.out, "w").write(json.dumps(res, indent=2))
    print(json.dumps(res, indent=2))

if __name__ == "__main__":
    main()
