#!/usr/bin/env python3
"""E38: read the conditional-admission opt-in off a built ai_learner binary.

Why this exists
---------------
E36 ran two cells at the same budget (9,382,092 B = CONTRACT_PER_CALL_BYTES of
the SmartCam contract): `cond_positive` from a build with
AI_LEARNER_ALLOW_CONDITIONAL_MAP=1 and `cond_denied_without_optin` from a build
with 0.  The control is what makes the positive cell mean anything.  But the
only thing that recorded which build served which cell was the run verdict
itself (`ADMIT_CONDITIONAL_MAP` vs `NOT_ADMITTED`) -- `build.log`,
`build_info.json`'s `app_knobs`, and the archived `ai_learner.CMakeLists.txt`
all omit the flag, and the two trees' app_knobs are byte-identical.  Reading
the verdict to learn the setting and then citing the verdict as evidence that
the setting worked is circular (the eighth external review, SS4.1).

The shipped binary is the object of the claim, so it is the right witness.
`AI_LEARNER_ALLOW_CONDITIONAL_MAP` is a compile-time constant in
`if (AI_LEARNER_ALLOW_CONDITIONAL_MAP && (long)CONTRACT_PER_CALL_BYTES <= g.budget_bytes)`
(native/cfs_app/fsw/src/ai_learner.c).  At 0 the whole conjunct folds away and
the comparison against CONTRACT_PER_CALL_BYTES is never emitted; at 1 the
compiler must materialise that contract constant and compare the budget with
it.  So: disassemble, reconstruct the integer immediates, and look for a
compare against per_call (or per_call-1, which is what GCC emits for `<=`)
whose next instruction is a conditional branch.

Three states, not two (D25/D29 lineage)
---------------------------------------
"I could not tell" is not "the flag was 0".  This tool returns
`allow_conditional_map` in {true, false, undetermined} and refuses to answer
`false` unless a POSITIVE CONTROL passes first: the same pattern-matcher must
find the unconditional admission compare against CONTRACT_BOUNDED_BYTES, which
`ai_learner.c:331` emits in every build.  If the analyzer cannot see that one
-- different toolchain, constants kept in .rodata, an optimiser that folded it
away -- then its silence about per_call carries no information and the answer
is `undetermined`.

Not a gate.  This is a witness: it reports what the binary shows.  It is used
by scripts/51_build_cfs_aarch64.sh to record the setting next to the binary it
built, and by the regression suite to re-derive the setting of the archived
E36 binaries without consulting their run verdicts.
"""
import argparse, json, os, re, shutil, subprocess, sys

# `mov xN, #0xIMM` optionally followed by `movk xN, #0xIMM, lsl #S` chains (AArch64),
# and x86-64's single-instruction `cmp $0xIMM,%reg`.
RE_AA64_MOV = re.compile(r"^\s*(?P<addr>[0-9a-f]+):\s+(?:[0-9a-f]{2} )*\s*mov\s+(?P<reg>[xw]\d+),\s*#(?P<imm>0x[0-9a-f]+|\d+)")
RE_AA64_MOVK = re.compile(r"^\s*(?P<addr>[0-9a-f]+):\s+(?:[0-9a-f]{2} )*\s*movk\s+(?P<reg>[xw]\d+),\s*#(?P<imm>0x[0-9a-f]+|\d+),\s*lsl\s*#(?P<sh>\d+)")
RE_AA64_CMP = re.compile(r"^\s*(?P<addr>[0-9a-f]+):\s+(?:[0-9a-f]{2} )*\s*(?:cmp|cmn|subs|adds)\s+(?P<ops>.+)$")
RE_AA64_CBR = re.compile(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2} )*\s*(?:b\.(?:eq|ne|le|lt|ge|gt|ls|lo|hi|hs|mi|pl)|cbz|cbnz|tbz|tbnz|cset|csetm|csel|csinc|csinv|csneg|ccmp)\b")
RE_X86_CMP_IMM = re.compile(r"^\s*(?P<addr>[0-9a-f]+):\s+(?:[0-9a-f]{2} )*\s*cmp[qlbw]?\s+\$(?P<imm>0x[0-9a-f]+|\d+),\s*(?P<reg>%\w+)")
RE_X86_CBR = re.compile(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2} )*\s*(?:j(?:e|ne|l|le|g|ge|a|ae|b|be|s|ns)|set(?:e|ne|l|le|g|ge|a|ae|b|be)|cmov\w+)\b")

