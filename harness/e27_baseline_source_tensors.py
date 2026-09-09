#!/usr/bin/env python3
"""Baseline (a) for E27: SOURCE-LEVEL analysis, before any lowering.

Reads the model's own `.mlir` -- the file a developer hands to `iree-compile` --
and estimates the memory a deployment would need by summing tensor types. It sees
the graph and nothing else: no allocation schedule, no buffer reuse, no alignment,
no artifact.

This is the weakest of the four information levels E27 compares, and the point is
to measure what that weakness costs. Its expected failure mode is the OPPOSITE of
baseline (b)'s: (b) reads a deployed artifact and can silently UNDER-estimate when
it fails to parse; (a) cannot under-estimate the live set for lack of reuse
information, so it should OVER-estimate. Whether an over-estimate is "safe" is
exactly what E27 measures -- an admission gate that refuses deployable models is a
type (B) defect in this repository, not a conservative virtue.

  DO NOT ADD FAIL-CLOSED HARDENING TO THIS FILE.
  It is a baseline, not a contract tool. Hardening it makes it stop being the thing
  being compared. (Same rule as harness/e27_baseline_vmfb_only.py.)

The one thing it does refuse is a dimension it cannot count: a `?` in a tensor type
has no byte size, so the result is `None` with a stated reason. That is arithmetic,
not hardening -- there is no number to report.

Usage: python3 harness/e27_baseline_source_tensors.py model.mlir [--entry infer]
"""
import argparse
import json
import re
import sys

DTYPE_BYTES = {"f64": 8, "f32": 4, "f16": 2, "bf16": 2,
               "i64": 8, "i32": 4, "i16": 2, "i8": 1, "i4": 1, "i1": 1,
               "ui8": 1, "si8": 1, "index": 8}

TENSOR_RE = re.compile(r"tensor<([0-9x?]*)x?([a-z0-9]+)>")
FUNC_RE = r"func\.func\s+(?:public\s+)?@%s\b"


def _tensor_bytes(dims_text, dtype):
    """(bytes, ok). ok=False when a dimension is dynamic or the dtype is unknown."""
    if dtype not in DTYPE_BYTES:
        return None, False
    dims = [d for d in dims_text.split("x") if d != ""]
    n = 1
    for d in dims:
        if d == "?":
            return None, False
        n *= int(d)
    return n * DTYPE_BYTES[dtype], True


def _entry_body(src, entry):
    """Text of the entry function, brace-matched from its signature."""
    m = re.search(FUNC_RE % re.escape(entry), src)
    if not m:
        return None
    i = src.index("{", m.end())
    depth, j = 0, i
    while j < len(src):
        if src[j] == "{":
            depth += 1
        elif src[j] == "}":
            depth -= 1
            if depth == 0:
                return src[i:j + 1]
        j += 1
    return src[i:]


def analyze(path, entry="infer"):
    src = open(path, encoding="utf-8", errors="replace").read()
    body = _entry_body(src, entry)
    out = {"model": path, "entry": entry, "a_entry_found": body is not None,
           "a_dynamic_dims": False, "a_unknown_dtypes": [],
           "a_constant_bytes": None, "a_live_tensor_bytes": None, "a_bounded": None,
           "a_note": ""}
    if body is None:
        out["a_note"] = "entry function @%s not found in source" % entry
        return out

    # module-resident constants: every `arith.constant dense<...> : tensor<...>`
    const_total, dynamic, unknown = 0, False, []
    for m in re.finditer(r"arith\.constant\s+dense<.*?>\s*:\s*tensor<([0-9x?]*)x?([a-z0-9]+)>",
                         src, re.S):
        b, ok = _tensor_bytes(m.group(1), m.group(2))
        if ok:
            const_total += b
        elif m.group(2) not in DTYPE_BYTES:
            unknown.append(m.group(2))
        else:
            dynamic = True

    # live set: every tensor type mentioned in the entry body, counted once per
    # occurrence. No reuse model exists at this level, so this is a sum, not a peak.
    live_total = 0
    for m in TENSOR_RE.finditer(body):
        b, ok = _tensor_bytes(m.group(1), m.group(2))
        if ok:
            live_total += b
        elif m.group(2) not in DTYPE_BYTES:
            unknown.append(m.group(2))
        else:
            dynamic = True

    out["a_dynamic_dims"] = dynamic
    out["a_unknown_dtypes"] = sorted(set(unknown))
    if dynamic or unknown:
        out["a_note"] = ("cannot size: %s%s" %
                         ("dynamic dimension present" if dynamic else "",
                          (" unknown dtype(s) %s" % sorted(set(unknown))) if unknown else ""))
        return out
    out["a_constant_bytes"] = const_total
    out["a_live_tensor_bytes"] = live_total
    out["a_bounded"] = live_total + const_total
    out["a_note"] = ("sum of every tensor type in the entry body plus every dense constant; "
                     "no buffer reuse, no alignment, no allocation schedule")
    return out


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("mlir")
    ap.add_argument("--entry", default="infer")
    a = ap.parse_args()
    print(json.dumps(analyze(a.mlir, a.entry), indent=1))
