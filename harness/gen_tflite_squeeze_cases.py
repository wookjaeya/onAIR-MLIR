#!/usr/bin/env python3
"""E30b: build minimal float32 TFLite flatbuffers that exercise the SQUEEZE converter
extension (harness/tflite2onnx_ext_squeeze.py) on shapes the SmartCam flight model
does not contain.

Graph: input (NHWC `ishape`) -> AVERAGE_POOL_2D (1x1, VALID, stride 1 -- an identity that
gives the SQUEEZE input the NHWC->NCHW layout tag tflite2onnx assigns to pooling outputs,
exactly the situation in SmartCam) -> SQUEEZE(`dims`) -> output (`oshape`).

Why this exists (D43's rule: the model that justifies a fix must be reproducible from the
repository). The adversarial review of E30 built these with the `tflite` package's own
builder API and showed, end to end, that a TFLite-valid *partial* SQUEEZE that passes
C1-C4 (e.g. [1,1,7,64] dims [1] -> [1,7,64]) is emitted with its data silently transposed:
the kept axes {N,W,C} do not keep their TFLite order once the input has been re-indexed to
NCHW. SmartCam's instance keeps {N,C}, whose order is the same in both layouts -- which is
why the flight model was unaffected. The extension now enforces that invariant as C5.

Usage: gen_tflite_squeeze_cases.py OUT_DIR            (writes the named cases below)
       gen_tflite_squeeze_cases.py OUT.tflite --ishape 1,1,7,64 --dims 1 --oshape 1,7,64 [--no-options]
Requires: flatbuffers, tflite (schema package).
"""
import argparse, json, os, sys

import flatbuffers
import tflite
import importlib
# the generated schema package exports the CLASSES at top level; the builder functions
# (XStart/XAddY/XEnd) live in the per-table MODULES, so import those explicitly
Model, SubGraph, Tensor, Operator, OperatorCode, Buffer, Pool2DOptions, SqueezeOptions = (
    importlib.import_module("tflite." + n)
    for n in ("Model", "SubGraph", "Tensor", "Operator", "OperatorCode", "Buffer", "Pool2DOptions", "SqueezeOptions"))
from tflite.BuiltinOptions import BuiltinOptions as BO
from tflite.BuiltinOperator import BuiltinOperator as BOp
from tflite.TensorType import TensorType

# name -> (ishape NHWC, squeeze_dims, oshape as TFLite records it, with_options)
CASES = {
    # SmartCam-like: kept axes {N,C} -- order preserved under NHWC->NCHW; must convert
    "sq_HW":        ([1, 1, 1, 64], [1, 2], [1, 64], True),
    "sq_neg":       ([1, 1, 1, 64], [-3, -2], [1, 64], True),       # negative axes normalise to [1,2]
    "sq_dup":       ([1, 1, 1, 64], [1, 1, 2], [1, 64], True),      # duplicate axes are TFLite-valid
    "sq_empty":     ([1, 1, 1, 64], [], [64], True),                # empty dims == every size-1 axis
    "sq_noopt":     ([1, 1, 1, 64], [], [64], False),               # no SqueezeOptions table at all
    # partial squeezes whose kept axes CHANGE order under the layout perm -- must be refused (C5)
    "sq_H":         ([1, 1, 7, 64], [1], [1, 7, 64], True),         # kept {N,W,C} -> NCHW order {N,C,W}
    "sq_H77":       ([1, 1, 7, 7], [1], [1, 7, 7], True),
    "sq_N":         ([1, 3, 3, 4], [0], [3, 3, 4], True),           # kept {H,W,C} -> {C,H,W}
    # identity: no size-1 axis, empty dims (TFLite-valid, output == input)
    "sq_identity":  ([2, 3, 4, 5], [], [2, 3, 4, 5], True),
    # C5's two boundary cases (E30's adversarial review, medium finding on the first C5):
    # kept axes DO reorder under the perm, but every reordered one has extent 1, so no data
    # moves and the emitted op reproduces np.squeeze exactly -- must CONVERT, not be refused.
    "sq_c5_extent1_reorder": ([2, 1, 1, 1], [1], [2, 1, 1], True),
    # ... and the case that the obvious repair ("only extent>1 kept axes must keep order")
    # would wrongly accept: one extent>1 kept axis, so that rule is satisfied, yet the emitted
    # Squeeze infers ONNX shape [1,2,1] while the graph declares the TFLite output [2,1,1].
    "sq_c5_shape_mismatch":  ([1, 2, 1, 1], [0], [2, 1, 1], True),
    # structural violations (C1..C4) the checker must refuse regardless of layout
    "bad_c1":       ([1, 2, 1, 64], [1, 2], [2, 64], True),         # axis 1 has size 2
    "bad_c4":       ([1, 1, 1, 64], [1, 2], [64, 1], True),         # recorded output shape is not the expected one
}


