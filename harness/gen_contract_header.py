#!/usr/bin/env python3
"""Generate a C header from a contract.json so that build-time constants are
never copied by hand (reviewer v0.6 SS3).  Both the standalone native learner
and the cFS app include the generated header.

Usage: python3 harness/gen_contract_header.py contract.json contract_gen.h

Macro set (shared C interface of E14 Stage 1; keep names stable):
  CONTRACT_MODEL_NAME              string   model.name (fallback: artifact file stem)
  CONTRACT_TARGET_TRIPLE           string   target.triple
  CONTRACT_BOUND_METHOD            string   resources.bound_method
  CONTRACT_BOUND_KNOWN             0/1      0 when bound_method == "NONE", any size unresolved,
                                            or bounded_bytes is null -> gate must return UNKNOWN_BOUND
  CONTRACT_BOUNDED_BYTES           long     resources.bounded_bytes, -1L when unknown
  CONTRACT_PER_CALL_BYTES          long     resources.static_per_call_bytes, -1L when unknown
  CONTRACT_CONST_BYTES             long     resources.module_resident_constant_bytes, -1L when unknown
  CONTRACT_KERNEL_STACK_BYTES_KNOWN 0/1     0 when resources.kernel_task_stack_bytes absent/null
  CONTRACT_KERNEL_STACK_BYTES      long     max stack-frame bytes over the executable's dispatch
                                            functions (ELF analysis); 0 when none/unknown.
                                            Task-stack budget bucket, NOT part of the HAL contract.
  CONTRACT_ARTIFACT_BYTES          long     artifact.bytes
  CONTRACT_ARTIFACT_SHA256         string   artifact.sha256 (64 hex)
  CONTRACT_ENTRY                   string   "module." + validity.entry (iree_runtime_call_initialize_by_name)
  CONTRACT_INPUT_RANK / _SHAPE / _ELEMS     validity.input.shape (brace initializer, e.g. {1, 9})
  CONTRACT_OUTPUT_RANK / _SHAPE / _ELEMS    validity.output.shape
  CONTRACT_NUM_INPUTS / CONTRACT_NUM_OUTPUTS  from interface.inputs/outputs (1 when absent)
  CONTRACT_SHAPES_STATIC           0/1      0 when any dim is dynamic (then the dim is -1 in the
                                            initializer and *_ELEMS is 0; bound_method is NONE too)
  CONTRACT_DRIVER                  string   validity.driver

Contracts written before E14 Stage 1 lack the new fields; they default as
documented above (bound known unless bound_method == "NONE"; kernel stack 0 and
unknown; entry "infer").
"""
import json
import math
import sys


def c_str(s):
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"') + '"'


def is_int(v):
    return isinstance(v, int) and not isinstance(v, bool)


def long_or(v, default=-1):
    return "%dL" % (v if is_int(v) else default)


def shape_from(c, kind, fallback):
    v = c.get("validity") or {}
    i = c.get("interface") or {}
    for src in (v.get(kind), i.get(kind)):
        if isinstance(src, dict) and isinstance(src.get("shape"), list) and src["shape"]:
            if any(not is_int(d) for d in src["shape"]):
                # dynamic dim (null / "?"): -1 in the initializer, ELEMS 0, CONTRACT_SHAPES_STATIC 0.
                # Such contracts also have bound_method NONE, so the gate refuses before shapes matter.
                print("gen_contract_header: WARNING %s shape %s has dynamic dims; emitting -1 for them" % (kind, src["shape"]), file=sys.stderr)
                return [int(d) if is_int(d) else -1 for d in src["shape"]], "contract-dynamic"
            return [int(d) for d in src["shape"]], "contract"
    print("gen_contract_header: WARNING %s shape missing in contract; using legacy default %s" % (kind, fallback), file=sys.stderr)
    return list(fallback), "legacy-default"