OBJDUMPS = {"AArch64": ["aarch64-linux-gnu-objdump", "objdump"],
            "Advanced Micro Devices X86-64": ["objdump"],
            "X86-64": ["objdump"]}


class WitnessError(Exception):
    """Something the tool could not observe.  Never silently becomes `false`."""


def elf_machine(path):
    exe = shutil.which("readelf") or shutil.which("aarch64-linux-gnu-readelf")
    if not exe:
        raise WitnessError("no readelf on PATH")
    try:
        out = subprocess.run([exe, "-h", path], capture_output=True, text=True, check=True).stdout
    except (OSError, subprocess.CalledProcessError) as e:      # D25: observe, do not crash
        raise WitnessError("readelf -h failed: %s" % e)
    m = re.search(r"^\s*Machine:\s*(.+)$", out, re.M)
    if not m:
        raise WitnessError("readelf -h printed no Machine line")
    return m.group(1).strip()


def disassemble(path, machine):
    for cand in OBJDUMPS.get(machine, ["objdump"]):
        exe = shutil.which(cand)
        if not exe:
            continue
        try:
            r = subprocess.run([exe, "-d", "--no-show-raw-insn", path],
                               capture_output=True, text=True)
        except OSError:
            continue
        if r.returncode == 0 and r.stdout.count("\n") > 100:
            return r.stdout, os.path.basename(exe)
    raise WitnessError("no working objdump for machine %r" % machine)


def _imm(tok):
    return int(tok, 16) if tok.startswith("0x") else int(tok)


def compares_against(disasm, values, isa):
    """Every site where one of `values` is materialised, compared, and branched on.

    Returns a list of dicts (addr, value, function).  A materialised immediate
    that is NOT compared (a printf argument, a spill to the stack) is not a
    site -- that distinction is the whole point: both E36 builds materialise
    CONTRACT_PER_CALL_BYTES for the JSON records, only the opt-in build
    compares the budget with it.
    """
    lines = disasm.splitlines()
    sites, func, live = [], None, {}          # live: reg -> (value, addr)
    for i, ln in enumerate(lines):
        fm = re.match(r"^[0-9a-f]+ <([^>]+)>:", ln)
        if fm:
            func, live = fm.group(1), {}
            continue
        if isa == "aarch64":
            m = RE_AA64_MOV.match(ln)
            if m:
                live[m.group("reg").replace("w", "x")] = (_imm(m.group("imm")), m.group("addr"))
                continue
            m = RE_AA64_MOVK.match(ln)
            if m:
                reg = m.group("reg").replace("w", "x")
                base = live.get(reg, (0, m.group("addr")))
                live[reg] = (base[0] | (_imm(m.group("imm")) << int(m.group("sh"))), base[1])
                continue
            m = RE_AA64_CMP.match(ln)
            if m:
                nxt = lines[i + 1] if i + 1 < len(lines) else ""
                if RE_AA64_CBR.match(nxt):   # branch OR conditional select/set: do not
                                                 # miss an opt-in the compiler spelled as `cmp; cset`
                    for reg in re.findall(r"\b[xw]\d+\b", m.group("ops")):
                        v = live.get(reg.replace("w", "x"))
                        if v and v[0] in values:
                            sites.append({"addr": "0x" + m.group("addr"), "value": v[0],
                                          "function": func, "materialised_at": "0x" + v[1]})
                continue
            # anything else that writes a register invalidates our knowledge of it
            wm = re.match(r"^\s*[0-9a-f]+:\s+\S+\s+([xw]\d+),", ln)
            if wm:
                live.pop(wm.group(1).replace("w", "x"), None)
        else:
            m = RE_X86_CMP_IMM.match(ln)
            if m and _imm(m.group("imm")) in values:
                nxt = lines[i + 1] if i + 1 < len(lines) else ""
                if RE_X86_CBR.match(nxt):
                    sites.append({"addr": "0x" + m.group("addr"), "value": _imm(m.group("imm")),
                                  "function": func, "materialised_at": "0x" + m.group("addr")})
    return sites


