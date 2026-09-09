#!/usr/bin/env python3
"""E14 / proposal §9.2 (docs/reviews/QEMU_AARCH64_EXPERIMENT_ENVIRONMENT.md):
static analyzer for the embedded-ELF executables IREE produces for the
llvm-cpu backend (x86-64 and AArch64).  Replaces the hand-counted numbers of
EVIDENCE_v0.7/v0.8 (instruction counts, FMA counts, stack-frame bytes, call
counts) with a machine-produced JSON that can be cited and re-run.

Why
---
The HAL memory contract (bounded_bytes) covers what the compiled program
allocates through the HAL allocator.  It does NOT cover memory the generated
machine code takes on the OS task stack (frame records, callee-saved register
spills, locals) or memory reached through calls into other code.  §9.2 asks
for exactly those facts to be read off the final executable and classified
into one of four buckets: (1) already in the HAL contract, (2) task-stack
budget, (3) IREE runtime residual, (4) unaccounted -> contract boundary must
be revised.  E14 Stage 0 found a 16-byte AAPCS64 frame record in every
AArch64 dispatch function; this tool makes that finding reproducible for any
model/target.

Definitions (cited by EVIDENCE_v0.9; keep them stable)
------------------------------------------------------
frame_bytes           = callee_save_bytes + local_alloc_bytes, per function.
  AArch64: callee_save_bytes = sum of N over pre-index stores
           `stp/str <regs>, [sp, #-N]!`; local_alloc_bytes = sum of immediates
           of `sub sp, sp, #M[, lsl #S]`.
  x86-64 : callee_save_bytes = 8 * (number of `push` in the prologue);
           local_alloc_bytes = sum of immediates of `sub $M,%rsp`.
  NOTE: EVIDENCE_v0.7 §E13 table row "ELF 스택 프레임(`sub $N,%rsp`)" counted
  ONLY local_alloc_bytes on x86-64 (=0), whereas EVIDENCE_v0.8 counted the
  AArch64 `stp x29,x30,[sp,#-16]!` (callee_save_bytes=16).  This tool applies
  the SAME definition to both ISAs, so x86-64 functions with `push %rbp` get
  frame_bytes=8 here, not 0.  Both components are reported separately.
return_address_bytes  = 8 on x86-64 (pushed by the caller's `call`, never
  visible inside the callee), 0 on AArch64 (LR is a register; its save is
  already inside callee_save_bytes).
invocation_stack_bytes = frame_bytes + return_address_bytes: the number to put
  into the task-stack budget per dispatch invocation (depth 1 when there are
  no call instructions).
has_frame_record      = x29/x30 pair saved to the stack and x29 set from sp
  (AArch64) or `push %rbp` + `mov %rsp,%rbp` (x86-64).
sp_relative_mem_ops   = loads/stores whose address is sp/x29-based (AArch64)
  or (%rsp)/(%rbp)-based (x86-64), EXCLUDING the frame-record save/restore
  and excluding push/pop/call/ret themselves.  Non-zero means spills or
  locals -> stack usage beyond the frame record.
insns                 = objdump instruction lines of the function without the
  trailing `int3` padding; padding_insns_after = that padding.
total_insns           = ALL objdump instruction lines of the executable
  (including padding) -- this is the rule behind the archived 122/111/88.
zmm_refs/ymm_refs/xmm_refs = number of register-name OCCURRENCES in operands
  (the archived zmm_refs=49 is occurrences, not instruction lines).

Function boundaries
-------------------
IREE's embedded ELF exports only `iree_hal_executable_library_query`; the
dispatch functions are stripped locals, so objdump shows them as one
`<iree_hal_executable_library_query-0xNNN>` block.  Their entry addresses
and names are recovered from the executable itself: the export table in
.data.rel.ro is a run of R_*_RELATIVE relocations whose addends are .text
addresses (export ptrs), followed by a run whose addends are C strings
(export names).  Fallback when no export table is found: split blocks after
`ret` + padding, name them from the .ll `define` order if --ll is given.

Usage
-----
  python3 harness/elf_stack_frame.py --elf FILE [--objdump TOOL] [--ll F.codegen.ll] [--out JSON]
  python3 harness/elf_stack_frame.py --elf FILE --objdump-txt pregenerated.objdump.txt
  python3 harness/elf_stack_frame.py --dump-dir DIR [--vmfb m.vmfb] [--ll ...]   # dumped ELF (preferred)
  python3 harness/elf_stack_frame.py --vmfb m.vmfb [--extract-to PATH]           # carve ELF out of the vmfb
Library:
  extract_embedded_elf(vmfb_or_dump_dir, out_path=None, index=0) -> path
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile

# ----------------------------------------------------------------------------
# ELF64 parsing (pure Python; no dependency on readelf output formatting)
# ----------------------------------------------------------------------------
ELF_MAGIC = b"\x7fELF"
ET_REL, ET_EXEC, ET_DYN = 1, 2, 3
ARCH_BY_MACHINE = {62: "x86_64", 183: "aarch64"}
SHT_SYMTAB, SHT_STRTAB, SHT_RELA, SHT_NOBITS, SHT_DYNSYM = 2, 3, 4, 8, 11
SHF_ALLOC, SHF_EXECINSTR = 0x2, 0x4
STT_FUNC = 2
# (arch, r_type) pairs that mean "base + addend" with no symbol.
R_RELATIVE = {("x86_64", 8), ("aarch64", 1027)}
RELOC_TYPE_NAMES = {
    "x86_64": {8: "R_X86_64_RELATIVE", 6: "R_X86_64_GLOB_DAT", 7: "R_X86_64_JUMP_SLOT", 1: "R_X86_64_64"},
    "aarch64": {1027: "R_AARCH64_RELATIVE", 1025: "R_AARCH64_GLOB_DAT", 1026: "R_AARCH64_JUMP_SLOT", 257: "R_AARCH64_ABS64"},
}


class Elf64:
    """Minimal ELF64 little-endian reader.  `data` may be a buffer that starts
    with the ELF magic and extends beyond the ELF (e.g. a vmfb tail); use
    .file_extent to learn where this ELF ends."""

    def __init__(self, data):
        if len(data) < 16:
            raise ValueError("too short to be an ELF header (%d bytes)" % len(data))
        if data[:4] != ELF_MAGIC:
            raise ValueError("not an ELF file (bad magic)")
        if data[4] != 2:
            raise ValueError("only ELF64 is supported (EI_CLASS=%d)" % data[4])
        if data[5] != 1:
            raise ValueError("only little-endian ELF is supported (EI_DATA=%d)" % data[5])
        self.data = data
        (self.e_type, self.e_machine, _ver, self.e_entry, self.e_phoff, self.e_shoff,
         _flags, self.e_ehsize, self.e_phentsize, self.e_phnum, self.e_shentsize,
         self.e_shnum, self.e_shstrndx) = struct.unpack_from("<HHIQQQIHHHHHH", data, 16)
        self.arch = ARCH_BY_MACHINE.get(self.e_machine, "unknown(e_machine=%d)" % self.e_machine)
        self.sections = []
        for i in range(self.e_shnum):
            off = self.e_shoff + i * self.e_shentsize
            if off + 64 > len(data):
                raise ValueError("section header %d beyond buffer" % i)
            (name_off, typ, flags, addr, offset, size, link, info, align, entsize) = \
                struct.unpack_from("<IIQQQQIIQQ", data, off)
            self.sections.append(dict(index=i, name_off=name_off, type=typ, flags=flags, addr=addr,
                                      offset=offset, size=size, link=link, info=info,
                                      align=align, entsize=entsize, name=""))
        if self.e_shstrndx < len(self.sections):
            shstr = self.sections[self.e_shstrndx]
            for s in self.sections:
                s["name"] = self.cstr_at_offset(shstr["offset"] + s["name_off"])
        self.phdrs = []
        for i in range(self.e_phnum):
            off = self.e_phoff + i * self.e_phentsize
            (p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align) = \
                struct.unpack_from("<IIQQQQQQ", data, off)
            self.phdrs.append(dict(type=p_type, flags=p_flags, offset=p_offset, vaddr=p_vaddr,
                                   filesz=p_filesz, memsz=p_memsz))

    # -- extents --------------------------------------------------------------
    @property
    def file_extent(self):
        """Number of bytes this ELF occupies in the buffer: the section-header
        table end (lld puts it last) or, if larger, the end of any section /
        segment file data."""
        ext = self.e_shoff + self.e_shnum * self.e_shentsize
        for s in self.sections:
            if s["type"] != SHT_NOBITS:
                ext = max(ext, s["offset"] + s["size"])
        for p in self.phdrs:
            ext = max(ext, p["offset"] + p["filesz"])
        return ext

    # -- helpers --------------------------------------------------------------
    def cstr_at_offset(self, off, limit=4096):
        end = self.data.find(b"\x00", off, off + limit)
        if end < 0:
            return ""
        try:
            return self.data[off:end].decode("utf-8")
        except UnicodeDecodeError:
            return ""

    def section(self, name):
        for s in self.sections:
            if s["name"] == name:
                return s
        return None

    def section_for_vaddr(self, addr):
        for s in self.sections:
            if s["flags"] & SHF_ALLOC and s["size"] and s["addr"] <= addr < s["addr"] + s["size"]:
                return s
        return None

    def cstr_at_vaddr(self, addr):
        s = self.section_for_vaddr(addr)
        if s is None or s["type"] == SHT_NOBITS or s["flags"] & SHF_EXECINSTR:
            return None
        return self.cstr_at_offset(s["offset"] + (addr - s["addr"]))

    def exec_ranges(self):
        return [(s["addr"], s["addr"] + s["size"], s["name"]) for s in self.sections
                if s["flags"] & SHF_EXECINSTR and s["size"]]

    def in_exec(self, addr):
        return any(lo <= addr < hi for lo, hi, _n in self.exec_ranges())

    def symbols(self):
        out = []
        for s in self.sections:
            if s["type"] not in (SHT_SYMTAB, SHT_DYNSYM) or s["entsize"] == 0:
                continue
            strtab = self.sections[s["link"]] if s["link"] < len(self.sections) else None
            for i in range(s["size"] // s["entsize"]):
                off = s["offset"] + i * s["entsize"]
                (st_name, st_info, st_other, st_shndx, st_value, st_size) = \
                    struct.unpack_from("<IBBHQQ", self.data, off)
                name = self.cstr_at_offset(strtab["offset"] + st_name) if strtab else ""
                out.append(dict(table=s["name"], name=name, type=st_info & 0xF, bind=st_info >> 4,
                                shndx=st_shndx, value=st_value, size=st_size))
        return out

    def relocations(self):
        out = []
        for s in self.sections:
            if s["type"] != SHT_RELA or s["entsize"] == 0:
                continue
            for i in range(s["size"] // s["entsize"]):
                off = s["offset"] + i * s["entsize"]
                r_offset, r_info, r_addend = struct.unpack_from("<QQq", self.data, off)
                out.append(dict(section=s["name"], offset=r_offset, type=r_info & 0xFFFFFFFF,
                                sym=r_info >> 32, addend=r_addend))
        return out


# ----------------------------------------------------------------------------
# Locating / extracting the embedded ELF (dump dir or vmfb)
# ----------------------------------------------------------------------------
def zip_local_entry_ending_at(blob, data_pos, window=1024):
    """IREE writes the vmfb as a polyglot ZIP: each executable is a *stored*
    ZIP entry (`PK\\x03\\x04` local header, name = <module>_linked_embedded_elf_<arch>.so,
    sizes in a Zip64 extra field).  If a local header's data starts exactly at
    `data_pos`, return dict(name, uncompressed_size, compressed_size, method)."""
    start = max(0, data_pos - window)
    p = blob.rfind(b"PK\x03\x04", start, data_pos)
    while p >= 0:
        try:
            (sig, ver, flags, method, mtime, mdate, crc, csize, usize, nlen, xlen) = \
                struct.unpack_from("<IHHHHHIIIHH", blob, p)
        except struct.error:
            return None
        if p + 30 + nlen + xlen == data_pos:
            name = blob[p + 30:p + 30 + nlen].decode("utf-8", "replace")
            extra = blob[p + 30 + nlen:p + 30 + nlen + xlen]
            q = 0
            while q + 4 <= len(extra):
                xid, xsz = struct.unpack_from("<HH", extra, q)
                if xid == 0x0001 and xsz >= 16:  # Zip64: uncompressed(u64), compressed(u64)
                    usize, csize = struct.unpack_from("<QQ", extra, q + 4)
                q += 4 + xsz
            return dict(name=name, uncompressed_size=usize, compressed_size=csize, method=method)
        p = blob.rfind(b"PK\x03\x04", start, p)
    return None


def locate_embedded_elfs(blob):
    """Find every ELF image inside `blob` (a vmfb).  The ELF bytes are stored
    contiguously; the size is derived from the ELF header (section-header
    table extent) and cross-checked against the enclosing ZIP entry's
    uncompressed size when the vmfb carries its polyglot ZIP wrapper."""
    found = []
    pos = blob.find(ELF_MAGIC)
    while pos >= 0:
        try:
            elf = Elf64(blob[pos:])
            size = elf.file_extent
            z = zip_local_entry_ending_at(blob, pos)
            found.append(dict(offset=pos, size=size, arch=elf.arch, e_type=elf.e_type,
                              zip_entry=z,
                              size_confirmed_by_zip_entry=(z is not None and z["uncompressed_size"] == size
                                                           and z["method"] == 0),
                              sha256=hashlib.sha256(blob[pos:pos + size]).hexdigest()))
            pos = blob.find(ELF_MAGIC, pos + size)
        except (ValueError, struct.error):
            pos = blob.find(ELF_MAGIC, pos + 1)
    return found


def is_elf_file(path):
    try:
        with open(path, "rb") as f:
            return f.read(4) == ELF_MAGIC
    except OSError:
        return False


def find_dumped_elfs(dump_dir):
    """ELF files in an --iree-hal-dump-executable-files-to directory.  The
    final linked embedded ELF is the ET_DYN one (module_<name>_linked_embedded_elf_<arch>.so);
    ET_REL objects (if any) are intermediate."""
    out = []
    for fn in sorted(os.listdir(dump_dir)):
        p = os.path.join(dump_dir, fn)
        if os.path.isfile(p) and is_elf_file(p):
            with open(p, "rb") as f:
                data = f.read()
            try:
                e = Elf64(data)
            except ValueError:
                continue
            out.append(dict(path=p, bytes=len(data), arch=e.arch, e_type=e.e_type,
                            sha256=hashlib.sha256(data).hexdigest()))
    return out


def extract_embedded_elf(vmfb_or_dump_dir, out_path=None, index=0):
    """Return the path of the final embedded ELF executable.

    * dump directory (preferred, one-invocation rule): returns the ET_DYN ELF
      file dumped by iree-compile (no copy is made).
    * vmfb (fallback): carves the `index`-th ELF image out of the FlatBuffer
      by ELF magic + header extents and writes it to `out_path` (a temp file
      when None).
    Raises FileNotFoundError / ValueError with a specific message otherwise."""
    if os.path.isdir(vmfb_or_dump_dir):
        elfs = [e for e in find_dumped_elfs(vmfb_or_dump_dir) if e["e_type"] == ET_DYN]
        if not elfs:
            raise FileNotFoundError("no ET_DYN ELF file in dump dir %s" % vmfb_or_dump_dir)
        if index >= len(elfs):
            raise IndexError("dump dir has %d ELF executables, index %d requested" % (len(elfs), index))
        return elfs[index]["path"]
    with open(vmfb_or_dump_dir, "rb") as f:
        blob = f.read()
    elfs = locate_embedded_elfs(blob)
    if not elfs:
        raise ValueError("no ELF image found inside %s" % vmfb_or_dump_dir)
    if index >= len(elfs):
        raise IndexError("%s embeds %d ELF images, index %d requested" % (vmfb_or_dump_dir, len(elfs), index))
    e = elfs[index]
    if out_path is None:
        fd, out_path = tempfile.mkstemp(prefix="embedded_elf_", suffix=".so")
        os.close(fd)
    with open(out_path, "wb") as f:
        f.write(blob[e["offset"]:e["offset"] + e["size"]])
    return out_path


# ----------------------------------------------------------------------------
# objdump parsing
# ----------------------------------------------------------------------------
LINE_RE = re.compile(r"^\s*([0-9a-f]+):\s?(.*)$")
LABEL_RE = re.compile(r"^([0-9a-f]+)\s+<([^>]+)>:\s*$")
FILEFMT_RE = re.compile(r"file format\s+(\S+)")
SECTION_RE = re.compile(r"^Disassembly of section\s+(\S+):")
# binutils raw-bytes field: "55                   " / "48 89 e5             " / "a9bf7bfd " ;
# llvm-objdump: " a9 bf 7b fd  " or "a9bf7bfd". Each token must be followed by whitespace
# so a bare two-letter mnemonic (aarch64 `dc`) is never mistaken for bytes.
RAWBYTES_RE = re.compile(r"^\s*(?:[0-9a-f]{2}\s+)+$|^\s*(?:[0-9a-f]{8}\s+)+$")
HEXWORD_RE = re.compile(r"^\s*[0-9a-f]{8}\s*$")  # a lone aarch64 opcode word; never a real mnemonic
X86_PREFIXES = {"data16", "data32", "addr32", "addr16", "cs", "ds", "es", "fs", "gs", "ss",
                "lock", "rep", "repz", "repnz", "repe", "repne", "bnd", "notrack", "xacquire",
                "xrelease", "rex", "rex.w", "rex.wb", "rex.wr", "rex.wrb", "rex.wx", "rex.b", "rex.r", "rex.x", "rex.xb"}


def run_objdump(elf_path, arch, tool=None):
    """Return (text, tool_used).  Prefers the cross objdump for aarch64."""
    candidates = []
    if tool:
        candidates.append(tool)
    else:
        if arch == "aarch64":
            candidates += ["aarch64-linux-gnu-objdump", "aarch64-none-linux-gnu-objdump"]
        candidates += ["objdump", "llvm-objdump"]
    last_err = None
    for t in candidates:
        if shutil.which(t) is None:
            continue
        try:
            r = subprocess.run([t, "-d", "--no-show-raw-insn", elf_path], capture_output=True, text=True)
        except OSError as e:
            last_err = str(e)
            continue
        if r.returncode == 0 and "Disassembly of section" in r.stdout:
            return r.stdout, t
        last_err = (r.stderr or r.stdout).strip()[:200]
    raise RuntimeError("no working objdump for %s (tried %s): %s" % (arch, candidates, last_err))


def parse_objdump(text):
    """-> dict(file_format, arch_hint, labels=[(addr,name)], insns=[dict])"""
    fmt = None
    labels = []
    insns = []
    section = None
    for line in text.splitlines():
        m = FILEFMT_RE.search(line)
        if m and fmt is None:
            fmt = m.group(1)
            continue
        m = SECTION_RE.match(line)
        if m:
            section = m.group(1)
            continue
        m = LABEL_RE.match(line)
        if m:
            labels.append((int(m.group(1), 16), m.group(2)))
            continue
        m = LINE_RE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        rest = m.group(2)
        parts = rest.split("\t")
        # binutils/llvm raw-bytes column (always followed by whitespace, unlike a
        # 2-letter mnemonic such as aarch64 `dc`), or a bytes-only continuation line
        if parts and (RAWBYTES_RE.match(parts[0]) or (len(parts) > 1 and HEXWORD_RE.match(parts[0]))):
            parts = parts[1:]
        body = " ".join(p.strip() for p in parts if p.strip()).strip()
        if not body:
            continue  # continuation line of a long x86 instruction (raw-bytes mode)
        # strip disassembler comments: aarch64 "// ...", x86 "# 2910 <sym>"
        body = re.sub(r"\s+//.*$", "", body)
        body = re.sub(r"\s+#\s+[0-9a-f]+\s+<.*$", "", body)
        toks = body.split()
        i = 0
        prefixes = []
        while i < len(toks) - 1 and toks[i].lower() in X86_PREFIXES:
            prefixes.append(toks[i])
            i += 1
        mnem = toks[i]
        ops = " ".join(toks[i + 1:])
        insns.append(dict(addr=addr, mnem=mnem, ops=ops, text=body, prefixes=prefixes, section=section))
    arch_hint = None
    if fmt:
        if "aarch64" in fmt:
            arch_hint = "aarch64"
        elif "x86-64" in fmt or "x86_64" in fmt:
            arch_hint = "x86_64"
    return dict(file_format=fmt, arch_hint=arch_hint, labels=labels, insns=insns)


# ----------------------------------------------------------------------------
# Export table recovery from relocations
# ----------------------------------------------------------------------------
IDENT_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_$.]*$")


def recover_export_table(elf):
    """Returns list of dict(ordinal, addr, name) or [] when not recoverable."""
    rels = [r for r in elf.relocations() if (elf.arch, r["type"]) in R_RELATIVE and r["sym"] == 0]
    rels.sort(key=lambda r: r["offset"])
    kinds = []
    for r in rels:
        a = r["addend"]
        if elf.in_exec(a):
            kinds.append("text")
        else:
            s = elf.cstr_at_vaddr(a)
            kinds.append("str" if s and IDENT_RE.match(s) else "other")
    # maximal runs of consecutive (stride 8) relocations of one kind
    runs = []
    for i, r in enumerate(rels):
        if runs and kinds[i] == runs[-1]["kind"] and r["offset"] == runs[-1]["last"] + 8:
            runs[-1]["items"].append(r)
            runs[-1]["last"] = r["offset"]
        else:
            runs.append(dict(kind=kinds[i], items=[r], last=r["offset"], first=r["offset"]))
    text_runs = [ru for ru in runs if ru["kind"] == "text"]
    if not text_runs:
        return []
    ptr_run = max(text_runs, key=lambda ru: len(ru["items"]))
    n = len(ptr_run["items"])
    name_run = next((ru for ru in runs if ru["kind"] == "str" and ru["first"] > ptr_run["last"]
                     and len(ru["items"]) >= n), None)
    exports = []
    for i, r in enumerate(ptr_run["items"]):
        name = elf.cstr_at_vaddr(name_run["items"][i]["addend"]) if name_run else None
        exports.append(dict(ordinal=i, addr=r["addend"], name=name))
    return exports


# ----------------------------------------------------------------------------
# Per-function analysis
# ----------------------------------------------------------------------------
def imm(s):
    s = s.strip().lstrip("#$")
    return int(s, 0)


A64_PREIDX_ST = re.compile(r"^(stp|str)\s+(\w+)(?:,\s*(\w+))?,\s*\[sp,\s*#(-?(?:0x[0-9a-f]+|\d+))\]!$")
A64_POSTIDX_LD = re.compile(r"^(ldp|ldr)\s+(\w+)(?:,\s*(\w+))?,\s*\[sp\],\s*#(-?(?:0x[0-9a-f]+|\d+))$")
A64_FRAMEREC_ST = re.compile(r"^stp\s+x29,\s*x30,\s*\[sp(?:,\s*#-?(?:0x[0-9a-f]+|\d+))?\]!?$")
A64_FRAMEREC_LD = re.compile(r"^ldp\s+x29,\s*x30,\s*\[sp(?:,\s*#-?(?:0x[0-9a-f]+|\d+))?\](?:,\s*#-?(?:0x[0-9a-f]+|\d+))?$")
A64_SUB_SP_IMM = re.compile(r"^sub\s+sp,\s*sp,\s*#(0x[0-9a-f]+|\d+)(?:,\s*lsl\s*#(\d+))?$")
A64_ADD_SP_IMM = re.compile(r"^add\s+sp,\s*sp,\s*#(0x[0-9a-f]+|\d+)(?:,\s*lsl\s*#(\d+))?$")
A64_SUB_SP_REG = re.compile(r"^sub\s+sp,\s*sp,\s*[xw]\d+")
A64_FP_SETUP = re.compile(r"^(mov\s+x29,\s*sp|add\s+x29,\s*sp,\s*#.*)$")
# AArch64 dynamic stack realignment idiom (e.g. for a 64 B-aligned local buffer):
#   sub x9, sp, #0x70              ; reserve 0x70 bytes below sp into a scratch reg
#   and sp, x9, #0xffffffffffffffc0 ; round DOWN to the alignment -> new sp
#   ...
#   mov sp, x29                     ; restore sp from the frame pointer
# Two lines, not one `sub sp,sp,#N`/`and $-N,%rsp`, so needs its own recognizer
# (E14 Stage 1: elf_stack_frame.py's first pass missed this on the conv2d
# kernel and under-reported callee-save-only frame_bytes).
A64_SUB_REG_FROM_SP = re.compile(r"^sub\s+(x\d+),\s*sp,\s*#(0x[0-9a-f]+|\d+)$")
A64_AND_SP_FROM_REG = re.compile(r"^and\s+sp,\s*(x\d+),\s*#(0x[0-9a-f]+)$")
A64_MOV_SP_FROM_REG = re.compile(r"^mov\s+sp,\s*(x\d+)$")
A64_CALLS = {"bl", "blr", "blraa", "blraaz", "blrab", "blrabz"}
A64_ARR = re.compile(r"\bv\d+\.(16b|8b|8h|4h|4s|2s|2d|1d|b|h|s|d)\b")
A64_VREG_LANE = re.compile(r"\bv\d+\.[bhsd]\[\d+\]")
A64_QREG = re.compile(r"\bq\d+\b")

X86_PUSH = re.compile(r"^push[q]?\s+%(\w+)$")
X86_POP = re.compile(r"^pop[q]?\s+%(\w+)$")
X86_MOV_RSP_RBP = re.compile(r"^mov[q]?\s+%rsp,\s*%rbp$")
# `lea -N(%rbp),%rsp` resets rsp to a fixed offset from rbp in one step -- the
# x86-64 counterpart of AArch64's `mov sp, x29`, seen after a realigned (`and
# $-N,%rsp`) frame. It restores an unknown mix of locals+padding that this
# analyzer does not attempt to reconcile against local_alloc_bytes byte-for-byte
# (unlike the plain `add $imm,%rsp` case) -- frame_balanced is reported as None
# rather than guessed when this idiom appears (E14 Stage 1 review finding).
X86_LEA_RBP_RSP = re.compile(r"^lea[q]?\s+-(0x[0-9a-f]+|\d+)\(%rbp\),\s*%rsp$")
X86_SUB_RSP_IMM = re.compile(r"^sub[q]?\s+\$(0x[0-9a-f]+|\d+),\s*%rsp$")
X86_ADD_RSP_IMM = re.compile(r"^add[q]?\s+\$(0x[0-9a-f]+|\d+),\s*%rsp$")
X86_SUB_RSP_REG = re.compile(r"^sub[q]?\s+%\w+,\s*%rsp$")
X86_AND_RSP = re.compile(r"^and[q]?\s+\$(0x[0-9a-f]+|-?\d+),\s*%rsp$")
X86_MEM_SP = re.compile(r"\(%r(sp|bp)[,)]")


def analyze_aarch64(fn):
    ins = fn["body"]
    r = dict(callee_save_bytes=0, local_alloc_bytes=0, restore_bytes=0, dynamic_stack_alloc=False,
             has_frame_record=False, call_insns=0, call_targets=[], ret_insns=0,
             sp_relative_mem_ops=0, sp_relative_mem_op_list=[], prologue=[], epilogue=[],
             realign_max_pad_bytes=0)
    fr_store = fp_setup = False
    # x29 is only a frame pointer when the function actually builds a frame record
    fr_pre = any(A64_FRAMEREC_ST.match(x["text"]) for x in ins) and any(A64_FP_SETUP.match(x["text"]) for x in ins)
    base_re = re.compile(r"\[(sp|x29)\b" if fr_pre else r"\[sp\b")
    # realign scratch-register tracking: reg -> bytes requested by `sub reg, sp, #N`,
    # consumed (and validated) by a matching `and sp, reg, #mask`
    realign_pending = {}
    realign_bytes = 0
    realign_restored = False
    vec = dict(fmla=0, fmul=0, fadd=0, fmls=0, fsub=0, neon_vreg_operands=0)
    arrangements = set()
    compute_arr = set()  # arrangements used by the FP arithmetic instructions themselves
    for x in ins:
        t, m, ops = x["text"], x["mnem"], x["ops"]
        if m in ("fmla", "fmul", "fadd", "fmls", "fsub"):
            vec[m] += 1
            compute_arr.update(A64_ARR.findall(ops))
        vec["neon_vreg_operands"] += len(A64_ARR.findall(ops)) + len(A64_QREG.findall(ops))
        arrangements.update(A64_ARR.findall(ops))
        if m in A64_CALLS:
            r["call_insns"] += 1
            r["call_targets"].append(t)
        if m == "ret":
            r["ret_insns"] += 1
        mm = A64_PREIDX_ST.match(t)
        if mm:
            r["callee_save_bytes"] += -imm(mm.group(4))
            r["prologue"].append(t)
        mm = A64_POSTIDX_LD.match(t)
        if mm:
            r["restore_bytes"] += imm(mm.group(4))
            r["epilogue"].append(t)
        mm = A64_SUB_SP_IMM.match(t)
        if mm:
            r["local_alloc_bytes"] += imm(mm.group(1)) << int(mm.group(2) or 0)
            r["prologue"].append(t)
        mm = A64_ADD_SP_IMM.match(t)
        if mm:
            r["restore_bytes"] += imm(mm.group(1)) << int(mm.group(2) or 0)
            r["epilogue"].append(t)
        if A64_SUB_SP_REG.match(t):
            r["dynamic_stack_alloc"] = True
        mm = A64_SUB_REG_FROM_SP.match(t)
        if mm:
            realign_pending[mm.group(1)] = imm(mm.group(2))
        mm = A64_AND_SP_FROM_REG.match(t)
        if mm and mm.group(1) in realign_pending:
            requested = realign_pending.pop(mm.group(1))
            mask = int(mm.group(2), 16) & ((1 << 64) - 1)
            align = ((~mask) & ((1 << 64) - 1)) + 1
            r["local_alloc_bytes"] += requested
            r["realign_max_pad_bytes"] = max(r["realign_max_pad_bytes"], max(align - 1, 0))
            realign_bytes = requested
            r["prologue"].append(t)
        mm = A64_MOV_SP_FROM_REG.match(t)
        if mm and realign_bytes:
            realign_restored = True
            r["restore_bytes"] += realign_bytes  # `mov sp, x29` restores the realigned locals in one step
            r["epilogue"].append(t)
        if A64_FRAMEREC_ST.match(t):
            fr_store = True
        if A64_FP_SETUP.match(t):
            fp_setup = True
            r["prologue"].append(t)
        # sp/x29-relative loads and stores other than the frame record itself
        is_ldst = m.startswith(("ld", "st")) or m in ("prfm",)
        if is_ldst and base_re.search(ops) and not (A64_FRAMEREC_ST.match(t) or A64_FRAMEREC_LD.match(t)):
            r["sp_relative_mem_ops"] += 1
            if len(r["sp_relative_mem_op_list"]) < 32:
                r["sp_relative_mem_op_list"].append("%x: %s" % (x["addr"], t))
    r["has_frame_record"] = fr_store and fp_setup
    r["frame_bytes"] = r["callee_save_bytes"] + r["local_alloc_bytes"]
    r["frame_balanced"] = (r["restore_bytes"] == r["frame_bytes"]) if r["ret_insns"] else None
    # `sub reg, sp, #N` with no matching `and sp, reg, #mask`, or a realigned sp
    # never restored via `mov sp, x29`, is an sp manipulation this analyzer did
    # not fully account for -- flag it rather than silently under-report.
    if realign_pending or (realign_bytes and not realign_restored):
        r["dynamic_stack_alloc"] = True
    r["return_address_bytes"] = 0
    r["vector_insns"] = vec
    def widest(arrs):
        for a in ("2d", "4s", "8h", "16b", "1d", "2s", "4h", "8b"):
            if a in arrs:
                return a
        return None
    w = widest(compute_arr) or widest(arrangements)
    lane = {"2d": "64-bit x2", "4s": "32-bit x4", "8h": "16-bit x8", "16b": "8-bit x16",
            "1d": "64-bit x1", "2s": "32-bit x2", "4h": "16-bit x4", "8b": "8-bit x8"}.get(w, "")
    if w in ("2d", "4s", "8h", "16b"):
        r["neon_or_avx_width_hint"] = "NEON 128-bit, compute arrangement v.%s (%s); arrangements seen: %s" % (
            w, lane, sorted(arrangements - {"s", "d", "b", "h"}))
    elif w:
        r["neon_or_avx_width_hint"] = "NEON 64-bit, compute arrangement v.%s (%s); arrangements seen: %s" % (
            w, lane, sorted(arrangements - {"s", "d", "b", "h"}))
    else:
        r["neon_or_avx_width_hint"] = "scalar (no NEON vector arrangements)"
    return r


def analyze_x86_64(fn):
    ins = fn["body"]
    r = dict(callee_save_bytes=0, local_alloc_bytes=0, restore_bytes=0, dynamic_stack_alloc=False,
             has_frame_record=False, call_insns=0, call_targets=[], ret_insns=0,
             sp_relative_mem_ops=0, sp_relative_mem_op_list=[], prologue=[], epilogue=[],
             realign_max_pad_bytes=0, push_insns_total=0, pop_insns_total=0, sp_relative_lea=0, lea_rbp_rsp_epilogue=False)
    push_rbp = fp_setup = False
    prologue_pushes = 0
    in_prologue = True
    # %rbp is only a frame pointer when the function actually builds a frame record
    fr_pre = any(X86_PUSH.match(x["text"]) and X86_PUSH.match(x["text"]).group(1) == "rbp" for x in ins) \
        and any(X86_MOV_RSP_RBP.match(x["text"]) for x in ins)
    mem_re = X86_MEM_SP if fr_pre else re.compile(r"\(%rsp[,)]")
    vec = dict(vfmadd=0, mulss=0, addss=0, zmm_refs=0, ymm_refs=0, xmm_refs=0, v_prefixed_insns=0,
               avx512_broadcast_or_mask=0)
    for x in ins:
        t, m, ops = x["text"], x["mnem"], x["ops"]
        if m.startswith("vfmadd"):
            vec["vfmadd"] += 1
        if m in ("mulss", "vmulss"):
            vec["mulss"] += 1
        if m in ("addss", "vaddss"):
            vec["addss"] += 1
        vec["zmm_refs"] += ops.count("zmm")
        vec["ymm_refs"] += ops.count("ymm")
        vec["xmm_refs"] += ops.count("xmm")
        if m.startswith("v") and re.search(r"[xyz]mm", ops):
            vec["v_prefixed_insns"] += 1
        if "{1to" in ops or re.search(r"\{%k\d", ops) or "zmm" in ops:
            vec["avx512_broadcast_or_mask"] += 1
        if m.startswith("call"):
            r["call_insns"] += 1
            r["call_targets"].append(t)
        if m in ("ret", "retq"):
            r["ret_insns"] += 1
        pm = X86_PUSH.match(t)
        if pm:
            r["push_insns_total"] += 1
        if X86_POP.match(t):
            r["pop_insns_total"] += 1
            r["epilogue"].append(t)
        if m == "leave":
            r["epilogue"].append(t)
        # prologue window: leading run of push / mov %rsp,%rbp / sub $imm,%rsp / and $imm,%rsp / endbr64
        if in_prologue:
            if pm:
                prologue_pushes += 1
                r["prologue"].append(t)
                if pm.group(1) == "rbp":
                    push_rbp = True
            elif X86_MOV_RSP_RBP.match(t):
                fp_setup = True
                r["prologue"].append(t)
            elif X86_SUB_RSP_IMM.match(t) or X86_AND_RSP.match(t) or m == "endbr64":
                r["prologue"].append(t)
            else:
                in_prologue = False
        mm = X86_SUB_RSP_IMM.match(t)
        if mm:
            r["local_alloc_bytes"] += imm(mm.group(1))
        mm = X86_ADD_RSP_IMM.match(t)
        if mm:
            r["restore_bytes"] += imm(mm.group(1))
            r["epilogue"].append(t)
        if X86_SUB_RSP_REG.match(t):
            r["dynamic_stack_alloc"] = True
        mm = X86_AND_RSP.match(t)
        if mm:
            mask = imm(mm.group(1)) & 0xFFFFFFFFFFFFFFFF
            align = (~mask + 1) & mask if mask else 0
            r["realign_max_pad_bytes"] = max(r["realign_max_pad_bytes"], max(align - 1, 0))
        if X86_LEA_RBP_RSP.match(t):
            r["lea_rbp_rsp_epilogue"] = True
            r["epilogue"].append(t)
        if m not in ("push", "pushq", "pop", "popq", "call", "callq", "ret", "retq", "leave") and mem_re.search(ops):
            if m.startswith("lea"):
                r["sp_relative_lea"] += 1
            else:
                r["sp_relative_mem_ops"] += 1
                if len(r["sp_relative_mem_op_list"]) < 32:
                    r["sp_relative_mem_op_list"].append("%x: %s" % (x["addr"], t))
    r["callee_save_bytes"] = 8 * prologue_pushes
    r["has_frame_record"] = push_rbp and fp_setup
    r["frame_bytes"] = r["callee_save_bytes"] + r["local_alloc_bytes"]
    r["restore_bytes"] += 8 * r["pop_insns_total"]
    # `lea -N(%rbp),%rsp` folds the local+realignment restore into one instruction
    # this analyzer does not attempt to size -- report "not determined" instead
    # of a spurious mismatch (frame_bytes/invocation_stack_bytes are unaffected).
    r["frame_balanced"] = (None if r.get("lea_rbp_rsp_epilogue") else
                           ((r["restore_bytes"] == r["frame_bytes"]) if r["ret_insns"] else None))
    r["return_address_bytes"] = 8
    r["vector_insns"] = vec
    if vec["zmm_refs"]:
        r["neon_or_avx_width_hint"] = "AVX-512 (512-bit zmm)"
    elif vec["ymm_refs"]:
        r["neon_or_avx_width_hint"] = "AVX/AVX2 (256-bit ymm)"
    elif vec["xmm_refs"] and vec["avx512_broadcast_or_mask"]:
        r["neon_or_avx_width_hint"] = "AVX-512VL-encoded 128-bit xmm ({1toN} broadcast / mask / xmm16-31)"
    elif vec["xmm_refs"] and vec["v_prefixed_insns"]:
        r["neon_or_avx_width_hint"] = "AVX-encoded 128-bit xmm"
    elif vec["xmm_refs"]:
        r["neon_or_avx_width_hint"] = "SSE 128-bit xmm (scalar ss ops)"
    else:
        r["neon_or_avx_width_hint"] = "no vector registers"
    return r


# ----------------------------------------------------------------------------
# Function splitting
# ----------------------------------------------------------------------------
QUERY_FN = "iree_hal_executable_library_query"


def split_functions(insns, arch, starts_named, use_heuristic):
    """starts_named: {addr: (name, source)}.  Returns list of function dicts with
    'body' (instructions without trailing padding) and 'padding' (int3 run)."""
    starts = dict(starts_named)
    if use_heuristic:
        pending = False
        for x in insns:
            if pending and x["mnem"] != "int3":
                if x["addr"] not in starts:
                    starts[x["addr"]] = ("func@0x%x" % x["addr"], "heuristic(ret+padding)")
                pending = False
            if x["mnem"] in ("ret", "retq"):
                pending = True
    if insns and (not starts or min(starts) > insns[0]["addr"]):
        a = insns[0]["addr"]
        starts[a] = ("func@0x%x" % a, "first-instruction")
    order = sorted(starts)
    fns = []
    for i, a in enumerate(order):
        hi = order[i + 1] if i + 1 < len(order) else None
        body = [x for x in insns if x["addr"] >= a and (hi is None or x["addr"] < hi)]
        pad = 0
        while body and body[-1]["mnem"] == "int3" and arch == "x86_64":
            body.pop()
            pad += 1
        name, src = starts[a]
        fns.append(dict(name=name, name_source=src, addr=a, body=body, padding=pad, end=hi))
    return fns


# ----------------------------------------------------------------------------
# Call-target resolution (E26a)
# ----------------------------------------------------------------------------
# classify() below has always said, for any executable containing call
# instructions, "callee stack use is not visible in this ELF -> resolve targets
# (imports/runtime) before classifying" -- and that resolution step was never
# implemented, so ANY call at all put the model in bucket (3)/(4) and
# gen_contract_header.py (E21/D22) then refused to emit a deployable header.
#
# Every model this repository had measured until now (the 14 stored E14
# contracts and E25's canonical model) has total_call_insns == 0, so the gap
# was invisible: hand-written linalg models lower to self-contained dispatch
# functions. A real public CNN does not. MLPerf Tiny's ResNet (CIFAR-10)
# produces ONE dispatch with calls -- the softmax -- whose 80 call
# instructions target exactly two addresses, both inside this ELF's own .text,
# both leaf routines with a zero-byte frame (compiler-generated float helpers).
# There is no .plt and no undefined symbol. Refusing that model reports "no
# static task-stack bound" for a program whose task-stack use is fully static
# and equal to 439 + 8 B -- a type (B) defect (over-rejection) in this repo's
# two-way defect definition.
#
# The resolution below is deliberately one-sided: it can only ever turn
# "unresolved" into "resolved", and it refuses on the first thing it cannot
# prove. Anything indirect (call *%rax, blr), anything targeting outside this
# ELF's executable sections, any callee without a clean single-ret body, any
# branch leaving the callee (tail call), any dynamic stack growth inside a
# callee, and any recursion all keep the original bucket (3)/(4) verdict.
X86_CALL_DIRECT = re.compile(r"^callq?\s+([0-9a-fA-F]+)\s*(?:<|$)")
A64_CALL_DIRECT = re.compile(r"^bl\s+([0-9a-fA-F]+)\s*(?:<|$)")
X86_BRANCH_TGT = re.compile(r"^j[a-z]+\s+([0-9a-fA-F]+)\s*(?:<|$)")
A64_BRANCH_TGT = re.compile(r"^(?:b|b\.[a-z]+|cbn?z|tbn?z)\s+(?:[^,]+,\s*)*([0-9a-fA-F]+)\s*(?:<|$)")


def _direct_call_target(text, arch):
    """Numeric target of a DIRECT call, or None (indirect / unparseable)."""
    m = (X86_CALL_DIRECT if arch == "x86_64" else A64_CALL_DIRECT).match(text.strip())
    return int(m.group(1), 16) if m else None


def _branch_target(x, arch):
    """(is_branch, target) -- target None means 'branch whose destination we
    could not read', which is treated exactly like a branch out of range."""
    m = x["mnem"]
    if arch == "x86_64":
        if not m.startswith("j"):
            return (False, None)
        mm = X86_BRANCH_TGT.match(x["text"].strip())
        return (True, int(mm.group(1), 16) if mm else None)
    if m in ("br", "braa", "brab", "brk"):
        return (True, None)                       # indirect branch: never resolvable
    if not (m == "b" or m.startswith("b.") or m.startswith("cb") or m.startswith("tb")):
        return (False, None)                      # bl/blr are calls, handled separately
    mm = A64_BRANCH_TGT.match(x["text"].strip())
    return (True, int(mm.group(1), 16) if mm else None)


