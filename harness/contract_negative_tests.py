#!/usr/bin/env python3
"""E15: negative/adversarial test suite for the contract generation toolchain
(harness/static_mem_bound.py, harness/make_contract.py,
harness/gen_contract_header.py), plus a regression check that the fail-closed
changes (D11-D15, docs/EVIDENCE_v0.9_E14_stage1.md SS11.9;
docs/EVIDENCE_v0.10_E15.md) did not change any of the 14 stored contracts or
headers under results/e14_aarch64_qemu/.

Every case in NEGATIVE below is an input that must be REFUSED (non-zero exit,
no output file written). Before D13/D14/D15 several of these were silently
accepted -- see the docstring of each tool for the specific defect. Most of
this file exercises the regex-based tools and pins down "refuses" as an
observable, testable contract of its own. The structural_walker_checks()
group (E18, harness/mlir_alloc_walk.py) is the first slice of the proposal's
"regular MLIR/IREE pass" item -- it independently re-derives the same numbers
via the real Operation/Type API (not text matching) and must agree with the
regex parser on every stored artifact.

Usage: python3 harness/contract_negative_tests.py [--root results/e14_aarch64_qemu]
Exit 0 iff every negative case was refused AND the regression check passed.
"""
import argparse
import copy
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import static_mem_bound as smb  # noqa: E402

PY = sys.executable
MAKE_CONTRACT = os.path.join(HERE, "make_contract.py")
GEN_HEADER = os.path.join(HERE, "gen_contract_header.py")

_structural_available_cache = None


def structural_available():
    """Whether iree.compiler.ir is importable in THIS interpreter -- cached,
    checked once. F9/E22 (external review, 2026-09): E21's F3 fix made
    make_contract.py refuse to write ANY contract by default when this
    package is missing (previously a silent regex-only degrade). That is the
    right default for a real invocation, but it means every subprocess call
    this test file makes to make_contract.py -- most of which are testing
    something else entirely (an ABI mismatch, a stale dump-dir, ...) -- would
    otherwise start failing for an unrelated reason in an environment that
    genuinely lacks the package, rather than skipping cleanly or testing what
    they say they test. Callers pass --allow-missing-structural-checker
    through when this is False so behaviour stays consistent across
    environments; main() reports the environment's actual state once."""
    global _structural_available_cache
    if _structural_available_cache is None:
        rc, out, err = run([PY, "-c", "import iree.compiler.ir"])
        _structural_available_cache = (rc == 0)
    return _structural_available_cache


_iree_tools_cache = None


def iree_tools_available():
    """Whether the iree-base-compiler CONSOLE SCRIPTS are on PATH -- separate
    from structural_available(), which only asks whether the Python module
    imports. D25 (E23): CI's without-deps leg proved these are two different
    questions. A checkout without iree-base-compiler has neither, but a local
    sys.meta_path import block has only the first, which is why the E22
    simulation missed the iree-dump-module crash entirely. Tests that need a
    real compiler tool SKIP (not FAIL) when this is False."""
    global _iree_tools_cache
    if _iree_tools_cache is None:
        _iree_tools_cache = all(shutil.which(t) for t in ("iree-compile", "iree-dump-module"))
    return _iree_tools_cache


_schema_validator_cache = None


def schema_validator_available():
    """Whether `jsonschema` is importable in the interpreter that runs
    make_contract.py. A THIRD independent question from structural_available()
    (the iree.compiler.ir module) and iree_tools_available() (the console
    scripts) -- N6 (external review v0.18-followup, E24) showed CI never
    exercises its absence, because the "without-deps" leg installs jsonschema.
    make_contract.py refuses to write ANY contract without it (E15/D13), so in
    an environment that genuinely lacks it every regeneration case failed for a
    reason unrelated to what it asserts: measured 15 FAILs, 98/113."""
    global _schema_validator_cache
    if _schema_validator_cache is None:
        _schema_validator_cache = (run([PY, "-c", "import jsonschema"])[0] == 0)
    return _schema_validator_cache


def with_structural_override(extra_flags=()):
    """extra_flags, plus whichever --allow-* flags this ENVIRONMENT (not the
    case under test) makes necessary:

      --allow-missing-structural-checker  when iree.compiler.ir is absent (E22)
      --allow-unverified-invocation       when iree-dump-module is absent, so
                                          the .rodata constant confirmation
                                          cannot be evaluated (D25/E23)
      --no-validate                       when jsonschema is absent (N6/E24)

    Each test is then decided by the condition it actually probes -- gated by
    its own --allow-* flag -- and not by an unrelated missing dependency.

    N6 note: degrading here rather than SKIPping the whole regeneration block
    is deliberate. A block-level skip would discard 43 checks that do not need
    jsonschema at all (14 make_contract + 14 structural cross-check + 14 header
    + summary) -- a test suite protecting itself from a false alarm by ceasing
    to look, which is the same failure shape in a harness that a fail-open is
    in a gate. --no-validate provably cannot change contract CONTENT (it gates
    only the validate() call), and the diff-0 result on all 14 archived
    artifacts confirms it."""
    extra_flags = list(extra_flags)
    if not structural_available() and "--allow-missing-structural-checker" not in extra_flags:
        extra_flags.append("--allow-missing-structural-checker")
    if not iree_tools_available() and "--allow-unverified-invocation" not in extra_flags:
        extra_flags.append("--allow-unverified-invocation")
    if not schema_validator_available() and "--no-validate" not in extra_flags:
        extra_flags.append("--no-validate")
    return extra_flags

