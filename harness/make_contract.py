#!/usr/bin/env python3
"""harness/make_contract.py -- build a deployment contract JSON from the SAVED
outputs of ONE iree-compile invocation (one-invocation rule, EVIDENCE_v0.7 SS1.3).

The invocation must have been of the form

  iree-compile M.mlir --iree-hal-target-backends=llvm-cpu \
      --iree-llvmcpu-target-triple=T --iree-llvmcpu-target-cpu=C \
      --mlir-print-ir-after=iree-stream-layout-slices \
      --iree-hal-dump-executable-files-to=D \
      -o V.vmfb 2> IR.txt

and this script is then given M, V, IR.txt and D (plus, optionally, the JSON
that harness/elf_stack_frame.py produced from the ELF in D).  It NEVER runs
iree-compile itself: every number it writes is parsed from files that the same
command line left behind, so the contract describes the very bytes in V.

What is parsed from where
-------------------------
  static_mem_bound.parse_alloc_ir(IR)  per-call inputs / outputs / transient
                                       slabs / dispatches of the entry function,
                                       module-resident constants
  static_mem_bound.entry_arg_shapes(M) entry input shapes (source signature)
  entry_result_shapes(M)               entry output shapes (source signature;
                                       added here, same style)
  IR  iree.abi.declaration             the compiler's own view of the entry
                                       signature (cross-check of the source)
  iree-dump-module V                   .rodata segments (independent check of the
                                       constant total), executable format string,
                                       VM bytecode size
  D/*.codegen.ll, D/*.so               target triple of the generated code, ELF
                                       bytes/sha256 (must equal the ELF embedded
                                       in V)
  --elf-analysis JSON                  kernel stack frame / call / alloca facts
  mlir_alloc_walk.parse_alloc_ir_structural(IR)
                                       E19: a SECOND, independent reader of the
                                       same layout IR, via IREE's own MLIR
                                       Python API (iree.compiler.ir) instead of
                                       regex (EVIDENCE_v0.13/E18). Used as a
                                       MANDATORY cross-check against
                                       static_mem_bound.parse_alloc_ir: if it
                                       disagrees or cannot parse the IR, the
                                       contract is refused (see
                                       --allow-structural-mismatch); if the
                                       package is not installed at all, the
                                       contract is ALSO refused by default
                                       (F3, external review 2026-09 -- a
                                       missing checker is not a passing one;
                                       see --allow-missing-structural-checker
                                       for the explicit opt-out).

Caveat recorded in provenance (found while writing this): with the default
multi-threaded pass manager, --mlir-print-ir-after prints EVERY function
separately and TWICE (the pass runs in two pipeline phases), in an order that
depends on thread scheduling.  The two prints of the entry function are at
different lowering states (the first has no stream.resource.alloca yet).  This
script therefore parses every print of the entry function and uses the most
lowered one, instead of trusting "the last one in the file".  The sha256 of the
printed IR is consequently NOT reproducible across invocations unless
--mlir-disable-threading is passed; the vmfb, the ELF and the numbers are.

Exit codes: 0 ok; 2 input problem; 3 contract written but schema validation failed.
"""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
import static_mem_bound as smb  # noqa: E402  (parse_alloc_ir, entry_arg_shapes, artifact_rodata_segments)
try:
    import elf_stack_frame as esf  # noqa: E402  optional: locate ELFs inside the vmfb
except Exception:  # pragma: no cover
    esf = None
try:
    import mlir_alloc_walk as maw  # noqa: E402  optional: structural (iree.compiler.ir) cross-check, E19
except Exception:  # pragma: no cover
    maw = None

MEMORY_BOUNDARY = "per_call_plus_module_constants"
BOUND_METHOD_STATIC = "static_from_stream_layout"
BOUND_METHOD_NONE = "NONE"
BINDING_RULE = ("the gate must hash the exact bytes handed to the IREE session and compare "
                "with artifact.sha256 before any runtime allocation")
DUMP_HEADER_RE = re.compile(r"^// -----// IR Dump After [^\n]*\n", re.M)
TENSOR_RE = re.compile(r"tensor<((?:[0-9?]+x)*)([a-z]+[0-9]*)>")