def _is_uncond_jump(x, arch):
    return x["mnem"] in ("jmp", "jmpq") if arch == "x86_64" else x["mnem"] == "b"


def _callee_body(insns, addr_index, start, arch, known_starts, limit=20000):
    """Discover a callee's extent by walking its control-flow graph from `start`.

    Slicing "up to the first ret" is wrong -- a function may have several rets
    with forward branches jumping past the first one (MLPerf Tiny's ResNet float
    helper at 0x5440 does exactly that at 0x5497). Walking the CFG finds the real
    extent instead. Returns (body, None) or (None, reason); anything that cannot
    be followed -- an indirect branch, an unreadable target, a jump into another
    known function (tail call), a target outside the disassembly -- refuses."""
    if start not in addr_index:
        return None, "no instruction boundary at 0x%x" % start
    seen, work, steps = set(), [start], 0
    while work:
        a = work.pop()
        while True:
            steps += 1
            if steps > limit:
                return None, "callee 0x%x exceeds the %d-instruction walk limit" % (start, limit)
            i = addr_index.get(a)
            if i is None:
                return None, "control flow of callee 0x%x reaches 0x%x, outside the disassembly" % (start, a)
            if a in seen:
                break
            seen.add(a)
            x = insns[i]
            if x["mnem"] in ("ret", "retq"):
                break
            is_branch, tgt = _branch_target(x, arch)
            if is_branch:
                if tgt is None:
                    return None, "indirect or unreadable branch at 0x%x in callee 0x%x" % (a, start)
                if tgt in known_starts:
                    return None, ("callee 0x%x tail-calls another function at 0x%x" % (start, tgt))
                work.append(tgt)
                if _is_uncond_jump(x, arch):
                    break
            if i + 1 >= len(insns):
                return None, "callee 0x%x runs off the end of the disassembly" % start
            a = insns[i + 1]["addr"]
    lo, hi = min(seen), max(seen)
    body = [x for x in insns if lo <= x["addr"] <= hi]
    return body, None


