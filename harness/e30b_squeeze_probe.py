#!/usr/bin/env python3
"""E30b: run ONE synthetic TFLite case (harness/gen_tflite_squeeze_cases.py) through the
SQUEEZE converter extension and report what happened -- and, when the IREE tools are on
PATH, whether the compiled artifact reproduces TFLite's squeeze semantics bit for bit.

Outcome (JSON on stdout):
  outcome     CONVERTED | REFUSED | CRASH
  reason      the SqueezeConditionError text (REFUSED) or the traceback tail (CRASH)
  audit       the extension's per-instance audit (C1..C5, axes before/after layout)
  onnx        {path, axes_attr, input_shape, output_shape} when CONVERTED
  numeric     when --iree: {ran, equal_to_tflite_semantics, max_abs_diff, iree_output_shape}
              The IREE entry takes the NCHW re-indexed input; the reference is
              np.squeeze(x_nhwc, dims) -- TFLite's own semantics (the 1x1 VALID average
              pool is an identity).  Equality here is exactly what C5 guarantees; the
              adversarial review of E30 showed sq_H converting with max_abs_diff 5.46
              before C5 existed.
This is a probe for tests and for revert-and-confirm-fail; it is not a gate.
"""
import argparse, json, os, subprocess, sys, tempfile, traceback

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tflite")
    ap.add_argument("--mode", choices=["squeeze", "reshape"], default="squeeze")
    ap.add_argument("--iree", action="store_true", help="also compile with IREE and compare with TFLite semantics")
    ap.add_argument("--workdir", default=None)
    a = ap.parse_args()
    import numpy as np
    import onnx
    import tflite
    from tflite2onnx.model import Model
    import tflite2onnx_ext_squeeze as ext

    ext.EMIT_MODE["mode"] = a.mode
    assert ext.register()
    work = a.workdir or tempfile.mkdtemp(prefix="e30b_")
    os.makedirs(work, exist_ok=True)
    buf = open(a.tflite, "rb").read()
    m = tflite.Model.GetRootAsModel(buf, 0)
    g = m.Subgraphs(0)
    ishape_nhwc = [g.Tensors(g.Inputs(0)).Shape(j) for j in range(g.Tensors(g.Inputs(0)).ShapeLength())]
    rec = {"tflite": a.tflite, "mode": a.mode, "input_shape_tflite_nhwc": ishape_nhwc}
    model = Model(m)
    try:
        model.convert(dict())
    except ext.SqueezeConditionError as e:
        sq = [op for op in model.graphes[0].ops if isinstance(op, ext.Squeeze)]
        rec.update({"outcome": "REFUSED", "reason": str(e), "audit": sq[0].audit if sq else None})
        print(json.dumps(rec)); return 0
    except Exception:
        rec.update({"outcome": "CRASH", "reason": traceback.format_exc()[-800:]})
        print(json.dumps(rec)); return 0
    model.onnx.graph.name = "infer"
    gg = model.onnx.graph
    inits = sorted(gg.initializer, key=lambda t: t.name); vinfo = sorted(gg.value_info, key=lambda t: t.name)
    del gg.initializer[:]; gg.initializer.extend(inits); del gg.value_info[:]; gg.value_info.extend(vinfo)
    onnx_path = os.path.join(work, "case.onnx")
    model.save(onnx_path)
    sq = [op for op in model.graphes[0].ops if isinstance(op, ext.Squeeze)]
    om = onnx.load(onnx_path)
    node = [n for n in om.graph.node if n.op_type in ("Squeeze", "Reshape")][-1]
    axes_attr = None
    for at in node.attribute:
        if at.name == "axes":
            axes_attr = list(at.ints)
    def dims_of(v):
        return [d.dim_value for d in v.type.tensor_type.shape.dim]
    rec.update({"outcome": "CONVERTED", "audit": sq[0].audit if sq else None,
                "onnx": {"path": onnx_path, "node": node.op_type, "axes_attr": axes_attr,
                         "input_shape": dims_of(om.graph.input[0]), "output_shape": dims_of(om.graph.output[0])}})
    if not a.iree:
        print(json.dumps(rec)); return 0

    # --- numeric check against TFLite semantics ---
    num = {"ran": False}
    try:
        t_mlir = os.path.join(work, "case.torch.mlir"); l_mlir = os.path.join(work, "case.linalg.mlir"); vmfb = os.path.join(work, "case.vmfb")
        subprocess.run(["iree-import-onnx", onnx_path, "--opset-version", "17", "-o", t_mlir], check=True, capture_output=True, text=True)
        subprocess.run(["iree-opt", t_mlir, "--pass-pipeline=builtin.module(torch-onnx-to-torch-backend-pipeline,"
                        "torch-backend-to-linalg-on-tensors-backend-pipeline)", "-o", l_mlir], check=True, capture_output=True, text=True)
        subprocess.run(["iree-compile", l_mlir, "-o", vmfb, "--iree-hal-target-device=local",
                        "--iree-hal-local-target-device-backends=llvm-cpu",
                        "--iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu", "--iree-llvmcpu-target-cpu=generic"],
                       check=True, capture_output=True, text=True)
        import iree.runtime as rt
        cfg = rt.Config("local-sync"); ctx = rt.SystemContext(config=cfg)
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
        fn = ctx.modules.module["infer"]
        rng = np.random.default_rng(0)
        x_nhwc = rng.standard_normal(ishape_nhwc).astype(np.float32)
        x_in = np.ascontiguousarray(x_nhwc.transpose(0, 3, 1, 2)) if rec["onnx"]["input_shape"] != ishape_nhwc else x_nhwc
        y = np.array(fn(x_in).to_host(), copy=True)
        dims = sq[0].tflite_axes if sq else []
        ref = np.squeeze(x_nhwc, axis=tuple(dims)) if dims else x_nhwc
        num.update({"ran": True, "iree_input_shape": list(x_in.shape), "iree_output_shape": list(y.shape),
                    "reference_shape": list(ref.shape),
                    "equal_to_tflite_semantics": bool(y.shape == ref.shape and np.array_equal(y, ref)),
                    "max_abs_diff": float(np.abs(y - ref).max()) if y.shape == ref.shape else None})
    except subprocess.CalledProcessError as e:
        num.update({"ran": False, "tool_error": (e.stderr or "")[-600:], "cmd": e.cmd[0]})
    except Exception:
        num.update({"ran": False, "error": traceback.format_exc()[-600:]})
    rec["numeric"] = num
    print(json.dumps(rec)); return 0


if __name__ == "__main__":
    sys.exit(main())
