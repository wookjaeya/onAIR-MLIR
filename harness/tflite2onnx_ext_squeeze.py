"""P1 (E30): a tflite2onnx converter EXTENSION for the TFLite SQUEEZE operator.

Why this file exists.  Stock tflite2onnx (0.4.1) has no converter for
BuiltinOperator.SQUEEZE and refuses the OPS-SAT SmartCam flight model at parse
time (`NotImplementedError: Unsupported TFLite OP: 43 SQUEEZE!`,
results/p1_smartcam_feasibility/import/step1_original_tflite2onnx.stderr).
The analysis document (docs/reviews/ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md SS5)
rules out editing the original .tflite and asks for the transform to live in the
converter, audited and reproducible, applied ONLY when every structural
condition holds.  This module is that: it registers a `Squeeze` operator class
with tflite2onnx's OpFactory at import time.  The flight artifact is never
touched; the transformation happens on the in-memory graph during conversion.

Two emission modes (both verified to lower to the same `tensor.collapse_shape`
under iree-import-onnx + iree-opt -- see the P1 evidence):
  squeeze  (default) -- emit ONNX `Squeeze` with the `axes` attribute
                        (tflite2onnx pins opset 11, where axes is an attribute).
                        Semantic twin of the TFLite op.
  reshape            -- emit ONNX `Reshape` with a static int64 shape initializer
                        (the literal suggestion of the analysis document).

Conditions enforced (analysis SS5, items 1-4; 5-7 are the audit trail this
repository keeps around the run).  Any violation raises SqueezeConditionError
-- the converter never silently drops or reinterprets the op:
  C1  every squeezed axis has size 1 in the input
  C2  element count is preserved
  C3  dtype is preserved
  C4  the output shape is static and equals the input shape with the squeezed
      axes removed (i.e. equals what the flatbuffer itself recorded)

Layout.  tflite2onnx converts NHWC activations adjacent to Conv/Pool into NCHW
and re-indexes shapes after layout propagation.  SQUEEZE's input here is the
AveragePool output, which carries an NHWC->NCHW layout, so TFLite's
squeeze_dims (indices in NHWC) must be re-indexed into NCHW positions before
the ONNX node is emitted; the output is rank-2 and layout-free, so this op
stops propagation (propagatableTensors() == []), exactly like tflite2onnx's own
Reshape.  The re-indexing is C1-checked again after the layout transform.
"""
import logging

import numpy as np
import tflite

from tflite2onnx.op.common import Operator, OpFactory

logger = logging.getLogger('tflite2onnx')

EMIT_MODE = {"mode": "squeeze"}   # set by the CLI wrapper before conversion


class SqueezeConditionError(RuntimeError):
    pass


def _numel(shape):
    n = 1
    for d in shape:
        n *= int(d)
    return n


def check_squeeze_conditions(ishape, oshape, idtype, odtype, dims):
    """Pure structural check for one SQUEEZE (analysis doc SS5 items 1-4).

    Returns (ok, audit).  Kept free of tflite2onnx objects so the negative
    tests can exercise every violation without building a flatbuffer.
    """
    ishape, oshape = [int(d) for d in ishape], [int(d) for d in oshape]
    dims = [int(d) for d in dims]
    c1 = bool(dims) and all(0 <= d < len(ishape) and ishape[d] == 1 for d in dims)
    c2 = _numel(ishape) == _numel(oshape)
    c3 = idtype == odtype
    expected = [d for k, d in enumerate(ishape) if k not in dims]
    c4 = all(d > 0 for d in oshape) and expected == oshape
    audit = {"tflite_squeeze_dims": dims, "input_shape_tflite": ishape, "output_shape": oshape,
             "input_dtype": idtype, "output_dtype": odtype,
             "C1_squeezed_axes_size_1": c1, "C2_elements_preserved": c2,
             "C3_dtype_preserved": c3, "C4_static_output_equals_expected": c4,
             "expected_output_shape": expected}
    return (c1 and c2 and c3 and c4), audit


class Squeeze(Operator):
    TypeMapping = {tflite.BuiltinOperator.SQUEEZE: 'Squeeze'}

    def __init__(self, TFactory, index):
        super().__init__(TFactory, index)
        self.tflite_axes = []          # squeeze_dims as recorded in the flatbuffer (TFLite layout)
        self.onnx_axes = []            # after layout re-indexing (what the ONNX node gets)
        self.audit = {}                # condition-by-condition record for the P1 manifest
        self.setInited()

    @property
    def type(self):
        return 'Reshape' if EMIT_MODE["mode"] == "reshape" else 'Squeeze'

    def parse(self):
        logger.debug("Parsing %s (P1 extension)...", self.type)
        op = self.tflite
        opcode = self.model.OperatorCodes(op.OpcodeIndex()).BuiltinCode()
        assert opcode in self.TypeMapping
        assert op.InputsLength() == 1, "TFLite SQUEEZE has exactly one input"
        assert op.OutputsLength() == 1

        it = self.parseInput(0)
        ot = self.parseOutput(0)

        opt = op.BuiltinOptions()
        so = tflite.SqueezeOptions()
        so.Init(opt.Bytes, opt.Pos)
        dims = [int(so.SqueezeDims(j)) for j in range(so.SqueezeDimsLength())]
        ishape, oshape = list(it.shape), list(ot.shape)
        if not dims:   # TFLite semantics: empty squeeze_dims == squeeze every size-1 axis
            dims = [k for k, d in enumerate(ishape) if d == 1]
        dims = [d + len(ishape) if d < 0 else d for d in dims]

        ok, self.audit = check_squeeze_conditions(ishape, oshape, int(it.dtype), int(ot.dtype), dims)
        if not ok:
            raise SqueezeConditionError("SQUEEZE at op %d violates structural conditions: %s"
                                        % (self.index, self.audit))
        self.tflite_axes = dims
        self.setParsed()

    def propagatableTensors(self):
        # rank-changing op: do not propagate layouts through it (same as tflite2onnx Reshape)
        return list()

    def transform(self):
        it, ot = self.inputs[0], self.outputs[0]
        axes = list(self.tflite_axes)
        if it.layout is not None:
            # it.shape has already been re-indexed by Tensor.transform(); map the axes the same way.
            perm = it.layout.perm            # new_shape[i] = old_shape[perm[i]]
            axes = sorted(perm.index(a) for a in axes)
            self.audit["layout"] = str(it.layout)
            self.audit["input_shape_onnx"] = list(it.shape)
        # C1 re-check in the emitted layout
        if not all(int(it.shape[a]) == 1 for a in axes):
            raise SqueezeConditionError("SQUEEZE axes %s are not size-1 after layout transform (shape %s)"
                                        % (axes, list(it.shape)))
        self.onnx_axes = axes
        self.audit["onnx_axes"] = axes
        self.audit["emit_mode"] = EMIT_MODE["mode"]
        if EMIT_MODE["mode"] == "reshape":
            shp = self.TFactory.createVector(np.array([int(d) for d in ot.shape], dtype='int64'))
            shp.addConsumer(self)
            self.inputs.append(shp)
            self.audit["reshape_shape_initializer"] = [int(d) for d in ot.shape]
        else:
            self.attrs['axes'] = axes        # opset 11: axes is an attribute


def register():
    """Register the extension with tflite2onnx (idempotent)."""
    if tflite.BuiltinOperator.SQUEEZE in OpFactory.registry:
        return OpFactory.registry[tflite.BuiltinOperator.SQUEEZE] is Squeeze
    OpFactory.register(Squeeze)
    return True