def _resolve_callee(insns, addr_index, start, arch, analyzer, in_exec, known_starts, seen):
    """dict for the callee rooted at `start`, or (None, reason)."""
    if start in seen:
        return None, "recursion: 0x%x is already on the call chain" % start
    if not in_exec(start):
        return None, "call target 0x%x is outside this ELF's executable sections" % start
    body, err = _callee_body(insns, addr_index, start, arch, known_starts)
    if body is None:
        return None, err
    a = analyzer(dict(body=body))
    if a["dynamic_stack_alloc"]:
        return None, "callee 0x%x grows the stack by a register amount (dynamic alloca)" % start
    frame = a["callee_save_bytes"] + a["local_alloc_bytes"]
    inv = frame + a["return_address_bytes"] + a.get("realign_max_pad_bytes", 0)
    nested_max, nested = 0, []
    for t in a["call_targets"]:
        tt = _direct_call_target(t, arch)
        if tt is None:
            return None, "indirect call inside callee 0x%x (%r)" % (start, t.strip()[:60])
        rec, err = _resolve_callee(insns, addr_index, tt, arch, analyzer, in_exec, known_starts,
                                   seen | {start})
        if rec is None:
            return None, err
        nested_max = max(nested_max, rec["chain_stack_bytes"])
        nested.append(rec)
    return dict(addr="0x%x" % start, insns=len(body), frame_bytes=frame,
                invocation_stack_bytes=inv, chain_stack_bytes=inv + nested_max,
                calls=len(a["call_targets"]), nested=nested), None


