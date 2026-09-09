#!/usr/bin/env python3
"""E27 baseline (b'), hardened: a fail-closed artifact-only (VMFB-only) analyser.

In tree because `docs/EVIDENCE_v0.29_E27.md` SS7 (errata, v0.31) rests on it: E27
concluded that the artifact-only level "reports what it could not read as absent",
and this analyser shows that conclusion was about THE IMPLEMENTATION THIS
REPOSITORY SHIPPED (`harness/e27_baseline_vmfb_only.py`), not about the
information level.  Same sources -- the deployed .vmfb and `iree-dump-module`,
no MLIR, no compiler dumps, no layout IR -- every silent-failure path turned into
an explicit refusal.  Re-measured in the v0.31 session over 8 archived artifacts:
7 honest ones reproduce the contract `bounded` exactly (0 over-rejection) and the
IREE 3.10 drift artifact is REFUSED with C4_DISASM instead of under-reported.

What the errata therefore claims is narrower and is about what is LEFT after a
detected failure: with one information source there is nothing to report but a
refusal; with two, the second still produces a value while the failure is
recorded (level (c) answered 786,476 + a note at the same input).

This is a baseline, not a production gate -- like the other E27 baselines it is
never wired into `make_contract.py`.

Built to test the external review's objection to E27 (section 4.1, problem 1):

    "The VMFB-only analyser could also be made to distinguish a dump failure
     from an empty allocation list, and would then refuse explicitly under the
     same condition.  The observed difference is therefore implementation
     quality, not the presence of MLIR."

This is that steelman.  Same information source as harness/e27_baseline_vmfb_only.py
(the deployed .vmfb and `iree-dump-module` only -- no MLIR, no compiler dumps,
no layout IR), but every silent-failure path the weak baseline has is turned
into an explicit refusal.  It is fail-closed: any check that cannot be
*positively* satisfied produces a REFUSE, never a value.

Checks (each can only REFUSE, never fabricate a value):
  C1  tool availability            -- iree-dump-module present and executable
                                      (OSError is a refusal, not a crash; D25)
  C2  metadata dump health         -- returncode == 0, stderr empty, stdout non-empty
  C3  container integrity          -- vmfb is a ZIP with a module.fb entry
  C4  disassembly dump health      -- returncode == 0, stderr empty, stdout non-empty.
                                      This is the functional probe that catches the
                                      bytecode-version mismatch; the metadata dump
                                      does NOT surface it (`// Bytecode : version 0`
                                      is printed identically by both versions).
  C5  entry body actually parsed   -- entry is in the export table AND its
                                      disassembly contains decoded instructions
  C6  ABI completeness             -- iree.abi.declaration present for the entry,
                                      every tensor statically shaped, every dtype
                                      known, declared arity == parsed arity
  C7  operand resolution           -- order-aware register table; any unresolved
                                      allocation_size operand refuses
  C8  empty-allocation discrimination
                                   -- zero allocas is accepted ONLY with positive
                                      evidence that HAL lowering is visible in this
                                      body (>=1 `vm.call @hal.` in the entry).
                                      "I read the body and there were none" is
                                      distinguished from "I could not read the body".
  C10 op whitelist                 -- every `vm.call @...` target in the entry body must
                                      be a recognised op.  This mirrors level (c)'s
                                      `_KNOWN_ENTRY_OPS` fail-closed whitelist
                                      (static_mem_bound.py:171) and was added AFTER the
                                      first BL1 revision was shown to under-report
                                      silently when the HAL alloca op is renamed.
  C9  rodata role attribution      -- the weak baseline assumes the executable is the
                                      LAST unlabeled segment.  That positional
                                      assumption is version-dependent and INVERTS on
                                      IREE 3.10.  BL1 instead matches every external
                                      segment to a ZIP entry by size and classifies it
                                      by ELF magic; unmatched / ambiguous / duplicate
                                      sizes refuse.  Embedded segments use the D48
                                      length rule (label is a label iff len == nbytes).

Output: JSON with "status": "value" | "refuse", refusals carrying every reason.
"""
import json
import os
import re
import subprocess
import sys
import zipfile

