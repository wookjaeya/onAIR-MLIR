#!/usr/bin/env python3
"""E31 / P2: judge the original TFLite against the imported IREE model.

The criteria are NOT chosen here -- they were fixed in docs/plans/E31_smartcam_semantic_equivalence.md
SS4 and committed BEFORE any measurement, and they are inherited unchanged from E25 (the ninth
external review SS9.3 asks that a change to the abs/rel rule be recorded; it is not changed):

    per element:  abs_err <= 1e-4  OR  rel_err <= 1e-5      rel = |a-b| / max(|a|,|b|,1e-30)
    plus:         argmax must agree on every sample
    and:          agreeing argmax is NOT by itself equivalence -- the per-element rule decides

The two paths are different implementations of the model (LiteRT interpreter vs IREE-compiled
CPU code), so bit-identity is not required and, if observed, is not generalised (E25's lesson).

Exit status is 0 whether the verdict is PASS or FAIL -- the verdict lives in the JSON. A FAIL is
a result, not a tool error; only a genuine tool problem returns non-zero.

Usage:
  e31_compare.py --oracle oracle.json --iree iree.json --out comparison.json
                 [--abs-tol 1e-4] [--rel-tol 1e-5]
"""
import argparse, json, sys

# The pre-fixed values (plan SS4.1, inherited from E25 SS3.2). Overridable on the command line
# only so the regression tests can demonstrate that a tightened tolerance actually bites; the
# stored verdict records whichever values were used.
ABS_TOL = 1e-4
REL_TOL = 1e-5


def elem_ok(a, b, abs_tol, rel_tol):
    d = abs(a - b)
    rel = d / max(abs(a), abs(b), 1e-30)
    return (d <= abs_tol) or (rel <= rel_tol), d, rel


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--oracle", required=True)
    ap.add_argument("--iree", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--abs-tol", type=float, default=ABS_TOL)
    ap.add_argument("--rel-tol", type=float, default=REL_TOL)
    ap.add_argument("--subset", default=None,
                    help="JSON file naming the sample ids this comparison is DECLARED to cover "
                         "(E32: a cell whose scope was fixed in the plan before measuring). Both "
                         "sides must contain every named id -- this narrows the declared scope, it "
                         "does NOT relax the same-sample-set guard, and the ids are recorded in the "
                         "result so a subset can never be read as the full fixture.")
    a = ap.parse_args()

    orc = json.load(open(a.oracle))
    ire = json.load(open(a.iree))
    o_by = {r["sample_id"]: r for r in orc["results"]}
    i_by = {r["sample_id"]: r for r in ire["results"]}

    declared = None
    if a.subset:
        raw = json.load(open(a.subset))
        declared = [r["sample_id"] if isinstance(r, dict) else r for r in raw]
        if len(set(declared)) != len(declared):
            rec = {"verdict": "REFUSED", "reason": "the declared subset repeats a sample id",
                   "declared": declared}
            json.dump(rec, open(a.out, "w"), indent=1)
            print(json.dumps(rec, indent=1))
            return 0
        o_by = {k: v for k, v in o_by.items() if k in set(declared)}
        i_by = {k: v for k, v in i_by.items() if k in set(declared)}
        missing = sorted(set(declared) - (set(o_by) & set(i_by)))
        if missing:
            rec = {"verdict": "REFUSED", "reason": "a declared sample is absent from one of the runs",
                   "declared": declared, "missing": missing}
            json.dump(rec, open(a.out, "w"), indent=1)
            print(json.dumps(rec, indent=1))
            return 0

    only_oracle = sorted(set(o_by) - set(i_by))
    only_iree = sorted(set(i_by) - set(o_by))
    if only_oracle or only_iree:
        # A missing sample must never read as a pass. Refuse to judge rather than judge a subset.
        rec = {"verdict": "REFUSED", "reason": "the two runs do not cover the same samples",
               "only_in_oracle": only_oracle, "only_in_iree": only_iree}
        json.dump(rec, open(a.out, "w"), indent=1)
        print(json.dumps(rec, indent=1))
        return 0

    rows, elems_total, elems_failed, argmax_failed = [], 0, 0, 0
    worst = {"abs": 0.0, "rel": 0.0, "sample_id": None, "index": None}
    for sid in sorted(o_by):
        o, i = o_by[sid], i_by[sid]
        ov, iv = o["output"], i["output"]
        if len(ov) != len(iv):
            rows.append({"sample_id": sid, "kind": o["kind"], "ok": False,
                         "reason": "output length %d vs %d" % (len(ov), len(iv))})
            elems_failed += max(len(ov), len(iv))
            elems_total += max(len(ov), len(iv))
            continue
        per = []
        for k, (x, y) in enumerate(zip(ov, iv)):
            ok, d, rel = elem_ok(x, y, a.abs_tol, a.rel_tol)
            per.append({"index": k, "oracle": x, "iree": y, "abs_err": d, "rel_err": rel, "ok": ok})
            elems_total += 1
            if not ok:
                elems_failed += 1
            if d > worst["abs"]:
                worst = {"abs": d, "rel": rel, "sample_id": sid, "index": k}
        am_ok = o["argmax"] == i["argmax"]
        if not am_ok:
            argmax_failed += 1
        rows.append({"sample_id": sid, "kind": o["kind"],
                     "elements_ok": sum(1 for p in per if p["ok"]), "elements": len(per),
                     "argmax_oracle": o["argmax"], "argmax_iree": i["argmax"], "argmax_ok": am_ok,
                     "max_abs_err": max((p["abs_err"] for p in per), default=0.0),
                     "max_rel_err": max((p["rel_err"] for p in per), default=0.0),
                     "ok": all(p["ok"] for p in per) and am_ok,
                     "elements_detail": per})

    verdict = "PASS" if (elems_failed == 0 and argmax_failed == 0 and rows) else "FAIL"
    rec = {
        "tool": "harness/e31_compare.py",
        "experiment": "E31 (P2: SmartCam semantic preservation)",
        "criteria": {
            "source": "docs/plans/E31_smartcam_semantic_equivalence.md SS4, committed before measurement",
            "inherited_from": "E25 SS3.2, unchanged (ninth review SS9.3)",
            "abs_tol": a.abs_tol, "rel_tol": a.rel_tol,
            "rule": "per element: abs_err <= abs_tol OR rel_err <= rel_tol",
            "rel_definition": "|a-b| / max(|a|,|b|,1e-30)",
            "argmax": "must agree on every sample, but agreeing argmax is NOT equivalence on its own",
            "bit_identity": "not required between these two implementations, and not generalised if seen",
        },
        "paths": {"oracle": {"file": a.oracle, "runner": orc.get("runner"),
                             "model_sha256": orc.get("model", {}).get("sha256")},
                  "iree": {"file": a.iree, "runner": ire.get("runner"),
                           "artifact_sha256": ire.get("artifact", {}).get("sha256")}},
        "totals": {"samples": len(rows), "elements": elems_total,
                   "elements_failed": elems_failed, "argmax_failed": argmax_failed,
                   "by_kind": {k: sum(1 for r in rows if r.get("kind") == k)
                               for k in sorted({r.get("kind") for r in rows})}},
        "worst_element": worst,
        "verdict": verdict,
        "scope": ({"declared_subset": sorted(declared),
                   "note": "this verdict covers exactly these samples and no others"}
                  if declared is not None else
                  {"declared_subset": None, "note": "every sample both runs contain"}),
        "samples": rows,
    }
    json.dump(rec, open(a.out, "w"), indent=1)
    print(json.dumps({"verdict": verdict, "totals": rec["totals"], "worst_element": worst}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