def resolve_call_graph(insns, fns, funcs, elf, arch, analyzer):
    """Try to account for every call instruction's callee stack.

    Returns a dict that is always safe to consume: `unresolved_call_insns` is
    the count classify() must use, and it equals total_call_insns whenever
    anything could not be proven."""
    total = sum(f["call_insns"] for f in funcs)
    out = dict(total_call_insns=total, unresolved_call_insns=total, resolved=(total == 0),
               reason=None if total == 0 else "not attempted", distinct_targets=[],
               callees=[], max_chain_stack_bytes=None)
    if total == 0:
        out["reason"] = "no call instructions"
        out["max_chain_stack_bytes"] = 0
        return out
    if not insns:
        out["reason"] = "no disassembly available"
        return out
    addr_index = {x["addr"]: i for i, x in enumerate(insns)}
    if elf is not None:
        in_exec = elf.in_exec
    else:
        lo_a, hi_a = insns[0]["addr"], insns[-1]["addr"]
        in_exec = lambda a: lo_a <= a <= hi_a                          # noqa: E731
    # a jump INTO one of these is a tail call to another function, not internal
    # control flow, so the resolver refuses rather than swallowing its frame.
    known_starts = {f["addr"] for f in fns}
    cache, targets = {}, []
    per_fn_chain = {}
    for raw, rec in zip(fns, funcs):
        best = 0
        for t in rec["call_targets"]:
            tt = _direct_call_target(t, arch)
            if tt is None:
                out["reason"] = "indirect call in %s (%r)" % (rec["name"], t.strip()[:60])
                return out
            targets.append(tt)
            if tt not in cache:
                r, err = _resolve_callee(insns, addr_index, tt, arch, analyzer, in_exec,
                                         known_starts, frozenset())
                if r is None:
                    out["reason"] = err
                    return out
                cache[tt] = r
            best = max(best, cache[tt]["chain_stack_bytes"])
        per_fn_chain[rec["name"]] = rec["invocation_stack_bytes"] + best
    out.update(resolved=True, unresolved_call_insns=0,
               reason="all %d call instruction(s) target %d address(es) inside this ELF; every "
                      "callee has a static frame and no indirect or outbound control flow"
                      % (total, len(cache)),
               distinct_targets=sorted("0x%x" % a for a in set(targets)),
               callees=[cache[a] for a in sorted(cache)],
               per_function_chain_stack_bytes=per_fn_chain,
               max_chain_stack_bytes=max(per_fn_chain.values(), default=0))
    return out

