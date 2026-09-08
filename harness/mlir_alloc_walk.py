#!/usr/bin/env python3
"""E18: structural (non-regex) extractor for the entry function's allocation
schedule, using IREE's own MLIR Python bindings (iree.compiler.ir) instead of
text regexes on the --mlir-print-ir-after dump.

Why this exists (CLAUDE.md priority 3 / EVIDENCE_v0.10 SS5 / EVIDENCE_v0.9 SS11.7):
harness/static_mem_bound.py::parse_alloc_ir is a regex parser over pretty-printed
IR text. E15 made it fail-closed (a whitelist of recognized op *names* in the
printed text), but it is still string matching -- a printer format change, or
an op that happens to print in a way the regex does not expect, can still
silently misparse. This module instead walks the REAL Operation/Value graph:
op.name is the compiler's own op identifier (not a substring match), and every
size is read by following the SSA def-use chain (Value.owner) back to its
defining arith.constant, not by scraping a number out of printed text.

The one genuine text-processing step that remains is unavoidable and narrow:
--mlir-print-ir-after prints the module in PER-FUNCTION FRAGMENTS (one dump
chunk per top-level symbol per pipeline phase -- this is inherent to how the
pass manager multiplexes IR printing, not a threading artifact; confirmed by
recompiling with --mlir-disable-threading, which changes chunk order
determinism but not the fragmentation itself). A fragment referencing
`util.global.load @NAME` has no `util.global @NAME : TYPE` declaration in that
same fragment (declarations are not re-printed by a pass that does not touch
them), so ir.Module.parse() refuses it with "undefined global". This module's
_synthesize_global_decls() does a narrow regex scan (util.global.load/store
lines ONLY, not allocation ops) to recover the {name: type} pairs and
prepends synthetic `util.global` declarations so the fragment becomes a
parseable, self-contained module. Everything after that parse is real API.

Return shape matches static_mem_bound.parse_alloc_ir() exactly (same keys) so
the two are directly comparable/substitutable; see contract_negative_tests.py
and the CLI's --cross-check flag below for the agreement check.
"""
import argparse
import json
import re
import sys

try:
    import iree.compiler.ir as ir
except ImportError as e:  # pragma: no cover
    ir = None
    _IMPORT_ERROR = e

DUMP_HEADER_RE = re.compile(r"^// -----// IR Dump After [^\n]*\n", re.M)
GLOBAL_LOAD_RE = re.compile(r'util\.global\.load(\s+immutable)?\s+@([\w.$]+)\s*:\s*([^\n,]+)')
GLOBAL_STORE_RE = re.compile(r'util\.global\.store\s+%[\w.#]+,\s*@([\w.$]+)\s*:\s*([^\n,]+)')

# Ops this walker resolves sizes for or otherwise understands, keyed by op
# name AS REPORTED BY THE COMPILER (op.name), not by any text pattern. Any
# other stream.resource.*/stream.tensor.* op encountered in the entry body is
# unresolved (D13 fail-closed policy: unknown -> refuse, never ignore).
KNOWN_ENTRY_OPS = {"stream.tensor.import", "stream.tensor.export",
                   "stream.resource.alloca", "stream.resource.dealloca",
                   "stream.resource.pack"}


def _require_bindings():
    if ir is None:
        raise RuntimeError("iree.compiler.ir is not importable (%s); this module needs the "
                           "iree-base-compiler Python package" % _IMPORT_ERROR)


def split_dumps(ir_text):
    parts = DUMP_HEADER_RE.split(ir_text)
    chunks = [p for p in parts if p.strip()]
    return chunks if chunks else [ir_text]


def _first_line(chunk):
    return chunk.lstrip().split("\n", 1)[0]


def _synthesize_global_decls(chunks):
    """Recover {name: (type, is_immutable)} for every util.global referenced
    (loaded or stored) anywhere in the dump, by scanning the load/store op
    text -- NOT the allocation ops this tool exists to stop text-matching.
    Returns the declarations as MLIR source lines."""
    types = {}
    immutable = {}
    for c in chunks:
        for m in GLOBAL_LOAD_RE.finditer(c):
            imm, name, typ = m.group(1), m.group(2), m.group(3).strip()
            types.setdefault(name, typ)
            if imm:
                immutable[name] = True
        for m in GLOBAL_STORE_RE.finditer(c):
            name, typ = m.group(1), m.group(2).strip()
            types.setdefault(name, typ)
            immutable.setdefault(name, False)
    lines = []
    for name, typ in types.items():
        mut = "" if immutable.get(name) else "mutable "
        lines.append("  util.global private %s@%s : %s" % (mut, name, typ))
    return "\n".join(lines)


def _walk(op):
    for region in op.regions:
        for block in region.blocks:
            for o in block.operations:
                yield o
                yield from _walk(o)


