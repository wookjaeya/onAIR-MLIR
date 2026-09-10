#!/usr/bin/env python3
"""E25: compare the outputs of every execution path against the fixed criteria.

The criteria are the ones fixed BEFORE the experiment ran, in
docs/plans/E25_same_model_equivalence.md section 3.2:

  reference (NumPy) vs any IREE path : abs_err <= 1e-4 OR rel_err <= 1e-5, per element
  IREE path vs IREE path, SAME vmfb  : BIT-IDENTICAL (same bytes, same runtime family)
  IREE path vs IREE path, OTHER vmfb : the reference tolerance above, plus equal argmax
  argmax                             : must agree everywhere, no tolerance

The split by vmfb identity is the plan's, not a later relaxation: section 3.2 lists
"cFS AArch64 <-> x86-64" under the tolerance row because they are different compilation
outputs, and section 3.3-5 repeats it.  The first implementation demanded bit-identity of
EVERY pair, which the E25 data happened to satisfy -- but that is a type (B) defect
(over-rejection): another model whose cross-ISA outputs agree within tolerance and differ
in the last bit would have been reported as FAIL.  E25b implements the rule as planned and
re-adjudicated the stored E25 outputs with it: PASS and every number unchanged.
Which rule applies to a pair is decided by the artifact sha256 the path loaded, so every
--path must come with a --vmfb; a path without one is refused rather than guessed at.

`rel_err = |a-b| / max(|a|, |b|, 1e-30)`. Either-of-two is not a loophole: measured on
this model, the telemetry regime passes 1/64 on absolute alone and the normalized regime
passes 59/64 on relative alone, so demanding either one by itself would fail an honest
result. That is why the criterion was written this way before any number was seen.

Usage:
  python3 harness/e25_compare.py --model-dir results/e25_equivalence/model \\
      --reference out_numpy.npy \\
      --path ireepy=out_ireepy.npy   --vmfb ireepy=0e250c2f...   \\
      --path nativec=out_nativec.bin --vmfb nativec=0e250c2f...  \\
      --out comparison.json
Outputs (.npy or raw float32 .bin) are reshaped to (-1, n_out).
"""
import argparse
import json
import os
import re

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
    ap.add_argument("--vmfb", action="append", default=[], metavar="NAME=SHA256",
                    help="the artifact sha256 that NAME loaded (contract artifact.sha256); "
                         "required for every --path -- it selects the pair rule")
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

    # Pair rule selection needs to know which paths share an artifact.  Guessing it
    # (from the path name, or by defaulting to one rule) would either re-introduce the
    # over-rejection this fixes or silently weaken the bit-identity requirement that IS
    # the experiment's core claim, so an unlabelled path is refused and nothing is written.
    vmfbs = {}
    for spec in a.vmfb:
        name, _, sha = spec.partition("=")
        vmfbs[name] = sha.strip().lower()
    missing = sorted(set(paths) - set(vmfbs))
    unknown = sorted(set(vmfbs) - set(paths))
    # A malformed value is refused, not compared as a string.  Two paths that DO share an
    # artifact but whose shas were mistyped (empty, truncated, "0e250c2f...") would compare
    # unequal and silently get the weaker cross_vmfb rule -- the same shape as D28/D29/D30,
    # where absent or unusable evidence was being treated as valid evidence.  Requiring the
    # full 64-hex digest makes that a refusal instead.  The value belongs verbatim to the
    # contract's artifact.sha256 for the vmfb that path loaded.
    malformed = sorted(n for n, v in vmfbs.items() if not re.fullmatch(r"[0-9a-f]{64}", v))
    if missing or unknown or malformed:
        raise SystemExit(
            "E25 compare: every --path needs a matching --vmfb NAME=SHA256 (full 64-hex digest)"
            + ("; missing for: %s" % ", ".join(missing) if missing else "")
            + ("; --vmfb for unknown path(s): %s" % ", ".join(unknown) if unknown else "")
            + ("; not a 64-hex sha256: %s" % ", ".join(malformed) if malformed else ""))

    report = {"criteria": {"abs_tol": ABS_TOL, "rel_tol": REL_TOL,
                           "rule": "abs<=abs_tol OR rel<=rel_tol, per element",
                           "iree_vs_iree": {
                               "same_vmfb": "bit-identical",
                               "cross_vmfb": "abs<=abs_tol OR rel<=rel_tol per element, and equal argmax",
                               "selected_by": "artifact sha256 given per path via --vmfb"},
                           "argmax": "must agree everywhere"},
              "vmfb_sha256": dict(sorted(vmfbs.items())),
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
            nx, ny = names[i], names[j]
            x, y = paths[nx], paths[ny]
            shape_ok = x.shape == y.shape
            same = shape_ok and np.array_equal(x.view(np.uint32), y.view(np.uint32))
            same_vmfb = vmfbs[nx] == vmfbs[ny]
            entry = {
                "rule": "same_vmfb" if same_vmfb else "cross_vmfb",
                "vmfb_same": bool(same_vmfb),
                # always recorded, even where it is not required: cross-ISA bit-identity is
                # an observation worth keeping (E25 saw it) but never a pass condition
                "bit_identical": bool(same),
                "differing_elements": int((x != y).sum()) if shape_ok else None,
            }
            if same_vmfb:
                entry["passed"] = bool(same)
            elif not shape_ok:
                entry.update({"passed": False, "error": "shape %s != %s" % (x.shape, y.shape)})
            else:
                ae, re_, ok = elementwise(x, y)
                am_agree = int((x.argmax(1) == y.argmax(1)).sum())
                entry.update({
                    "elements": int(ok.size), "elements_passed": int(ok.sum()),
                    "abs_max": float(ae.max()), "rel_max": float(re_.max()),
                    "argmax_agree": am_agree, "argmax_total": int(x.shape[0]),
                    "passed": bool(int(ok.sum()) == int(ok.size) and am_agree == int(x.shape[0])),
                })
            report["iree_vs_iree"]["%s__vs__%s" % (nx, ny)] = entry
            if not entry["passed"]:
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
        print("  %-10s %-28s pass=%s bit_identical=%s%s"
              % (v["rule"], k, v["passed"], v["bit_identical"],
                 "" if v["rule"] == "same_vmfb" or "abs_max" not in v
                 else "  (%d/%d elems, abs_max=%.3e rel_max=%.3e, argmax %d/%d)"
                      % (v["elements_passed"], v["elements"], v["abs_max"], v["rel_max"],
                         v["argmax_agree"], v["argmax_total"])))
    return 0 if report["pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