# ----------------------------------------------------------------------------
# LLVM IR (.codegen.ll) facts
# ----------------------------------------------------------------------------
def analyze_ll(path):
    text = open(path, encoding="utf-8", errors="replace").read()
    defines = re.findall(r"^define\s+[^@\n]*@([\w.$]+)\(", text, re.M)
    declares = re.findall(r"^declare\s+[^@\n]*@([\w.$]+)\(", text, re.M)
    calls = re.findall(r"\bcall\b[^@\n]*@([\w.$]+)\(", text)
    alloca_count = len(re.findall(r"=\s*alloca\s", text))
    fp = sorted(set(re.findall(r'"frame-pointer"="([^"]+)"', text)))
    triple = re.search(r'target triple = "([^"]+)"', text)
    external = sorted({c for c in calls if c not in defines and not c.startswith("llvm.")})
    return dict(path=path, alloca_count=alloca_count, defines=defines, declares=declares,
                non_intrinsic_declares=[d for d in declares if not d.startswith("llvm.")],
                external_calls=external, frame_pointer_attrs=fp,
                target_triple=triple.group(1) if triple else None,
                malloc_free_refs=len(re.findall(r"@(malloc|free|calloc|realloc)\b", text)))


# ----------------------------------------------------------------------------
# Main analysis
# ----------------------------------------------------------------------------
def analyze(elf_path=None, objdump_tool=None, objdump_txt=None, ll_path=None):
    elf = None
    elf_bytes = None
    if elf_path:
        with open(elf_path, "rb") as f:
            elf_bytes = f.read()
        elf = Elf64(elf_bytes)
    if objdump_txt:
        with open(objdump_txt, encoding="utf-8", errors="replace") as f:
            dis_text = f.read()
        tool_used = "pre-generated:" + objdump_txt
    elif elf is not None:
        dis_text, tool_used = run_objdump(elf_path, elf.arch, objdump_tool)
    else:
        raise ValueError("need --elf or --objdump-txt")
    dis = parse_objdump(dis_text)
    arch = elf.arch if elf is not None else dis["arch_hint"]
    if arch not in ("aarch64", "x86_64"):
        raise ValueError("unsupported arch %r" % arch)
    if elf is not None and dis["arch_hint"] and dis["arch_hint"] != elf.arch:
        raise ValueError("objdump arch %s != ELF arch %s" % (dis["arch_hint"], elf.arch))
    insns = dis["insns"]

    out = dict(tool="harness/elf_stack_frame.py", elf=elf_path, arch=arch,
               elf_bytes=len(elf_bytes) if elf_bytes is not None else None,
               elf_sha256=hashlib.sha256(elf_bytes).hexdigest() if elf_bytes is not None else None,
               objdump=dict(tool=tool_used, file_format=dis["file_format"]))

    starts = {}
    exports = []
    if elf is not None:
        out["elf_type"] = {ET_REL: "ET_REL", ET_EXEC: "ET_EXEC", ET_DYN: "ET_DYN"}.get(elf.e_type, str(elf.e_type))
        out["sections"] = {s["name"]: s["size"] for s in elf.sections if s["flags"] & SHF_ALLOC and s["size"]}
        out["text_bytes"] = sum(s["size"] for s in elf.sections if s["flags"] & SHF_EXECINSTR)
        out["rodata_bytes"] = sum(s["size"] for s in elf.sections if s["name"].startswith(".rodata"))
        syms = elf.symbols()
        out["symbols"] = sorted({(s["name"], s["value"]) for s in syms if s["type"] == STT_FUNC and s["name"]})
        out["symbols"] = [dict(name=n, addr="0x%x" % v) for n, v in out["symbols"]]
        out["undefined_symbols"] = sorted({s["name"] for s in syms if s["shndx"] == 0 and s["name"]})
        rels = elf.relocations()
        types = {}
        for r in rels:
            nm = RELOC_TYPE_NAMES.get(arch, {}).get(r["type"], "type_%d" % r["type"])
            types[nm] = types.get(nm, 0) + 1
        out["relocations"] = dict(count=len(rels), types=types,
                                  non_relative=sum(1 for r in rels if (arch, r["type"]) not in R_RELATIVE))
        for s in syms:
            if s["type"] == STT_FUNC and s["name"] and s["value"]:
                starts[s["value"]] = (s["name"], "symtab")
        exports = recover_export_table(elf)
        out["exports"] = [dict(ordinal=e["ordinal"], name=e["name"], addr="0x%x" % e["addr"]) for e in exports]
        for e in exports:
            if e["addr"] not in starts:
                starts[e["addr"]] = (e["name"] or "export_%d@0x%x" % (e["ordinal"], e["addr"]), "export_table(.rela.dyn)")
    else:
        for a, n in dis["labels"]:
            if IDENT_RE.match(n):
                starts[a] = (n, "objdump-label")

    use_heuristic = not exports
    fns = split_functions(insns, arch, starts, use_heuristic)
    out["function_split_method"] = "symtab+export_table(.rela.dyn)" if exports else "symtab/labels + heuristic(ret+padding)"

    ll = analyze_ll(ll_path) if ll_path else None
    if ll:
        out["llvm_ir"] = ll
        # name heuristic fallback: .ll define order (dispatch defines only)
        ll_dispatch = [d for d in ll["defines"] if d != QUERY_FN]
        unnamed = [f for f in fns if f["name_source"] in ("heuristic(ret+padding)", "first-instruction")]
        if unnamed and len(unnamed) == len(ll_dispatch):
            for f, n in zip(unnamed, ll_dispatch):
                f["name"], f["name_source"] = n, "llvm_ir_define_order(unverified)"
        if exports:
            out["export_names_verified_in_ll"] = all(e["name"] in ll["defines"] for e in exports)

    analyzer = analyze_aarch64 if arch == "aarch64" else analyze_x86_64
    funcs = []
    for f in fns:
        a = analyzer(f)
        rec = dict(name=f["name"], name_source=f["name_source"], addr="0x%x" % f["addr"],
                   insns=len(f["body"]), padding_insns_after=f["padding"],
                   code_bytes=(f["end"] - f["addr"]) if f["end"] else None)
        rec.update(a)
        # worst case: frame + return address + any stack realignment padding
        # the observed instructions could insert (realign_max_pad_bytes is not
        # already part of frame_bytes on either ISA).
        rec["invocation_stack_bytes"] = (rec["frame_bytes"] + rec["return_address_bytes"]
                                         + rec.get("realign_max_pad_bytes", 0))
        funcs.append(rec)
    out["functions"] = funcs
    disp = [f for f in funcs if f["name"] != QUERY_FN]
    out["dispatch_functions"] = [f["name"] for f in disp]
    out["max_dispatch_frame_bytes"] = max([f["frame_bytes"] for f in disp], default=0)
    out["sum_dispatch_frame_bytes"] = sum(f["frame_bytes"] for f in disp)
    out["max_dispatch_invocation_stack_bytes"] = max([f["invocation_stack_bytes"] for f in disp], default=0)
    out["max_dispatch_local_alloc_bytes"] = max([f["local_alloc_bytes"] for f in disp], default=0)
    out["total_call_insns"] = sum(f["call_insns"] for f in funcs)
    out["total_insns"] = len(insns)
    out["total_padding_insns"] = sum(f["padding_insns_after"] for f in funcs)
    out["total_code_insns"] = out["total_insns"] - out["total_padding_insns"]
    out["dispatch_insns"] = sum(f["insns"] for f in disp)
    tot = {}
    for f in funcs:
        for k, v in f["vector_insns"].items():
            tot[k] = tot.get(k, 0) + v
    out["vector_insns_total"] = tot
    out["any_dynamic_stack_alloc"] = any(f["dynamic_stack_alloc"] for f in disp)
    out["any_sp_relative_mem_ops"] = any(f["sp_relative_mem_ops"] for f in disp)
    out["all_dispatch_frames_balanced"] = all(f["frame_balanced"] is not False for f in disp)
    # E26a: resolve call targets instead of giving up on their existence.
    cr = resolve_call_graph(insns, fns, funcs, elf, arch, analyzer)
    out["call_resolution"] = cr
    out["unresolved_call_insns"] = cr["unresolved_call_insns"]
    if cr["resolved"]:
        chains = cr.get("per_function_chain_stack_bytes") or {}
        out["max_dispatch_invocation_stack_bytes_with_calls"] = max(
            [chains.get(f["name"], f["invocation_stack_bytes"]) for f in disp], default=0)
    else:
        # unresolved: no chain figure at all rather than a number that looks
        # like one (D25/D29 -- "could not observe" must not read as "observed").
        out["max_dispatch_invocation_stack_bytes_with_calls"] = None
    out["classification_note"] = classify(out, disp)
    return out


