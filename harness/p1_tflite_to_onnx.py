#!/usr/bin/env python3
"""P1 (E30): convert a TFLite model to ONNX with tflite2onnx + the SQUEEZE
extension, and write an audited before/after manifest.

The original .tflite is read only.  Output: MODEL.onnx and MODEL.transform_manifest.json
recording tool versions, the input/output signature before (flatbuffer) and after
(ONNX), every SQUEEZE instance's condition audit, ONNX sha256, and the ONNX node
histogram -- the artifact a reviewer needs to see that the transform is the
structural no-op it claims to be (numeric equivalence itself is P2's job).

Usage: p1_tflite_to_onnx.py MODEL.tflite OUT.onnx [--squeeze-as squeeze|reshape]
"""
import argparse, collections, hashlib, json, os, sys

import onnx
import tflite
import tflite2onnx
from tflite2onnx.model import Model

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import tflite2onnx_ext_squeeze as ext  # noqa: E402


def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tflite")
    ap.add_argument("onnx_out")
    ap.add_argument("--squeeze-as", choices=["squeeze", "reshape"], default="squeeze")
    ap.add_argument("--graph-name", default="infer",
                    help="ONNX graph name -> IREE entry function name (this repo's executors and "
                         "make_contract default to `infer`; tflite2onnx emits `pre-alpha`). Metadata only.")
    a = ap.parse_args()
    ext.EMIT_MODE["mode"] = a.squeeze_as
    assert ext.register(), "another SQUEEZE converter is already registered"

    buf = open(a.tflite, "rb").read()
    im = tflite.Model.GetRootAsModel(buf, 0)
    model = Model(im)
    model.convert(dict())
    model.onnx.graph.name = a.graph_name   # entry symbol; no tensor/node is touched
    # Canonical order. tflite2onnx keeps `initializer` and `value_info` in Python sets of
    # Tensor objects (graph.py:25-26), so their serialized order follows object identity
    # and differs from process to process -- three runs of the same input gave three
    # sha256s while every node, initializer and value_info was identical as a multiset.
    # Sorting both by name makes the ONNX bytes a function of the input alone; neither
    # list carries graph semantics (nodes are a list and are untouched).
    g = model.onnx.graph
    inits = sorted(g.initializer, key=lambda t: t.name)
    vinfo = sorted(g.value_info, key=lambda t: t.name)
    del g.initializer[:]; g.initializer.extend(inits)
    del g.value_info[:]; g.value_info.extend(vinfo)
    model.save(a.onnx_out)

    g = model.graphes[0]
    squeezes = [op for op in g.ops if isinstance(op, ext.Squeeze)]
    om = onnx.load(a.onnx_out)
    onnx.checker.check_model(om)
    hist = collections.Counter(n.op_type for n in om.graph.node)
    def vi(v):
        t = v.type.tensor_type
        return {"name": v.name, "dtype": int(t.elem_type), "shape": [d.dim_value for d in t.shape.dim]}
    man = {
        "tool": "harness/p1_tflite_to_onnx.py",
        "tflite2onnx_version": tflite2onnx.__version__, "onnx_version": onnx.__version__,
        "emit_mode": a.squeeze_as,
        "input_tflite": {"path": a.tflite, "bytes": len(buf), "sha256": hashlib.sha256(buf).hexdigest()},
        "output_onnx": {"path": a.onnx_out, "bytes": os.path.getsize(a.onnx_out), "sha256": sha(a.onnx_out),
                        "ir_version": om.ir_version, "opset": [(o.domain, o.version) for o in om.opset_import],
                        "graph_name": om.graph.name},
        "signature_onnx": {"inputs": [vi(v) for v in om.graph.input], "outputs": [vi(v) for v in om.graph.output]},
        "onnx_node_histogram": dict(sorted(hist.items(), key=lambda kv: -kv[1])),
        "onnx_node_count": len(om.graph.node),
        "squeeze_instances": [dict(op.audit, onnx_node_name=op.name) for op in squeezes],
        "original_modified": False,
        "canonical_order": "initializer and value_info sorted by name (tflite2onnx emits them from sets)",
        "graph_name_set_to": a.graph_name,
    }
    with open(os.path.splitext(a.onnx_out)[0] + ".transform_manifest.json", "w") as fh:
        json.dump(man, fh, indent=1)
    print(json.dumps({k: man[k] for k in ("emit_mode", "output_onnx", "signature_onnx", "onnx_node_histogram", "squeeze_instances")}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
