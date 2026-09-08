#!/usr/bin/env python3
"""harness/cross_target_compare.py -- side-by-side comparison of contracts for
the same model compiled for different targets (proposal SS13, RQ1/RQ2 of
docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md).

  python3 harness/cross_target_compare.py --contracts x86.json aarch64.json [...] \
      [--native-summaries x86.json=run_x86.json[#dotted.key] aarch64.json=run_a64.json[#key]] \
      [--tol 1e-5] --out comparison.json

Per model (grouped by model.name; `--contracts name=path` overrides the name)
the fields of SS13 are put side by side for every target:
  bounded / per-call / constants bytes, vmfb sha256 + size, embedded ELF size,
  LLVM alloca count, ELF call count, ELF stack-frame bytes,
and, when a native run summary is mapped to the contract:
  HAL observed peak, steady-state per-call allocation, peak_within_bounded,
  steady_within_per_call, out0.
Booleans per model: identical_bounded_bytes, identical_per_call_bytes,
identical_constant_bytes, both_sound (null unless every target has a summary),
out0_agreement (max |out0_i - out0_j| <= tol; null unless >= 2 values).

Native run summary JSON: an object with keys hal_device_bytes_peak,
hal_bytes_per_call_steady, peak_within_bounded, steady_within_per_call, out0
(legacy aliases hal_peak / hal_bytes_per_call are accepted).  If the file nests
the block, select it with `#dotted.key`; otherwise the first object that carries
hal_device_bytes_peak (or hal_peak) is used.  peak_within_bounded /
steady_within_per_call are recomputed from the contract when absent; the JSON
says which ("given" vs "computed").

Only deterministic values are compared; latency fields are ignored.
"""
import argparse
import json
import os
import sys

SUMMARY_KEYS = ("hal_device_bytes_peak", "hal_bytes_per_call_steady", "peak_within_bounded",
                "steady_within_per_call", "out0")
ALIASES = {"hal_device_bytes_peak": ("hal_device_bytes_peak", "hal_peak"),
           "hal_bytes_per_call_steady": ("hal_bytes_per_call_steady", "hal_bytes_per_call"),
           "peak_within_bounded": ("peak_within_bounded",),
           "steady_within_per_call": ("steady_within_per_call",),
           "out0": ("out0",)}


def load(path):
    with open(path) as f:
        return json.load(f)


def get(d, *keys, default=None):
    cur = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return default
        cur = cur[k]
    return cur


def first_int(*vals):
    for v in vals:
        if isinstance(v, int) and not isinstance(v, bool):
            return v
    return None


def contract_row(path, c):
    r = c.get("resources", {})
    t = c.get("target", {})
    a = c.get("artifact", {})
    e13 = c.get("e13", {})  # legacy block of contract.e13_host.json
    emb = a.get("embedded_executables") or []
    label = "%s/%s" % (t.get("triple", "?"), t.get("cpu") or t.get("profile") or "?")
    return {
        "contract_file": os.path.basename(path),
        "target": label,
        "triple": t.get("triple"),
        "cpu": t.get("cpu"),
        "bound_method": r.get("bound_method"),
        "bounded_bytes": r.get("bounded_bytes"),
        "static_per_call_bytes": r.get("static_per_call_bytes"),
        "static_transient_bytes": r.get("static_transient_bytes"),
        "static_io_bytes": r.get("static_io_bytes"),
        "module_resident_constant_bytes": r.get("module_resident_constant_bytes"),
        "vmfb_sha256": a.get("sha256"),
        "vmfb_bytes": first_int(a.get("bytes"), r.get("binary_size_bytes")),
        "elf_bytes": first_int(r.get("kernel_elf_bytes"), emb[0].get("bytes") if emb else None),
        "elf_sha256": r.get("kernel_elf_sha256") or (emb[0].get("sha256") if emb else None),
        "llvm_alloca_count": first_int(r.get("llvm_alloca_count"), e13.get("llvm_ir_alloca_count")),
        "elf_call_insns": first_int(r.get("kernel_external_call_insns"), e13.get("kernel_elf_call_insns")),
        "elf_stack_frame_bytes": first_int(r.get("kernel_task_stack_bytes"), e13.get("kernel_elf_stack_frame_bytes")),
        "kernel_stack_classification": r.get("kernel_stack_classification"),
        "dispatches": r.get("dispatches"),
        "constants_confirmed_in_artifact": r.get("constants_independently_confirmed_in_artifact",
                                                 r.get("constants_confirmed_in_artifact")),
        "single_invocation": get(c, "provenance", "single_invocation"),
        "compiler": get(c, "validity", "compiler"),
    }


