#!/usr/bin/env python3
"""E41: measure what happens OUTSIDE the contract's declared analysis domain.

This is a MEASUREMENT, not a gate. E40 made the contract publish
`analysis_domain.required_premises` -- conditions the deployment must uphold that
the compiler output cannot confirm. This probe answers the only question that makes
publishing them worthwhile: are they load-bearing, or decorative?

It drives the IREE Python bindings directly, with N host threads calling the same
module concurrently, and reads the HAL allocator peak. It deliberately does NOT add
a thread to either C deployment: asserting that a hazard is absent by first building
it into a flight app would be the regression, not the test. Which deployments can
reach the hazard is checked separately, by reading their source (see
harness/contract_negative_tests.py::e41_analysis_domain_cases).

Every cell runs in its OWN SUBPROCESS. The HAL allocator statistics are
PROCESS-GLOBAL -- E26 measured this contamination once already, and the first draft of
this probe reproduced it: b3_deepae at N=1 reported 1,237,664 B (b2_resnet's N=4 peak)
instead of its own 6,208 B. The wrong number was obvious only because the contract said
what the right one was.

Two premises are probed independently so their effects are not confused (D50: the
HAL statistics react to what the observer is holding):
  * max_in_flight_calls  -- N threads, results released immediately
  * output_lifetime      -- the same N, results retained

Usage:
  e41_domain_probe.py --out results/e41_analysis_domain/probe.json \\
      --cell MODEL.vmfb:MODEL.contract.json [--cell ...] [--threads 1,2,4] [--repeats 3]
"""
import argparse, json, os, sys, threading


def run_cell(vmfb, contract, nthreads, hold, driver="local-sync"):
    import numpy as np
    import iree.runtime as rt

    c = json.load(open(contract))
    shape = tuple(c["interface"]["input"]["shape"])
    entry = c["interface"].get("entry") or c["model"].get("entry", "infer")
    res = c["resources"]

    cfg = rt.Config(driver)
    ctx = rt.SystemContext(config=cfg)
    with open(vmfb, "rb") as fh:
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, fh.read()))
    fn = ctx.modules.module[entry]

    barrier = threading.Barrier(nthreads)
    lock = threading.Lock()
    kept, errors = [], []

    def work():
        x = np.zeros(shape, dtype=np.float32)
        try:
            barrier.wait()
            r = fn(x)
            if hold:
                with lock:
                    kept.append(r)
            else:
                del r
        except Exception as e:                      # a refusal is data, not a crash
            with lock:
                errors.append(type(e).__name__ + ": " + str(e)[:200])

    ts = [threading.Thread(target=work) for _ in range(nthreads)]
    for t in ts:
        t.start()
    for t in ts:
        t.join()

    st = dict(cfg.device.allocator.statistics)
    peak = st.get("device_bytes_peak")
    per_call = res.get("static_per_call_bytes")
    bounded = res.get("bounded_bytes")
    return {
        "threads": nthreads, "hold_outputs": bool(hold), "driver": driver,
        "peak": peak,
        "allocated": st.get("device_bytes_allocated"),
        "freed": st.get("device_bytes_freed"),
        "per_call_bytes": per_call, "bounded_bytes": bounded,
        # the premise is upheld exactly when one call is in flight; outside it the
        # contract states nothing, so these are observations, not verdicts
        "peak_within_per_call": None if (peak is None or per_call is None) else peak <= per_call,
        "peak_within_bounded": None if (peak is None or bounded is None) else peak <= bounded,
        "errors": errors,
    }


def _run_one_in_subprocess(vmfb, contract, nthreads, hold, driver):
    """One cell, one fresh interpreter -- the HAL statistics are process-global."""
    import subprocess
    out = subprocess.run(
        [sys.executable, os.path.abspath(__file__), "--single-cell",
         "--vmfb", vmfb, "--contract", contract, "--threads", str(nthreads),
         "--driver", driver] + (["--hold"] if hold else []),
        capture_output=True, text=True)
    if out.returncode != 0:
        raise SystemExit("e41_domain_probe: cell failed (rc=%d): %s"
                         % (out.returncode, out.stderr.strip()[:400]))
    return json.loads(out.stdout.strip().splitlines()[-1])


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--single-cell", action="store_true",
                    help="internal: run ONE cell in this process and print its JSON")
    ap.add_argument("--vmfb")
    ap.add_argument("--contract")
    ap.add_argument("--hold", action="store_true")
    ap.add_argument("--cell", action="append",
                    help="VMFB:CONTRACT pair; repeatable")
    ap.add_argument("--threads", default="1,2,4")
    ap.add_argument("--repeats", type=int, default=3)
    ap.add_argument("--driver", default="local-sync")
    ap.add_argument("--out")
    a = ap.parse_args(argv)

    try:
        import iree.runtime  # noqa: F401
        import numpy  # noqa: F401
    except ImportError as e:                        # a decision, not a crash (D24/D25)
        print("e41_domain_probe: %s" % e, file=sys.stderr)
        return 2

    if a.single_cell:
        print(json.dumps(run_cell(a.vmfb, a.contract, int(a.threads), a.hold, a.driver)))
        return 0
    if not a.cell:
        print("e41_domain_probe: --cell is required", file=sys.stderr)
        return 2

    threads = [int(t) for t in a.threads.split(",")]
    cells = []
    for spec in a.cell:
        vmfb, contract = spec.split(":", 1)
        name = json.load(open(contract))["model"]["name"]
        for hold in (False, True):
            for n in threads:
                runs = [_run_one_in_subprocess(vmfb, contract, n, hold, a.driver)
                        for _ in range(a.repeats)]
                peaks = [r["peak"] for r in runs]
                cell = dict(runs[0])
                cell.update({
                    "model": name,
                    "vmfb": os.path.relpath(vmfb),
                    "contract": os.path.relpath(contract),
                    "repeats": a.repeats,
                    "peaks_observed": peaks,
                    # a peak that is not the same across repeats is timing-dependent:
                    # the threads did not actually overlap every time. N x per_call is
                    # an UPPER BOUND on what overlap costs, never a law.
                    "deterministic": len(set(peaks)) == 1,
                    "peak": max(peaks),
                })
                cells.append(cell)

    single = [c for c in cells if c["threads"] == 1 and not c["hold_outputs"]]
    over_bounded = [c for c in cells if c["threads"] > 1 and c["peak_within_bounded"] is False]
    summary = {
        "experiment": "E41",
        "what_this_is":
            "a measurement of behaviour OUTSIDE analysis_domain.required_premises, not a gate. "
            "The contract states nothing about these runs; the point is whether the premises are "
            "load-bearing.",
        "driver": a.driver,
        "threads_probed": threads,
        "repeats": a.repeats,
        "single_call_peak_equals_per_call":
            all(c["peak"] == c["per_call_bytes"] for c in single) if single else None,
        "premise_is_load_bearing": bool(over_bounded),
        "cells_exceeding_bounded": [
            {"model": c["model"], "threads": c["threads"], "hold_outputs": c["hold_outputs"],
             "peak": c["peak"], "bounded_bytes": c["bounded_bytes"]} for c in over_bounded],
        "cells": cells,
    }
    if not a.out:
        print("e41_domain_probe: --out is required", file=sys.stderr)
        return 2
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    with open(a.out, "w") as f:
        json.dump(summary, f, indent=2)
    print("e41_domain_probe: %d cells -> %s" % (len(cells), a.out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
