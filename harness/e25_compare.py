#!/usr/bin/env python3
"""E25: compare the outputs of every execution path against the fixed criteria.

The criteria are the ones fixed BEFORE the experiment ran, in
docs/plans/E25_same_model_equivalence.md section 3.2:

  reference (NumPy) vs any IREE path : abs_err <= 1e-4 OR rel_err <= 1e-5, per element
  IREE path vs IREE path             : BIT-IDENTICAL (same vmfb, same runtime family)
  argmax                             : must agree everywhere, no tolerance

`rel_err = |a-b| / max(|a|, |b|, 1e-30)`. Either-of-two is not a loophole: measured on
this model, the telemetry regime passes 1/64 on absolute alone and the normalized regime
passes 59/64 on relative alone, so demanding either one by itself would fail an honest
result. That is why the criterion was written this way before any number was seen.

Usage:
  python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \\
      --reference out_numpy.npy --path ireepy=out_ireepy.npy --path nativec=out_nativec.bin \\
      --out comparison.json
Outputs (.npy or raw float32 .bin) are reshaped to (-1, n_out).
"""
import argparse
import json
import os

import numpy as np

ABS_TOL = 1e-4
REL_TOL = 1e-5


def load_outputs(path, n_out):
    a = np.load(path) if path.endswith(".npy") else np.fromfile(path, dtype=np.float32)
    return np.asarray(a, dtype=np.float32).reshape(-1, n_out)


def elementwise(a, b):
    abs_err = np.abs(a - b)
    rel_err = abs_err / np.maximum(np.maximum(np.abs(a), np.abs(b)), 1e-30)
    return abs_err, rel_err, (abs_err <= ABS_TOL) | (rel_err <= REL_TOL)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--model-dir", required=True, help="directory holding manifest.json + inputs.npy")
    ap.add_argument("--reference", required=True, help=".npy of the NumPy reference outputs")
    ap.add_argument("--path", action="append", default=[], metavar="NAME=FILE",
                    help="an IREE execution path's outputs; repeatable")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    man = json.load(open(os.path.join(a.model_dir, "manifest.json")))
    n_out = man["params"]["n_out"]
    regimes = np.array(man.get("input_regimes") or ["all"] * man["params"]["n_inputs"])
    ref = load_outputs(a.reference, n_out)
    paths = {}
    for spec in a.path:
        name, _, f = spec.partition("=")
        paths[name] = load_outputs(f, n_out)

    report = {"criteria": {"abs_tol": ABS_TOL, "rel_tol": REL_TOL,
                           "rule": "abs<=abs_tol OR rel<=rel_tol, per element",
                           "iree_vs_iree": "bit-identical",
                           "argmax": "must agree everywhere"},
              "model_manifest_sha256": man["sha256"], "n_out": n_out,
              "vs_reference": {}, "iree_vs_iree": {}, "argmax": {}, "pass": True}

    for name, arr in sorted(paths.items()):
        if arr.shape != ref.shape:
            report["vs_reference"][name] = {"error": "shape %s != reference %s" % (arr.shape, ref.shape)}
            report["pass"] = False
            continue
        per_regime = {}
        for rname in sorted(set(regimes.tolist())):
            m = regimes == rname
            ae, re_, ok = elementwise(arr[m], ref[m])
            per_regime[rname] = {
                "elements": int(ok.size), "passed": int(ok.sum()),
                "abs_max": float(ae.max()), "rel_max": float(re_.max()),
                # recorded so the "either-of-two" design is auditable, not just asserted
                "would_pass_abs_only": int((ae <= ABS_TOL).sum()),
                "would_pass_rel_only": int((re_ <= REL_TOL).sum()),
                "output_abs_max": float(np.abs(ref[m]).max()),
            }
            if int(ok.sum()) != int(ok.size):
                report["pass"] = False
        per_regime["all_passed"] = all(v["passed"] == v["elements"] for v in per_regime.values()
                                       if isinstance(v, dict))
        report["vs_reference"][name] = per_regime

    names = sorted(paths)
    for i in range(len(names)):
        for j in range(i + 1, len(names)):
            x, y = paths[names[i]], paths[names[j]]
            same = x.shape == y.shape and np.array_equal(x.view(np.uint32), y.view(np.uint32))
            report["iree_vs_iree"]["%s__vs__%s" % (names[i], names[j])] = {
                "bit_identical": bool(same),
                "differing_elements": int((x != y).sum()) if x.shape == y.shape else None,
            }
            if not same:
                report["pass"] = False

    ref_am = ref.argmax(1)
    for name, arr in sorted(paths.items()):
        agree = int((arr.argmax(1) == ref_am).sum()) if arr.shape == ref.shape else -1
        report["argmax"][name] = {"agree_with_reference": agree, "total": int(ref.shape[0])}
        if agree != int(ref.shape[0]):
            report["pass"] = False

    with open(a.out, "w") as f:
        json.dump(report, f, indent=2)
        f.write("\n")
    print("wrote %s" % a.out)
    print("VERDICT: %s" % ("PASS" if report["pass"] else "FAIL"))
    for name, v in sorted(report["vs_reference"].items()):
        for rname, d in sorted(v.items()):
            if isinstance(d, dict):
                print("  %-9s %-11s %d/%d  abs_max=%.3e rel_max=%.3e  (abs-only %d, rel-only %d)"
                      % (name, rname, d["passed"], d["elements"], d["abs_max"], d["rel_max"],
                         d["would_pass_abs_only"], d["would_pass_rel_only"]))
    for k, v in sorted(report["iree_vs_iree"].items()):
        print("  bit-identical %-28s %s" % (k, v["bit_identical"]))
    return 0 if report["pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
