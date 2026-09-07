"""E7 / A5: memory-only admission checker.

Decision (v0.4) on the contract's memory boundary -- option (b):
    bounded  = static_per_call_bytes + module_resident_constant_bytes
               (both derived from the compiler's allocation schedule)
    excluded = IREE runtime context, thread stacks, cFS pipes/buffers
               (attributed by measurement, never bounded by the compiler)

The checker answers ONE question: given a budget for the bounded region, may
this artifact be deployed? It uses no timing, no selector, no Pareto logic.
That is deliberate: reviewer §4/§9 established that H3 (admission) is
independent of H2 (selection), and E6/E6c gave the memory axis a static
figure. This is the smallest experiment that turns that figure into a
decision and then checks the decision against reality.

Verdicts
    ACCEPT     bounded <= budget and all sizes static
    REJECT     bounded  > budget
    UNBOUNDED  a size in the schedule is not a compile-time constant;
               no static bound exists, so the artifact is refused regardless
               of budget (a "we do not know" is not a "yes")

Verification
    For every ACCEPT/REJECT we run the artifact and read the HAL allocator
    peak. observed_within = (peak + constants) <= budget.
      optimistic misprediction  = ACCEPT  and not observed_within   (the bad one)
      pessimistic misprediction = REJECT  and observed_within
"""

import argparse
import json
import os
import subprocess
import sys
import tempfile


def analyze(mlir, shape, extra, baked):
    r = subprocess.run([sys.executable, os.path.join(os.path.dirname(__file__), "static_mem_bound.py"),
                        mlir, "--shape", *map(str, shape), f"--extra={extra}"] + (["--baked"] if baked else []),
                       capture_output=True, text=True)
    txt = r.stdout
    return json.loads(txt[txt.index("{"):])


def decide(analysis, budget_bytes):
    if not analysis["all_sizes_static"]:
        return "UNBOUNDED", None
    bounded = analysis["static_total_bytes_incl_inputs"] + analysis["static_constant_bytes_module_resident"]
    return ("ACCEPT" if bounded <= budget_bytes else "REJECT"), bounded


def verify(analysis, budget_bytes):
    rc = analysis.get("runtime_check", {})
    if not rc.get("supported"):
        return None
    observed = rc["device_bytes_peak"] + analysis["static_constant_bytes_module_resident"]
    return observed, observed <= budget_bytes


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mlir", required=True)
    ap.add_argument("--shape", type=int, nargs=3, required=True)
    ap.add_argument("--extra", default="")
    ap.add_argument("--baked", action="store_true")
    ap.add_argument("--budget", type=int, required=True, help="bytes for the bounded region")
    a = ap.parse_args()
    an = analyze(a.mlir, a.shape, a.extra, a.baked)
    verdict, bounded = decide(an, a.budget)
    out = {"verdict": verdict, "bounded_bytes": bounded, "budget_bytes": a.budget,
           "components": {"per_call": an["static_total_bytes_incl_inputs"],
                          "constants": an["static_constant_bytes_module_resident"]},
           "unresolved": an["unresolved_sizes"]}
    if verdict != "UNBOUNDED":
        v = verify(an, a.budget)
        if v:
            observed, within = v
            out["observed_bytes"] = observed
            out["observed_within_budget"] = within
            out["misprediction"] = ("optimistic" if verdict == "ACCEPT" and not within else
                                    "pessimistic" if verdict == "REJECT" and within else None)
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
