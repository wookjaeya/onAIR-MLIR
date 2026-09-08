#!/usr/bin/env python3
"""cfs_cmd.py -- dependency-free cFE 7.x ground-command sender for the CI_LAB app.

Sends CCSDS/cFE command packets over UDP to CI_LAB (default 127.0.0.1:1234).
Intended for the E14 A7 scenarios (app restart / delete) where the guest has
no cFS-GroundSystem.  Python 3 stdlib only.

Every constant below was read from the nasa/cFS bundle checked out at
/home/user/onair-ext/cFS (nasa/cFS 78c23b0, submodules on dev) and matches what
the native_std build actually compiled (build-native_std generated headers).

  Message-ID scheme (MsgId v1, primary-header-only):
    build-native_std/inc/cfe_msg_hdr.h  -> cfe/modules/msg/option_inc/default_cfe_msg_hdr_pri.h
    build-native_std/inc/cfe_msg_sechdr.h -> cfe/modules/msg/option_inc/default_cfe_msg_sechdr.h
    libmsg.a members: cfe_msg_initdefaulthdr_pri.c.o + cfe_msg_msgid_v1.c.o (no ccsdsext)
    cfe/modules/msg/fsw/src/cfe_msg_msgid_v1.c:  MsgId value == 16-bit StreamId word
    cfe/modules/core_api/config/default_cfe_core_api_msgid_mapping.h:49
        CFE_PLATFORM_CMD_TOPICID_TO_MIDV(topic) = CFE_PLATFORM_BASE_MIDVAL(CMD) | topic
    sample_defs/cpu1/cfe_core_api_base_msgid_values.h:32
        CFE_PLATFORM_BASE_MIDVAL(x) = SAMPLE_CPU1_##x##_MID_BASE
    sample_defs/inc/global_core_api_base_msgid_values.h:30  SAMPLE_CPU1_CMD_MID_BASE 0x1800
  Topic IDs:
    cfe/modules/es/fsw/inc/cfe_es_topicids.h:38        DEFAULT_CFE_MISSION_ES_CMD_TOPICID     6
    cfe/modules/evs/fsw/inc/cfe_evs_topicids.h:38      DEFAULT_CFE_MISSION_EVS_CMD_TOPICID    1
    apps/sample_app/fsw/inc/sample_app_topicids.h:29   DEFAULT_SAMPLE_APP_MISSION_CMD_TOPICID 0x82
    apps/ci_lab/fsw/inc/ci_lab_topicids.h:29           DEFAULT_CI_LAB_MISSION_CMD_TOPICID     0x84
  ES function codes:
    cfe/modules/es/config/default_cfe_es_fcncode_values.h:39-47
  Payload layouts:
    cfe/modules/es/config/default_cfe_es_msgdefs.h:107-124 (AppNameCmd, AppReloadCmd)
    cfe/modules/core_api/fsw/inc/cfe_core_api_interface_cfg.h:113  MAX_API_LEN 20, :58 MAX_PATH_LEN 64
  Header layout (CCSDS v1 primary, big-endian, 6 bytes):
    cfe/modules/msg/fsw/inc/ccsds_hdr.h  StreamId[2] Sequence[2] Length[2]
    cfe/modules/msg/fsw/src/cfe_msg_ccsdspri.c:30  CFE_MSG_SIZE_OFFSET 7 (Length = total - 7)
    cfe/modules/msg/fsw/src/cfe_msg_ccsdspri.c:33-41 TYPE 0x1000, SHDR 0x0800, SEGFLG 0xC000, SEQ 0x3FFF
  Command secondary header (2 bytes): FunctionCode then Checksum
    cfe/modules/msg/option_inc/default_cfe_msg_sechdr.h  (struct order confirmed)
  Checksum:
    cfe/modules/msg/fsw/src/cfe_msg_sechdr_checksum.c  ComputeCheckSum: 0xFF ^ XOR(all bytes);
    GenerateChecksum zeroes the field first; ValidateChecksum requires ComputeCheckSum()==0,
    i.e. XOR over the whole packet including the checksum byte == 0xFF.
  CI_LAB UDP port:
    apps/ci_lab/fsw/inc/ci_lab_interface_cfg.h:51   DEFAULT_CI_LAB_MISSION_BASE_UDP_PORT 1234
    apps/ci_lab/fsw/src/ci_lab_app.c:168            port = BASE + CFE_PSP_GetProcessorId() - 1  (cpu1 -> 1234)
  Verification performed by the flight side:
    apps/ci_lab/fsw/src/ci_lab_passthru_decode.c:82-100  size >= sizeof(CommandHeader) and hdr len <= datagram
    apps/ci_lab/fsw/src/ci_lab_app.c:267   CFE_SB_TransmitBuffer(buf, false) -> no OriginationAction
    cfe/modules/msg/fsw/src/cfe_msg_integrity.c  VerificationAction accepts everything
    cfe/modules/es/fsw/src/cfe_es_dispatch.c:44-73  ES checks only exact length (VerifyCmdLength);
    ES never calls CFE_MSG_ValidateChecksum.  We still emit a correct checksum.

Timing note (observed on the native_std build, 2026-09-08): RESTART_APP / STOP_APP are only
*initiated* by the ES command handler; the ES background task completes them on its
app-scan cadence, ~6 s later ("Restart Application X Initiated" -> "... Success, AppID=").
A second app-control command sent within that window is rejected with
"Cannot Delete Application X, It is not running." -- wait >= 8 s between such commands.
QUERY_ONE reports success only as a DEBUG event (not printed by default); its failure
("GetAppIDByName Failed, RC = 0xC4000002") is an ERROR event and does appear.

Usage:
  python3 harness/cfs_cmd.py [--host H] [--port P] [--seq N] [--dry-run] SUBCMD ...
    es-noop | es-reset-counters | es-restart-app NAME | es-delete-app NAME |
    es-reload-app NAME FILE | es-query-app NAME | es-query-all [FILE] |
    raw MID FC [HEX_PAYLOAD] | selftest
  Importable: build_cmd(mid, fc, payload: bytes, seq=0) -> bytes
"""
import argparse
import socket
import sys

