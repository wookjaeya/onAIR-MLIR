#!/usr/bin/env python3
"""E68: the OnAIR plugin's specification-to-artifact linkage checks, exercised on the evaluation target.

Plan: docs/plans/E68_onair_artifact_linkage.md (committed before any cell, c51ad37).

  prepare      Build results/e68_onair_linkage/art/: for each refusal cell that changes the FILE, a byte copy of the
               re-issued ResNet document next to the file the cell loads in its place --
                 L1  a relative symlink to DeepAE's evaluated artifact (another model's file, different size);
                 L2  the ResNet artifact with one byte flipped by harness/corrupt_vmfb.py (same size, other bytes).
               Writes art/manifest.json (sizes and digests of what each cell will load).
  deployments  Write configs/deployments/onair_deployments_e68_aarch64.json: the E66 deployment e66_b2_resnet_Bu,
               copied, with exactly one key changed per refusal cell (Q3 re-derives that from the file).
  summary      Read the guest cells and write results/e68_onair_linkage/summary.json (Q1-Q3).

The plugin is not changed by this experiment. Nothing here runs a model; the cells run on the AArch64 guest.
"""
import argparse
import copy
import hashlib
import json
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import corrupt_vmfb                                                  # noqa: E402

PLAN = "docs/plans/E68_onair_artifact_linkage.md (committed before any cell, c51ad37)"
OUT = os.path.join(ROOT, "results", "e68_onair_linkage")
ART = os.path.join(OUT, "art")
CELLS = os.path.join(OUT, "guest", "cells")
CONFIG = os.path.join(ROOT, "configs", "deployments", "onair_deployments_e68_aarch64.json")
E66_CONFIG = os.path.join(ROOT, "configs", "deployments", "onair_deployments_e66_aarch64.json")
BASE = "e66_b2_resnet_Bu"
DOC = "results/e66_plugin_document_rules/docs/b2_resnet/b2_resnet.contract.json"   # byte copy of E65's re-issue
RESNET_VMFB = "results/e36b_aarch64_models/b2_resnet/b2_resnet.vmfb"
DEEPAE_VMFB = "results/e36b_aarch64_models/b3_deepae/b3_deepae.vmfb"
FLIP_OFFSET = 4096
B_U = 618856

# cell -> (the single deployment key it changes, its value, expected stage, reason substring)
CELLS_DEF = {
    "e68_control": (None, None, "ran", None),
    "e68_L1_other_model_file": ("artifact_dir", "../../results/e68_onair_linkage/art/L1_other_model_file",
                                "size", "CONTRACT_ARTIFACT_MISMATCH: size"),
    "e68_L2_same_size_other_bytes": ("artifact_dir", "../../results/e68_onair_linkage/art/L2_same_size_other_bytes",
                                     "sha256", "CONTRACT_ARTIFACT_MISMATCH: sha256"),
    "e68_L3_driver": ("driver", "local-task", "driver", "deployment driver 'local-task' != contract driver"),
}


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def rel(p):
    return os.path.relpath(p, ROOT)


def dump_json(doc, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1, sort_keys=True)
        f.write("\n")


def cmd_prepare(_a):
    doc = json.load(open(os.path.join(ROOT, DOC), encoding="utf-8"))
    name = doc["artifact"]["file"]
    entries = {}
    for cell in ("L1_other_model_file", "L2_same_size_other_bytes"):
        d = os.path.join(ART, cell)
        if os.path.isdir(d):
            shutil.rmtree(d)
        os.makedirs(d)
        shutil.copyfile(os.path.join(ROOT, DOC), os.path.join(d, "b2_resnet.contract.json"))
        dst = os.path.join(d, name)
        if cell.startswith("L1"):
            os.symlink(os.path.relpath(os.path.join(ROOT, DEEPAE_VMFB), d), dst)
            how = {"loaded_in_place": DEEPAE_VMFB, "symlink_target": os.readlink(dst)}
        else:
            corrupt_vmfb.corrupt_flip(os.path.join(ROOT, RESNET_VMFB), dst, offset=FLIP_OFFSET)
            how = {"derived_from": RESNET_VMFB, "method": "corrupt_vmfb.corrupt_flip", "offset": FLIP_OFFSET}
        entries[cell] = dict(how, **{
            "dir": rel(d),
            "document_byte_identical_to": DOC,
            "document_identical": sha256_file(os.path.join(d, "b2_resnet.contract.json")) == sha256_file(os.path.join(ROOT, DOC)),
            "document_artifact_bytes": doc["artifact"]["bytes"],
            "document_artifact_sha256": doc["artifact"]["sha256"],
            "loaded_file_bytes": os.path.getsize(dst),
            "loaded_file_sha256": sha256_file(dst),
        })
    dump_json({"experiment": "E68", "plan": PLAN, "entries": entries}, os.path.join(ART, "manifest.json"))
    print(json.dumps({k: {x: v[x] for x in ("document_artifact_bytes", "loaded_file_bytes")} for k, v in entries.items()}))