def build(ishape, dims, oshape, with_options=True):
    b = flatbuffers.Builder(1024)
    bufs = []
    for _ in range(4):
        Buffer.BufferStart(b); bufs.append(Buffer.BufferEnd(b))
    Model.ModelStartBuffersVector(b, len(bufs))
    for x in reversed(bufs):
        b.PrependUOffsetTRelative(x)
    bufvec = b.EndVector()

    def tensor(name, shape, bufidx):
        n = b.CreateString(name)
        Tensor.TensorStartShapeVector(b, len(shape))
        for d in reversed(shape):
            b.PrependInt32(int(d))
        sv = b.EndVector()
        Tensor.TensorStart(b); Tensor.TensorAddShape(b, sv); Tensor.TensorAddType(b, TensorType.FLOAT32)
        Tensor.TensorAddBuffer(b, bufidx); Tensor.TensorAddName(b, n)
        return Tensor.TensorEnd(b)
    t0 = tensor("x", ishape, 1); t1 = tensor("pool", ishape, 2); t2 = tensor("y", oshape, 3)
    SubGraph.SubGraphStartTensorsVector(b, 3)
    for t in reversed([t0, t1, t2]):
        b.PrependUOffsetTRelative(t)
    tvec = b.EndVector()

    Pool2DOptions.Pool2DOptionsStart(b)
    Pool2DOptions.Pool2DOptionsAddPadding(b, 1)  # VALID
    Pool2DOptions.Pool2DOptionsAddStrideW(b, 1); Pool2DOptions.Pool2DOptionsAddStrideH(b, 1)
    Pool2DOptions.Pool2DOptionsAddFilterWidth(b, 1); Pool2DOptions.Pool2DOptionsAddFilterHeight(b, 1)
    Pool2DOptions.Pool2DOptionsAddFusedActivationFunction(b, 0)
    popt = Pool2DOptions.Pool2DOptionsEnd(b)

    sopt = None
    if with_options:
        SqueezeOptions.SqueezeOptionsStartSqueezeDimsVector(b, len(dims))
        for d in reversed(dims):
            b.PrependInt32(int(d))
        dv = b.EndVector()
        SqueezeOptions.SqueezeOptionsStart(b); SqueezeOptions.SqueezeOptionsAddSqueezeDims(b, dv)
        sopt = SqueezeOptions.SqueezeOptionsEnd(b)

    def op(opcode_idx, ins, outs, bo_type, bo):
        Operator.OperatorStartInputsVector(b, len(ins))
        for i in reversed(ins):
            b.PrependInt32(i)
        iv = b.EndVector()
        Operator.OperatorStartOutputsVector(b, len(outs))
        for i in reversed(outs):
            b.PrependInt32(i)
        ov = b.EndVector()
        Operator.OperatorStart(b); Operator.OperatorAddOpcodeIndex(b, opcode_idx)
        Operator.OperatorAddInputs(b, iv); Operator.OperatorAddOutputs(b, ov)
        if bo is not None:
            Operator.OperatorAddBuiltinOptionsType(b, bo_type); Operator.OperatorAddBuiltinOptions(b, bo)
        return Operator.OperatorEnd(b)
    o0 = op(0, [0], [1], BO.Pool2DOptions, popt); o1 = op(1, [1], [2], BO.SqueezeOptions, sopt)
    SubGraph.SubGraphStartOperatorsVector(b, 2)
    for o in reversed([o0, o1]):
        b.PrependUOffsetTRelative(o)
    opvec = b.EndVector()
    SubGraph.SubGraphStartInputsVector(b, 1); b.PrependInt32(0); inv = b.EndVector()
    SubGraph.SubGraphStartOutputsVector(b, 1); b.PrependInt32(2); outv = b.EndVector()
    sgname = b.CreateString("main")
    SubGraph.SubGraphStart(b); SubGraph.SubGraphAddTensors(b, tvec); SubGraph.SubGraphAddInputs(b, inv)
    SubGraph.SubGraphAddOutputs(b, outv); SubGraph.SubGraphAddOperators(b, opvec); SubGraph.SubGraphAddName(b, sgname)
    sg = SubGraph.SubGraphEnd(b)
    Model.ModelStartSubgraphsVector(b, 1); b.PrependUOffsetTRelative(sg); sgvec = b.EndVector()

    def opcode(code):
        OperatorCode.OperatorCodeStart(b); OperatorCode.OperatorCodeAddDeprecatedBuiltinCode(b, code)
        OperatorCode.OperatorCodeAddBuiltinCode(b, code); OperatorCode.OperatorCodeAddVersion(b, 1)
        return OperatorCode.OperatorCodeEnd(b)
    c0 = opcode(BOp.AVERAGE_POOL_2D); c1 = opcode(BOp.SQUEEZE)
    Model.ModelStartOperatorCodesVector(b, 2)
    for c in reversed([c0, c1]):
        b.PrependUOffsetTRelative(c)
    cvec = b.EndVector()
    desc = b.CreateString("synthetic squeeze case (harness/gen_tflite_squeeze_cases.py)")
    Model.ModelStart(b); Model.ModelAddVersion(b, 3); Model.ModelAddOperatorCodes(b, cvec)
    Model.ModelAddSubgraphs(b, sgvec); Model.ModelAddDescription(b, desc); Model.ModelAddBuffers(b, bufvec)
    m = Model.ModelEnd(b); b.Finish(m, file_identifier=b"TFL3")
    return bytes(b.Output())


def write_all(out_dir):
    os.makedirs(out_dir, exist_ok=True)
    manifest = {}
    for name, (ishape, dims, oshape, with_options) in CASES.items():
        data = build(ishape, dims, oshape, with_options)
        path = os.path.join(out_dir, name + ".tflite")
        with open(path, "wb") as fh:
            fh.write(data)
        manifest[name] = {"ishape_nhwc": ishape, "squeeze_dims": dims, "oshape_tflite": oshape,
                          "with_options": with_options, "bytes": len(data)}
    with open(os.path.join(out_dir, "cases.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    return manifest


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("out")
    ap.add_argument("--ishape"); ap.add_argument("--dims", default=""); ap.add_argument("--oshape")
    ap.add_argument("--no-options", action="store_true")
    a = ap.parse_args()
    if a.ishape:
        ishape = [int(x) for x in a.ishape.split(",")]
        dims = [int(x) for x in a.dims.split(",")] if a.dims else []
        oshape = [int(x) for x in a.oshape.split(",")]
        with open(a.out, "wb") as fh:
            fh.write(build(ishape, dims, oshape, not a.no_options))
        print("built", a.out)
        return 0
    m = write_all(a.out)
    print(json.dumps({k: v["bytes"] for k, v in m.items()}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