def classify(out, disp):
    mx = out["max_dispatch_frame_bytes"]
    calls = out["total_call_insns"]
    # E26a: the question was never "are there calls" but "can the callees' stack
    # be accounted for". Fall back to `calls` when the resolver did not run, so
    # an older/partial analysis keeps the conservative verdict.
    unresolved = out.get("unresolved_call_insns", calls)
    cr = out.get("call_resolution") or {}
    if out["any_dynamic_stack_alloc"]:
        return ("bucket (4) UNACCOUNTED: a dispatch function grows the stack by a register amount "
                "(dynamic alloca); no static task-stack bound -> revise contract boundary before admission.")
    if unresolved:
        return ("bucket (3)/(4) CANDIDATE: %d call instruction(s) in the executable, %d of them unresolved; "
                "callee stack use is not visible in this ELF -> resolve targets (imports/runtime) before "
                "classifying. Resolver said: %s" % (calls, unresolved, cr.get("reason")))
    if calls:
        return ("bucket (2) TASK-STACK with resolved calls: %d call instruction(s) target %d address(es) "
                "inside this same ELF; every callee has a static frame and no indirect or outbound control "
                "flow, so the deepest per-invocation chain is %d B (vs %d B for the calling dispatch alone). "
                "Not HAL memory (not in bounded_bytes); add the chain figure to the task/thread stack budget."
                % (calls, len(cr.get("distinct_targets") or []),
                   out.get("max_dispatch_invocation_stack_bytes_with_calls") or 0,
                   out["max_dispatch_invocation_stack_bytes"]))
    if mx == 0:
        return ("no stack frame and no calls in any dispatch function (leaf, registers only): nothing to add "
                "to the task-stack bucket beyond the IREE runtime residual; HAL contract covers all kernel memory.")
    spill = " with %d sp-relative load/store(s) (spills/locals)" % sum(f["sp_relative_mem_ops"] for f in disp) \
        if out["any_sp_relative_mem_ops"] else " and no sp-relative loads/stores (no spills, no locals)"
    la = out["max_dispatch_local_alloc_bytes"]
    return ("bucket (2) TASK-STACK: each dispatch function reserves at most %d B of stack (%s%s), 0 call "
            "instructions -> call depth 1 below the runtime; per-invocation stack = %d B incl. return address. "
            "Not HAL memory (not in bounded_bytes); add it explicitly to the task/thread stack budget."
            % (mx, ("frame record/callee-saved registers only, no explicit locals" if la == 0
                    else "callee-saved + %d B explicit locals" % la), spill,
               out["max_dispatch_invocation_stack_bytes"]))


