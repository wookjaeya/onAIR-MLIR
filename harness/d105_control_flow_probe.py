#!/usr/bin/env python3
"""D105: calls and control flow in a post-layout entry are refused, not counted once.

The v20 manuscript review asked where the analyzer's support range ends for called functions,
nested regions, loops and branches. A fact-finding probe ran the PRODUCTION make_contract.py
(repository HEAD 32f5102) on hand-edited copies of the archived ResNet AArch64 layout IR and
found that the walker had no rule for them: a callee printed in the same chunk as the entry had
its 4,096 B allocation omitted and the archived bound 618,856 was still issued, and an allocation
inside scf.for / scf.while was counted once. (results/d105_control_flow_boundary/before_32f5102.json)

No archived entry contains these structures -- the four evaluated entries' only region-holding
ops are stream.cmd.execute and stream.cmd.concurrent -- so no reported figure changes. The fix
makes the boundary a refusal: the walker reports call / scf / cf / affine ops under
`unsupported_control_ops` and make_contract.py refuses the entry (not overridable).

This harness regenerates the same edited IRs from the archived one (deterministic, nothing is
stored but the outcomes) and records, per cell, what the production path does now.

    python3 harness/d105_control_flow_probe.py [--out results/d105_control_flow_boundary/after.json]
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
sys.path.insert(0, HERE)
import mlir_alloc_walk as maw          # noqa: E402

D = os.path.join(ROOT, "results", "e36b_aarch64_models", "b2_resnet")
SRC = os.path.join(D, "b2_resnet.layout_ir.txt")
AFF = "on(#hal.device.affinity<@__device_0>)"


def alloca(name, sz, await_="%1", life="transient"):
    return ("%%%s, %%%s_tp = stream.resource.alloca uninitialized %s await(%s) => "
            "!stream.resource<%s>{%s} => !stream.timepoint" % (name, name, AFF, await_, life, sz))


def dealloca(name, sz):
    return ("%%%s_d = stream.resource.dealloca %s await(%%%s_tp) => %%%s : "
            "!stream.resource<transient>{%s} => !stream.timepoint" % (name, AFF, name, name, sz))


CONSTS = ("\n  %q_lb = arith.constant 0 : index\n  %q_ub = arith.constant 3 : index"
          "\n  %q_st = arith.constant 1 : index\n  %q4096 = arith.constant 4096 : index"
          "\n  %q8192 = arith.constant 8192 : index\n  %q_true = arith.constant true")

HDR = "// -----// IR Dump After LayoutSlicesPass (iree-stream-layout-slices) //----- //\n"
AFF = "on(#hal.device.affinity<@__device_0>)"


def alloca(name, sz, await_="%1", life="transient"):
    return ("%%%s, %%%s_tp = stream.resource.alloca uninitialized %s await(%s) => "
            "!stream.resource<%s>{%s} => !stream.timepoint" % (name, name, AFF, await_, life, sz))


def dealloca(name, sz):
    return ("%%%s_d = stream.resource.dealloca %s await(%%%s_tp) => %%%s : "
            "!stream.resource<transient>{%s} => !stream.timepoint" % (name, AFF, name, name, sz))


CONSTS = ("\n  %q_lb = arith.constant 0 : index\n  %q_ub = arith.constant 3 : index"
          "\n  %q_st = arith.constant 1 : index\n  %q4096 = arith.constant 4096 : index"
          "\n  %q8192 = arith.constant 8192 : index\n  %q_true = arith.constant true")

VARIANTS = {
    "scf_for_alloca_dealloca": CONSTS + (
        "\n  scf.for %q_iv = %q_lb to %q_ub step %q_st {"
        "\n    " + alloca("q_r", "%q4096") +
        "\n    " + dealloca("q_r", "%q4096") +
        "\n  }"),
    "scf_for_alloca_no_dealloca": CONSTS + (
        "\n  scf.for %q_iv = %q_lb to %q_ub step %q_st {"
        "\n    " + alloca("q_r", "%q4096") +
        "\n  }"),
    "scf_for_alloca_sized_by_iv": CONSTS + (
        "\n  scf.for %q_iv = %q_lb to %q_ub step %q_st {"
        "\n    " + alloca("q_r", "%q_iv") +
        "\n  }"),
    "scf_if_two_branches_no_results": CONSTS + (
        "\n  scf.if %q_true {"
        "\n    " + alloca("q_a", "%q4096") +
        "\n  } else {"
        "\n    " + alloca("q_b", "%q8192") +
        "\n  }"),
    "scf_if_yields_resource": CONSTS + (
        "\n  %q_sel = scf.if %q_true -> (!stream.resource<transient>) {"
        "\n    " + alloca("q_a", "%q4096") +
        "\n    scf.yield %q_a : !stream.resource<transient>"
        "\n  } else {"
        "\n    " + alloca("q_b", "%q4096") +
        "\n    scf.yield %q_b : !stream.resource<transient>"
        "\n  }"),
    "scf_while_alloca_in_body": CONSTS + (
        "\n  %q_w = scf.while (%q_x = %q_lb) : (index) -> index {"
        "\n    %q_c = arith.cmpi slt, %q_x, %q_ub : index"
        "\n    scf.condition(%q_c) %q_x : index"
        "\n  } do {"
        "\n  ^bb0(%q_y: index):"
        "\n    " + alloca("q_r", "%q4096") +
        "\n    %q_n = arith.addi %q_y, %q_st : index"
        "\n    scf.yield %q_n : index"
        "\n  }"),
    "cf_cond_br_alloca_in_blocks": CONSTS + (
        "\n  cf.cond_br %q_true, ^bb1, ^bb2"
        "\n^bb1:"
        "\n  " + alloca("q_a", "%q4096") +
        "\n  cf.br ^bb3"
        "\n^bb2:"
        "\n  " + alloca("q_b", "%q8192") +
        "\n  cf.br ^bb3"
        "\n^bb3:"),
    # a callee printed as its own dump chunk, which is how --mlir-print-ir-after prints
    # a function-scoped pass (one chunk per callable)
    "util_call_callee_in_own_chunk": "\n  util.call @q_helper(%1) : (!stream.timepoint) -> ()",
    # the same callee, but placed in the SAME chunk right after the entry function
    "util_call_callee_in_same_chunk": "\n  util.call @q_helper(%1) : (!stream.timepoint) -> ()",
    # a call that carries a resource operand (callee in the same chunk so the module parses)
    "util_call_resource_operand_same_chunk": "\n  util.call @q_helper_r(%result, %1) : (!stream.resource<external>, !stream.timepoint) -> ()",
}

HELPER = ("util.func private @q_helper(%q_t: !stream.timepoint) {"
          "\n  %q4096 = arith.constant 4096 : index"
          "\n  " + alloca("q_h", "%q4096", await_="%q_t") +
          "\n  util.return\n}\n")
HELPER_R = ("util.func private @q_helper_r(%q_x: !stream.resource<external>, %q_t: !stream.timepoint) {"
            "\n  %q4096 = arith.constant 4096 : index"
            "\n  " + alloca("q_h", "%q4096", await_="%q_t") +
            "\n  util.return\n}\n")


def mutate(ir, inject):
    ms = list(re.finditer(r"(util\.func|func\.func)\s+public\s+@infer\b.*?\n\}", ir, re.S))
    s, e = ms[-1].span()
    body = ir[s:e]
    cut = list(re.finditer(r"\n\s*util\.return\b", body))[-1].start()
    return ir[:s] + body[:cut] + inject + body[cut:] + ir[e:], e + len(inject)


FHELP = ("func.func private @q_fh(%q_t: !stream.timepoint) {"
         "\n  %q4096 = arith.constant 4096 : index"
         "\n  " + alloca("q_h", "%q4096", await_="%q_t") + "\n  return\n}\n")


def mutate(ir, inject):
    ms = list(re.finditer(r"(util\.func|func\.func)\s+public\s+@infer\b.*?\n\}", ir, re.S))
    s, e = ms[-1].span()
    body = ir[s:e]
    cut = list(re.finditer(r"\n\s*util\.return\b", body))[-1].start()
    return ir[:s] + body[:cut] + inject + body[cut:] + ir[e:], e + len(inject)


def cases(ir):
    out = {"control_unedited": ir}
    for tag, inj in VARIANTS.items():
        text, end = mutate(ir, inj)
        if tag == "util_call_callee_in_own_chunk":
            text = text + HDR + HELPER
        elif tag == "util_call_callee_in_same_chunk":
            text = text[:end] + "\n" + HELPER + text[end:]
        elif tag == "util_call_resource_operand_same_chunk":
            text = text[:end] + "\n" + HELPER_R + text[end:]
        out[tag] = text
    t, end = mutate(ir, "\n  func.call @q_fh(%1) : (!stream.timepoint) -> ()")
    out["func_call_callee_in_own_chunk"] = t + HDR + FHELP
    out["func_call_callee_in_same_chunk"] = t[:end] + "\n" + FHELP + t[end:]
    return out


def production(tmp, tag, text):
    lir = os.path.join(tmp, tag + ".layout_ir.txt")
    con = os.path.join(tmp, tag + ".contract.json")
    with open(lir, "w", encoding="utf-8") as fh:
        fh.write(text)
    cmd = [sys.executable, os.path.join(HERE, "make_contract.py"),
           "--mlir", os.path.join(D, "b2_resnet.mlir"), "--vmfb", os.path.join(D, "b2_resnet.vmfb"),
           "--layout-ir", lir, "--dump-dir", os.path.join(D, "dump"),
           "--triple", "aarch64-unknown-linux-gnu", "--cpu", "cortex-a53", "--model-name", "b2_resnet",
           "--elf-analysis", os.path.join(D, "b2_resnet.elf.json"), "--out", con]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    res = {"make_contract_rc": r.returncode, "contract_written": os.path.isfile(con)}
    if res["contract_written"]:
        c = json.load(open(con))["resources"]
        res.update({k: c.get(k) for k in ("bound_method", "bounded_bytes")})
    try:
        w = maw.parse_alloc_ir_structural(text, "infer")
        res["walker_unsupported_control_ops"] = sorted(set(w.get("unsupported_control_ops") or []))
    except Exception as exc:                                        # noqa: BLE001
        res["walker_exception"] = "%s: %s" % (type(exc).__name__, str(exc)[:160])
    err = (r.stderr or "") + (r.stdout or "")
    res["refused_for_control_flow"] = "call or control-flow op" in err
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(ROOT, "results", "d105_control_flow_boundary", "after.json"))
    a = ap.parse_args()
    ir = open(SRC, encoding="utf-8").read()
    out = {"what": "D105 AFTER the fix: production make_contract.py on the same edited IRs",
           "source_layout_ir": os.path.relpath(SRC, ROOT), "cells": {}}
    with tempfile.TemporaryDirectory() as tmp:
        for tag, text in cases(ir).items():
            out["cells"][tag] = production(tmp, tag, text)
    json.dump(out, open(a.out, "w"), indent=1)
    open(a.out, "a").write("\n")
    for k, v in out["cells"].items():
        print("%-48s rc=%s written=%s bound=%s ctl=%s" % (k, v["make_contract_rc"], v["contract_written"],
                                                          v.get("bounded_bytes"), v.get("walker_unsupported_control_ops")))


if __name__ == "__main__":
    main()
