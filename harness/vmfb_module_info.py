#!/usr/bin/env python3
"""E65/M1: read what a compiled IREE artifact itself says about its producer.

A `.vmfb` is a ZIP container whose first entry `module.fb` begins a size-prefixed FlatBuffer
(`BytecodeModuleDef`, file identifier "IREE", schema
runtime/src/iree/schemas/bytecode_module_def.fbs). Field 13 of the root table is
`bytecode_version`, a uint32 packed as (major << 16) | minor, which the runtime's
verifier compares against IREE_VM_BYTECODE_VERSION_MAJOR / _MINOR before it will load
the module (runtime/src/iree/vm/bytecode/verifier.c, at the revision this repository
evaluates: major must be equal, minor must not exceed the runtime's).

That version is the ONLY producer identity the artifact carries: the module `attrs`
vector is empty on every artifact in this repository and the embedded ELF's `.comment`
section reads "IREE" with no revision. So what this reader returns is coarser than a
compiler revision -- two compiler revisions that emit the same bytecode version are
indistinguishable here, and callers must say so rather than treat a match as a revision
match.

Fail-closed by construction: any structural doubt (first entry not `module.fb`, size prefix out
of bounds, wrong
file identifier, an offset or vtable outside the buffer, field 13 absent) raises
ModuleInfoError. Nothing is defaulted -- an absent field is not version 0.0 (D29/D68:
"could not read" is not a reading).

Usage: python3 harness/vmfb_module_info.py ARTIFACT.vmfb [...]   (prints one JSON line each)
"""
import json
import struct
import sys

MODULE_MEMBER = "module.fb"
FILE_IDENTIFIER = b"IREE"
FIELD_NAME = 0
FIELD_BYTECODE_VERSION = 13


class ModuleInfoError(Exception):
    pass


def _u32(b, o):
    if o < 0 or o + 4 > len(b):
        raise ModuleInfoError("uint32 read at %d outside a %d-byte buffer" % (o, len(b)))
    return struct.unpack_from("<I", b, o)[0]


def _i32(b, o):
    if o < 0 or o + 4 > len(b):
        raise ModuleInfoError("int32 read at %d outside a %d-byte buffer" % (o, len(b)))
    return struct.unpack_from("<i", b, o)[0]


def _u16(b, o):
    if o < 0 or o + 2 > len(b):
        raise ModuleInfoError("uint16 read at %d outside a %d-byte buffer" % (o, len(b)))
    return struct.unpack_from("<H", b, o)[0]


def _field_pos(b, table, index):
    """Absolute position of scalar/offset field `index` of the table at `table`, or None if
    the vtable does not carry it."""
    vt = table - _i32(b, table)
    vt_len = _u16(b, vt)
    if vt_len < 4 or vt + vt_len > len(b):
        raise ModuleInfoError("vtable at %d (length %d) is malformed" % (vt, vt_len))
    slot = 4 + 2 * index
    if slot + 2 > vt_len:
        return None
    rel = _u16(b, vt + slot)
    return None if rel == 0 else table + rel


def _string(b, pos):
    s = pos + _u32(b, pos)
    n = _u32(b, s)
    if s + 4 + n > len(b):
        raise ModuleInfoError("string at %d (length %d) runs past the buffer" % (s, n))
    return b[s + 4:s + 4 + n].decode("utf-8")


ZIP_LOCAL_FILE_HEADER_SIGNATURE = 0x04034B50
ZIP_LOCAL_FILE_HEADER_BYTES = 30


def module_flatbuffer(vmfb_path):
    """Return the FlatBuffer bytes the RUNTIME would verify, located the way it locates them.

    Mirrors runtime/src/iree/vm/bytecode/archive.c (iree_vm_bytecode_module_strip_zip_header
    and iree_vm_bytecode_archive_parse_header) rather than reading the ZIP member: the runtime
    skips the local file header at offset 0 and reads the size prefix against everything that
    follows, and on every artifact in this repository that prefix exceeds the `module.fb`
    member's own length by 4 bytes, so a member-based reader would refuse artifacts the runtime
    loads. The runtime's own bounds rule (prefix <= remaining bytes) is enforced here.
    """
    with open(vmfb_path, "rb") as f:
        data = f.read()
    start = 0
    if len(data) >= 4 and _u32(data, 0) == ZIP_LOCAL_FILE_HEADER_SIGNATURE:
        if len(data) < ZIP_LOCAL_FILE_HEADER_BYTES:
            raise ModuleInfoError("ZIP local header truncated")
        name_len = _u16(data, 26)
        extra_len = _u16(data, 28)
        start = ZIP_LOCAL_FILE_HEADER_BYTES + name_len + extra_len
        if start > len(data):
            raise ModuleInfoError("archive self-reports as a zip but does not have enough data "
                                  "to contain a module")
        member = data[ZIP_LOCAL_FILE_HEADER_BYTES:ZIP_LOCAL_FILE_HEADER_BYTES + name_len]
        if member != MODULE_MEMBER.encode():
            raise ModuleInfoError("first ZIP entry is %r, not %r" % (member, MODULE_MEMBER))
    contents = data[start:]
    if len(contents) < 16:
        raise ModuleInfoError("FlatBuffer data is not present or less than 16 bytes (%d total)"
                              % len(contents))
    prefix = _u32(contents, 0)
    if prefix > len(contents) - 4:
        raise ModuleInfoError("FlatBuffer length prefix out of bounds (prefix is %d but only %d "
                              "available)" % (prefix, len(contents) - 4))
    return contents[4:4 + prefix]


def read_module_info(vmfb_path):
    b = module_flatbuffer(vmfb_path)
    ident = b[4:8]
    if ident != FILE_IDENTIFIER:
        raise ModuleInfoError("file identifier %r != %r" % (ident, FILE_IDENTIFIER))
    root = _u32(b, 0)
    if root < 8 or root >= len(b):
        raise ModuleInfoError("root table offset %d outside the buffer" % root)
    pos = _field_pos(b, root, FIELD_BYTECODE_VERSION)
    if pos is None:
        raise ModuleInfoError("BytecodeModuleDef.bytecode_version (field %d) is absent"
                              % FIELD_BYTECODE_VERSION)
    raw_version = _u32(b, pos)
    name_pos = _field_pos(b, root, FIELD_NAME)
    return {
        "bytecode_version": [raw_version >> 16, raw_version & 0xFFFF],
        "bytecode_version_raw": raw_version,
        "module_name": _string(b, name_pos) if name_pos is not None else None,
        "source": "%s BytecodeModuleDef.bytecode_version (field %d), (major << 16) | minor"
                  % (MODULE_MEMBER, FIELD_BYTECODE_VERSION),
    }


def main(argv):
    rc = 0
    for p in argv:
        try:
            print(json.dumps({"file": p, **read_module_info(p)}))
        except (ModuleInfoError, OSError, UnicodeDecodeError) as e:
            print(json.dumps({"file": p, "error": str(e)}))
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
