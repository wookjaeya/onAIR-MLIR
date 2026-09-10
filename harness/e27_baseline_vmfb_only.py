#!/usr/bin/env python3
"""Baseline (b2) for E27: artifact-only analysis -- a COMPARISON TARGET, not a contract tool.

This is deliberately NOT part of the contract pipeline. It exists so E27 can answer
"what does the MLIR stage actually add?" with a measurement instead of an assertion,
and it is kept exactly as weak as an artifact-only analyser really is -- do not add
fail-closed guards to it, or it stops being the baseline.

Measured (E27 preliminary, docs/plans/E27_mlir_contribution.md):
  * On IREE 3.11 artifacts it reproduces the contract's per_call / constants / bounded
    EXACTLY for conv2d, mlp16k and multibranch. So "these numbers need MLIR" is FALSE
    for this model set.
  * On an IREE 3.10 artifact (results/e27_baselines/iree310_mlp16k/) it returns
    b2_bounded = 5,172 instead of 786,476 -- a 152x UNDER-estimate -- and reports
    alloca_unresolved = [], i.e. no problem at all. The disassembly it needs is
    unreadable across that bytecode version boundary, and it cannot tell "no
    allocations" from "I could not read the allocations".
    The repository's MLIR path on the same artifact produced 786,476 and recorded the
    tool failure in a note (constants_confirmation_state = confirmed).


Recovers the contract quantities from the DEPLOYED vmfb alone -- no MLIR, no
compiler dumps, no layout IR.  Uses only `iree-dump-module`:
  * per-call transient/output slabs: allocation_size operand (positional index
    7) of every `hal.device.queue.alloca` in the entry function's VM bytecode,
    resolved through the function's `vm.const.i64` table
  * module-resident constants: the unlabeled `.rodata` segment(s) in metadata
  * input bytes: the `iree.abi.declaration` attribute in the export table
"""
import re, subprocess, sys, json

DT = {"f32":4,"f16":2,"bf16":2,"f64":8,"i64":8,"i32":4,"i16":2,"i8":1,"i1":1}

def dump(vmfb, *extra):
    return subprocess.run(["iree-dump-module", *extra, vmfb],
                          capture_output=True, text=True).stdout

def abi_io(meta):
    m = re.search(r"iree\.abi\.declaration:.*?func @\w+\((.*?)\)\s*->\s*\((.*?)\)", meta)
    if not m: return None, None
    def total(s):
        t = 0
        for mm in re.finditer(r"tensor<([0-9x?]+)x(\w+)>", s):
            dims, dt = mm.group(1).split("x"), mm.group(2)
            if any(d == "?" for d in dims): return None
            n = 1
            for d in dims: n *= int(d)
            t += n * DT[dt]
        return t
    return total(m.group(1)), total(m.group(2))

def rodata(meta):
    """(unlabeled segments = constants+executables, labeled = metadata strings)"""
    seg = []
    for m in re.finditer(r"\.rodata\[\s*\d+\]\s+(external|embedded)\s+(\d+) bytes([^\n]*)", meta):
        kind, n, rest = m.group(1), int(m.group(2)), m.group(3)
        seg.append((kind, n, "`" in rest))
    return seg

def allocas(vmfb, entry="infer"):
    d = dump(vmfb, "--output=disassembly", "--function=" + entry)
    consts = {}
    for m in re.finditer(r"%(i\d+)(?::\d+)?\s*=\s*vm\.const\.i(?:32|64)\s+(-?\d+)", d):
        consts[m.group(1)] = int(m.group(2))
    for m in re.finditer(r"%(i\d+)(?::\d+)?\s*=\s*vm\.const\.i(?:32|64)\.zero", d):
        consts[m.group(1)] = 0
    sizes, unresolved = [], []
    for m in re.finditer(r"vm\.call @hal\.device\.queue\.alloca\(([^)]*)\)", d):
        ops = [o.strip() for o in m.group(1).split(",")]
        if len(ops) < 8: unresolved.append(m.group(0)); continue
        key = ops[7].lstrip("%").lower()          # allocation_size operand
        if key in consts: sizes.append(consts[key])
        else: unresolved.append(ops[7])
    return sizes, unresolved, d

def analyze(vmfb, entry="infer"):
    meta = dump(vmfb, "--output=metadata")
    inb, outb = abi_io(meta)
    seg = rodata(meta)
    unlabeled = [n for k, n, lab in seg if not lab]
    # the executable ELF is the LAST unlabeled segment; anything before it is the
    # module constant pool (verified against iree-dump-module ordering)
    consts = sum(unlabeled[:-1]) if len(unlabeled) >= 2 else 0
    exe = unlabeled[-1] if unlabeled else 0
    sizes, unres, _ = allocas(vmfb, entry)
    per_call = (inb or 0) + sum(sizes)
    return {"vmfb": vmfb, "input_bytes": inb, "output_bytes": outb,
            "alloca_sizes": sizes, "alloca_unresolved": unres,
            "rodata_segments": [(k, n, lab) for k, n, lab in seg],
            "b2_constants": consts, "b2_executable_bytes": exe,
            "b2_per_call": per_call if not unres and inb is not None else None,
            "b2_bounded": (per_call + consts) if (not unres and inb is not None) else None}

if __name__ == "__main__":
    print(json.dumps(analyze(sys.argv[1], sys.argv[2] if len(sys.argv)>2 else "infer"), indent=1))


def allocas_ordered(vmfb, entry="infer"):
    """Order-aware register resolution (fail-closed).

    The naive `allocas()` above builds one constant table for the whole
    function.  VM registers are REASSIGNED: on the repo's dynamic model
    `%i18:19 = vm.mul.i64 %i34:35, %i18:19` overwrites the constant 256 with
    batch*256 *before* the alloca uses it, so the naive table yields [8, 256]
    -- per-batch-element sizes reported as if they bounded the allocation.
    This version walks in program order and invalidates a register whenever a
    non-constant op defines it.
    """
    d = dump(vmfb, "--output=disassembly", "--function=" + entry)
    consts, sizes, unresolved = {}, [], []
    for line in d.splitlines():
        mc = re.match(r"\[[0-9A-F]+\]\s+%(i\d+)(?::\d+)?\s*=\s*vm\.const\.i(?:32|64)(\.zero)?\s*(-?\d+)?", line)
        if mc:
            consts[mc.group(1)] = 0 if mc.group(2) else int(mc.group(3))
            continue
        md = re.match(r"\[[0-9A-F]+\]\s+%(i\d+)(?::\d+)?\s*=\s*(\S+)", line)
        if md and not md.group(2).startswith("vm.const"):
            consts.pop(md.group(1), None)          # invalidated by a computed def
        ma = re.search(r"vm\.call @hal\.device\.queue\.alloca\(([^)]*)\)", line)
        if ma:
            ops = [o.strip() for o in ma.group(1).split(",")]
            key = ops[7].lstrip("%").lower() if len(ops) >= 8 else None
            if key in consts: sizes.append(consts[key])
            else: unresolved.append(ops[7] if key else ma.group(0))
    return sizes, unresolved