TARGET_INFO = {
    "aarch64": {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53"},
    "x86_64": {"triple": "x86_64-unknown-linux-gnu", "cpu": "host"},
}


# ----------------------------------------------------------------------------
# small helpers
# ----------------------------------------------------------------------------
class Result:
    # F9/E22 (external review): a genuinely missing prerequisite (this
    # environment lacks iree.compiler.ir) is not the same claim as "this
    # code is broken" -- conflating them either hides real bugs behind an
    # expected-in-some-environments FAIL, or makes an environment without
    # the optional package look permanently red. `skip=True` marks the
    # former; it is excluded from both the pass and fail counts in main()'s
    # summary and prints as SKIP, never FAIL.
    def __init__(self, name, ok, detail="", skip=False):
        self.name = name
        self.ok = ok
        self.detail = detail
        self.skip = skip

    def __repr__(self):
        status = "SKIP" if self.skip else ("PASS" if self.ok else "FAIL")
        return "%-6s %-70s %s" % (status, self.name, self.detail)


def run(cmd, **kw):
    r = subprocess.run(cmd, capture_output=True, text=True, **kw)
    return r.returncode, r.stdout, r.stderr


def load(path):
    with open(path) as f:
        return json.load(f)


def write_json(obj, path):
    with open(path, "w") as f:
        json.dump(obj, f, indent=2)
    return path


# ----------------------------------------------------------------------------
# in-process unit checks on static_mem_bound.parse_alloc_ir (D13 R2)
# ----------------------------------------------------------------------------
def unit_tests(root):
    results = []
    layout = os.path.join(root, "aarch64", "layout_ir", "conv2d.layout_ir.txt")
    if not os.path.isfile(layout):
        return [Result("unit: layout IR fixture present", False, "missing %s" % layout)]
    ir = open(layout).read()
    base = smb.parse_alloc_ir(ir, entry="infer")
    results.append(Result("unit: baseline conv2d parse has no unresolved",
                          base["entry_found"] and not base["unresolved"],
                          str(base["unresolved"])))

    # R2 exact repro: a line break inside one op's own syntax must not drop
    # the allocation -- before the fix this made outputs/transient_slabs
    # silently vanish while unresolved stayed empty.
    for label, needle, repl in [
        ("line-break in 'alloca uninitialized on('", "uninitialized on(", "uninitialized\n      on("),
        ("line-break before resource-type operand", "=> !stream.resource<transient>",
         "=>\n        !stream.resource<transient>"),
    ]:
        mod = ir.replace(needle, repl, 1)
        got = smb.parse_alloc_ir(mod, entry="infer")
        ok = (got["outputs"] == base["outputs"] and got["transient_slabs"] == base["transient_slabs"]
             and not got["unresolved"])
        results.append(Result("unit: %s recovers correct sizes (not silently dropped)" % label,
                              ok, str({"outputs": got["outputs"], "transient_slabs": got["transient_slabs"],
                                      "unresolved": got["unresolved"]})))

    # R2/D13: an unrecognized resource-producing op in the entry body must be
    # flagged (fail-closed), not ignored.
    mod = ir.replace("stream.resource.dealloca", "stream.resource.totally_new_verb_from_a_future_iree", 1)
    got = smb.parse_alloc_ir(mod, entry="infer")
    results.append(Result("unit: unrecognized op in entry body -> unresolved (fail-closed)",
                          any("totally_new_verb" in u for u in got["unresolved"]), str(got["unresolved"])))

    # entry not found must propagate into all_static at the CLI aggregation
    # level (D12): a whole-file fallback parse must not be reported as a
    # clean static bound.
    mod = re.sub(r"@infer\b", "@not_infer_at_all", ir)
    got = smb.parse_alloc_ir(mod, entry="infer")
    all_static_standalone = got["entry_found"] and len(got["unresolved"]) == 0
    results.append(Result("unit: entry not found -> entry_found False, all_static False (D12)",
                          (not got["entry_found"]) and (not all_static_standalone),
                          "entry_found=%s" % got["entry_found"]))
    return results


# ----------------------------------------------------------------------------
# gen_contract_header.py negative cases (D13 R3/R3b)
# ----------------------------------------------------------------------------
def header_negative_cases(root, tmp):
    base_path = os.path.join(root, "aarch64", "contracts", "contract.mlp16k.aarch64.json")
    if not os.path.isfile(base_path):
        return [Result("header: fixture contract present", False, "missing %s" % base_path)]
    base = load(base_path)
    results = []

    def try_mutation(name, mutate):
        c = copy.deepcopy(base)
        mutate(c)
        cpath = os.path.join(tmp, "hdr_%s.json" % re.sub(r"\W+", "_", name))
        hpath = cpath[:-5] + ".h"
        write_json(c, cpath)
        rc, out, err = run([PY, GEN_HEADER, cpath, hpath])
        refused = rc != 0 and not os.path.exists(hpath)
        results.append(Result("header-neg: %s -> refused" % name, refused,
                              "rc=%d wrote_header=%s stderr=%s" % (rc, os.path.exists(hpath), err.strip()[:160])))

    # sanity: the unmodified fixture must NOT be refused (else the negative
    # tests below would be vacuous)
    cpath = os.path.join(tmp, "hdr_sanity.json")
    hpath = cpath[:-5] + ".h"
    write_json(base, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath])
    results.append(Result("header-neg: unmodified fixture is ACCEPTED (sanity)", rc == 0 and os.path.exists(hpath),
                          "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    try_mutation("negative bounded_bytes", lambda c: c["resources"].__setitem__("bounded_bytes", -10))
    try_mutation("bounded_bytes = -1", lambda c: c["resources"].__setitem__("bounded_bytes", -1))
    try_mutation("unsupported bound_method (string)",
                lambda c: c["resources"].__setitem__("bound_method", "UNSUPPORTED"))
    try_mutation("lowercase bound_method 'none' (not the schema's 'NONE')",
                lambda c: c["resources"].__setitem__("bound_method", "none"))
    try_mutation("missing kernel stack fields on a bound-known contract",
                lambda c: (c["resources"].pop("kernel_task_stack_invocation_bytes", None),
                          c["resources"].pop("kernel_task_stack_bytes", None)))
    try_mutation("multi-input interface (native/cFS runtimes hardcode single f32 in/out)",
                lambda c: c["interface"].__setitem__(
                    "inputs", c["interface"]["inputs"] + [dict(c["interface"]["inputs"][0])]))
    try_mutation("non-f32 dtype",
                lambda c: c["interface"]["inputs"].__setitem__(
                    0, dict(c["interface"]["inputs"][0], dtype="i8")))
    try_mutation("artifact.sha256 not hex", lambda c: c["artifact"].__setitem__(
        "sha256", "g" * 64))
    try_mutation("artifact.sha256 wrong length", lambda c: c["artifact"].__setitem__(
        "sha256", "abcd"))

    # --allow-unknown-stack must still let the missing-stack case through
    c = copy.deepcopy(base)
    c["resources"].pop("kernel_task_stack_invocation_bytes", None)
    c["resources"].pop("kernel_task_stack_bytes", None)
    cpath = os.path.join(tmp, "hdr_allow_unknown_stack.json")
    hpath = cpath[:-5] + ".h"
    write_json(c, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath, "--allow-unknown-stack"])
    results.append(Result("header-neg: missing stack + --allow-unknown-stack -> accepted (explicit override)",
                          rc == 0 and os.path.exists(hpath), "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    # F6 (external review, 2026-09): a NUMERIC stack figure whose own analysis
    # flags it as unreliable (dynamic alloca, unresolved external calls, or a
    # classification other than none/bucket_2) used to still get
    # CONTRACT_KERNEL_STACK_BYTES_KNOWN=1 -- only "is it an int" was checked,
    # not "did elf_stack_frame.py's own classify() trust it". Each of the
    # three untrusted signals must independently refuse (int stack value kept
    # unchanged, so the ONLY thing making these bad is the flag).
    try_mutation("stack figure present but kernel_dynamic_stack_alloc=true (F6)",
                lambda c: c["resources"].__setitem__("kernel_dynamic_stack_alloc", True))
    try_mutation("stack figure present but kernel_external_call_insns!=0 (F6)",
                lambda c: c["resources"].__setitem__("kernel_external_call_insns", 1))
    try_mutation("stack figure present but kernel_stack_classification=bucket_4_unaccounted_dynamic_stack (F6)",
                lambda c: c["resources"].__setitem__("kernel_stack_classification",
                                                      "bucket_4_unaccounted_dynamic_stack"))
    # N4 (external review v0.18-followup, E24): F6 above checked the three
    # signals only when they were PRESENT and said something bad. A missing
    # signal was read as "trusted" -- all four of these were silently accepted
    # with KERNEL_STACK_BYTES_KNOWN=1 before E24 (revert-and-confirm-fail).
    try_mutation("stack figure present but kernel_stack_classification key ABSENT (N4)",
                lambda c: c["resources"].pop("kernel_stack_classification", None))
    try_mutation("stack figure present but kernel_stack_classification=null (N4)",
                lambda c: c["resources"].__setitem__("kernel_stack_classification", None))
    try_mutation("stack figure present but all three trust signals ABSENT (N4)",
                lambda c: [c["resources"].pop(k, None) for k in
                           ("kernel_stack_classification", "kernel_dynamic_stack_alloc", "kernel_external_call_insns")])
    try_mutation("stack figure present but kernel_external_call_insns ABSENT (N4)",
                lambda c: c["resources"].pop("kernel_external_call_insns", None))

    # N3 (external review v0.18-followup, E24): dtype was read ONLY from the
    # optional plural interface.inputs/outputs arrays, so an empty dtype set was
    # indistinguishable from exactly {"f32"} and CONTRACT_DTYPES_ALL_F32 came out
    # 1 for an f16 contract. The pre-existing "non-f32 dtype" case at L234 only
    # mutates the plural array, which is why it never caught any of these three.
    def _strip_plural_f16(c):
        c["interface"].pop("inputs", None)
        c["interface"].pop("outputs", None)
        c["interface"]["input"]["dtype"] = "f16"
        c["interface"]["output"]["dtype"] = "f16"
        (c.get("validity") or {}).get("input", {}).pop("dtype", None)
        (c.get("validity") or {}).get("output", {}).pop("dtype", None)
    try_mutation("interface.inputs/outputs ABSENT and singular dtype=f16 (N3)", _strip_plural_f16)

    def _empty_plural_f16(c):
        c["interface"]["inputs"] = []
        c["interface"]["outputs"] = []
        c["interface"]["input"]["dtype"] = "f16"
        c["interface"]["output"]["dtype"] = "f16"
        (c.get("validity") or {}).get("input", {}).pop("dtype", None)
        (c.get("validity") or {}).get("output", {}).pop("dtype", None)
    try_mutation("interface.inputs/outputs EMPTY and singular dtype=f16 (N3)", _empty_plural_f16)

    def _singular_contradicts(c):
        # plural still says f32; the schema-REQUIRED singular field says f16
        c["interface"]["input"]["dtype"] = "f16"
    try_mutation("singular interface.input dtype=f16 contradicts plural f32 (N3)", _singular_contradicts)

    # R1 (external review v0.19-reframe, E24b) — the only finding of that review
    # reachable through the NORMAL pipeline, and the only one rated a claim
    # blocker. A negative stack figure made ai_learner.c's
    # `stack_needed = BASE + KERNEL` negative, and since CFE_ES_AppInfo_t.StackSize
    # is unsigned, `es_stack >= stack_needed` became true for EVERY stack size
    # including 0 — the D15/E16 refusal branch stopped enforcing while telemetry
    # still said accounted=true.
    try_mutation("negative kernel_task_stack_invocation_bytes (R1)",
                lambda c: c["resources"].__setitem__("kernel_task_stack_invocation_bytes", -300000))

    def _neg_stack_bytes(c):
        c["resources"]["kernel_task_stack_invocation_bytes"] = None
        c["resources"]["kernel_task_stack_bytes"] = -5
    try_mutation("negative kernel_task_stack_bytes (R1)", _neg_stack_bytes)

    # R2 (E24b): bounded_bytes was sign/type-checked (D13) but never compared with
    # the components the same contract states. Both directions matter — too small
    # is a fail-open (ADMIT where the honest value refuses), inflated is a class-B
    # over-rejection of a legitimate model.
    try_mutation("bounded_bytes smaller than its own components (R2)",
                lambda c: c["resources"].__setitem__("bounded_bytes", 1))
    try_mutation("bounded_bytes inflated beyond its own components (R2)",
                lambda c: c["resources"].__setitem__("bounded_bytes", 999999999))

    # R3 (E24b): shape_from() is a fallback chain, never a comparison, so a
    # contract stating two different shapes silently emitted the validity one.
    # Not reachable from the production path (make_contract.py fills both blocks
    # from the same object) — defense in depth.
    try_mutation("interface.input shape contradicts validity.input (R3)",
                lambda c: c["interface"]["input"].__setitem__("shape", [1, 4, 4, 1]))
    try_mutation("validity.input shape contradicts interface.input (R3)",
                lambda c: c["validity"]["input"].__setitem__("shape", [1, 4, 4, 1]))

    # R1 over-rejection guard (load-bearing): stack == 0 is LEGITIMATE —
    # elf_stack_frame.py's `max(..., default=0)` produces it for an ELF with no
    # dispatch functions. This pins the gate at `< 0` and stops a future
    # "<= 0" over-correction, which was measured to also reject the two `dynamic`
    # contracts (constants == 0), the A8 scenario inputs.
    c = copy.deepcopy(base)
    c["resources"]["kernel_task_stack_invocation_bytes"] = 0
    c["resources"]["kernel_task_stack_bytes"] = 0
    c["resources"]["kernel_stack_classification"] = "none"
    cpath = os.path.join(tmp, "hdr_stack_zero_ok.json")
    hpath = cpath[:-5] + ".h"
    write_json(c, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath])
    results.append(Result("header: stack == 0 with classification 'none' -> accepted (R1 over-rejection guard)",
                          rc == 0 and os.path.isfile(hpath), "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    # N3, the other direction: a contract that states its dtype in validity.*
    # rather than interface.* must still be ACCEPTED (contracts/contract.e14_aarch64.json
    # is exactly this shape). Refusing it would be over-rejection, defect class (B).
    c = copy.deepcopy(base)
    c["interface"].pop("inputs", None)
    c["interface"].pop("outputs", None)
    c["interface"].pop("input", None)
    c["interface"].pop("output", None)
    cpath = os.path.join(tmp, "hdr_dtype_from_validity.json")
    hpath = cpath[:-5] + ".h"
    write_json(c, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath])
    ok = rc == 0 and os.path.isfile(hpath) and "CONTRACT_DTYPES_ALL_F32 1" in open(hpath).read()
    results.append(Result("header: dtype stated only in validity.* (not interface.*) -> accepted (N3, over-rejection guard)",
                          ok, "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    # --allow-unknown-stack must still let the untrusted-classification case
    # through too (same override, now covering both "absent" and "untrusted").
    c = copy.deepcopy(base)
    c["resources"]["kernel_dynamic_stack_alloc"] = True
    cpath = os.path.join(tmp, "hdr_allow_untrusted_stack.json")
    hpath = cpath[:-5] + ".h"
    write_json(c, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath, "--allow-unknown-stack"])
    results.append(Result("header-neg: untrusted stack (F6) + --allow-unknown-stack -> accepted (explicit override)",
                          rc == 0 and os.path.exists(hpath), "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    # F7 (external review, 2026-09): the C interface gate claimed to check
    # "single-f32" but had no dtype macro to check at all -- confirm the new
    # CONTRACT_DTYPES_ALL_F32 macro is actually emitted, and is 0 for the
    # existing non-f32-dtype negative case above (not just refused before
    # reaching macro emission, which the "non-f32 dtype" mutation already
    # covers by refusing outright -- this checks the ACCEPTED, f32 case emits
    # the macro as 1 so the C-level check in ai_learner.c/native_learner.c has
    # something real to test).
    cpath = os.path.join(tmp, "hdr_dtype_macro_sanity.json")
    hpath = cpath[:-5] + ".h"
    write_json(base, cpath)
    rc, out, err = run([PY, GEN_HEADER, cpath, hpath])
    macro_present = rc == 0 and os.path.isfile(hpath) and "CONTRACT_DTYPES_ALL_F32 1" in open(hpath).read()
    results.append(Result("header-neg: CONTRACT_DTYPES_ALL_F32 emitted as 1 for an all-f32 contract (F7)",
                          macro_present, "rc=%d" % rc))
    return results


# ----------------------------------------------------------------------------
# make_contract.py negative cases (D13/D14, R3/R5)
# ----------------------------------------------------------------------------
def make_contract_negative_cases(root, tmp):
    results = []
    aarch64_dir = os.path.join(root, "aarch64")
    if not os.path.isdir(aarch64_dir):
        return [Result("make_contract: fixture directory present", False, "missing %s" % aarch64_dir)]

    def invocation(model, tgt="aarch64"):
        inv_path = os.path.join(root, tgt, "vmfb", "%s.invocation.json" % model)
        return load(inv_path)

    def base_cmd(model, tgt, layout_ir, dump_dir, out, elf_analysis=None, extra_flags=()):
        inv = invocation(model, tgt)
        ti = TARGET_INFO[tgt]
        cmd = [PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv["vmfb"],
              "--layout-ir", layout_ir, "--dump-dir", dump_dir, "--triple", ti["triple"], "--cpu", ti["cpu"],
              "--model-name", model, "--out", out, "--no-validate",
              "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
        if elf_analysis:
            cmd[cmd.index("--out"):cmd.index("--out")] = ["--elf-analysis", elf_analysis]
        # F9/E22: pass --allow-missing-structural-checker through when this
        # environment lacks iree.compiler.ir, so these cases keep testing
        # what they say they test (an ABI mismatch, a stale dump-dir, ...)
        # instead of incidentally failing for an unrelated reason (E21's F3
        # made a missing structural checker hard-fail by default). Each
        # case's OWN --allow-* flag (if any) is unaffected -- this only
        # suppresses that one, unrelated failure reason.
        extra_flags = with_structural_override(extra_flags)
        # make_contract.py's parse_args() takes EVERYTHING after a bare
        # --extra-args verbatim (it's the iree-compile flags of the
        # invocation) -- any of our own --allow-* flags must go BEFORE it or
        # they silently become iree-compile args instead of reaching argparse.
        extra_args_idx = cmd.index("--extra-args")
        return cmd[:extra_args_idx] + list(extra_flags) + cmd[extra_args_idx:]

    def try_case(name, model, tgt, layout_ir, dump_dir, elf_analysis=None, extra_flags=()):
        out = os.path.join(tmp, "mc_%s.json" % re.sub(r"\W+", "_", name))
        cmd = base_cmd(model, tgt, layout_ir, dump_dir, out, elf_analysis, extra_flags)
        rc, o, err = run(cmd)
        refused = rc != 0 and not os.path.exists(out)
        results.append(Result("make_contract-neg: %s -> refused" % name, refused,
                              "rc=%d wrote=%s stderr=%s" % (rc, os.path.exists(out), err.strip()[:200])))

    # sanity: real, matched conv2d artifacts must be ACCEPTED
    inv = invocation("conv2d")
    dump_dir = os.path.join(aarch64_dir, "dump", "conv2d")
    elf_json = os.path.join(aarch64_dir, "elf", "conv2d.elf_analysis.json")
    out = os.path.join(tmp, "mc_sanity.json")
    if os.path.isdir(dump_dir) and os.path.isfile(elf_json):
        cmd = base_cmd("conv2d", "aarch64", inv["layout_ir"], dump_dir, out, elf_json)
        rc, o, err = run(cmd)
        results.append(Result("make_contract-neg: matched conv2d artifacts ACCEPTED (sanity)",
                              rc == 0 and os.path.exists(out), "rc=%d stderr=%s" % (rc, err.strip()[:200])))
    else:
        results.append(Result("make_contract-neg: conv2d fixtures present", False,
                              "missing dump_dir or elf_json"))

    # D14: stale layout IR from a DIFFERENT model's compile, wrong dump-dir
    # binding. conv2d has 3 dispatches (infer_dispatch_0/1/2); mlp16k's
    # dump-dir only has files for infer_dispatch_0/1. Feeding conv2d's
    # layout IR against mlp16k's dump-dir must be refused because
    # infer_dispatch_2 has no file there -- the OLD checks (embedded-ELF
    # sha256, mlir-basename-in-dump-dir) do not look at layout IR content at
    # all and would not catch this on their own.
    mlp_dump = os.path.join(aarch64_dir, "dump", "mlp16k")
    conv2d_layout = os.path.join(aarch64_dir, "layout_ir", "conv2d.layout_ir.txt")
    if os.path.isdir(mlp_dump) and os.path.isfile(conv2d_layout):
        try_case("stale layout IR (conv2d layout IR + mlp16k dump-dir, D14)",
                 "conv2d", "aarch64", conv2d_layout, mlp_dump)
    else:
        results.append(Result("make_contract-neg: D14 fixture present", False, "missing mlp16k dump-dir"))

    # D13/R3: ABI declaration mismatch -- edit a copy of the layout IR so its
    # iree.abi.declaration disagrees with the (unedited) MLIR source
    # signature.
    if os.path.isfile(inv["layout_ir"]):
        ir_text = open(inv["layout_ir"]).read()
        m = re.search(r'iree\.abi\.declaration = "(sync|async) func @infer\(([^)]*)\)', ir_text)
        if m:
            edited = ir_text.replace(m.group(0), m.group(0).replace(m.group(2), m.group(2) + ", tensor<1xf32>"), 1)
            edited_path = os.path.join(tmp, "conv2d_abi_mismatch.layout_ir.txt")
            with open(edited_path, "w") as f:
                f.write(edited)
            try_case("ABI declaration disagrees with MLIR source (R3)",
                     "conv2d", "aarch64", edited_path, dump_dir, elf_json)
        else:
            results.append(Result("make_contract-neg: ABI fixture present", False,
                                  "iree.abi.declaration pattern not found in layout IR"))

    # D13/R3: target-triple arch mismatch -- copy the dump-dir with an edited
    # codegen.ll target triple line.
    if os.path.isdir(dump_dir):
        triple_dump = os.path.join(tmp, "triple_mismatch_dump")
        if os.path.isdir(triple_dump):
            shutil.rmtree(triple_dump)
        shutil.copytree(dump_dir, triple_dump)
        for fn in os.listdir(triple_dump):
            if fn.endswith(".codegen.ll"):
                p = os.path.join(triple_dump, fn)
                txt = open(p).read()
                txt2 = re.sub(r'target triple = "aarch64-[^"]+"', 'target triple = "x86_64-unknown-linux-gnu"', txt)
                if txt2 != txt:
                    with open(p, "w") as f:
                        f.write(txt2)
        try_case("codegen.ll triple arch disagrees with --triple (R3)",
                 "conv2d", "aarch64", inv["layout_ir"], triple_dump, elf_json)

    # D13/R3: elf-analysis JSON that analysed a DIFFERENT ELF than the one
    # embedded in the vmfb (elf_sha256 does not match).
    if os.path.isfile(elf_json):
        bad_elf = copy.deepcopy(load(elf_json))
        bad_elf["elf_sha256"] = "0" * 64
        bad_elf_path = os.path.join(tmp, "conv2d_bad_elf_analysis.json")
        write_json(bad_elf, bad_elf_path)
        try_case("elf-analysis analysed a different ELF than embedded in vmfb (R3)",
                 "conv2d", "aarch64", inv["layout_ir"], dump_dir, bad_elf_path)

    # regression: dump-dir belonging to a different model entirely (the
    # PRE-EXISTING mlir-basename check, D10) must still be caught.
    if os.path.isdir(mlp_dump):
        try_case("dump-dir belongs to a different model (D10 regression)",
                 "conv2d", "aarch64", inv["layout_ir"], mlp_dump, elf_json)

    # F1 (external review, 2026-09): an empty --dump-dir makes every
    # one-invocation signal None ("could not evaluate") rather than False
    # ("verified mismatch") -- the old checks only ever caught False, so this
    # used to write a fully "valid" contract with single_invocation=false and
    # not one note explaining why. Must now be refused by default, and
    # writable only with the matching --allow-unverified-invocation override.
    empty_dump = os.path.join(tmp, "f1_empty_dump")
    os.makedirs(empty_dump, exist_ok=True)
    if not iree_tools_available():
        # D25 (E23): --allow-unverified-invocation is the very flag under test
        # here, and it is also the flag this environment needs for an unrelated
        # reason (no iree-dump-module -> the .rodata confirmation is unevaluable
        # too). The two conditions cannot be separated without the real tools,
        # so report SKIP rather than a pass that would hold for the wrong reason.
        results.append(Result("make_contract-neg: empty --dump-dir refused by default + override (F1)",
                              True, "needs iree-dump-module to isolate from the D25 condition", skip=True))
    else:
        try_case("--dump-dir is empty, one-invocation signals unverifiable (F1)",
                 "conv2d", "aarch64", inv["layout_ir"], empty_dump, elf_json)
        out = os.path.join(tmp, "f1_override.json")
        cmd = base_cmd("conv2d", "aarch64", inv["layout_ir"], empty_dump, out, elf_json,
                       extra_flags=("--allow-unverified-invocation",))
        rc, o, err = run(cmd)
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        results.append(Result("make_contract-neg: --allow-unverified-invocation overrides the empty --dump-dir (F1)",
                              rc == 0 and c is not None and c["provenance"]["single_invocation"] is False,
                              "rc=%d stderr=%s" % (rc, err.strip()[:200])))

    # N2 (external review v0.18-followup, E24): F1 above closed only the EMPTY
    # --dump-dir. A non-empty dump dir merely missing the linked executable
    # leaves dump_elf_in_vmfb None, which no branch caught -- exit 0, empty
    # notes, single_invocation=false, and a byte-identical deployable header.
    # Reachable without hand-editing: compiling with the component
    # --iree-hal-dump-executable-{sources,intermediates}-to flags instead of the
    # meta flag --iree-hal-dump-executable-files-to produces exactly this shape.
    if not iree_tools_available():
        results.append(Result("make_contract-neg: dump-dir without linked ELF refused (N2)",
                              True, "needs iree-dump-module to isolate from the D25 condition", skip=True))
    else:
        noso_dump = os.path.join(tmp, "n2_dump_no_elf")
        if os.path.isdir(noso_dump):
            shutil.rmtree(noso_dump)
        shutil.copytree(os.path.join(root, "aarch64", "dump", "conv2d"), noso_dump)
        for fn in os.listdir(noso_dump):
            if fn.endswith(".so") or fn.endswith(".elf"):
                os.remove(os.path.join(noso_dump, fn))
        try_case("--dump-dir has files but no linked ELF, vmfb binding unverifiable (N2)",
                 "conv2d", "aarch64", inv["layout_ir"], noso_dump, elf_json)
        # ESCALATION: the same partial dump dir paired with a DIFFERENT model's
        # vmfb -- this is the D10 hole re-opened through the None path, and it is
        # what makes N2 a fail-open rather than only a bookkeeping gap.
        inv_mlp = invocation("mlp16k", "aarch64")
        out = os.path.join(tmp, "n2_escalation.json")
        ti = TARGET_INFO["aarch64"]
        cmd = ([PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv_mlp["vmfb"],
                "--layout-ir", inv["layout_ir"], "--dump-dir", noso_dump, "--triple", ti["triple"],
                "--cpu", ti["cpu"], "--model-name", "conv2d", "--out", out, "--no-validate"]
               + list(with_structural_override(()))
               + ["--extra-args", "--mlir-elide-elementsattrs-if-larger=16"])
        rc, o, err = run(cmd)
        results.append(Result("make_contract-neg: partial dump-dir + WRONG model's vmfb -> refused (N2 escalation, D10 via None)",
                              rc != 0 and not os.path.exists(out),
                              "rc=%d wrote=%s stderr=%s" % (rc, os.path.exists(out), err.strip()[:200])))
        # the override must still work, and must now RECORD why in provenance.notes
        out = os.path.join(tmp, "n2_override.json")
        cmd = base_cmd("conv2d", "aarch64", inv["layout_ir"], noso_dump, out, elf_json,
                       extra_flags=("--allow-unverified-invocation",))
        rc, o, err = run(cmd)
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        noted = bool(c) and any("one-invocation signal not verified" in n for n in c["provenance"]["notes"])
        results.append(Result("make_contract-neg: --allow-unverified-invocation overrides it AND records a note (N2)",
                              rc == 0 and c is not None and c["provenance"]["single_invocation"] is False and noted,
                              "rc=%d noted=%s stderr=%s" % (rc, noted, err.strip()[:160])))

        # N1 (external review v0.18-followup, E24): D25 refuses "could not observe
        # the artifact-side constant total", but the STRONGER negative evidence --
        # observed and CONTRADICTS the IR total -- was only written into a note.
        # Reproduced with a fake iree-dump-module on PATH that reports one .rodata
        # segment as 1 B instead of the real 2176 B (the observer is faked, not the
        # observed, because the real tool cannot be made to disagree with a healthy
        # artifact without editing the artifact).
        fake_bin = os.path.join(tmp, "n1_fakebin")
        os.makedirs(fake_bin, exist_ok=True)
        real_dump = shutil.which("iree-dump-module")
        shim = os.path.join(fake_bin, "iree-dump-module")
        with open(shim, "w") as fh:
            fh.write("#!%s\nimport re, subprocess, sys\n"
                     "r = subprocess.run([%r] + sys.argv[1:], capture_output=True, text=True)\n"
                     "sys.stdout.write(re.sub(r'(\\.rodata\\[\\s*0\\]\\s+embedded\\s+)2176( bytes)', r'\\g<1>   1\\g<2>', r.stdout))\n"
                     "sys.stderr.write(r.stderr); sys.exit(r.returncode)\n" % (PY, real_dump))
        os.chmod(shim, 0o755)
        env = dict(os.environ, PATH=fake_bin + os.pathsep + os.environ.get("PATH", ""))
        out = os.path.join(tmp, "n1_contradiction.json")
        cmd = base_cmd("conv2d", "aarch64", inv["layout_ir"], os.path.join(root, "aarch64", "dump", "conv2d"),
                       out, elf_json)
        rc, o, err = run(cmd, env=env)
        results.append(Result("make_contract-neg: artifact .rodata CONTRADICTS module_resident_constant_bytes -> refused (N1)",
                              rc != 0 and not os.path.exists(out),
                              "rc=%d wrote=%s stderr=%s" % (rc, os.path.exists(out), err.strip()[:200])))
        out = os.path.join(tmp, "n1_override.json")
        cmd = base_cmd("conv2d", "aarch64", inv["layout_ir"], os.path.join(root, "aarch64", "dump", "conv2d"),
                       out, elf_json, extra_flags=("--allow-unconfirmed-constants",))
        rc, o, err = run(cmd, env=env)
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        noted = bool(c) and any("CONTRADICTED" in n for n in c["provenance"]["notes"])
        results.append(Result("make_contract-neg: --allow-unconfirmed-constants overrides it AND records a note (N1)",
                              rc == 0 and c is not None and noted, "rc=%d noted=%s" % (rc, noted)))
        # N1, the other direction (over-rejection guard): a model with ZERO
        # module-resident constants must STILL build. subset_sum_match returns a
        # plain False for "nothing to confirm", so the review's literal
        # prescription (refuse whenever confirmed is not True) makes both shipped
        # `dynamic` contracts -- the input of the A8 UNKNOWN_BOUND scenario --
        # unbuildable. Measured: 2 of 14 refused. This case pins that carve-out.
        inv_dyn = invocation("dynamic", "aarch64")
        out = os.path.join(tmp, "n1_zero_consts.json")
        cmd = base_cmd("dynamic", "aarch64", inv_dyn["layout_ir"],
                       os.path.join(root, "aarch64", "dump", "dynamic"), out)
        rc, o, err = run(cmd)
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        zero_const = bool(c) and c["resources"]["module_resident_constant_bytes"] == 0
        results.append(Result("make_contract: zero-constant model still builds (N1 over-rejection guard, A8 input)",
                              rc == 0 and zero_const, "rc=%d const=%s stderr=%s"
                              % (rc, c and c["resources"]["module_resident_constant_bytes"], err.strip()[:160])))

    # R1 producer side (external review v0.19-reframe, E24b): the negative stack
    # figure enters as a TOOL OUTPUT, not as a hand-edited contract —
    # make_contract.py hashed the --elf-analysis file and matched its elf_sha256
    # against the vmfb, but never questioned its numbers. A stale, hand-written or
    # third-party analysis JSON therefore produced a schema-valid contract whose
    # header disabled the cFS stack gate. This is what makes R1 reachable through
    # the normal pipeline rather than by tampering with a stored contract.
    if os.path.isfile(elf_json):
        bad_elf = os.path.join(tmp, "r1_elf_neg.json")
        ej = load(elf_json)
        ej["max_dispatch_invocation_stack_bytes"] = -300000
        write_json(ej, bad_elf)
        try_case("--elf-analysis reports a negative task stack figure (R1)",
                 "conv2d", "aarch64", inv["layout_ir"], os.path.join(root, "aarch64", "dump", "conv2d"), bad_elf)

    # N6 (external review v0.18-followup, E24): E15/D13 made make_contract.py
    # refuse to write anything when jsonschema is missing, but NOTHING tested
    # that branch -- both existing make_contract negative cases pass
    # --no-validate, and CI's "without-deps" leg installs jsonschema, so the
    # condition was never exercised anywhere. Block the import with a stub
    # MODULE on PYTHONPATH (not a sitecustomize.py, which would shadow whatever
    # sitecustomize the host python installs).
    if not (iree_tools_available() and structural_available() and schema_validator_available()):
        results.append(Result("make_contract-neg: jsonschema absent -> refuses to write (N6, E15/D13 branch)",
                              True, "needs the full toolchain to isolate this one condition", skip=True))
    else:
        nojs = os.path.join(tmp, "n6_nojsonschema")
        os.makedirs(nojs, exist_ok=True)
        with open(os.path.join(nojs, "jsonschema.py"), "w") as fh:
            fh.write("raise ImportError('jsonschema blocked (E24/N6 regression test)')\n")
        env = dict(os.environ, PYTHONPATH=nojs + os.pathsep + os.environ.get("PYTHONPATH", ""))
        out = os.path.join(tmp, "n6_nojs.json")
        ti = TARGET_INFO["aarch64"]
        cmd = [PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv["vmfb"],
               "--layout-ir", inv["layout_ir"], "--dump-dir", os.path.join(root, "aarch64", "dump", "conv2d"),
               "--triple", ti["triple"], "--cpu", ti["cpu"], "--model-name", "conv2d",
               "--elf-analysis", elf_json, "--out", out,
               "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
        rc, o, err = run(cmd, env=env)
        results.append(Result("make_contract-neg: jsonschema absent -> refuses to write (N6, E15/D13 branch)",
                              rc != 0 and not os.path.exists(out) and "schema validation" in err.lower(),
                              "rc=%d wrote=%s stderr=%s" % (rc, os.path.exists(out), err.strip()[-140:])))

    # F2 (external review, 2026-09): iree.abi.declaration being ENTIRELY
    # ABSENT from the layout IR used to only add a note, unlike a declaration
    # that disagrees with the source (handled above, hard fail by default) --
    # an asymmetry between "no reflection to check against" and "reflection
    # disagrees" that let the contract trust the source signature alone with
    # no compiler cross-check at all. Must now be refused by default too.
    if os.path.isfile(inv["layout_ir"]):
        ir_text = open(inv["layout_ir"]).read()
        no_abi = re.sub(r',?\s*iree\.reflection = \{iree\.abi\.declaration = "[^"]*"\}', "", ir_text)
        if no_abi != ir_text and "iree.abi.declaration" not in no_abi:
            no_abi_path = os.path.join(tmp, "conv2d_no_abi.layout_ir.txt")
            with open(no_abi_path, "w") as f:
                f.write(no_abi)
            try_case("iree.abi.declaration entirely absent from layout IR (F2)",
                     "conv2d", "aarch64", no_abi_path, dump_dir, elf_json)
            out = os.path.join(tmp, "f2_override.json")
            cmd = base_cmd("conv2d", "aarch64", no_abi_path, dump_dir, out, elf_json,
                           extra_flags=("--allow-missing-abi-declaration",))
            rc, o, err = run(cmd)
            results.append(Result("make_contract-neg: --allow-missing-abi-declaration overrides the absence (F2)",
                                  rc == 0 and os.path.exists(out), "rc=%d stderr=%s" % (rc, err.strip()[:200])))
        else:
            results.append(Result("make_contract-neg: F2 fixture present (abi declaration removable)", False,
                                  "could not cleanly remove iree.abi.declaration from layout IR"))
    return results


# ----------------------------------------------------------------------------
# E19: make_contract.py's structural (mlir_alloc_walk) cross-check must
# actually hard-fail the CLI when the two independent extractors disagree, or
# when the structural one cannot parse the IR at all. There is no real fixture
# that makes iree.compiler.ir and the regex parser disagree on a well-formed
# layout IR (that is the point -- E18/EVIDENCE_v0.13 SS3 found none in 14/14),
# so this calls make_contract.build_contract() in-process and monkeypatches
# mlir_alloc_walk.parse_alloc_ir_structural to simulate exactly the two
# conditions the hard-fail branch (harness/make_contract.py, "structural
# cross-check" block) exists to catch. This exercises the SAME hard_fail_errors
# / SystemExit path the ABI/triple/ELF-analysis mismatch cases above already
# prove works -- what's new here is confirming this specific branch actually
# reaches it.
# ----------------------------------------------------------------------------
def structural_hard_fail_cases(root):
    results = []
    aarch64_dir = os.path.join(root, "aarch64")
    inv_path = os.path.join(aarch64_dir, "vmfb", "conv2d.invocation.json")
    dump_dir = os.path.join(aarch64_dir, "dump", "conv2d")
    elf_json = os.path.join(aarch64_dir, "elf", "conv2d.elf_analysis.json")
    if not (os.path.isfile(inv_path) and os.path.isdir(dump_dir) and os.path.isfile(elf_json)):
        return [Result("structural-hard-fail: conv2d fixtures present", False, "missing input file(s)")]
    inv = load(inv_path)

    try:
        sys.path.insert(0, HERE)
        import make_contract as mc
    except Exception as e:
        return [Result("structural-hard-fail: make_contract importable", False, str(e)[:200])]

    def args(allow_structural_mismatch=False, allow_missing_structural_checker=False):
        return argparse.Namespace(
            mlir=inv["mlir"], vmfb=inv["vmfb"], layout_ir=inv["layout_ir"], dump_dir=dump_dir,
            triple=TARGET_INFO["aarch64"]["triple"], cpu=TARGET_INFO["aarch64"]["cpu"],
            model_name="conv2d", entry="infer", driver="local-sync", profile=None,
            elf_analysis=elf_json, runtime_commit=None,
            allow_abi_mismatch=False, allow_triple_mismatch=False, allow_elf_analysis_mismatch=False,
            allow_missing_abi_declaration=False,
            # D25 (E23): environment-driven, not case-under-test -- see with_structural_override()
            allow_unverified_invocation=not iree_tools_available(),
            allow_structural_mismatch=allow_structural_mismatch,
            allow_missing_structural_checker=allow_missing_structural_checker,
        )

    def run_build(allow_structural_mismatch=False, allow_missing_structural_checker=False):
        try:
            c = mc.build_contract(args(allow_structural_mismatch, allow_missing_structural_checker), [])
            return True, None, c
        except SystemExit as e:
            return False, str(e), None

    # E19 code review finding #11: the "iree.compiler.ir not installed" path
    # (EVIDENCE_v0.14_E19.md SS4) was checked by hand during the E19 session
    # but had no repeatable test -- and this function's OWN prerequisite check
    # below (bailing out when the real package is missing) meant that in an
    # environment lacking iree.compiler.ir, this whole test group would report
    # FAILURES instead of verifying the behaviour that matters there. Test it
    # directly by replacing mc.maw itself (not just parse_alloc_ir_structural)
    # with a stand-in whose `ir` attribute is None -- exactly what happens
    # when the import at the top of make_contract.py fails -- independent of
    # whether the real package happens to be installed in THIS test run.
    #
    # F3 (external review, 2026-09): make_contract.py's default changed --
    # this project calls the structural cross-check MANDATORY, so a missing
    # checker is now refused by default too (previously it silently degraded
    # to regex-only, which the review correctly pointed out made "mandatory"
    # an overstatement). Confirm BOTH directions: default refuses, and the
    # explicit --allow-missing-structural-checker override still degrades
    # gracefully with the number correctly computed by the regex path alone.
    orig_maw = mc.maw

    class _FakeUnavailableMaw:
        ir = None
        _IMPORT_ERROR = "simulated: iree.compiler.ir not installed"

    try:
        mc.maw = _FakeUnavailableMaw()
        ok, err, c = run_build(allow_missing_structural_checker=False)
        results.append(Result("structural-hard-fail: iree.compiler.ir unavailable -> refused by default (F3)",
                              not ok, err or "wrote a contract despite a missing structural checker"))

        ok2, err2, c2 = run_build(allow_missing_structural_checker=True)
        bounded = c2["resources"]["bounded_bytes"] if c2 else None
        results.append(Result("structural-hard-fail: --allow-missing-structural-checker overrides, degrades gracefully",
                              ok2 and bounded is not None, "ok=%s err=%s bounded_bytes=%s" % (ok2, err2, bounded)))
        avail = c2["provenance"]["structural_walker"]["available"] if c2 else None
        results.append(Result("structural-hard-fail: degrade path records available=False (not silently omitted)",
                              avail is False, "available=%s" % avail))
    finally:
        mc.maw = orig_maw

    if mc.maw is None or getattr(mc.maw, "ir", None) is None:
        results.append(Result("structural-hard-fail: remaining cases (structural/regex disagreement, etc.)",
                              True, "skipped: iree.compiler.ir not installed in this environment", skip=True))
        return results

    orig_fn = mc.maw.parse_alloc_ir_structural

    # sanity: unpatched, matched conv2d artifacts must still be ACCEPTED
    # in-process (proves the monkeypatch technique itself, not just its target).
    ok, err, _ = run_build()
    results.append(Result("structural-hard-fail: unpatched conv2d ACCEPTED (sanity)", ok, err or ""))

    try:
        def fake_mismatch(ir_text, entry):
            real = dict(orig_fn(ir_text, entry))
            real["inputs"] = [x + 1 for x in real["inputs"]] if real["inputs"] else [999999]
            return real
        mc.maw.parse_alloc_ir_structural = fake_mismatch
        ok, err, _ = run_build(allow_structural_mismatch=False)
        results.append(Result("structural-hard-fail: structural/regex disagreement on inputs -> refused",
                              not ok, err or "wrote a contract despite disagreement"))
        ok2, err2, _ = run_build(allow_structural_mismatch=True)
        results.append(Result("structural-hard-fail: --allow-structural-mismatch overrides the disagreement",
                              ok2, err2 or ""))
    finally:
        mc.maw.parse_alloc_ir_structural = orig_fn

    # E19 review finding #7 (test-gap): the only diff kind exercised above is
    # "inputs" -- constants(sum) was never simulated, which is exactly the
    # branch that had the dense_sum/const_b bug (see the "structural
    # (non-regex) cross-check" comment in make_contract.py). Force a genuine
    # constants(sum) mismatch (not just a value that happens to differ from
    # dense_sum but still equals const_b, which the padding regression case
    # below covers) and confirm it is still caught.
    try:
        def fake_constants_mismatch(ir_text, entry):
            real = dict(orig_fn(ir_text, entry))
            real["constants"] = [sum(real.get("constants", [])) + 999999]
            return real
        mc.maw.parse_alloc_ir_structural = fake_constants_mismatch
        ok, err, _ = run_build(allow_structural_mismatch=False)
        results.append(Result("structural-hard-fail: structural/regex disagreement on constants(sum) -> refused",
                              not ok, err or "wrote a contract despite disagreement"))
    finally:
        mc.maw.parse_alloc_ir_structural = orig_fn

    # E19 review finding #4 (test-gap): dispatches is explicitly informational
    # (does not gate bound_method, see make_contract.py) -- confirm a
    # dispatches-only difference does NOT trigger a hard fail, so a future
    # change that accidentally starts comparing it cannot go unnoticed either.
    try:
        def fake_dispatches_only(ir_text, entry):
            real = dict(orig_fn(ir_text, entry))
            real["dispatches"] = real.get("dispatches", 0) + 1
            return real
        mc.maw.parse_alloc_ir_structural = fake_dispatches_only
        ok, err, c = run_build(allow_structural_mismatch=False)
        diffs = c["provenance"]["structural_walker"]["diffs"] if c else None
        results.append(Result("structural-hard-fail: dispatches-only difference does NOT refuse (informational)",
                              ok and diffs == [], "ok=%s err=%s diffs=%s" % (ok, err, diffs)))
    finally:
        mc.maw.parse_alloc_ir_structural = orig_fn

    try:
        def fake_raise(ir_text, entry):
            raise RuntimeError("simulated: layout IR printer format changed in a future IREE version")
        mc.maw.parse_alloc_ir_structural = fake_raise
        ok, err, _ = run_build(allow_structural_mismatch=False)
        results.append(Result("structural-hard-fail: structural parser exception -> refused",
                              not ok, err or "wrote a contract despite a structural-parse exception"))
        # E19 review finding #5 (test-gap): the override was tested for the
        # disagreement branch above but not for this exception branch.
        ok2, err2, _ = run_build(allow_structural_mismatch=True)
        results.append(Result("structural-hard-fail: --allow-structural-mismatch overrides a parse exception too",
                              ok2, err2 or ""))
    finally:
        mc.maw.parse_alloc_ir_structural = orig_fn

    # confirm the monkeypatch was fully undone (no cross-test leakage)
    ok, err, _ = run_build()
    results.append(Result("structural-hard-fail: monkeypatch restored, conv2d ACCEPTED again", ok, err or ""))
    return results


# ----------------------------------------------------------------------------
# E19 code review (2026-09): two real false-hard-fail bugs in the first
# version of make_contract.py's structural cross-check, both confirmed by
# reproduction against REAL stored layout IR text (surgical, targeted edits --
# same methodology as the ABI/triple-mismatch cases in
# make_contract_negative_cases(), not hand-mangling into something no real
# compiler would emit):
#   Bug A: the cross-check compared `structural` against `whole`
#          (smb.parse_alloc_ir on the raw file, which assumes the entry
#          function's LAST print in the file is its most-lowered one) instead
#          of `p` (chosen by lowering_score, independent of file order --
#          what the contract's numbers actually come from). Any layout IR
#          where the lowered print happens NOT to be last in the file (this
#          module's own docstring says print order depends on thread
#          scheduling) would false-hard-fail even though the structural
#          extractor and the ACTUAL contract value fully agree.
#   Bug B: the constants(sum) comparison used `dense_sum` (raw per-tensor
#          sum) instead of `const_b` (packed_sum when nonzero, else
#          dense_sum -- the value the contract actually reports). The
#          structural extractor's constants sum tracks the PACKED
#          stream.resource.alloc size, so any model with nonzero constant
#          packing padding/dedup would false-hard-fail forever.
# Both fixed by comparing against p/const_b instead of whole/dense_sum (see
# make_contract.py). These tests reproduce the exact failing condition
# against a REAL stored fixture and confirm the fix accepts it.
# ----------------------------------------------------------------------------
def structural_bugfix_regression_cases(root, tmp):
    results = []
    try:
        sys.path.insert(0, HERE)
        import make_contract as mc
    except Exception as e:
        return [Result("structural-bugfix: make_contract importable", False, str(e)[:200])]
    if mc.maw is None or getattr(mc.maw, "ir", None) is None:
        return [Result("structural-bugfix: bugs A and B regression cases",
                       True, "skipped: iree.compiler.ir not installed in this environment", skip=True)]

    aarch64_dir = os.path.join(root, "aarch64")

    def run_cli(model, layout_ir, dump_dir, elf_json, out, extra_flags=()):
        inv = load(os.path.join(aarch64_dir, "vmfb", "%s.invocation.json" % model))
        ti = TARGET_INFO["aarch64"]
        cmd = [PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv["vmfb"],
              "--layout-ir", layout_ir, "--dump-dir", dump_dir, "--triple", ti["triple"], "--cpu", ti["cpu"],
              "--model-name", model, "--out", out, "--no-validate",
              "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"] + list(extra_flags)
        return run(cmd)

    # ---- Bug A: physically swap the two @infer print chunks in a real,
    # unedited stored layout IR (conv2d, whose entry function is printed
    # twice at different lowering states -- confirmed via
    # provenance.entry_print_states_differ=true in the stored contract).
    # Nothing in the chunks themselves changes, only their order in the file
    # -- simulating exactly the thread-scheduling-dependent print order this
    # project's own docstring (make_contract.py, top) warns about.
    conv2d_layout = os.path.join(aarch64_dir, "layout_ir", "conv2d.layout_ir.txt")
    conv2d_dump = os.path.join(aarch64_dir, "dump", "conv2d")
    conv2d_elf = os.path.join(aarch64_dir, "elf", "conv2d.elf_analysis.json")
    if os.path.isfile(conv2d_layout) and os.path.isdir(conv2d_dump) and os.path.isfile(conv2d_elf):
        text = open(conv2d_layout, encoding="utf-8", errors="replace").read()
        headers = list(mc.DUMP_HEADER_RE.finditer(text))
        segs = [text[h.start():(headers[i + 1].start() if i + 1 < len(headers) else len(text))]
               for i, h in enumerate(headers)]
        # each seg is HEADER-LINE + body; the entry function signature is the
        # body's first line, not the header's (matches make_contract.py's own
        # split_dumps()-based chunk classification, which strips the header
        # before checking).
        infer_idx = [i for i, s in enumerate(segs)
                    if re.match(r"(util\.func|func\.func)\s+public\s+@infer\b", s[len(headers[i].group(0)):].lstrip())]
        if len(infer_idx) >= 2 and headers:
            a_idx, b_idx = infer_idx[0], infer_idx[1]
            swapped = list(segs)
            swapped[a_idx], swapped[b_idx] = swapped[b_idx], swapped[a_idx]
            swapped_text = text[:headers[0].start()] + "".join(swapped)
            swapped_path = os.path.join(tmp, "conv2d_swapped_print_order.layout_ir.txt")
            with open(swapped_path, "w") as f:
                f.write(swapped_text)
            out = os.path.join(tmp, "bugfix_bugA_conv2d.json")
            rc, o, err = run_cli("conv2d", swapped_path, conv2d_dump, conv2d_elf, out)
            accepted = rc == 0 and os.path.isfile(out)
            results.append(Result("structural-bugfix(A): print-order-swapped conv2d layout IR still ACCEPTED",
                                  accepted, "rc=%d stderr=%s" % (rc, err.strip()[:300])))
            if accepted:
                c = load(out)
                sw = c["provenance"]["structural_walker"]
                results.append(Result("structural-bugfix(A): structural cross-check agrees despite reordering",
                                      sw.get("available") is True and sw.get("agrees_with_regex_parser") is True,
                                      str(sw)))
                orig_layout_ir = load(os.path.join(aarch64_dir, "vmfb", "conv2d.invocation.json"))["layout_ir"]
                orig_out = os.path.join(tmp, "bugfix_bugA_conv2d_orig.json")
                rc0, o0, err0 = run_cli("conv2d", orig_layout_ir, conv2d_dump, conv2d_elf, orig_out)
                if rc0 == 0 and os.path.isfile(orig_out):
                    same_bound = load(orig_out)["resources"]["bounded_bytes"] == c["resources"]["bounded_bytes"]
                    results.append(Result("structural-bugfix(A): bounded_bytes unchanged by the reorder",
                                          same_bound, "orig=%s swapped=%s"
                                          % (load(orig_out)["resources"]["bounded_bytes"], c["resources"]["bounded_bytes"])))
        else:
            results.append(Result("structural-bugfix(A): conv2d has >=2 @infer print chunks (prerequisite)",
                                  False, "found %d" % len(infer_idx)))
    else:
        results.append(Result("structural-bugfix(A): conv2d fixtures present", False, "missing dump_dir or elf_json"))

    # ---- Bug B: edit ONLY the packed constant-buffer size (every occurrence
    # of the SAME symbolic constant that sizes #util.composite/
    # stream.resource.alloc/stream.file.read/stream.resource.subview for the
    # packed buffer) in a real stored layout IR (mlp16k), leaving the
    # per-tensor dense declarations untouched -- simulating 64-byte alignment
    # padding on the packed buffer (packed_sum > dense_sum), a case
    # make_contract.py's own packed_constant_buffers()/dense_sum machinery
    # already anticipates (see the "packed constant buffers ... smaller than
    # the dense constant sum" note) but the structural cross-check did not.
    mlp_layout = os.path.join(aarch64_dir, "layout_ir", "mlp16k.layout_ir.txt")
    mlp_dump = os.path.join(aarch64_dir, "dump", "mlp16k")
    mlp_elf = os.path.join(aarch64_dir, "elf", "mlp16k.elf_analysis.json")
    if os.path.isfile(mlp_layout) and os.path.isdir(mlp_dump) and os.path.isfile(mlp_elf):
        text = open(mlp_layout, encoding="utf-8", errors="replace").read()
        m = re.search(r"#util\.composite<(\d+)xi8", text)
        if m:
            packed_orig = int(m.group(1))
            padded = packed_orig + 64
            # every occurrence of "%c<packed_orig>" and the bare packed size
            # literal that sizes the SAME packed buffer -- NOT the per-tensor
            # dense declarations a few lines above, which use different
            # symbol names/sizes entirely (see grep confirming this in the
            # E19 review's reproduction).
            padded_text = re.sub(r"\b%%c%d\b" % packed_orig, "%%c%d" % padded, text)
            padded_text = padded_text.replace("#util.composite<%dxi8" % packed_orig,
                                              "#util.composite<%dxi8" % padded)
            padded_text = re.sub(r"\barith\.constant %d :" % packed_orig, "arith.constant %d :" % padded, padded_text)
            if padded_text == text:
                results.append(Result("structural-bugfix(B): packed-size edit actually changed the fixture "
                                      "(prerequisite)", False, "no occurrences substituted"))
            else:
                padded_path = os.path.join(tmp, "mlp16k_padded_constants.layout_ir.txt")
                with open(padded_path, "w") as f:
                    f.write(padded_text)
                out = os.path.join(tmp, "bugfix_bugB_mlp16k.json")
                rc, o, err = run_cli("mlp16k", padded_path, mlp_dump, mlp_elf, out)
                accepted = rc == 0 and os.path.isfile(out)
                results.append(Result("structural-bugfix(B): packing-padded mlp16k layout IR still ACCEPTED",
                                      accepted, "rc=%d stderr=%s" % (rc, err.strip()[:300])))
                if accepted:
                    c = load(out)
                    r = c["resources"]
                    sw = c["provenance"]["structural_walker"]
                    correct_bound = (r.get("module_resident_constant_bytes") == padded
                                    and r.get("module_resident_constant_dense_sum_bytes") == packed_orig)
                    results.append(Result("structural-bugfix(B): contract reports the PADDED (packed) size, "
                                          "not the pre-pad dense sum",
                                          correct_bound, "module_resident_constant_bytes=%s dense_sum_bytes=%s"
                                          % (r.get("module_resident_constant_bytes"),
                                             r.get("module_resident_constant_dense_sum_bytes"))))
                    results.append(Result("structural-bugfix(B): structural cross-check agrees on the padded size",
                                          sw.get("available") is True and sw.get("agrees_with_regex_parser") is True,
                                          str(sw)))
        else:
            results.append(Result("structural-bugfix(B): mlp16k has a #util.composite constant buffer (prerequisite)",
                                  False, "pattern not found"))
    else:
        results.append(Result("structural-bugfix(B): mlp16k fixtures present", False, "missing dump_dir or elf_json"))

    return results


# ----------------------------------------------------------------------------
# regression: the 14 stored contracts/headers must not change (D13-D15 must
# be a fail-CLOSED tightening, not a change to any currently-valid contract)
# ----------------------------------------------------------------------------
IGNORE_PROVENANCE_KEYS = {
    "entry_print_used_chunk_index", "entry_print_used_sha256", "entry_print_used_is_last",
    "layout_ir_sha256", "layout_ir_dump_count", "entry_prints_in_dump", "entry_print_states_differ",
    # N2 (E24): two signals that D14 computed and then discarded are now persisted
    # in provenance. The 14 stored contracts predate them, so like the E19
    # structural_walker fields they are new *recorded facts*, not changed values --
    # every number in the regeneration still has to match exactly.
    "layout_dispatch_names", "layout_dispatches_in_dump",
}
# E19: provenance.structural_walker is a field the 14 stored (pre-E19) contracts
# never had -- comparing it leaf-by-leaf against IGNORE_PROVENANCE_KEYS by bare
# name would risk colliding with unrelated same-named leaves elsewhere in the
# contract (e.g. resources.dispatches), so the whole subtree is excluded from
# the "contract unchanged" diff by path instead, and checked separately below
# (asserting it is actually present and agrees, not just absent from the diff).
IGNORE_PROVENANCE_SUBTREES = {"structural_walker"}


def flatten(d, prefix=()):
    if isinstance(d, dict):
        for k, v in d.items():
            yield from flatten(v, prefix + (k,))
    else:
        yield prefix, d


def regression_check(root, tmp):
    results = []
    # D25 (E23): regenerating a stored contract byte-for-byte needs the real
    # compiler tools (iree-compile --version fills validity.compiler*,
    # iree-dump-module fills executable_format_in_artifact/vm_bytecode_bytes).
    # Without them the regenerated contract legitimately differs from the
    # fixture in those fields -- an environment difference, not a regression --
    # so this is a SKIP, never a FAIL.
    if not iree_tools_available():
        return [Result("regression: 14/14 contract+header regeneration",
                       True, "iree-compile/iree-dump-module not on PATH", skip=True)]
    models = ["mlp16k", "mlp16k_swap", "conv2d", "conv2d_swap", "multibranch", "multibranch_swap", "dynamic"]
    n_ok = 0
    n_total = 0
    for tgt in ("aarch64", "x86_64"):
        ti = TARGET_INFO[tgt]
        for model in models:
            n_total += 1
            inv_path = os.path.join(root, tgt, "vmfb", "%s.invocation.json" % model)
            contract_path = os.path.join(root, tgt, "contracts", "contract.%s.%s.json" % (model, tgt))
            hdr_path = os.path.join(root, tgt, "headers", "contract_gen.%s.h" % model)
            if not (os.path.isfile(inv_path) and os.path.isfile(contract_path) and os.path.isfile(hdr_path)):
                results.append(Result("regression: %s/%s fixtures present" % (tgt, model), False, "missing file(s)"))
                continue
            inv = load(inv_path)
            dump_dir = os.path.join(root, tgt, "dump", model)
            elf_json = os.path.join(root, tgt, "elf", "%s.elf_analysis.json" % model)
            new_contract = os.path.join(tmp, "regress.%s.%s.json" % (model, tgt))
            # F9/E22: pass --allow-missing-structural-checker through when this
            # environment lacks iree.compiler.ir, so the regression check can
            # still run (reduced verification -- see the availability-aware
            # assertion below) instead of every contract failing to write at
            # all for a reason unrelated to what this check tests.
            cmd = [PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv["vmfb"], "--layout-ir", inv["layout_ir"],
                  "--dump-dir", dump_dir, "--triple", ti["triple"], "--cpu", ti["cpu"], "--model-name", model,
                  "--elf-analysis", elf_json] + with_structural_override() + [
                  "--out", new_contract,
                  "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
            rc, o, err = run(cmd)
            if rc != 0:
                # N6/E24: the label must not claim schema validation ran when this
                # environment has no jsonschema (with_structural_override then
                # degrades to --no-validate rather than letting all 14 fail).
                results.append(Result("regression: %s/%s make_contract succeeds%s"
                                      % (tgt, model, " (incl. schema validation)" if schema_validator_available()
                                         else " (schema validation unavailable here)"), False,
                                      "rc=%d stderr=%s" % (rc, err.strip()[:200])))
                continue
            old = dict(flatten(load(contract_path)))
            new = dict(flatten(load(new_contract)))
            # F9/E22: when this environment lacks iree.compiler.ir, the
            # regenerated contract's provenance.notes legitimately gains one
            # extra entry (the structural-checker-unavailable note) that the
            # stored fixture -- generated in an environment that HAD the
            # package -- does not have. That is a real, expected difference
            # given the environment mismatch, not a regression in the numbers
            # this check exists to catch; skip the "notes" leaf only in that
            # case (structural_walker's own subtree is still separately
            # asserted above via the availability-aware Result).
            ignore_keys = IGNORE_PROVENANCE_KEYS | ({"notes"} if not structural_available() else set())
            diffs = [(k, old.get(k), new.get(k)) for k in set(old) | set(new)
                    if k[-1] not in ignore_keys and not (set(k) & IGNORE_PROVENANCE_SUBTREES)
                    and old.get(k) != new.get(k)]
            ok = not diffs
            if ok:
                n_ok += 1
            results.append(Result("regression: %s/%s contract unchanged" % (tgt, model), ok,
                                  "" if ok else "%d field(s) differ, e.g. %s" % (len(diffs), diffs[:3])))
            # E19: make_contract.py now wires mlir_alloc_walk in as a mandatory
            # cross-check (see harness/make_contract.py's "structural (non-regex)
            # cross-check" block) -- assert it actually ran and agreed on every
            # regenerated contract, through the real production entry point
            # (not just the standalone call structural_walker_checks() below makes).
            avail = new.get(("provenance", "structural_walker", "available"))
            agree = new.get(("provenance", "structural_walker", "agrees_with_regex_parser"))
            if structural_available():
                results.append(Result("regression: %s/%s structural cross-check ran and agreed" % (tgt, model),
                                      avail is True and agree is True,
                                      "available=%s agrees_with_regex_parser=%s" % (avail, agree)))
            else:
                results.append(Result("regression: %s/%s structural cross-check skipped (iree.compiler.ir unavailable in this environment)" % (tgt, model),
                                      avail is False, "available=%s" % avail))
            if not ok:
                continue
            new_hdr = os.path.join(tmp, "regress.%s.%s.h" % (model, tgt))
            rc2, o2, err2 = run([PY, GEN_HEADER, new_contract, new_hdr])
            hdr_ok = rc2 == 0 and os.path.isfile(new_hdr) and open(new_hdr).read() == open(hdr_path).read()
            results.append(Result("regression: %s/%s header unchanged" % (tgt, model), hdr_ok,
                                  "" if hdr_ok else "rc=%d stderr=%s" % (rc2, err2.strip()[:160])))
    results.append(Result("regression: summary", n_ok == n_total, "%d/%d contracts unchanged" % (n_ok, n_total)))
    return results


# ----------------------------------------------------------------------------
# E18: structural (MLIR API, non-regex) walker cross-check (harness/mlir_alloc_walk.py)
# ----------------------------------------------------------------------------
def structural_walker_checks(root):
    results = []
    try:
        import mlir_alloc_walk as maw
    except Exception as e:
        return [Result("structural: mlir_alloc_walk importable", False, str(e)[:200])]
    if maw.ir is None:
        # F9/E22: this whole group needs iree.compiler.ir to exist at all --
        # not installed is an environment fact, not a bug in this repo. One
        # clean SKIP beats 16 misleading FAILs (14 models + whitelist test +
        # F5 test) that would otherwise report a failure this environment
        # cannot fix by fixing the code.
        return [Result("structural: mlir_alloc_walk structural checks",
                       True, "skipped: iree.compiler.ir not installed in this environment", skip=True)]

    models = ["mlp16k", "mlp16k_swap", "conv2d", "conv2d_swap", "multibranch", "multibranch_swap", "dynamic"]
    for tgt in ("aarch64", "x86_64"):
        for model in models:
            f = os.path.join(root, tgt, "layout_ir", "%s.layout_ir.txt" % model)
            if not os.path.isfile(f):
                results.append(Result("structural: %s/%s fixture present" % (tgt, model), False, "missing %s" % f))
                continue
            text = open(f, encoding="utf-8", errors="replace").read()
            try:
                structural = maw.parse_alloc_ir_structural(text, "infer")
            except Exception as e:
                results.append(Result("structural: %s/%s extraction succeeds" % (tgt, model), False, str(e)[:200]))
                continue
            regex_based = smb.parse_alloc_ir(text, "infer")
            # E19 code review: this diff logic used to be reimplemented here,
            # in make_contract.py, and in mlir_alloc_walk.py's own
            # --cross-check -- all three independently, and two of them had
            # the same latent bug (comparing against the wrong constants
            # reference). Now there is exactly one implementation
            # (maw.diff_against_regex); this call mirrors the CLI's own
            # default (no constants_reference override) since this test is
            # validating the standalone tool, not make_contract.py's
            # production wiring (see structural_hard_fail_cases() below for
            # that).
            diffs = maw.diff_against_regex(structural, regex_based)
            results.append(Result("structural: %s/%s agrees with regex parser" % (tgt, model), not diffs,
                                  "" if not diffs else "disagree on %s" % diffs))

    # fail-closed: an op the walker's registry does not recognize must be
    # reported unresolved, not silently skipped -- tested honestly by
    # narrowing the real registry (KNOWN_ENTRY_OPS), which is exactly the
    # D13 scenario (a syntactically valid op this tool's whitelist lacks),
    # rather than hand-mangling MLIR text into something no real compiler
    # would ever emit.
    conv2d_ir = os.path.join(root, "aarch64", "layout_ir", "conv2d.layout_ir.txt")
    if os.path.isfile(conv2d_ir):
        text = open(conv2d_ir).read()
        orig = maw.KNOWN_ENTRY_OPS
        try:
            maw.KNOWN_ENTRY_OPS = orig - {"stream.resource.dealloca"}
            r = maw.parse_alloc_ir_structural(text, "infer")
            results.append(Result("structural: op removed from whitelist -> unresolved (fail-closed)",
                                  any("dealloca" in u for u in r["unresolved"]), str(r["unresolved"])))
        except Exception as e:
            # F9 (external review, 2026-09): this call was the one spot in this
            # function without an except around parse_alloc_ir_structural -- in
            # an environment genuinely missing iree.compiler.ir, the
            # RuntimeError _require_bindings() raises propagated uncaught out
            # of this whole function, killing main() before it ever printed a
            # summary (confirmed: contract_negative_tests.py died with a raw
            # traceback and zero PASS/FAIL lines, not a clean FAIL count).
            results.append(Result("structural: op removed from whitelist -> unresolved (fail-closed)",
                                  False, "exception: %s" % str(e)[:200]))
        finally:
            maw.KNOWN_ENTRY_OPS = orig

    # F5 (external review, 2026-09): stream.resource.pack's non-constant
    # index operands used to be silently dropped instead of going to
    # unresolved (the sibling stream.tensor.import / stream.resource.alloca
    # branches both use the symmetric "bucket if ok else unresolved" pattern;
    # only pack was missing the else). Real IREE Stream_ResourcePackOp
    # assembly syntax (verified against iree-org/iree upstream
    # StreamOps.td/resource_ops.mlir, not guessed) with one constant slice
    # size and one non-constant (arith.addi of a block argument) -- current
    # corpus has none of this op so this is the only coverage for it.
    pack_ir = '''
module {
  util.func public @infer(%arg0: index) -> index {
    %c128 = arith.constant 128 : index
    %c64 = arith.constant 64 : index
    %nonconst = arith.addi %arg0, %c64 : index
    %0:3 = stream.resource.pack offset(%c128) slices({
      [0, 9] = %c64,
      [3, 8] = %nonconst,
    }) : index
    util.return %0#0 : index
  }
}
'''
    if maw.ir is None:
        results.append(Result("structural: stream.resource.pack non-constant slice size -> unresolved (F5)",
                              False, "iree.compiler.ir not importable in this environment"))
        return results
    try:
        ctx = maw.ir.Context()
        mod = maw.ir.Module.parse(pack_ir, ctx)
        entries = maw._find_entry_candidates(mod.operation, "infer")
        r = maw._extract_from_entry(entries[0]) if entries else None
        ok = bool(r) and any("addi" in u or "non_constant" in u for u in r.get("unresolved", []))
        results.append(Result("structural: stream.resource.pack non-constant slice size -> unresolved (F5)",
                              ok, str(r) if r else "entry @infer not found"))
    except Exception as e:
        results.append(Result("structural: stream.resource.pack non-constant slice size -> unresolved (F5)",
                              False, "exception: %s" % str(e)[:200]))
    return results


# ----------------------------------------------------------------------------
# E23 (external review F8 + F10): A5a/A5b corruption methods are real, named,
# deterministic code (harness/corrupt_vmfb.py) and the OnAIR plugin's
# contract<->artifact binding gate (plugins/compiled_learner/artifact_binding.py)
# refuses exactly what native_learner.c / the cFS app refuse.
# ----------------------------------------------------------------------------
def workflow_yaml_cases():
    """E24: every .github/workflows/*.yml must actually parse.

    A broken workflow file is the one defect CI structurally cannot report as a
    test failure -- the run dies before any step, showing the file path instead
    of the workflow name, so a reader scanning for "which test failed" finds
    nothing. E24 shipped exactly that: a `run:` step whose plain scalar
    contained ": " (a YAML mapping separator) inside a Python string, which
    invalidated the whole file. Same class as D24/D25 -- the harness could not
    see a condition it was supposed to cover.

    SKIPs when PyYAML is absent (it is not in requirements.txt and this check is
    not worth adding a dependency for; GitHub's own parser remains the authority).
    """
    root = os.path.join(os.path.dirname(HERE), ".github", "workflows")
    if not os.path.isdir(root):
        return []
    try:
        import yaml                                            # noqa: PLC0415 - optional probe
    except ImportError:
        return [Result("workflow-yaml: .github/workflows/*.yml parse", True,
                       "PyYAML not installed (not a repo dependency)", skip=True)]
    results = []
    for fn in sorted(os.listdir(root)):
        if not fn.endswith((".yml", ".yaml")):
            continue
        try:
            d = yaml.safe_load(open(os.path.join(root, fn)))
            ok = isinstance(d, dict) and bool(d.get("name")) and bool(d.get("jobs"))
            detail = "name=%r jobs=%s" % (d.get("name") if isinstance(d, dict) else None,
                                          sorted((d or {}).get("jobs", {})) if isinstance(d, dict) else None)
        except Exception as e:                                 # noqa: BLE001 - any parse error is the defect
            ok, detail = False, "%s: %s" % (type(e).__name__, str(e).replace("\n", " ")[:160])
        results.append(Result("workflow-yaml: %s parses and declares name+jobs" % fn, ok, detail))
    return results


def default_plugin_fixture_cases():
    """N5 (external review v0.18-followup, E24): the SHIPPED OnAIR fixture must
    pass the very gate E23 added for it.

    Deliberately a standalone, stdlib-only function rather than a case inside
    artifact_binding_and_corruption_cases(): that one imports corrupt_vmfb /
    e14_cfs_scenarios and early-returns when the E14 vmfb fixtures are absent,
    so a case placed there would be silently skipped in exactly the
    dependency-free environment where this check is the only one covering the
    plugin. E23's own unit tests used the E14 contracts, which is why they
    passed while the shipped fixture -- whose contract predates artifact.bytes
    -- was refused on the default path: defect class (B), over-rejection.
    """
    results = []
    d = os.path.join(os.path.dirname(HERE), "plugins", "compiled_learner", "runtime")
    cpath = os.path.join(d, "contract.json")
    if not os.path.isfile(cpath):
        return [Result("plugin-fixture: default contract present", False, "missing %s" % cpath)]
    sys.path.insert(0, os.path.join(os.path.dirname(HERE), "plugins", "compiled_learner"))
    import artifact_binding as ab
    c = load(cpath)
    vmfb = os.path.join(d, c["artifact"]["file"])
    try:
        v = ab.verify_artifact_binding(c, vmfb)
        ok, detail = v["verdict"] == "MATCH", "verdict=%s sha=%s" % (v["verdict"], v["artifact_sha256"][:16])
    except Exception as e:                                     # noqa: BLE001 - the regression IS an exception
        ok, detail = False, "%s: %s" % (type(e).__name__, str(e)[:140])
    results.append(Result("plugin-fixture: SHIPPED default contract+vmfb pass the binding gate (N5)", ok, detail))
    # and the gate must still REFUSE when the field is genuinely missing, so the
    # fix above is a data correction, not a weakening of D27.
    c2 = copy.deepcopy(c)
    c2["artifact"].pop("bytes", None)
    try:
        ab.verify_artifact_binding(c2, vmfb)
        refused, detail = False, "accepted a contract with no artifact.bytes"
    except Exception as e:                                     # noqa: BLE001
        refused, detail = True, type(e).__name__
    results.append(Result("plugin-fixture: gate still refuses a contract with artifact.bytes missing (D27 intact)",
                          refused, detail))
    return results


def artifact_binding_and_corruption_cases(root, tmp):
    results = []
    sys.path.insert(0, HERE)
    sys.path.insert(0, os.path.join(os.path.dirname(HERE), "plugins", "compiled_learner"))
    import corrupt_vmfb as cv
    import e14_cfs_scenarios as e14
    import artifact_binding as ab

    fixtures = []
    for arch in ("aarch64", "x86_64"):
        for m in ("mlp16k", "conv2d", "multibranch", "dynamic"):
            p = os.path.join(root, arch, "vmfb", "%s.vmfb" % m)
            if os.path.isfile(p):
                fixtures.append((arch, m, p))
    if not fixtures:
        return [Result("corrupt: vmfb fixtures present", False, "none under %s" % root)]

    # --- F8: structural method works on every stored vmfb, container stays a valid ZIP ---
    n_ok = 0
    details = []
    for arch, m, p in fixtures:
        out = os.path.join(tmp, "%s.%s.rootuoff.vmfb" % (m, arch))
        try:
            cv.corrupt_flatbuffer_root_uoffset(p, out)
            z, zo = zipfile.ZipFile(out), zipfile.ZipFile(p)
            ok = (z.testzip() is None and z.read("module.fb")[:4] == b"\xff\xff\xff\xff"
                  and all(z.read(n) == zo.read(n) for n in z.namelist() if n != "module.fb")
                  and os.path.getsize(out) == os.path.getsize(p))
        except Exception as e:
            ok = False; details.append("%s/%s: %s" % (arch, m, e))
        n_ok += ok
    results.append(Result("corrupt: flatbuffer_root_uoffset on all stored vmfb (ZIP CRC ok, only module.fb prefix changed, size kept)",
                          n_ok == len(fixtures), "%d/%d %s" % (n_ok, len(fixtures), "; ".join(details)[:200])))

    arch, m, p = fixtures[0]
    r1 = cv.corrupt_flatbuffer_root_uoffset(p, os.path.join(tmp, "det1.vmfb"))
    r2 = cv.corrupt_flatbuffer_root_uoffset(p, os.path.join(tmp, "det2.vmfb"))
    results.append(Result("corrupt: flatbuffer_root_uoffset is deterministic (host-built corruptsha contract == guest-run file)",
                          r1["sha256"] == r2["sha256"], r1["sha256"][:16]))

    flip_out = os.path.join(tmp, "flip.vmfb")
    cv.corrupt_flip(p, flip_out, 4096)
    a, b = open(p, "rb").read(), open(flip_out, "rb").read()
    diff = [i for i in range(len(a)) if a[i] != b[i]]
    results.append(Result("corrupt: flip changes exactly the one requested byte (A5a stays unstructured)",
                          diff == [4096], str(diff[:5])))

    rc, out, err = run([PY, os.path.join(HERE, "corrupt_vmfb.py"), "--method", "bogus", "--in", p, "--out", os.path.join(tmp, "x.vmfb")])
    results.append(Result("corrupt: CLI refuses an unrecognized --method (no silent default)", rc != 0 and not os.path.exists(os.path.join(tmp, "x.vmfb")), "rc=%d" % rc))
    try:
        cv.corrupt_flatbuffer_root_uoffset(p, os.path.join(tmp, "y.vmfb"), entry_name="no_such_entry.fb")
        results.append(Result("corrupt: missing ZIP entry -> refused", False, "no exception"))
    except ValueError as e:
        results.append(Result("corrupt: missing ZIP entry -> refused", True, str(e)[:80]))

    # --- F8: scenario installer fails closed on a missing/unknown corrupt_method ---
    for label, v in [("missing", {"corrupt_of": "models/x.vmfb", "flip_offset": 4096}),
                     ("unknown", {"corrupt_of": "models/x.vmfb", "corrupt_method": "bogus"})]:
        try:
            e14._corruption_step(v, "cpu1", "cfs_e14", dry=True)
            results.append(Result("scenario: corrupt_method %s -> ValueError (fail-closed)" % label, False, "no exception"))
        except ValueError as e:
            results.append(Result("scenario: corrupt_method %s -> ValueError (fail-closed)" % label, True, str(e)[:80]))
    step = e14._corruption_step({"corrupt_of": "models/x.vmfb", "corrupt_method": "flatbuffer_root_uoffset"}, "cpu1", "cfs_e14", dry=True)[0]
    results.append(Result("scenario: A5b step invokes corrupt_vmfb.py RELATIVE to cwd (no remote_root double prefix)",
                          "python3 corrupt_vmfb.py" in step and "cfs_e14/corrupt_vmfb.py" not in step, step[:120]))
    rc, out, err = run([PY, os.path.join(HERE, "e14_make_scenarios.py"), "--root", root, "--out", os.path.join(tmp, "sc.json")])
    scs = load(os.path.join(tmp, "sc.json")) if rc == 0 else []
    a5a = [s for s in scs if s["id"].startswith("A5a")]; a5b = [s for s in scs if s["id"].startswith("A5b")]
    results.append(Result("scenario: generated A5a=flip / A5b=flatbuffer_root_uoffset, explicit and distinct",
                          bool(a5a) and bool(a5b) and all(s["vmfb"]["corrupt_method"] == "flip" for s in a5a)
                          and all(s["vmfb"]["corrupt_method"] == "flatbuffer_root_uoffset" for s in a5b),
                          "rc=%d a5a=%d a5b=%d" % (rc, len(a5a), len(a5b))))

    # --- F10: OnAIR binding gate == native/cFS gate semantics ---
    cpath = os.path.join(root, arch, "contracts", "contract.%s.%s.json" % (m, arch))
    c = load(cpath)
    good = os.path.join(tmp, "good.vmfb"); shutil.copy(p, good)
    v = ab.verify_artifact_binding(c, good)
    results.append(Result("binding: stored contract + its own vmfb -> MATCH (sanity)", v["verdict"] == "MATCH", v["artifact_sha256"][:16]))

    def refused(label, contract, path, must_contain):
        try:
            ab.verify_artifact_binding(contract, path)
            results.append(Result("binding: %s -> refused" % label, False, "MATCHed"))
        except ab.ArtifactBindingError as e:
            results.append(Result("binding: %s -> refused" % label, must_contain in str(e), str(e)[:100]))

    refused("A5a flip file vs original contract (sha256 mismatch)", c, flip_out, "sha256")
    refused("A5b root_uoffset file vs ORIGINAL contract (same size -> caught by sha256, not size)", c, os.path.join(tmp, "det1.vmfb"), "sha256")
    trunc = os.path.join(tmp, "trunc.vmfb"); open(trunc, "wb").write(a[:-1])
    refused("truncated file (size mismatch, refused before hashing)", c, trunc, "size")
    c2 = copy.deepcopy(c); c2["artifact"].pop("bytes")
    refused("contract missing artifact.bytes (fail-closed)", c2, good, "bytes missing")
    c3 = copy.deepcopy(c); c3["artifact"].pop("sha256")
    refused("contract missing artifact.sha256 (fail-closed)", c3, good, "sha256 missing")
    cc = cv.make_corrupted_contract(cpath, r1, "det1.vmfb")
    v = ab.verify_artifact_binding(cc, os.path.join(tmp, "det1.vmfb"))
    results.append(Result("binding: corruptsha contract + root_uoffset file -> MATCH (A5b precondition: hash gate passes, only IREE can refuse)",
                          v["verdict"] == "MATCH" and cc["resources"] == c["resources"], v["artifact_sha256"][:16]))

    # --- A5b end-to-end at the Python iree.runtime level (4th level after native/cFS x86-64/cFS AArch64) ---
    try:
        import iree.runtime as rt
    except ImportError:
        results.append(Result("a5b-runtime: iree.runtime rejects root_uoffset file with 'length prefix out of bounds'", True, "iree.runtime not installed", skip=True))
        return results
    x86 = [f for f in fixtures if f[0] == "x86_64"]
    if not x86:
        results.append(Result("a5b-runtime: x86_64 vmfb fixture present", False, "none"))
        return results
    _, xm, xp = x86[0]
    def load_rt(path):
        ctx = rt.SystemContext(config=rt.Config("local-sync"))
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(path, "rb").read()))
    try:
        load_rt(xp); ok_orig = True; msg = ""
    except Exception as e:
        ok_orig = False; msg = str(e)[:100]
    results.append(Result("a5b-runtime: original x86_64 %s loads in iree.runtime (sanity)" % xm, ok_orig, msg))
    xc = os.path.join(tmp, "x86.rootuoff.vmfb"); cv.corrupt_flatbuffer_root_uoffset(xp, xc)
    try:
        load_rt(xc); results.append(Result("a5b-runtime: iree.runtime rejects root_uoffset file with 'length prefix out of bounds'", False, "LOADED"))
    except Exception as e:
        results.append(Result("a5b-runtime: iree.runtime rejects root_uoffset file with 'length prefix out of bounds'",
                              "FlatBuffer length prefix out of bounds" in str(e) and "4294967295" in str(e), str(e)[-90:]))
    return results


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="results/e14_aarch64_qemu")
    ap.add_argument("--skip-regression", action="store_true", help="skip the 14/14 regression check (slower part)")
    a = ap.parse_args()

    with tempfile.TemporaryDirectory(prefix="contract_negative_tests_") as tmp:
        all_results = []
        all_results += unit_tests(a.root)
        all_results += header_negative_cases(a.root, tmp)
        all_results += make_contract_negative_cases(a.root, tmp)
        all_results += structural_walker_checks(a.root)
        all_results += structural_hard_fail_cases(a.root)
        all_results += structural_bugfix_regression_cases(a.root, tmp)
        all_results += workflow_yaml_cases()
        all_results += default_plugin_fixture_cases()
        all_results += artifact_binding_and_corruption_cases(a.root, tmp)
        if not a.skip_regression:
            all_results += regression_check(a.root, tmp)

        print("=" * 100)
        for r in all_results:
            print(r)
        print("=" * 100)
        # F9/E22: skipped checks (missing iree.compiler.ir, an optional
        # dependency) are neither passes nor failures -- reported separately
        # so this environment's real pass/fail count stays meaningful instead
        # of being permanently short of the in-tree total, or a real bug
        # hiding behind an expected-here FAIL.
        n_skip = sum(1 for r in all_results if r.skip)
        n_fail = sum(1 for r in all_results if not r.skip and not r.ok)
        n_pass = sum(1 for r in all_results if not r.skip and r.ok)
        # D25 (E23): skips have more than one cause now (iree.compiler.ir, the
        # iree-* console scripts, iree.runtime), so name the actual reasons
        # instead of attributing every skip to the module -- CI's without-deps
        # leg lacks all three and used to be summarised as if it lacked one.
        reasons = sorted({r.detail for r in all_results if r.skip and r.detail})
        print("%d/%d checks passed%s" % (n_pass, n_pass + n_fail,
              " (%d skipped: %s)" % (n_skip, "; ".join(reasons)) if n_skip else ""))
        return 1 if n_fail else 0


if __name__ == "__main__":
    sys.exit(main())
