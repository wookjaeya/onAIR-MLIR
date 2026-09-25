#!/usr/bin/env python3
"""E62: does the binding's asarray leak the MappedMemory, and does the buffer-protocol readback not?

Plan: docs/plans/E62_onair_output_release.md (committed before any cell). One mode per process
(HAL statistics are process-global -- E41). A probe, not a gate. Runs on the evaluation target.

    python3 e62_readback_probe.py <vmfb> <contract.json> <fixture .npy> <mode> [calls]

modes
  refcount_asarray     one call; map the result's buffer view and build the array exactly as
                       DeviceArray._map_to_host does (MappedMemory.asarray); record the
                       MappedMemory's refcount before, while the array lives, after the array is
                       gone; then drop every reference and read the allocator
  refcount_bufproto    the same, reading through memoryview(mapped) instead of asarray
  loop_asarray         `calls` calls through the PRODUCTION readback (readback.read_output),
  loop_buffer_protocol one mode each; per call: allocator live/peak and the sha256 of the output
"""
import gc
import hashlib
import json
import os
import sys

import numpy as np
import iree.runtime as rt

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                                "plugins", "compiled_learner"))
import readback                                                  # noqa: E402


def stats(cfg):
    alloc = cfg.device.allocator
    if not getattr(alloc, "has_statistics", False):
        return {"available": False, "unavailable_reason": "has_statistics=False"}
    st = dict(alloc.statistics)
    a, f = st.get("device_bytes_allocated"), st.get("device_bytes_freed")
    return {"available": True, "peak": st.get("device_bytes_peak"), "live": a - f}


def main():
    vmfb, contract, npy, mode = sys.argv[1:5]
    calls = int(sys.argv[5]) if len(sys.argv) > 5 else 20
    con = json.load(open(contract))
    entry = con["interface"].get("entry") or "infer"
    x = np.ascontiguousarray(np.load(npy).astype(np.float32))
    cfg = rt.Config("local-sync")
    ctx = rt.SystemContext(config=cfg)
    ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
    fn = ctx.modules.module[entry]
    rec = {"mode": mode, "vmfb": vmfb, "python": sys.version.split()[0],
           "numpy": np.__version__, "machine": os.uname().machine,
           "after_append": stats(cfg)}

    if mode in ("refcount_asarray", "refcount_bufproto"):
        out = fn(x)
        bv = out._buffer_view
        dtype = np.dtype(rt.HalElementType.map_to_dtype(bv.element_type))
        shape = list(bv.shape)
        mm = bv.map()
        r0 = sys.getrefcount(mm)
        if mode == "refcount_asarray":
            a = mm.asarray(shape, dtype)
            r1 = sys.getrefcount(mm)
            y = a.copy()
            del a
        else:
            mv = memoryview(mm)
            r1 = sys.getrefcount(mm)
            view = np.frombuffer(mv, dtype=dtype, count=int(np.prod(shape)))
            y = view.copy()
            del view
            mv.release()
            del mv
        r2 = sys.getrefcount(mm)
        rec["refcount"] = {"before": r0, "while_array_or_view_alive": r1, "after_array_or_view_gone": r2,
                           "delta_after": r2 - r0}
        rec["live_holding_mapping"] = stats(cfg)
        del mm, bv, out
        gc.collect()
        rec["after_all_references_dropped"] = stats(cfg)
        rec["output_sha256"] = hashlib.sha256(np.ascontiguousarray(y).reshape(-1).tobytes()).hexdigest()
    elif mode in ("loop_asarray", "loop_buffer_protocol"):
        rb = mode[len("loop_"):]
        rows = []
        for i in range(calls):
            out = fn(x)
            y = readback.read_output(out, rb)
            del out
            rows.append({"call": i + 1, **stats(cfg),
                         "output_sha256": hashlib.sha256(np.ascontiguousarray(y).tobytes()).hexdigest()})
        rec["calls"] = calls
        rec["rows"] = rows
    else:
        raise SystemExit("unknown mode %r" % mode)
    print(json.dumps(rec))


if __name__ == "__main__":
    main()