def find_summary_block(obj, dotted=None):
    if dotted:
        cur = obj
        for k in dotted.split("."):
            if isinstance(cur, list):
                cur = cur[int(k)]
            else:
                cur = cur[k]
        return cur
    stack = [obj]
    while stack:
        cur = stack.pop(0)
        if isinstance(cur, dict):
            if any(k in cur for k in ("hal_device_bytes_peak", "hal_peak")):
                return cur
            stack.extend(cur.values())
        elif isinstance(cur, list):
            stack.extend(cur)
    return None


def summary_row(block, row):
    out = {}
    for key, names in ALIASES.items():
        val = None
        for n in names:
            if n in block:
                val = block[n]
                break
        out[key] = val
    src = {"peak_within_bounded": "given" if out["peak_within_bounded"] is not None else None,
           "steady_within_per_call": "given" if out["steady_within_per_call"] is not None else None}
    if out["peak_within_bounded"] is None and isinstance(out["hal_device_bytes_peak"], (int, float)) \
            and isinstance(row["bounded_bytes"], int):
        out["peak_within_bounded"] = out["hal_device_bytes_peak"] <= row["bounded_bytes"]
        src["peak_within_bounded"] = "computed"
    if out["steady_within_per_call"] is None and isinstance(out["hal_bytes_per_call_steady"], (int, float)) \
            and isinstance(row["static_per_call_bytes"], int):
        out["steady_within_per_call"] = out["hal_bytes_per_call_steady"] <= row["static_per_call_bytes"]
        src["steady_within_per_call"] = "computed"
    out["sound"] = (out["peak_within_bounded"] is True and out["steady_within_per_call"] is True) \
        if (out["peak_within_bounded"] is not None and out["steady_within_per_call"] is not None) else None
    out["source_of_verdicts"] = src
    return out