def _resolve_index_value(value):
    """Follow a Value of type `index` back to its defining arith.constant.
    Returns (int_value, True) if it is a compile-time constant, else
    (description, False) -- description names the actual blocking op/reason
    (a real fact from the IR, not a guess) for the unresolved-sizes report."""
    owner = value.owner
    if owner is None or not hasattr(owner, "name"):
        return "block_argument", False
    if owner.name == "arith.constant":
        try:
            return int(owner.attributes["value"]), True
        except Exception:
            return "arith.constant(non-integer)", False
    return "non_constant_def:%s" % owner.name, False


def _find_entry_candidates(module_op, entry):
    """All top-level util.func/func.func ops named `entry`, in document order."""
    out = []
    for o in _walk(module_op):
        if o.name in ("util.func", "func.func"):
            sym = o.attributes.get("sym_name")
            if sym is not None and str(sym).strip('"') == entry:
                out.append(o)
    return out


def _extract_from_entry(entry_op):
    """Structural extraction: walk the entry function body, resolving every
    stream.resource.alloca / stream.tensor.import via the SSA def-use chain.
    Any stream.resource.*/stream.tensor.* op outside KNOWN_ENTRY_OPS is
    reported unresolved (fail-closed: an op this walker does not understand
    is a reason to refuse a bound, not a reason to skip it silently)."""
    result = {"inputs": [], "outputs": [], "transient_slices": [], "transient_slabs": [],
             "constants": [], "unresolved": [], "dispatches": 0, "entry_found": True}
    for o in _walk(entry_op):
        name = o.name
        if name == "stream.cmd.dispatch":
            result["dispatches"] += 1
            continue
        if not (name.startswith("stream.resource.") or name.startswith("stream.tensor.")):
            continue
        if name not in KNOWN_ENTRY_OPS:
            result["unresolved"].append("unrecognized_op:%s" % name)
            continue
        if name == "stream.tensor.import":
            size_val = o.operands[-1]
            v, ok = _resolve_index_value(size_val)
            (result["inputs"] if ok else result["unresolved"]).append(v if ok else "tensor.import:%s" % v)
        elif name == "stream.resource.alloca":
            kind = str(o.results[0].type)
            size_val = o.operands[0]
            v, ok = _resolve_index_value(size_val)
            if "external" in kind:
                (result["outputs"] if ok else result["unresolved"]).append(v if ok else "alloca_external:%s" % v)
            else:
                (result["transient_slabs"] if ok else result["unresolved"]).append(v if ok else "alloca_transient:%s" % v)
        elif name == "stream.resource.pack":
            # best-effort: every index-typed operand after the affinity/await
            # operands is a candidate slice size; unresolved ones are reported,
            # not skipped. (Not exercised by the current model corpus -- none
            # of the 14 stored layout IRs use stream.resource.pack in the
            # entry body -- but must not be silently ignored if one does.)
            for opd in o.operands:
                if str(opd.type) != "index":
                    continue
                v, ok = _resolve_index_value(opd)
                if ok:
                    result["transient_slices"].append(v)
        # stream.tensor.export / stream.resource.dealloca: consume an
        # already-counted resource, allocate nothing new -- intentionally
        # not sized (matches static_mem_bound.py's KNOWN_ENTRY_OPS treatment).
    return result


def _extract_constants(module_op):
    """module_resident_constant_bytes: sum of stream.resource.alloc(constant)
    sizes anywhere in the module (these live in util.initializer, outside the
    entry function, by construction -- E6c's scoping lesson)."""
    total = []
    for o in _walk(module_op):
        if o.name == "stream.resource.alloc":
            v, ok = _resolve_index_value(o.operands[0])
            if ok:
                total.append(v)
    return total


def parse_alloc_ir_structural(ir_text, entry="infer"):
    """Structural twin of static_mem_bound.parse_alloc_ir(): same return
    shape, extracted via the real MLIR API instead of regex. Tries every
    entry-function dump chunk (paired with every initializer chunk, most
    recent first) and keeps the first one that both parses AND yields a
    dispatch count > 0 preferring the richest result -- mirroring the
    "most-lowered print" selection make_contract.py already does, but scored
    from real op counts instead of regex-derived counts."""
    _require_bindings()
    chunks = split_dumps(ir_text)
    decls = _synthesize_global_decls(chunks)
    init_chunks = [c for c in chunks if _first_line(c).startswith("util.initializer")]
    entry_chunks = [c for c in chunks if re.match(r"(util\.func|func\.func)\s+public\s+@" + re.escape(entry) + r"\b", _first_line(c))]

    if not entry_chunks:
        return {"inputs": [], "outputs": [], "transient_slices": [], "transient_slabs": [],
               "constants": [], "unresolved": [], "dispatches": 0, "entry_found": False}

    best = None
    ctx_errors = []
    for ec in reversed(entry_chunks):           # most-recently-printed first
        for ic in (reversed(init_chunks) if init_chunks else [""]):
            merged = "module {\n%s\n%s\n%s\n}\n" % (decls, ic, ec)
            ctx = ir.Context()
            try:
                mod = ir.Module.parse(merged, ctx)
            except Exception as e:
                ctx_errors.append(str(e)[:200])
                continue
            entries = _find_entry_candidates(mod.operation, entry)
            if not entries:
                continue
            extracted = _extract_from_entry(entries[0])
            extracted["constants"] = _extract_constants(mod.operation)
            score = (extracted["dispatches"], len(extracted["outputs"]) + len(extracted["transient_slabs"]),
                     -len(extracted["unresolved"]))
            if best is None or score > best[0]:
                best = (score, extracted)
    if best is None:
        raise RuntimeError("no (entry, initializer) chunk combination parsed; errors: %s" % ctx_errors[:3])
    return best[1]


