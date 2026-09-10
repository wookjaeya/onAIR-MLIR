"""Real, deterministic vmfb corruption methods for the A5a/A5b admission scenarios
(proposal SS11.2, EVIDENCE_v0.9 D11 / EVIDENCE_v0.12 §2.1 / external review F8).

External review F8 (docs/reviews/REVIEW_v0_15_LATEST.md) found that
`harness/e14_make_scenarios.py` and `harness/e14_cfs_scenarios.py` had no code
distinguishing A5a (naive byte flip, caught by the artifact-hash gate before
any IREE runtime exists) from A5b (a structural FlatBuffer corruption that
passes the hash gate -- because the contract is regenerated against the
corrupted file's real hash -- and must instead be rejected by IREE's own
FlatBuffer verifier at load time). Both scenarios used the same
`{"corrupt_of": ..., "flip_offset": ...}` shape with no `corrupt_method`
field, so nothing in code actually enforced that A5b used a different
(structural) corruption than A5a -- the distinction existed only as prose in
docs/EVIDENCE_v0.12_E17.md §2.1, applied "by hand" for that experiment run.

This module makes the two methods real, named, and independently testable:

  flip                     -- single-byte XOR at a raw file offset (A5a):
                               lands anywhere in the vmfb's raw bytes with no
                               structural awareness; whatever it corrupts, the
                               artifact-hash gate (sha256 mismatch) must catch
                               it before any IREE call.
  flatbuffer_root_uoffset   -- structural corruption (A5b): overwrites the
                               4-byte FlatBuffer length prefix at the start of
                               the embedded `module.fb` VM bytecode FlatBuffer
                               with 0xFFFFFFFF, in place, without touching any
                               other byte of the .vmfb ZIP container. The
                               contract used for this scenario must be
                               regenerated (make_corrupted_contract below)
                               against the corrupted file's real sha256/bytes
                               so the artifact-hash gate MATCHes and the
                               corruption is only caught by IREE's own
                               `iree_vm_bytecode_module_create_with_data`
                               FlatBuffer verifier (observed failure string:
                               "FlatBuffer length prefix out of bounds").

Verified empirically (this module's own negative tests, and
harness/contract_negative_tests.py) against the 8 real .vmfb files under
results/e14_aarch64_qemu/{aarch64,x86_64}/vmfb/: every one of them stores
`module.fb` uncompressed (ZIP_STORED) and its first 4 bytes (little-endian
uint32) equal len(module.fb) exactly -- i.e. this really is a whole-buffer
length prefix, not an arbitrary bit pattern, so 0xFFFFFFFF is guaranteed to
be "out of bounds" for any real vmfb this repo produces.
"""
import argparse, hashlib, json, struct, sys, zipfile

LOCAL_HEADER_SIGNATURE = b"PK\x03\x04"
LOCAL_HEADER_FIXED_SIZE = 30  # signature .. filename+extra length fields, before the variable-length names
ZIP64_EXTRA_ID = 0x0001
ZIP32_SENTINEL = 0xFFFFFFFF


def _zip64_sizes_from_extra(extra, need_uncompressed, need_compressed):
    """Parse the ZIP64 extended-information extra field (id 0x0001) out of a
    local-header extra field blob and return (uncompressed_size, compressed_size)
    for whichever of the two were escaped (0xFFFFFFFF) in the 32-bit header --
    those are the only fields present in a *local* header's zip64 record, in
    that fixed order (relative_header_offset/disk_start_number are
    central-directory-only). Raises if the record isn't found or is too short
    for what's needed."""
    i = 0
    while i + 4 <= len(extra):
        hid, hsize = struct.unpack_from("<HH", extra, i)
        if hid == ZIP64_EXTRA_ID:
            body = extra[i + 4:i + 4 + hsize]
            pos = 0
            uncompressed = compressed = None
            if need_uncompressed:
                uncompressed = struct.unpack_from("<Q", body, pos)[0]
                pos += 8
            if need_compressed:
                compressed = struct.unpack_from("<Q", body, pos)[0]
                pos += 8
            return uncompressed, compressed
        i += 4 + hsize
    raise ValueError("32-bit size field was the ZIP64 sentinel (0xFFFFFFFF) but no ZIP64 "
                      "extra record (id 0x0001) was found in the local header")