# ----------------------------------------------------------------------------
def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--elf", help="embedded ELF executable (dumped .so or extracted)")
    ap.add_argument("--dump-dir", help="iree-compile --iree-hal-dump-executable-files-to directory (preferred)")
    ap.add_argument("--vmfb", help="vmfb to carve the ELF out of (fallback), or to cross-check against --dump-dir")
    ap.add_argument("--extract-to", help="where to write the ELF carved from --vmfb (default: temp file)")
    ap.add_argument("--index", type=int, default=0, help="which embedded executable (multi-executable modules)")
    ap.add_argument("--objdump", help="objdump binary (default: aarch64-linux-gnu-objdump for aarch64, else objdump)")
    ap.add_argument("--objdump-txt", help="pre-generated `objdump -d` output to parse instead of running objdump")
    ap.add_argument("--ll", help="*.codegen.ll from the same iree-compile invocation")
    ap.add_argument("--out", help="write JSON here (also printed)")
    args = ap.parse_args(argv)

    source = {}
    elf_path = args.elf
    if args.dump_dir:
        dumped = find_dumped_elfs(args.dump_dir)
        source["dump_dir"] = args.dump_dir
        source["dump_dir_elf_files"] = dumped
        elf_path = extract_embedded_elf(args.dump_dir, index=args.index)
        source["selected"] = elf_path
    if args.vmfb:
        with open(args.vmfb, "rb") as f:
            blob = f.read()
        found = locate_embedded_elfs(blob)
        source["vmfb"] = args.vmfb
        source["vmfb_bytes"] = len(blob)
        source["vmfb_sha256"] = hashlib.sha256(blob).hexdigest()
        source["vmfb_embedded_elfs"] = found
        if elf_path is None:
            elf_path = extract_embedded_elf(args.vmfb, out_path=args.extract_to, index=args.index)
            source["selected"] = elf_path
            source["selected_origin"] = "carved from vmfb (ELF magic + section-header-table extent)"
        elif found:
            with open(elf_path, "rb") as f:
                sha = hashlib.sha256(f.read()).hexdigest()
            source["vmfb_embedded_elf_matches_elf"] = any(e["sha256"] == sha for e in found)
    if elf_path is None and args.objdump_txt is None:
        ap.error("one of --elf / --dump-dir / --vmfb / --objdump-txt is required")

    res = analyze(elf_path=elf_path, objdump_tool=args.objdump, objdump_txt=args.objdump_txt, ll_path=args.ll)
    if source:
        res["source"] = source
    js = json.dumps(res, indent=2)
    if args.out:
        with open(args.out, "w") as f:
            f.write(js + "\n")
    print(js)
    return 0


if __name__ == "__main__":
    sys.exit(main())