def witness(so_path, per_call, bounded):
    """Decide the opt-in from the binary.  Raises WitnessError for `undetermined`."""
    machine = elf_machine(so_path)
    isa = "aarch64" if "AArch64" in machine else "x86-64"
    disasm, tool = disassemble(so_path, machine)
    if "<AI_LEARNER_Init>" not in disasm:
        raise WitnessError("AI_LEARNER_Init not in the disassembly (stripped?)")

    # POSITIVE CONTROL first: ai_learner.c:331 compares the budget against
    # CONTRACT_BOUNDED_BYTES in every build, opt-in or not.  If we cannot see
    # that, we cannot read anything from not seeing the per_call one.
    control = compares_against(disasm, {bounded, bounded - 1}, isa)
    if not control:
        raise WitnessError(
            "positive control failed: no compare against CONTRACT_BOUNDED_BYTES "
            "(%d) -- this analyzer cannot read compare-against-contract-constant "
            "patterns out of this binary, so its silence about CONTRACT_PER_CALL_BYTES "
            "means nothing" % bounded)

    sites = compares_against(disasm, {per_call, per_call - 1}, isa)
    return {
        "allow_conditional_map": bool(sites),
        "method": "disassembly: compare against CONTRACT_PER_CALL_BYTES in the admission path",
        "isa": isa, "elf_machine": machine, "objdump": tool,
        "per_call_bytes": per_call, "bounded_bytes": bounded,
        "conditional_compare_sites": sites,
        "positive_control_sites": control,
        "note": ("ai_learner.c gates the conditional tier on a compile-time constant; "
                 "at 0 the compare against CONTRACT_PER_CALL_BYTES is not emitted at all"),
    }


def contract_numbers(contract_path):
    d = json.load(open(contract_path))
    r = d.get("resources", d)
    per_call, bounded = r.get("static_per_call_bytes"), r.get("bounded_bytes")
    if not isinstance(per_call, int) or not isinstance(bounded, int):
        raise WitnessError("contract %s has no integer static_per_call_bytes/bounded_bytes"
                           % contract_path)
    return per_call, bounded


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("so", help="path to the built ai_learner.so (or the native_learner ELF)")
    ap.add_argument("--contract", help="contract JSON the app was built against")
    ap.add_argument("--per-call", type=int, help="CONTRACT_PER_CALL_BYTES (instead of --contract)")
    ap.add_argument("--bounded", type=int, help="CONTRACT_BOUNDED_BYTES (instead of --contract)")
    ap.add_argument("--expect", choices=["0", "1"],
                    help="fail with a non-zero exit unless the binary shows this value")
    ap.add_argument("--out", help="write the witness JSON here")
    a = ap.parse_args()

    try:
        if a.contract:
            per_call, bounded = contract_numbers(a.contract)
        elif a.per_call is not None and a.bounded is not None:
            per_call, bounded = a.per_call, a.bounded
        else:
            raise WitnessError("need --contract, or both --per-call and --bounded")
        rec = witness(a.so, per_call, bounded)
        rec["allow_conditional_map_state"] = "1" if rec["allow_conditional_map"] else "0"
    except WitnessError as e:
        rec = {"allow_conditional_map": None, "allow_conditional_map_state": "undetermined",
               "reason": str(e), "binary": os.path.abspath(a.so)}
    rec["binary"] = os.path.abspath(a.so)
    rec["binary_sha256"] = _sha256(a.so)
    rec["binary_bytes"] = os.path.getsize(a.so)

    text = json.dumps(rec, indent=2) + "\n"
    if a.out:
        os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
        open(a.out, "w").write(text)
    print(text, end="")

    if a.expect is not None and rec["allow_conditional_map_state"] != a.expect:
        sys.stderr.write("FAIL: binary shows allow_conditional_map=%s, expected %s\n"
                         % (rec["allow_conditional_map_state"], a.expect))
        return 2
    return 0 if rec["allow_conditional_map_state"] != "undetermined" or a.expect is None else 2


def _sha256(path):
    import hashlib
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


if __name__ == "__main__":
    sys.exit(main())
