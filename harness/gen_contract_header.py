#!/usr/bin/env python3
"""Generate a C header from a contract.json so that build-time constants are
never copied by hand (reviewer v0.6 SS3).  Both the standalone native learner
and the cFS app include the generated header.

Usage: python3 harness/gen_contract_header.py contract.json contract_gen.h
         [--allow-unknown-stack] [--allow-override-contract]

Macro set (shared C interface of E14 Stage 1; keep names stable):
  CONTRACT_MODEL_NAME              string   model.name (fallback: artifact file stem)
  CONTRACT_TARGET_TRIPLE           string   target.triple
  CONTRACT_BOUND_METHOD            string   resources.bound_method
  CONTRACT_BOUND_KNOWN             0/1      0 when bound_method == "NONE", any size unresolved,
                                            or bounded_bytes is null -> gate must return UNKNOWN_BOUND
  CONTRACT_PROVENANCE_VERIFIED     0/1      R5/E24b: 1 iff the contract carries a provenance block, states a
                                            known bound, records NO applied --allow-*/--no-validate override,
                                            and positively verified its single-invocation binding. A contract
                                            whose provenance says otherwise is REFUSED here unless
                                            --allow-override-contract is passed (then this macro is 0).
  CONTRACT_BOUNDED_BYTES           long     resources.bounded_bytes, -1L when unknown
  CONTRACT_PER_CALL_BYTES          long     resources.static_per_call_bytes, -1L when unknown
  CONTRACT_CONST_BYTES             long     resources.module_resident_constant_bytes, -1L when unknown
  CONTRACT_KERNEL_STACK_BYTES_KNOWN 0/1     0 when resources.kernel_task_stack_bytes absent/null
  CONTRACT_KERNEL_STACK_BYTES      long     max stack-frame bytes over the executable's dispatch
                                            functions (ELF analysis); 0 when none/unknown.
                                            Task-stack budget bucket, NOT part of the HAL contract.
  CONTRACT_ARTIFACT_BYTES          long     artifact.bytes
  CONTRACT_ARTIFACT_SHA256         string   artifact.sha256 (64 hex)
  CONTRACT_ENTRY                   string   "module." + validity.entry (iree_runtime_call_initialize_by_name)
  CONTRACT_INPUT_RANK / _SHAPE / _ELEMS     validity.input.shape (brace initializer, e.g. {1, 9})
  CONTRACT_OUTPUT_RANK / _SHAPE / _ELEMS    validity.output.shape
  CONTRACT_NUM_INPUTS / CONTRACT_NUM_OUTPUTS  from interface.inputs/outputs (1 when absent)
  CONTRACT_SHAPES_STATIC           0/1      0 when any dim is dynamic (then the dim is -1 in the
                                            initializer and *_ELEMS is 0; bound_method is NONE too)
  CONTRACT_DRIVER                  string   validity.driver

Contracts written before E14 Stage 1 lack the new fields; they default as
documented above (bound known unless bound_method == "NONE"; kernel stack 0 and
unknown; entry "infer").

Fail-closed checks (D13/EVIDENCE_v0.9 SS11.9, external review R3/R3b/8.3): before
D13 this generator's ONLY validation was that artifact.sha256 was 64 hex
characters. A contract with a negative bounded_bytes, or an unrecognized
bound_method, or no kernel_task_stack_* field, was all silently accepted and
turned into a header the C gate (`bounded <= budget`) would then ADMIT
unconditionally against. This tool now refuses to write a header (non-zero
exit, no file written) when any of those hold, unless the caller passes the
matching --allow-* flag as an explicit, logged override:
  --allow-unknown-stack   write CONTRACT_KERNEL_STACK_BYTES_KNOWN=0 with a
                          bound-known contract instead of refusing
"""
import json
import math
import sys


def c_str(s):
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"') + '"'


def is_int(v):
    return isinstance(v, int) and not isinstance(v, bool)


BOUND_METHOD_WHITELIST = {"static_from_stream_schedule", "static_from_stream_layout", "NONE"}


def long_or(v, default=-1):
    return "%dL" % (v if is_int(v) else default)