# --- message IDs -----------------------------------------------------------
CFE_PLATFORM_CMD_MID_BASE = 0x1800  # SAMPLE_CPU1_CMD_MID_BASE (cmd bit 0x1000 | sec-hdr bit 0x0800)
CFE_MISSION_ES_CMD_TOPICID = 6
CFE_MISSION_EVS_CMD_TOPICID = 1
SAMPLE_APP_MISSION_CMD_TOPICID = 0x82
CI_LAB_MISSION_CMD_TOPICID = 0x84

CFE_ES_CMD_MID = CFE_PLATFORM_CMD_MID_BASE | CFE_MISSION_ES_CMD_TOPICID          # 0x1806
CFE_EVS_CMD_MID = CFE_PLATFORM_CMD_MID_BASE | CFE_MISSION_EVS_CMD_TOPICID        # 0x1801
SAMPLE_APP_CMD_MID = CFE_PLATFORM_CMD_MID_BASE | SAMPLE_APP_MISSION_CMD_TOPICID  # 0x1882
CI_LAB_CMD_MID = CFE_PLATFORM_CMD_MID_BASE | CI_LAB_MISSION_CMD_TOPICID          # 0x1884

# --- ES function codes (default_cfe_es_fcncode_values.h) --------------------
CFE_ES_NOOP_CC = 0
CFE_ES_RESET_COUNTERS_CC = 1
CFE_ES_RESTART_CC = 2
CFE_ES_START_APP_CC = 4
CFE_ES_STOP_APP_CC = 5      # "delete app"
CFE_ES_RESTART_APP_CC = 6
CFE_ES_RELOAD_APP_CC = 7
CFE_ES_QUERY_ONE_CC = 8
CFE_ES_QUERY_ALL_CC = 9

# --- sizes -------------------------------------------------------------------
CFE_MISSION_MAX_API_LEN = 20
CFE_MISSION_MAX_PATH_LEN = 64
CCSDS_PRI_HDR_LEN = 6
CFE_CMD_SEC_HDR_LEN = 2      # FunctionCode, Checksum
CFE_CMD_HDR_LEN = CCSDS_PRI_HDR_LEN + CFE_CMD_SEC_HDR_LEN  # sizeof(CFE_MSG_CommandHeader_t) == 8
CFE_MSG_SIZE_OFFSET = 7
CFE_MSG_SEGFLG_UNSEGMENTED = 0xC000
CFE_MSG_SEQCNT_MASK = 0x3FFF
CFE_MSG_TYPE_MASK = 0x1000
CFE_MSG_SHDR_MASK = 0x0800

