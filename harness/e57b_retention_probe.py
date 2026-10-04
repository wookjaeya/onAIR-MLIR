#!/usr/bin/env python3
"""E57b: which step of the Python path keeps the output device buffer alive between calls.

Plan: docs/plans/E57b_output_retention_probe.md (committed before the cells).  One mode per
process (HAL statistics are process-global -- E41).  Nothing here is a gate; it is a probe.

    python3 e57b_retention_probe.py <vmfb> <contract.json> <fixture .npy> <mode R0|R1|R2|R3> [calls]
"""
import gc
import json
import sys

import numpy as np
import iree.runtime as rt


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
    rows = [{"point": "after_append", **stats(cfg)}]
    for i in range(calls):
        out = fn(x)
        if mode == "R0":
            del out
        elif mode == "R1":
            y = np.array(out, copy=True)
            del out
        elif mode == "R2":
            y = out.to_host().copy()
            del out
        elif mode == "R3":
            y = np.array(out, copy=True)
            del out
            gc.collect()
        else:
            raise SystemExit("unknown mode %r" % mode)
        rows.append({"point": "after_call_%d" % (i + 1), **stats(cfg)})
    print(json.dumps({"mode": mode, "calls": calls, "vmfb": vmfb, "rows": rows}))


if __name__ == "__main__":
    main()