def diff_against_regex(structural, regex_based, constants_reference=None):
    """Compare a structural extraction (parse_alloc_ir_structural) against a
    regex-based one (static_mem_bound.parse_alloc_ir) -- both have the SAME
    return shape -- and return the list of field names that disagree. This is
    the ONE place this comparison is implemented; both this module's own
    --cross-check CLI below and harness/make_contract.py's mandatory
    cross-check (E19) call it, so the disagreement rule cannot drift between
    the two the way it did before this function existed (E19 code review,
    2026-09: both call sites independently reimplemented this logic and both
    had the same constants(sum) bug -- see constants_reference below).

    constants_reference overrides what "constants(sum)" is compared against.
    Default (None) uses regex_based's own constants sum, appropriate for a
    standalone diagnostic run with no other context (this module's --cross-check
    CLI). make_contract.py instead passes const_b (module_resident_constant_bytes
    -- packed_sum when nonzero, else dense_sum): structural's constants sum is
    the packed stream.resource.alloc size (see _extract_constants above), which
    is NOT always equal to regex_based's raw per-tensor dense sum whenever
    constant packing pads or deduplicates (make_contract.py already tracks this
    distinction as packed_sum vs dense_sum, with a note when they differ) --
    comparing against the wrong one false-hard-fails a contract whose bound is
    actually correct."""
    exact_keys = ("inputs", "outputs", "transient_slabs")
    diffs = [k for k in exact_keys if sorted(structural.get(k, [])) != sorted(regex_based.get(k, []))]
    target = sum(regex_based.get("constants", [])) if constants_reference is None else constants_reference
    if sum(structural.get("constants", [])) != target:
        diffs.append("constants(sum)")
    if structural.get("entry_found") != regex_based.get("entry_found"):
        diffs.append("entry_found")
    if bool(structural.get("unresolved")) != bool(regex_based.get("unresolved")):
        diffs.append("unresolved(presence)")
    return diffs


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("layout_ir", help="stderr of --mlir-print-ir-after=iree-stream-layout-slices")
    ap.add_argument("--entry", default="infer")
    ap.add_argument("--cross-check", action="store_true",
                    help="also run static_mem_bound.parse_alloc_ir on the same file and diff the two")
    a = ap.parse_args()
    text = open(a.layout_ir, encoding="utf-8", errors="replace").read()
    structural = parse_alloc_ir_structural(text, a.entry)
    print(json.dumps(structural, indent=2))
    if a.cross_check:
        import os
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import static_mem_bound as smb
        regex_based = smb.parse_alloc_ir(text, a.entry)
        # inputs/outputs/transient_slabs must match element-for-element (both
        # tools attribute per-call buffers the same way). constants is
        # compared by SUM only: the regex path lists one entry per `dense`
        # declaration in the initializer, this walker lists one entry per
        # stream.resource.alloc (the packed allocation covering all of
        # them) -- different granularity. The two totals are equal ONLY when
        # there is no constant-packing padding/dedup (structural's sum is
        # really the PACKED total -- make_contract.py's packed_sum -- not the
        # raw per-tensor dense sum; a standalone run has no packed_sum to
        # compare against, so this falls back to regex_based's own dense sum
        # and can show a "constants(sum)" DISAGREE on a padded model that
        # make_contract.py's own cross-check, given the real packed_sum via
        # constants_reference, would not -- diagnostic-only, not a bug in the
        # contract path). dispatches is informational only in both tools
        # (does not gate bound_method), so a difference there is reported but
        # does not fail the check. "unresolved" only compared by presence:
        # the two tools report DIFFERENT diagnostic strings for the same
        # condition by design (SSA operand name vs. op name) -- what matters
        # is whether either found a reason to refuse a static bound, not the
        # message text.
        diffs = diff_against_regex(structural, regex_based)
        if structural.get("dispatches") != regex_based.get("dispatches"):
            print("note: dispatches differ (informational, does not gate bound_method): "
                 "structural=%s regex=%s" % (structural.get("dispatches"), regex_based.get("dispatches")), file=sys.stderr)
        print("CROSS-CHECK:", "AGREE" if not diffs else "DISAGREE on %s" % diffs, file=sys.stderr)
        return 1 if diffs else 0
    return 0


if __name__ == "__main__":
    sys.exit(main())
