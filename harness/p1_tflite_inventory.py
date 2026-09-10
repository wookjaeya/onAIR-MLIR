#!/usr/bin/env python3
"""P1 (E30): machine-readable inventory of a TFLite flatbuffer -- I/O signature,
operator histogram, per-instance detail for structurally sensitive ops, static
shape check, and the cFS interface fit this repository's C paths assume.

Reads the flatbuffer with the `tflite` schema package only (no TensorFlow, no
ai_edge_litert) -- the same route E26's plan used by hand; this file pins it as
a reproducible tool.  It records what the model IS; it does not transform it.

Usage: p1_tflite_inventory.py MODEL.tflite --out inventory.json
Requires: pip install tflite  (schema bindings; version recorded in the output)
"""
import argparse, collections, hashlib, json, os, sys

try:
    import tflite
    from tflite.SqueezeOptions import SqueezeOptions
except ImportError as e:  # explicit, not a crash (D24 lesson)
    print("p1_tflite_inventory: `tflite` schema package not installed: %s" % e, file=sys.stderr)
    sys.exit(2)

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from tflite2onnx_ext_squeeze import check_squeeze_conditions, normalize_squeeze_dims  # noqa: E402
# Single source of truth for TFLite SQUEEZE semantics (E30b/D56 adversarial review, medium finding
# 2 of 2): this file used to compute C1/C4 straight off the raw squeeze_dims, so a TFLite-valid
# negative-axis SQUEEZE ([-3,-2] on a rank-4 tensor) was reported as FAILING conditions the sibling
# converter (harness/tflite2onnx_ext_squeeze.py) correctly ACCEPTS on the identical file -- an
# inventory tool contradicting the transform it is meant to audit. Importing the same two pure
# functions the converter uses makes divergence between the two P1 tools impossible by construction.

TYPES = {getattr(tflite.TensorType, n): n for n in dir(tflite.TensorType) if not n.startswith("_")}
BOPS = {getattr(tflite.BuiltinOperator, n): n for n in dir(tflite.BuiltinOperator) if not n.startswith("_")}


def shape_of(t):
    return [t.Shape(j) for j in range(t.ShapeLength())]


def sig_of(t):
    n = t.ShapeSignatureLength()
    return [t.ShapeSignature(j) for j in range(n)] if n else None


def tensor_rec(g, idx):
    t = g.Tensors(idx)
    return {"index": idx, "name": t.Name().decode(errors="replace"), "shape": shape_of(t),
            "shape_signature": sig_of(t), "dtype": TYPES.get(t.Type(), str(t.Type()))}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("model")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    buf = open(a.model, "rb").read()
    m = tflite.Model.GetRootAsModel(buf, 0)
    inv = {
        "tool": "harness/p1_tflite_inventory.py",
        "schema_package": {"tflite": getattr(tflite, "__version__", "unknown")},
        "file": {"path": a.model, "bytes": len(buf), "sha256": hashlib.sha256(buf).hexdigest()},
        "schema_version": m.Version(),
        "description": (m.Description() or b"").decode(errors="replace"),
        "subgraphs": m.SubgraphsLength(),
    }
    inv["inventory_complete"] = (m.SubgraphsLength() == 1)
    if not inv["inventory_complete"]:
        inv["note"] = ("multi-subgraph model (%d subgraphs); only subgraph 0 inventoried -- "
                       "operator/custom-op histogram and dynamic-tensor counts are PARTIAL, "
                       "not a complete picture of the model") % m.SubgraphsLength()
    g = m.Subgraphs(0)
    inv["inputs"] = [tensor_rec(g, g.Inputs(k)) for k in range(g.InputsLength())]
    inv["outputs"] = [tensor_rec(g, g.Outputs(k)) for k in range(g.OutputsLength())]

    ops = collections.Counter()
    custom = []
    instances = []
    for i in range(g.OperatorsLength()):
        op = g.Operators(i)
        oc = m.OperatorCodes(op.OpcodeIndex())
        code = oc.BuiltinCode()
        name = BOPS.get(code, str(code))
        if name == "CUSTOM":
            cc = oc.CustomCode()
            name = "CUSTOM:" + (cc.decode(errors="replace") if cc else "?")
            custom.append(name)
        ops[name] += 1
        if name == "SQUEEZE":
            ins = [op.Inputs(j) for j in range(op.InputsLength())]
            outs = [op.Outputs(j) for j in range(op.OutputsLength())]
            ti, to = g.Tensors(ins[0]), g.Tensors(outs[0])
            ishape, oshape = shape_of(ti), shape_of(to)
            bo = op.BuiltinOptions()
            if bo is None:   # no SqueezeOptions table: TFLite treats it as empty squeeze_dims
                raw_dims = []  # explicit, not a crash (D24 class; converter has the same fix, E30b)
            else:
                so = SqueezeOptions(); so.Init(bo.Bytes, bo.Pos)
                raw_dims = [so.SqueezeDims(j) for j in range(so.SqueezeDimsLength())]
            dims = normalize_squeeze_dims(raw_dims, ishape)  # negatives, dedupe, empty == all size-1
            ok, audit = check_squeeze_conditions(ishape, oshape, ti.Type(), to.Type(), dims)
            instances.append(dict(audit, op_index=i, op="SQUEEZE", raw_squeeze_dims=raw_dims,
                                  input=tensor_rec(g, ins[0]), output=tensor_rec(g, outs[0]),
                                  conditions_1_to_4_satisfied=ok))
    inv["operators"] = {"total": g.OperatorsLength(), "distinct": len(ops),
                        "histogram": dict(sorted(ops.items(), key=lambda kv: -kv[1])),
                        "custom": custom}
    inv["sensitive_instances"] = instances

    dyn = []
    for i in range(g.TensorsLength()):
        s = shape_of(g.Tensors(i))
        if any(d < 0 for d in s):
            dyn.append({"index": i, "shape": s})
    inv["static_shapes"] = {"tensors": g.TensorsLength(), "dynamic_tensors": len(dyn), "examples": dyn[:8],
                            "note": "shape (concrete) is what the flatbuffer executes with; "
                                    "shape_signature may carry -1 for a batch the exporter left symbolic"}
    # cFS interface fit as this repository's C executors assume it (single f32 in / single f32 out)
    fit = (len(inv["inputs"]) == 1 and len(inv["outputs"]) == 1
           and inv["inputs"][0]["dtype"] == "FLOAT32" and inv["outputs"][0]["dtype"] == "FLOAT32"
           and not dyn)
    inv["cfs_interface_fit"] = {"single_f32_in_single_f32_out_static": fit,
                                "input_elems": (lambda s: __import__("math").prod(s))(inv["inputs"][0]["shape"]) if inv["inputs"] else None,
                                "output_elems": (lambda s: __import__("math").prod(s))(inv["outputs"][0]["shape"]) if inv["outputs"] else None}
    with open(a.out, "w") as fh:
        json.dump(inv, fh, indent=1)
    print(json.dumps({k: inv[k] for k in ("file", "operators", "static_shapes", "cfs_interface_fit")}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
