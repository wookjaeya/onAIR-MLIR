#!/usr/bin/env python3
"""D108: control flow in the module INITIALIZER, other than the map attempt's branch, is refused.

D105 made calls, loops and branches in the ENTRY a refusal. The v25 manuscript fact check found that
the initializer was never checked: the structural walker counts each `stream.resource.alloc` once
where it appears and the text path reads the packed constant size once, so both extractors count an
initializer allocation once whatever structure surrounds it. The evaluated initializers each hold
exactly one `scf.if` on the map attempt's `did_map` flag and its two `scf.yield` (the loading arms),
so no reported figure is affected.

This harness edits the archived ResNet AArch64 layout IR's last initializer print (no recompile) and
runs the PRODUCTION make_contract.py on each edit:
  control           unedited                                   -> bound 618,856
  loop_zero_alloc   scf.for around a 0-byte constant alloc      (constant totals unchanged)
  branch_zero_alloc extra scf.if around a 0-byte constant alloc (constant totals unchanged)
  loop_4096_alloc   scf.for around a 4,096-byte constant alloc  (constant totals change)

    python3 harness/d108_initializer_control_probe.py --out results/d108_initializer_control/after.json
"""
import argparse
import json
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
D = os.path.join(ROOT, "results", "e36b_aarch64_models", "b2_resnet")
SRC = os.path.join(D, "b2_resnet.layout_ir.txt")
AFF = "on(#hal.device.affinity<@__device_0>)"
CONSTS = ("\n  %q_lb = arith.constant 0 : index\n  %q_ub = arith.constant 3 : index"
          "\n  %q_st = arith.constant 1 : index\n  %q_z = arith.constant 0 : index"
          "\n  %q4096 = arith.constant 4096 : index\n  %q_true = arith.constant true")


def alloc(name, sz):
    return "%%%s = stream.resource.alloc uninitialized %s : !stream.resource<constant>{%s}" % (name, AFF, sz)


VARIANTS = {
    "loop_zero_alloc": CONSTS + "\n  scf.for %q_iv = %q_lb to %q_ub step %q_st {\n    " + alloc("q_a", "%q_z") + "\n  }",
    "branch_zero_alloc": CONSTS + "\n  scf.if %q_true {\n    " + alloc("q_a", "%q_z") + "\n  }",
    "loop_4096_alloc": CONSTS + "\n  scf.for %q_iv = %q_lb to %q_ub step %q_st {\n    " + alloc("q_a", "%q4096") + "\n  }",
}


def mutate_initializer(ir, inject):
    """Insert before the terminator of the LAST printed util.initializer."""
    starts = [m.start() for m in re.finditer(r"^util\.initializer \{", ir, re.M)]
    if not starts:
        return None
    s = starts[-1]
    end = ir.find("\n}\n", s)
    body = ir[s:end]
    rets = list(re.finditer(r"\n\s*util\.return\b", body))
    if not rets:
        return None
    cut = s + rets[-1].start()
    return ir[:cut] + inject + ir[cut:]


def production(tmp, tag, text):
    lir = os.path.join(tmp, tag + ".layout_ir.txt")
    con = os.path.join(tmp, tag + ".contract.json")
    open(lir, "w").write(text)
    cmd = [sys.executable, os.path.join(HERE, "make_contract.py"),
           "--mlir", os.path.join(D, "b2_resnet.mlir"), "--vmfb", os.path.join(D, "b2_resnet.vmfb"),
           "--layout-ir", lir, "--dump-dir", os.path.join(D, "dump"),
           "--triple", "aarch64-unknown-linux-gnu", "--cpu", "cortex-a53", "--model-name", "b2_resnet",
           "--elf-analysis", os.path.join(D, "b2_resnet.elf.json"), "--out", con]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    res = {"make_contract_rc": r.returncode, "contract_written": os.path.isfile(con)}
    if res["contract_written"]:
        c = json.load(open(con))["resources"]
        res.update({k: c.get(k) for k in ("bound_method", "bounded_bytes", "module_resident_constant_bytes")})
    err = (r.stderr or "") + (r.stdout or "")
    res["refused_for_initializer_control_flow"] = "module initializer contains call or control-flow" in err
    res["refused_for_extractor_disagreement"] = "DISAGREES with the regex parser" in err
    res["stderr_tail"] = [l for l in err.strip().splitlines() if l.strip().startswith("- ")][-3:]
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(ROOT, "results", "d108_initializer_control", "after.json"))
    ap.add_argument("--label", default="after")
    a = ap.parse_args()
    ir = open(SRC, encoding="utf-8").read()
    out = {"what": "D108 %s: production make_contract.py on edited initializer prints" % a.label,
           "source_layout_ir": os.path.relpath(SRC, ROOT), "cells": {}}
    with tempfile.TemporaryDirectory() as tmp:
        out["cells"]["control_unedited"] = production(tmp, "control", ir)
        for tag, inj in VARIANTS.items():
            text = mutate_initializer(ir, inj)
            out["cells"][tag] = production(tmp, tag, text) if text else {"error": "initializer terminator not found"}
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    json.dump(out, open(a.out, "w"), indent=1)
    open(a.out, "a").write("\n")
    for k, v in out["cells"].items():
        print("%-20s rc=%s written=%s bound=%s init_ctl=%s disagree=%s" % (
            k, v.get("make_contract_rc"), v.get("contract_written"), v.get("bounded_bytes"),
            v.get("refused_for_initializer_control_flow"), v.get("refused_for_extractor_disagreement")))


if __name__ == "__main__":
    main()