DT = {"f32": 4, "f16": 2, "bf16": 2, "f64": 8,
      "i64": 8, "i32": 4, "i16": 2, "i8": 1, "i1": 1,
      "si32": 4, "ui32": 4, "si8": 1, "ui8": 1}

TOOL = "iree-dump-module"


class Refusal(Exception):
    def __init__(self, code, msg):
        super().__init__(f"[{code}] {msg}")
        self.code = code
        self.msg = msg


def run_dump(vmfb, *extra):
    """C1 + C2/C4 raw: return (rc, stdout, stderr) or refuse if the tool is absent."""
    try:
        p = subprocess.run([TOOL, *extra, vmfb], capture_output=True, text=True)
    except OSError as e:                                    # C1
        raise Refusal("C1_TOOL_MISSING",
                      f"{TOOL} could not be executed: {e}")
    return p.returncode, p.stdout, p.stderr


def dump_checked(vmfb, code, *extra):
    rc, out, err = run_dump(vmfb, *extra)
    if rc != 0:
        raise Refusal(code, f"{TOOL} {' '.join(extra)} exited rc={rc}; "
                            f"stderr={err.strip()[:400]!r}")
    if err.strip():
        raise Refusal(code, f"{TOOL} {' '.join(extra)} wrote to stderr "
                            f"(rc=0): {err.strip()[:400]!r}")
    if not out.strip():
        raise Refusal(code, f"{TOOL} {' '.join(extra)} produced empty stdout with rc=0")
    return out


# ---------------------------------------------------------------- C3 container
def zip_entries(vmfb):
    try:
        z = zipfile.ZipFile(vmfb)
    except Exception as e:
        raise Refusal("C3_CONTAINER", f"vmfb is not a readable ZIP container: {e}")
    names = z.namelist()
    if "module.fb" not in names:
        raise Refusal("C3_CONTAINER", f"no module.fb entry in container; entries={names}")
    ents = []
    for n in names:
        if n == "module.fb":
            continue
        info = z.getinfo(n)
        with z.open(n) as f:
            magic = f.read(4)
        ents.append({"name": n, "size": info.file_size,
                     "is_elf": magic == b"\x7fELF"})
    return ents


# ------------------------------------------------------- C9 rodata attribution
RODATA_RE = re.compile(
    r"\.rodata\[\s*\d+\]\s+(external|embedded)\s+(\d+) bytes([^\n]*)")


def classify_rodata(meta, zents):
    """Return (constant_bytes, executable_bytes, detail).  Fail-closed."""
    segs = []
    for m in RODATA_RE.finditer(meta):
        kind, n, rest = m.group(1), int(m.group(2)), m.group(3)
        lab = re.search(r"`([^`]*)`", rest)
        # D48 rule: a backtick group is a *label* only if its length equals the
        # segment size.  A constant blob whose first byte is NUL renders as ``.
        is_label = bool(lab) and len(lab.group(1)) == n
        segs.append({"kind": kind, "bytes": n, "label": lab.group(1) if lab else None,
                     "is_label": is_label})
    if not segs:
        raise Refusal("C9_RODATA", "no .rodata segments found in metadata")

    # size -> zip entries, used to classify externals by real content
    by_size = {}
    for e in zents:
        by_size.setdefault(e["size"], []).append(e)

    consts, exe, detail = 0, 0, []
    for s in segs:
        if s["kind"] == "embedded":
            if s["is_label"]:
                detail.append({**s, "role": "metadata_string"})
            else:
                consts += s["bytes"]
                detail.append({**s, "role": "constant"})
            continue
        # external: must be resolvable to exactly one container entry
        cands = by_size.get(s["bytes"], [])
        if len(cands) == 0:
            raise Refusal("C9_RODATA",
                          f"external .rodata segment of {s['bytes']} B has no matching "
                          f"container entry; cannot tell constants from executable")
        if len(cands) > 1:
            kinds = {c["is_elf"] for c in cands}
            if len(kinds) > 1:
                raise Refusal("C9_RODATA",
                              f"external .rodata segment of {s['bytes']} B matches "
                              f"{len(cands)} container entries of differing kind; ambiguous")
            cand = cands[0]
        else:
            cand = cands[0]
        if cand["is_elf"]:
            exe += s["bytes"]
            detail.append({**s, "role": "executable", "entry": cand["name"]})
        else:
            consts += s["bytes"]
            detail.append({**s, "role": "constant", "entry": cand["name"]})
    return consts, exe, detail


