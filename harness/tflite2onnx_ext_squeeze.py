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
  C5  (E30b, adversarial review of E30) when the input carries a layout tag, the
      KEPT axes keep their TFLite relative order under the layout permutation.
      Without this, a TFLite-valid partial squeeze that passes C1-C4 (e.g.
      [1,1,7,64] dims [1] -> [1,7,64]) is emitted on the NCHW-re-indexed tensor
      with its data silently transposed ([1,64,1,7] -> [1,64,7]); reproduced end
      to end with harness/gen_tflite_squeeze_cases.py (sq_H: max_abs_diff 5.46
      vs TFLite semantics, shape inference and iree-compile both happy).
      SmartCam keeps {N,C}, whose order is the same in NHWC and NCHW, which is
      why the flight model was never affected.  A model that fails C5 needs a
      Transpose, which this extension deliberately does not insert -- it
      refuses, explicitly.

Layout.  tflite2onnx converts NHWC activations adjacent to Conv/Pool into NCHW
and re-indexes shapes after layout propagation.  SQUEEZE's input here is the
AveragePool output, which carries an NHWC->NCHW layout, so TFLite's
squeeze_dims (indices in NHWC) must be re-indexed into NCHW positions before
the ONNX node is emitted; the output is treated as layout-free, so this op stops
propagation (propagatableTensors() == []), exactly like tflite2onnx's own Reshape.
The re-indexing is C1-checked again after the layout transform, and C5 is what
makes the layout-free treatment of the OUTPUT legitimate: the output is
layout-free because its axes are the kept axes in their TFLite order, not because
it happens to be rank-2.

TFLite semantics applied before the checks (E30b): a missing SqueezeOptions table
means empty squeeze_dims (TFLite's ParseSqueeze defaults num_squeeze_dims to 0);
empty squeeze_dims means every size-1 axis; negative axes count from the back;
duplicate axes are legal and collapse to one.  If after that no axis is left the op
is an identity (no size-1 axis at all): C1 holds vacuously and the op is emitted as
a Squeeze with no `axes` attribute (which squeezes nothing) / a Reshape to the
same shape -- but only when C5 allows it, i.e. only on a layout-free input.
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
    # C1: every squeezed axis exists and has size 1.  Empty dims are legal ONLY as the
    # identity case (no size-1 axis at all after TFLite's fill-in); an empty list on an
    # input that still has size-1 axes is a contradiction and is refused.
    identity = (not dims) and all(d != 1 for d in ishape)
    c1 = identity or (bool(dims) and all(0 <= d < len(ishape) and ishape[d] == 1 for d in dims))
    c2 = _numel(ishape) == _numel(oshape)
    c3 = idtype == odtype
    expected = [d for k, d in enumerate(ishape) if k not in dims]
    c4 = all(d > 0 for d in oshape) and expected == oshape
    audit = {"tflite_squeeze_dims": dims, "input_shape_tflite": ishape, "output_shape": oshape,
             "input_dtype": idtype, "output_dtype": odtype,
             "C1_squeezed_axes_size_1": c1, "C2_elements_preserved": c2,
             "C3_dtype_preserved": c3, "C4_static_output_equals_expected": c4,
             "expected_output_shape": expected, "identity": identity}
    return (c1 and c2 and c3 and c4), audit


def normalize_squeeze_dims(dims, ishape):
    """TFLite semantics, applied before any check: negatives count from the back,
    duplicates collapse, an empty list means every size-1 axis.  Pure."""
    rank = len(ishape)
    dims = [int(d) for d in dims]
    dims = sorted(set(d + rank if d < 0 else d for d in dims))
    if not dims:
        dims = [k for k, d in enumerate(ishape) if int(d) == 1]
    return dims


def check_kept_axis_order(rank, dims, perm):
    """C5, pure.  `perm` is tflite2onnx's Layout.perm (new_shape[i] = old_shape[perm[i]]),
    or None for a layout-free tensor.  Returns (ok, mapped_positions_of_kept_axes)."""
    kept = [k for k in range(rank) if k not in dims]
    if perm is None:
        return True, kept
    perm = [int(p) for p in perm]
    mapped = [perm.index(k) for k in kept]
    return mapped == sorted(mapped), mapped


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
        if opt is None:            # no SqueezeOptions table: TFLite treats it as empty squeeze_dims
            raw_dims = []
        else:
            so = tflite.SqueezeOptions()
            so.Init(opt.Bytes, opt.Pos)
            raw_dims = [int(so.SqueezeDims(j)) for j in range(so.SqueezeDimsLength())]
        ishape, oshape = list(it.shape), list(ot.shape)
        dims = normalize_squeeze_dims(raw_dims, ishape)

        ok, self.audit = check_squeeze_conditions(ishape, oshape, int(it.dtype), int(ot.dtype), dims)
        if not ok:
            raise SqueezeConditionError("SQUEEZE at op %d violates structural conditions: %s"
                                        % (self.index, self.audit))
        self.audit["raw_squeeze_dims"] = raw_dims
        self.tflite_axes = dims
        self.setParsed()

    def propagatableTensors(self):
        # rank-changing op: do not propagate layouts through it (same as tflite2onnx Reshape)
        return list()

    def transform(self):
        it, ot = self.inputs[0], self.outputs[0]
        axes = list(self.tflite_axes)
        rank = len(self.audit["input_shape_tflite"])
        perm = list(it.layout.perm) if it.layout is not None else None
        # C5: the kept axes must keep their TFLite order under the layout permutation,
        # otherwise the emitted op would reorder data (see module docstring).
        ok5, mapped = check_kept_axis_order(rank, axes, perm)
        self.audit["C5_kept_axis_order_preserved"] = ok5
        self.audit["kept_axes_positions_after_layout"] = mapped
        if perm is not None:
            # it.shape has already been re-indexed by Tensor.transform(); map the axes the same way.
            axes = sorted(set(perm.index(a) for a in axes))    # new_shape[i] = old_shape[perm[i]]
            self.audit["layout"] = str(it.layout)
            self.audit["input_shape_onnx"] = list(it.shape)
        if not ok5:
            raise SqueezeConditionError("SQUEEZE at op %d would reorder data: kept axes %s map to positions %s "
                                        "under layout %s (C5); a Transpose would be needed, which this extension "
                                        "does not insert" % (self.index, [k for k in range(rank) if k not in self.tflite_axes],
                                                              mapped, it.layout))
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
        elif axes:
            self.attrs['axes'] = axes        # opset 11: axes is an attribute
        # identity (no size-1 axis): a Squeeze with NO axes attribute squeezes nothing


def register():
    """Register the extension with tflite2onnx (idempotent)."""
    if tflite.BuiltinOperator.SQUEEZE in OpFactory.registry:
        return OpFactory.registry[tflite.BuiltinOperator.SQUEEZE] is Squeeze
    OpFactory.register(Squeeze)
    return True