def all_equal(vals):
    vals = [v for v in vals]
    return len(vals) >= 2 and all(v is not None for v in vals) and len({json.dumps(v) for v in vals}) == 1


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--contracts", nargs="+", required=True, help="contract JSON paths, optionally name=path")
    ap.add_argument("--native-summaries", nargs="*", default=[],
                    help="contract_path=summary.json[#dotted.key] mappings (contract_path as given in --contracts)")
    ap.add_argument("--tol", type=float, default=1e-5, help="out0 agreement tolerance (abs)")
    ap.add_argument("--out", required=True)
    a = ap.parse_args(argv)

    summaries = {}
    for m in a.native_summaries:
        if "=" not in m:
            ap.error("--native-summaries entries must be contract_path=summary.json[#key]: %r" % m)
        cpath, spec = m.split("=", 1)
        spath, _, dotted = spec.partition("#")
        block = find_summary_block(load(spath), dotted or None)
        if block is None:
            ap.error("no native summary block found in %s" % spath)
        summaries[os.path.normpath(cpath)] = {"file": spath, "key": dotted or None, "block": block}

    models = {}
    order = []
    for spec in a.contracts:
        name = None
        path = spec
        if "=" in spec and not os.path.exists(spec):
            name, path = spec.split("=", 1)
        c = load(path)
        name = name or get(c, "model", "name") or os.path.basename(path)
        row = contract_row(path, c)
        s = summaries.get(os.path.normpath(path))
        if s:
            row["native"] = summary_row(s["block"], row)
            row["native"]["summary_file"] = s["file"]
            row["native"]["summary_key"] = s["key"]
        else:
            row["native"] = None
        if name not in models:
            models[name] = []
            order.append(name)
        models[name].append(row)

    result = {"tool": "harness/cross_target_compare.py", "tol_out0": a.tol, "models": {}}
    for name in order:
        rows = models[name]
        bounded = [r["bounded_bytes"] for r in rows]
        per_call = [r["static_per_call_bytes"] for r in rows]
        consts = [r["module_resident_constant_bytes"] for r in rows]
        natives = [r["native"] for r in rows]
        sound_vals = [n["sound"] if n else None for n in natives]
        both_sound = all(v is True for v in sound_vals) if (len(rows) >= 2 and all(v is not None for v in sound_vals)) else None
        out0 = [(r["target"], n["out0"]) for r, n in zip(rows, natives) if n and isinstance(n.get("out0"), (int, float))]
        if len(out0) >= 2:
            vals = [v for _, v in out0]
            max_abs = max(abs(x - y) for i, x in enumerate(vals) for y in vals[i + 1:])
            out0_agree = {"values": {t: v for t, v in out0}, "max_abs_diff": max_abs, "tol": a.tol,
                          "agree": max_abs <= a.tol}
        else:
            out0_agree = {"values": {t: v for t, v in out0}, "max_abs_diff": None, "tol": a.tol, "agree": None}
        result["models"][name] = {
            "targets": [r["target"] for r in rows],
            "rows": rows,
            "identical_bounded_bytes": all_equal(bounded),
            "identical_per_call_bytes": all_equal(per_call),
            "identical_constant_bytes": all_equal(consts),
            "all_bounds_known": all(r["bound_method"] not in (None, "NONE") and isinstance(r["bounded_bytes"], int) for r in rows),
            "vmfb_sha256_all_distinct": len({r["vmfb_sha256"] for r in rows}) == len(rows),
            "elf_stack_frame_bytes_by_target": {r["target"]: r["elf_stack_frame_bytes"] for r in rows},
            "elf_call_insns_by_target": {r["target"]: r["elf_call_insns"] for r in rows},
            "llvm_alloca_count_by_target": {r["target"]: r["llvm_alloca_count"] for r in rows},
            "both_sound": both_sound,
            "sound_by_target": {r["target"]: s for r, s in zip(rows, sound_vals)},
            "out0_agreement": out0_agree,
        }
    result["summary"] = {
        "models": len(order),
        "all_models_identical_bounded_bytes": all(m["identical_bounded_bytes"] for m in result["models"].values()
                                                  if m["all_bounds_known"]) if order else None,
        "models_with_unknown_bound": [n for n, m in result["models"].items() if not m["all_bounds_known"]],
        "models_both_sound": [n for n, m in result["models"].items() if m["both_sound"] is True],
        "models_not_sound": [n for n, m in result["models"].items() if m["both_sound"] is False],
        "models_out0_agree": [n for n, m in result["models"].items() if m["out0_agreement"]["agree"] is True],
        "models_out0_disagree": [n for n, m in result["models"].items() if m["out0_agreement"]["agree"] is False],
    }
    with open(a.out, "w") as f:
        json.dump(result, f, indent=2)
        f.write("\n")
    for name, m in result["models"].items():
        print("%s: targets=%s bounded=%s identical=%s both_sound=%s out0_agree=%s stack=%s calls=%s alloca=%s"
              % (name, m["targets"], [r["bounded_bytes"] for r in m["rows"]], m["identical_bounded_bytes"],
                 m["both_sound"], m["out0_agreement"]["agree"], m["elf_stack_frame_bytes_by_target"],
                 m["elf_call_insns_by_target"], m["llvm_alloca_count_by_target"]))
    print("wrote", a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
