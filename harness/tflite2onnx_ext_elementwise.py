"""E46: tflite2onnx converter EXTENSION for the shape-preserving elementwise ops
LEAKY_RELU and TANH, needed by the OPS-SAT WGAN denoiser.

Why this file exists
--------------------
Stock tflite2onnx 0.4.1 has converters for ABS and SQRT (op/unary.py) and for
nothing else in the elementwise-activation family. It refuses the flight WGAN at
parse time:

    NotImplementedError: Unsupported TFLite OP: 98 LEAKY_RELU!

-- the same failure shape E30 hit with `43 SQUEEZE!`. The model's op histogram is
CONV_2D 12 / LEAKY_RELU 11 / ADD 4 / RESIZE_BILINEAR 2 / MUL 1 / TANH 1, so the
entire gap is these two operators.

How this differs from E30's SQUEEZE extension, and why it is much smaller
------------------------------------------------------------------------
E30/E30b needed conditions C1-C5 because SQUEEZE REMOVES AXES: the dangerous case
was a TFLite-valid partial squeeze emitted on a layout-re-indexed tensor, which
silently transposed data (D56), and the first repair over-rejected honest shapes
(D57). None of that applies here. LEAKY_RELU and TANH are elementwise and
shape-preserving: they neither move nor drop an element, and they commute with any
layout permutation. That is why `propagatableTensors()` returns inputs + outputs
(layout flows straight through, exactly as stock Unary does) and `transform()` is a
no-op. Writing C1-C5-style axis checks here would be ceremony, not safety.

The real hazard here is a different one, and it IS guarded
----------------------------------------------------------
ONNX `LeakyRelu` has an `alpha` attribute that DEFAULTS TO 0.01 when absent. TFLite
carries its own alpha in LeakyReluOptions. So a converter that fails to read the
TFLite value and lets ONNX fall back to its default produces a graph that compiles,
runs, and is quietly wrong wherever alpha != 0.01 -- no error, no warning, just
different numbers on the negative half of every activation.

This repository has fixed that exact failure mode five times under different names
(D25, D28, D29, D30, D68): absence of a signal must not be read as a value. So:

  * the alpha is read from LeakyReluOptions and passed through explicitly;
  * if the options table is missing, of the wrong type, or yields a non-finite
    alpha, the converter REFUSES (ElementwiseConditionError). It does not fall back
    to 0.01, and it does not fall back to TFLite's own documented default either --
    a model whose alpha we could not read is a model we did not convert.

Structural conditions enforced (any violation refuses):
  E1  exactly one input and one output
  E2  the output shape equals the input shape (elementwise, shape-preserving)
  E3  dtype is preserved
  E4  (LEAKY_RELU only) alpha was actually READ from the flatbuffer and is finite
"""
import logging
import math

import tflite

from tflite2onnx.op.common import Operator, OpFactory

logger = logging.getLogger('tflite2onnx')


class ElementwiseConditionError(RuntimeError):
    pass


def check_elementwise_conditions(ishape, oshape, idtype, odtype, alpha, needs_alpha):
    """Pure structural check for one elementwise op. No tflite2onnx objects, so the
    negative tests can exercise every violation without building a flatbuffer."""
    ishape, oshape = [int(d) for d in ishape], [int(d) for d in oshape]
    e1 = True                      # arity is checked by the caller against the flatbuffer
    e2 = ishape == oshape
    e3 = idtype == odtype
    if needs_alpha:
        e4 = alpha is not None and isinstance(alpha, float) and math.isfinite(alpha)
    else:
        # For an op that takes no attribute, "no alpha" is correct and "an alpha" is a
        # sign the caller wired the wrong operator up.
        e4 = alpha is None
    audit = {"input_shape": ishape, "output_shape": oshape,
             "input_dtype": idtype, "output_dtype": odtype,
             "alpha": alpha, "alpha_required": needs_alpha,
             "E1_single_in_single_out": e1,
             "E2_shape_preserved": e2,
             "E3_dtype_preserved": e3,
             "E4_alpha_read_from_flatbuffer": e4}
    return (e1 and e2 and e3 and e4), audit


class Elementwise(Operator):
    """LEAKY_RELU and TANH. Shape-preserving, layout-transparent, one in one out."""

    TypeMapping = {
        tflite.BuiltinOperator.LEAKY_RELU: 'LeakyRelu',
        tflite.BuiltinOperator.TANH: 'Tanh',
    }
    # which of them carries an attribute we must not let ONNX default
    NEEDS_ALPHA = {tflite.BuiltinOperator.LEAKY_RELU}

    def __init__(self, TFactory, index):
        super().__init__(TFactory, index)
        self.audit = None
        self.setInited()

    def _opcode(self):
        return self.model.OperatorCodes(self.tflite.OpcodeIndex()).BuiltinCode()

    @property
    def type(self):
        if self.status.uninitialized:
            return 'Elementwise'
        opcode = self._opcode()
        assert opcode in self.TypeMapping
        return self.TypeMapping[opcode]

    def _read_alpha(self, op):
        """Read alpha from LeakyReluOptions, or return None. Never invents a value."""
        if op.BuiltinOptionsType() != tflite.BuiltinOptions.LeakyReluOptions:
            return None
        table = op.BuiltinOptions()
        if table is None:
            return None
        opt = tflite.LeakyReluOptions()
        opt.Init(table.Bytes, table.Pos)
        try:
            return float(opt.Alpha())
        except (TypeError, ValueError):
            return None

    def parse(self):
        logger.debug("Parsing %s...", self.type)
        op = self.tflite
        opcode = self._opcode()
        assert opcode in self.TypeMapping

        if op.InputsLength() != 1 or op.OutputsLength() != 1:
            raise ElementwiseConditionError(
                "E1: %s has %d inputs / %d outputs; this extension converts only the "
                "single-input single-output elementwise form"
                % (self.TypeMapping[opcode], op.InputsLength(), op.OutputsLength()))

        self.parseInput(0)
        self.parseOutput(0)
        it, ot = self.inputs[0], self.outputs[0]

        needs_alpha = opcode in self.NEEDS_ALPHA
        alpha = self._read_alpha(op) if needs_alpha else None
        ok, audit = check_elementwise_conditions(it.shape, ot.shape, it.dtype, ot.dtype,
                                                 alpha, needs_alpha)
        audit["tflite_opcode"] = int(opcode)
        audit["onnx_type"] = self.TypeMapping[opcode]
        self.audit = audit
        if not ok:
            raise ElementwiseConditionError(
                "%s: refusing to convert -- %s. An unread attribute is NOT a default: "
                "ONNX LeakyRelu would silently fall back to alpha=0.01 and produce a graph "
                "that compiles, runs, and is wrong on the negative half of every activation."
                % (self.TypeMapping[opcode], audit))
        if needs_alpha:
            self.attrs['alpha'] = alpha

        self.setParsed()

    def propagatableTensors(self):
        # Elementwise and shape-preserving: it commutes with any layout permutation, so
        # layout flows straight through -- same as stock Unary. This is exactly what
        # SQUEEZE could NOT do (E30b/D56), which is why that op needed C5 and this one
        # does not.
        return self.inputs + self.outputs

    def transform(self):
        pass


def register():
    """Register with tflite2onnx's OpFactory. Idempotent; returns True if ours is live."""
    live = True
    for opcode in Elementwise.TypeMapping:
        cur = OpFactory.registry.get(opcode)
        if cur is None:
            OpFactory.register(Elementwise)
        elif cur is not Elementwise:
            live = False
    return live