# ------------------------------------------------------------ C5/C6 export+ABI
def entry_abi(meta, entry):
    """C5 (export present) + C6 (ABI complete).  Returns (in_bytes, out_bytes, decl)."""
    if "Exported Functions:" not in meta:
        raise Refusal("C5_ENTRY", "metadata has no export table")
    exported = re.findall(r"^\s*\[\s*\d+\]\s+(\w+)\(", meta, re.M)
    if entry not in exported:
        raise Refusal("C5_ENTRY",
                      f"entry {entry!r} not in export table {exported}")
    m = re.search(r"iree\.abi\.declaration:\s*\S*\s*func @" + re.escape(entry) +
                  r"\((.*?)\)\s*->\s*\((.*?)\)\s*$", meta, re.M)
    if not m:
        raise Refusal("C6_ABI",
                      f"no iree.abi.declaration for entry {entry!r}; "
                      f"input size is unknowable from the artifact alone")

    def total(side, s):
        # every declared operand/result must be a statically shaped tensor
        parts = [p.strip() for p in re.split(r",(?![^<]*>)", s) if p.strip()]
        tot = 0
        for p in parts:
            mm = re.search(r"tensor<([^>]*)>", p)
            if not mm:
                raise Refusal("C6_ABI",
                              f"{side} operand {p!r} is not a tensor type; "
                              f"artifact-only sizing is not defined for it")
            body = mm.group(1)
            toks = body.split("x")
            dt = toks[-1]
            dims = toks[:-1]
            if any(d == "?" for d in dims) or not dims:
                raise Refusal("C6_ABI",
                              f"{side} tensor <{body}> has a dynamic or absent shape")
            if dt not in DT:
                raise Refusal("C6_ABI", f"{side} tensor <{body}> has unknown dtype {dt!r}")
            n = 1
            for d in dims:
                if not d.isdigit():
                    raise Refusal("C6_ABI", f"{side} tensor <{body}> has non-literal dim {d!r}")
                n *= int(d)
            tot += n * DT[dt]
        return tot, len(parts)

    inb, nin = total("input", m.group(1))
    outb, nout = total("output", m.group(2))
    return inb, outb, nin, nout, m.group(0).strip()


# ------------------------------------------------------- C4/C7/C8 disassembly
INSN_RE = re.compile(r"^\s*\[[0-9A-F]+\]\s+")
CONST_RE = re.compile(
    r"^\s*\[[0-9A-F]+\]\s+%(i\d+)(?::\d+)?\s*=\s*vm\.const\.i(?:32|64)(\.zero)?\s*(-?\d+)?")
DEF_RE = re.compile(r"^\s*\[[0-9A-F]+\]\s+%(i\d+)(?::\d+)?\s*=\s*(\S+)")
ALLOCA_RE = re.compile(r"vm\.call @hal\.device\.queue\.alloca\(([^)]*)\)")
HALCALL_RE = re.compile(r"vm\.call @hal\.")
VMCALL_RE = re.compile(r"vm\.call @([\w.]+)")

# C10: the exact set observed across every artifact in this repository under
# IREE 3.11 (24/24 dumpable vmfbs).  Same fail-closed contract as level (c)'s
# _KNOWN_ENTRY_OPS: an unrecognised call target is an unsized event, not a
# non-event.  NOTE: this list is pinned to one compiler version by construction.
KNOWN_ENTRY_CALLS = {
    "hal.buffer.assert", "hal.buffer_view.buffer", "hal.buffer_view.dim",
    "hal.command_buffer.create", "hal.command_buffer.execution_barrier",
    "hal.command_buffer.finalize", "hal.device.allocator",
    "hal.device.queue.alloca", "hal.device.queue.dealloca",
    "hal.device.queue.execute", "hal.fence.create",
}