def main():
    if len(sys.argv) != 3:
        print("usage: gen_contract_header.py contract.json out.h", file=sys.stderr)
        return 2
    c = json.load(open(sys.argv[1]))
    out = sys.argv[2]
    r = c["resources"]
    a = c["artifact"]
    v = c.get("validity") or {}
    m = c.get("model") or {}
    t = c.get("target") or {}
    i = c.get("interface") or {}

    name = m.get("name") or (a.get("file", "model.vmfb").rsplit(".", 1)[0]) or "unknown"
    triple = t.get("triple") or "unknown"
    method = r.get("bound_method") or "unspecified"
    bounded = r.get("bounded_bytes")
    unresolved = r.get("unresolved_sizes") or []
    bound_known = (method != "NONE") and is_int(bounded) and not unresolved
    if not bound_known:
        bounded = None
    # Use the per-invocation worst case (frame + return address + any stack
    # realignment padding the codegen inserted), not the bare callee-save+locals
    # figure -- realignment padding is real stack the task can actually consume
    # (E14 Stage 1, conv2d: 128 B frame vs. 191 B worst-case invocation).
    stack = r.get("kernel_task_stack_invocation_bytes")
    if stack is None:
        stack = r.get("kernel_task_stack_bytes")
    stack_known = is_int(stack)
    entry = v.get("entry") or m.get("entry") or "infer"
    in_shape, in_src = shape_from(c, "input", [1, 9])
    out_shape, out_src = shape_from(c, "output", [1, 2])
    n_in = len(i.get("inputs") or []) or 1
    n_out = len(i.get("outputs") or []) or 1
    sha = a["sha256"]
    if len(sha) != 64:
        raise SystemExit("artifact.sha256 is not 64 hex chars")

    lines = [
        "/* GENERATED from contract.json -- do not edit */",
        "#ifndef CONTRACT_GEN_H",
        "#define CONTRACT_GEN_H",
        "#define CONTRACT_MODEL_NAME %s" % c_str(name),
        "#define CONTRACT_TARGET_TRIPLE %s" % c_str(triple),
        "#define CONTRACT_BOUND_METHOD %s" % c_str(method),
        "#define CONTRACT_BOUND_KNOWN %d" % (1 if bound_known else 0),
        "#define CONTRACT_BOUNDED_BYTES %s" % long_or(bounded),
        "#define CONTRACT_PER_CALL_BYTES %s" % long_or(r.get("static_per_call_bytes") if bound_known else None),
        "#define CONTRACT_CONST_BYTES %s" % long_or(r.get("module_resident_constant_bytes")),
        "#define CONTRACT_KERNEL_STACK_BYTES_KNOWN %d" % (1 if stack_known else 0),
        "#define CONTRACT_KERNEL_STACK_BYTES %s" % long_or(stack if stack_known else 0, 0),
        "#define CONTRACT_ARTIFACT_BYTES %s" % long_or(a["bytes"]),
        "#define CONTRACT_ARTIFACT_SHA256 %s" % c_str(sha),
        "#define CONTRACT_ENTRY %s" % c_str("module." + entry),
        "#define CONTRACT_INPUT_RANK %d" % len(in_shape),
        "#define CONTRACT_INPUT_SHAPE {%s}" % ", ".join(str(d) for d in in_shape),
        "#define CONTRACT_INPUT_ELEMS %d" % (int(math.prod(in_shape)) if all(d >= 0 for d in in_shape) else 0),
        "#define CONTRACT_OUTPUT_RANK %d" % len(out_shape),
        "#define CONTRACT_OUTPUT_SHAPE {%s}" % ", ".join(str(d) for d in out_shape),
        "#define CONTRACT_OUTPUT_ELEMS %d" % (int(math.prod(out_shape)) if all(d >= 0 for d in out_shape) else 0),
        "#define CONTRACT_SHAPES_STATIC %d" % (1 if all(d >= 0 for d in in_shape + out_shape) else 0),
        "#define CONTRACT_NUM_INPUTS %d" % n_in,
        "#define CONTRACT_NUM_OUTPUTS %d" % n_out,
        "#define CONTRACT_DRIVER %s" % c_str(v.get("driver", "local-sync")),
        "#endif",
    ]
    with open(out, "w") as f:
        f.write("\n".join(lines) + "\n")
    print("wrote", out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