def cmd_deployments(_a):
    base = json.load(open(E66_CONFIG, encoding="utf-8"))["deployments"][BASE]
    base = {k: v for k, v in base.items() if not k.startswith("_")}
    deps = {}
    for cell, (key, val, stage, _r) in CELLS_DEF.items():
        d = copy.deepcopy(base)
        if key is not None:
            d[key] = val
        d["_e68_source_deployment"] = "%s (configs/deployments/onair_deployments_e66_aarch64.json)" % BASE
        d["_e68_expected_stage"] = stage
        deps[cell] = d
    doc = {"_note": "E68 (%s): the E66 ResNet deployment at B_u and three refusal cells, each changing one key. "
                    "Written by harness/e68_onair_linkage.py deployments." % PLAN,
           "_scope": "AArch64 QEMU guest only; nothing here is run on the development host",
           "deployments": deps}
    with open(CONFIG, "w", encoding="utf-8") as f:
        f.write(json.dumps(doc, indent=1, ensure_ascii=False) + "\n")
    print(rel(CONFIG), len(deps))


def differing_keys(a, b):
    ks = (set(a) | set(b))
    return sorted(k for k in ks if not k.startswith("_") and a.get(k) != b.get(k))


def derive_summary():
    """The summary, derived from the raw guest cells, the deployment file and the art manifest (D89)."""
    base = {k: v for k, v in json.load(open(E66_CONFIG, encoding="utf-8"))["deployments"][BASE].items()
            if not k.startswith("_")}
    deps = json.load(open(CONFIG, encoding="utf-8"))["deployments"]
    man = json.load(open(os.path.join(ART, "manifest.json"), encoding="utf-8"))["entries"]
    env = open(os.path.join(OUT, "guest", "guest_env.txt"), encoding="utf-8").read()
    cells = {}
    for cell, (key, val, stage, reason) in CELLS_DEF.items():
        run = json.load(open(os.path.join(CELLS, cell, "run.json"), encoding="utf-8"))
        init = run.get("plugin_init") or {}
        diff = differing_keys(base, deps[cell])
        rec = {
            "returncode": run.get("returncode"),
            "onair_core_unmodified": (run.get("onair") or {}).get("core_unmodified"),
            "active": init.get("active"),
            "inactive_reason": init.get("inactive_reason"),
            "admission_verdict": (init.get("admission") or {}).get("verdict"),
            "binding": (init.get("binding") or {}).get("verdict"),
            "runtime_created": init.get("runtime_created"),
            "inferences": run.get("inferences"),
            "deployment_keys_differing_from_base": diff,
            "expected_stage": stage,
        }
        if stage == "ran":
            ok = (rec["active"] is True and rec["binding"] == "MATCH" and rec["runtime_created"] is True
                  and (rec["inferences"] or 0) >= 1 and rec["returncode"] == 0)
        else:
            ok = (rec["active"] is False and rec["runtime_created"] is False and rec["inferences"] == 0
                  and rec["returncode"] == 0 and reason in (rec["inactive_reason"] or ""))
        rec["as_expected"] = ok
        rec["attributed"] = diff == ([] if key is None else [key])
        art = man.get(cell.replace("e68_", ""))
        if art:
            rec["loaded_file"] = {"bytes": art["loaded_file_bytes"], "sha256": art["loaded_file_sha256"],
                                  "document_bytes": art["document_artifact_bytes"],
                                  "sha256_in_guest_env": art["loaded_file_sha256"] in env}
        cells[cell] = rec
    q1 = cells["e68_control"]["as_expected"]
    refusals = [c for c in cells if c != "e68_control"]
    q2 = all(cells[c]["as_expected"] for c in refusals)
    q3 = all(cells[c]["attributed"] for c in cells) and all(
        cells[c].get("loaded_file", {}).get("sha256_in_guest_env", True) for c in cells)
    return {
        "experiment": "E68", "plan": PLAN, "target": "AArch64 QEMU guest (cortex-a53)",
        "base_deployment": BASE, "budget_bytes": B_U, "cells": cells,
        "verdict": {"Q1_control_ran": q1, "Q2_refusals_at_expected_stage": q2, "Q3_attributed": q3,
                    "all_pass": bool(q1 and q2 and q3)},
        "code_order_not_cells": {
            "entry": "checked against the loaded module's exports after runtime creation and module append, before any "
                     "inference (no cell: every evaluated document names `infer`; a mismatch needs a hand-edited document)",
            "io_interface": "read from the document, not compared with the module; the digest binds the document to the "
                            "artifact of the compile that emitted that interface; file_replay checks each sample's shape "
                            "against the document before the call",
        },
        "not_claimed": ["defence against deliberate tampering (the digest identifies; it is not a security control)",
                        "refusal cells for models other than ResNet", "latency"],
    }


def cmd_summary(_a):
    s = derive_summary()
    dump_json(s, os.path.join(OUT, "summary.json"))
    print(json.dumps({c: (v["as_expected"], v["attributed"]) for c, v in s["cells"].items()}))


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    for c in ("prepare", "deployments", "summary"):
        sub.add_parser(c)
    a = ap.parse_args()
    {"prepare": cmd_prepare, "deployments": cmd_deployments, "summary": cmd_summary}[a.cmd](a)


if __name__ == "__main__":
    main()