# ----------------------------------------------------------------------------
# small helpers
# ----------------------------------------------------------------------------
def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def read_text(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


def tensors_in(text):
    """All `tensor<AxBx..xdtype>` types in `text`, in order."""
    out = []
    for m in TENSOR_RE.finditer(text):
        dims = [d for d in m.group(1).split("x") if d]
        out.append({"shape": [None if d == "?" else int(d) for d in dims],
                    "dtype": m.group(2),
                    "static": all(d != "?" for d in dims)})
    return out


def _balanced_paren(text, start):
    """text[start] == '(' -> index just past the matching ')' (or -1)."""
    depth = 0
    for i in range(start, len(text)):
        c = text[i]
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                return i + 1
    return -1


def entry_signature(src, entry="infer"):
    """Inputs / outputs of `func.func @entry(...) -> ...` parsed from MLIR source.
    Returns {"inputs": [tensor...], "outputs": [tensor...]} or None."""
    m = re.search(r"func\.func\s+(?:public\s+|private\s+)?@" + re.escape(entry) + r"\s*\(", src)
    if not m:
        return None
    a0 = m.end() - 1
    a1 = _balanced_paren(src, a0)
    if a1 < 0:
        return None
    args = src[a0:a1]
    rest = src[a1:]
    results = ""
    mr = re.match(r"\s*->\s*", rest)
    if mr:
        r2 = rest[mr.end():]
        if r2.startswith("("):
            results = r2[:_balanced_paren(r2, 0)]
        else:
            mt = re.match(r"[^\s{]+", r2)
            results = mt.group(0) if mt else ""
    return {"inputs": tensors_in(args), "outputs": tensors_in(results)}


def entry_result_shapes(mlir_path, entry="infer"):
    """Static result shapes of the entry function, parsed from source -- the
    output-side twin of static_mem_bound.entry_arg_shapes().  None if the entry
    is missing, has no tensor results, or any result dim is dynamic."""
    sig = entry_signature(read_text(mlir_path), entry)
    if not sig or not sig["outputs"]:
        return None
    if not all(t["static"] for t in sig["outputs"]):
        return None
    return [tuple(t["shape"]) for t in sig["outputs"]]


def abi_declaration(ir, entry="infer"):
    """The compiler's `iree.abi.declaration = "sync func @entry(...) -> (...)"`
    reflection string from the layout IR (the same invocation's view of the
    entry signature)."""
    m = re.search(r'iree\.abi\.declaration = "(?:sync|async) func @' + re.escape(entry) + r'\((.*?)\) -> \((.*?)\)"', ir)
    if not m:
        return None
    return {"inputs": tensors_in(m.group(1)), "outputs": tensors_in(m.group(2)),
            "raw": m.group(0)[len('iree.abi.declaration = "'):-1]}


def split_dumps(ir):
    """The printed IR as a list of per-dump chunks (one per `IR Dump After` header)."""
    parts = DUMP_HEADER_RE.split(ir)
    chunks = [p for p in parts if p.strip()]
    return chunks if chunks else [ir]


def parse_entry_prints(ir, entry):
    """Run static_mem_bound.parse_alloc_ir on EVERY print of the entry function."""
    prints = []
    for i, ch in enumerate(split_dumps(ir)):
        first = ch.lstrip().split("\n", 1)[0]
        if re.match(r"(util\.func|func\.func)\s+public\s+@" + re.escape(entry) + r"\b", first):
            p = smb.parse_alloc_ir(ch, entry)
            lowering_score = (p["dispatches"],
                              len(p["outputs"]) + len(p["transient_slabs"]) + len(p["unresolved"]),
                              len(p["inputs"]))
            prints.append({"chunk_index": i, "parsed": p, "lowering_score": lowering_score,
                           "sha256": hashlib.sha256(ch.encode()).hexdigest()})
    return prints


def packed_constant_buffers(ir):
    """Sizes of the packed module-constant buffers (`#util.composite<Nxi8`, i.e.
    what stream.resource.try_map / alloc actually map or allocate), taken from
    the initializer print that carries them.  Per-chunk sums; the max over chunks
    guards against the same initializer being printed twice."""
    best = []
    for ch in split_dumps(ir):
        sizes = [int(n) for n in re.findall(r"#util\.composite<(\d+)xi8", ch)]
        if sum(sizes) > sum(best):
            best = sizes
    return best


SUBSET_SUM_MAX_SEGMENTS = 24


def subset_sum_match(total, segs, max_segments=SUBSET_SUM_MAX_SEGMENTS):
    """True if `total` equals the sum of some non-empty subset of `segs`.

    NOTE (N1, v0.19/E24): this returns a plain False for three different states --
    "enumerated everything and nothing matches" (contradiction), "total <= 0, there
    is nothing to confirm", and "more than max_segments segments, gave up". Callers
    that REFUSE on False must separate them; the N1 gate below does so explicitly.
    Making this function itself tri-state is the cleaner fix and is recorded as out
    of scope in docs/EVIDENCE_v0.19_E24.md §7 (it changes the stored note text of
    the two `dynamic` contracts, so it is a deliberate regeneration, not diff-0).
    """
    if total <= 0 or not segs:
        return False
    segs = list(segs)[:max_segments]
    reach = {0}
    for s in segs:
        reach |= {r + s for r in reach}
    return total in reach


def iree_dump_module(vmfb):
    """`iree-dump-module <vmfb>` -> (stdout, None) or (None, error).

    D25 (E23): the binary being ABSENT (a checkout without iree-base-compiler
    installed) used to raise FileNotFoundError out of this function and kill
    the caller before it could report anything -- the same crash class as D24,
    at a different point, and one a local `sys.meta_path` import block cannot
    reproduce because it only hides the Python module, not the console script.
    Real CI (the without-deps leg of .github/workflows/contract-negative-tests.yml)
    is what caught it. A missing binary is now the same degrade path as a
    failing one: the two fields it feeds (executable_format_in_artifact,
    vm_bytecode_bytes) are informational -- no gate reads them -- and their
    absence is recorded in provenance.notes rather than guessed."""
    try:
        r = subprocess.run(["iree-dump-module", vmfb], capture_output=True, text=True)
    except OSError as e:
        return None, "iree-dump-module not runnable: %s" % e
    if r.returncode != 0:
        return None, r.stderr[-500:]
    return r.stdout, None


def compiler_version():
    """`iree-compile --version` -> (short "IREE <ver> <sha7>", raw first lines, full sha)."""
    try:
        r = subprocess.run(["iree-compile", "--version"], capture_output=True, text=True)
        raw = (r.stdout or "") + (r.stderr or "")
    except OSError as e:
        return None, "iree-compile not runnable: %s" % e, None
    m = re.search(r"IREE compiler version\s+(\S+)\s+@\s+([0-9a-f]+)", raw)
    if not m:
        return None, raw.strip(), None
    return "IREE %s %s" % (m.group(1), m.group(2)[:7]), raw.strip(), m.group(2)


def tensor_json(t):
    return {"shape": list(t["shape"]), "dtype": t["dtype"]}


def sig_equal(a, b):
    return [tensor_json(t) for t in a] == [tensor_json(t) for t in b]


# ----------------------------------------------------------------------------
def build_contract(a, extra_args):
    notes = []
    # D13/EVIDENCE_v0.9 SS11.9, R3 (external review): a mismatch here used to
    # only go into `notes` -- the contract was still written with a bound
    # that assumed the ABI/triple/ELF the reader trusts. Each check below
    # appends to hard_fail_errors UNLESS the caller passed the matching
    # --allow-* escape hatch, and the whole batch is raised together with the
    # one-invocation errors (SS362 below) so a --no-validate run cannot skip it.
    hard_fail_errors = []

    # ---- inputs of the ONE invocation -------------------------------------
    for p in (a.mlir, a.vmfb, a.layout_ir):
        if not os.path.isfile(p):
            raise SystemExit("input file not found: %s" % p)
    if a.dump_dir and not os.path.isdir(a.dump_dir):
        raise SystemExit("dump dir not found: %s" % a.dump_dir)

    src = read_text(a.mlir)
    ir = read_text(a.layout_ir)
    vmfb_bytes = os.path.getsize(a.vmfb)
    vmfb_sha = sha256_file(a.vmfb)

    # ---- entry signature: source vs compiler reflection --------------------
    sig = entry_signature(src, a.entry)
    if sig is None:
        raise SystemExit("entry function @%s not found in %s" % (a.entry, a.mlir))
    arg_shapes = smb.entry_arg_shapes(a.mlir, a.entry)          # reused helper (inputs)
    res_shapes = entry_result_shapes(a.mlir, a.entry)           # output-side twin
    abi = abi_declaration(ir, a.entry)
    abi_matches = (abi is not None and sig_equal(abi["inputs"], sig["inputs"])
                   and sig_equal(abi["outputs"], sig["outputs"]))
    # F2 (external review, 2026-09): a MISSING iree.abi.declaration used to only
    # go into `notes` -- unlike a declaration that disagrees with the source
    # (handled below), an absent one skipped the compiler's own reflection
    # cross-check entirely and still let the contract trust the source
    # signature alone. Missing is not the same as agreeing; treat it the same
    # as a mismatch (hard fail unless explicitly overridden).
    if abi is None:
        msg = "no iree.abi.declaration for @%s in the layout IR" % a.entry
        notes.append(msg)
        if not a.allow_missing_abi_declaration:
            hard_fail_errors.append(msg + " (pass --allow-missing-abi-declaration to override)")
    elif not abi_matches:
        msg = "iree.abi.declaration disagrees with the MLIR source signature"
        notes.append(msg)
        if not a.allow_abi_mismatch:
            hard_fail_errors.append(msg + " (pass --allow-abi-mismatch to override)")

    # ---- allocation schedule (entry) ---------------------------------------
    prints = parse_entry_prints(ir, a.entry)
    whole = smb.parse_alloc_ir(ir, a.entry)                     # reference behaviour: last print
    if prints:
        chosen = max(prints, key=lambda p: (p["lowering_score"], p["chunk_index"]))
        p = chosen["parsed"]
        states = {json.dumps({k: pr["parsed"][k] for k in ("inputs", "outputs", "transient_slabs",
                                                           "transient_slices", "unresolved", "dispatches")},
                             sort_keys=True) for pr in prints}
        entry_prov = {"entry_prints_in_dump": len(prints),
                      "entry_print_states_differ": len(states) > 1,
                      "entry_print_used_chunk_index": chosen["chunk_index"],
                      "entry_print_used_sha256": chosen["sha256"],
                      "entry_print_used_is_last": chosen is prints[-1],
                      "agrees_with_parse_alloc_ir_last_print": all(
                          p[k] == whole[k] for k in ("inputs", "outputs", "transient_slabs", "unresolved", "dispatches"))}
    else:
        p = whole
        entry_prov = {"entry_prints_in_dump": 0, "entry_print_states_differ": None,
                      "entry_print_used_chunk_index": None, "entry_print_used_is_last": None,
                      "agrees_with_parse_alloc_ir_last_print": True}
        notes.append("entry function @%s not found as a separate dump; parsed the whole IR" % a.entry)
    if not p["entry_found"]:
        notes.append("entry function @%s NOT found in layout IR; bound cannot be established" % a.entry)

    unresolved = list(p["unresolved"])
    all_static = p["entry_found"] and not unresolved
    inputs_b = sum(p["inputs"])
    outputs_b = sum(p["outputs"])
    transient_b = sum(p["transient_slabs"])
    io_b = inputs_b + outputs_b

    # ---- module-resident constants -----------------------------------------
    dense_consts = list(whole["constants"])          # `<constant>{%cN} = dense...` (established method)
    dense_sum = sum(dense_consts)
    packed = packed_constant_buffers(ir)             # `#util.composite<Nxi8` (what try_map/alloc maps)
    packed_sum = sum(packed)
    if packed_sum > 0:
        const_b, const_method = packed_sum, "packed_constant_buffers(#util.composite)"
    else:
        const_b, const_method = dense_sum, "sum_of_stream_constants(= dense)"
    padding = (packed_sum - dense_sum) if (packed_sum > 0 and dense_sum > 0) else 0
    if packed_sum > 0 and dense_sum > 0 and packed_sum < dense_sum:
        notes.append("packed constant buffers (%d B) smaller than the dense constant sum (%d B): "
                     "some constants were inlined into executables or deduplicated" % (packed_sum, dense_sum))

    # ---- structural (non-regex) cross-check (E19, CLAUDE.md priority 3 stage 2) --
    # E18 (EVIDENCE_v0.13) built harness/mlir_alloc_walk.py, a second, independently
    # implemented reader of the SAME layout IR: it walks IREE's real Operation/Value
    # graph (iree.compiler.ir) instead of matching regexes against the printed text,
    # and EVIDENCE_v0.13 SS3 validated it against all 14 stored contracts (exact
    # agreement on inputs/outputs/transient_slabs, constants by sum, entry_found,
    # and unresolved-presence). Wiring it in here as a MANDATORY cross-check (not a
    # replacement -- EVIDENCE_v0.13 SS4 explicitly scoped replacement out as needing
    # further stream.resource.pack coverage and multi-compiler-version testing)
    # means a silent misparse in either implementation alone can no longer pass
    # unnoticed: two independent readers of the same IR must agree before a
    # contract is written. It also gives CLAUDE.md priority 3's still-unmet
    # evaluation criterion ("compiler 버전 변경 시 명시적 실패") a real enforcement
    # point -- if a future IREE version changes the layout IR in a way the
    # structural parser can't handle, ir.Module.parse() raises and THIS hard-fails
    # the contract, instead of the regex path silently keeping its own number with
    # nothing to check it against.
    structural = None
    structural_error = None
    structural_available = maw is not None and getattr(maw, "ir", None) is not None
    if structural_available:
        try:
            structural = maw.parse_alloc_ir_structural(ir, a.entry)
        except Exception as e:
            structural_error = str(e)[:500]
    elif maw is not None:
        structural_error = "iree.compiler.ir not importable (%s)" % getattr(maw, "_IMPORT_ERROR", "?")

    # E19 code review (2026-09) found two false-hard-fail bugs in the first
    # version of this block, both confirmed by real reproduction:
    #   (1) it compared `structural` against `whole` (smb.parse_alloc_ir on the
    #       WHOLE file, which -- per static_mem_bound.py's own "take the LAST
    #       occurrence" comment -- assumes the entry function's last print in
    #       the file is its most-lowered one). The contract's actual numbers
    #       come from `p` (chosen just above by lowering_score, NOT file
    #       order) precisely because that assumption can be wrong -- this
    #       module's own docstring says the print order depends on thread
    #       scheduling. Comparing against `whole` instead of `p` meant a
    #       structurally-correct extraction could be hard-refused merely
    #       because the file happened to print the lowered chunk first.
    #   (2) it compared structural's constants sum against `dense_sum` (the
    #       raw per-tensor sum). structural's constants sum is actually the
    #       PACKED stream.resource.alloc size (see mlir_alloc_walk.py's
    #       _extract_constants), i.e. it tracks packed_sum, not dense_sum --
    #       the same distinction this file already carries as const_b
    #       (packed_sum when nonzero, else dense_sum; see above). Any model
    #       with nonzero constant-packing padding/dedup (padding != 0) would
    #       false-hard-fail forever, even though const_b -- what the contract
    #       actually reports -- was correct.
    # Both are fixed by comparing against what the contract actually signs
    # (p, const_b) instead of the legacy/reference-only values (whole,
    # dense_sum); the diff logic itself now lives once, in
    # mlir_alloc_walk.diff_against_regex, so make_contract.py and
    # mlir_alloc_walk.py's own --cross-check CLI cannot independently drift
    # into the same bug again.
    structural_diffs = (maw.diff_against_regex(structural, p, constants_reference=const_b)
                        if structural is not None else [])

    if not structural_available:
        structural_note = ("structural (iree.compiler.ir) cross-check unavailable%s: this project calls it "
                           "a MANDATORY cross-check, so a genuinely missing checker is refused by default "
                           "the same as an active disagreement (F3, external review 2026-09) -- pass "
                           "--allow-missing-structural-checker to proceed with the regex parser alone"
                           % ((" (%s)" % structural_error) if structural_error else ""))
    elif structural is None:
        structural_note = "structural (iree.compiler.ir) cross-check could not parse the layout IR: %s" % structural_error
    elif structural_diffs:
        structural_note = "structural (iree.compiler.ir) extractor DISAGREES with the regex parser on %s" % structural_diffs
    else:
        structural_note = "structural (iree.compiler.ir) extractor agrees with the regex parser"
    structural_prov = {
        "available": structural_available,
        "parse_error": structural_error,
        "agrees_with_regex_parser": (not structural_diffs) if structural is not None else None,
        "diffs": structural_diffs,
        "dispatches": structural.get("dispatches") if structural is not None else None,
        "note": structural_note,
    }
    # only note the "agrees" case in structural_prov (above), not in the
    # top-level notes list -- matches pre-existing behaviour for every other
    # silently-passing check in this function, and keeps the 14 stored
    # contracts' provenance.notes list byte-for-byte unchanged (regression
    # check, harness/contract_negative_tests.py).
    if structural_available and (structural is None or structural_diffs):
        notes.append(structural_note)
        if not a.allow_structural_mismatch:
            hard_fail_errors.append(structural_note + " (pass --allow-structural-mismatch to override)")
    elif not structural_available:
        notes.append(structural_note)
        if not a.allow_missing_structural_checker:
            hard_fail_errors.append(structural_note)

    # ---- artifact ---------------------------------------------------------
    dump_txt, dump_err = iree_dump_module(a.vmfb)
    rod = smb.artifact_rodata_segments(a.vmfb)
    if rod == (None, None):
        # D25 (E23): iree-dump-module is not runnable, so the INDEPENDENT
        # (non-IR) confirmation of the module constant total cannot be made at
        # all. Record null -- never False, which would read as "checked and
        # contradicted" -- and refuse by default, the same treatment F1 gave
        # an unevaluable one-invocation cross-check (same override flag: a
        # contract whose independent checks could not run is exactly what
        # --allow-unverified-invocation is for).
        ext_segs, data_segs = None, None
        consts_confirmed = consts_confirmed_dense = None
        rodata_unavailable = ("iree-dump-module is not runnable: the independent artifact-side confirmation of "
                              "module_resident_constant_bytes (.rodata segments) could not be evaluated")
        notes.append(rodata_unavailable)
    else:
        rodata_unavailable = None
        if isinstance(rod, tuple) and len(rod) == 2:
            ext_segs, data_segs = list(rod[0]), list(rod[1])
        else:  # older static_mem_bound returned one list
            ext_segs, data_segs = list(rod), list(rod)
        consts_confirmed = subset_sum_match(const_b, data_segs)
        consts_confirmed_dense = subset_sum_match(dense_sum, data_segs)
    exec_fmt = None
    bytecode_bytes = None
    if dump_txt:
        m = re.search(r"embedded-elf-[\w]+", dump_txt)
        exec_fmt = m.group(0) if m else None
        m = re.search(r"Bytecode:\s+(\d+)\s+bytes", dump_txt)
        bytecode_bytes = int(m.group(1)) if m else None
    else:
        notes.append("iree-dump-module failed: %s" % dump_err)
    embedded = []
    if esf is not None:
        with open(a.vmfb, "rb") as f:
            blob = f.read()
        for e in esf.locate_embedded_elfs(blob):
            embedded.append({"offset": e["offset"], "bytes": e["size"], "arch": e["arch"], "sha256": e["sha256"]})
        del blob
    embedded_shas = {e["sha256"] for e in embedded}

    # ---- dump dir ---------------------------------------------------------
    dump_files = []
    ll_triple = None
    dump_elf = None
    if a.dump_dir:
        for fn in sorted(os.listdir(a.dump_dir)):
            fp = os.path.join(a.dump_dir, fn)
            if not os.path.isfile(fp):
                continue
            rec = {"name": fn, "bytes": os.path.getsize(fp), "sha256": sha256_file(fp)}
            dump_files.append(rec)
            if fn.endswith(".codegen.ll") and ll_triple is None:
                m = re.search(r'target triple = "([^"]+)"', read_text(fp))
                ll_triple = m.group(1) if m else None
            if fn.endswith((".so", ".elf")):
                with open(fp, "rb") as f:
                    is_elf = f.read(4) == b"\x7fELF"
                if is_elf and (dump_elf is None or fn.endswith(".so")):
                    dump_elf = rec  # the final linked ET_DYN executable, not the intermediate .o
    if ll_triple and ll_triple.split("-")[0] != a.triple.split("-")[0]:
        msg = "codegen.ll target triple %s does not match --triple %s" % (ll_triple, a.triple)
        notes.append(msg)
        if not a.allow_triple_mismatch:
            hard_fail_errors.append(msg + " (pass --allow-triple-mismatch to override)")
    dump_elf_in_vmfb = (dump_elf["sha256"] in embedded_shas) if (dump_elf and embedded) else None

    # ---- one-invocation cross-checks (EVIDENCE_v0.7 SS1.3) -----------------
    # A contract is only evidence if --vmfb, --layout-ir and --dump-dir all came
    # from the SAME iree-compile call. Nothing here proves that positively (we
    # were not the ones who ran the compiler) but two independent signals catch
    # the case that matters -- someone passing artifacts from different models
    # or different compiles: (1) the vmfb must physically embed the dump-dir's
    # linked executable (byte-identical, checked by sha256 above), and (2) the
    # dump-dir's file names must carry the mlir input's own basename (the input
    # path is baked into symbol/file names -- the exact fact EVIDENCE_v0.7 SS1.3
    # is about). Both are necessary, neither is sufficient by itself: (1) alone
    # would not catch two same-named models compiled from different source
    # files; (2) alone would not catch a stale vmfb rebuilt from a since-edited
    # but identically-named mlir file.
    mlir_stem = re.sub(r"[^0-9A-Za-z_]", "_", os.path.splitext(os.path.basename(a.mlir))[0])
    stem_in_dump = any(mlir_stem and mlir_stem in fn["name"] for fn in dump_files) if dump_files else None

    # D14 (EVIDENCE_v0.9 SS11.7, external review R5): (1) and (2) above bind
    # --vmfb and --dump-dir to each other, but neither says anything about
    # --layout-ir -- and every number bounded_bytes reports (SS462 below) is
    # parsed from --layout-ir alone. A layout IR carried over from a
    # different compile (even of an identically-named model) would sail
    # through unnoticed. Unlike the vmfb/dump-dir case there is no filename
    # embedding the mlir basename inside --layout-ir (it starts at
    # `util.initializer`, not `module @name`), so basename matching does not
    # apply here; instead this checks a real, invocation-specific fact: the
    # `stream.cmd.dispatch @NAME::...` symbols the layout IR references for
    # its transient/output sizing must each have a per-dispatch file under
    # --dump-dir (e.g. `module_infer_dispatch_0.mlir`) from that SAME
    # invocation's --iree-hal-dump-executable-files-to. A stale or swapped
    # layout IR referencing dispatch names the dump-dir never produced fails
    # this check; a dump-dir missing a dispatch the layout IR relies on also
    # fails it. This is still not a cryptographic proof (a compile that
    # coincidentally reuses the same dispatch names would pass), but it is a
    # concrete cross-artifact fact this tool did not check before D14.
    layout_dispatch_names = sorted(set(re.findall(r"stream\.cmd\.dispatch\s+@([A-Za-z0-9_]+)", ir)))
    dump_names = {fn["name"] for fn in dump_files}
    layout_dispatches_in_dump = (all(any(dn in fname for fname in dump_names) for dn in layout_dispatch_names)
                                 if (layout_dispatch_names and dump_files) else None)

    # F1 (external review, 2026-09): the three one-invocation signals above
    # (dump_elf_in_vmfb, stem_in_dump, layout_dispatches_in_dump) are each
    # tri-state -- True (verified same-invocation), False (verified NOT the
    # same, e.g. D10/D14), or None ("could not evaluate", e.g. --dump-dir was
    # empty). The checks below only ever caught the False case; a --dump-dir
    # with zero files makes every signal None, invocation_errors stays empty,
    # and the contract is written with single_invocation=false and NOT ONE
    # note explaining why -- "did not find a mismatch" silently became
    # equivalent to "confirmed the same invocation". Reproduced directly:
    # --dump-dir pointed at an empty directory writes a fully "valid"
    # contract. Fail closed on "could not verify" the same as on "verified
    # mismatch", with the same --allow-* escape hatch pattern.
    invocation_errors = []
    if rodata_unavailable and not a.allow_unverified_invocation:
        invocation_errors.append(rodata_unavailable + " (pass --allow-unverified-invocation to override)")

    # N1 (external review v0.18-followup, 2026-09): D25 above refuses "could not
    # observe the artifact-side constant total". But the STRICTLY STRONGER negative
    # evidence -- observed it and it CONTRADICTS the IR total -- was only written
    # into constants_check_note and never refused. Reproduced: a dump reporting
    # .rodata [1, 6344] against an IR total of 2176 B still wrote a contract whose
    # header was byte-identical to the healthy one.
    #
    # Three carve-outs, each measured against the archived corpus rather than
    # argued -- subset_sum_match() returns a plain False for all three of
    # "contradicted", "nothing to confirm" and "gave up", so the gate has to
    # separate them at the call site (the same tri-state lesson as D25, one level
    # down; making subset_sum_match itself tri-state is the structurally cleaner
    # fix and is recorded as out of scope in EVIDENCE_v0.19 §7):
    #   (1) const_b == 0  -- nothing to confirm. Both shipped `dynamic` contracts
    #       are exactly this, so a blanket refusal makes the UNKNOWN_BOUND model
    #       of the A8 negative scenario unbuildable (measured: 2 of 14 refused).
    #   (2) len(data_segs) > 24 -- subset_sum_match caps enumeration and returns
    #       False on "gave up". No archived model has more than 2 segments, so
    #       this path is untested; treat it as unevaluated, not contradicted.
    #   (3) the dense sum IS confirmed and const_b >= dense_sum -- constant-buffer
    #       alignment padding (D17/E20), a sound over-approximation that E20 fixed
    #       AS an over-rejection defect. Refusing it would re-open D17 (measured:
    #       the E20 regression fixture fails without this carve-out).
    _consts_truncated = data_segs is not None and len(data_segs) > SUBSET_SUM_MAX_SEGMENTS
    _consts_pad_ok = bool(consts_confirmed_dense) and dense_sum > 0 and const_b >= dense_sum
    if const_b > 0 and consts_confirmed is False and not _consts_truncated and not _consts_pad_ok:
        msg = ("module_resident_constant_bytes %d B is CONTRADICTED by the independent artifact-side "
               "observation: no subset of the flatbuffer .rodata segments %s sums to it, and the dense "
               "constant sum %d B is not confirmed either (iree-dump-module)" % (const_b, data_segs, dense_sum))
        notes.append(msg)
        if not a.allow_unconfirmed_constants:
            invocation_errors.append(msg + " (pass --allow-unconfirmed-constants to override)")
    if not dump_files:
        msg = ("--dump-dir '%s' contains no files: none of the one-invocation cross-checks "
              "(embedded-ELF match, mlir-basename match, layout-ir dispatch match) could be "
              "evaluated -- this looks like --iree-hal-dump-executable-files-to was not passed "
              "to the compile, or --dump-dir points at the wrong directory, not like a verified "
              "same-invocation compile" % a.dump_dir)
        notes.append(msg)
        if not a.allow_unverified_invocation:
            invocation_errors.append(msg + " (pass --allow-unverified-invocation to override)")
    if dump_elf is not None and embedded and dump_elf_in_vmfb is False:
        invocation_errors.append(
            "--dump-dir's linked executable (%s, sha256 %s) is NOT embedded in --vmfb: "
            "these are not outputs of the same iree-compile invocation" % (dump_elf["name"], dump_elf["sha256"][:16]))
    if dump_files and stem_in_dump is False:
        invocation_errors.append(
            "no file under --dump-dir contains the --mlir basename '%s' (mlir input path is embedded in "
            "dispatch/symbol names): --dump-dir looks like it belongs to a different compile" % mlir_stem)
    if layout_dispatches_in_dump is False:
        missing = [dn for dn in layout_dispatch_names if not any(dn in fname for fname in dump_names)]
        invocation_errors.append(
            "--layout-ir references dispatch(es) %s that have no file under --dump-dir: "
            "--layout-ir looks like it belongs to a different compile than --dump-dir" % missing)

    # N2 (external review v0.18-followup, 2026-09): F1 above closed only the
    # *empty* --dump-dir case. A NON-empty dump dir that is merely missing the
    # linked executable (.so/.elf) leaves dump_elf_in_vmfb None -- no branch above
    # fires, and the contract was written with single_invocation=false, an empty
    # notes list, and a byte-identical deployable header. Reproduced by deleting
    # one .so from a copy of the archived conv2d dump dir (exit 0, no override
    # flag), and escalated: that same dump dir paired with a DIFFERENT model's
    # vmfb also produced a contract, which is the D10 hole re-opened through the
    # None path. It is reachable without hand-editing anything -- compiling with
    # --iree-hal-dump-executable-sources-to/-intermediates-to instead of the meta
    # flag --iree-hal-dump-executable-files-to yields exactly this dump dir.
    #
    # This catch-all deliberately covers ONLY the None ("could not evaluate")
    # state: each False state already has an unconditional, non-overridable
    # branch above, and folding those in here would both duplicate the diagnostic
    # and wrongly advertise a verified mismatch as --allow-* overridable.
    unverifiable = []
    if dump_elf_in_vmfb is None:
        unverifiable.append(
            "dump_elf_sha256_in_vmfb=None (linked executable found under --dump-dir: %s): the vmfb<->dump-dir "
            "binding could not be established -- pass --iree-hal-dump-executable-files-to (the meta flag), "
            "not only the component --iree-hal-dump-executable-{sources,intermediates}-to flags"
            % (dump_elf["name"] if dump_elf else "none"))
    if stem_in_dump is None:
        unverifiable.append("mlir_basename_in_dump_dir_files=None (--mlir stem %r could not be checked)" % mlir_stem)
    if layout_dispatches_in_dump is None:
        unverifiable.append("layout_dispatches_in_dump=None (layout-ir dispatch names %s could not be checked)"
                            % (layout_dispatch_names or "[]"))
    for m in unverifiable:
        notes.append("one-invocation signal not verified: " + m)   # never silent again
    if unverifiable and not a.allow_unverified_invocation:
        invocation_errors.append("one-invocation cross-check(s) could not be evaluated: " + "; ".join(unverifiable)
                                 + " (pass --allow-unverified-invocation to override)")

    if invocation_errors or hard_fail_errors:
        raise SystemExit("one-invocation / provenance check FAILED (not writing a contract for mismatched inputs):\n  - "
                         + "\n  - ".join(invocation_errors + hard_fail_errors))
    # N2: every signal must be positively True. The previous form accepted None
    # for two of the three (`is not False`), i.e. "did not find a mismatch" was
    # recorded as "confirmed same invocation".
    single_invocation = (dump_elf_in_vmfb is True and stem_in_dump is True
                         and layout_dispatches_in_dump is True)

    # ---- ELF analysis (harness/elf_stack_frame.py) --------------------------
    elf = None
    elf_prov = {"file": None, "sha256": None, "elf_sha256_in_vmfb": None}
    if a.elf_analysis:
        if not os.path.isfile(a.elf_analysis):
            raise SystemExit("elf analysis not found: %s" % a.elf_analysis)
        elf = json.load(open(a.elf_analysis))
        elf_prov = {"file": os.path.basename(a.elf_analysis), "sha256": sha256_file(a.elf_analysis),
                    "elf_sha256_in_vmfb": (elf.get("elf_sha256") in embedded_shas) if embedded else None}
        if embedded and elf.get("elf_sha256") not in embedded_shas:
            msg = "ELF analysed by elf_stack_frame.py is NOT the ELF embedded in the vmfb"
            notes.append(msg)
            if not a.allow_elf_analysis_mismatch:
                raise SystemExit("one-invocation / provenance check FAILED (not writing a contract for mismatched "
                                 "inputs):\n  - %s (pass --allow-elf-analysis-mismatch to override)" % msg)
    if elf is not None:
        stack_b = elf.get("max_dispatch_frame_bytes")
        stack_inv = elf.get("max_dispatch_invocation_stack_bytes")
        calls = elf.get("total_call_insns")
        alloca = (elf.get("llvm_ir") or {}).get("alloca_count")
        dyn = bool(elf.get("any_dynamic_stack_alloc"))
        # R1 (external review v0.19-reframe, E24b): these two numbers were copied
        # out of the --elf-analysis JSON with no sanity check, so a stale,
        # hand-written or third-party analysis file could put a NEGATIVE task
        # stack into a schema-valid contract -- and from there into a header
        # whose C gate becomes a tautology (see gen_contract_header.py's R1
        # comment). make_contract.py hashes the analysis file and matches its
        # elf_sha256 against the vmfb, but never questioned its numbers. Refuse
        # here so the bad value cannot enter a contract at all; the header-side
        # guard is the second layer.
        for _name, _v in (("max_dispatch_frame_bytes", stack_b),
                          ("max_dispatch_invocation_stack_bytes", stack_inv)):
            if isinstance(_v, int) and not isinstance(_v, bool) and _v < 0:
                raise SystemExit("--elf-analysis reports a negative %s (%r): a task stack figure cannot be "
                                 "negative; refusing to write it into a contract" % (_name, _v))
        if dyn:
            cls = "bucket_4_unaccounted_dynamic_stack"
        elif calls:
            cls = "bucket_3_or_4_unresolved_calls"
        elif stack_b is not None and stack_b > 0:
            # R1: was `elif stack_b:` -- truthiness promoted ANY non-zero figure,
            # negative included, into the "trusted" bucket_2 that the header
            # generator's stack-trust gate (E21/D22, E24/D29) accepts.
            cls = "bucket_2_task_stack_budget"
        else:
            cls = "none"
        kernel = {
            "kernel_task_stack_bytes": stack_b,
            "kernel_task_stack_invocation_bytes": elf.get("max_dispatch_invocation_stack_bytes"),
            "kernel_task_stack_bytes_source": "elf_stack_frame.py max_dispatch_frame_bytes (max over dispatch functions; callee-saved + locals)",
            "kernel_external_call_insns": calls,
            "llvm_alloca_count": alloca,
            "llvm_external_calls": (elf.get("llvm_ir") or {}).get("external_calls"),
            "kernel_dynamic_stack_alloc": dyn,
            "kernel_stack_classification": cls,
            "kernel_stack_note": elf.get("classification_note"),
            "kernel_elf_bytes": elf.get("elf_bytes"),
            "kernel_elf_sha256": elf.get("elf_sha256"),
            "kernel_elf_arch": elf.get("arch"),
            "kernel_dispatch_functions": elf.get("dispatch_functions"),
            "kernel_total_insns": elf.get("total_insns"),
            "kernel_vector_insns": elf.get("vector_insns_total"),
        }
    else:
        kernel = {
            "kernel_task_stack_bytes": None,
            "kernel_task_stack_invocation_bytes": None,
            "kernel_task_stack_bytes_source": None,
            "kernel_external_call_insns": None,
            "llvm_alloca_count": None,
            "llvm_external_calls": None,
            "kernel_dynamic_stack_alloc": None,
            "kernel_stack_classification": "unknown",
            "kernel_stack_note": "no --elf-analysis given: kernel stack frame / calls / alloca not established",
            "kernel_elf_bytes": dump_elf["bytes"] if dump_elf else None,
            "kernel_elf_sha256": dump_elf["sha256"] if dump_elf else None,
            "kernel_elf_arch": None,
            "kernel_dispatch_functions": None,
            "kernel_total_insns": None,
            "kernel_vector_insns": None,
        }
        notes.append("kernel_task_stack_bytes is null (no ELF analysis supplied)")

    # ---- compiler / runtime identity ---------------------------------------
    comp_short, comp_raw, comp_sha = compiler_version()
    runtime_commit = a.runtime_commit or (comp_sha[:7] if comp_sha else None)

    # ---- assemble -------------------------------------------------------------
    first_in = tensor_json(sig["inputs"][0]) if sig["inputs"] else None
    first_out = tensor_json(sig["outputs"][0]) if sig["outputs"] else None
    assumptions = ["static shapes", "single in-flight call (no concurrency)",
                   "%s driver" % a.driver, "entry function @%s only" % a.entry]

    resources = {
        "memory_boundary": MEMORY_BOUNDARY,
        "static_external_input_bytes": inputs_b if all_static else None,
        "static_external_output_bytes": outputs_b if all_static else None,
        "static_io_bytes": io_b if all_static else None,
        "static_transient_bytes": transient_b if all_static else None,
        "transient_slabs_post_layout": list(p["transient_slabs"]),
        "transient_slice_sum_diagnostic": sum(p["transient_slices"]),
        "static_per_call_bytes": (io_b + transient_b) if all_static else None,
        "module_resident_constant_bytes": const_b,
        "module_resident_constant_method": const_method,
        "module_resident_constant_dense_sum_bytes": dense_sum,
        "module_resident_constant_buffers_packed": packed,
        "module_resident_constant_packing_padding_bytes": padding,
        "bounded_bytes": (io_b + transient_b + const_b) if all_static else None,
        "bound_method": BOUND_METHOD_STATIC if all_static else BOUND_METHOD_NONE,
        "bound_source": "post-layout stream.resource.alloca sizes of the entry function after iree-stream-layout-slices "
                        "(alignment and lifetime reuse resolved by the compiler) + packed module constants",
        "unresolved_sizes": unresolved,
        "resolved_partial_sums_when_unbounded": (None if all_static else
                                                 {"inputs": inputs_b, "outputs": outputs_b, "transient": transient_b}),
        "bound_assumptions": assumptions,
        "entry_function_found": p["entry_found"],
        "dispatches": p["dispatches"],
        "binary_size_bytes": vmfb_bytes,
        "vm_bytecode_bytes": bytecode_bytes,
        "artifact_rodata_external_segments": ext_segs,
        "artifact_rodata_data_segments": data_segs,
        "constants_independently_confirmed_in_artifact": consts_confirmed,
        "constants_dense_sum_confirmed_in_artifact": consts_confirmed_dense,
        "constants_check_note": (
            # D25 (E23): three states, not two -- "not evaluated" must never be
            # printed as "NOT matched" (checked and contradicted).
            rodata_unavailable if consts_confirmed is None else
            "module constant total %d B equals a subset-sum of the flatbuffer .rodata segments %s (iree-dump-module)"
            % (const_b, data_segs) if consts_confirmed else
            "module constant total %d B NOT matched by artifact .rodata segments %s" % (const_b, data_segs)),
        "scope": "program-allocated buffers only; excludes IREE runtime context (VM, HAL device, module tables) and the task stack",
    }
    resources.update(kernel)

    contract = {
        "model": {
            "name": a.model_name,
            "sha256": sha256_file(a.mlir),  # raw file bytes, not the decoded/newline-translated text (`src`)
            "file": os.path.basename(a.mlir),
            "bytes": os.path.getsize(a.mlir),
            "entry": a.entry,
        },
        "interface": {
            "input": first_in,
            "output": first_out,
            "inputs": [tensor_json(t) for t in sig["inputs"]],
            "outputs": [tensor_json(t) for t in sig["outputs"]],
            "all_static": all(t["static"] for t in sig["inputs"] + sig["outputs"]),
            "source_arg_shapes_static": [list(s) for s in arg_shapes] if arg_shapes else None,
            "source_result_shapes_static": [list(s) for s in res_shapes] if res_shapes else None,
            "abi_declaration": abi["raw"] if abi else None,
            "abi_declaration_matches_source": abi_matches,
        },
        "target": {
            "triple": a.triple,
            "cpu": a.cpu,
            "profile": a.profile or a.cpu,
            "driver": a.driver,
            "backend": "llvm-cpu",
            "executable_format": "embedded-elf",
            "executable_format_in_artifact": exec_fmt,
            "codegen_ll_target_triple": ll_triple,
            "extra_args": extra_args,
        },
        "resources": resources,
        "timing": {
            "boundary": "L1_kernel",
            "execution_bound_us": None,
            "bound_method": None,
            "sample_count": None,
            "platform_timing_grade": "FUNCTIONAL_ONLY",
            "note": "no execution bound: latency is never evidence on a FUNCTIONAL_ONLY platform (harness/platform_check.py)",
        },
        "artifact": {
            "file": os.path.basename(a.vmfb),
            "sha256": vmfb_sha,
            "bytes": vmfb_bytes,
            "embedded_executables": embedded,
            "produced_by": "single iree-compile invocation that also emitted the layout IR (--mlir-print-ir-after=iree-stream-layout-slices) "
                           "and the executable dumps (--iree-hal-dump-executable-files-to); this contract was parsed from those outputs",
        },
        "validity": {
            "entry": a.entry,
            "input": first_in,
            "output": first_out,
            "driver": a.driver,
            "profile": a.profile or a.cpu,
            "compiler": comp_short,
            "compiler_version_raw": comp_raw,
            "compiler_commit": comp_sha,
            "runtime_commit": runtime_commit,
            "assumptions": assumptions,
            "binding_rule": BINDING_RULE,
        },
        "provenance": {
            "single_invocation": single_invocation,
            "mlir_basename_in_dump_dir_files": stem_in_dump,
            "tool": "harness/make_contract.py",
            "mlir_file": os.path.basename(a.mlir),
            "mlir_sha256": None,  # filled below
            "layout_ir_file": os.path.basename(a.layout_ir),
            "layout_ir_sha256": sha256_file(a.layout_ir),
            "layout_ir_bytes": os.path.getsize(a.layout_ir),
            "layout_ir_dump_count": len(DUMP_HEADER_RE.findall(ir)),
            "layout_ir_note": "per-function dumps in thread-dependent order (multi-threaded pass manager); "
                              "the entry function is printed once per pipeline phase -- the most-lowered print is used",
            "dump_dir": a.dump_dir,
            "dump_dir_files": dump_files,
            "dump_elf": dump_elf,
            "dump_elf_sha256_in_vmfb": dump_elf_in_vmfb,
            # N2 (v0.19/E24): the third one-invocation signal was computed since D14
            # and then discarded -- single_invocation was recorded as a single bool
            # with no way to tell WHICH cross-check carried it. Persist the signal
            # and the dispatch names it was derived from so the provenance is
            # reviewable rather than merely asserted.
            "layout_dispatch_names": layout_dispatch_names,
            "layout_dispatches_in_dump": layout_dispatches_in_dump,
            "elf_analysis": elf_prov,
            "structural_walker": structural_prov,
            "notes": notes,
        },
    }
    contract["provenance"].update(entry_prov)
    contract["provenance"]["mlir_sha256"] = contract["model"]["sha256"]
    return contract



def validate(contract, schema_path):
    try:
        import jsonschema
    except ImportError:
        return None, ["jsonschema not importable; validation skipped"]
    schema = json.load(open(schema_path))
    v = jsonschema.Draft202012Validator(schema)
    errs = ["%s: %s" % ("/".join(str(x) for x in e.absolute_path) or "<root>", e.message[:200])
            for e in v.iter_errors(contract)]
    return (len(errs) == 0), errs


def parse_args(argv):
    # everything after a bare `--extra-args` is taken verbatim (values start with "--")
    extra = []
    if "--extra-args" in argv:
        i = argv.index("--extra-args")
        extra = argv[i + 1:]
        argv = argv[:i]
    rest = []
    for tok in argv:
        if tok.startswith("--extra-args="):
            extra.append(tok.split("=", 1)[1])
        else:
            rest.append(tok)
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mlir", required=True, help="MLIR source given to iree-compile")
    ap.add_argument("--vmfb", required=True, help="vmfb written by -o of the SAME invocation")
    ap.add_argument("--layout-ir", required=True, help="stderr of the SAME invocation (--mlir-print-ir-after=iree-stream-layout-slices)")
    ap.add_argument("--dump-dir", required=True, help="--iree-hal-dump-executable-files-to directory of the SAME invocation")
    ap.add_argument("--triple", required=True)
    ap.add_argument("--cpu", required=True)
    ap.add_argument("--model-name", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--entry", default="infer")
    ap.add_argument("--driver", default="local-sync")
    ap.add_argument("--profile", default=None, help="target.profile label (default: --cpu)")
    ap.add_argument("--elf-analysis", default=None, help="JSON from harness/elf_stack_frame.py on the ELF in --dump-dir")
    ap.add_argument("--runtime-commit", default=None, help="override (default: compiler commit short sha)")
    ap.add_argument("--schema", default=os.path.join(HERE, "..", "contracts", "contract.schema.json"))
    ap.add_argument("--no-validate", action="store_true")
    ap.add_argument("--allow-abi-mismatch", action="store_true",
                    help="do not hard-fail when iree.abi.declaration disagrees with the MLIR source signature "
                         "(D13/EVIDENCE_v0.9 SS11.9; default is to refuse writing the contract)")
    ap.add_argument("--allow-missing-abi-declaration", action="store_true",
                    help="do not hard-fail when iree.abi.declaration is absent from the layout IR entirely "
                         "(F2, external review 2026-09; the compiler's own reflection cross-check of the "
                         "source signature is then skipped -- default is to refuse writing the contract)")
    ap.add_argument("--allow-unverified-invocation", action="store_true",
                    help="do not hard-fail when --dump-dir is empty and the one-invocation cross-checks "
                         "(embedded-ELF match, mlir-basename match, layout-ir dispatch match) could not be "
                         "evaluated at all (F1, external review 2026-09; default is to refuse writing the "
                         "contract -- 'could not verify' is not the same as 'verified')")
    ap.add_argument("--allow-unconfirmed-constants", action="store_true",
                    help="N1 (v0.19/E24): write the contract even though the artifact-side .rodata observation "
                         "CONTRADICTS module_resident_constant_bytes. Deliberately NOT --allow-unverified-invocation: "
                         "that flag means 'could not evaluate', this one means 'evaluated and it disagrees'")
    ap.add_argument("--allow-triple-mismatch", action="store_true",
                    help="do not hard-fail when codegen.ll's target triple arch differs from --triple "
                         "(D13/EVIDENCE_v0.9 SS11.9; default is to refuse writing the contract)")
    ap.add_argument("--allow-elf-analysis-mismatch", action="store_true",
                    help="do not hard-fail when --elf-analysis analysed a different ELF than the one embedded "
                         "in --vmfb (D13/EVIDENCE_v0.9 SS11.9; default is to refuse writing the contract, since "
                         "kernel_task_stack_bytes would then describe the wrong binary)")
    ap.add_argument("--allow-structural-mismatch", action="store_true",
                    help="do not hard-fail when the structural (iree.compiler.ir) extractor "
                         "(harness/mlir_alloc_walk.py, E18/E19) disagrees with, or cannot parse what, "
                         "the regex parser read from the same layout IR (default is to refuse writing "
                         "the contract; does not cover iree.compiler.ir being entirely uninstalled -- "
                         "see --allow-missing-structural-checker for that, F3 external review 2026-09)")
    ap.add_argument("--allow-missing-structural-checker", action="store_true",
                    help="do not hard-fail when iree.compiler.ir is not installed at all, so the structural "
                         "cross-check never ran (F3, external review 2026-09; default is to refuse writing "
                         "the contract with the regex parser alone, since this project calls the structural "
                         "cross-check MANDATORY -- a missing checker should not silently mean 'skip')")
    ap.add_argument("--extra-args", nargs="*", default=[], help="extra iree-compile flags of the invocation (must be LAST)")
    a = ap.parse_args(rest)
    a.extra_args = extra
    return a


def main(argv=None):
    a = parse_args(sys.argv[1:] if argv is None else argv)
    c = build_contract(a, a.extra_args)

    # R3b (EVIDENCE_v0.9 SS11.9, external review): schema validation used to
    # run AFTER the contract was already written to --out, so an exit-3
    # schema failure still left an invalid contract on disk for downstream
    # tools (gen_contract_header.py etc.) to pick up. It also silently
    # SKIPPED validation (treated as pass) whenever the `jsonschema` package
    # was not importable. Both are fail-open. Now: validate first, refuse to
    # write on failure OR on a missing validator, unless --no-validate was
    # explicitly given (an intentional, logged opt-out, not a silent default).
    if not a.no_validate:
        ok, errs = validate(c, a.schema)
        if ok is None:
            print("SCHEMA VALIDATION UNAVAILABLE (%s): %s" % (a.schema, errs[0]), file=sys.stderr)
            print("refusing to write a contract without schema validation; "
                  "install jsonschema, or pass --no-validate to override", file=sys.stderr)
            return 3
        elif not ok:
            print("SCHEMA VALIDATION FAILED (%s):" % a.schema, file=sys.stderr)
            for e in errs:
                print("  -", e, file=sys.stderr)
            return 3
        else:
            print("schema: valid (%s)" % os.path.relpath(a.schema))
    else:
        print("schema: validation skipped (--no-validate)", file=sys.stderr)

    os.makedirs(os.path.dirname(os.path.abspath(a.out)) or ".", exist_ok=True)
    with open(a.out, "w") as f:
        json.dump(c, f, indent=2)
        f.write("\n")
    r = c["resources"]
    print("wrote %s: bound_method=%s bounded=%s per_call=%s io=%s transient=%s constants=%s dispatches=%s "
          "artifact=%s B sha256=%s kernel_stack=%s calls=%s alloca=%s"
          % (a.out, r["bound_method"], r["bounded_bytes"], r["static_per_call_bytes"], r["static_io_bytes"],
             r["static_transient_bytes"], r["module_resident_constant_bytes"], r["dispatches"],
             c["artifact"]["bytes"], c["artifact"]["sha256"][:16], r["kernel_task_stack_bytes"],
             r["kernel_external_call_insns"], r["llvm_alloca_count"]))
    for n in c["provenance"]["notes"]:
        print("note:", n, file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