def disassemble_entry(vmfb, entry):
    out = dump_checked(vmfb, "C4_DISASM", "--output=disassembly", "--function=" + entry)
    lines = out.splitlines()
    # the dump is already restricted to the requested function; require decoded body
    insns = [l for l in lines if INSN_RE.match(l)]
    if not insns:
        raise Refusal("C5_ENTRY",
                      f"disassembly of {entry!r} contains no decoded instructions "
                      f"({len(lines)} lines); the body could not be read")
    return out, insns


def allocas_ordered(insns):
    """C7: order-aware constant table; registers invalidated by computed defs."""
    consts, sizes, unresolved = {}, [], []
    for line in insns:
        mc = CONST_RE.match(line)
        if mc:
            consts[mc.group(1)] = 0 if mc.group(2) else int(mc.group(3))
            continue
        md = DEF_RE.match(line)
        if md and not md.group(2).startswith("vm.const"):
            consts.pop(md.group(1), None)
        ma = ALLOCA_RE.search(line)
        if ma:
            ops = [o.strip() for o in ma.group(1).split(",")]
            if len(ops) < 8:
                unresolved.append(ma.group(0))
                continue
            key = ops[7].lstrip("%").lower()
            if key in consts:
                sizes.append(consts[key])
            else:
                unresolved.append(ops[7])
    return sizes, unresolved


def analyze(vmfb, entry="infer"):
    res = {"tool": "BL1_robust_vmfb_only", "vmfb": vmfb, "entry": entry}
    try:
        if not os.path.isfile(vmfb):
            raise Refusal("C0_INPUT", f"no such file: {vmfb}")
        meta = dump_checked(vmfb, "C2_METADATA", "--output=metadata")     # C1,C2
        zents = zip_entries(vmfb)                                          # C3
        inb, outb, nin, nout, decl = entry_abi(meta, entry)                # C5,C6
        _dis, insns = disassemble_entry(vmfb, entry)                       # C4,C5
        sizes, unres = allocas_ordered(insns)                              # C7
        if unres:
            raise Refusal("C7_UNRESOLVED",
                          f"{len(unres)} allocation_size operand(s) not statically "
                          f"resolvable: {unres}")
        hal_calls = sum(1 for l in insns if HALCALL_RE.search(l))
        called = sorted({m.group(1) for l in insns for m in [VMCALL_RE.search(l)] if m})
        unknown_calls = sorted(set(called) - KNOWN_ENTRY_CALLS)
        if unknown_calls:                                                  # C10
            raise Refusal("C10_UNKNOWN_OP",
                          f"entry body calls unrecognised target(s) {unknown_calls}; "
                          f"an unrecognised op is an unsized event, not a non-event")
        if not sizes:                                                      # C8
            if hal_calls == 0:
                raise Refusal("C8_EMPTY_ALLOCA",
                              "zero queue.alloca calls AND zero vm.call @hal.* in the "
                              "entry body: cannot distinguish an allocation-free entry "
                              "from an unreadable/unlowered body")
        consts, exe, detail = classify_rodata(meta, zents)                 # C9
        per_call = inb + sum(sizes)
        res.update({"status": "value",
                    "input_bytes": inb, "output_bytes": outb,
                    "abi_declaration": decl, "abi_arity": [nin, nout],
                    "alloca_sizes": sizes, "hal_calls_in_entry": hal_calls,
                    "insn_count": len(insns),
                    "entry_calls": called,
                    "rodata_detail": detail,
                    "bl1_constants": consts, "bl1_executable_bytes": exe,
                    "bl1_per_call": per_call,
                    "bl1_bounded": per_call + consts,
                    "refusals": []})
    except Refusal as r:
        res.update({"status": "refuse", "refusal_code": r.code, "refusal": r.msg,
                    "bl1_per_call": None, "bl1_bounded": None})
    return res


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: bl1_robust_vmfb.py <vmfb> [entry]", file=sys.stderr)
        sys.exit(2)
    print(json.dumps(analyze(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "infer"),
                     indent=1))