CI_LAB_DEFAULT_PORT = 1234


def compute_checksum(packet: bytes) -> int:
    """CFE_MSG_ComputeCheckSum: 0xFF XOR every byte of the packet."""
    c = 0xFF
    for b in packet:
        c ^= b
    return c


def build_cmd(mid: int, fc: int, payload: bytes = b"", seq: int = 0) -> bytes:
    """Build a cFE command packet (CCSDS v1 primary + cFE command secondary header).

    mid     full message-id value (e.g. 0x1806); bits 0x1000 (cmd) and 0x0800 (sec hdr) are
            expected to be already set -- they are OR-ed in defensively so a bare topic works too.
    fc      function code (0..127)
    payload raw payload bytes appended after the 8-byte command header
    seq     14-bit sequence count
    """
    if not (0 <= fc <= 0x7F):
        raise ValueError("function code must be 0..127")
    if not (0 <= mid <= 0xFFFF):
        raise ValueError("mid must fit in 16 bits")
    stream_id = (mid | CFE_MSG_TYPE_MASK | CFE_MSG_SHDR_MASK) & 0xFFFF
    total = CFE_CMD_HDR_LEN + len(payload)
    if total - CFE_MSG_SIZE_OFFSET > 0xFFFF:
        raise ValueError("packet too large")
    sequence = CFE_MSG_SEGFLG_UNSEGMENTED | (seq & CFE_MSG_SEQCNT_MASK)
    length = total - CFE_MSG_SIZE_OFFSET
    hdr = bytes([
        (stream_id >> 8) & 0xFF, stream_id & 0xFF,
        (sequence >> 8) & 0xFF, sequence & 0xFF,
        (length >> 8) & 0xFF, length & 0xFF,
        fc & 0x7F,
        0x00,  # checksum placeholder (GenerateChecksum zeroes it before computing)
    ])
    pkt = hdr + bytes(payload)
    cks = compute_checksum(pkt)
    pkt = pkt[:7] + bytes([cks]) + pkt[8:]
    assert compute_checksum(pkt) == 0, "checksum self-check failed"
    return pkt


def _fixed_str(s: str, n: int, what: str) -> bytes:
    b = s.encode("ascii")
    if len(b) > n:
        raise ValueError("%s longer than %d bytes: %r" % (what, n, s))
    return b.ljust(n, b"\0")


def app_name_payload(name: str) -> bytes:
    """CFE_ES_AppNameCmd_Payload_t: char Application[CFE_MISSION_MAX_API_LEN]"""
    return _fixed_str(name, CFE_MISSION_MAX_API_LEN, "app name")


def app_reload_payload(name: str, filename: str) -> bytes:
    """CFE_ES_AppReloadCmd_Payload_t: Application[20] + AppFileName[64]"""
    return app_name_payload(name) + _fixed_str(filename, CFE_MISSION_MAX_PATH_LEN, "file name")


def query_all_payload(filename: str) -> bytes:
    """CFE_ES_FileNameCmd_Payload_t: char FileName[CFE_MISSION_MAX_PATH_LEN]"""
    return _fixed_str(filename, CFE_MISSION_MAX_PATH_LEN, "file name")


# expected sizeof(CFE_ES_*Cmd_t) with the primary-only header (8 bytes, no padding)
EXPECTED_SIZES = {
    "es-noop": 8,
    "es-reset-counters": 8,
    "es-restart-app": 28,
    "es-delete-app": 28,
    "es-query-app": 28,
    "es-reload-app": 92,
    "es-query-all": 72,
}


def make_packet(args) -> bytes:
    sub = args.subcmd
    if sub == "es-noop":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_NOOP_CC, b"", args.seq)
    if sub == "es-reset-counters":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_RESET_COUNTERS_CC, b"", args.seq)
    if sub == "es-restart-app":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_RESTART_APP_CC, app_name_payload(args.name), args.seq)
    if sub == "es-delete-app":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_STOP_APP_CC, app_name_payload(args.name), args.seq)
    if sub == "es-query-app":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_QUERY_ONE_CC, app_name_payload(args.name), args.seq)
    if sub == "es-reload-app":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_RELOAD_APP_CC, app_reload_payload(args.name, args.file), args.seq)
    if sub == "es-query-all":
        return build_cmd(CFE_ES_CMD_MID, CFE_ES_QUERY_ALL_CC, query_all_payload(args.file), args.seq)
    if sub == "raw":
        payload = bytes.fromhex(args.hex_payload) if args.hex_payload else b""
        return build_cmd(int(args.mid, 0), int(args.fc, 0), payload, args.seq)
    raise ValueError("unknown subcommand %s" % sub)