def _find_local_header_data_offset(raw, header_offset, entry_name):
    """Return (data_offset, data_size) for the STORED entry at header_offset.

    Fails closed (raises ValueError) if the signature doesn't match, the
    filename doesn't match what the central directory claims, or the entry
    is compressed -- this method only supports ZIP_STORED entries, since it
    patches bytes in place without recompressing. Handles the ZIP64
    extra-field escaping that real .vmfb files from this repo's iree-compile
    actually use (32-bit size fields set to 0xFFFFFFFF, real size in a ZIP64
    extra record) -- confirmed present in every stored .vmfb this module was
    tested against (see module docstring).
    """
    if raw[header_offset:header_offset + 4] != LOCAL_HEADER_SIGNATURE:
        raise ValueError(f"not a local file header at offset {header_offset} (corrupt/unsupported zip layout)")
    compress_method = struct.unpack_from("<H", raw, header_offset + 8)[0]
    if compress_method != 0:
        raise ValueError(f"entry {entry_name!r} is compressed (method {compress_method}); "
                          "in-place structural corruption requires ZIP_STORED")
    comp_size = struct.unpack_from("<I", raw, header_offset + 18)[0]
    name_len = struct.unpack_from("<H", raw, header_offset + 26)[0]
    extra_len = struct.unpack_from("<H", raw, header_offset + 28)[0]
    name = raw[header_offset + LOCAL_HEADER_FIXED_SIZE: header_offset + LOCAL_HEADER_FIXED_SIZE + name_len]
    if name.decode("utf-8", "replace") != entry_name:
        raise ValueError(f"local header at {header_offset} names {name!r}, expected {entry_name!r}")
    extra = raw[header_offset + LOCAL_HEADER_FIXED_SIZE + name_len:
                header_offset + LOCAL_HEADER_FIXED_SIZE + name_len + extra_len]
    if comp_size == ZIP32_SENTINEL:
        uncomp_size = struct.unpack_from("<I", raw, header_offset + 22)[0]
        _, comp_size = _zip64_sizes_from_extra(extra, need_uncompressed=(uncomp_size == ZIP32_SENTINEL),
                                                need_compressed=True)
    data_offset = header_offset + LOCAL_HEADER_FIXED_SIZE + name_len + extra_len
    return data_offset, comp_size


def _patch_crc32(raw, header_offset, new_crc, is_central_directory=False):
    off = header_offset + (16 if is_central_directory else 14)
    struct.pack_into("<I", raw, off, new_crc)


def corrupt_flip(in_path, out_path, offset=4096):
    """A5a: single-byte XOR at a raw file offset. No structural awareness --
    this is the deliberately-naive corruption the artifact-hash gate (byte
    sha256 comparison, run before any IREE call) must catch regardless of
    where it lands."""
    data = bytearray(open(in_path, "rb").read())
    if not (0 <= offset < len(data)):
        raise ValueError(f"flip offset {offset} out of range for {in_path} ({len(data)} bytes)")
    data[offset] ^= 0xFF
    open(out_path, "wb").write(bytes(data))
    return _describe(out_path)


def corrupt_flatbuffer_root_uoffset(in_path, out_path, entry_name="module.fb"):
    """A5b: overwrite the 4-byte FlatBuffer length prefix at the start of the
    named ZIP-STORED entry with 0xFFFFFFFF, updating the CRC32 in both the
    local file header and the matching central-directory record so the
    result is still a structurally valid ZIP (only the flatbuffer content is
    corrupted, not the container). Fails closed (raises) if the entry isn't
    found or isn't stored uncompressed."""
    zf = zipfile.ZipFile(in_path)
    try:
        zinfo = zf.getinfo(entry_name)
    except KeyError:
        raise ValueError(f"{in_path} has no entry named {entry_name!r}")
    raw = bytearray(open(in_path, "rb").read())
    data_offset, data_size = _find_local_header_data_offset(raw, zinfo.header_offset, entry_name)
    if data_size < 4:
        raise ValueError(f"entry {entry_name!r} is only {data_size} bytes, too small for a length prefix")
    original_prefix = struct.unpack_from("<I", raw, data_offset)[0]
    if original_prefix != data_size:
        raise ValueError(f"entry {entry_name!r} length prefix ({original_prefix}) != entry size ({data_size}); "
                          "this .vmfb does not match the length-prefixed FlatBuffer layout this method assumes")
    struct.pack_into("<I", raw, data_offset, 0xFFFFFFFF)
    new_data = bytes(raw[data_offset:data_offset + data_size])
    new_crc = zipfile.crc32(new_data) & 0xFFFFFFFF
    _patch_crc32(raw, zinfo.header_offset, new_crc, is_central_directory=False)
    # Central directory record: find it by matching header_offset + filename (there is exactly one
    # record per entry; re-parsing via zipfile gives us the authoritative header_offset already).
    cd_off = _find_central_directory_record_offset(bytes(raw), zinfo)
    _patch_crc32(raw, cd_off, new_crc, is_central_directory=True)
    open(out_path, "wb").write(bytes(raw))
    # Round-trip sanity check: the corrupted archive must still open as a ZIP (only the flatbuffer
    # PAYLOAD is invalid, not the container) and the entry's bytes must show the intended corruption.
    zf2 = zipfile.ZipFile(out_path)
    got = zf2.read(entry_name)[:4]
    if got != b"\xff\xff\xff\xff":
        raise RuntimeError(f"corruption verification failed: {entry_name} starts with {got!r}, not 0xFFFFFFFF")
    return _describe(out_path)


