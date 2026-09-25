"""Host readback of an IREE function result (E62; D103).

Why this module exists
----------------------
E57 observed on the evaluation target that the OnAIR plugin path keeps ONE output device buffer
alive per call (live bytes +O per call, peak P + (n-1)O; DeepAE exceeded its admitted budget at
call 417). E57b localised the retention to the host readback: discarding the result released
everything, while `np.array(out)` and `out.to_host()` both retained one output per call and a
forced garbage collection did not release it -- so it is not a reference cycle.

The readback of a mappable result goes `DeviceArray._map_to_host()` -> `HalBufferView.map()` ->
`MappedMemory.asarray()`, and `asarray` builds the array through
`runtime/bindings/python/numpy_interop.cc::SimpleNewFromData` (IREE revision e4a3b04, the one the
wheel under evaluation was cut from). That function fills a Py_buffer with
`PyBuffer_FillInfo(&pybuf, base_object, ...)` -- which INCREFs the MappedMemory -- and wraps it with
`PyMemoryView_FromBuffer(&pybuf)`. CPython documents the `obj` of that struct as a BORROWED
reference that `PyBuffer_Release` must not decrement (memoryobject.c sets `master.obj = NULL`), and
nothing else calls `PyBuffer_Release(&pybuf)`. The INCREF is therefore never balanced: every
`asarray` leaves the MappedMemory alive, the MappedMemory holds the buffer (it retains it and keeps
the HalBufferView alive through `keep_alive<0, 1>` on `map`), and the device bytes are never
freed. That is read from source; E62 measures it (plan SS3, cells M).

What this module does instead
-----------------------------
`buffer_protocol` maps the same buffer view and copies the bytes out through the Python buffer
protocol (`memoryview(mapped_memory)`), whose getbuffer slot INCREFs and whose release DECREFs --
a balanced pair (binding.h `buffer_protocol_slots`). The memoryview is released and every
reference dropped before returning, so nothing outlives the call.

`asarray` is the previous readback, kept verbatim as the named control of E62 and so that E57 is
reproducible from repository content (its deployments pin it).

Nothing here falls back silently: a result that cannot be read this way raises
ReadbackUnavailable, and the plugin turns that into an inactive state with the reason. Falling
back to `asarray` would re-open the retention without saying so (D29/D51 family).

`_buffer_view` is a private attribute of `iree.runtime.DeviceArray` in the pinned wheel
(3.11.0). If a later wheel renames it, this raises rather than guessing.
"""

READBACK_MODES = ("buffer_protocol", "asarray")
DEFAULT_READBACK = "buffer_protocol"


class ReadbackUnavailable(Exception):
    """The result cannot be read back through the requested path."""


def read_output(out, mode=DEFAULT_READBACK):
    """Return the result's elements as a flat, independent numpy array.

    `mode` is one of READBACK_MODES. The returned array owns its memory; no reference to the
    device result, its buffer view or its mapping survives this call in the buffer_protocol mode.
    """
    import numpy as np                                          # noqa: PLC0415

    if mode == "asarray":
        # the pre-E62 readback, byte for byte (DeviceArray.__array__ -> _map_to_host -> asarray)
        return np.array(out, copy=True).reshape(-1)
    if mode != "buffer_protocol":
        raise ValueError("unknown output readback %r (expected one of %s)" % (mode, READBACK_MODES))

    import iree.runtime as rt                                   # noqa: PLC0415

    bv = getattr(out, "_buffer_view", None)
    if bv is None:
        raise ReadbackUnavailable("the result carries no _buffer_view (DeviceArray API differs from "
                                  "the pinned wheel); refusing rather than falling back to asarray")
    raw_dtype = np.dtype(rt.HalElementType.map_to_dtype(bv.element_type))
    override = getattr(out, "_override_dtype", None)
    if override is not None and np.dtype(override) != raw_dtype:
        raise ReadbackUnavailable("the result requests dtype %s over raw %s; not handled here"
                                  % (np.dtype(override), raw_dtype))
    n = 1
    for d in bv.shape:
        n *= int(d)

    buf = bv.get_buffer()
    host_visible = int(rt.MemoryType.HOST_VISIBLE)
    scoped = int(rt.BufferUsage.MAPPING_SCOPED)
    mappable = (buf.memory_type() & host_visible) == host_visible and \
        (buf.allowed_usage() & scoped) == scoped
    del buf
    if not mappable:
        raise ReadbackUnavailable("the result buffer is not host-mappable; the device-copy path "
                                  "goes through asarray too and is not used")

    mm = bv.map()
    mv = memoryview(mm)
    try:
        if mv.nbytes < n * raw_dtype.itemsize:
            raise ReadbackUnavailable("mapping holds %d bytes, the view needs %d"
                                      % (mv.nbytes, n * raw_dtype.itemsize))
        view = np.frombuffer(mv, dtype=raw_dtype, count=n)
        y = view.copy()
        del view                     # the export on `mv` must be gone before release()
    finally:
        mv.release()
    del mv, mm, bv
    return y