def _shape_statements(c, kind):
    """Every shape this contract actually STATES for `kind`, as (where, shape)
    pairs -- validity.<kind>, interface.<kind>, interface.<kind>s[0]. Only
    present, non-empty list shapes are returned; absence is not a statement."""
    v = c.get("validity") or {}
    i = c.get("interface") or {}
    out = []
    for where, src in (("validity.%s" % kind, v.get(kind)),
                       ("interface.%s" % kind, i.get(kind)),
                       ("interface.%ss[0]" % kind, (i.get("%ss" % kind) or [None])[0])):
        if isinstance(src, dict) and isinstance(src.get("shape"), list) and src["shape"]:
            out.append((where, list(src["shape"])))
    return out


def check_shape_agreement(c):
    """R3 (external review v0.19-reframe, E24b): shape_from() below is a FALLBACK
    chain (validity first, then interface) -- it returns on the first hit and never
    compares the two. A contract stating [1,8,8,1] in interface.input and [1,4,4,1]
    in validity.input silently emitted the validity one with BOUND_KNOWN=1, and an
    INFLATED shape sizes the HAL input buffer from the header while the gate only
    compares CONTRACT_BOUNDED_BYTES.

    NOT reachable from the production path -- make_contract.py fills both blocks
    from the same Python object (first_in/first_out), so only a hand-edited stored
    contract reaches this state. Defense-in-depth, not an observed failure.

    Absence is NOT disagreement: contracts/contract.e14_aarch64.json has no
    interface block at all and is an honest contract in the shape this repo's own
    schema declares. Requiring both blocks was measured as an over-rejection
    (defect class B), so only contradictions among the statements PRESENT are
    refused. The dtype half of the review's claim is refuted -- E24/N3 already
    takes the union of dtypes across both blocks, so any dtype conflict contains a
    non-f32 member and is already rejected."""
    for kind in ("input", "output"):
        stmts = _shape_statements(c, kind)
        if len(stmts) < 2:
            continue
        first_where, first_shape = stmts[0]
        for where, shape in stmts[1:]:
            if shape != first_shape:
                raise SystemExit(
                    "gen_contract_header: contract contradicts itself -- %s says %s but %s says %s. "
                    "Refusing to pick one silently (the header would size the HAL buffer from the winner "
                    "while the admission gate compares only CONTRACT_BOUNDED_BYTES)."
                    % (first_where, first_shape, where, shape))


def shape_from(c, kind, fallback):
    v = c.get("validity") or {}
    i = c.get("interface") or {}
    for src in (v.get(kind), i.get(kind)):
        if isinstance(src, dict) and isinstance(src.get("shape"), list) and src["shape"]:
            if any(not is_int(d) for d in src["shape"]):
                # dynamic dim (null / "?"): -1 in the initializer, ELEMS 0, CONTRACT_SHAPES_STATIC 0.
                # Such contracts also have bound_method NONE, so the gate refuses before shapes matter.
                print("gen_contract_header: WARNING %s shape %s has dynamic dims; emitting -1 for them" % (kind, src["shape"]), file=sys.stderr)
                return [int(d) if is_int(d) else -1 for d in src["shape"]], "contract-dynamic"
            return [int(d) for d in src["shape"]], "contract"
    print("gen_contract_header: WARNING %s shape missing in contract; using legacy default %s" % (kind, fallback), file=sys.stderr)
    return list(fallback), "legacy-default"