CENTRAL_DIR_SIGNATURE = b"PK\x01\x02"


def _find_central_directory_record_offset(raw, zinfo):
    """Locate the central-directory record for zinfo.filename. Matched by name
    only (not by header_offset): the central directory's 32-bit header_offset
    field is itself ZIP64-escaped (0xFFFFFFFF) whenever the entry's size
    fields are escaped -- confirmed present in every real .vmfb this module
    was tested against (see module docstring) -- so comparing it directly
    against zinfo.header_offset (which zipfile already resolved from the
    ZIP64 extra record) would never match. Name-uniqueness within one .vmfb
    (module.fb / _const.bin / one embedded .so) makes this unambiguous."""
    idx = 0
    matches = []
    while True:
        idx = raw.find(CENTRAL_DIR_SIGNATURE, idx)
        if idx == -1:
            break
        name_len = struct.unpack_from("<H", raw, idx + 28)[0]
        extra_len = struct.unpack_from("<H", raw, idx + 30)[0]
        comment_len = struct.unpack_from("<H", raw, idx + 32)[0]
        name = raw[idx + 46: idx + 46 + name_len].decode("utf-8", "replace")
        if name == zinfo.filename:
            matches.append(idx)
        idx += 46 + name_len + extra_len + comment_len
    if not matches:
        raise ValueError(f"central directory record for {zinfo.filename!r} not found")
    if len(matches) > 1:
        raise ValueError(f"{len(matches)} central directory records named {zinfo.filename!r}; "
                          "this method assumes unique entry names")
    return matches[0]


def _describe(path):
    data = open(path, "rb").read()
    return {"file": path, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def make_corrupted_contract(contract_path, corrupted_describe, corrupted_filename):
    """Return a copy of the contract at contract_path with artifact.file/sha256/bytes
    replaced by the corrupted file's real values (everything else -- bounded_bytes,
    kernel stack accounting, ABI -- is untouched, since A5b's whole point is that the
    CONTRACT still matches this corrupted file's hash; only the FlatBuffer content
    inside it is invalid)."""
    c = json.load(open(contract_path))
    c["artifact"]["file"] = corrupted_filename
    c["artifact"]["sha256"] = corrupted_describe["sha256"]
    c["artifact"]["bytes"] = corrupted_describe["bytes"]
    c.setdefault("provenance", {}).setdefault("notes", []).append(
        "artifact.sha256/bytes replaced by harness/corrupt_vmfb.py (A5b structural corruption scenario); "
        "this is NOT a make_contract.py output and must never be used outside a corruption negative scenario")
    return c


METHODS = {
    "flip": corrupt_flip,
    "flatbuffer_root_uoffset": corrupt_flatbuffer_root_uoffset,
}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--method", required=True, choices=sorted(METHODS), help="fails closed: no default")
    ap.add_argument("--in", dest="in_path", required=True)
    ap.add_argument("--out", dest="out_path", required=True)
    ap.add_argument("--offset", type=int, default=4096, help="byte offset for --method flip")
    ap.add_argument("--entry", default="module.fb", help="ZIP entry name for --method flatbuffer_root_uoffset")
    ap.add_argument("--contract", help="original contract JSON to derive a corrupted-hash contract from")
    ap.add_argument("--contract-out", help="where to write the corrupted-hash contract (requires --contract)")
    a = ap.parse_args()
    if a.method == "flip":
        desc = corrupt_flip(a.in_path, a.out_path, a.offset)
    else:
        desc = corrupt_flatbuffer_root_uoffset(a.in_path, a.out_path, a.entry)
    print(json.dumps(desc))
    if a.contract:
        if not a.contract_out:
            print("error: --contract requires --contract-out", file=sys.stderr)
            sys.exit(2)
        cc = make_corrupted_contract(a.contract, desc, a.out_path.split("/")[-1])
        json.dump(cc, open(a.contract_out, "w"), indent=1)


if __name__ == "__main__":
    main()