def selftest() -> int:
    ok = True
    p = build_cmd(CFE_ES_CMD_MID, CFE_ES_NOOP_CC)
    checks = [
        # 0xFF ^ 0x18 ^ 0x06 ^ 0xC0 ^ 0x00 ^ 0x00 ^ 0x01 ^ 0x00 = 0x20
        ("noop hex", p.hex(), "1806c00000010020"),
        ("ES MID", "0x%04x" % CFE_ES_CMD_MID, "0x1806"),
        ("EVS MID", "0x%04x" % CFE_EVS_CMD_MID, "0x1801"),
        ("SAMPLE_APP MID", "0x%04x" % SAMPLE_APP_CMD_MID, "0x1882"),
        ("CI_LAB MID", "0x%04x" % CI_LAB_CMD_MID, "0x1884"),
        ("restart-app len", len(build_cmd(CFE_ES_CMD_MID, CFE_ES_RESTART_APP_CC, app_name_payload("SAMPLE_APP"))), 28),
        ("reload-app len", len(build_cmd(CFE_ES_CMD_MID, CFE_ES_RELOAD_APP_CC, app_reload_payload("A", "/cf/a.so"))), 92),
        ("query-all len", len(build_cmd(CFE_ES_CMD_MID, CFE_ES_QUERY_ALL_CC, query_all_payload("/cf/x.dat"))), 72),
    ]
    for name, got, want in checks:
        good = got == want
        ok &= good
        print("%-16s %-6s got=%r want=%r" % (name, "OK" if good else "FAIL", got, want))
    # XOR over whole packet incl. checksum must be 0xFF for every packet
    for pk in (p, build_cmd(0x1806, 6, app_name_payload("SAMPLE_APP"), seq=5)):
        x = 0
        for b in pk:
            x ^= b
        good = x == 0xFF
        ok &= good
        print("%-16s %-6s xor=0x%02x" % ("xor==0xFF", "OK" if good else "FAIL", x))
    print("SELFTEST", "PASS" if ok else "FAIL")
    return 0 if ok else 1


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=CI_LAB_DEFAULT_PORT)
    ap.add_argument("--seq", type=int, default=0, help="14-bit CCSDS sequence count")
    ap.add_argument("--dry-run", action="store_true", help="print hex, do not send")
    sp = ap.add_subparsers(dest="subcmd", required=True)
    sp.add_parser("es-noop")
    sp.add_parser("es-reset-counters")
    for n in ("es-restart-app", "es-delete-app", "es-query-app"):
        sp.add_parser(n).add_argument("name")
    r = sp.add_parser("es-reload-app")
    r.add_argument("name")
    r.add_argument("file")
    q = sp.add_parser("es-query-all")
    q.add_argument("file", nargs="?", default="/cf/cfe_es_app_info.log")
    rw = sp.add_parser("raw")
    rw.add_argument("mid", help="message id, e.g. 0x1806")
    rw.add_argument("fc", help="function code")
    rw.add_argument("hex_payload", nargs="?", default="")
    sp.add_parser("selftest")
    args = ap.parse_args(argv)

    if args.subcmd == "selftest":
        return selftest()

    pkt = make_packet(args)
    exp = EXPECTED_SIZES.get(args.subcmd)
    print("%s: mid=0x%04x fc=%d len=%d%s hex=%s" % (
        args.subcmd, (pkt[0] << 8) | pkt[1], pkt[6], len(pkt),
        "" if exp is None else " (expected sizeof %d)" % exp, pkt.hex()))
    if exp is not None and len(pkt) != exp:
        print("ERROR: packet length %d != expected %d" % (len(pkt), exp), file=sys.stderr)
        return 2
    if args.dry_run:
        return 0
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        n = s.sendto(pkt, (args.host, args.port))
    finally:
        s.close()
    print("sent %d bytes to %s:%d" % (n, args.host, args.port))
    return 0


if __name__ == "__main__":
    sys.exit(main())