def main():
    argv = [x for x in sys.argv[1:] if not x.startswith("--allow-")]
    flags = {x for x in sys.argv[1:] if x.startswith("--allow-")}
    allow_unknown_stack = "--allow-unknown-stack" in flags
    allow_override_contract = "--allow-override-contract" in flags
    if len(argv) != 2:
        print("usage: gen_contract_header.py contract.json out.h "
              "[--allow-unknown-stack] [--allow-override-contract]", file=sys.stderr)
        return 2
    c = json.load(open(argv[0]))
    out = argv[1]
    r = c["resources"]
    a = c["artifact"]
    v = c.get("validity") or {}
    m = c.get("model") or {}
    t = c.get("target") or {}
    i = c.get("interface") or {}

    name = m.get("name") or (a.get("file", "model.vmfb").rsplit(".", 1)[0]) or "unknown"
    triple = t.get("triple") or "unknown"
    method = r.get("bound_method") or "unspecified"
    bounded = r.get("bounded_bytes")
    unresolved = r.get("unresolved_sizes") or []

    # D13 (EVIDENCE_v0.9 SS11.9, R3/R3b/8.3): fail-closed instead of the
    # previous behaviour of accepting anything and letting a bad value ride
    # into CONTRACT_BOUND_KNOWN=1 -- which the C gate (`bounded <= budget`)
    # would then treat as a real, admissible bound.
    if method not in BOUND_METHOD_WHITELIST:
        raise SystemExit("gen_contract_header: refusing unrecognized resources.bound_method %r "
                         "(allowed: %s)" % (method, sorted(BOUND_METHOD_WHITELIST)))
    if bounded is not None and (not is_int(bounded) or bounded < 0):
        raise SystemExit("gen_contract_header: refusing negative/non-integer resources.bounded_bytes %r" % (bounded,))

    bound_known = (method != "NONE") and is_int(bounded) and bounded >= 0 and not unresolved
    # R2 (external review v0.19-reframe, E24b): D13/E15 type- and sign-checked
    # bounded_bytes but never compared it with the components the SAME contract
    # states. A contract saying bounded_bytes=1 next to static_per_call_bytes=1352
    # and module_resident_constant_bytes=2176 emitted BOUND_KNOWN=1, and the C gate
    # reads only the first of those three macros -- ADMIT where the honest value
    # would refuse. make_contract.py computes all three in one dict literal under
    # the same all_static guard, so `==` is an exact identity there (measured on
    # every integer-valued contract in the repo); `>=` would refuse the same set
    # while letting an INFLATED self-contradictory bound through, which turns a
    # legitimate ADMIT into NOT_ADMITTED -- defect class (B).
    # Scoped to bound_known: the two `dynamic` contracts carry None/None/0 and an
    # unscoped comparison would reject them (the D16/D17 and N1/N3 trap again).
    #
    # F2 (external review v0.20, E24c): the guard above was `is_int(_pc) and
    # is_int(_cb) and bounded != _pc + _cb`, i.e. it ran ONLY when both components
    # happened to be integers -- so "the identity could not be evaluated" was
    # silently treated as "the identity holds". Two doctored contracts reproduced
    # it, and they are NOT the same mechanism:
    #   * static_per_call_bytes = null, bounded = 3528  -> the check never runs;
    #   * static_per_call_bytes = 3529, module_resident_constant_bytes = -1,
    #     bounded = 3528                                -> the check DOES run and
    #     passes vacuously, because 3529 + (-1) == 3528. The review attributed
    #     both to "only when both are ints"; that explains the first only. The
    #     second needs a NON-NEGATIVITY check, which nothing had.
    # This is the repo's own recurring root cause in a gate (D25/D28/D29): a state
    # that means "could not observe" collapsed into "observed and consistent".
    # Not normal-path reachable (make_contract.py builds all three in one dict
    # literal under one all_static guard, from unsigned regex captures), so it is
    # hardening, not a claim blocker -- but it defeats the gate D36 shipped one
    # version ago with the two cheapest possible edits.
    #
    # Three properties, each measured rather than assumed:
    #   * keep the `bound_known` scoping -- unscoped it refuses both `dynamic`
    #     contracts (pc=None, cb=0, bounded=None, method=NONE), the input of the
    #     A8 negative scenario, which already emit BOUND_KNOWN=0;
    #   * `>= 0`, never `> 0` -- cb == 0 is legitimate and occurs on a bound_known
    #     path (a model with no module-resident constants). Same lesson as D35;
    #   * require is_int, do not merely use it as a precondition to skip.
    if bound_known:
        _pc = r.get("static_per_call_bytes")
        _cb = r.get("module_resident_constant_bytes")
        if not (is_int(_pc) and _pc >= 0 and is_int(_cb) and _cb >= 0):
            raise SystemExit(
                "gen_contract_header: bound_method=%s but resources.static_per_call_bytes %r and "
                "module_resident_constant_bytes %r are not both non-negative integers, so "
                "bounded_bytes %r cannot be cross-checked against the components stated beside it. "
                "'Could not evaluate the identity' is not 'the identity holds'."
                % (method, _pc, _cb, bounded))
        if bounded != _pc + _cb:
            raise SystemExit(
                "gen_contract_header: contract contradicts itself -- resources.bounded_bytes %r != "
                "static_per_call_bytes %r + module_resident_constant_bytes %r (= %r). Refusing to emit a "
                "header whose CONTRACT_BOUNDED_BYTES disagrees with the components stated beside it."
                % (bounded, _pc, _cb, _pc + _cb))
    # R5 (external review v0.19-reframe, E24b): make_contract.py now records
    # which of its escape hatches actually suppressed a refusal
    # (provenance.overrides_applied / .verification_grade). Recording alone is
    # only half the fix: this generator is the single consumer that stands
    # between a contract and a deployable header, and it read NONE of the
    # provenance block -- a contract whose ABI, target triple, ELF binding and
    # one-invocation cross-checks were all waived produced the same header as a
    # fully verified one. Refuse by default; --allow-override-contract is the
    # deliberate, logged opt-out (same pattern as every other gate here).
    #
    # Scope, measured rather than assumed:
    #  * `bound_known` only -- a NONE-bound contract emits KNOWN=0 and is
    #    refused by the C gate anyway; gating it here would refuse the two
    #    `dynamic` contracts that are the INPUT of the A8 negative scenario.
    #  * `isinstance(prov, dict)` only -- contracts/*.json and the OnAIR plugin
    #    fixture carry no provenance block at all; refusing those would break
    #    the smoke test CLAUDE.md documents (defect class (B), the D31 mistake
    #    E23 shipped). They are reported as PROVENANCE_VERIFIED=0 instead.
    #  * an ABSENT verification_grade is NOT read as untrusted -- all 14
    #    archived contracts predate this field (measured: the strict reading
    #    rejects 14/14). Only a grade that is present and not "verified" fails.
    prov = c.get("provenance")
    prov_bad = []
    if bound_known and isinstance(prov, dict):
        _ov = prov.get("overrides_applied")
        _grade = prov.get("verification_grade")
        _si = prov.get("single_invocation")
        if isinstance(_ov, list) and _ov:
            prov_bad.append("provenance.overrides_applied=%s" % (_ov,))
        if _grade is not None and _grade != "verified":
            prov_bad.append("provenance.verification_grade=%r" % (_grade,))
        if _si is not True:
            prov_bad.append("provenance.single_invocation=%r (not a positively verified "
                            "single iree-compile invocation)" % (_si,))
        if prov_bad and not allow_override_contract:
            raise SystemExit(
                "gen_contract_header: refusing to emit a deployable header from a contract whose own "
                "provenance says it was not fully verified: %s. Rebuild the contract without the "
                "--allow-* escape hatch(es), or pass --allow-override-contract to override."
                % "; ".join(prov_bad))
    provenance_verified = bool(bound_known and isinstance(prov, dict) and not prov_bad)

    if not bound_known:
        bounded = None
    # Use the per-invocation worst case (frame + return address + any stack
    # realignment padding the codegen inserted), not the bare callee-save+locals
    # figure -- realignment padding is real stack the task can actually consume
    # (E14 Stage 1, conv2d: 128 B frame vs. 191 B worst-case invocation).
    stack = r.get("kernel_task_stack_invocation_bytes")
    if stack is None:
        stack = r.get("kernel_task_stack_bytes")
    stack_known = is_int(stack)
    # R1 (external review v0.19-reframe, E24b) -- the one finding of that review
    # that is reachable through the NORMAL pipeline, and the only one rated a
    # claim blocker. D13/E15 refuses a negative bounded_bytes but nothing checked
    # the stack figure, and make_contract.py copies it straight out of the
    # --elf-analysis JSON. A negative value then flows into ai_learner.c:201
    #     stack_needed = AI_LEARNER_STACK_BASE_BYTES + CONTRACT_KERNEL_STACK_BYTES
    # so 262144 + (-300000) = -37856. Both operands of the very next line's
    # `es_stack >= stack_needed` are signed `long` (ai_learner.c:198/201, with
    # info.StackSize explicitly cast at :200), so this is a SIGNED comparison and
    # it is true for every possible stack size -- including 0, and including the
    # es_stack = -1 that ai_learner.c leaves in place when CFE_ES_GetAppInfo
    # fails. The D15/E16 stack-refusal branch silently stops enforcing while
    # telemetry still reports accounted=true.
    # (Verified by compiling that exact expression: stack_needed = -37856 and the
    # comparison holds at es_stack in {-1, 0, 1, 16384, 262144, 262335}.)
    # DO NOT remove the (long) cast at ai_learner.c:200 on the strength of an
    # "unsigned" reading -- E24c measured that removing it rejects EVERY stack
    # size, including the correct 262335. Earlier revisions of this comment
    # blamed unsigned promotion; that was wrong (정정 E24c/F5) and is exactly
    # backwards: an unsigned comparison would wrap -37856 to 1.8e19 and REFUSE.
    # No --allow-* escape hatch: unlike "unknown stack", no honest analysis
    # reports a negative byte count. Deliberately `< 0`, never `<= 0` -- stack==0
    # is legitimate (elf_stack_frame.py's `max(..., default=0)` for an ELF with no
    # dispatch functions), and `<= 0` would also reject the two `dynamic`
    # contracts' constants=0. Both were measured as over-rejections.
    if is_int(stack) and stack < 0:
        raise SystemExit("gen_contract_header: refusing negative kernel task stack figure %r "
                         "(resources.kernel_task_stack_invocation_bytes/kernel_task_stack_bytes) -- "
                         "it would make ai_learner.c's stack_needed negative and its stack gate a tautology"
                         % (stack,))
    # F6 (external review, 2026-09): a numeric stack figure is not by itself a
    # trustworthy bound -- elf_stack_frame.py's own classify() says so in its
    # own classification_note ("no static task-stack bound -- revise contract
    # boundary before admission" for bucket_4_unaccounted_dynamic_stack;
    # "callee stack use is not visible in this ELF" for bucket_3/4 unresolved
    # calls), but this generator used to only ask "is it an int", not "did the
    # analysis that produced it say it doesn't trust it". A contract whose
    # kernel_dynamic_stack_alloc=true or kernel_external_call_insns!=0 (or a
    # classification other than none/bucket_2_task_stack_budget) got
    # CONTRACT_KERNEL_STACK_BYTES_KNOWN=1 anyway. Reproduced directly by
    # editing a stored contract to that combination and generating a header.
    # Treat "the analysis itself flagged this as unreliable" the same as
    # "no figure at all" -- same --allow-unknown-stack escape hatch.
    stack_classification = r.get("kernel_stack_classification")
    # N4 (external review v0.18-followup, 2026-09): F6 above asked "did the
    # analysis flag this figure as unreliable" but read all three signals through
    # bool()/`not in (None, ...)`, so a MISSING field was indistinguishable from a
    # field that says "trusted". Deleting only kernel_stack_classification from a
    # stored contract (or setting it to null, or dropping all three keys) produced
    # a byte-identical header with KERNEL_STACK_BYTES_KNOWN=1. Absence of the
    # verdict is not evidence of a trustworthy bound -- it is the same UNKNOWN as
    # an explicit distrust marker (the D25 lesson again). None is deliberately
    # untrusted for all three fields; do not "simplify" these back to bool().
    # make_contract.py always writes all three (a real classification, or the
    # literal "unknown" on the no-ELF path), so no contract this repo produces
    # omits them, and no scoping to bound_known is needed -- the gate below
    # already provides it (a bound_known=0 contract merely degrades to KNOWN=0).
    stack_untrusted = (
        r.get("kernel_dynamic_stack_alloc") is not False
        or r.get("kernel_external_call_insns") != 0
        or stack_classification not in ("none", "bucket_2_task_stack_budget"))
    if stack_untrusted:
        stack_known = False
    # D13/D15 (EVIDENCE_v0.9 SS11.5, SS11.9): a bound-known contract with no
    # kernel stack analysis used to still get a header
    # (CONTRACT_KERNEL_STACK_BYTES_KNOWN=0, CONTRACT_KERNEL_STACK_BYTES=0L)
    # that nothing downstream actually checks -- the admission gate would
    # ADMIT as if the kernel used zero extra stack. Refuse by default; the
    # caller can opt in explicitly (e.g. while iterating on a new model
    # before ELF analysis is wired up) via --allow-unknown-stack.
    if bound_known and not stack_known and not allow_unknown_stack:
        # `and is_int(stack)` (N4): without it the no-ELF-analysis contract shape
        # that make_contract.py itself can produce (stack=None, classification
        # "unknown") hits the "a numeric stack figure is present (None)" branch --
        # a pre-existing diagnostic bug on a reachable path, not one this change
        # introduces. With the guard it gets the correct "no kernel_task_stack_*"
        # message instead.
        if stack_untrusted and is_int(stack):
            raise SystemExit("gen_contract_header: bound_method=%s and a numeric stack figure is present "
                             "(%r), but the ELF analysis flagged it as unreliable (kernel_stack_classification=%r "
                             "kernel_dynamic_stack_alloc=%r kernel_external_call_insns=%r) -- refusing to emit "
                             "a header that would report it as known (pass --allow-unknown-stack to override)"
                             % (method, stack, stack_classification, r.get("kernel_dynamic_stack_alloc"),
                                r.get("kernel_external_call_insns")))
        raise SystemExit("gen_contract_header: bound_method=%s but no kernel_task_stack_invocation_bytes/"
                         "kernel_task_stack_bytes in resources -- refusing to emit a header with an implicit "
                         "0 B kernel stack (pass --allow-unknown-stack to override)" % method)
    entry = v.get("entry") or m.get("entry") or "infer"
    check_shape_agreement(c)          # R3: refuse a self-contradictory contract before picking a side
    in_shape, in_src = shape_from(c, "input", [1, 9])
    out_shape, out_src = shape_from(c, "output", [1, 2])
    n_in = len(i.get("inputs") or []) or 1
    n_out = len(i.get("outputs") or []) or 1
    dtypes = {t2.get("dtype") for t2 in (i.get("inputs") or []) + (i.get("outputs") or [])}
    # N3 (external review v0.18-followup, 2026-09): interface.inputs/outputs are
    # OPTIONAL extensions -- contracts/contract.schema.json requires only the
    # singular interface.input/output, and each of those carries a dtype. Reading
    # dtype exclusively from the plural arrays left `dtypes` EMPTY whenever they
    # were absent, and because both the gate below and CONTRACT_DTYPES_ALL_F32
    # test `dtypes - {"f32"}`, an empty set was indistinguishable from exactly
    # {"f32"} -- so a contract whose only dtype statement said "f16" emitted
    # CONTRACT_DTYPES_ALL_F32=1. Vacuous truth, the same "observed nothing" vs
    # "observed and found none" confusion as D25. Folding the schema-REQUIRED
    # singular dtype into the set closes it for all three variants measured
    # (plural absent, plural empty, plural and singular disagreeing).
    #
    # NOT done here, deliberately: refusing outright when the plural arrays are
    # absent. Measured over-rejection -- contracts/contract.filled.example.json
    # and contract.e13_host.json are honest f32 contracts in exactly the shape
    # this repo's own schema declares, and a refusal would reject the canonical
    # format on the grounds that an UNDECLARED extension is missing.
    # Read the singular dtype from BOTH blocks that can carry it, exactly as
    # shape_from() above already does for shapes: contracts/contract.e14_aarch64.json
    # declares f32 in validity.input/output and has no interface block at all, so
    # looking only at `interface` here would refuse a contract that does state its
    # dtype -- over-rejection, this repo's defect class (B).
    for _blk in (c.get("validity") or {}, i):
        for _sing in ("input", "output"):
            _d = (_blk.get(_sing) or {}).get("dtype")
            if _d is not None:
                dtypes.add(_d)
    if bound_known and not dtypes:
        raise SystemExit("gen_contract_header: bound_method=%s but the contract states no dtype anywhere "
                         "(neither interface.input/output nor interface.inputs/outputs) -- refusing to "
                         "assert CONTRACT_DTYPES_ALL_F32 from an empty observation" % method)
    # D13 (EVIDENCE_v0.9 SS11.9, R3): native_learner.c and ai_learner.c both
    # hardcode a single f32 input and a single f32 output
    # (IREE_HAL_ELEMENT_TYPE_FLOAT_32 literal, one push/pop each) -- neither
    # checks CONTRACT_NUM_INPUTS/OUTPUTS at all. A bound-known contract for a
    # model with a different interface would ADMIT and then fail inside
    # iree_runtime_call_invoke with an argument-count mismatch, or silently
    # misinterpret non-f32 bytes as f32. Refuse at generation time instead --
    # this is the precondition the existing C runtimes already assume.
    if bound_known and (n_in != 1 or n_out != 1 or dtypes - {"f32"}):
        raise SystemExit("gen_contract_header: bound_method=%s but interface is not the single-f32-input/"
                         "single-f32-output shape native_learner.c/ai_learner.c hardcode "
                         "(inputs=%d outputs=%d dtypes=%s)" % (method, n_in, n_out, sorted(dtypes)))
    sha = a["sha256"]
    if len(sha) != 64 or not all(ch in "0123456789abcdefABCDEF" for ch in sha):
        raise SystemExit("artifact.sha256 is not 64 hex chars")

    lines = [
        "/* GENERATED from contract.json -- do not edit */",
        "#ifndef CONTRACT_GEN_H",
        "#define CONTRACT_GEN_H",
        "#define CONTRACT_MODEL_NAME %s" % c_str(name),
        "#define CONTRACT_TARGET_TRIPLE %s" % c_str(triple),
        "#define CONTRACT_BOUND_METHOD %s" % c_str(method),
        "#define CONTRACT_BOUND_KNOWN %d" % (1 if bound_known else 0),
        # R5 (E24b): 1 iff this header came from a contract that carries a
        # provenance block, states a known bound, records no applied override,
        # and positively verified its single-invocation binding. No C code
        # consumes it yet -- deliberately: the two C gates live in binaries this
        # container cannot rebuild (cFS + IREE C runtime), and making the
        # example fixture in contracts/ fail the build would be exactly the
        # over-rejection E23 shipped as D31. Emitted now so the fact travels
        # with the header instead of only with the JSON.
        "#define CONTRACT_PROVENANCE_VERIFIED %d" % (1 if provenance_verified else 0),
        "#define CONTRACT_BOUNDED_BYTES %s" % long_or(bounded),
        "#define CONTRACT_PER_CALL_BYTES %s" % long_or(r.get("static_per_call_bytes") if bound_known else None),
        "#define CONTRACT_CONST_BYTES %s" % long_or(r.get("module_resident_constant_bytes")),
        "#define CONTRACT_KERNEL_STACK_BYTES_KNOWN %d" % (1 if stack_known else 0),
        "#define CONTRACT_KERNEL_STACK_BYTES %s" % long_or(stack if stack_known else 0, 0),
        "#define CONTRACT_ARTIFACT_BYTES %s" % long_or(a["bytes"]),
        "#define CONTRACT_ARTIFACT_SHA256 %s" % c_str(sha),
        "#define CONTRACT_ENTRY %s" % c_str("module." + entry),
        "#define CONTRACT_INPUT_RANK %d" % len(in_shape),
        "#define CONTRACT_INPUT_SHAPE {%s}" % ", ".join(str(d) for d in in_shape),
        "#define CONTRACT_INPUT_ELEMS %d" % (int(math.prod(in_shape)) if all(d >= 0 for d in in_shape) else 0),
        "#define CONTRACT_OUTPUT_RANK %d" % len(out_shape),
        "#define CONTRACT_OUTPUT_SHAPE {%s}" % ", ".join(str(d) for d in out_shape),
        "#define CONTRACT_OUTPUT_ELEMS %d" % (int(math.prod(out_shape)) if all(d >= 0 for d in out_shape) else 0),
        "#define CONTRACT_SHAPES_STATIC %d" % (1 if all(d >= 0 for d in in_shape + out_shape) else 0),
        "#define CONTRACT_NUM_INPUTS %d" % n_in,
        "#define CONTRACT_NUM_OUTPUTS %d" % n_out,
        # F7 (external review, 2026-09): native_learner.c/ai_learner.c's C-level
        # interface gate checked CONTRACT_NUM_INPUTS/OUTPUTS but not dtype --
        # the event message called it a "single-f32" check while the actual
        # condition never referenced f32 at all, because no dtype macro
        # existed for the C code to check. This project generates the header
        # from a validated contract (dtype already refused above if not all
        # f32), so today's normal path is safe -- but a stale or hand-edited
        # contract_gen.h (the exact threat model the C comment names) can have
        # correct counts and wrong dtypes with nothing in C to catch it.
        # N3: `dtypes and` -- an empty dtype set must never assert "all f32".
        "#define CONTRACT_DTYPES_ALL_F32 %d" % (1 if bound_known and dtypes and not (dtypes - {"f32"}) else 0),
        "#define CONTRACT_DRIVER %s" % c_str(v.get("driver", "local-sync")),
        "#endif",
    ]
    with open(out, "w") as f:
        f.write("\n".join(lines) + "\n")
    print("wrote", out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
