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
import hashlib
import glob
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


def read(path):
    with open(path, errors="replace") as f:
        return f.read()


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


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

    # F2 (external review v0.20, E24c): the D36/R2 sum identity used to run only
    # when both components happened to be ints, so a null component DISABLED it
    # and a negative component SATISFIED it vacuously. Two distinct mechanisms;
    # the review's "only when both are ints" describes the first only.
    try_mutation("static_per_call_bytes=null disables the D36 sum identity (F2)",
                 lambda c: c["resources"].__setitem__("static_per_call_bytes", None))
    try_mutation("module_resident_constant_bytes=null disables the D36 sum identity (F2)",
                 lambda c: c["resources"].__setitem__("module_resident_constant_bytes", None))

    def _neg_component(c):
        r = c["resources"]
        # keep the identity arithmetically TRUE (pc + cb == bounded) so this can
        # only be caught by the non-negativity requirement, not by the sum check
        r["static_per_call_bytes"] = r["bounded_bytes"] + 1
        r["module_resident_constant_bytes"] = -1
    try_mutation("negative component satisfies the D36 identity vacuously (F2)", _neg_component)

    # the (B) direction: a bound_known contract whose constants are legitimately
    # 0 must still be ACCEPTED -- `>= 0`, never `> 0` (the D35 lesson again).
    def _zero_constants(c):
        r = c["resources"]
        r["module_resident_constant_bytes"] = 0
        r["bounded_bytes"] = r["static_per_call_bytes"]
    czero = copy.deepcopy(base)
    _zero_constants(czero)
    czpath = os.path.join(tmp, "hdr_zero_constants.json")
    write_json(czero, czpath)
    rc, _o, err = run([PY, GEN_HEADER, czpath, czpath[:-5] + ".h"])
    results.append(Result("header-neg: constants==0 on a bound_known contract is ACCEPTED (F2 over-rejection guard)",
                          rc == 0 and os.path.exists(czpath[:-5] + ".h"),
                          "rc=%d stderr=%s" % (rc, err.strip()[:160])))

    # R1 (external review v0.19-reframe, E24b) — the only finding of that review
    # reachable through the NORMAL pipeline, and the only one rated a claim
    # blocker. A negative stack figure made ai_learner.c's
    # `stack_needed = BASE + KERNEL` negative (262144 + (-300000) = -37856), and
    # since BOTH operands of `es_stack >= stack_needed` are signed `long`, the
    # comparison became true for EVERY stack size -- including 0, and including
    # the es_stack = -1 left in place when CFE_ES_GetAppInfo fails. The D15/E16
    # refusal branch stopped enforcing while telemetry still said accounted=true.
    # (정정 E24c/F5: earlier revisions attributed this to CFE_ES_AppInfo_t.StackSize
    # being unsigned. That was wrong and backwards -- an unsigned comparison would
    # wrap -37856 to 1.8e19 and REFUSE at every realistic stack size.)
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

    # ------------------------------------------------------------------
    # R5 (external review v0.19-reframe, E24b): an applied --allow-* escape
    # hatch left no machine-readable trace in the contract it then wrote, so a
    # fully-verified contract and one whose ABI/triple/ELF/one-invocation
    # checks were all waived were indistinguishable to gen_contract_header.py
    # (which reads no provenance at all) and to every human reader who does not
    # diff provenance.notes by hand.
    #
    # These cases pin BOTH directions, because "record the overrides" has an
    # over-rejection twin: a flag that was passed but never actually suppressed
    # anything must NOT be recorded (it would grade a healthy contract
    # "overridden" and, through the header gate below, refuse a deployable
    # header for a contract nothing is wrong with -- defect class (B)).
    # ------------------------------------------------------------------
    env_flags = set(with_structural_override(()))       # forced by THIS environment, not by the case
    if os.path.isdir(dump_dir) and os.path.isfile(elf_json):
        # (1) healthy inputs: nothing beyond what the environment forced.
        # base_cmd() always passes --no-validate, which IS a real override
        # (it suppresses the schema check unconditionally), so it belongs in
        # the expected set.
        out = os.path.join(tmp, "r5_clean.json")
        rc, o, err = run(base_cmd("conv2d", "aarch64", inv["layout_ir"], dump_dir, out, elf_json))
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        got = set((c or {}).get("provenance", {}).get("overrides_applied") or [])
        expect = env_flags | {"--no-validate"}
        results.append(Result("R5: healthy contract records exactly the environment-forced overrides",
                              c is not None and got == expect
                              and c["provenance"]["verification_grade"] == ("overridden" if expect else "verified"),
                              "got=%s expect=%s rc=%d" % (sorted(got), sorted(expect), rc)))

        # (2) a flag passed but NOT needed must not be recorded (no false
        # accusation): --allow-abi-mismatch on inputs whose ABI declaration
        # agrees. waive() is only reached inside the mismatch branch, so
        # short-circuit evaluation gives this for free -- pin it, because a
        # "record every flag argparse saw" implementation would break it.
        out = os.path.join(tmp, "r5_unneeded_flag.json")
        rc, o, err = run(base_cmd("conv2d", "aarch64", inv["layout_ir"], dump_dir, out, elf_json,
                                  extra_flags=("--allow-abi-mismatch",)))
        c = load(out) if (rc == 0 and os.path.exists(out)) else None
        got = set((c or {}).get("provenance", {}).get("overrides_applied") or [])
        results.append(Result("R5: an override that suppressed nothing is NOT recorded (no false accusation)",
                              c is not None and "--allow-abi-mismatch" not in got and got == expect,
                              "got=%s rc=%d" % (sorted(got), rc)))

        # (3) an override that DID suppress a refusal is recorded, and the
        # grade flips. The condition used here (an --elf-analysis JSON that
        # analysed a different ELF than the vmfb embeds) needs no iree tools
        # and no iree.compiler.ir, so this case runs in every CI leg.
        bad_elf = copy.deepcopy(load(elf_json))
        bad_elf["elf_sha256"] = "0" * 64
        bad_elf_r5 = os.path.join(tmp, "r5_bad_elf_analysis.json")
        write_json(bad_elf, bad_elf_r5)
        r5_over = os.path.join(tmp, "r5_overridden.json")
        rc, o, err = run(base_cmd("conv2d", "aarch64", inv["layout_ir"], dump_dir, r5_over, bad_elf_r5,
                                  extra_flags=("--allow-elf-analysis-mismatch",)))
        c = load(r5_over) if (rc == 0 and os.path.exists(r5_over)) else None
        got = set((c or {}).get("provenance", {}).get("overrides_applied") or [])
        results.append(Result("R5: an override that DID suppress a refusal is recorded + graded 'overridden'",
                              c is not None and got == expect | {"--allow-elf-analysis-mismatch"}
                              and c["provenance"]["verification_grade"] == "overridden",
                              "got=%s grade=%s rc=%d" % (sorted(got), (c or {}).get("provenance", {}).get("verification_grade"), rc)))

        # (4) G4: gen_contract_header.py must refuse that contract by default,
        # and accept it only with the explicit --allow-override-contract, which
        # then reports CONTRACT_PROVENANCE_VERIFIED 0 rather than pretending.
        if c is not None:
            hdr = os.path.join(tmp, "r5_overridden.h")
            rc2, o2, err2 = run([PY, GEN_HEADER, r5_over, hdr])
            results.append(Result("R5/G4: header from an overridden contract refused by default",
                                  rc2 != 0 and not os.path.exists(hdr),
                                  "rc=%d wrote=%s stderr=%s" % (rc2, os.path.exists(hdr), err2.strip()[:160])))
            rc3, o3, err3 = run([PY, GEN_HEADER, r5_over, hdr, "--allow-override-contract"])
            txt = open(hdr).read() if os.path.exists(hdr) else ""
            results.append(Result("R5/G4: --allow-override-contract writes it with PROVENANCE_VERIFIED 0",
                                  rc3 == 0 and "#define CONTRACT_PROVENANCE_VERIFIED 0" in txt,
                                  "rc=%d stderr=%s" % (rc3, err3.strip()[:160])))
    return results


# ----------------------------------------------------------------------------
# R5 drift guard (E24b), source-level and stdlib-only.
#
# The behavioural cases above prove the recording works for the flags they
# exercise. They cannot prove it for a flag added LATER, and that is the
# failure mode independent verification actually flagged: a mechanical patch
# (append a record next to each `hard_fail_errors.append`) silently misses the
# two COMBINED-form gates, `if <condition> and not a.allow_...:`. A contract
# that then reports overrides_applied=[] / verification_grade="verified" WHILE
# an override was applied is strictly worse than recording nothing -- it is a
# new fail-open that asserts verification. So assert the invariant that makes
# the drift impossible instead of only its consequences: every --allow-* flag
# make_contract.py declares is consumed through waive(), and no bare flag
# access survives.
# ----------------------------------------------------------------------------
def r5_waive_wrapping_cases():
    src = open(MAKE_CONTRACT).read()
    declared = set(re.findall(r'ap\.add_argument\("(--allow-[a-z-]+)"', src))
    waived = set(re.findall(r'waive\("(--[a-z-]+)"', src))
    bare = [ln.strip() for ln in src.splitlines()
            if re.search(r'\ba\.allow_[a-z_]+', ln) and "waive(" not in ln and "add_argument" not in ln]
    results = [
        Result("R5: every --allow-* flag make_contract.py declares is consumed through waive()",
               bool(declared) and declared <= waived,
               "declared=%d waived=%d missing=%s" % (len(declared), len(waived), sorted(declared - waived))),
        Result("R5: no bare a.allow_* access bypasses waive() in make_contract.py",
               not bare, "%d line(s): %s" % (len(bare), bare[:2])),
        # --no-validate is consumed in main(), after build_contract() returns,
        # so it is recorded unconditionally at build time instead; assert that
        # single recording site exists rather than letting it drift away.
        Result("R5: --no-validate is recorded as the eleventh override",
               'waive("--no-validate"' in src, ""),
    ]
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
    # R5 (E24b): which escape hatches were used, and the resulting grade. Also
    # new recorded facts on pre-existing contracts (all 14 regenerate with
    # overrides_applied=[] / verification_grade="verified"), and pinned as such
    # by r5_override_recording_cases() below rather than by this diff.
    "overrides_applied", "verification_grade",
    # F3 (E24c): the machine-readable twin of the pre-existing
    # resources.constants_check_note prose. Another new recorded fact -- the 14
    # stored contracts predate it and every number in the regeneration still has
    # to match exactly. Pinned separately by subset_sum_tristate_cases() and by
    # the header/contract negative cases, not by this diff.
    # (Despite the constant's name this set is matched against the LAST path
    # component, so it covers resources.* as well as provenance.*.)
    "constants_confirmation_state",
}
# E19: provenance.structural_walker is a field the 14 stored (pre-E19) contracts
# never had -- comparing it leaf-by-leaf against IGNORE_PROVENANCE_KEYS by bare
# name would risk colliding with unrelated same-named leaves elsewhere in the
# contract (e.g. resources.dispatches), so the whole subtree is excluded from
# the "contract unchanged" diff by path instead, and checked separately below
# (asserting it is actually present and agrees, not just absent from the diff).
# E40: `analysis_domain` and `accounting_rules` are two more subtrees the 14 stored
# (pre-E40) contracts never had. They are excluded BY SUBTREE, not by bare leaf name,
# and the distinction is not stylistic: IGNORE_PROVENANCE_KEYS is matched against the
# LAST path component, so putting "driver" or "entry" there to silence
# analysis_domain.derived.driver would also silence target.driver and model.entry --
# a fail-open in the one check that exists to catch drift. Their values are pinned
# instead by analysis_domain_cases() below, per the E24b/D39 + E24/N2 + E24c/F3
# precedent (exclusion from the diff must be paired with dedicated pinning).
IGNORE_PROVENANCE_SUBTREES = {"structural_walker", "analysis_domain", "accounting_rules"}


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
            # E40: the analysis_domain / accounting_rules subtrees are excluded from
            # the diff above (the 14 stored contracts predate them), so they are pinned
            # HERE instead -- on the production path, per model, re-checked against the
            # regenerated contract's own source fields. Exclusion without pinning is how
            # a new block becomes an unchecked second source of truth (D65).
            import make_contract as _mc
            _c = load(new_contract)
            _drift = _mc.analysis_domain_drift(_c)
            _ad = (_c.get("analysis_domain") or {})
            _prem = _ad.get("required_premises") or {}
            _pin_ok = (not _drift
                       and _ad.get("derived", {}).get("static_shapes")
                           == (_c["resources"]["bound_method"] != "NONE")
                       and _prem.get("max_in_flight_calls") == 1
                       and _prem.get("output_lifetime") == "released_before_next_call"
                       and "max_in_flight_calls" not in (_ad.get("derived") or {})
                       and isinstance(_c.get("accounting_rules"), dict)
                       and _c["accounting_rules"].get("bounded_bytes"))
            results.append(Result("regression: %s/%s analysis_domain agrees with its sources" % (tgt, model),
                                  bool(_pin_ok),
                                  "drift=%s static_shapes=%s premises=%s accounting=%s"
                                  % (_drift, _ad.get("derived", {}).get("static_shapes"),
                                     sorted(_prem), bool(_c.get("accounting_rules")))))
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
def documented_smoke_path_cases(tmp):
    """E24b: the two contract-building paths CLAUDE.md documents as smoke tests must
    actually reach a header.

    Found while verifying R5: `native/build.sh` (documented as `cd native &&
    bash build.sh`) and `scripts/62_compile_and_check_aarch64.sh` both fed
    gen_contract_header.py a contract it refused, so both were rc=1. Two of the
    three causes predate E24 (no ELF stack analysis -> D13/D15; no bound_method ->
    E15/D13), but the third was introduced BY E24: N3's "a bound-known contract
    must state a dtype somewhere" gate. E24 measured its over-rejection risk across
    contracts/*.json and the 14 archived contracts, and missed contracts that
    scripts construct inline -- so a class-B regression shipped. These cases pin
    both shapes so the next gate cannot silently break them again.

    stdlib only: builds the same contract shapes the scripts build, without
    running the scripts (which need toolchains this container may not have)."""
    results = []
    # (1) native/build.sh's default contract, with the flag build.sh now passes.
    example = os.path.join(os.path.dirname(HERE), "contracts", "contract.filled.example.json")
    if os.path.isfile(example):
        hpath = os.path.join(tmp, "smoke_native_build.h")
        rc, out, err = run([PY, GEN_HEADER, example, hpath, "--allow-unknown-stack"])
        results.append(Result("smoke-path: native/build.sh default contract -> header (E24b)",
                              rc == 0 and os.path.isfile(hpath), "rc=%d stderr=%s" % (rc, err.strip()[:150])))
    # (2) scripts/62's inline budget contract, same shape the script writes.
    vmfb = os.path.join(os.path.dirname(HERE), "results", "e14_aarch64_qemu", "aarch64", "vmfb", "mlp16k.vmfb")
    if os.path.isfile(vmfb):
        blob = open(vmfb, "rb").read()
        c62 = {"resources": {"bounded_bytes": 786476, "static_per_call_bytes": 65580,
                             "module_resident_constant_bytes": 720896,
                             "bound_method": "static_from_stream_layout"},
               "artifact": {"bytes": len(blob), "sha256": hashlib.sha256(blob).hexdigest()},
               "validity": {"input": {"shape": [1, 9], "dtype": "f32"},
                            "output": {"shape": [1, 2], "dtype": "f32"}, "driver": "local-sync"}}
        cpath = os.path.join(tmp, "smoke_scripts62.json")
        hpath = cpath[:-5] + ".h"
        write_json(c62, cpath)
        rc, out, err = run([PY, GEN_HEADER, cpath, hpath, "--allow-unknown-stack"])
        ok = rc == 0 and os.path.isfile(hpath) and "CONTRACT_BOUND_KNOWN 1" in open(hpath).read()
        results.append(Result("smoke-path: scripts/62 inline budget contract -> header (E24b)",
                              ok, "rc=%d stderr=%s" % (rc, err.strip()[:150])))
    return results


def constants_budget_gate_cases(root):
    """F3 (external review v0.20, E24c): a constants confirmation that could not be
    evaluated because the total exceeded the enumeration budget used to leave a
    bound-known contract with the independent artifact-side check silently NOT
    MADE -- while the strictly weaker "iree-dump-module is missing" was refused
    (D25) and the strictly stronger "observed and contradicted" was refused (N1).

    No artifact in this repo can reach it (the largest constant total here is
    720,896 B, 372x below the budget) and manufacturing one would mean compiling a
    >256 MiB constant pool, so the wiring is exercised the way E19 exercised its
    hard-fail path: in-process, by monkeypatching the observation."""
    results = []
    inv_path = os.path.join(root, "aarch64", "vmfb", "conv2d.invocation.json")
    if not os.path.isfile(inv_path):
        return [Result("F3 budget gate: fixture present", False, "missing %s" % inv_path)]
    try:
        import make_contract as mc
    except Exception as e:                                  # pragma: no cover
        return [Result("F3 budget gate: make_contract importable", False, str(e))]

    # the state machine itself, stdlib-only
    st = mc.constants_confirmation_state
    checks = [
        ("not_observed wins over everything", st(1024, None, "tool missing"), "not_observed"),
        ("zero constants -> nothing_to_confirm", st(0, None, None), "nothing_to_confirm"),
        ("True -> confirmed", st(1024, True, None), "confirmed"),
        ("False -> contradicted", st(1024, False, None), "contradicted"),
        ("None with real constants -> unevaluable_budget_exceeded", st(1024, None, None),
         "unevaluable_budget_exceeded"),
    ]
    for name, got, want in checks:
        results.append(Result("F3 state: %s" % name, got == want, "got %r want %r" % (got, want)))
    results.append(Result("F3 state: every state is declared in CONSTANTS_CONFIRMATION_STATES",
                          all(w in mc.CONSTANTS_CONFIRMATION_STATES for _n, _g, w in checks),
                          str(mc.CONSTANTS_CONFIRMATION_STATES)))

    # the GATE: force the unevaluable state and confirm build_contract refuses,
    # and that the documented override still writes the contract.
    inv = load(inv_path)
    ti = TARGET_INFO["aarch64"]
    dump_dir = os.path.join(root, "aarch64", "dump", "conv2d")
    elf_json = os.path.join(root, "aarch64", "elf", "conv2d.elf_analysis.json")
    if not (os.path.isdir(dump_dir) and os.path.isfile(elf_json) and iree_tools_available()
            and structural_available() and schema_validator_available()):
        results.append(Result("F3 gate: budget-exceeded confirmation is refused by default",
                              True, "needs the full toolchain to isolate this one condition", skip=True))
        return results

    def run_build(extra):
        argv = ["--mlir", inv["mlir"], "--vmfb", inv["vmfb"], "--layout-ir", inv["layout_ir"],
                "--dump-dir", dump_dir, "--triple", ti["triple"], "--cpu", ti["cpu"],
                "--model-name", "conv2d", "--elf-analysis", elf_json,
                "--out", os.path.join(tempfile.gettempdir(), "f3_gate_unused.json")] + list(extra)
        return mc.build_contract(mc.parse_args(argv), [])

    # The gate fires on the STATE, so force exactly that state: a real
    # observation (so it is not "not_observed"), a real constant total (so it is
    # not "nothing_to_confirm"), and an enumeration that cannot decide. The
    # cheap procedures added in E24c make the real over-budget case hard to
    # manufacture from an archived artifact, so patch the enumerator itself --
    # the same in-process technique E19 used to exercise its hard-fail wiring.
    real_match = mc.subset_sum_match
    mc.subset_sum_match = lambda total, segs, **kw: None
    try:
        refused = False
        detail = ""
        try:
            run_build([])
        except SystemExit as e:
            detail = str(e)
            refused = "could not be confirmed against the artifact" in detail
        results.append(Result("F3 gate: budget-exceeded confirmation is refused by default",
                              refused, detail.strip().replace("\n", " ")[:150]))
        # the documented override must still let it through, and must be recorded
        wrote = False
        note = False
        grade = None
        try:
            c = run_build(["--allow-unverified-invocation"])
            wrote = True
            note = any("could not be confirmed against the artifact" in n
                       for n in c["provenance"]["notes"])
            grade = c["provenance"].get("verification_grade")
        except SystemExit as e:
            detail = str(e)
        results.append(Result("F3 gate: --allow-unverified-invocation overrides it AND records why",
                              wrote and note and grade == "overridden",
                              "wrote=%s noted=%s grade=%r %s" % (wrote, note, grade, detail[:90])))
    finally:
        mc.subset_sum_match = real_match
    return results


def preserved_manyconst31_cases():
    """E24c / F4 (external review v0.20): the >24-segment case that motivated D38
    was pinned only by a SYNTHESISED 31-integer array. The review correctly noted
    that no real IREE artifact exhibiting it was preserved, so the claim
    "a single honest compile produces more segments than the old cap" was not
    reproducible from repository contents -- and this repo's own discipline
    (작업 규율 4, evidence grading) says a claim used to justify a decision must be
    backed by preserved evidence.

    results/e24c_manyconst31/ now holds ONE iree-compile invocation's outputs
    (generator: harness/gen_model_manyconst.py). These checks read the recorded
    segment list from invocation.json, so they are stdlib-only and run in every CI
    leg; the two that need the real tools re-observe the vmfb and are SKIPped
    without them."""
    results = []
    root = os.path.join(HERE, "..", "results", "e24c_manyconst31")
    inv_path = os.path.join(root, "invocation.json")
    contract_path = os.path.join(root, "manyconst31.contract.json")
    if not (os.path.isfile(inv_path) and os.path.isfile(contract_path)):
        return [Result("manyconst31: preserved bundle present", False,
                       "missing %s" % os.path.relpath(inv_path))]
    inv = load(inv_path)
    contract = load(contract_path)
    segs = inv.get("observed_data_segments") or []
    total = contract["resources"]["module_resident_constant_bytes"]

    results.append(Result("manyconst31: preserved bundle records MORE segments than the old 24 cap",
                          len(segs) > 24 and len(segs) == inv.get("observed_data_segment_count"),
                          "%d segments, recorded count %s" % (len(segs), inv.get("observed_data_segment_count"))))
    results.append(Result("manyconst31: the contract's constant total is the recorded one",
                          isinstance(total, int) and total == inv.get("module_resident_constant_bytes"),
                          "contract=%r invocation.json=%r" % (total, inv.get("module_resident_constant_bytes"))))

    # the point of the bundle: current code says True, the pre-E24b truncation says False.
    try:
        import make_contract as mc
        cur = mc.subset_sum_match(total, list(segs))
    except Exception as e:                                    # pragma: no cover - import guard
        cur = "ERROR: %s" % e
    results.append(Result("manyconst31: current tri-state subset_sum_match confirms the total (True)",
                          cur is True, "got %r" % (cur,)))

    def pre_e24b_subset_sum_match(tot, ss, max_segments=24):
        """The implementation as it stood before D38: positional truncation."""
        if not ss or tot is None or tot <= 0:
            return False
        ss = ss[:max_segments]
        reach = {0}
        for v in ss:
            reach |= {r + v for r in reach if r + v <= tot}
            if tot in reach:
                return True
        return tot in reach

    old = pre_e24b_subset_sum_match(total, list(segs))
    results.append(Result("manyconst31: the PRE-E24b truncation contradicts the same honest total (False)",
                          old is False,
                          "got %r; first 24 segments sum to %d < %d"
                          % (old, sum(list(segs)[:24]), total)))
    results.append(Result("manyconst31: the shipped contract records the constants as independently confirmed",
                          contract["resources"].get("constants_independently_confirmed_in_artifact") is True,
                          "%r" % contract["resources"].get("constants_independently_confirmed_in_artifact")))

    # re-observe the artifact itself when the real tools are here
    vmfb = os.path.join(root, "manyconst31.vmfb")
    if not iree_tools_available():
        results.append(Result("manyconst31: re-observed segments match the recorded ones",
                              True, "iree-dump-module not on PATH", skip=True))
    else:
        ext2, data2 = smb.artifact_rodata_segments(vmfb)
        results.append(Result("manyconst31: re-observed segments match the recorded ones",
                              data2 == list(segs) and ext2 == (inv.get("observed_external_segments") or []),
                              "re-observed %d segments (recorded %d)"
                              % (len(data2 or []), len(segs))))
    return results


def subset_sum_tristate_cases():
    """R4 (external review v0.19-reframe, E24b): subset_sum_match() used to return
    a plain False for three different states, and truncated enumeration at 24
    segments. The reachable half was not the skipped gate but the FALSE FIELD: a
    single honest iree-compile with the stock flag
    --iree-stream-resource-max-allocation-size=1024 yields more data segments than
    the old 24-segment cap (measured on the preserved bundle in
    results/e24c_manyconst31/: 33 by this repo's own artifact_rodata_segments --
    32 embedded 1024 B constant slabs plus one external segment -- for a model of
    31 constants; see preserved_manyconst31_cases() below), and
    the old code then wrote `constants_independently_confirmed_in_artifact: false`
    plus a note stating "NOT matched" about a total that DOES match -- a false
    assertion in a shipped contract, copied onward by cross_target_compare.py.

    Unit-level (stdlib only, no IREE needed), so this runs in every environment."""
    sys.path.insert(0, HERE)
    import make_contract as mc
    f = mc.subset_sum_match
    cases = [
        ("exact single segment", (2176, [2176, 6344]), True),
        ("subset of several", (2176, [1000, 1176, 99]), True),
        ("contradicted (enumerated, no subset matches)", (2176, [1, 6344]), False),
        ("nothing to confirm (total == 0)", (0, [7440]), None),
        ("no observation (empty segs)", (2176, []), None),
        ("no observation (segs is None)", (2176, None), None),
        # The reachable case. The matching segment must sit PAST the old
        # 24-segment cap, or the test is vacuous: the old code kept the first 24,
        # so a matching segment at index 0 was found even while truncating (a
        # trap this test fell into on the first attempt, caught by running the
        # pre-fix function directly).
        ("31 segments, the only matching one past the old 24-cap (was False)",
         (2176, [100003 + i for i in range(30)] + [2176]), True),
        ("31 segments, genuinely contradicted",
         (2176, [100003 + i for i in range(30)] + [2177]), False),
        # F3 (E24c): over the TOTAL budget the bitset DP is unaffordable, but the
        # answer is often still decidable cheaply. Refusing on the budget alone
        # would be a type-(B) over-rejection of an honest large model, so the
        # cheap procedures run FIRST and only their failure yields None.
        ("over budget but one segment IS the total -> True, not None",
         (mc.SUBSET_SUM_MAX_TOTAL + 1, [mc.SUBSET_SUM_MAX_TOTAL + 1, 7]), True),
        ("over budget, few segments, a subset sums -> True",
         (mc.SUBSET_SUM_MAX_TOTAL + 3, [mc.SUBSET_SUM_MAX_TOTAL, 1, 2]), True),
        ("over budget, few segments, exhaustively contradicted -> False",
         (mc.SUBSET_SUM_MAX_TOTAL + 1, [1, 2]), False),
        ("over budget AND too many segments -> unevaluable, never contradicted",
         (mc.SUBSET_SUM_MAX_TOTAL + 1,
          [3] * (mc.SUBSET_SUM_MAX_COMBINATION_SEGMENTS + 1)), None),
    ]
    results = []
    for name, args, expect in cases:
        got = f(*args)
        results.append(Result("subset-sum tri-state: %s" % name, got is expect,
                              "got %r expected %r" % (got, expect)))
    return results


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


def e25_compare_rule_cases(tmp):
    """E25b: harness/e25_compare.py must judge each IREE path pair by the rule the
    plan fixed BEFORE the experiment ran, and must refuse to guess which rule applies.

    docs/plans/E25_same_model_equivalence.md SS3.2/SS3.3-5 put "cFS AArch64 <-> x86-64"
    under the tolerance row (they are different compilation outputs) and kept
    bit-identity for paths sharing a vmfb, where it IS the core claim. The first
    implementation demanded bit-identity of every pair. The stored E25 outputs happen
    to satisfy even that, so E25's PASS was never in doubt -- but it is a type (B)
    defect (over-rejection): a model whose cross-ISA outputs agree within tolerance
    and differ in the last bit would have been reported FAIL. Case 2 below is exactly
    that input.

    Note on the revert-and-confirm-fail witness: reverting e25_compare.py and re-running
    THIS function is a weak witness -- every case dies at rc=2 because argparse does not
    know --vmfb, which is the new interface rather than the defect. The real witness is
    the direct run recorded in docs/EVIDENCE_v0.22_E25.md SS12: the pre-E25b comparator,
    on its own interface, given two paths whose outputs differ by one ulp (every element
    passing BOTH tolerances on its own -- 16/16 abs-only and 16/16 rel-only), reports
    VERDICT: FAIL rc=1. The same data through the E25b comparator, declared as two
    different vmfbs, reports PASS with bit_identical recorded as False.

    Every case runs the real script as a subprocess on synthesised .npy inputs, so
    nothing here depends on the stored E25 outputs staying byte-identical -- except
    case 1, which is the point of case 1.
    Skips as a group when numpy is absent (stdlib-only CI leg)."""
    try:
        import numpy as np                                     # noqa: PLC0415 - optional probe
    except ImportError:
        return [Result("e25-compare: pair rules (same_vmfb bit-identical / cross_vmfb tolerance)",
                       True, "numpy not installed", skip=True)]

    script = os.path.join(HERE, "e25_compare.py")
    if not os.path.exists(script):
        return [Result("e25-compare: harness/e25_compare.py present", False, "missing")]

    root = os.path.join(os.path.dirname(HERE), "results", "e25_equivalence")
    store = os.path.join(root, "build")
    model_dir = os.path.join(root, "model")
    SHA_X = "0e250c2f16e704dbfd9a272073abb72935d5165c584c3c8d73fcd2790d2baebd"
    SHA_A = "4e5b2972c0bd970479eb5b8cb855d6ee83ff3dd2d9b86f4bf7773e780cadfba1"
    results = []

    def call(work, paths, vmfbs, ref=None, model=None):
        """paths: {name: absolute file}, vmfbs: {name: sha or None to omit}."""
        out = os.path.join(work, "cmp.json")
        cmd = [PY, script, "--model-dir", model or model_dir,
               "--reference", ref or os.path.join(store, "ref_numpy.npy"), "--out", out]
        for n, f in sorted(paths.items()):
            cmd += ["--path", "%s=%s" % (n, f)]
        for n, s in sorted(vmfbs.items()):
            if s is not None:
                cmd += ["--vmfb", "%s=%s" % (n, s)]
        rc, so, se = run(cmd)
        rep = load(out) if os.path.exists(out) else None
        return rc, so + se, rep, out

    # --- 1. the stored E25 outputs still adjudicate to PASS, with the rules split 3/3
    if all(os.path.exists(os.path.join(store, f)) for f in
           ("ref_numpy.npy", "out_ireepy.npy", "out_nativec.bin", "out_cfs.bin", "out_cfs_aarch64.bin")):
        work = os.path.join(tmp, "e25rule_stored"); os.makedirs(work, exist_ok=True)
        rc, log, rep, _ = call(work,
                               {"ireepy": os.path.join(store, "out_ireepy.npy"),
                                "nativec": os.path.join(store, "out_nativec.bin"),
                                "cfs_x86": os.path.join(store, "out_cfs.bin"),
                                "cfs_aarch64": os.path.join(store, "out_cfs_aarch64.bin")},
                               {"ireepy": SHA_X, "nativec": SHA_X, "cfs_x86": SHA_X, "cfs_aarch64": SHA_A})
        pairs = (rep or {}).get("iree_vs_iree", {})
        same = sorted(k for k, v in pairs.items() if v.get("rule") == "same_vmfb")
        cross = sorted(k for k, v in pairs.items() if v.get("rule") == "cross_vmfb")
        ok = (rc == 0 and rep and rep.get("pass") is True
              and len(same) == 3 and len(cross) == 3
              and all(v.get("passed") for v in pairs.values())
              and all(v.get("bit_identical") for v in pairs.values()))
        results.append(Result("e25-compare: stored E25 outputs PASS, rules split 3 same_vmfb / 3 cross_vmfb",
                              bool(ok), "rc=%d pass=%s same=%d cross=%d"
                              % (rc, (rep or {}).get("pass"), len(same), len(cross))))
        # the stored adjudication must not have drifted from the committed one either
        prev = os.path.join(store, "comparison_all.json")
        if os.path.exists(prev) and rep:
            old = load(prev)
            results.append(Result("e25-compare: vs_reference/argmax unchanged vs committed comparison_all.json",
                                  old.get("vs_reference") == rep.get("vs_reference")
                                  and old.get("argmax") == rep.get("argmax"),
                                  "pass %s -> %s" % (old.get("pass"), rep.get("pass"))))

    # --- synthesised inputs for the behavioural cases (independent of stored data)
    work = os.path.join(tmp, "e25rule_synth"); os.makedirs(work, exist_ok=True)
    rng = np.random.default_rng(20260909)
    ref = np.abs(rng.standard_normal((8, 2)).astype(np.float32)) + 1.0
    # a manifest the script can read: 2 outputs, 8 inputs, one regime
    write_json({"params": {"n_out": 2, "n_inputs": 8}, "sha256": {"synthetic": "n/a"},
                "input_regimes": ["synthetic"] * 8}, os.path.join(work, "manifest.json"))
    np.save(os.path.join(work, "ref.npy"), ref)
    np.save(os.path.join(work, "a.npy"), ref.copy())
    one_ulp = ref.copy(); one_ulp[3, 1] = np.nextafter(one_ulp[3, 1], np.float32(np.inf))
    np.save(os.path.join(work, "b_1ulp.npy"), one_ulp)
    coarse = ref.copy(); coarse[3, 1] = coarse[3, 1] * np.float32(1.001)
    np.save(os.path.join(work, "b_coarse.npy"), coarse)
    swapped = ref.copy(); swapped[[2]] = swapped[[2]][:, ::-1]          # flips that row's argmax
    np.save(os.path.join(work, "b_argmax.npy"), swapped)

    def synth(paths, vmfbs, tag):
        w = os.path.join(work, tag); os.makedirs(w, exist_ok=True)
        return call(w, {n: os.path.join(work, f) for n, f in paths.items()}, vmfbs,
                    ref=os.path.join(work, "ref.npy"), model=work)

    # 2. cross_vmfb + 1 ulp apart -> PASS (this is the over-rejection that was fixed)
    rc, log, rep, _ = synth({"x": "a.npy", "y": "b_1ulp.npy"}, {"x": SHA_X, "y": SHA_A}, "cross_1ulp")
    pair = list((rep or {}).get("iree_vs_iree", {}).values())
    ok = (rc == 0 and rep and rep.get("pass") is True and len(pair) == 1
          and pair[0].get("rule") == "cross_vmfb" and pair[0].get("bit_identical") is False)
    results.append(Result("e25-compare: cross_vmfb 1-ulp difference passes (bit_identical recorded False)",
                          bool(ok), "rc=%d pass=%s rule=%s bit=%s" % (
                              rc, (rep or {}).get("pass"),
                              pair[0].get("rule") if pair else None,
                              pair[0].get("bit_identical") if pair else None)))

    # 3. the SAME 1 ulp difference declared as one vmfb -> must FAIL (core claim kept)
    rc, log, rep, _ = synth({"x": "a.npy", "y": "b_1ulp.npy"}, {"x": SHA_X, "y": SHA_X}, "same_1ulp")
    pair = list((rep or {}).get("iree_vs_iree", {}).values())
    ok = (rc != 0 and rep and rep.get("pass") is False and pair
          and pair[0].get("rule") == "same_vmfb" and pair[0].get("passed") is False)
    results.append(Result("e25-compare: same_vmfb 1-ulp difference still FAILS (bit-identity kept)",
                          bool(ok), "rc=%d pass=%s rule=%s" % (
                              rc, (rep or {}).get("pass"), pair[0].get("rule") if pair else None)))

    # 4. cross_vmfb but beyond tolerance -> FAIL
    rc, log, rep, _ = synth({"x": "a.npy", "y": "b_coarse.npy"}, {"x": SHA_X, "y": SHA_A}, "cross_coarse")
    ok = rc != 0 and rep and rep.get("pass") is False
    results.append(Result("e25-compare: cross_vmfb beyond tolerance FAILS", bool(ok),
                          "rc=%d pass=%s" % (rc, (rep or {}).get("pass"))))

    # 5. cross_vmfb within tolerance on values but argmax flipped -> FAIL
    #    (tolerance alone must not be able to admit a different classification)
    rc, log, rep, _ = synth({"x": "a.npy", "y": "b_argmax.npy"}, {"x": SHA_X, "y": SHA_A}, "cross_argmax")
    ok = rc != 0 and rep and rep.get("pass") is False
    results.append(Result("e25-compare: cross_vmfb argmax disagreement FAILS", bool(ok),
                          "rc=%d pass=%s" % (rc, (rep or {}).get("pass"))))

    # 6. a --path without a --vmfb is refused, and nothing is written
    rc, log, rep, out = synth({"x": "a.npy", "y": "b_1ulp.npy"}, {"x": SHA_X, "y": None}, "no_vmfb")
    ok = rc != 0 and rep is None and not os.path.exists(out) and "--vmfb" in log
    results.append(Result("e25-compare: --path without --vmfb refused, no output written", bool(ok),
                          "rc=%d wrote=%s" % (rc, os.path.exists(out))))

    # 7b. a malformed --vmfb (truncated/empty) is refused rather than string-compared:
    #     two paths that share an artifact but whose shas were mistyped would otherwise
    #     compare unequal and get the WEAKER cross_vmfb rule (D28/D29/D30 shape).
    for tag, bad in (("trunc", "0e250c2f"), ("empty", ""), ("nonhex", "z" * 64)):
        rc, log, rep, out = synth({"x": "a.npy", "y": "b_1ulp.npy"},
                                  {"x": bad, "y": SHA_A}, "badsha_" + tag)
        ok = rc != 0 and rep is None and not os.path.exists(out) and "64-hex" in log
        results.append(Result("e25-compare: malformed --vmfb (%s) refused, no output written" % tag,
                              bool(ok), "rc=%d wrote=%s" % (rc, os.path.exists(out))))

    # 7c. equal-but-malformed shas must NOT be accepted as "same vmfb" either -- the
    #     refusal has to come before any pair rule is chosen.
    rc, log, rep, out = synth({"x": "a.npy", "y": "b_1ulp.npy"},
                              {"x": "0e250c2f", "y": "0e250c2f"}, "badsha_equal")
    results.append(Result("e25-compare: equal-but-malformed --vmfb pair still refused",
                          bool(rc != 0 and rep is None and not os.path.exists(out)),
                          "rc=%d wrote=%s" % (rc, os.path.exists(out))))

    # 8. deterministic output (no timestamps): same inputs twice -> identical bytes
    w1 = os.path.join(work, "det1"); w2 = os.path.join(work, "det2")
    os.makedirs(w1, exist_ok=True); os.makedirs(w2, exist_ok=True)
    a1 = call(w1, {"x": os.path.join(work, "a.npy"), "y": os.path.join(work, "b_1ulp.npy")},
              {"x": SHA_X, "y": SHA_A}, ref=os.path.join(work, "ref.npy"), model=work)
    a2 = call(w2, {"x": os.path.join(work, "a.npy"), "y": os.path.join(work, "b_1ulp.npy")},
              {"x": SHA_X, "y": SHA_A}, ref=os.path.join(work, "ref.npy"), model=work)
    same_bytes = (os.path.exists(a1[3]) and os.path.exists(a2[3])
                  and open(a1[3], "rb").read() == open(a2[3], "rb").read())
    results.append(Result("e25-compare: report is deterministic across runs", bool(same_bytes),
                          "identical=%s" % same_bytes))
    return results


def e26_instrumentation_expect_cases():
    """E26 prerequisite: the scenario harness must be able to PROVE that a memory run was
    not contaminated by the E25 equivalence mode, and must treat a missing statement as
    unproven rather than as "off".

    With /cf/e25_inputs.bin present the cFS app runs one inference per input vector during
    AI_LEARNER_Init -- 64 of them in E25 -- so by the time the run loop emits its first
    `mem` record the allocator has long since passed its init-time state. The external
    review (SS6, "measurement prerequisite") calls this out as a measurement-accuracy issue,
    not a code-quality one: init / first-call / steady would blur into one number.

    ai_learner.c therefore always emits {"stage":"e25_mode","active":<bool>} plus a
    {"stage":"mem_init",...} snapshot taken after module load and input-buffer allocation
    and BEFORE any inference. These cases pin the harness side: expect e25_mode_active=false
    passes only on a log that actually says so, and an app old enough not to emit the record
    FAILS instead of passing by silence (D29: absence of a signal is not the signal)."""
    sys.path.insert(0, HERE)
    try:
        import e14_cfs_scenarios as sc                        # noqa: PLC0415 - local module
    except Exception as e:                                    # noqa: BLE001
        return [Result("e26-instr: e14_cfs_scenarios importable", False, "%s: %s" % (type(e).__name__, e))]

    OFF = ('{"app":"AI_LEARNER","stage":"stack","es_stack_size":262160,"stack_base_bytes":262144,'
           '"contract_kernel_stack_bytes":16,"kernel_stack_accounted":true}\n'
           '{"app":"AI_LEARNER","stage":"admission","verdict":"ADMIT","bounded":786476,"budget":786477}\n'
           '{"app":"AI_LEARNER","stage":"binding","verdict":"MATCH"}\n'
           '{"app":"AI_LEARNER","stage":"mem_init","hal_peak":720932,"hal_allocated":720932,'
           '"bounded":786476,"peak_within_bounded":true,"inferences_so_far":0,"process_rss_kb":9356,'
           '"rss_kb_before_runtime":8188,"rss_kb_after_session":8492,"rss_kb_after_init":9356}\n'
           '{"app":"AI_LEARNER","stage":"e25_mode","active":false,"inputs_path":"/cf/e25_inputs.bin"}\n'
           '{"app":"AI_LEARNER","stage":"run","attempted":5,"completed":5,"fail_input":0,'
           '"fail_invoke":0,"fail_output":0}\n'
           '{"app":"AI_LEARNER","stage":"mem","completed":5,"hal_peak":786476,"peak_within_bounded":true}\n')
    ON = OFF.replace('"stage":"e25_mode","active":false', '"stage":"e25_mode","active":true')
    OLD = "\n".join(l for l in OFF.splitlines() if '"e25_mode"' not in l) + "\n"

    off, on, old = sc.parse_log(OFF), sc.parse_log(ON), sc.parse_log(OLD)
    cases = [
        ("e26-instr: e25_mode_active=false passes on a log that says active=false",
         sc.check_expect(off, {"e25_mode_active": False}) == []),
        ("e26-instr: e25_mode_active=false FAILS when the app ran the equivalence mode",
         len(sc.check_expect(on, {"e25_mode_active": False})) == 1),
        ("e26-instr: e25_mode_active=false FAILS when the record is absent (absence != off)",
         len(sc.check_expect(old, {"e25_mode_active": False})) == 1
         and "absent" in sc.check_expect(old, {"e25_mode_active": False})[0]),
        ("e26-instr: mem_init snapshot parsed with inferences_so_far=0",
         (off.get("mem_init") or {}).get("inferences_so_far") == 0
         and (off.get("mem_init") or {}).get("hal_peak") == 720932),
        ("e26-instr: mem_init_present FAILS when the app emits no init snapshot",
         sc.check_expect(off, {"mem_init_present": True}) == []
         and len(sc.check_expect(sc.parse_log(
             "\n".join(l for l in OFF.splitlines() if '"mem_init"' not in l) + "\n"),
             {"mem_init_present": True})) == 1),
        # the init snapshot must not be mistaken for the run-loop record or vice versa
        ("e26-instr: mem_init and mem stay distinct records",
         (off.get("mem_init") or {}).get("hal_peak") == 720932
         and (off.get("last_mem") or {}).get("hal_peak") == 786476),
    ]
    return [Result(n, bool(ok)) for n, ok in cases]


def _synthetic_objdump(tmp, tag, body_lines, fmt="elf64-x86-64"):
    """Write minimal `objdump -d` text the elf_stack_frame parser accepts and
    return its path (analyze() takes a path, not the text)."""
    text = ("\nsynthetic:     file format %s\n\n\nDisassembly of section .text:\n\n"
            "0000000000001000 <synthetic_start>:\n" % fmt) + "\n".join(body_lines) + "\n"
    path = os.path.join(tmp, "objdump_%s.txt" % re.sub(r"[^a-z0-9]+", "_", tag.lower()))
    with open(path, "w", encoding="utf-8") as f:
        f.write(text)
    return path


def call_resolution_cases(tmp):
    """E26a: resolving internal call targets must only ever turn 'unresolved' into
    'resolved', and must refuse on the first thing it cannot prove.

    elf_stack_frame.py's classify() has always told the reader to "resolve targets
    (imports/runtime) before classifying" and then never resolved them, so ANY call
    instruction put a model in bucket (3)/(4) and gen_contract_header.py (E21/D22)
    refused a deployable header. Every model this repository had measured has
    total_call_insns == 0 -- hand-written linalg lowers to self-contained dispatch
    functions -- so the gap was structurally invisible to the existing model set.
    A real public CNN exposes it immediately (MLPerf Tiny ResNet's softmax dispatch
    calls a compiler-generated float helper inside the same ELF 80 times).

    These cases pin the REFUSALS, because the fix widens what is accepted and the
    danger is now under-reporting stack (fail-open), not over-rejecting."""
    import elf_stack_frame as esf                              # noqa: PLC0415 - local module
    results = []

    counter = [0]

    def analyze_text(lines):
        counter[0] += 1
        return esf.analyze(objdump_txt=_synthetic_objdump(tmp, "c%d" % counter[0], lines))

    # A leaf dispatch that calls a local helper: both frames visible -> RESOLVED.
    ok_lines = [
        "    1000:\tpush   %rbp",
        "    1001:\tsub    $0x40,%rsp",
        "    1005:\tcall   1100 <synthetic_start+0x100>",
        "    100a:\tadd    $0x40,%rsp",
        "    100e:\tpop    %rbp",
        "    100f:\tret",
        "",
        "0000000000001100 <helper>:",
        "    1100:\tpush   %rbx",
        "    1101:\tmulss  %xmm1,%xmm0",
        "    1105:\tpop    %rbx",
        "    1106:\tret",
    ]
    a = analyze_text(ok_lines)
    cr = a.get("call_resolution") or {}
    results.append(Result("call-res: local direct call resolves (frames of caller and callee both counted)",
                          bool(a.get("unresolved_call_insns") == 0 and cr.get("resolved") is True
                              and a.get("max_dispatch_invocation_stack_bytes_with_calls")
                              == a["max_dispatch_invocation_stack_bytes"] + 8 + 8),
                          "unresolved=%s with_calls=%s alone=%s"
                          % (a.get("unresolved_call_insns"),
                             a.get("max_dispatch_invocation_stack_bytes_with_calls"),
                             a.get("max_dispatch_invocation_stack_bytes"))))

    # Every one of these must stay unresolved: the resolver may not guess.
    refusals = [
        ("indirect call (register target)", [
            "    1000:\tpush   %rbp", "    1001:\tcall   *%rax",
            "    1003:\tpop    %rbp", "    1004:\tret"]),
        ("call outside the disassembled range", [
            "    1000:\tpush   %rbp", "    1001:\tcall   9000 <elsewhere>",
            "    1006:\tpop    %rbp", "    1007:\tret"]),
        ("callee tail-jumps into another known function", [
            "    1000:\tpush   %rbp", "    1001:\tcall   1100 <helper>",
            "    1006:\tpop    %rbp", "    1007:\tret",
            "", "0000000000001100 <helper>:",
            "    1100:\tjmp    1200 <other>",
            "", "0000000000001200 <other>:",
            "    1200:\tret"]),
        ("callee grows the stack dynamically", [
            "    1000:\tpush   %rbp", "    1001:\tcall   1100 <helper>",
            "    1006:\tpop    %rbp", "    1007:\tret",
            "", "0000000000001100 <helper>:",
            "    1100:\tsub    %rax,%rsp", "    1103:\tret"]),
        ("callee has an indirect branch", [
            "    1000:\tpush   %rbp", "    1001:\tcall   1100 <helper>",
            "    1006:\tpop    %rbp", "    1007:\tret",
            "", "0000000000001100 <helper>:",
            "    1100:\tjmp    *%rdx", "    1102:\tret"]),
        ("callee calls back into its caller (recursion)", [
            "    1000:\tpush   %rbp", "    1001:\tcall   1100 <helper>",
            "    1006:\tpop    %rbp", "    1007:\tret",
            "", "0000000000001100 <helper>:",
            "    1100:\tcall   1100 <helper>", "    1105:\tret"]),
    ]
    for name, lines in refusals:
        a = analyze_text(lines)
        cr = a.get("call_resolution") or {}
        refused = (a.get("unresolved_call_insns") == a.get("total_call_insns") != 0
                   and cr.get("resolved") is False
                   and a.get("max_dispatch_invocation_stack_bytes_with_calls") is None
                   # bucket (3)/(4) normally; bucket (4) when the callee's own dynamic
                   # alloca makes the whole executable unaccounted -- both are refusals,
                   # and neither may be the resolved bucket (2) wording.
                   and "TASK-STACK with resolved calls" not in (a.get("classification_note") or ""))
        results.append(Result("call-res: %s stays unresolved" % name, bool(refused),
                              "unresolved=%s/%s reason=%s"
                              % (a.get("unresolved_call_insns"), a.get("total_call_insns"),
                                 str(cr.get("reason"))[:70])))

    # The real artifact this was found on, preserved so the claim is reproducible from
    # the repository alone (D43's lesson: a fix justified by "a real model does X" needs
    # that model in the tree). MLPerf Tiny ResNet, CIFAR-10, converted through
    # tflite2onnx -> iree-import-onnx -> iree-opt -> ONE iree-compile. Its softmax
    # dispatch calls two compiler-generated float helpers 80 times; both live inside
    # this ELF's .text, both are leaves with a zero-byte frame, and one of them branches
    # forward past its own first `ret` -- which is why slicing a callee at its first ret
    # (the first implementation here) produced a FALSE refusal on it.
    fx = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                      "mlperf_tiny_resnet_fixture")
    objd = os.path.join(fx, "embedded_elf.objdump.txt")
    so = os.path.join(fx, "embedded_elf.so")
    if not os.path.exists(objd) or not os.path.exists(so):
        results.append(Result("call-res: MLPerf Tiny ResNet fixture present", False,
                              "missing %s / %s" % (objd, so)))
    elif shutil.which("objdump") is None:
        results.append(Result("call-res: MLPerf Tiny ResNet resolves (needs the ELF's own "
                              "symbol/export table)", True, "objdump not installed", skip=True))
    else:
        # Degradation check first: given ONLY a disassembly, the function-boundary
        # heuristic (ret+padding) over-splits this ELF into 23 functions instead of 17,
        # so a forward branch inside the 0x5440 helper looks like a tail call into a
        # neighbour and the resolver REFUSES. That is the behaviour we want from worse
        # information -- a conservative refusal, never a smaller number.
        a_txt = esf.analyze(objdump_txt=objd)
        results.append(Result("call-res: disassembly without the ELF degrades to a refusal, not a "
                              "wrong figure", bool(a_txt.get("unresolved_call_insns") == 80
                                                   and a_txt.get("max_dispatch_invocation_stack_bytes_with_calls") is None),
                              "unresolved=%s" % a_txt.get("unresolved_call_insns")))
        a = esf.analyze(elf_path=so)
        cr = a.get("call_resolution") or {}
        results.append(Result("call-res: real MLPerf Tiny ResNet -- 80 calls, 2 internal targets, resolved",
                              bool(a.get("total_call_insns") == 80 and a.get("unresolved_call_insns") == 0
                                   and cr.get("resolved") is True
                                   and cr.get("distinct_targets") == ["0x53c0", "0x5440"]
                                   and all(c["frame_bytes"] == 0 for c in cr.get("callees", []))
                                   and a.get("max_dispatch_invocation_stack_bytes_with_calls") == 439),
                              "targets=%s with_calls=%s" % (cr.get("distinct_targets"),
                                                            a.get("max_dispatch_invocation_stack_bytes_with_calls"))))
        # the softmax dispatch itself must carry the +8 return address of its callee
        chains = cr.get("per_function_chain_stack_bytes") or {}
        sm = [(n, v) for n, v in chains.items() if "softmax" in n]
        inv = {f["name"]: f["invocation_stack_bytes"] for f in a["functions"]}
        results.append(Result("call-res: the calling dispatch's chain = its own frame + the callee's",
                              bool(len(sm) == 1 and sm[0][1] == inv[sm[0][0]] + 8),
                              "%s: inv=%s chain=%s" % (sm[0][0][:40] if sm else "?",
                                                       inv.get(sm[0][0]) if sm else None,
                                                       sm[0][1] if sm else None)))
        # and it must reach a deployable header, with no override
        rc, so, se = run([PY, GEN_HEADER, os.path.join(fx, "resnet.contract.json"),
                          os.path.join(tmp, "resnet_check.h")])
        hdr = open(os.path.join(tmp, "resnet_check.h")).read() if rc == 0 else ""
        results.append(Result("call-res: ResNet contract yields a deployable header with no override",
                              bool(rc == 0 and "#define CONTRACT_KERNEL_STACK_BYTES_KNOWN 1" in hdr
                                   and "#define CONTRACT_KERNEL_STACK_BYTES 439L" in hdr
                                   and "#define CONTRACT_BOUND_KNOWN 1" in hdr),
                              "rc=%d" % rc))

    # make_contract.py must fall back to the TOTAL count when the analysis file predates
    # the resolver -- an old JSON must not be read as "nothing unresolved".
    src = open(os.path.join(HERE, "make_contract.py"), encoding="utf-8").read()
    results.append(Result("call-res: make_contract falls back to total_call_insns when the "
                          "analysis has no resolver verdict",
                          "calls = total_calls if unresolved_calls is None else unresolved_calls" in src,
                          "source-level guard"))
    return results


MULTIOUT_DIR = os.path.join(os.path.dirname(HERE), "results", "e26c_multiout")
MULTIOUT_SUBVIEW_LINE = ("%2 = stream.resource.subview %result[%c64_3] : "
                         "!stream.resource<external>{%c128_4} -> !stream.resource<external>{%c16}")


A5B_CANONICAL_DIR = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                                  "aarch64", "a5b_canonical")


EXT_B2_DIR = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                          "x86_64", "ext_b2_resnet")


EXT_B3_DIR = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                          "x86_64", "ext_b3_deepae")


E27_SUMMARY = os.path.join(os.path.dirname(HERE), "results", "e27_baselines", "summary.json")


RESULTS_DIR = os.path.join(os.path.dirname(HERE), "results")


E36_DIR = os.path.join(os.path.dirname(HERE), "results", "e36_aarch64_cfs")


def e36_aarch64_cfs_cases():
    """E36: the AArch64 cFS cells SS10 stage 2 asked for, pinned from the guest raw logs.

    Two of these exist because the change that produced them ALSO produced two defects
    (evidence SS6), and neither was caught by a test -- both were caught by a field the plan
    required every admission record to carry.  So the pins here are on that field as much as
    on the verdicts: a refusal must say which budget it refused against, or a budget of 0
    from a botched edit reads exactly like a principled denial."""
    results = []
    p = os.path.join(E36_DIR, "summary.json")
    if not os.path.exists(p):
        results.append(Result("e36: summary present", False, "missing %s" % p))
        return results
    d = load(p)
    c, PER_CALL = d["cells"], 9382092

    _ok = (c["deny_B_minus_1"]["verdict"] == "NOT_ADMITTED"
           and c["deny_B_minus_1"]["inferences"] == 0
           and c["deny_B_minus_1"]["budget_bytes"] == 18222795)
    results.append(Result("e36 Q1: the cFS budget-shortfall cell refuses and runs zero inferences "
                          "(unreachable in E32 -- the budget was a compile-time constant)", _ok,
                          "" if _ok else json.dumps(c["deny_B_minus_1"])[:220]))

    alive = c["deny_B_minus_1"].get("cfs_alive_after_refusal", {})
    _ok = alive.get("exit_app_logged") is True and len(alive.get("apps_loaded_after", [])) >= 4
    results.append(Result("e36 Q1: and the rest of cFS keeps running afterwards -- the stage-2 "
                          "criterion, checked on the log rather than assumed", _ok,
                          "" if _ok else json.dumps(alive)[:220]))

    for cell in ("malformed_abc", "zero_budget"):
        _ok = c[cell]["budget_invalid_event"] and c[cell]["inferences"] == 0
        results.append(Result("e36 Q1b: a malformed budget override (%s) refuses initialisation "
                              "instead of silently falling back to the compiled-in budget" % cell,
                              _ok, "" if _ok else json.dumps(c[cell])[:200]))

    cp = c["cond_positive"]
    _ok = (cp["verdict"] == "ADMIT_CONDITIONAL_MAP" and cp["admitted_budget_bytes"] == PER_CALL
           and cp["hal_peak"] == PER_CALL and cp["peak_within_admitted_budget"] is True
           and cp["inferences"] > 0)
    results.append(Result("e36 Q2: the conditional tier runs on AArch64 cFS with the real 8.9 MB "
                          "model and the peak lands EXACTLY on the budget it was admitted on", _ok,
                          "" if _ok else json.dumps(cp)[:240]))
    mb = cp.get("map_branch", {})
    _ok = mb.get("arm") == "map" and mb.get("module_ptr_mod64") == 0 and mb.get("hal_peak_after_append") == 0
    results.append(Result("e36 Q2: and E29b's two preconditions are recorded as MEASURED, not "
                          "assumed (64B-aligned image, zero append peak)", _ok,
                          "" if _ok else json.dumps(mb)[:200]))
    _ok = c["cond_denied_without_optin"]["verdict"] == "NOT_ADMITTED"
    results.append(Result("e36 Q2: the control -- the same budget without the opt-in is refused, so "
                          "the pass is the conditional tier and not a loose budget", _ok,
                          "" if _ok else json.dumps(c["cond_denied_without_optin"])[:200]))

    r = c["regression_no_override"]
    _ok = (r["budget_source"] == "macro" and r["budget_bytes"] == 18222797
           and r["verdict"] == "ADMIT" and r["hal_peak"] == PER_CALL
           and r["admission_mode"] == "unconditional" and r["peak_within_admitted_budget"] is True)
    results.append(Result("e36 Q4: with the override unset the app reproduces E32's deterministic "
                          "values exactly -- the knob did not change the existing verdicts", _ok,
                          "" if _ok else json.dumps(r)[:240]))

    _ok = all(c[n]["budget_source"] in ("macro", "override") or c[n]["budget_invalid_event"]
              for n in c)
    results.append(Result("e36: every cell testifies which budget it judged on -- the field that "
                          "caught both defects this change introduced", _ok,
                          "" if _ok else "a cell has no budget_source"))

    # the build script must pass the opt-in explicitly: `${VAR:+-D...}` inherited a stale
    # CMakeCache value and turned a deny cell into ADMIT_CONDITIONAL_MAP (evidence SS6.2)
    sh = os.path.join(os.path.dirname(HERE), "scripts", "51_build_cfs_aarch64.sh")
    txt = open(sh, encoding="utf-8", errors="replace").read() if os.path.exists(sh) else ""
    _ok = ('ALLOW_CONDITIONAL_MAP="${ALLOW_CONDITIONAL_MAP:-0}"' in txt
           and "${ALLOW_CONDITIONAL_MAP:+" not in txt
           and "did not reach the ai_learner.c compile (stale CMakeCache?)" in txt)
    results.append(Result("e36 D61: the AArch64 build passes the conditional opt-in explicitly and "
                          "verifies it reached the compile (a shared cmake tree remembers)", _ok,
                          "" if _ok else "51_build_cfs_aarch64.sh still lets an unset opt-in inherit the cache"))

    src = os.path.join(os.path.dirname(HERE), "native", "cfs_app", "fsw", "src", "ai_learner.c")
    ctxt = open(src, encoding="utf-8", errors="replace").read() if os.path.exists(src) else ""
    _ok = "g.budget_bytes = g.budget_bytes" not in ctxt and "return g.budget_bytes > 0;" in ctxt
    results.append(Result("e36 D61: the macro path really reads the macro, and a non-positive "
                          "budget is an explicit refusal rather than a denial that hides its cause",
                          _ok, "" if _ok else "the resolver is back to a self-assignment or drops the > 0 check"))
    return results


E36B_DIR = os.path.join(os.path.dirname(HERE), "results", "e36b_aarch64_models")


def e36b_aarch64_models_cases():
    """E36b / stage 4's remaining half: the two public models on AArch64.

    The interesting pin is D62. Two runners carried SmartCam's output arity as a literal
    3; one of them sliced a 10-output classifier down to three values and the comparator
    then reported 340/340 elements failed with worst_abs 0.0 -- a verdict and an error
    that contradict each other, which is the shape of a TOOL defect, not a finding. So the
    pins are on the generalisation as much as on the results: the arity must come from the
    contract, and refusing to slice a shape the model does not have must stay an explicit
    refusal rather than a silent truncation."""
    results = []
    p = os.path.join(E36B_DIR, "summary.json")
    if not os.path.exists(p):
        results.append(Result("e36b: summary present", False, "missing %s" % p))
        return results
    d = load(p)
    for name, m in sorted(d["models"].items()):
        _ok = m["contract_identical_to_x86_64"] and not m.get("overrides_applied")
        results.append(Result("e36b %s: the AArch64 contract's three figures equal the x86-64 ones "
                              "with zero overrides" % name, _ok,
                              "" if _ok else json.dumps(m["contract"])[:200]))
        for path in ("semantics_native_aarch64", "semantics_cfs_aarch64"):
            t = m[path]
            _ok = t["verdict"] == "PASS" and t["elements_failed"] == 0 and t["elements"] > 0
            results.append(Result("e36b %s: %s -- every output element meets the criterion inherited "
                                  "unchanged from E25" % (name, path.replace("semantics_", "")), _ok,
                                  "" if _ok else json.dumps(t)[:200]))
        a, n = m["cfs_admit"], m["cfs_deny_B_minus_1"]
        _ok = (a["verdict"] == "ADMIT" and a["peak_within_admitted_budget"] is True
               and a["inferences"] > 0 and n["verdict"] == "NOT_ADMITTED"
               and n["budget"] == a["budget"] - 1 and n["budget_source"] == "override")
        results.append(Result("e36b %s: the cFS budget boundary holds on AArch64 (B admits and stays "
                              "inside, B-1 refuses via the E36 runtime override)" % name, _ok,
                              "" if _ok else json.dumps({"admit": a, "deny": n})[:260]))
        _ok = a["hal_peak"] == m["contract"]["static_per_call_bytes"]
        results.append(Result("e36b %s: the deployed peak is exactly per_call -- the app aligns its "
                              "own blob, so the map arm is what runs (E29b)" % name, _ok,
                              "" if _ok else "peak=%s per_call=%s" % (a["hal_peak"], m["contract"]["static_per_call_bytes"])))

    h = d["harness_reuse"]
    _ok = h["new_model_specific_harnesses"] == 0 and h["model_specific_branches"] == 0 and h["generalised"]
    results.append(Result("e36b: stage 4's reuse criterion is recorded honestly -- zero new harnesses, "
                          "and the two that had to be generalised are named", _ok,
                          "" if _ok else json.dumps(h)[:220]))

    # D62: neither runner may go back to a literal output arity
    # the literal must be gone as an EFFECTIVE value; `DEFAULT_OUT_ELEMS = 3` is fine
    # (it only reproduces E32's SmartCam runs when no contract is given), so match the
    # bare assignment at line start rather than the substring
    for tool, const in (("e32_native_aarch64.py", r"^\s*per = 3\s*$"),
                        ("e32_cfs_outputs.py", r"^OUT_ELEMS = 3\s*$")):
        f = os.path.join(HERE, tool)
        txt = open(f, encoding="utf-8", errors="replace").read() if os.path.exists(f) else ""
        _ok = ("--contract" in txt and not re.search(const, txt, re.M)
               and 'interface"].get("outputs")' in txt.replace("'", '"'))
        results.append(Result("e36b D62: %s takes the output arity from the contract, not from a "
                              "literal that only fits SmartCam" % tool, _ok,
                              "" if _ok else "the SmartCam arity is back as a literal in %s" % tool))
    f = os.path.join(HERE, "e32_native_aarch64.py")
    txt = open(f, encoding="utf-8", errors="replace").read() if os.path.exists(f) else ""
    _ok = "refusing to slice a shape the model does not have" in txt
    results.append(Result("e36b D62: and a byte count that does not divide by that arity is an "
                          "explicit refusal, never a silent truncation", _ok,
                          "" if _ok else "the native runner no longer refuses a non-dividing output blob"))
    return results


E37_DIR = os.path.join(os.path.dirname(HERE), "results", "evidence_linkage")


def e37_evidence_linkage_cases():
    """E37: the three-model evidence linkage table, and what it must never be allowed to become.

    The table's whole value is that a reader can walk from a claim to the raw file and the
    judging code.  Two ways that value can quietly evaporate, both of which this repository
    has already been bitten by, are pinned here:

      * D55 -- a document cites a raw log that is not in the repository.  Every path the table
        names must exist AND be git-tracked, or the table is citing something a fresh clone
        will not have.
      * D29 -- a missing key read as a zero.  The first version of the generator resolved each
        admission cell as ONE parent object, so E36b's DENY cells passing without `inferences`
        looked like a filled cell.  Adversarial verification caught it.  The locators are now
        per-sub-key, and this test pins that: if any item-4 locator loses its sub-key suffix,
        the granularity has regressed to the version that could not see the gap.

    A null is not automatically a gap, and that distinction is the third thing pinned here: on
    a refused cell there IS no approved budget, and on a BUDGET_INVALID cell there is no
    admission record at all -- those nulls are licensed by a POSITIVE signal in the same
    record (the verdict, or budget_invalid_event), never by absence."""
    results = []
    root = os.path.dirname(HERE)
    linkage = os.path.join(E37_DIR, "linkage.json")

    if not os.path.exists(linkage):
        results.append(Result("e37: linkage table present", False, "missing %s" % linkage))
        return results

    rc, out, err = run([sys.executable, os.path.join(HERE, "mk_evidence_linkage.py"), "--check"])
    results.append(Result("e37: the linkage table regenerates from the raw data unchanged "
                          "(no value in it was typed by hand)", rc == 0,
                          "" if rc == 0 else (out + err).strip()[:300]))

    data = load(linkage)
    t = data["totals"]
    _ok = t["cells"] == 21 and t["not_present"] == 0
    results.append(Result("e37: all 21 cells (3 models x 7 items) resolve", _ok,
                          "" if _ok else "not_present=%s %s" % (t["not_present"],
                                                                data["cells_not_present"])))

    # D55: every raw path the table cites must be in the repository AND tracked.
    cited = set()
    for m in data["models"].values():
        for num, item in m["items"].items():
            for src in item.get("sources", []):
                cited.add(src["path"])
            for e in item.get("entries", []):
                for k in ("raw", "script"):
                    if e.get(k):
                        cited.add(e[k])
    missing = [p for p in sorted(cited) if not os.path.exists(os.path.join(root, p))]
    results.append(Result("e37: every path the table cites exists on disk", not missing,
                          "" if not missing else "missing: %s" % missing[:4]))
    untracked = []
    for p in sorted(cited):
        if os.path.exists(os.path.join(root, p)):
            r = subprocess.run(["git", "-C", root, "ls-files", "--error-unmatch", p],
                               capture_output=True, text=True)
            if r.returncode != 0:
                untracked.append(p)
    results.append(Result("e37: and every one of them is git-tracked (D55: a table that cites "
                          "an untracked file does not survive a fresh clone)", not untracked,
                          "" if not untracked else "untracked: %s" % untracked[:4]))

    # D29: a null that no positive signal licenses is a gap, not a value.
    unlicensed = []
    for name, m in data["models"].items():
        for num, item in m["items"].items():
            for src in item.get("sources", []):
                if src["status"] == "null_value":
                    unlicensed.append("%s/%s %s" % (name, num, src["locator"]))
    results.append(Result("e37: no cell is filled with an unlicensed null (a null is only a "
                          "value when a positive signal in the same record allows it)",
                          not unlicensed, "" if not unlicensed else str(unlicensed[:4])))

    # The granularity fix itself. Item 4 must be resolved per sub-key, never per parent object.
    coarse = []
    for name, m in data["models"].items():
        for src in m["items"]["4"].get("sources", []):
            leaf = src["locator"].rsplit(".", 1)[-1]
            if leaf not in ("verdict", "budget_bytes", "budget_source", "inferences", "hal_peak",
                            "admitted_budget_bytes", "peak_within_admitted_budget",
                            "admission_mode"):
                coarse.append("%s: %s" % (name, src["locator"]))
    results.append(Result("e37: item 4 is resolved per sub-key, not per parent object -- the "
                          "granularity that let E36b's missing `inferences` pass as filled",
                          not coarse, "" if not coarse else str(coarse[:4])))

    # E36b's DENY cells must actually carry the field whose absence started this.
    b = os.path.join(E36B_DIR, "summary.json")
    if os.path.exists(b):
        bs = load(b)
        gaps = [m for m in ("b2_resnet", "b3_deepae")
                if "inferences" not in bs["models"][m]["cfs_deny_B_minus_1"]]
        results.append(Result("e37: E36b's DENY cells record `inferences` explicitly (0), so a "
                              "reader never has to infer 'no inference' from an absent key",
                              not gaps, "" if not gaps else "still absent for %s" % gaps))
        zero = [m for m in ("b2_resnet", "b3_deepae")
                if bs["models"][m]["cfs_deny_B_minus_1"].get("inferences") != 0]
        results.append(Result("e37: and the value derived from the guest log is 0", not zero,
                              "" if not zero else str(zero)))

    # Reproduction check (mandatory work C): the judging step re-run on the final code.
    rep = os.path.join(E37_DIR, "reproduce_check.json")
    if not os.path.exists(rep):
        results.append(Result("e37: reproduce_check present", False, "missing %s" % rep))
    else:
        rp = load(rep)
        _ok = rp.get("verdict") == "PASS" and rp["totals"]["differing"] == 0 \
            and rp["totals"]["tool_error"] == 0
        results.append(Result("e37: re-judging every archived cell with the FINAL code gives the "
                              "stored verdict (%d cells)" % rp["totals"]["cells"], _ok,
                              "" if _ok else json.dumps(rp["totals"])))
        # The table must READ that result, not restate it.
        by_cell = {c["cell"]: c.get("identical") for c in rp["cells"]}
        wrong = []
        for name, m in data["models"].items():
            for e in m["items"]["7"].get("entries", []):
                if e.get("rejudge_cell"):
                    if e.get("rejudged_at_final_version") != by_cell.get(e["rejudge_cell"]):
                        wrong.append("%s/%s" % (name, e["rejudge_cell"]))
        results.append(Result("e37: the table's re-judge column is read from the check's own "
                              "output, not asserted independently", not wrong,
                              "" if not wrong else str(wrong[:4])))
    return results


def e37_truncated_record_cases():
    """E37 / D68: a record the parser could not read is not a record that is not there.

    The E36b summary generator this experiment wrote counted `run` records with
    `except ValueError: continue`, so DeepAE -- whose run lines carry a 640-element output
    array and are cut at 766 characters -- was recorded as `run_records: 0` while SEVEN such
    records sat in the log.  The generator's own docstring said "absence is not zero".  This is
    D51's shape again: "could not see it" written down as "looked and there was nothing".

    Pinned from both ends: the truncated lines really are in the archived log (so the condition
    is real, not a paraphrase), and the summary reports them as observed-but-unparseable rather
    than as absent."""
    results = []
    log = os.path.join(E36B_DIR, "cfs", "deepae_admit_B.log")
    if not os.path.exists(log):
        results.append(Result("e37/d68: deepae admit log present", False, log))
        return results

    seen = unparsed = 0
    for line in open(log, encoding="utf-8", errors="replace"):
        i = line.find('{"app":"AI_LEARNER"')
        if i < 0:
            continue
        frag = line[i:].strip()
        if '"stage":"run"' not in frag:
            continue
        seen += 1
        try:
            json.loads(frag)
        except ValueError:
            unparsed += 1
    _ok = seen > 0 and unparsed == seen
    results.append(Result("e37/d68: the archived DeepAE log really does carry run records whose "
                          "payload is truncated (%d of %d)" % (unparsed, seen), _ok,
                          "" if _ok else "seen=%d unparsed=%d" % (seen, unparsed)))

    summ = os.path.join(E36B_DIR, "summary.json")
    if os.path.exists(summ):
        cell = load(summ)["models"]["b3_deepae"]["cfs_admit"]
        _ok = cell.get("run_records") == seen
        results.append(Result("e37/d68: and the summary counts them as observed (%d), not as 0 -- "
                              "a payload the parser cannot read still proves the record existed"
                              % seen, _ok, "" if _ok else "run_records=%s" % cell.get("run_records")))
        _ok = cell.get("run_records_unparseable") == unparsed
        results.append(Result("e37/d68: the summary says how many it could not parse, so the "
                              "reader is never handed a silent count", _ok,
                              "" if _ok else "unparseable=%s" % cell.get("run_records_unparseable")))
        deny = load(summ)["models"]["b3_deepae"]["cfs_deny_B_minus_1"]
        _ok = deny.get("run_records") == 0 and deny.get("run_records_unparseable") == 0
        results.append(Result("e37/d68: and a genuinely empty cell still reads 0/0 -- the fix did "
                              "not turn 'no records' into 'unknown'", _ok,
                              "" if _ok else json.dumps(deny)))

    for gen in ("mk_e36_summary.py", "mk_e36b_summary.py"):
        txt = open(os.path.join(HERE, gen), encoding="utf-8", errors="replace").read()
        _ok = "__unparsed__" in txt and "record_count" in txt
        results.append(Result("e37/d68: %s counts unparseable records instead of dropping them"
                              % gen, _ok, "" if _ok else "still drops them silently"))
    return results


def e37_guest_rerun_cases():
    """E37 §5: the one cell that genuinely needed the guest again, and what it settled.

    E32's SmartCam cFS equivalence cell was produced by `ai_learner.c` BEFORE D61 added the
    runtime budget resolver, and E36's no-override regression cell did not exercise that path
    (`e25_mode active=false` in all seven E36 cells; only E32's A_admit.log has it true).  So it
    was the single cell whose currency could not be settled from archived material -- everything
    else was re-judged in place.  It was re-run on the final code and the result is compared,
    element for element, against the pre-D61 run: same verdict, same totals, same worst element.

    The comparison direction matters.  This does NOT say "D61 was harmless" in general; it says
    this cell's numbers did not move, which is the only thing the cell can testify to."""
    results = []
    d = os.path.join(os.path.dirname(HERE), "results", "e37_evidence_consolidation",
                     "s_cfs_post_d61")
    summ = os.path.join(d, "summary.json")
    if not os.path.exists(summ):
        results.append(Result("e37/rerun: the re-run cell is preserved", False, "missing %s" % summ))
        return results
    js = load(summ)

    rec = js.get("app_records", {})
    _ok = (rec.get("e25_mode") or {}).get("active") is True
    results.append(Result("e37/rerun: the app itself testifies the equivalence mode was ON -- the "
                          "whole reason this cell needed re-running is that E36's cells had it off",
                          _ok, "" if _ok else json.dumps(rec.get("e25_mode"))))
    eq = rec.get("e25_equivalence") or {}
    _ok = eq.get("inputs") == 5 and eq.get("completed") == 5
    results.append(Result("e37/rerun: five inputs replayed, five completed", _ok,
                          "" if _ok else json.dumps(eq)))
    adm = rec.get("admission") or {}
    _ok = adm.get("verdict") == "ADMIT" and adm.get("budget_source") == "macro"
    results.append(Result("e37/rerun: and it ran through the same admission gate (the budget "
                          "resolver D61 added reports which budget it judged on)", _ok,
                          "" if _ok else json.dumps(adm)))

    m = js.get("matches_e32_pre_d61", {})
    for key in ("verdict", "totals", "worst_element"):
        _ok = m.get(key) is True
        results.append(Result("e37/rerun: %s is identical to the pre-D61 run" % key, _ok,
                              "" if _ok else "differs"))

    cmpf = os.path.join(d, "comparison.json")
    if os.path.exists(cmpf):
        c = load(cmpf)
        _ok = c.get("verdict") == "PASS" and (c.get("totals") or {}).get("elements_failed") == 0
        results.append(Result("e37/rerun: judged by the same pre-fixed criteria, not a new rule",
                              _ok and (c.get("criteria") or {}).get("abs_tol") == 1e-4,
                              "" if _ok else json.dumps(c.get("totals"))))

    raw = os.path.join(d, "s_cfs_equiv.log")
    tracked = subprocess.run(["git", "-C", os.path.dirname(HERE), "ls-files", "--error-unmatch",
                              os.path.relpath(raw, os.path.dirname(HERE))],
                             capture_output=True, text=True).returncode == 0
    results.append(Result("e37/rerun: the guest raw log is committed (D55 -- a cited log that is "
                          "not in the repository does not survive a fresh clone)",
                          os.path.exists(raw) and tracked,
                          "" if tracked else "raw log present but untracked"))
    return results


def e37_peak_vs_budget_cases():
    """E37 §5b: "the peak fit in the budget" and "the bound was tight" are different sentences.

    The completeness critic caught the claim sentence flattening these.  Measured: on the
    unconditional cells the observed HAL peak is 51.5% / 50.0% / 0.6% of the budget it was
    approved on; exactly ONE cell reaches 100.0%, and it is the conditional one.  The slack is
    not evidence of tightness -- it is E29b making the app 64-byte-align its own blob so the map
    arm is taken; the same DeepAE measured on the x86-64 source-built runtime takes the copy arm
    and reports 1,069,632 (E26f).

    So this pins two things at once: every admitted cell really is within its approved budget
    (the claim), and the ratios really do vary (the qualifier).  If a later change made every
    cell sit at 100%, the second check fails and someone has to look -- because that would mean
    the arm changed, not that the contract got tighter."""
    results = []
    cells = []
    e36 = os.path.join(E36_DIR, "summary.json")
    if os.path.exists(e36):
        for name, c in load(e36)["cells"].items():
            if c.get("hal_peak") is not None and c.get("admitted_budget_bytes"):
                cells.append(("smartcam/" + name, c["hal_peak"], c["admitted_budget_bytes"],
                              c.get("admission_mode")))
    e36b = os.path.join(E36B_DIR, "summary.json")
    if os.path.exists(e36b):
        for m, blk in load(e36b)["models"].items():
            c = blk.get("cfs_admit") or {}
            if c.get("hal_peak") is not None and c.get("admitted_budget_bytes"):
                cells.append((m + "/cfs_admit", c["hal_peak"], c["admitted_budget_bytes"],
                              c.get("admission_mode")))
    if not cells:
        results.append(Result("e37/peak: admitted cells present", False, "no cells found"))
        return results

    over = ["%s %d>%d" % (n, p, b) for n, p, b, _ in cells if p > b]
    results.append(Result("e37/peak: every admitted cell's observed peak is within the budget it "
                          "was approved on (%d cells)" % len(cells), not over,
                          "" if not over else str(over)))

    ratios = {n: p / float(b) for n, p, b, _ in cells}
    at_bound = [n for n, r in ratios.items() if abs(r - 1.0) < 1e-9]
    _ok = len(at_bound) == 1 and "cond_positive" in at_bound[0]
    results.append(Result("e37/peak: exactly one cell sits AT its budget and it is the "
                          "conditional one -- the rest have slack, so 'within budget' must not "
                          "be quoted as tightness", _ok,
                          "" if _ok else "cells at bound: %s" % at_bound))

    spread = max(ratios.values()) - min(ratios.values())
    results.append(Result("e37/peak: the ratios really do vary (%.1f%%..%.1f%%) -- if they all "
                          "collapsed to one value the try_map arm changed, not the contract"
                          % (100 * min(ratios.values()), 100 * max(ratios.values())),
                          spread > 0.5, "spread=%.3f" % spread))

    for doc in ("docs/EVIDENCE_v0.41_E37.md", "CLAUDE.md"):
        txt = open(os.path.join(os.path.dirname(HERE), doc), encoding="utf-8",
                   errors="replace").read()
        _ok = "tightness의" in txt and "승인 근거 예산 이하" in txt
        results.append(Result("e37/peak: %s states the bound as 'within the approved budget' and "
                              "says outright that this is not a tightness claim" % doc, _ok,
                              "" if _ok else "the qualifier is missing"))
    return results


def e37_d60_extension_cases():
    """E37: the D60 erratum, extended to the places the first pass did not reach.

    v0.38.1 retracted "released" in the evidence document.  Reading the raw data again for the
    linkage table showed the retracted wording still standing in two machine-readable places a
    later reader would take as current -- the summary the document cites, and the plugin's own
    docstring.  A retraction that lives only in prose gets restored by the next person who reads
    the source.  It also showed the guard pinned only `p_admit` while `p_legacy` carries the
    same condition, and that the ledger's instance breakdown was miscounted.

    The correspondence between leaked instances and inference count is recorded here as a
    measurement, NOT as grounds to flip the verdict: the status stays MEMORY RELEASE NOT
    VERIFIED in both directions until someone measures the HAL peak on this path."""
    results = []
    root = os.path.dirname(HERE)

    counts = {}
    for cell, expect_inf in (("p_admit", 5), ("p_legacy", 4)):
        rj = os.path.join(E33_DIR, cell, "run.json")
        if not os.path.exists(rj):
            results.append(Result("e37/d60: %s raw run.json present" % cell, False, rj))
            continue
        tail = load(rj).get("stderr_tail", "") or ""
        hbv = len(re.findall(r'leaked instance .* of type "[^"]*HalBufferView"', tail))
        mm = len(re.findall(r'leaked instance .* of type "[^"]*MappedMemory"', tail))
        counts[cell] = (hbv, mm)
        _ok = hbv > 0 and mm > 0
        results.append(Result("e37/d60: %s also reports unreleased runtime objects (the guard "
                              "used to pin only p_admit)" % cell, _ok,
                              "" if _ok else "HalBufferView=%d MappedMemory=%d" % (hbv, mm)))
        _ok = hbv == expect_inf and mm == expect_inf
        results.append(Result("e37/d60: %s -- one of each per inference (%d), recorded as a "
                              "measurement and NOT as grounds to un-retract" % (cell, expect_inf),
                              _ok, "" if _ok else "HalBufferView=%d MappedMemory=%d" % (hbv, mm)))

    if "p_admit" in counts:
        hbv, mm = counts["p_admit"]
        log = open(os.path.join(root, "EXPERIMENT_LOG.md"), encoding="utf-8",
                   errors="replace").read()
        _ok = ("HalBufferView %d · MappedMemory %d" % (hbv, mm)) in log
        results.append(Result("e37/d60: the defect ledger's instance breakdown matches the raw "
                              "count (it said 6/4; the file says %d/%d)" % (hbv, mm), _ok,
                              "" if _ok else "ledger does not carry the counted breakdown"))

    summ = os.path.join(E33_DIR, "summary.json")
    if os.path.exists(summ):
        v = load(summ).get("verdicts", {})
        _ok = "Q4_note_erratum" in v and "NOT VERIFIED" in v.get("Q4_note_erratum", "")
        results.append(Result("e37/d60: the raw summary the evidence cites carries the erratum "
                              "beside the retracted sentence, so a machine-readable consumer "
                              "cannot read the withdrawn half as current", _ok,
                              "" if _ok else "no Q4_note_erratum in verdicts"))

    plug = os.path.join(root, "plugins", "compiled_learner", "compiled_learner_plugin.py")
    if os.path.exists(plug):
        txt = open(plug, encoding="utf-8", errors="replace").read()
        _ok = "result buffer is released each call" not in txt and "NOT VERIFIED" in txt
        results.append(Result("e37/d60: the plugin docstring no longer asserts the retracted "
                              "release (a retraction only in prose gets restored from source)",
                              _ok, "" if _ok else "the docstring still asserts release"))
    return results


def cited_raw_logs_tracked_cases():
    """D55 (v0.32.1): a summary.json may cite a raw log that is not in the repository.

    `.gitignore` ignored `*.log` and un-ignored it per experiment by hand. E28, E29
    and E29b each wrote cFS raw logs under results/, cited them from summary.json
    and from their EVIDENCE documents as the primary record, and committed -- and
    none of those nine files ever entered the repository, while every test kept
    passing because the tests read summary.json, not the logs. That is the E22
    `dump/` trap again (evidence the tests silently do not require), one level up.

    This check walks every results/**/summary.json, resolves each `"log"` field
    (repo-relative when it starts with `results/`, else relative to the summary's
    own directory -- both conventions exist in tree) and requires the file to
    exist and, in a git checkout, to be tracked. A missing or untracked citation
    is a FAIL: the record says "here is the raw log" and there is none."""
    results = []
    cited = []
    for sp in sorted(glob.glob(os.path.join(RESULTS_DIR, "**", "summary.json"), recursive=True)):
        try:
            doc = load(sp)
        except Exception as e:
            results.append(Result("d55: %s parses" % os.path.relpath(sp, os.path.dirname(HERE)), False, repr(e)))
            continue
        def walk(o):
            if isinstance(o, dict):
                for k, v in o.items():
                    if k == "log" and isinstance(v, str):
                        yield v
                    else:
                        yield from walk(v)
            elif isinstance(o, list):
                for x in o:
                    yield from walk(x)
        for rel in walk(doc):
            full = (os.path.join(os.path.dirname(HERE), rel) if rel.startswith("results/")
                    else os.path.join(os.path.dirname(sp), rel))
            cited.append((sp, rel, full))
    missing = [(sp, rel) for sp, rel, full in cited if not os.path.exists(full)]
    results.append(Result("d55: every raw log cited by a results/**/summary.json exists (%d citations)" % len(cited),
                          not missing, "missing=%s" % [(os.path.relpath(a, RESULTS_DIR), b) for a, b in missing][:6]))
    git_dir = os.path.join(os.path.dirname(HERE), ".git")
    if not (os.path.isdir(git_dir) and shutil.which("git")):
        results.append(Result("d55: every cited raw log is tracked by git", True,
                              "not a git checkout (or git missing) -- tracked-ness cannot be checked here", skip=True))
        return results
    untracked = []
    for sp, rel, full in cited:
        if not os.path.exists(full):
            continue
        rc = subprocess.run(["git", "-C", os.path.dirname(HERE), "ls-files", "--error-unmatch", full],
                            capture_output=True).returncode
        if rc != 0:
            untracked.append((os.path.relpath(sp, RESULTS_DIR), rel))
    results.append(Result("d55: every cited raw log is tracked by git (not silently .gitignored)",
                          not untracked, "untracked=%s" % untracked[:9]))
    return results


E29B_DIR = os.path.join(os.path.dirname(HERE), "results", "e29b_conditional_verify")


def e29b_conditional_verify_cases(tmp):
    """E29b / D54: the conditional tier's post-append check was a size comparison
    and let a copy arm through whenever constants < per_call.

    E29 verified the map precondition after append with
    `hal_peak_after_append > CONTRACT_PER_CALL_BYTES`. A copy arm allocates
    exactly `constants` at append, so the check passed for any model whose
    constant block is smaller than its per-call term -- the app had itself just
    labelled the arm "copy" and still ran, ending at per_call + constants over
    the budget it was admitted on. The seventh external review (SS4.1) predicted
    this from the code; every model archived before E29b has constants >
    per_call (closest: b2_resnet by 24 B), which is exactly why E29's
    revert-and-confirm-fail never saw it. `bigact` (per_call 45,444 / constants
    14,016, one iree-compile invocation) is the first fixture on the other side
    of that line, and it reproduced the fail-open in native AND in cFS: admitted
    on 45,444, ran 3/3 and 5/5, peaked at 59,460 with peak_within_bounded=true.

    The fix is two checks, both pinned here. Pre-append: the map arm is decided
    by the image's 64-byte alignment (E29, 64/64 cells), so an unaligned image
    is refused BEFORE the runtime exists -- no copy-arm allocation ever happens
    (the review's SS4.2 option 1). Post-append: B_map holds only on the map arm,
    whose append peak is exactly 0 (E29, 32/32), so the verification is
    `hal_peak_after_append != 0 -> refuse`, not a size comparison. A revert of
    either half must fail here; the aligned cells pin that neither over-rejects."""
    results = []
    summ_p = os.path.join(E29B_DIR, "summary.json")
    if not os.path.exists(summ_p):
        results.append(Result("e29b: fixture preserved", False, "missing %s" % summ_p))
        return results
    d = load(summ_p)
    fx, ar = d["fixture"], d["d54_arithmetic"]
    results.append(Result("e29b: fixture is the first archived model with constants < per_call",
                          fx["constants_lt_per_call"] and fx["constants"] < fx["per_call"],
                          "per_call=%s constants=%s" % (fx["per_call"], fx["constants"])))
    results.append(Result("e29b: the copy arm's append peak passes E29's size comparison",
                          ar["passes_old_check"] and ar["copy_arm_append_peak"] == fx["constants"]
                          and ar["copy_arm_append_peak"] <= fx["per_call"],
                          "append peak %s vs per_call %s" % (ar["copy_arm_append_peak"], fx["per_call"])))
    results.append(Result("e29b: before the fix the app ran on the copy arm above the budget it was "
                          "admitted on, in native and in cFS, with peak_within_bounded=true",
                          d["invariants_observed"]["before_fix_ran_on_copy_arm_over_admitted_budget"]
                          and ar["end_peak_on_copy_arm"] == fx["per_call"] + fx["constants"]
                          and ar["peak_within_bounded_reported"] is True,
                          "end=%s admitted=%s" % (ar["end_peak_on_copy_arm"], ar["admitted_budget"])))
    results.append(Result("e29b: after the fix the same cells refuse BEFORE runtime creation "
                          "(native + cFS), 0 inferences, cFS stays OPERATIONAL",
                          d["invariants_observed"]["after_fix_refuses_before_runtime_creation"]
                          and d["invariants_observed"]["cfs_stayed_operational_after_refusal"],
                          "cfs=%s" % d["cfs_x86_64"]["AFTER_fix_copy_condmap_budget_percall"]))
    results.append(Result("e29b: the fix does not over-reject -- aligned conditional cells still "
                          "run at exactly per_call (native + cFS)",
                          d["invariants_observed"]["after_fix_no_over_rejection_on_map_arm"],
                          "native=%s cfs=%s" % (d["native_x86_64"]["AFTER_fix_aligned_condmap_budget_percall"]["end_peak"],
                                                d["cfs_x86_64"]["AFTER_fix_aligned_condmap_budget_percall"]["end_peak"])))

    # --- source level: both halves of the fix, in both C paths (revert must fail) ---
    root = os.path.dirname(HERE)
    for label, path in (("native_learner.c", os.path.join(root, "native", "native_learner.c")),
                        ("ai_learner.c", os.path.join(root, "native", "cfs_app", "fsw", "src", "ai_learner.c"))):
        src = open(path, encoding="utf-8", errors="replace").read()
        results.append(Result("e29b: %s post-append verification is 'map arm or refuse', not a size comparison" % label,
                              "hal_peak_after_append != 0" in src
                              and "hal_peak_after_append > (long)CONTRACT_PER_CALL_BYTES" not in src,
                              "E29's `> CONTRACT_PER_CALL_BYTES` comparison is back, or `!= 0` is gone, in %s" % label))
        results.append(Result("e29b: %s refuses an unaligned image BEFORE runtime creation in the conditional tier" % label,
                              "MAP_PRECONDITION_UNMET" in src and "g.conditional_map && g.module_ptr_mod64 != 0" in src,
                              "pre-append alignment check missing in %s" % label))

    # --- the fixture regenerates from its reduced dump (one-invocation rule) ---
    if not (shutil.which("iree-compile") and shutil.which("iree-dump-module")):
        results.append(Result("e29b: contract regenerates from the preserved single-invocation artifacts",
                              True, "iree-compile/iree-dump-module not on PATH", skip=True))
        return results
    out = os.path.join(tmp, "e29b_regen.contract.json")
    cmd = [sys.executable, os.path.join(HERE, "make_contract.py"),
           "--mlir", os.path.join(E29B_DIR, "bigact.mlir"), "--vmfb", os.path.join(E29B_DIR, "bigact.vmfb"),
           "--layout-ir", os.path.join(E29B_DIR, "bigact.layout_ir.txt"), "--dump-dir", os.path.join(E29B_DIR, "dump"),
           "--triple", "x86_64-unknown-linux-gnu", "--cpu", "host", "--model-name", "bigact",
           "--elf-analysis", os.path.join(E29B_DIR, "bigact.elf.json"), "--out", out]
    try:
        pr = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
    except Exception as e:  # tool crash is a result, not a skip (D24/D25)
        results.append(Result("e29b: contract regenerates from the preserved single-invocation artifacts", False, repr(e)))
        return results
    if pr.returncode != 0 or not os.path.exists(out):
        results.append(Result("e29b: contract regenerates from the preserved single-invocation artifacts", False,
                              "rc=%d %s" % (pr.returncode, (pr.stderr or pr.stdout)[-300:])))
        return results
    a, b = load(out), load(os.path.join(E29B_DIR, "bigact.contract.json"))
    ma = a["resources"].get("memory", a["resources"]); mb = b["resources"].get("memory", b["resources"])
    keys = ("static_per_call_bytes", "module_resident_constant_bytes", "bounded_bytes")
    same = all(ma.get(k) == mb.get(k) for k in keys)
    results.append(Result("e29b: contract regenerates from the preserved single-invocation artifacts (numeric diff 0)",
                          same, "regen=%s stored=%s" % ({k: ma.get(k) for k in keys}, {k: mb.get(k) for k in keys})))
    return results


P1_DIR = os.path.join(os.path.dirname(HERE), "results", "p1_smartcam_feasibility")


def _sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _converter_available():
    return run([PY, "-c", "import tflite, tflite2onnx, onnx"])[0] == 0


def p1_smartcam_feasibility_cases(tmp):
    """E30 / P1: OPS-SAT SmartCam import feasibility (docs/reviews/ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md).

    What this group pins, and why each pin is a *claim* rather than a checksum:
      - the flight artifact stored in-tree is the bytes the manifest says it is, and is
        never edited (the analysis doc forbids editing the original);
      - the ONE structurally sensitive op (SQUEEZE) satisfies C1..C4 in the flatbuffer
        itself, and the transform's audit says the same thing about what it emitted,
        including the NHWC->NCHW axis re-indexing ([1,2] -> [2,3]);
      - the interface change the import introduces (NCHW entry vs NHWC flight input) is
        RECORDED, not hidden -- P2 owes a transpose;
      - the contract exists with zero overrides, its identity holds, the structural
        walker and the artifact-only hardened baseline (E27 (b')) agree with it exactly,
        and the reshape emission mode gives the same numbers (so the verdict does not
        depend on which ONNX op the extension chose);
      - the smoke run is a feasibility record only, but the numbers it did record are
        pinned: peak == per_call with allocated == freed (D50 discipline);
      - the stored contract regenerates from the reduced fixture (one-invocation rule);
      - the pure condition checker refuses every single-condition violation, and stock
        tflite2onnx still refuses the model (the blocker is reproduced, not remembered).
    Anything that needs the converter packages or the IREE tools SKIPs without them
    (D24/D25): a missing package is not a finding."""
    results = []
    need = ["source_manifest.json", "operator_inventory.json", "feasibility_summary.json",
            "original/model.tflite", "original/labels.txt",
            "import/import_log.txt", "import/step1_original_tflite2onnx.stderr",
            "import/step2_smartcam_ext_squeeze.onnx",
            "import/step2_smartcam_ext_squeeze.transform_manifest.json",
            "import/step2_smartcam_ext_reshape.transform_manifest.json",
            "import/dropped_intermediates.sha256",
            "build/smartcam.mlir.gz", "build/smartcam.vmfb", "build/smartcam.layout_ir.txt",
            "build/smartcam.elf.json", "build/smartcam.contract.json", "build/contract_gen.smartcam.h",
            "build/smartcam.artifact_only_hardened.json", "build/smartcam.smoke_pip_runtime.json",
            "build/dropped_dump_files.sha256", "build/dump",
            "variant_reshape/equivalence.json", "variant_reshape/dropped_artifacts.sha256"]
    missing = [n for n in need if not os.path.exists(os.path.join(P1_DIR, n))]
    results.append(Result("p1-smartcam: fixture complete (%d files/dirs)" % len(need), not missing,
                          "missing: %s" % missing if missing else ""))
    if missing:
        return results
    src = load(os.path.join(P1_DIR, "source_manifest.json"))
    inv = load(os.path.join(P1_DIR, "operator_inventory.json"))
    summ = load(os.path.join(P1_DIR, "feasibility_summary.json"))["models"]["smartcam"]
    man_s = load(os.path.join(P1_DIR, "import", "step2_smartcam_ext_squeeze.transform_manifest.json"))
    man_r = load(os.path.join(P1_DIR, "import", "step2_smartcam_ext_reshape.transform_manifest.json"))
    contract = load(os.path.join(P1_DIR, "build", "smartcam.contract.json"))
    equiv = load(os.path.join(P1_DIR, "variant_reshape", "equivalence.json"))
    hardened = load(os.path.join(P1_DIR, "build", "smartcam.artifact_only_hardened.json"))
    smoke = load(os.path.join(P1_DIR, "build", "smartcam.smoke_pip_runtime.json"))
    r = contract["resources"]

    # --- provenance: the flight artifact is the bytes every manifest names, unmodified ---
    tfl = os.path.join(P1_DIR, "original", "model.tflite")
    sha = _sha256_file(tfl); nbytes = os.path.getsize(tfl)
    oa = src["original_artifact"]
    results.append(Result("p1-smartcam: stored flight artifact == source_manifest (sha256, bytes, modified=false)",
                          sha == oa["sha256"] and nbytes == oa["bytes"] and oa["modified"] is False
                          and src["source"]["commit"] == "be09ecee41f0a5db52afe0ee929dbd339cb68672",
                          "sha=%s bytes=%d" % (sha[:16], nbytes)))
    _ok = (inv["file"]["sha256"] == sha and man_s["input_tflite"]["sha256"] == sha
                          and man_r["input_tflite"]["sha256"] == sha and summ["source"]["sha256"] == sha
                          and man_s["original_modified"] is False and man_r["original_modified"] is False)
    results.append(Result("p1-smartcam: inventory, both transform manifests and the summary name that same artifact",
                          _ok,
                          "" if _ok else "a manifest points at different bytes than the stored flight artifact"))

    # --- inventory: what the flatbuffer IS ---
    hist = inv["operators"]["histogram"]
    sens = inv["sensitive_instances"]
    results.append(Result("p1-smartcam: flatbuffer inventory -- 68 ops / 9 distinct / 0 custom / 0 dynamic tensors, "
                          "exactly one SQUEEZE, NHWC [1,224,224,3] f32 -> [1,3] f32",
                          inv["operators"]["total"] == 68 and inv["operators"]["distinct"] == 9
                          and inv["operators"]["custom"] == [] and inv["static_shapes"]["dynamic_tensors"] == 0
                          and hist.get("SQUEEZE") == 1 and len(sens) == 1
                          and inv["inputs"][0]["shape"] == [1, 224, 224, 3] and inv["inputs"][0]["dtype"] == "FLOAT32"
                          and inv["outputs"][0]["shape"] == [1, 3] and inv["outputs"][0]["dtype"] == "FLOAT32",
                          "total=%s distinct=%s hist=%s" % (inv["operators"]["total"], inv["operators"]["distinct"], hist)))
    s0 = sens[0] if sens else {}
    # Field names come from the converter's own check_squeeze_conditions: since E30's adversarial
    # review the inventory imports that function instead of re-deriving the conditions, so the two
    # P1 tools cannot report different verdicts for the same op (scope bundle, medium findings).
    _c14 = (bool(s0) and s0.get("C1_squeezed_axes_size_1") is True and s0.get("C2_elements_preserved") is True
            and s0.get("C3_dtype_preserved") is True and s0.get("C4_static_output_equals_expected") is True
            and s0.get("conditions_1_to_4_satisfied") is True
            and s0.get("input", {}).get("shape") == [1, 1, 1, 1280] and s0.get("output", {}).get("shape") == [1, 1280]
            and s0.get("tflite_squeeze_dims") == [1, 2] and s0.get("raw_squeeze_dims") == [1, 2])
    results.append(Result("p1-smartcam: the SQUEEZE instance satisfies C1..C4 in the flatbuffer itself "
                          "([1,1,1,1280] -> [1,1280], dims [1,2]), judged by the converter's own checker",
                          _c14,
                          "" if _c14 else "instance=%s" % {k: s0.get(k) for k in (
                              "tflite_squeeze_dims", "raw_squeeze_dims", "C1_squeezed_axes_size_1",
                              "C2_elements_preserved", "C3_dtype_preserved", "C4_static_output_equals_expected",
                              "conditions_1_to_4_satisfied")}))
    results.append(Result("p1-smartcam: the inventory reports itself complete (single-subgraph model)",
                          inv.get("inventory_complete") is True,
                          "" if inv.get("inventory_complete") is True else "inventory_complete=%s" % inv.get("inventory_complete")))
    results.append(Result("p1-smartcam: cFS interface fit recorded as single f32 in/out, static, 150528 -> 3 elements",
                          inv["cfs_interface_fit"]["single_f32_in_single_f32_out_static"] is True
                          and inv["cfs_interface_fit"]["input_elems"] == 150528 and inv["cfs_interface_fit"]["output_elems"] == 3,
                          "%s" % inv["cfs_interface_fit"]))

    # --- the blocker is reproduced in the log, not remembered ---
    err = open(os.path.join(P1_DIR, "import", "step1_original_tflite2onnx.stderr"), encoding="utf-8", errors="replace").read()
    log = open(os.path.join(P1_DIR, "import", "import_log.txt"), encoding="utf-8", errors="replace").read()
    _ok = ("NotImplementedError" in err and "SQUEEZE" in err and "rc  : 1" in log
                          and "Unsupported TFLite OP: 43 SQUEEZE" in log)
    results.append(Result("p1-smartcam: stock tflite2onnx's SQUEEZE refusal is preserved verbatim (stderr + import_log step 1)",
                          _ok,
                          "" if _ok else "blocker text missing from the preserved logs"))
    results.append(Result("p1-smartcam: import_log records every step 1..8 with commands and rc",
                          all(("## step %d" % k) in log for k in range(1, 9)) and log.count("rc  :") >= 8,
                          "steps found: %s" % [k for k in range(1, 9) if ("## step %d" % k) in log]))

    # --- the transform's own audit, both emission modes ---
    for label, man in (("squeeze", man_s), ("reshape", man_r)):
        inst = man["squeeze_instances"]
        a0 = inst[0] if inst else {}
        results.append(Result("p1-smartcam: %s-mode manifest -- one instance, C1..C4 true, axes re-indexed [1,2] -> [2,3] "
                              "under NHWC->NCHW, ONNX output [1,1280]" % label,
                              len(inst) == 1 and man["emit_mode"] == label
                              and a0.get("C1_squeezed_axes_size_1") is True and a0.get("C2_elements_preserved") is True
                              and a0.get("C3_dtype_preserved") is True and a0.get("C4_static_output_equals_expected") is True
                              and a0.get("tflite_squeeze_dims") == [1, 2] and a0.get("onnx_axes") == [2, 3]
                              and a0.get("input_shape_onnx") == [1, 1280, 1, 1] and a0.get("output_shape") == [1, 1280]
                              and a0.get("emit_mode") == label,
                              "%s" % {k: a0.get(k) for k in ("tflite_squeeze_dims", "onnx_axes", "input_shape_onnx", "layout", "emit_mode")}))
    _ok = (_sha256_file(os.path.join(P1_DIR, "import", "step2_smartcam_ext_squeeze.onnx")) == man_s["output_onnx"]["sha256"]
                          and os.path.getsize(os.path.join(P1_DIR, "import", "step2_smartcam_ext_squeeze.onnx")) == man_s["output_onnx"]["bytes"]
                          and man_s["output_onnx"]["graph_name"] == "infer" and man_s["output_onnx"]["opset"] == [["", 11]])
    results.append(Result("p1-smartcam: squeeze-mode ONNX in the fixture == its manifest (sha256, bytes), graph renamed to `infer`",
                          _ok,
                          "" if _ok else "stored ONNX differs from the manifest"))
    dropped = open(os.path.join(P1_DIR, "import", "dropped_intermediates.sha256"), encoding="utf-8").read()
    _ok = (man_r["output_onnx"]["sha256"] in dropped and contract["model"]["sha256"] in dropped)
    results.append(Result("p1-smartcam: reshape-mode ONNX (dropped) is still identified by hash in dropped_intermediates.sha256",
                          _ok,
                          "" if _ok else "hash record incomplete"))
    results.append(Result("p1-smartcam: the ONNX node histograms differ ONLY in Squeeze(1) vs Reshape(+1)",
                          {k: v for k, v in man_s["onnx_node_histogram"].items() if k not in ("Squeeze", "Reshape")}
                          == {k: v for k, v in man_r["onnx_node_histogram"].items() if k not in ("Squeeze", "Reshape")}
                          and man_s["onnx_node_histogram"].get("Squeeze") == 1 and "Squeeze" not in man_r["onnx_node_histogram"]
                          and man_r["onnx_node_histogram"].get("Reshape", 0) == man_s["onnx_node_histogram"].get("Reshape", 0) + 1
                          and man_s["onnx_node_count"] == man_r["onnx_node_count"],
                          "%s vs %s" % (man_s["onnx_node_histogram"], man_r["onnx_node_histogram"])))

    # --- the interface change is recorded, not hidden ---
    ic = summ["interface_change_recorded"]
    _ok = (man_s["signature_onnx"]["inputs"][0]["shape"] == [1, 3, 224, 224]
                          and contract["interface"]["input"]["shape"] == [1, 3, 224, 224]
                          and ic["flight_tflite_input"]["shape"] == [1, 224, 224, 3]
                          and ic["iree_entry_input"]["shape"] == [1, 3, 224, 224]
                          and ic["element_order_preserved"] is False and ic["elements"] == 150528
                          and summ["transform"]["condition_7_numeric_equivalence"].startswith("NOT DONE"))
    results.append(Result("p1-smartcam: NCHW entry vs NHWC flight input is RECORDED as a P2 obligation (element order not preserved)",
                          _ok,
                          "" if _ok else "interface change under-recorded: %s" % ic))

    # --- the contract: numbers, identity, zero overrides, agreement of every independent reader ---
    want = {"static_io_bytes": 602124, "static_transient_bytes": 8779968, "static_per_call_bytes": 9382092,
            "module_resident_constant_bytes": 8840704, "bounded_bytes": 18222796}
    results.append(Result("p1-smartcam: contract numbers pinned (bounded 18,222,796 = per_call 9,382,092 + constants 8,840,704; 56 dispatches)",
                          all(r.get(k) == v for k, v in want.items())
                          and r["bounded_bytes"] == r["static_per_call_bytes"] + r["module_resident_constant_bytes"]
                          and r["static_per_call_bytes"] == r["static_io_bytes"] + r["static_transient_bytes"]
                          and r["dispatches"] == 56 and r["bound_method"] == "static_from_stream_layout",
                          "%s" % {k: r.get(k) for k in want}))
    results.append(Result("p1-smartcam: zero overrides, verification_grade verified, constants confirmed, structural walker agrees, "
                          "kernel stack 368/439 B with 0 unresolved calls",
                          contract["provenance"]["overrides_applied"] == [] and contract["provenance"]["verification_grade"] == "verified"
                          and r["constants_confirmation_state"] == "confirmed"
                          and contract["provenance"]["structural_walker"]["agrees_with_regex_parser"] is True
                          and r["kernel_task_stack_bytes"] == 368 and r["kernel_task_stack_invocation_bytes"] == 439
                          and r["kernel_external_call_insns"] == 0 and r["kernel_dynamic_stack_alloc"] is False,
                          "overrides=%s grade=%s consts=%s stack=%s/%s" % (contract["provenance"]["overrides_applied"], contract["provenance"]["verification_grade"], r["constants_confirmation_state"], r["kernel_task_stack_bytes"], r["kernel_task_stack_invocation_bytes"])))
    results.append(Result("p1-smartcam: artifact-only hardened baseline (E27 (b'), no MLIR, no dump) agrees with the contract exactly",
                          hardened["status"] == "value" and hardened["bl1_bounded"] == r["bounded_bytes"]
                          and hardened["bl1_per_call"] == r["static_per_call_bytes"]
                          and hardened["bl1_constants"] == r["module_resident_constant_bytes"]
                          and hardened["abi_arity"] == [1, 1],
                          "hardened=%s" % {k: hardened.get(k) for k in ("status", "bl1_bounded", "bl1_per_call", "bl1_constants")}))
    results.append(Result("p1-smartcam: reshape emission mode converges -- different ONNX bytes, byte-identical linalg MLIR "
                          "(== contract.model.sha256), identical contract resources (the verdict does not depend on the emitted op)",
                          equiv["onnx"]["squeeze"]["sha256"] == man_s["output_onnx"]["sha256"]
                          and equiv["onnx"]["reshape"]["sha256"] == man_r["output_onnx"]["sha256"]
                          and equiv["onnx"]["squeeze"]["sha256"] != equiv["onnx"]["reshape"]["sha256"]
                          and equiv["linalg_mlir"]["byte_identical"] is True
                          and equiv["linalg_mlir"]["squeeze_sha256"] == contract["model"]["sha256"]
                          and equiv["contract"]["resources_identical"] is True
                          and equiv["contract"]["bounded_bytes"] == r["bounded_bytes"],
                          "equivalence record: linalg=%s resources=%s" % (equiv["linalg_mlir"].get("byte_identical"), equiv["contract"].get("resources_identical"))))
    layout = open(os.path.join(P1_DIR, "build", "smartcam.layout_ir.txt"), encoding="utf-8", errors="replace").read()
    results.append(Result("p1-smartcam: layout IR has E26's two-arm structure (1 try_map, 1 scf.if, 1 constant alloc) on a flight model",
                          layout.count("stream.resource.try_map") == 1 and layout.count("scf.if") == 1
                          and layout.count("stream.resource.alloc ") == 1,
                          "try_map=%d scf.if=%d alloc=%d" % (layout.count("stream.resource.try_map"), layout.count("scf.if"), layout.count("stream.resource.alloc "))))
    hdr = open(os.path.join(P1_DIR, "build", "contract_gen.smartcam.h"), encoding="utf-8").read()
    _ok = (all(t in hdr for t in ("#define CONTRACT_BOUND_KNOWN 1", "#define CONTRACT_PROVENANCE_VERIFIED 1",
                                                 "#define CONTRACT_DTYPES_ALL_F32 1", "#define CONTRACT_INPUT_ELEMS 150528",
                                                 "#define CONTRACT_OUTPUT_ELEMS 3", "#define CONTRACT_KERNEL_STACK_BYTES 439L",
                                                 "#define CONTRACT_BOUNDED_BYTES 18222796L", "#define CONTRACT_PER_CALL_BYTES 9382092L")))
    results.append(Result("p1-smartcam: header carries BOUND_KNOWN 1 / PROVENANCE_VERIFIED 1 / ALL_F32 1 / 150528 -> 3 / stack 439",
                          _ok,
                          "" if _ok else "header macro missing"))
    out_h = os.path.join(tmp, "p1_regen.h")
    rc, _, err = run([PY, GEN_HEADER, os.path.join(P1_DIR, "build", "smartcam.contract.json"), out_h])
    results.append(Result("p1-smartcam: header regenerates byte-identical from the stored contract",
                          rc == 0 and os.path.exists(out_h) and open(out_h, "rb").read() == open(os.path.join(P1_DIR, "build", "contract_gen.smartcam.h"), "rb").read(),
                          "rc=%d %s" % (rc, err.strip()[-200:])))

    # --- smoke: feasibility record, D50 discipline ---
    st = smoke["hal_statistics"]
    results.append(Result("p1-smartcam: smoke record -- ran, [1,3] f32 finite, deterministic, peak == per_call, allocated == freed (D50)",
                          smoke["status"] == "ran" and smoke["contract_artifact_sha256_matches"] is True
                          and all(o["output_shape"] == [1, 3] and o["finite"] for o in smoke["outputs"].values())
                          and smoke["deterministic_same_input"] is True
                          and st["device_bytes_peak"] == r["static_per_call_bytes"]
                          and st["device_bytes_allocated"] == st["device_bytes_freed"]
                          and smoke["observation"]["peak_le_bounded"] is True,
                          "peak=%s per_call=%s alloc=%s freed=%s" % (st.get("device_bytes_peak"), r["static_per_call_bytes"], st.get("device_bytes_allocated"), st.get("device_bytes_freed"))))
    _ok = ("hal_statistics_after_host_reads" in smoke
                          and smoke["hal_statistics_after_host_reads"]["device_bytes_allocated"] > smoke["hal_statistics_after_host_reads"]["device_bytes_freed"])
    results.append(Result("p1-smartcam: the smoke record also shows the observer effect it guards against (host reads hold HAL bytes)",
                          _ok,
                          "" if _ok else "after_host_reads block missing or shows nothing held"))
    results.append(Result("p1-smartcam: feasibility verdict is TRANSFORM_REQUIRED with go_with_transform=true and the non-claims listed",
                          summ["verdict"] == "TRANSFORM_REQUIRED" and summ["go_with_transform"] is True
                          and summ["transform"]["emission_mode_independent"] is True
                          and summ["second_information_source"]["agrees_with_contract"] is True
                          and any("P2" in s for s in summ["not_claimed"]) and any("AArch64" in s for s in summ["not_claimed"]),
                          "verdict=%s" % summ.get("verdict")))

    # --- the pure condition checker refuses every single-condition violation ---
    if not _converter_available():
        results.append(Result("p1-smartcam: check_squeeze_conditions refuses each single-condition violation",
                              True, "tflite/tflite2onnx/onnx not installed", skip=True))
        results.append(Result("p1-smartcam: stock tflite2onnx still refuses the flight model at SQUEEZE (blocker reproduced live)",
                              True, "tflite/tflite2onnx/onnx not installed", skip=True))
        results.append(Result("p1-smartcam: converter reproduces the stored squeeze-mode ONNX (sha256) and audit",
                              True, "tflite/tflite2onnx/onnx not installed", skip=True))
    else:
        probe = r"""
import json, sys
sys.path.insert(0, %r)
from tflite2onnx_ext_squeeze import check_squeeze_conditions as chk
ok, _ = chk([1,1,1,1280], [1,1280], 1, 1, [1,2])
cases = {
  "valid": ok,
  "C1_axis_not_size_1": chk([1,2,1,1280], [1,2,1280], 1, 1, [1,2])[0],
  "C2_elements_changed": chk([1,1,1,1280], [1,640], 1, 1, [1,2])[0],
  "C3_dtype_changed": chk([1,1,1,1280], [1,1280], 1, 2, [1,2])[0],
  "C4_output_shape_mismatch": chk([1,1,1,1280], [1280,1], 1, 1, [1,2])[0],
  "empty_dims": chk([1,1,1,1280], [1,1,1,1280], 1, 1, [])[0],
  "axis_out_of_range": chk([1,1,1,1280], [1,1280], 1, 1, [1,7])[0],
  "C4_nonstatic_output": chk([1,1,1,1280], [-1,1280], 1, 1, [1,2])[0],
}
print(json.dumps(cases))
""" % HERE
        rc, out, err = run([PY, "-c", probe])
        try:
            cases = json.loads(out.strip().splitlines()[-1])
        except Exception:
            cases = {}
        bad = [k for k, v in cases.items() if (v is not True if k == "valid" else v is not False)]
        results.append(Result("p1-smartcam: check_squeeze_conditions accepts the valid case and refuses each single-condition violation (7)",
                              rc == 0 and len(cases) == 8 and not bad,
                              "rc=%d wrong=%s %s" % (rc, bad, (err or "").strip()[-200:])))
        probe2 = r"""
import sys, tflite
from tflite2onnx.model import Model
buf = open(%r, "rb").read()
try:
    Model(tflite.Model.GetRootAsModel(buf, 0)).convert(dict())
    print("CONVERTED")
except NotImplementedError as e:
    print("REFUSED:" + str(e))
""" % tfl
        rc, out, err = run([PY, "-c", probe2])
        results.append(Result("p1-smartcam: stock tflite2onnx still refuses the flight model at SQUEEZE (blocker reproduced live)",
                              rc == 0 and out.strip().startswith("REFUSED:") and "SQUEEZE" in out,
                              "rc=%d out=%s err=%s" % (rc, out.strip()[-120:], (err or "").strip()[-160:])))
        out_onnx = os.path.join(tmp, "p1_regen.onnx")
        rc, out, err = run([PY, os.path.join(HERE, "p1_tflite_to_onnx.py"), tfl, out_onnx, "--squeeze-as", "squeeze"])
        man_path = os.path.join(tmp, "p1_regen.transform_manifest.json")
        ok = rc == 0 and os.path.exists(out_onnx) and os.path.exists(man_path)
        detail = "rc=%d %s" % (rc, (err or "").strip()[-200:])
        if ok:
            m2 = load(man_path)
            ok = (_sha256_file(out_onnx) == man_s["output_onnx"]["sha256"]
                  and m2["squeeze_instances"] == man_s["squeeze_instances"]
                  and m2["onnx_node_histogram"] == man_s["onnx_node_histogram"])
            detail = "sha=%s (stored %s)" % (_sha256_file(out_onnx)[:16], man_s["output_onnx"]["sha256"][:16])
        results.append(Result("p1-smartcam: converter reproduces the stored squeeze-mode ONNX (sha256) and audit",
                              ok, detail))
        out_onnx_r = os.path.join(tmp, "p1_regen_reshape.onnx")
        rc, out, err = run([PY, os.path.join(HERE, "p1_tflite_to_onnx.py"), tfl, out_onnx_r, "--squeeze-as", "reshape"])
        results.append(Result("p1-smartcam: converter reproduces the reshape-mode ONNX (sha256 in variant_reshape/equivalence.json)",
                              rc == 0 and os.path.exists(out_onnx_r) and _sha256_file(out_onnx_r) == equiv["onnx"]["reshape"]["sha256"],
                              "rc=%d sha=%s (recorded %s)" % (rc, _sha256_file(out_onnx_r)[:16] if os.path.exists(out_onnx_r) else "-", equiv["onnx"]["reshape"]["sha256"][:16])))
        # ONNX -> torch -> linalg, both modes: the stored contract's model hash must come back from the flight artifact alone
        if not (shutil.which("iree-import-onnx") and shutil.which("iree-opt")):
            results.append(Result("p1-smartcam: iree-import-onnx + iree-opt regenerate the contract's linalg MLIR (sha256) from both ONNX modes",
                                  True, "iree-import-onnx/iree-opt not on PATH", skip=True))
        else:
            got = {}
            for label, src_onnx in (("squeeze", out_onnx), ("reshape", out_onnx_r)):
                if not os.path.exists(src_onnx):
                    got[label] = "no-onnx"; continue
                t_mlir = os.path.join(tmp, "p1_%s.torch.mlir" % label); l_mlir = os.path.join(tmp, "p1_%s.linalg.mlir" % label)
                rc1, _, e1 = run(["iree-import-onnx", src_onnx, "--opset-version", "17", "-o", t_mlir])
                rc2, _, e2 = run(["iree-opt", t_mlir, "--pass-pipeline=builtin.module(torch-onnx-to-torch-backend-pipeline,"
                                  "torch-backend-to-linalg-on-tensors-backend-pipeline)", "-o", l_mlir]) if rc1 == 0 else (rc1, "", e1)
                got[label] = _sha256_file(l_mlir) if (rc2 == 0 and os.path.exists(l_mlir)) else "rc=%d/%d %s" % (rc1, rc2, (e2 or e1).strip()[-120:])
            results.append(Result("p1-smartcam: iree-import-onnx + iree-opt regenerate the contract's linalg MLIR (sha256) from both ONNX modes",
                                  all(v == contract["model"]["sha256"] for v in got.values()) and len(got) == 2,
                                  "%s (contract %s)" % ({k: v[:16] for k, v in got.items()}, contract["model"]["sha256"][:16])))

    # --- the stored contract regenerates from the reduced fixture (one-invocation rule) ---
    if not (structural_available() and iree_tools_available()):
        results.append(Result("p1-smartcam: contract regenerates unchanged from the reduced fixture",
                              True, "needs iree.compiler.ir and iree-dump-module", skip=True))
        return results
    import gzip
    mlir_tmp = os.path.join(tmp, "smartcam.mlir")     # the basename is part of the one-invocation check
    with gzip.open(os.path.join(P1_DIR, "build", "smartcam.mlir.gz"), "rb") as gz, open(mlir_tmp, "wb") as fo:
        shutil.copyfileobj(gz, fo)
    _ok = (_sha256_file(mlir_tmp) == contract["model"]["sha256"] and os.path.getsize(mlir_tmp) == contract["model"]["bytes"])
    results.append(Result("p1-smartcam: gzipped linalg MLIR in the fixture == contract.model.sha256",
                          _ok,
                          "" if _ok else "mlir.gz content does not match the contract's model hash"))
    out = os.path.join(tmp, "p1_regen.contract.json")
    rc, _, err = run([PY, MAKE_CONTRACT,
                      "--mlir", mlir_tmp,
                      "--vmfb", os.path.join(P1_DIR, "build", "smartcam.vmfb"),
                      "--layout-ir", os.path.join(P1_DIR, "build", "smartcam.layout_ir.txt"),
                      "--dump-dir", os.path.join(P1_DIR, "build", "dump"),
                      "--triple", "x86_64-unknown-linux-gnu", "--cpu", "generic",
                      "--model-name", "smartcam",
                      "--elf-analysis", os.path.join(P1_DIR, "build", "smartcam.elf.json")]
                     + with_structural_override() + ["--out", out])
    if rc != 0:
        results.append(Result("p1-smartcam: contract regenerates unchanged from the reduced fixture", False,
                              "make_contract rc=%d: %s" % (rc, err.strip()[-300:])))
        return results
    old_f = dict(flatten(contract))
    new_f = dict(flatten(load(out)))
    ignore = IGNORE_PROVENANCE_KEYS | {"dump_dir"}
    diffs = [(k, old_f.get(k), new_f.get(k)) for k in set(old_f) | set(new_f)
             if k[-1] not in ignore and not (set(k) & IGNORE_PROVENANCE_SUBTREES)
             and old_f.get(k) != new_f.get(k)]
    results.append(Result("p1-smartcam: contract regenerates unchanged from the reduced fixture",
                          not diffs, "" if not diffs else "%d field(s) differ, e.g. %s" % (len(diffs), diffs[:3])))
    return results


def e30b_squeeze_extension_cases(tmp):
    """E30b / D56: the SQUEEZE converter extension on shapes the flight model does not contain.

    The adversarial review of E30 built synthetic TFLite flatbuffers and showed that a
    TFLite-valid PARTIAL squeeze which passes C1-C4 ([1,1,7,64] dims [1] -> [1,7,64]) was
    emitted on the NCHW-re-indexed tensor with its data silently transposed -- shape
    inference, iree-compile and the runtime all accept it; only the numbers are wrong
    (reshape mode: max_abs_diff 5.46 / 1.89 / 2.61 for sq_H / sq_H77 / sq_N; squeeze mode:
    sq_H77 runs with 1.89, the non-square ones are caught downstream by a shape cast).
    SmartCam keeps {N,C}, whose order NHWC and NCHW agree on, so the flight model was
    never affected -- which is exactly why a synthetic set was needed (D43's rule: the
    models that justify the fix live in harness/gen_tflite_squeeze_cases.py).

    Fix: C5 -- the kept axes must keep their TFLite order under the layout permutation --
    plus three smaller things the same review found: a missing SqueezeOptions table
    crashed with AttributeError where a decision was owed (D24's class), duplicate axes
    were forwarded verbatim, and the identity case (no size-1 axis) was refused as C1
    even on a layout-free tensor.  Each case below pins one outcome; the CONVERTED ones
    are additionally compiled with IREE and compared bit for bit with TFLite's semantics
    when the tools are on PATH.  Revert-and-confirm-fail was done by hand (disable C5 ->
    sq_H/sq_H77/sq_N CONVERT with the numbers above); the source-level guard here keeps
    the check from disappearing quietly."""
    results = []
    root = os.path.dirname(HERE)
    ext_src = open(os.path.join(HERE, "tflite2onnx_ext_squeeze.py"), encoding="utf-8").read()
    _c5 = ("check_kept_axis_order(" in ext_src and "if not ok5:" in ext_src
           and "raise SqueezeConditionError" in ext_src.split("if not ok5:")[1][:400]
           and "np.array_equal(got, ref)" in ext_src and "got.shape == ref.shape" in ext_src)
    results.append(Result("e30b: C5 is decided by simulation against np.squeeze (shape AND values), and refuses instead of emitting",
                          _c5,
                          "" if _c5 else "C5's simulation, its shape+value equality, or its refusal is gone from the extension"))
    results.append(Result("e30b: a missing SqueezeOptions table is a decision (empty dims), not a crash",
                          ("if opt is None:" in ext_src and "raw_dims = []" in ext_src),
                          "" if ("if opt is None:" in ext_src and "raw_dims = []" in ext_src) else "opt-None path missing in parse()"))
    results.append(Result("e30b: squeeze dims are normalised by one pure helper (negatives, duplicates, empty == all size-1)",
                          ("def normalize_squeeze_dims(" in ext_src and "sorted(set(" in ext_src.split("def normalize_squeeze_dims(")[1][:400]),
                          "" if ("def normalize_squeeze_dims(" in ext_src and "sorted(set(" in ext_src.split("def normalize_squeeze_dims(")[1][:400]) else "normalize_squeeze_dims missing or no longer dedupes"))

    if not _converter_available():
        results.append(Result("e30b: synthetic SQUEEZE cases give the pinned outcomes", True,
                              "tflite/tflite2onnx/onnx not installed", skip=True))
        results.append(Result("e30b: the inventory tool agrees with the converter on every synthetic case", True,
                              "tflite/tflite2onnx/onnx not installed", skip=True))
        return results
    gen = os.path.join(HERE, "gen_tflite_squeeze_cases.py")
    cases_dir = os.path.join(tmp, "e30b_cases")
    rc, out, err = run([PY, gen, cases_dir])
    if rc != 0:
        results.append(Result("e30b: synthetic SQUEEZE cases (11) give the pinned outcomes", False,
                              "generator rc=%d %s" % (rc, err.strip()[-200:])))
        return results
    have_iree = all(shutil.which(t) for t in ("iree-import-onnx", "iree-opt", "iree-compile")) \
        and run([PY, "-c", "import iree.runtime"])[0] == 0
    # name -> (expected outcome, expected ONNX axes attr in squeeze mode, refusal must mention)
    expect = {
        "sq_HW":       ("CONVERTED", [2, 3], None),
        "sq_neg":      ("CONVERTED", [2, 3], None),
        "sq_dup":      ("CONVERTED", [2, 3], None),          # duplicates collapse
        "sq_empty":    ("CONVERTED", [0, 2, 3], None),       # empty dims == every size-1 axis, C5 holds (kept {C})
        "sq_noopt":    ("CONVERTED", [0, 2, 3], None),       # no options table == empty dims
        "sq_H":        ("REFUSED", None, "C5"),
        "sq_H77":      ("REFUSED", None, "C5"),
        "sq_N":        ("REFUSED", None, "C5"),
        "sq_identity": ("REFUSED", None, "C5"),              # identity on a layout-tagged input needs a Transpose
        # C5's two boundary cases (E30 adversarial review, medium on the FIRST C5): the axis-position
        # argument over-refused the first, and its obvious repair would fail-open on the second.
        "sq_c5_extent1_reorder": ("CONVERTED", [2], None),   # kept axes reorder, but every reordered one has extent 1
        "sq_c5_shape_mismatch":  ("REFUSED", None, "C5"),    # declared [2,1,1] vs ONNX-inferred [1,2,1]
        "bad_c1":      ("REFUSED", None, "structural conditions"),
        "bad_c4":      ("REFUSED", None, "structural conditions"),
    }
    probe = os.path.join(HERE, "e30b_squeeze_probe.py")
    outcomes = {}
    for name, (want, want_axes, must_mention) in expect.items():
        tfl = os.path.join(cases_dir, name + ".tflite")
        cmd = [PY, probe, tfl, "--mode", "squeeze", "--workdir", os.path.join(tmp, "e30b_" + name)]
        if have_iree and want == "CONVERTED":
            cmd.append("--iree")
        rc, out, err = run(cmd)
        try:
            d = json.loads(out.strip().splitlines()[-1])
        except Exception:
            d = {"outcome": "PROBE-ERROR", "reason": (err or out)[-300:]}
        outcomes[name] = d
        ok = d.get("outcome") == want
        detail = "outcome=%s" % d.get("outcome")
        if ok and want == "CONVERTED":
            ok = (d.get("onnx") or {}).get("axes_attr") == want_axes and (d.get("audit") or {}).get("C5_kept_axis_order_preserved") is True
            detail += " axes=%s" % (d.get("onnx") or {}).get("axes_attr")
            if have_iree:
                num = d.get("numeric") or {}
                ok = ok and num.get("ran") is True and num.get("equal_to_tflite_semantics") is True
                detail += " iree=%s max_abs_diff=%s" % (num.get("equal_to_tflite_semantics"), num.get("max_abs_diff"))
        elif ok and want == "REFUSED":
            ok = must_mention in (d.get("reason") or "")
            detail += " reason=%s" % (d.get("reason") or "")[:70].replace("\n", " ")
        elif not ok:
            detail += " %s" % (d.get("reason") or "")[-160:].replace("\n", " ")
        results.append(Result("e30b: %s -> %s%s" % (name, want, "" if want != "CONVERTED" or not have_iree else " and == TFLite semantics under IREE"),
                              ok, detail))
    if not have_iree:
        results.append(Result("e30b: CONVERTED cases reproduce TFLite semantics bit for bit under IREE", True,
                              "iree tools / iree.runtime not available", skip=True))
    # The inventory tool and the converter must agree about the SS5 conditions on every case.
    # E30's adversarial review (scope bundle, both medium findings) showed they did not: the
    # inventory crashed with an uncaught AttributeError on a SQUEEZE with no SqueezeOptions
    # table -- the exact condition E30b had just fixed in the converter and recorded as fixed --
    # and it reported C1/C4 as FAILING for negative squeeze_dims that the converter correctly
    # accepts, i.e. the audit tool contradicted the transform it exists to audit. Both now
    # import the converter's own normalize_squeeze_dims/check_squeeze_conditions, so this pins
    # that they cannot diverge again.
    inv_rows = {}
    for name in expect:
        out_inv = os.path.join(tmp, "e30b_inv_%s.json" % name)
        rc, _, err = run([PY, os.path.join(HERE, "p1_tflite_inventory.py"),
                          os.path.join(cases_dir, name + ".tflite"), "--out", out_inv])
        if rc != 0 or not os.path.exists(out_inv):
            inv_rows[name] = {"rc": rc, "error": (err or "").strip()[-160:]}
            continue
        inv = load(out_inv)
        sens = inv.get("sensitive_instances") or [{}]
        inv_rows[name] = {"rc": rc, "dims": sens[0].get("tflite_squeeze_dims"),
                          "raw": sens[0].get("raw_squeeze_dims"),
                          "c1to4": sens[0].get("conditions_1_to_4_satisfied"),
                          "complete": inv.get("inventory_complete")}
    crashed = [n for n, r in inv_rows.items() if r["rc"] != 0]
    results.append(Result("e30b: the inventory tool reads every synthetic case without crashing "
                          "(including the SQUEEZE with no SqueezeOptions table)",
                          not crashed, "" if not crashed else "rc!=0 for %s" % {n: inv_rows[n] for n in crashed}))
    # C1..C4 are structural, so the inventory's verdict must match the converter's audit wherever
    # the converter got far enough to record one. sq_c5_shape_mismatch and the C5 refusals pass
    # C1..C4 and fail only C5, which the inventory (a flatbuffer reader, no layout) does not judge.
    c1to4_expected_true = ["sq_HW", "sq_neg", "sq_dup", "sq_empty", "sq_noopt", "sq_H", "sq_H77",
                           "sq_N", "sq_c5_extent1_reorder", "sq_c5_shape_mismatch"]
    mism = [n for n in c1to4_expected_true if inv_rows.get(n, {}).get("c1to4") is not True]
    results.append(Result("e30b: the inventory agrees with the converter on C1..C4 -- negative and empty "
                          "squeeze_dims are normalised, not reported as violations",
                          not mism, "" if not mism else "inventory says C1..C4 fail for %s" % {n: inv_rows.get(n) for n in mism}))
    results.append(Result("e30b: bad_c1 / bad_c4 are reported as failing C1..C4 by the inventory too",
                          inv_rows.get("bad_c1", {}).get("c1to4") is False
                          and inv_rows.get("bad_c4", {}).get("c1to4") is False,
                          "bad_c1=%s bad_c4=%s" % (inv_rows.get("bad_c1", {}).get("c1to4"),
                                                   inv_rows.get("bad_c4", {}).get("c1to4"))))

    # the refused partial squeezes must never have produced an ONNX file (refusal before emission)
    results.append(Result("e30b: refused cases emit nothing (refusal happens before any ONNX is written)",
                          (all("onnx" not in outcomes.get(n, {}) for n, (w, _, _) in expect.items() if w == "REFUSED")),
                          "" if (all("onnx" not in outcomes.get(n, {}) for n, (w, _, _) in expect.items() if w == "REFUSED")) else "a refused case still wrote an ONNX file"))
    # reshape mode (the analysis document's literal suggestion) must refuse the same partial squeezes:
    # before C5 it converted, compiled and ran them with wrong numbers (5.46 / 1.89 / 2.61)
    for name in ("sq_H", "sq_H77", "sq_N", "sq_c5_shape_mismatch"):
        rc, out, err = run([PY, probe, os.path.join(cases_dir, name + ".tflite"), "--mode", "reshape",
                            "--workdir", os.path.join(tmp, "e30b_r_" + name)])
        try:
            d = json.loads(out.strip().splitlines()[-1])
        except Exception:
            d = {"outcome": "PROBE-ERROR"}
        results.append(Result("e30b: reshape mode refuses %s too (C5 is emission-mode independent)" % name,
                              d.get("outcome") == "REFUSED" and "C5" in (d.get("reason") or ""),
                              "outcome=%s" % d.get("outcome")))
    return results


E31_DIR = os.path.join(os.path.dirname(HERE), "results", "e31_smartcam_equivalence")


def _litert_available():
    return run([PY, "-c", "import ai_edge_litert"])[0] == 0


def e31_semantic_equivalence_cases(tmp):
    """E31 / P2: the imported SmartCam model computes what the original computes.

    The ninth external review (docs/reviews/ONAIR_MLIR_ARCHITECTURE_PLAN_20260910.md SS10 step 1)
    named this the first thing to build, and E30 had explicitly left it open
    (`condition_7_numeric_equivalence: "NOT DONE -- P2"`). The criteria were fixed in
    docs/plans/E31_smartcam_semantic_equivalence.md SS4 and committed BEFORE the measurement,
    inherited unchanged from E25.

    What is pinned here, and why each pin is a claim rather than a checksum:
      - the verdict, its totals, and that the criteria in the stored comparison are the plan's
        (a later widening of the tolerance would show up here, not pass silently);
      - the fixture's preprocessing is the ORIGINAL's own config values and the layout step is a
        transpose whose round trip the generator verified;
      - the synthetic inputs -- which are not stored -- regenerate bit-exactly from the recorded
        seed, so the fixture is complete evidence without carrying 38 MB of regenerable arrays;
      - the negative control: feeding the same model a RESHAPED (wrong-layout) input must FAIL,
        because a PASS means nothing if the criteria cannot fail. It is regenerated here, not
        remembered, and its two lessons are asserted as numbers: argmax alone would have accepted
        the wrong layout on 34 of 37 samples, and the only samples it could not catch are the
        constant edge inputs (a constant array is invariant under any permutation).
    Everything that needs LiteRT, IREE or Pillow SKIPs cleanly without them (D24/D25)."""
    results = []
    need = ["summary.json", "comparison.json", "oracle_tflite.json", "iree_x86_64.json",
            "negative_control_reshape.comparison.json", "fixture/manifest.json"]
    missing = [n for n in need if not os.path.exists(os.path.join(E31_DIR, n))]
    results.append(Result("e31: fixture and results present", not missing,
                          "" if not missing else "missing: %s" % missing))
    if missing:
        return results
    summ = load(os.path.join(E31_DIR, "summary.json"))
    comp = load(os.path.join(E31_DIR, "comparison.json"))
    man = load(os.path.join(E31_DIR, "fixture", "manifest.json"))
    orc = load(os.path.join(E31_DIR, "oracle_tflite.json"))
    ire = load(os.path.join(E31_DIR, "iree_x86_64.json"))
    neg = load(os.path.join(E31_DIR, "negative_control_reshape.comparison.json"))

    # --- the verdict and the criteria it was reached under ---
    t = comp["totals"]
    _v = (comp["verdict"] == "PASS" and summ["verdict"] == "PASS" and t["elements_failed"] == 0
          and t["argmax_failed"] == 0 and t["samples"] == 37 and t["elements"] == 111)
    results.append(Result("e31: PASS on 37 samples / 111 elements, 0 element failures, 0 argmax failures",
                          _v, "" if _v else "totals=%s verdict=%s" % (t, comp["verdict"])))
    _c = (comp["criteria"]["abs_tol"] == 1e-4 and comp["criteria"]["rel_tol"] == 1e-5
          and "abs_err <= abs_tol OR rel_err <= rel_tol" in comp["criteria"]["rule"])
    results.append(Result("e31: the verdict was reached under the plan's pre-fixed tolerance (E25's, unchanged)",
                          _c, "" if _c else "criteria=%s" % comp["criteria"]))

    # --- the OR rule was load-bearing: rel alone would have failed an honest result ---
    rk = summ["by_kind"]["real_example"]
    _or = (rk["max_rel_err"] > comp["criteria"]["rel_tol"] and rk["all_elements_ok"] is True)
    results.append(Result("e31: the pre-fixed OR rule was load-bearing -- a real image's worst rel_err "
                          "(%.3e) exceeds rel_tol, and only abs_err carried it" % rk["max_rel_err"],
                          _or, "" if _or else "real_example max_rel_err=%s rel_tol=%s"
                          % (rk["max_rel_err"], comp["criteria"]["rel_tol"])))

    # --- provenance: the oracle ran the flight artifact, the runner ran E30's vmfb ---
    _p = (orc["model"]["sha256"] == "fd1ecbd01ad2d46bd35cbac17809cfa24b1d929b8f14871fc1fb6fca5ff06aae"
          and ire["artifact"]["sha256"] == "aa95a6f5ab92cf0ef62737c1227403d0a176c1c1ae24bf210b3e59b4cf60ead8"
          and orc["interpreter_signature"]["input_shape"] == [1, 224, 224, 3]
          and ire["results"] and len(orc["results"]) == len(ire["results"]) == 37)
    results.append(Result("e31: the oracle ran the unmodified flight .tflite (NHWC) and the runner ran E30's vmfb (NCHW)",
                          _p, "" if _p else "oracle=%s iree=%s" % (orc["model"]["sha256"][:16],
                                                                   ire["artifact"]["sha256"][:16])))

    # --- preprocessing is the original's own, and the layout step is a transpose ---
    norm = man["preprocessing"]["normalisation"]
    _pp = (norm["mean"] == 0 and norm["std"] == 255
           and man["preprocessing"]["resize"]["to"] == [224, 224]
           and "transpose" in man["preprocessing"]["layout"]["operation"]
           and "round trip" in man["preprocessing"]["layout"]["verified"])
    results.append(Result("e31: preprocessing uses the original config's mean=0/std=255 at 224x224 and a "
                          "verified transpose (not a reshape)",
                          _pp, "" if _pp else "preprocessing=%s" % man["preprocessing"]))
    _counts = man["counts"] == {"edge": 2, "real_example": 3, "synthetic": 32}
    results.append(Result("e31: inputs are separated into real (3, all the public examples) / synthetic (32, "
                          "coverage only) / edge (2), never conflated",
                          _counts, "" if _counts else "counts=%s" % man["counts"]))

    # --- the negative control's numbers, which is what makes the PASS meaningful ---
    nc = neg["negative_control"]["observed"]
    _n = (neg["verdict"] == "FAIL" and nc["elements_failed"] == 105 and nc["of"] == 111
          and nc["argmax_failed"] == 3 and nc["argmax_only_would_have_passed"] == 34)
    results.append(Result("e31: negative control -- the wrong layout FAILS (105/111 elements), and argmax "
                          "alone would have accepted it on 34/37 samples",
                          _n, "" if _n else "observed=%s verdict=%s" % (nc, neg["verdict"])))
    _const = [r["sample_id"] for r in neg["samples"] if r.get("elements_ok") == r.get("elements")]
    results.append(Result("e31: under the wrong layout only the two CONSTANT edge inputs pass -- boundary "
                          "inputs alone cannot detect a layout error",
                          sorted(_const) == ["edge_ones", "edge_zeros"],
                          "" if sorted(_const) == ["edge_ones", "edge_zeros"] else "passed: %s" % _const))

    # --- non-claims are recorded, not assumed ---
    nots = " ".join(summ.get("not_claimed", []))
    _nc = all(k in nots for k in ("accuracy", "AArch64", "flight-pipeline", "bit identity"))
    results.append(Result("e31: the summary records what is NOT claimed (accuracy, flight pipeline, "
                          "AArch64/cFS/OnAIR, bit identity)",
                          _nc, "" if _nc else "not_claimed=%s" % summ.get("not_claimed")))

    # --- the unstored synthetic inputs regenerate bit-exactly from the recorded seed ---
    if not _converter_available() and not os.path.exists("/usr/lib/python3/dist-packages/numpy"):
        pass  # numpy is checked directly below
    if run([PY, "-c", "import numpy"])[0] != 0:
        results.append(Result("e31: the unstored synthetic inputs regenerate bit-exactly from the seed",
                              True, "numpy not installed", skip=True))
    else:
        probe = r"""
import json, hashlib, sys
import numpy as np
man = json.load(open(%r))
rng = np.random.default_rng(31)
bad = []
for s in man["samples"]:
    if s["kind"] != "synthetic":
        continue
    nhwc = rng.random((1, 224, 224, 3), dtype=np.float32)
    nchw = np.ascontiguousarray(nhwc.transpose(0, 3, 1, 2))
    if hashlib.sha256(nhwc.tobytes()).hexdigest() != s["nhwc"]["sha256"]: bad.append((s["sample_id"], "nhwc"))
    if hashlib.sha256(nchw.tobytes()).hexdigest() != s["nchw"]["sha256"]: bad.append((s["sample_id"], "nchw"))
print(json.dumps({"checked": sum(1 for s in man["samples"] if s["kind"] == "synthetic"), "bad": bad}))
""" % os.path.join(E31_DIR, "fixture", "manifest.json")
        rc, out, err = run([PY, "-c", probe])
        try:
            d = json.loads(out.strip().splitlines()[-1])
        except Exception:
            d = {"checked": 0, "bad": [("probe", (err or out)[-160:])]}
        _r = rc == 0 and d["checked"] == 32 and not d["bad"]
        results.append(Result("e31: the 32 unstored synthetic inputs regenerate bit-exactly from seed 31 "
                              "(sha256 vs manifest)", _r, "" if _r else "%s" % d))

    # --- stored real/edge inputs match their manifest hashes ---
    if run([PY, "-c", "import numpy"])[0] != 0:
        results.append(Result("e31: stored real/edge inputs match their manifest sha256", True,
                              "numpy not installed", skip=True))
    else:
        probe2 = r"""
import json, hashlib, os, sys
import numpy as np
root = %r
man = json.load(open(os.path.join(root, "fixture", "manifest.json")))
bad, checked = [], 0
for s in man["samples"]:
    if s["kind"] == "synthetic":
        continue
    for k in ("nhwc", "nchw"):
        p = os.path.join(root, "fixture", s[k]["file"])
        if not os.path.exists(p):
            bad.append((s["sample_id"], k, "missing")); continue
        checked += 1
        if hashlib.sha256(np.load(p).tobytes()).hexdigest() != s[k]["sha256"]:
            bad.append((s["sample_id"], k, "sha mismatch"))
print(json.dumps({"checked": checked, "bad": bad}))
""" % E31_DIR
        rc, out, err = run([PY, "-c", probe2])
        try:
            d = json.loads(out.strip().splitlines()[-1])
        except Exception:
            d = {"checked": 0, "bad": [("probe", (err or out)[-160:])]}
        _s2 = rc == 0 and d["checked"] == 10 and not d["bad"]
        results.append(Result("e31: the 10 stored real/edge input arrays match their manifest sha256",
                              _s2, "" if _s2 else "%s" % d))

    # --- live: re-run both paths and re-judge, and re-run the negative control ---
    if not (_litert_available() and run([PY, "-c", "import iree.runtime"])[0] == 0
            and run([PY, "-c", "import numpy"])[0] == 0):
        results.append(Result("e31: both paths re-run live and reproduce the stored verdict", True,
                              "ai_edge_litert / iree.runtime not installed", skip=True))
        results.append(Result("e31: the negative control re-runs live and still FAILS", True,
                              "ai_edge_litert / iree.runtime not installed", skip=True))
        return results
    work = os.path.join(tmp, "e31")
    os.makedirs(work, exist_ok=True)
    # rebuild the full fixture (synthetic included) from the recorded recipe
    rc, out, err = run([PY, os.path.join(HERE, "model_fixture.py"), "--out", os.path.join(work, "fx"),
                        "--images", os.path.join(E31_DIR, "fixture", "inputs"),
                        "--height", "224", "--width", "224", "--mean", "0", "--std", "255",
                        "--synthetic", "32", "--seed", "31", "--edge"])
    # NOTE: the real images are not in the repo as images (only as .npy), so the live re-run uses the
    # stored arrays directly rather than re-preprocessing; build a manifest that points at them.
    live_fx = os.path.join(work, "live")
    os.makedirs(os.path.join(live_fx, "inputs"), exist_ok=True)
    build = r"""
import json, os, shutil, hashlib, sys
import numpy as np
src, dst = %r, %r
man = json.load(open(os.path.join(src, "fixture", "manifest.json")))
rng = np.random.default_rng(31)
rows = []
for s in man["samples"]:
    sid = s["sample_id"]
    if s["kind"] == "synthetic":
        nhwc = rng.random((1, 224, 224, 3), dtype=np.float32)
    else:
        nhwc = np.load(os.path.join(src, "fixture", s["nhwc"]["file"]))
    nchw = np.ascontiguousarray(nhwc.transpose(0, 3, 1, 2))
    pn, pc = os.path.join(dst, "inputs", sid + ".nhwc.npy"), os.path.join(dst, "inputs", sid + ".nchw.npy")
    np.save(pn, nhwc); np.save(pc, nchw)
    rows.append(dict(s, nhwc=dict(s["nhwc"], file="inputs/" + sid + ".nhwc.npy"),
                     nchw=dict(s["nchw"], file="inputs/" + sid + ".nchw.npy")))
json.dump(dict(man, samples=rows), open(os.path.join(dst, "manifest.json"), "w"))
print("built", len(rows))
""" % (E31_DIR, live_fx)
    rc, out, err = run([PY, "-c", build])
    if rc != 0:
        results.append(Result("e31: both paths re-run live and reproduce the stored verdict", False,
                              "could not rebuild the fixture: %s" % (err or out)[-200:]))
        return results
    o_live = os.path.join(work, "oracle.json"); i_live = os.path.join(work, "iree.json")
    c_live = os.path.join(work, "cmp.json")
    rc1, _, e1 = run([PY, os.path.join(HERE, "tflite_oracle.py"),
                      os.path.join(os.path.dirname(E31_DIR), "p1_smartcam_feasibility", "original", "model.tflite"),
                      "--fixture", live_fx, "--out", o_live])
    rc2, _, e2 = run([PY, os.path.join(HERE, "iree_runner.py"),
                      os.path.join(os.path.dirname(E31_DIR), "p1_smartcam_feasibility", "build", "smartcam.vmfb"),
                      "--fixture", live_fx, "--out", i_live])
    rc3, out3, e3 = run([PY, os.path.join(HERE, "e31_compare.py"), "--oracle", o_live,
                         "--iree", i_live, "--out", c_live])
    if rc1 or rc2 or rc3 or not os.path.exists(c_live):
        results.append(Result("e31: both paths re-run live and reproduce the stored verdict", False,
                              "rc=%d/%d/%d %s" % (rc1, rc2, rc3, (e1 or e2 or e3)[-200:])))
    else:
        live = load(c_live)
        _l = (live["verdict"] == "PASS" and live["totals"]["elements_failed"] == 0
              and live["totals"]["argmax_failed"] == 0 and live["totals"]["samples"] == 37)
        results.append(Result("e31: both paths re-run live and reproduce the stored verdict (PASS, 0 failures)",
                              _l, "" if _l else "live totals=%s verdict=%s" % (live["totals"], live["verdict"])))

    # negative control, regenerated
    neg_fx = os.path.join(work, "neg")
    os.makedirs(os.path.join(neg_fx, "inputs"), exist_ok=True)
    build_neg = r"""
import json, os, hashlib
import numpy as np
src, dst = %r, %r
man = json.load(open(os.path.join(src, "manifest.json")))
rows = []
for s in man["samples"]:
    sid = s["sample_id"]
    nhwc = np.load(os.path.join(src, s["nhwc"]["file"]))
    wrong = np.ascontiguousarray(nhwc.reshape(1, 3, 224, 224))   # RESHAPE, the mistake under test
    np.save(os.path.join(dst, "inputs", sid + ".nhwc.npy"), nhwc)
    np.save(os.path.join(dst, "inputs", sid + ".nchw.npy"), wrong)
    rows.append(dict(s, nhwc=dict(s["nhwc"], file="inputs/" + sid + ".nhwc.npy"),
                     nchw=dict(s["nchw"], file="inputs/" + sid + ".nchw.npy",
                               sha256=hashlib.sha256(wrong.tobytes()).hexdigest())))
json.dump(dict(man, samples=rows), open(os.path.join(dst, "manifest.json"), "w"))
print("built", len(rows))
""" % (live_fx, neg_fx)
    rc, out, err = run([PY, "-c", build_neg])
    i_neg = os.path.join(work, "iree_neg.json"); c_neg = os.path.join(work, "cmp_neg.json")
    rc2, _, e2 = run([PY, os.path.join(HERE, "iree_runner.py"),
                      os.path.join(os.path.dirname(E31_DIR), "p1_smartcam_feasibility", "build", "smartcam.vmfb"),
                      "--fixture", neg_fx, "--out", i_neg]) if rc == 0 else (rc, "", err)
    rc3, _, e3 = run([PY, os.path.join(HERE, "e31_compare.py"), "--oracle", o_live,
                      "--iree", i_neg, "--out", c_neg]) if rc2 == 0 else (rc2, "", e2)
    if rc3 or not os.path.exists(c_neg):
        results.append(Result("e31: the negative control re-runs live and still FAILS", False,
                              "rc=%s %s" % (rc3, (e2 or e3)[-200:])))
    else:
        ln = load(c_neg)
        _ln = (ln["verdict"] == "FAIL" and ln["totals"]["elements_failed"] == 105
               and ln["totals"]["argmax_failed"] == 3)
        results.append(Result("e31: the negative control re-runs live and still FAILS (105/111 elements, "
                              "3 argmax) -- the criteria can fail", _ln,
                              "" if _ln else "live negative control totals=%s verdict=%s"
                              % (ln["totals"], ln["verdict"])))
    return results


E32_DIR = os.path.join(os.path.dirname(HERE), "results", "e32_smartcam_aarch64")


def e32_aarch64_realigned_frame_cases(tmp):
    """E32 / D58: an AArch64 over-aligned dispatch frame is static, and the analyser
    already computed its bound -- but refused to let anything use it.

    LLVM gives a dispatch that needs 64 B-aligned locals this prologue/epilogue pair:

        stp  d15, d14, [sp, #-160]!     ; callee saves
        sub  x9, sp, #0x6a0             ; CONSTANT immediate
        and  sp, x9, #0xff..c0          ; round down -> at most 63 B of extra padding
        add  x29, sp, #0x40             ; frame record is not at the top of the frame
        ...
        sub  sp, x29, #0x40             ; one step back to the pre-realign sp
        ldp  ...                        ; pop callee saves

    `elf_stack_frame.py` recognised the *prologue* half from E14 on and even computed
    the correct bound (160 + 1696 + 63 = 1919).  It recognised only `mov sp, x29` as
    the restore, so the offset spelling left `realign_restored` false, which set
    `dynamic_stack_alloc` -> bucket (4) -> `gen_contract_header.py` refused a header.
    The x86-64 counterpart of exactly this restore (`lea -N(%rbp),%rsp`) had been
    handled since E14; the AArch64 offset form had not.  SmartCam on aarch64 hit it
    (5 of 40 dispatches), so an honest static f32 model could not be deployed --
    the D47/D48/D49 family again, type (B) over-rejection.

    The relaxation is one-directional (refused -> resolved, never the reverse) and
    the danger it introduces is UNDER-reporting stack, so the cases below pin the
    REFUSALS at least as hard as the acceptance."""
    import elf_stack_frame as esf                              # noqa: PLC0415 - local module
    results = []
    counter = [0]

    def analyze_a64(lines):
        counter[0] += 1
        return esf.analyze(objdump_txt=_synthetic_objdump(tmp, "a64_%d" % counter[0], lines,
                                                          fmt="elf64-littleaarch64"))

    def frame(lines):
        a = analyze_a64(lines)
        fns = a["functions"]
        return fns[0] if fns else {}

    # The real idiom, offset spelling: prologue `add x29, sp, #0x40`, epilogue
    # `sub sp, x29, #0x40`.  Static and bounded -> must resolve.
    good = [
        "    1000:\tstp\td15, d14, [sp, #-160]!",
        "    1004:\tsub\tx9, sp, #0x6a0",
        "    1008:\tstp\tx29, x30, [sp, #64]",
        "    100c:\tadd\tx29, sp, #0x40",
        "    1010:\tand\tsp, x9, #0xffffffffffffffc0",
        "    1014:\tstr\tq0, [sp, #16]",
        "    1018:\tsub\tsp, x29, #0x40",
        "    101c:\tldp\td15, d14, [sp], #160",
        "    1020:\tret",
    ]
    f = frame(good)
    _ok = (f.get("dynamic_stack_alloc") is False
           and f.get("realign_restore_form") == "sub_sp_from_fp_imm"
           and f.get("local_alloc_bytes") == 1696 and f.get("callee_save_bytes") == 160
           and f.get("realign_max_pad_bytes") == 63)
    results.append(Result("e32: `sub sp, x29, #K` restoring a realigned frame resolves (static, bounded)",
                          _ok, "" if _ok else json.dumps({k: f.get(k) for k in (
                              "dynamic_stack_alloc", "realign_restore_form", "local_alloc_bytes",
                              "callee_save_bytes", "realign_max_pad_bytes")})))

    # The independent arithmetic check: debits (frame_bytes) and credits
    # (restore_bytes) are accumulated separately, so a frame that balances is not
    # the same statement as "the pattern matched".
    _ok = f.get("frame_balanced") is True and f.get("frame_bytes") == 1856
    results.append(Result("e32: that frame balances -- restore_bytes equals frame_bytes (1856), computed separately",
                          _ok, "" if _ok else "frame_bytes=%s restore=%s balanced=%s" % (
                              f.get("frame_bytes"), f.get("restore_bytes"), f.get("frame_balanced"))))

    # REFUSAL 1: the epilogue offset must be the prologue's own.  A different K
    # lands sp somewhere this analyser has not accounted for.
    bad_k = [ln.replace("sub\tsp, x29, #0x40", "sub\tsp, x29, #0x30") for ln in good]
    f2 = frame(bad_k)
    _ok = f2.get("dynamic_stack_alloc") is True and f2.get("realign_restore_form") is None
    results.append(Result("e32: a MISMATCHED restore offset (`sub sp, x29, #0x30` vs `add x29, sp, #0x40`) stays refused",
                          _ok, "" if _ok else json.dumps({k: f2.get(k) for k in (
                              "dynamic_stack_alloc", "realign_restore_form")})))

    # REFUSAL 2: a genuine variable-length alloca is still unbounded even when the
    # realign pair around it is textbook.  This is the fail-open that a careless
    # widening would introduce.
    vla = good[:5] + ["    1013:\tsub\tsp, sp, x8"] + good[5:]
    f3 = frame(vla)
    _ok = f3.get("dynamic_stack_alloc") is True
    results.append(Result("e32: a real `sub sp, sp, x8` alloca stays refused even with a well-formed realign pair",
                          _ok, "" if _ok else json.dumps({k: f3.get(k) for k in ("dynamic_stack_alloc",)})))

    # REFUSAL 3: `sub xN, sp, #imm` with no `and sp, xN, #mask` consuming it is an
    # sp computation the analyser did not follow.
    dangling = [ln for ln in good if "and\tsp," not in ln]
    f4 = frame(dangling)
    _ok = f4.get("dynamic_stack_alloc") is True
    results.append(Result("e32: a dangling `sub x9, sp, #N` with no matching `and sp, x9, #mask` stays refused",
                          _ok, "" if _ok else json.dumps({k: f4.get(k) for k in ("dynamic_stack_alloc",)})))

    # REFUSAL 4: no frame pointer established -> no K to compare against.
    no_fp = [ln for ln in good if "add\tx29, sp," not in ln]
    f5 = frame(no_fp)
    _ok = f5.get("dynamic_stack_alloc") is True and f5.get("realign_restore_form") is None
    results.append(Result("e32: `sub sp, x29, #K` with no prologue frame-pointer setup stays refused",
                          _ok, "" if _ok else json.dumps({k: f5.get(k) for k in (
                              "dynamic_stack_alloc", "realign_restore_form")})))

    # The stored SmartCam aarch64 analysis: the model that exposed this.
    elf_json = os.path.join(E32_DIR, "build", "smartcam.elf.json")
    if not os.path.exists(elf_json):
        results.append(Result("e32: stored aarch64 SmartCam ELF analysis present", False,
                              "missing: %s" % elf_json))
        return results
    d = load(elf_json)
    _ok = (d.get("arch") == "aarch64" and d.get("any_dynamic_stack_alloc") is False
           and d.get("max_dispatch_invocation_stack_bytes") == 1919
           and d.get("max_dispatch_frame_bytes") == 1856
           and d.get("total_call_insns") == 0)
    results.append(Result("e32: SmartCam aarch64 resolves to a static 1,919 B task-stack bound (0 calls)",
                          _ok, "" if _ok else json.dumps({k: d.get(k) for k in (
                              "arch", "any_dynamic_stack_alloc", "max_dispatch_invocation_stack_bytes",
                              "max_dispatch_frame_bytes", "total_call_insns")})))
    # The classification the HEADER GATE actually reads lives in the contract, not
    # in the ELF analysis -- pin it where it is consumed (D52's lesson: check that
    # the gate uses the number the contract gave it).
    con_p = os.path.join(E32_DIR, "build", "smartcam.contract.json")
    hdr_p = os.path.join(E32_DIR, "build", "contract_gen.smartcam.h")
    if os.path.exists(con_p):
        con = load(con_p)
        cls = con.get("resources", {}).get("kernel_stack_classification")
        _ok = cls == "bucket_2_task_stack_budget"
        results.append(Result("e32: the contract records bucket_2_task_stack_budget (what the header gate reads)",
                              _ok, "" if _ok else "kernel_stack_classification=%r" % cls))
        _ok = not con.get("provenance", {}).get("overrides_applied")
        results.append(Result("e32: the aarch64 SmartCam contract needed zero overrides",
                              _ok, "" if _ok else json.dumps(con.get("provenance", {}).get("overrides_applied"))))
    else:
        results.append(Result("e32: stored aarch64 SmartCam contract present", False, "missing: %s" % con_p))
    if os.path.exists(hdr_p):
        hdr = open(hdr_p, encoding="utf-8").read()
        _ok = ("#define CONTRACT_KERNEL_STACK_BYTES 1919L" in hdr
               and "#define CONTRACT_KERNEL_STACK_BYTES_KNOWN 1" in hdr
               and "#define CONTRACT_BOUND_KNOWN 1" in hdr)
        results.append(Result("e32: a deployable header is emitted with the 1,919 B stack reported as KNOWN",
                              _ok, "" if _ok else "header does not carry the expected stack macros"))
    else:
        results.append(Result("e32: stored aarch64 SmartCam header present", False, "missing: %s" % hdr_p))
    _ok = d.get("all_dispatch_frames_balanced") is True
    results.append(Result("e32: every SmartCam aarch64 dispatch frame balances (the accounting closes)",
                          _ok, "" if _ok else "all_dispatch_frames_balanced=%s" % d.get("all_dispatch_frames_balanced")))
    forms = [f.get("realign_restore_form") for f in d.get("functions", []) if f.get("realign_restore_form")]
    _ok = forms.count("sub_sp_from_fp_imm") == 5 and forms.count("mov_sp_from_reg") == 8
    results.append(Result("e32: 5 dispatches use the offset restore (the refused spelling) and 8 the plain one",
                          _ok, "" if _ok else "forms=%s" % json.dumps(sorted(set(forms)))
                          + " counts=%d/%d" % (forms.count("sub_sp_from_fp_imm"), forms.count("mov_sp_from_reg"))))
    return results


def e32_admitted_budget_cases():
    """E32 / D59: the post-hoc memory check compared the peak with the wrong number.

    `peak_within_bounded` answers "is the UNCONDITIONAL contract sound?".  In the
    conditional tier admission is granted on `per_call`, not on `bounded`, so a
    conditional deployment that peaks ABOVE its approved budget still logged
    `peak_within_bounded: true`.  Measured on SmartCam/aarch64: admitted at 9,382,092,
    peaked at 9,984,204 (106.4% of the approved budget) -- and the overrun is exactly
    602,112 B, one input tensor, because a replay that keeps the resident input buffer
    AND allocates a per-sample input has two inputs live while `per_call`'s io term
    counts one.

    E29/E29b could not have seen this: their conditional cells used models whose input
    is a few dozen bytes, so the same structural overrun was invisible in the numbers.

    This is D53's rule ("compare the number you admitted on") applied to the check that
    runs AFTER inference, which E29b left comparing `bounded`.  Both figures are kept --
    one is about contract soundness, the other about this deployment -- and the cases
    below pin that both are emitted by both C paths."""
    results = []
    nat = os.path.join(os.path.dirname(HERE), "native", "native_learner.c")
    app = os.path.join(os.path.dirname(HERE), "native", "cfs_app", "fsw", "src", "ai_learner.c")
    for label, path in (("native_learner.c", nat), ("ai_learner.c", app)):
        if not os.path.exists(path):
            results.append(Result("e32: %s present" % label, False, "missing %s" % path))
            continue
        src = open(path, encoding="utf-8", errors="replace").read()
        _ok = "CONTRACT_PER_CALL_BYTES" in src and "admitted_budget" in src
        results.append(Result("e32: %s derives the admitted budget from the tier it admitted on" % label,
                              _ok, "" if _ok else "no admitted_budget derived from the conditional tier"))
        _ok = "peak_within_admitted_budget" in src
        results.append(Result("e32: %s reports peak_within_admitted_budget, not only peak_within_bounded" % label,
                              _ok, "" if _ok else "the deployment-budget comparison is not emitted"))
        _ok = "peak_within_bounded" in src
        results.append(Result("e32: %s still reports peak_within_bounded (contract soundness is not dropped)" % label,
                              _ok, "" if _ok else "the unconditional soundness signal was removed -- both are needed"))
    # the app must make an overrun loud, not merely tabulate it
    if os.path.exists(app):
        src = open(app, encoding="utf-8", errors="replace").read()
        _ok = "budget overrun" in src and "CFE_EVS_EventType_ERROR" in src
        results.append(Result("e32: the cFS app raises an EVS ERROR when the peak exceeds the admitted budget",
                              _ok, "" if _ok else "an overrun is recorded in JSON only, with no operator-visible event"))

    # --- the measured cells, and above all the CONTROL that made the diagnosis a
    # measurement rather than an argument ---
    summ_p = os.path.join(E32_DIR, "summary.json")
    if not os.path.exists(summ_p):
        results.append(Result("e32: E32 summary present", False, "missing %s" % summ_p))
        return results
    d = load(summ_p)

    v = d["verdicts"]
    _ok = (v["Q1_semantics"] == "PASS" and v["Q2_contract_admission"] == "PASS"
           and v["Q4_mode_separation"] == "PASS" and "FAILED" in v["Q3_lifecycle"]
           and d["verdicts"]["stage_2_complete"] is False)
    results.append(Result("e32: the recorded verdict keeps Q3's conditional shortfall (stage 2 not complete)",
                          _ok, "" if _ok else json.dumps(v)[:240]))

    c = d["contract"]
    _ok = (c["bounded_bytes"] == 18222796 and c["per_call_bytes"] == 9382092
           and c["constants_bytes"] == 8840704 and not c["overrides_applied"]
           and c["kernel_stack_classification"] == "bucket_2_task_stack_budget")
    results.append(Result("e32: the aarch64 contract is x86-64's three figures with zero overrides",
                          _ok, "" if _ok else json.dumps(c)[:240]))

    n, cf = d["cells"]["S_native"], d["cells"]["S_cfs"]
    _ok = (n["verdict"] == "PASS" and n["samples"] == 37 and n["elements"] == 111
           and n["elements_failed"] == 0 and n["argmax_failed"] == 0)
    results.append(Result("e32: S-native PASS on all 37 fixture samples (111 elements, 0 failures)",
                          _ok, "" if _ok else json.dumps(n)[:200]))
    _ok = (cf["verdict"] == "PASS" and cf["samples"] == 5 and cf["elements"] == 15
           and cf["elements_failed"] == 0 and cf["argmax_failed"] == 0
           and len(cf["declared_subset"] or []) == 5)
    results.append(Result("e32: S-cfs PASS on the 5 samples the plan declared before measuring",
                          _ok, "" if _ok else json.dumps(cf)[:200]))
    # the declared subset must still contain the non-constant real images: E31 measured that
    # constant edge inputs cannot detect a layout error at all.
    _ok = sum(1 for s in (cf["declared_subset"] or []) if s.startswith("img_")) == 3
    results.append(Result("e32: that declared subset contains all three non-constant real images",
                          _ok, "" if _ok else "declared=%s" % json.dumps(cf["declared_subset"])))

    t = d["D59_conditional_tier"]
    _ok = (t["with_replay"]["hal_peak"] == 9984204
           and t["without_replay"]["hal_peak"] == 9382092
           and t["without_replay"]["ratio"] == 1.0)
    results.append(Result("e32: the control isolates the overrun -- same budget, replay off, peak is exactly per_call",
                          _ok, "" if _ok else json.dumps({k: t[k] for k in ("with_replay", "without_replay")})[:260]))
    ar = t["arithmetic"]
    _ok = (ar["per_call"] == ar["io"] + ar["transient"]
           and ar["io"] == ar["input_tensor_bytes"] + ar["output_bytes"]
           and t["with_replay"]["hal_peak"] == ar["per_call"] + ar["input_tensor_bytes"])
    results.append(Result("e32: and the decomposition is exact -- peak == per_call + one input tensor",
                          _ok, "" if _ok else json.dumps(ar)[:220]))
    af = t["after_fix"]
    _ok = (af["peak_within_bounded"] is True and af["peak_within_admitted_budget"] is False
           and af["admission_mode"] == "conditional_map")
    results.append(Result("e32: after D59 the same run reports the violation instead of hiding it",
                          _ok, "" if _ok else json.dumps(af)[:220]))
    _ok = t["cfs_app_contrast"]["equals_per_call"] is True
    results.append(Result("e32: the cFS deployment adapter keeps one input live -- its peak is exactly per_call",
                          _ok, "" if _ok else json.dumps(t["cfs_app_contrast"])[:200]))

    b = d["budget_cells"]
    _ok = (b["native_B_minus_1"]["verdict"] == "NOT_ADMITTED" and b["native_B_minus_1"]["inferences"] == 0
           and b["native_B"]["verdict"] == "ADMIT" and b["native_B_plus_1"]["verdict"] == "ADMIT")
    results.append(Result("e32: budget boundary holds on aarch64 (B-1 DENY with 0 inferences, B and B+1 ADMIT)",
                          _ok, "" if _ok else json.dumps(b)[:240]))
    # the plan said something that turned out to be impossible; that has to stay recorded
    _ok = (b["cfs_B_minus_1"]["buildable"] is False and "plan_error" in b["cfs_B_minus_1"])
    results.append(Result("e32: the cFS B-1 cell records why it is unbuildable AND that the plan was wrong about it",
                          _ok, "" if _ok else json.dumps(b.get("cfs_B_minus_1"))[:240]))
    return results


E33_DIR = os.path.join(os.path.dirname(HERE), "results", "e33_onair_official")


def e33_official_onair_cases(tmp):
    """E33 / stage 3: the plugin runs under NASA OnAIR's OWN loader, and a refusal
    leaves OnAIR alive.

    v0.22.1 had to correct E25's "OnAIR-IREE" to "direct iree.runtime call": the
    official loading path had never been exercised. What is pinned here is the
    difference between those two things, plus the three NASA-source constraints the
    design had to obey and the two-way defect rule applied to a refusal:

      * the loader passes (construct_name, headers) and nothing else, so deployment
        settings must arrive out of band;
      * `AIPlugin` asserts non-empty headers while an image must NOT be spread over
        150,528 header fields -> two input modes;
      * NASA's csv parser floatifies every field, so a STRING sample id would arrive
        as 0.0 and every frame would silently replay sample zero -> numeric index.

    The refusal cells matter as much as the admitting one: a plugin that takes the
    OnAIR process down with it is not fail-closed, it is just broken."""
    results = []
    pure = admission_policy_unit_cases()
    results.extend(pure)

    summ_p = os.path.join(E33_DIR, "summary.json")
    if not os.path.exists(summ_p):
        results.append(Result("e33: official OnAIR run summary present", False,
                              "missing %s" % summ_p))
        return results
    d = load(summ_p)
    cells = d["cells"]

    # every cell must have gone through NASA's loader with OnAIR core untouched
    bad = [n for n, c in cells.items()
           if not (c["plugin_constructed_by_nasa_loader"] and c["onair_core_unmodified"])]
    results.append(Result("e33: all four cells were constructed by NASA's loader with OnAIR core untouched",
                          not bad, "" if not bad else "cells failing: %s" % bad))

    a = cells["p_admit"]
    _ok = a["active"] is True and a["inferences"] == 5 and a["returncode"] == 0
    results.append(Result("e33: P-admit ran 5 inferences through the official path",
                          _ok, "" if _ok else json.dumps({k: a[k] for k in
                                                          ("active", "inferences", "returncode")})))
    s = a["semantics"]
    _ok = (s["verdict"] == "PASS" and s["elements"] == 15 and s["elements_failed"] == 0
           and s["argmax_failed"] == 0)
    results.append(Result("e33: and its outputs meet the criteria inherited unchanged from E25/E31/E32",
                          _ok, "" if _ok else json.dumps(s)[:220]))
    _ok = "ORIGINAL TFLite oracle" in s["reference"]
    results.append(Result("e33: judged against the ORIGINAL oracle, not against another IREE run",
                          _ok, "" if _ok else s.get("reference")))

    # the refusals: zero inferences AND a living OnAIR process
    for name, why in (("p_deny", "budget below the bound"),
                      ("p_mismatch", "artifact does not match the contract")):
        c = cells[name]
        _ok = (c["active"] is False and c["inferences"] == 0 and c["returncode"] == 0
               and bool(c["inactive_reason"]))
        results.append(Result("e33: %s refuses (%s) with 0 inferences and OnAIR still exits cleanly"
                              % (name, why), _ok,
                              "" if _ok else json.dumps({k: c[k] for k in
                                                         ("active", "inferences", "returncode",
                                                          "inactive_reason")})[:240]))
    _ok = "before reading" in (cells["p_mismatch"]["inactive_reason"] or "")
    results.append(Result("e33: the mismatch is caught BEFORE the artifact is read (size pre-check first)",
                          _ok, "" if _ok else cells["p_mismatch"].get("inactive_reason")))

    # the legacy path must not have been broken by any of this (type (B) regression)
    lg = cells["p_legacy"]
    _ok = lg["active"] is True and lg["inferences"] > 0
    results.append(Result("e33: the original MLP path still runs (telemetry mode, external weights)",
                          _ok, "" if _ok else json.dumps(lg)[:200]))
    _ok = (lg["admission"] or {}).get("verdict") == "NOT_EVALUATED"
    results.append(Result("e33: and its old-style contract records NOT_EVALUATED rather than "
                          "inventing a bound", _ok,
                          "" if _ok else json.dumps(lg.get("admission"))[:200]))

    # the constraints that were read out of NASA's source, kept where a future
    # change would have to notice them
    k = d["constraints_read_from_nasa_source"]
    _ok = ("floatify" in k["csv_floatifies"] and "0.0" in k["csv_floatifies"]
           and "NUMERIC index" in k["csv_floatifies"])
    results.append(Result("e33: the record keeps WHY the frame carries a numeric index "
                          "(a string id would floatify to 0.0 and replay sample zero)",
                          _ok, "" if _ok else k.get("csv_floatifies", "")[:200]))
    _ok = "6 results for 5 frames" in k["extra_render_call"]
    results.append(Result("e33: and that OnAIR calls render_reasoning() once more with no fresh input",
                          _ok, "" if _ok else k.get("extra_render_call", "")[:200]))

    # the plugin source: the properties the review's SS6.1 table asked for
    src_p = os.path.join(os.path.dirname(HERE), "plugins", "compiled_learner",
                         "compiled_learner_plugin.py")
    if os.path.exists(src_p):
        src = open(src_p, encoding="utf-8", errors="replace").read()
        for label, pat in (("a fixed-size latency ring, not a per-call list", "deque(maxlen=LAT_RING)"),
                           ("deployment settings out of band", "ONAIR_MLIR_DEPLOYMENT_CONFIG"),
                           ("full outputs preserved for verification", "self.last_output"),
                           ("stale render calls do not spend an inference", "self.n_stale_calls")):
            results.append(Result("e33: plugin keeps %s" % label, pat in src,
                                  "" if pat in src else "expected %r in the plugin" % pat))
        _ok = "self._x[0, i] = 0.0" not in src
        results.append(Result("e33: an unconvertible telemetry field is an error, not a silent 0.0",
                              _ok, "" if _ok else "the zero-substitution path is back"))
    return results


def admission_policy_unit_cases():
    """The pure decision, exercised directly. It is shared by the plugin and must never
    invent a bound: an unknown method refuses, and the conditional tier is only reachable
    when the unconditional answer does NOT already fit (E29) -- otherwise a deployment
    would trade a proven bound for a precondition for nothing."""
    import admission_policy as ap                                # noqa: PLC0415
    out = []

    def contract(bounded, per_call, constants, method="static_from_stream_layout"):
        return {"resources": {"bound_method": method, "bounded_bytes": bounded,
                              "static_per_call_bytes": per_call,
                              "module_resident_constant_bytes": constants}}

    c = contract(100, 40, 60)
    v = ap.decide(c, 100)
    _ok = v["verdict"] == ap.ADMIT and v["admitted_budget_bytes"] == 100
    out.append(Result("e33/policy: budget == bounded admits, and records the budget it decided on",
                      _ok, "" if _ok else json.dumps(v)[:200]))
    v = ap.decide(c, 99)
    _ok = v["verdict"] == ap.NOT_ADMITTED and v["admitted_budget_bytes"] is None
    out.append(Result("e33/policy: budget == bounded-1 refuses", _ok,
                      "" if _ok else json.dumps(v)[:200]))
    v = ap.decide(c, 99, allow_conditional_map=True)
    _ok = (v["verdict"] == ap.ADMIT_CONDITIONAL_MAP and v["admitted_budget_bytes"] == 40)
    out.append(Result("e33/policy: the conditional tier admits on per_call and says so in "
                      "admitted_budget_bytes (D59's number)", _ok,
                      "" if _ok else json.dumps(v)[:220]))
    v = ap.decide(c, 100, allow_conditional_map=True)
    _ok = v["verdict"] == ap.ADMIT and v["conditional_available"] is False
    out.append(Result("e33/policy: when the unconditional bound already fits, the conditional "
                      "tier is NOT entered", _ok, "" if _ok else json.dumps(v)[:220]))
    v = ap.decide(c, 39, allow_conditional_map=True)
    _ok = v["verdict"] == ap.NOT_ADMITTED
    out.append(Result("e33/policy: a budget below per_call refuses even with the tier enabled",
                      _ok, "" if _ok else json.dumps(v)[:200]))
    for method in (None, "NONE", "none", "unspecified"):
        v = ap.decide(contract(100, 40, 60, method), 10 ** 9)
        _ok = v["verdict"] == ap.REFUSED_UNKNOWN_BOUND
        out.append(Result("e33/policy: bound_method %r refuses at any budget" % method, _ok,
                          "" if _ok else json.dumps(v)[:200]))
    try:
        ap.decide(contract(101, 40, 60), 10 ** 9)
        _ok = False
    except ap.AdmissionInputError:
        _ok = True
    out.append(Result("e33/policy: a contract whose bounded != per_call + constants is refused, "
                      "not admitted on the larger figure", _ok,
                      "" if _ok else "a self-inconsistent contract was accepted"))
    for bad in (-1, "100", 1.5, True):
        try:
            ap.decide(contract(100, 40, 60), bad)
            _ok = False
        except ap.AdmissionInputError:
            _ok = True
        out.append(Result("e33/policy: budget %r is refused as input, never coerced" % (bad,), _ok,
                          "" if _ok else "budget %r was accepted" % (bad,)))
    _ok = not ap.admitted("ADMITTED") and not ap.admitted(None) and ap.admitted(ap.ADMIT)
    out.append(Result("e33/policy: admitted() is a whitelist -- an unrecognised verdict is not "
                      "an admission", _ok, "" if _ok else "admitted() accepted an unknown verdict"))
    return out


E34_DIR = os.path.join(os.path.dirname(HERE), "results", "e34_two_models")


def e34_two_models_cases():
    """E34 / stage 4: the same tools, two more public models -- and the argmax measurement
    that turns the review's SS9.3 instruction into a fact.

    What is pinned:
      * both verdicts and their FULL element counts (DeepAE's 21,760 outputs are all compared);
      * that argmax stays a CLASSIFIER's check: DeepAE's argmax is the same index on every one
        of 34 inputs, so its 34/34 agreement is evidence of nothing. The plan predicted this
        would show up as an over-rejection; it did not, and the record says so;
      * the negative control, because a PASS means nothing if the criteria cannot fail -- and
        it replicates BOTH of E31's lessons on a different model, the second one exactly;
      * that the originals are in-tree and hash as their recorded provenance (D43);
      * that generalising the tools did not move E31's stored verdict."""
    results = []
    p = os.path.join(E34_DIR, "summary.json")
    if not os.path.exists(p):
        results.append(Result("e34: stage-4 summary present", False, "missing %s" % p))
        return results
    d = load(p)

    b2, b3 = d["cells"]["b2_resnet"], d["cells"]["b3_deepae"]
    _ok = (b2["verdict"] == "PASS" and b2["elements"] == 340 and b2["elements_failed"] == 0
           and b2["argmax_mode"] == "require" and b2["argmax_failed"] == 0)
    results.append(Result("e34: ResNet PASS on 340 elements with argmax required",
                          _ok, "" if _ok else json.dumps(b2)[:220]))
    _ok = (b3["verdict"] == "PASS" and b3["elements"] == 21760 and b3["elements_failed"] == 0
           and b3["argmax_mode"] == "not-applicable")
    results.append(Result("e34: DeepAE PASS on all 21,760 outputs, argmax declared not applicable",
                          _ok, "" if _ok else json.dumps(b3)[:220]))

    a = d["argmax_observation"]
    _ok = a["b3_deepae_distinct_argmax"] == [261] and len(a["b2_resnet_distinct_argmax"]) > 1
    results.append(Result("e34: DeepAE's argmax is ONE index across all inputs (no discriminating "
                          "power) while ResNet's varies", _ok,
                          "" if _ok else json.dumps({k: a[k] for k in
                                                     ("b2_resnet_distinct_argmax",
                                                      "b3_deepae_distinct_argmax")})))
    _ok = "not confirmed" in a["measured"] and "PASS" in a["b3_argmax_required_run_verdict"]
    results.append(Result("e34: the plan's predicted over-rejection is recorded as NOT confirmed",
                          _ok, "" if _ok else a.get("b3_argmax_required_run_verdict", "")[:160]))

    n = d["negative_control"]
    _ok = (n["verdict"] == "FAIL" and n["elements_failed"] == 258 and n["elements"] == 340)
    results.append(Result("e34: the wrong-layout control FAILS (258/340 elements)",
                          _ok, "" if _ok else json.dumps(n)[:220]))
    _ok = n["argmax_would_have_passed"] == "34/34" and n["argmax_failed"] == 0
    results.append(Result("e34: and argmax alone would have accepted that wrong layout on ALL 34 "
                          "samples (E31 measured 92% on another model)", _ok,
                          "" if _ok else str(n.get("argmax_would_have_passed"))))
    _ok = (sorted(n["samples_the_element_rule_could_not_catch"]) == ["edge_ones", "edge_zeros"])
    results.append(Result("e34: the only samples it could not catch are the two CONSTANT edge "
                          "inputs -- E31's limit replicates exactly", _ok,
                          "" if _ok else json.dumps(n.get("samples_the_element_rule_could_not_catch"))))

    t = d["tooling"]
    _ok = t["new_per_model_harnesses"] == 0 and t["artifacts_recompiled"] == 0
    results.append(Result("e34: no new per-model harness and no recompilation (stage 4's actual criterion)",
                          _ok, "" if _ok else json.dumps(t)[:200]))
    _ok = d["regression"]["e31_smartcam_reproduced"] is True
    results.append(Result("e34: generalising the tools reproduced E31's stored verdict unchanged",
                          _ok, "" if _ok else json.dumps(d["regression"])[:200]))

    # the originals must actually be in the tree and hash as recorded (D43)
    orig = d["originals_preserved"]
    for f in orig["files"]:
        fp = os.path.join(E34_DIR, "originals", f["file"])
        if not os.path.exists(fp):
            results.append(Result("e34: original %s preserved in-tree" % f["file"], False,
                                  "missing %s" % fp))
            continue
        got = hashlib.sha256(open(fp, "rb").read()).hexdigest()
        _ok = got == f["sha256"] and os.path.getsize(fp) == f["bytes"]
        results.append(Result("e34: original %s matches its recorded provenance hash" % f["file"],
                              _ok, "" if _ok else "sha256 %s vs %s" % (got[:16], f["sha256"][:16])))

    _ok = all("SYNTHETIC-ONLY" in c["semantic_grade"] for c in (b2, b3))
    results.append(Result("e34: both cells are graded SYNTHETIC-ONLY (no accuracy claimed, weaker "
                          "than SmartCam's real-image grade)", _ok,
                          "" if _ok else json.dumps([b2["semantic_grade"], b3["semantic_grade"]])[:200]))
    return results


def e34_comparator_generalisation_cases(tmp):
    """The comparator's two new switches must narrow what is CHECKED, never what is FORGIVEN.

    `--argmax not-applicable` is a declared model property; if it ever let a genuine element
    mismatch pass, or turned an argmax MISMATCH into a pass, the E34 verdicts would be worthless."""
    results = []
    cmp_py = os.path.join(HERE, "e31_compare.py")

    def run_cmp(oracle, iree, extra=()):
        o = os.path.join(tmp, "o.json")
        i = os.path.join(tmp, "i.json")
        out = os.path.join(tmp, "c.json")
        json.dump(oracle, open(o, "w"))
        json.dump(iree, open(i, "w"))
        rc, so, se = run([PY, cmp_py, "--oracle", o, "--iree", i, "--out", out] + list(extra))
        try:
            return rc, load(out)
        except Exception:
            return rc, {"verdict": "TOOL_ERROR", "stderr": se[-200:]}

    def doc(outs, argmaxes):
        return {"results": [{"sample_id": "s%d" % k, "kind": "synthetic", "output": o,
                             "argmax": am} for k, (o, am) in enumerate(zip(outs, argmaxes))]}

    # an element mismatch must FAIL even with argmax declared not-applicable
    orc = doc([[1.0, 2.0, 3.0]], [2])
    bad = doc([[1.0, 2.0, 3.5]], [2])
    rc, c = run_cmp(orc, bad, ["--argmax", "not-applicable"])
    _ok = c["verdict"] == "FAIL" and c["totals"]["elements_failed"] == 1
    results.append(Result("e34/cmp: --argmax not-applicable still FAILS on an element mismatch",
                          _ok, "" if _ok else json.dumps(c.get("totals", c))[:200]))

    # an argmax mismatch with matching elements: `require` fails, `not-applicable` passes on the
    # elements alone -- and the record must say the check was not applied, never that it passed
    orc = doc([[1.0, 2.0]], [1])
    swapped = doc([[1.0, 2.0]], [0])          # same numbers, contradictory argmax label
    rc, c = run_cmp(orc, swapped)
    _ok = c["verdict"] == "FAIL" and c["totals"]["argmax_failed"] == 1
    results.append(Result("e34/cmp: the default still requires argmax and fails on a mismatch",
                          _ok, "" if _ok else json.dumps(c.get("totals", c))[:200]))
    rc, c = run_cmp(orc, swapped, ["--argmax", "not-applicable"])
    _ok = (c["verdict"] == "PASS" and c["samples"][0]["argmax_ok"] is None
           and "NOT APPLICABLE" in c["criteria"]["argmax"])
    results.append(Result("e34/cmp: with the check declared not applicable, argmax_ok is null "
                          "(not true) and the criteria say so", _ok,
                          "" if _ok else json.dumps(c.get("samples", [{}])[0])[:200]))

    # --detail failures must keep every FAILING row
    orc = doc([[1.0, 2.0, 3.0]], [2])
    bad = doc([[1.0, 9.0, 3.0]], [2])
    rc, c = run_cmp(orc, bad, ["--detail", "failures"])
    rows = c["samples"][0]["elements_detail"]
    _ok = (c["verdict"] == "FAIL" and len(rows) == 1 and rows[0]["index"] == 1
           and c["samples"][0]["elements"] == 3)
    results.append(Result("e34/cmp: --detail failures keeps every failing row and the full element count",
                          _ok, "" if _ok else json.dumps(c["samples"][0])[:240]))
    return results


E35_DIR = os.path.join(os.path.dirname(HERE), "results", "e35_fair_baseline")


def e35_fair_baseline_cases():
    """E35 / stage 5: with the SAME conditional knowledge, the artifact-only level decides
    exactly what the MLIR level decides.

    This is the deflationary result the ninth review SS8.3 asked for, and the pins here exist
    to stop it being quietly re-inflated later:

      * 24/24 admission verdicts agree -- if a future change makes them differ, that is a
        finding, not a silent improvement;
      * the baseline really was GIVEN the conditional bound (band_between admits
        conditionally at per_call on BOTH levels). A comparison that forgot to do that
        would manufacture an MLIR advantage out of execution policy;
      * the kernel stack agrees too. The first run of the collector said 0/4, which was a
        TOOL bug (wrong contract field name), not a finding -- the embedded ELF is inside
        the vmfb, so the same analyser runs at either level;
      * the one asymmetry (one-invocation binding) is recorded as a COST of using several
        artifacts, never as an MLIR advantage."""
    results = []
    p = os.path.join(E35_DIR, "summary.json")
    if not os.path.exists(p):
        results.append(Result("e35: fair-baseline matrix present", False, "missing %s" % p))
        return results
    d = load(p)
    t = d["totals"]

    _ok = t["cells"] == 24 and t["verdicts_disagreeing"] == 0 and t["verdicts_agreeing"] == 24
    results.append(Result("e35: all 24 admission verdicts agree between the MLIR and artifact-only levels",
                          _ok, "" if _ok else json.dumps(t)))
    _ok = t["models_where_three_figures_agree"] == t["models_total"] == 4
    results.append(Result("e35: bounded/per_call/constants agree on all 4 models",
                          _ok, "" if _ok else json.dumps(t)))
    _ok = t["models_where_kernel_stack_agrees"] == 4
    results.append(Result("e35: the kernel stack figure agrees too (it is not MLIR-exclusive)",
                          _ok, "" if _ok else json.dumps(t)))

    f = d["fairness"]
    _ok = (f["conditional_knowledge_given_to_baseline"] is True
           and "admission_policy.py" in f["same_policy_code"]
           and f["recompiled"] == 0)
    results.append(Result("e35: the baseline was given the conditional bound and both levels ran ONE "
                          "policy implementation", _ok, "" if _ok else json.dumps(f)[:220]))

    # the fairness claim has to be visible in the cells, not only asserted in a field
    between = [c for c in d["cells"] if c["band"] == "band_between" and c["policy"] == "conditional_map"]
    _ok = (len(between) == 4
           and all(c["level_b_verdict"] == "ADMIT_CONDITIONAL_MAP" for c in between)
           and all(c["level_b_admitted_budget"] == c["level_c_admitted_budget"] for c in between))
    results.append(Result("e35: in the between band the artifact-only level admits conditionally on "
                          "the SAME budget (the fairness condition, checked in the cells)",
                          _ok, "" if _ok else json.dumps(between)[:260]))
    uncond = [c for c in d["cells"] if c["band"] == "band_between" and c["policy"] == "unconditional"]
    _ok = len(uncond) == 4 and all(c["level_c_verdict"] == "NOT_ADMITTED" for c in uncond)
    results.append(Result("e35: and the unconditional policy denies that same budget, so the band "
                          "actually separates the two policies", _ok,
                          "" if _ok else json.dumps(uncond)[:220]))

    # the asymmetry must stay described as a cost
    m = next(iter(d["models"].values()))
    _ok = (m["level_c_mlir"]["one_invocation_binding"] is True
           and m["level_b_artifact_only"]["one_invocation_binding"] is None
           and "cross-check against" in m["level_b_artifact_only"].get("one_invocation_note", ""))
    results.append(Result("e35: one-invocation binding is recorded as not-produced with the reason, "
                          "not as an MLIR advantage", _ok,
                          "" if _ok else json.dumps(m.get("level_b_artifact_only", {}))[:220]))

    # and the claim guardrails must carry the deflation
    claude = os.path.join(os.path.dirname(HERE), "CLAUDE.md")
    if os.path.exists(claude):
        txt = open(claude, encoding="utf-8", errors="replace").read()
        _ok = "24/24" in txt and "MLIR 기반 계약 추출·연계 방법" in txt
        results.append(Result("e35: the claim guardrails record the 24/24 result and the narrowed "
                              "wording", _ok,
                              "" if _ok else "CLAUDE.md does not carry E35's narrowing"))
    return results


def e33_e35_errata_cases():
    """v0.38.1 / D60: the two errata that came out of reading the RAW DATA, pinned so neither
    half can drift back.

    D60 is the repository's own failure mode seen once more: `EVIDENCE_v0.36_E33.md` claimed the
    OnAIR path released its output buffers every call, while the very run it cites reports leaked
    nanobind instances at interpreter shutdown. The raw file was committed the whole time -- no
    test had ever looked at that field, so the suite stayed green. These checks therefore pin BOTH
    sides: the condition is really there in the raw log, AND the evidence document says so. If IREE
    ever fixes the binding refcount the first check fails and tells us to re-examine the claim,
    which is the point -- "released" must never become true by silence again.

    The E35 pair is the same discipline applied to a softer error: agreement between two
    information levels is not evidence of INDEPENDENCE when both levels run the same analyser."""
    results = []
    root = os.path.dirname(HERE)

    run_json = os.path.join(E33_DIR, "p_admit", "run.json")
    if not os.path.exists(run_json):
        results.append(Result("d60: E33 p_admit raw run.json present", False, "missing %s" % run_json))
    else:
        tail = load(run_json).get("stderr_tail", "") or ""
        _ok = "nanobind" in tail and "leaked" in tail
        results.append(Result("d60: the raw log really does report unreleased nanobind instances "
                              "(the condition the erratum describes, not a paraphrase)", _ok,
                              "" if _ok else "stderr_tail no longer carries the leak report: %r" % tail[:160]))
        _ok = "HalBufferView" in tail or "MappedMemory" in tail
        results.append(Result("d60: and the leaked types are the IREE runtime buffer objects", _ok,
                              "" if _ok else tail[:160]))

    ev = os.path.join(root, "docs", "EVIDENCE_v0.36_E33.md")
    txt = open(ev, encoding="utf-8", errors="replace").read() if os.path.exists(ev) else ""
    _ok = "nanobind" in txt and "미검증" in txt and "정오표" in txt
    results.append(Result("d60: EVIDENCE_v0.36_E33 carries the erratum -- the leak warning is "
                          "recorded and the status is stated as not-verified", _ok,
                          "" if _ok else "the evidence document does not record the raw-data contradiction"))

    claude = os.path.join(root, "CLAUDE.md")
    ctxt = open(claude, encoding="utf-8", errors="replace").read() if os.path.exists(claude) else ""
    _ok = "출력 버퍼 해제를 검증했다" in ctxt and "오류가 독립" in ctxt
    results.append(Result("d60: the claim guardrails forbid both retracted claims (OnAIR release "
                          "verified; the two sources' errors are independent)", _ok,
                          "" if _ok else "CLAUDE.md guardrails do not carry the v0.38.1 retractions"))

    summ = os.path.join(E35_DIR, "summary.json")
    if not os.path.exists(summ):
        results.append(Result("e35 errata: summary present", False, "missing %s" % summ))
    else:
        names = list(load(summ)["models"].keys())
        base = {n.replace("_x86_64", "").replace("_aarch64", "") for n in names}
        _ok = len(names) == 4 and len(base) == 3
        results.append(Result("e35 errata: the matrix is 4 model-TARGET configurations over 3 "
                              "distinct models (SmartCam is counted twice)", _ok,
                              "" if _ok else "%s -> %s" % (names, sorted(base))))

    ev35 = os.path.join(root, "docs", "EVIDENCE_v0.38_E35.md")
    t35 = open(ev35, encoding="utf-8", errors="replace").read() if os.path.exists(ev35) else ""
    collector = os.path.join(HERE, "e35_baseline_policy_matrix.py")
    ctext = open(collector, encoding="utf-8", errors="replace").read() if os.path.exists(collector) else ""
    shares_analyser = "elf_stack_frame.py" in ctext
    _ok = shares_analyser and "정보원 독립성의 증거가 아니다" in t35
    results.append(Result("e35 errata: the shared analyser is a fact of the collector AND the "
                          "evidence says the stack agreement is not an independence result", _ok,
                          "" if _ok else "collector_uses_elf_stack_frame=%s; erratum_present=%s"
                          % (shares_analyser, "정보원 독립성의 증거가 아니다" in t35)))
    return results


E27_HARDENED_DIR = os.path.join(os.path.dirname(HERE), "results", "e27_baselines", "hardened")


def e27_hardened_baseline_cases():
    """EVIDENCE_v0.29_E27 SS7 (v0.31 errata): E27's silent-under-report was the
    SHIPPED implementation's property, not the information level's.

    E27 concluded from `harness/e27_baseline_vmfb_only.py` that an artifact-only
    analyser "reports what it could not read as absent".  The fail-closed
    steelman at the same level -- deployed vmfb + `iree-dump-module` only --
    refuses the drift artifact explicitly and over-rejects none of the honest
    ones.  Both halves matter and both are pinned here: a future change that
    makes the hardened baseline start refusing honest artifacts would turn the
    errata's "0 over-rejection" into a false statement, and one that makes it
    stop refusing the drift artifact would restore the silent path.

    Also pinned: the arithmetic of the 152x under-report, because SS3.1 named
    only one of its two independent causes.  5,172 = 36 input bytes + 5,136
    bytes of executable ELF mis-attributed as the constant pool, which happens
    because IREE 3.10 and 3.11 order the vmfb entries differently."""
    results = []
    p = os.path.join(E27_HARDENED_DIR, "summary.json")
    if not os.path.exists(p):
        results.append(Result("e27-hardened: fixture preserved", False, "missing %s" % p))
        return results
    d = load(p)
    su = d["summary"]
    results.append(Result("e27-hardened: 7 honest artifacts reproduce the contract bound exactly",
                          su["honest_artifacts"] == 7 and su["honest_exact"] == 7,
                          "honest=%s exact=%s" % (su["honest_artifacts"], su["honest_exact"])))
    results.append(Result("e27-hardened: over-rejection is 0 (the errata's claim is two-sided)",
                          su["honest_over_rejected"] == 0,
                          "over_rejected=%s" % su["honest_over_rejected"]))
    results.append(Result("e27-hardened: the drift artifact is REFUSED, not under-reported",
                          su["drift_refused"] == su["drift_artifacts"] == 1
                          and su["drift_refusal_codes"] == ["C4_DISASM"],
                          "refused=%s codes=%s" % (su["drift_refused"], su["drift_refusal_codes"])))
    w = su["weak_baseline_on_drift"]
    results.append(Result("e27-hardened: the 152x under-report is 36 + 5,136, and its dominant "
                          "term is the segment-order assumption SS3.1 did not name",
                          w["reported_bounded"] == 5172 and w["contract_bounded"] == 786476
                          and len(w["two_independent_failures"]) == 2,
                          "weak=%s" % w))
    # the shipped weak baseline must stay un-hardened: it is the measured object.
    weak = open(os.path.join(os.path.dirname(HERE), "harness", "e27_baseline_vmfb_only.py"),
                encoding="utf-8").read()
    results.append(Result("e27-hardened: the weak baseline stays un-hardened "
                          "(it is what E27 measured; hardening it would erase the observation)",
                          "unlabeled[:-1]" in weak,
                          "e27_baseline_vmfb_only.py no longer contains the measured assumption"))
    hard = open(os.path.join(os.path.dirname(HERE), "harness",
                             "e27_baseline_vmfb_only_hardened.py"), encoding="utf-8").read()
    results.append(Result("e27-hardened: the steelman is in tree and reads only the artifact",
                          "C4_DISASM" in hard and "layout_ir" not in hard,
                          "hardened baseline missing or reads more than the artifact"))
    return results


E29_DIR = os.path.join(os.path.dirname(HERE), "results", "e29_conditional_contract")


def e29_conditional_contract_cases():
    """E29: the `stream.resource.try_map` arm is decided by ONE deployment property.

    E26 measured the same vmfb peaking anywhere from `per_call` to
    `per_call + constants` depending on the deployment (up to 172.30x, E26f) and
    recorded the determinant as UNDETERMINED after ruling out four candidates.
    E29 identified it in IREE's own source -- `iree_hal_heap_buffer_wrap()`
    refuses an imported span that is not 64-byte aligned, and the map arm is
    exactly that import -- and measured it: 64 cells (8 models x 8 alignment
    classes) split 32 map / 32 copy with the arm agreeing with the alignment in
    every cell and no third peak value anywhere.

    Two things follow, and both are pinned here.

    (1) `bounded_bytes` was never unsound: it is the max over the arms, and the
        copy arm hits it exactly while the map arm hits `per_call` exactly.  E26
        Q1 is untouched.  What changes is tightness, and it is not intrinsic --
        it is a property of one pointer the deploying app allocates itself.
    (2) Both C paths therefore allocate the module image aligned, and the
        conditional admission tier (opt-in) admits on the map arm's bound while
        VERIFYING the arm after append and refusing before any inference if the
        copy arm ran.  A revert of either half must fail here: without the
        aligned allocation the map cells stop reproducing, and without the
        post-append verification the conditional tier becomes a fail-open."""
    results = []
    sweep_p = os.path.join(E29_DIR, "align_sweep.json")
    summ_p = os.path.join(E29_DIR, "summary.json")
    if not (os.path.exists(sweep_p) and os.path.exists(summ_p)):
        results.append(Result("e29: fixture preserved", False, "missing %s / %s" % (sweep_p, summ_p)))
        return results
    sweep = load(sweep_p)
    summ = load(summ_p)

    # --- the determinant, cell by cell -------------------------------------
    cells = sweep["cells"]
    graded = [c for c in cells if c["arm"] != "append_failed"]
    results.append(Result("e29: alignment sweep is 64 graded cells (8 models x 8 classes)",
                          len(graded) == 64, "graded=%d of %d" % (len(graded), len(cells))))
    results.append(Result("e29: no cell produced a third peak value (two-arm model exact)",
                          all(c["arm"] in ("map", "copy") for c in graded),
                          "arms=%s" % sorted({c["arm"] for c in graded})))
    results.append(Result("e29: map arm <=> 64-byte aligned module image, in every cell",
                          all((c["arm"] == "map") == (c["blob_ptr_mod64"] == 0) for c in graded),
                          "mismatched cells=%s" % [(c["model"], c["delta"], c["arm"])
                                                   for c in graded
                                                   if (c["arm"] == "map") != (c["blob_ptr_mod64"] == 0)][:4]))
    results.append(Result("e29: map cells allocate nothing for constants, copy cells allocate exactly them",
                          all((c["init_peak"] == 0) if c["arm"] == "map"
                              else (c["init_peak"] == c["contract_constants"]) for c in graded),
                          "off cells=%s" % [(c["model"], c["arm"], c["init_peak"], c["contract_constants"])
                                            for c in graded
                                            if (c["init_peak"] != 0 if c["arm"] == "map"
                                                else c["init_peak"] != c["contract_constants"])][:4]))

    # --- the two arms land on the two contract terms, exactly ---------------
    tbl = summ["native_x86_64"]
    results.append(Result("e29: 7 models measured both ways on x86-64 native",
                          len(tbl) == 7, "models=%d" % len(tbl)))
    results.append(Result("e29: map arm peak == contract per_call, every model "
                          "(the conditional bound is tight, not merely sound)",
                          all(r["aligned_arm"] == "map" and r["aligned_end_peak"] == r["per_call"] for r in tbl),
                          "off=%s" % [(r["model"], r["aligned_arm"], r["aligned_end_peak"], r["per_call"])
                                      for r in tbl if r["aligned_end_peak"] != r["per_call"]][:4]))
    results.append(Result("e29: copy arm peak == contract bounded, every model "
                          "(bounded is the max over the arms -- E26 Q1 untouched)",
                          all(r["malloc_arm"] == "copy" and r["malloc_end_peak"] == r["bounded"] for r in tbl),
                          "off=%s" % [(r["model"], r["malloc_arm"], r["malloc_end_peak"], r["bounded"])
                                      for r in tbl if r["malloc_end_peak"] != r["bounded"]][:4]))
    # E26f reported 172.30x as the widest deployment gap it saw; E29 says that
    # number is bounded/per_call for that model -- i.e. the gap WAS the arm.
    b3 = [r for r in tbl if r["model"] == "b3_deepae"]
    results.append(Result("e29: E26f's 172.30x deployment gap equals b3_deepae bounded/per_call",
                          bool(b3) and round(b3[0]["bounded"] / b3[0]["per_call"], 2) == 172.30,
                          "b3=%s" % (b3[0] if b3 else None)))

    # --- the deployment change, at source level (revert must fail here) -----
    root = os.path.dirname(HERE)
    for label, path, fn in (
            ("native_learner.c", os.path.join(root, "native", "native_learner.c"), "alloc_module_image"),
            ("ai_learner.c", os.path.join(root, "native", "cfs_app", "fsw", "src", "ai_learner.c"),
             "AI_LEARNER_AllocModuleImage")):
        src = open(path, encoding="utf-8", errors="replace").read()
        results.append(Result("e29: %s allocates the module image 64-byte aligned" % label,
                              "posix_memalign(&p, 64, n)" in src and (fn + "((size_t)") in src,
                              "expected posix_memalign(...,64,...) via %s() in %s" % (fn, label)))
        results.append(Result("e29: %s measures the arm actually taken after append" % label,
                              "hal_peak_after_append" in src and "iree_hal_allocator_query_statistics" in src,
                              "no post-append allocator query in %s" % label))
        # E29b/D54: this line originally pinned `hal_peak_after_append >
        # (long)CONTRACT_PER_CALL_BYTES` -- i.e. it pinned the defect. A copy arm
        # allocates exactly `constants` at append, so that comparison passed for
        # every model with constants < per_call (results/e29b_conditional_verify).
        # The verification is now "map arm (append peak == 0) or refuse".
        results.append(Result("e29: %s conditional tier verifies the precondition instead of assuming it" % label,
                              "MAP_PRECONDITION_FAILED" in src
                              and "hal_peak_after_append != 0" in src,
                              "conditional tier in %s does not refuse on a copy arm" % label))

    cm = open(os.path.join(root, "native", "cfs_app", "CMakeLists.txt"), encoding="utf-8").read()
    results.append(Result("e29: conditional admission is opt-in (default 0), so existing "
                          "deployments keep the unconditional decision",
                          "set(AI_LEARNER_ALLOW_CONDITIONAL_MAP 0 CACHE STRING" in cm,
                          "default for AI_LEARNER_ALLOW_CONDITIONAL_MAP is not 0"))

    # --- the four cFS cells, as recorded -----------------------------------
    cfs = summ["cfs_x86_64"]
    want = [
        ("unconditional_B", "ADMIT", False, 6208, True),
        ("percall_budget_no_optin", "NOT_ADMITTED", False, None, False),
        ("conditional_map_admit", "ADMIT_CONDITIONAL_MAP", False, 6208, True),
        ("conditional_map_precondition_failed", "ADMIT_CONDITIONAL_MAP", True, None, False),
    ]
    for tag, verdict, refused, peak, ran in want:
        c = cfs.get(tag, {})
        ok = (c.get("admission_verdict") == verdict and bool(c.get("refused")) == refused
              and c.get("end_hal_peak") == peak and (c.get("inferences", 0) > 0) == ran)
        results.append(Result("e29 cFS: %s -> %s%s" % (tag, verdict, " then refused" if refused else ""),
                              ok, "recorded=%s" % c))
    results.append(Result("e29 cFS: a model denied at a 6,208 B budget runs at that budget "
                          "under the verified precondition, at peak 6,208",
                          cfs.get("percall_budget_no_optin", {}).get("admission_verdict") == "NOT_ADMITTED"
                          and cfs.get("conditional_map_admit", {}).get("end_hal_peak") == 6208,
                          "deny=%s cond=%s" % (cfs.get("percall_budget_no_optin"),
                                               cfs.get("conditional_map_admit"))))
    return results


E28_DIR = os.path.join(os.path.dirname(HERE), "results", "e28_stack_failopen")


def e28_stack_failopen_cases():
    """D52 (E28): the cFS task-stack gate certified stack sufficiency and the app then died.

    `AI_LEARNER_Init` computes `stack_needed = AI_LEARNER_STACK_BASE_BYTES +
    CONTRACT_KERNEL_STACK_BYTES` and refuses below it. But the inference path put three
    CONTRACT-SIZED buffers on that same stack -- `feat[]` (4 B per input element), `out[]`
    (4 B per output element) and `outs[]` (16 B per output element) -- and the gate counted
    none of them. With an OPS-SAT-sized contract (150,528 input elements) `feat[]` alone
    needs 602,112 B against a 262,144 B base: the gate reported
    `kernel_stack_accounted: true`, admission ADMITted, binding MATCHed, and the cFS process
    took SIGSEGV in the first inference. That is a fail-open in the admission gate itself,
    which is this repository's central claim -- not a peripheral robustness issue.

    The fix moves the three buffers to `static`, exactly what `zeros[]` in the same file
    already is. Teaching the gate to add the I/O bytes instead would DENY every model that
    runs today, because the granted stack is exactly `base + kernel` (measured: 4/4 honest
    models refused). Moving them makes the gate's existing formula true.

    Both runs are preserved raw: same contract, same stack, same artifact, opposite outcome."""
    results = []
    summ_path = os.path.join(E28_DIR, "summary.json")
    src_path = os.path.join(os.path.dirname(HERE), "native", "cfs_app", "fsw", "src", "ai_learner.c")
    if not os.path.exists(summ_path):
        results.append(Result("e28-stack: reproduction preserved", False, "missing %s" % summ_path))
        return results
    d = load(summ_path)

    # the source-level cause: all three buffers must be off the automatic storage path
    src = open(src_path, encoding="utf-8", errors="replace").read()
    for name, pat in (("feat[]", "static float feat[CONTRACT_INPUT_ELEMS]"),
                      ("out[]", "static float out[CONTRACT_OUTPUT_ELEMS]"),
                      ("outs[]", "static char outs[CONTRACT_OUTPUT_ELEMS * 16 + 8]")):
        results.append(Result("e28-stack: %s is not on the task stack" % name, pat in src,
                              "expected `%s` in ai_learner.c" % pat))

    # the gate's formula is only correct BECAUSE those buffers left the stack; if a future
    # change puts them back, the formula silently starts over-promising again.
    results.append(Result("e28-stack: gate formula still counts base + kernel only "
                          "(correct once the buffers are static)",
                          "long stack_needed = (long)AI_LEARNER_STACK_BASE_BYTES + "
                          "(long)CONTRACT_KERNEL_STACK_BYTES;" in src,
                          "gate formula changed -- if I/O bytes were added, check the granted "
                          "stack formula in scripts/50 too or honest models get denied"))

    a, b = d["runs"]["after_fix"], d["runs"]["before_fix"]
    results.append(Result("e28-stack: before the fix the gate passed and the app never inferred",
                          b["stack"]["kernel_stack_accounted"] is True
                          and b["inference_report_count"] == 0
                          and b["harness_exit"] == 139,
                          "accounted=%s reports=%s exit=%s" % (b["stack"]["kernel_stack_accounted"],
                                                               b["inference_report_count"],
                                                               b["harness_exit"])))
    results.append(Result("e28-stack: after the fix the same contract and stack complete 10/10",
                          a["inference_report_count"] > 0
                          and a["completed_reports"] == ["10", "10"]
                          and a["clean_shutdown"] is True,
                          "reports=%s completed=%s clean=%s" % (a["inference_report_count"],
                                                                a["completed_reports"],
                                                                a["clean_shutdown"])))
    # the arithmetic that made it possible, pinned so the numbers cannot drift in the docs
    sa = d["stack_arithmetic"]
    uncounted = sum(sa["uncounted_stack_bytes"].values())
    results.append(Result("e28-stack: the uncounted buffers exceeded the granted stack",
                          uncounted > sa["es_stack_granted"],
                          "uncounted=%d granted=%d" % (uncounted, sa["es_stack_granted"])))
    results.append(Result("e28-stack: admission and binding both passed before the crash "
                          "(the gate is what failed, not the contract)",
                          b["admission"]["verdict"] == "ADMIT"
                          and b["binding"]["verdict"] == "MATCH",
                          "admission=%s binding=%s" % (b["admission"]["verdict"],
                                                       b["binding"]["verdict"])))
    return results


def e27_information_level_cases():
    """E27: the four-information-level comparison, pinned.

    Two of these checks exist to stop a convenient story from drifting into the docs.

    The first is that (b), the artifact-only baseline, MATCHES the repository pipeline
    exactly in the normal condition. That result undercuts the original R-3 framing
    ("these numbers need MLIR"), and the pre-fixed plan required reporting it anyway.
    If someone later hardens (b) -- which its docstring forbids -- this check is what
    notices, because a hardened (b) stops being the baseline that was compared.

    The second is `collection_clean`. The collector's first run counted a mistyped
    model filename as an `explicit_refusal`, i.e. as the analyzer honestly declining,
    in the very experiment that measures the difference between not-looking and
    looking-and-finding-nothing (D51). A run with any tool_error is not a result."""
    results = []
    if not os.path.exists(E27_SUMMARY):
        results.append(Result("e27: summary present", False, "missing %s" % E27_SUMMARY))
        return results
    d = load(E27_SUMMARY)

    results.append(Result("e27: collection is clean (no tool_error counted as a refusal)",
                          d.get("collection_clean") is True,
                          "tool_errors=%s" % [(c["model"], c["level"]) for c in d.get("tool_errors", [])]))

    normal = [c for c in d["cells"] if c["condition"] == "normal"]
    by = {}
    for c in normal:
        by.setdefault(c["model"], {})[c["level"]] = c
    agree = [m for m, lv in by.items()
             if lv.get("b", {}).get("bounded") is not None
             and lv["b"]["bounded"] == lv.get("c", {}).get("bounded")]
    results.append(Result("e27: (b) artifact-only equals (c) on every normal cell "
                          "(the result that refutes the original R-3 framing)",
                          len(agree) == len(by) and len(by) >= 8,
                          "%d/%d models agree" % (len(agree), len(by))))
    # the normal set must keep including real workloads and both ISAs, or the claim narrows
    results.append(Result("e27: normal set spans both ISAs and the two real MLPerf Tiny models",
                          any("@aarch64" in m for m in by)
                          and "b2_resnet" in by and "b3_deepae" in by,
                          "models=%s" % sorted(by)))
    over = [lv["a"]["over_reference"] for lv in by.values()
            if lv.get("a", {}).get("over_reference")]
    results.append(Result("e27: (a) source-level never under-estimates (all cells > 1.0x)",
                          bool(over) and min(over) > 1.0,
                          "range=%.2fx..%.2fx" % (min(over), max(over)) if over else "no cells"))

    drift = {c["level"]: c for c in d["cells"] if c["condition"] == "version_drift"}
    results.append(Result("e27: at compiler-version drift (b) under-estimates SILENTLY",
                          drift.get("b", {}).get("verdict") == "silent_wrong",
                          "b=%s bounded=%s" % (drift.get("b", {}).get("verdict"),
                                               drift.get("b", {}).get("bounded"))))
    results.append(Result("e27: ...while (c) still states a bound and records the failure",
                          drift.get("c", {}).get("verdict") == "value"
                          and drift.get("c", {}).get("bounded") == 786476,
                          "c=%s bounded=%s" % (drift.get("c", {}).get("verdict"),
                                               drift.get("c", {}).get("bounded"))))
    dyn = {c["level"]: c for c in d["cells"] if c["condition"] == "dynamic_shape"}
    results.append(Result("e27: every level refuses the dynamic-shape model "
                          "(not every perturbation breaks (b))",
                          all(dyn.get(l, {}).get("verdict") == "explicit_refusal"
                              for l in ("a", "b", "c")),
                          "verdicts=%s" % {l: dyn.get(l, {}).get("verdict") for l in ("a", "b", "c")}))
    results.append(Result("e27: silent under-estimates counted a=0 b=1 c=0",
                          d["headline_silent_wrong"].get("a") == 0
                          and d["headline_silent_wrong"].get("b") == 1
                          and d["headline_silent_wrong"].get("c") == 0,
                          "%s" % d["headline_silent_wrong"]))
    # (d) is recorded, never scored -- and it must show the spread that justifies that
    dcells = [c for c in d["cells"] if c["level"] == "d"]
    spreads = []
    for c in dcells:
        pk = [o["peak"] for o in c.get("observed_peaks", [])]
        if len(pk) > 1:
            spreads.append(max(pk) / min(pk))
    results.append(Result("e27: (d) is recorded per deployment and spans >100x somewhere "
                          "(why it cannot be the reference)",
                          bool(spreads) and max(spreads) > 100
                          and all(c["verdict"] == "not_scored" for c in dcells),
                          "max spread=%.1fx over %d multi-deployment models"
                          % (max(spreads), len(spreads)) if spreads else "no spreads"))
    return results


def ext_b3_deepae_cases():
    """E26f: the constant-dominated end of the E26-ext portfolio, pinned.

    B3 exists in the portfolio because its constants:per_call ratio (171.3 : 1) is the
    opposite extreme from B2 ResNet's (1.00 : 1). If the branch hypothesis or the budget
    boundary held only for balanced models, this is the model that would show it."""
    results = []
    summ_path = os.path.join(EXT_B3_DIR, "summary.json")
    if not os.path.exists(summ_path):
        results.append(Result("ext-b3-deepae: fixture present", False, "missing %s" % EXT_B3_DIR))
        return results
    summ = load(summ_path)
    ctr = summ["contract"]
    results.append(Result("ext-b3-deepae: bounded == per_call + constants",
                          ctr["bounded_bytes"] == ctr["static_per_call_bytes"]
                          + ctr["module_resident_constant_bytes"],
                          "%s = %s + %s" % (ctr["bounded_bytes"], ctr["static_per_call_bytes"],
                                            ctr["module_resident_constant_bytes"])))
    results.append(Result("ext-b3-deepae: this model really is constant-dominated (>100:1)",
                          ctr["constants_to_per_call_ratio"] > 100,
                          "ratio=%s" % ctr["constants_to_per_call_ratio"]))
    results.append(Result("ext-b3-deepae: every measured cell is within the bound (Q1)",
                          summ["q1_peak_within_bounded_all"] is True,
                          "peaks=%s" % [c.get("hal_device_bytes_peak") for c in summ["cells"]]))
    results.append(Result("ext-b3-deepae: branch hypothesis not refuted (Q2)",
                          summ["q2_hypothesis_refuted"] == [],
                          "refuted=%s" % summ["q2_hypothesis_refuted"]))
    results.append(Result("ext-b3-deepae: the SAME vmfb takes both branches in different deployments",
                          sorted(summ["q2_branches"]) == ["allocated", "mapped"],
                          "branches=%s" % summ["q2_branches"]))
    # the headline: the widest deployment spread this repository has measured
    lo, hi = summ["q2_tightness_range"]
    results.append(Result("ext-b3-deepae: tightness spread exceeds E26-core's 45.50x maximum",
                          lo == 1.0 and hi > 45.5, "range=%s..%s" % (lo, hi)))
    results.append(Result("ext-b3-deepae: DENY at bound-1, ADMIT at bound and above (Q3)",
                          summ["q3_deny_at_bound_minus_1"] is True
                          and summ["q3_admit_at_bound_and_above"] is True,
                          "deny=%s admit=%s" % (summ["q3_deny_at_bound_minus_1"],
                                                summ["q3_admit_at_bound_and_above"])))
    return results


def ext_b2_resnet_cases():
    """E26e: the E26-ext measurement on a real MLPerf Tiny CNN, pinned.

    Two things are worth a regression test here and neither is a defect gate.

    (1) The contract QUANTITIES are stable across iree-compile runs even though the
        ARTIFACT BYTES are not (§4 of the evidence: three threaded compiles of the same
        file gave three different vmfb digests). If a later change silently altered what
        the extractor reports for this model, the stored pair would stop agreeing.
    (2) The branch hypothesis holds on this workload, and the same artifact lands in
        DIFFERENT branches in different runtime deployments -- which is E26's central
        claim, measured here outside the synthetic model set."""
    results = []
    summ_path = os.path.join(EXT_B2_DIR, "summary.json")
    ctr_path = os.path.join(EXT_B2_DIR, "b2_resnet.contract.json")
    fixture_ctr = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                               "mlperf_tiny_resnet_fixture", "resnet.contract.json")
    for p_ in (summ_path, ctr_path, fixture_ctr):
        if not os.path.exists(p_):
            results.append(Result("ext-b2-resnet: fixture present", False, "missing %s" % p_))
            return results
    summ, ctr, fix = load(summ_path), load(ctr_path), load(fixture_ctr)

    # (1) same numbers, different artifact -- both halves asserted
    keys = ("bounded_bytes", "static_per_call_bytes", "module_resident_constant_bytes",
            "static_transient_bytes", "static_io_bytes", "dispatches")
    same = {k: (ctr["resources"][k], fix["resources"][k]) for k in keys}
    results.append(Result("ext-b2-resnet: contract quantities match the fixture's other compile",
                          all(a == b for a, b in same.values()),
                          "; ".join("%s %s!=%s" % (k, a, b) for k, (a, b) in same.items() if a != b)))
    results.append(Result("ext-b2-resnet: ...while the artifact identity does NOT (compile is not "
                          "byte-reproducible)",
                          ctr["artifact"]["sha256"] != fix["artifact"]["sha256"],
                          "%s vs %s" % (ctr["artifact"]["sha256"][:16],
                                        fix["artifact"]["sha256"][:16])))

    # (2) soundness, branch hypothesis, and the admission boundary
    results.append(Result("ext-b2-resnet: every measured cell is within the bound (Q1)",
                          summ["q1_peak_within_bounded_all"] is True,
                          "cells=%s" % [c.get("hal_device_bytes_peak") for c in summ["cells"]]))
    results.append(Result("ext-b2-resnet: branch hypothesis not refuted on a real CNN (Q2)",
                          summ["q2_hypothesis_refuted"] == [],
                          "refuted=%s" % summ["q2_hypothesis_refuted"]))
    results.append(Result("ext-b2-resnet: the SAME vmfb takes both branches in different deployments",
                          sorted(summ["q2_branches"]) == ["allocated", "mapped"],
                          "branches=%s" % summ["q2_branches"]))
    per, const = ctr["resources"]["static_per_call_bytes"], ctr["resources"]["module_resident_constant_bytes"]
    peaks = sorted({c["hal_device_bytes_peak"] for c in summ["cells"] if c["hal_device_bytes_peak"]})
    results.append(Result("ext-b2-resnet: the two peaks differ by exactly the module constants",
                          peaks == [per, per + const],
                          "peaks=%s per_call=%d constants=%d" % (peaks, per, const)))
    results.append(Result("ext-b2-resnet: DENY at bound-1, ADMIT at bound and above (Q3)",
                          summ["q3_deny_at_bound_minus_1"] is True
                          and summ["q3_admit_at_bound_and_above"] is True,
                          "deny=%s admit=%s" % (summ["q3_deny_at_bound_minus_1"],
                                                summ["q3_admit_at_bound_and_above"])))
    # D50: the pip cell's peak must be the released-buffer figure, not the retained one
    pip = [c for c in summ["cells"] if c["runner"] == "pip_runtime"]
    results.append(Result("ext-b2-resnet: pip cell peak is the released-buffer figure (D50)",
                          bool(pip) and pip[0]["hal_device_bytes_peak"] == per,
                          "peak=%s per_call=%d" % (pip[0]["hal_device_bytes_peak"] if pip else None, per)))
    return results


def a5b_canonical_guest_cases(tmp):
    """E26d: the A5b_canonical guest run that the pre-fixed E26 plan (§5 step 3) named and
    the E26 evidence originally neither reported nor disclaimed.

    A5b is the corruption the artifact-hash gate CANNOT catch: the contract is regenerated
    against the corrupted file's real hash, so admission ADMITs and binding MATCHes, and the
    refusal has to come from IREE's own FlatBuffer verifier at load time. What makes the
    claim reproducible from repository contents is that the corruption is DETERMINISTIC --
    so this test does not store the corrupted 732,760 B artifact, it REGENERATES it from the
    in-tree source vmfb and checks the digest the guest actually loaded.

    (The repository has corrected an A5b claim once before, in v0.9.1, for asserting a run
    that never happened. That is why a skipped plan step gets a test and not just a note.)"""
    results = []
    log_path = os.path.join(A5B_CANONICAL_DIR, "canonical_A5b.log")
    rec_path = os.path.join(A5B_CANONICAL_DIR, "canonical_A5b.json")
    src_vmfb = os.path.join(os.path.dirname(HERE), "results", "e25_equivalence", "aarch64",
                            "model_canonical.aarch64.vmfb")
    if not (os.path.exists(log_path) and os.path.exists(rec_path)):
        results.append(Result("a5b-canonical: guest fixture present", False,
                              "missing %s" % A5B_CANONICAL_DIR))
        return results
    rec = load(rec_path)

    # -- the raw guest log says what the record claims it says --------------------------
    import e14_cfs_scenarios as scen                          # noqa: PLC0415 - local module
    with open(log_path) as f:
        log = f.read()
    parsed = scen.parse_log(log)
    mism = scen.check_expect(parsed, {"admission": "ADMIT", "binding": "MATCH",
                                      "runtime_load_failed": True, "cleanup_calls": 1})
    results.append(Result("a5b-canonical: ADMIT -> MATCH -> runtime_load_failed -> 1 cleanup",
                          mism == [], "mismatches=%s" % mism))
    rlf = (parsed.get("runtime_load_failed") or [{}])[-1]
    results.append(Result("a5b-canonical: rejected by IREE's FlatBuffer verifier, not by a gate",
                          rlf.get("step") == "append_bytecode_module"
                          and "FlatBuffer length prefix out of bounds" in str(rlf.get("status")),
                          "step=%s status=%s" % (rlf.get("step"), str(rlf.get("status"))[:90])))
    # the app gave up, cFS did not: more apps load after AI_LEARNER exits, and nothing aborts
    tail = log.split("CFE_ES_ExitApp")[-1]
    results.append(Result("a5b-canonical: cFS keeps running after the app stands down",
                          "CFE_ES_ParseFileEntry" in tail,
                          "%d further app loads after AI_LEARNER exit"
                          % tail.count("CFE_ES_ParseFileEntry")))
    # `cfe_assert.so` is a cFS library FILENAME, not an assertion firing -- match the shapes
    # a real crash would print instead.
    crash = [w for w in ("Segmentation fault", "core dumped", "Aborted") if w in log]
    results.append(Result("a5b-canonical: no crash or abort in the guest log", not crash,
                          "found %s" % crash))
    results.append(Result("a5b-canonical: e25_mode absent by construction (load fails first)",
                          parsed.get("e25_mode") is None,
                          "e25_mode=%s" % (parsed.get("e25_mode"),)))

    # -- the corruption regenerates to exactly the artifact the guest loaded -------------
    if not os.path.exists(src_vmfb):
        results.append(Result("a5b-canonical: corruption regenerates deterministically", False,
                              "missing source vmfb %s" % src_vmfb))
        return results
    out_vmfb = os.path.join(tmp, "a5b_regen.vmfb")
    rc, _, err = run([PY, os.path.join(HERE, "corrupt_vmfb.py"),
                      "--method", "flatbuffer_root_uoffset",
                      "--in", src_vmfb, "--out", out_vmfb])
    if rc != 0:
        results.append(Result("a5b-canonical: corruption regenerates deterministically", False,
                              "corrupt_vmfb rc=%d: %s" % (rc, err.strip()[-200:])))
        return results
    with open(out_vmfb, "rb") as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    results.append(Result("a5b-canonical: corruption regenerates deterministically",
                          digest == rec["corrupted_vmfb_sha256"],
                          "regenerated %s vs guest-loaded %s"
                          % (digest[:16], str(rec["corrupted_vmfb_sha256"])[:16])))
    results.append(Result("a5b-canonical: corrupted artifact is byte-for-byte the same SIZE",
                          os.path.getsize(out_vmfb) == os.path.getsize(src_vmfb),
                          "%d vs %d" % (os.path.getsize(out_vmfb), os.path.getsize(src_vmfb))))
    # the hash gate provably cannot catch this one: the deployed contract signs the CORRUPTED file
    contract = load(os.path.join(A5B_CANONICAL_DIR, "model_canonical.aarch64.a5b.contract.json"))
    results.append(Result("a5b-canonical: contract signs the corrupted file (hash gate cannot fire)",
                          contract["artifact"]["sha256"] == digest,
                          "contract=%s file=%s" % (contract["artifact"]["sha256"][:16], digest[:16])))
    return results


def multiout_subview_cases(tmp):
    """D49 (E26c): `stream.resource.subview` must be recognized as a non-allocating
    VIEW whose containment claim is CHECKED -- not refused outright, and not trusted.

    IREE packs a multi-output model's results into ONE output slab and then emits one
    subview per result. Neither allocation extractor had `stream.resource.subview` in
    its whitelist, so D13's fail-closed rule pushed it into `unresolved` and every such
    model came out UNKNOWN_BOUND -- even though the single real allocation had already
    been sized soundly and conservatively (128 B slab for 32 + 16 B of results). That is
    a type (B) defect, an over-rejection, and it excluded essentially every multi-output
    model from the contract pipeline.

    The fix whitelists the op in both extractors and gives it an invariant the other two
    non-allocating entries (tensor.export, resource.dealloca) do not have: a subview is
    accepted only when its three index operands are resolvable constants AND
    offset + result_size <= source_size. Both halves are tested here -- the honest model
    must pass, and both ways of lying about the window must still refuse.

    Fixture: results/e26c_multiout/, from ONE iree-compile invocation of
    harness/gen_model_multiout.py output (D43's rule -- the model that justifies the fix
    lives in the tree, generated by committed code)."""
    import static_mem_bound as smb                            # noqa: PLC0415 - local module
    results = []

    # Whitelist membership, as a unit. Stated separately from behaviour so that reverting
    # the fix names the cause rather than only its symptom.
    results.append(Result("multiout-subview: regex parser whitelists stream.resource.subview",
                          "resource.subview" in getattr(smb, "_KNOWN_ENTRY_OPS", set()),
                          "_KNOWN_ENTRY_OPS = %s" % sorted(getattr(smb, "_KNOWN_ENTRY_OPS", []))))

    ir_path = os.path.join(MULTIOUT_DIR, "multiout.layout_ir.txt")
    contract_path = os.path.join(MULTIOUT_DIR, "multiout.contract.json")
    if not (os.path.exists(ir_path) and os.path.exists(contract_path)):
        results.append(Result("multiout-subview: fixture present", False,
                              "missing %s" % MULTIOUT_DIR))
        return results
    base = open(ir_path).read()
    if base.count(MULTIOUT_SUBVIEW_LINE) != 1:
        results.append(Result("multiout-subview: fixture carries the expected subview line", False,
                              "anchor found %d times" % base.count(MULTIOUT_SUBVIEW_LINE)))
        return results

    # -- the honest model: a bound, not a refusal (this is what used to fail) ----------
    got = smb.parse_alloc_ir(base)
    expect = {"inputs": [64], "outputs": [128], "transient_slabs": [], "constants": [512]}
    for key, want in expect.items():
        results.append(Result("multiout-subview: regex parser %s == %s" % (key, want),
                              got.get(key) == want, "got %s" % got.get(key)))
    results.append(Result("multiout-subview: regex parser states a bound (unresolved empty)",
                          got["unresolved"] == [], "unresolved=%s" % got["unresolved"]))

    # -- the two ways of lying about the window: both must still refuse ---------------
    variants = [
        ("window leaves its source (offset 128 + 16 > 128)",
         base.replace(MULTIOUT_SUBVIEW_LINE,
                      MULTIOUT_SUBVIEW_LINE.replace("%result[%c64_3]", "%result[%c128_4]")),
         "subview_out_of_range"),
        ("result size defined by a non-constant op",
         base.replace(MULTIOUT_SUBVIEW_LINE,
                      "%dyn_sz = arith.muli %c16, %c1 : index\n    "
                      + MULTIOUT_SUBVIEW_LINE.replace(
                          "-> !stream.resource<external>{%c16}",
                          "-> !stream.resource<external>{%dyn_sz}")),
         "subview_size"),
    ]
    for name, text, tag in variants:
        r = smb.parse_alloc_ir(text)
        hit = any(str(u).startswith(tag) for u in r["unresolved"])
        results.append(Result("multiout-subview: regex parser refuses -- %s" % name, hit,
                              "unresolved=%s" % r["unresolved"]))

    # -- the structural twin must reach the same verdicts, or the mandatory
    #    cross-check in make_contract.py would hard-fail on an honest model -----------
    # structural_available() answers with a SUBPROCESS probe, so it can say "yes" while
    # the in-process import fails (an import blocker, a partially installed package).
    # D24/D32's rule applies to this file too: a missing prerequisite SKIPs cleanly, it
    # never takes the suite down -- and reverting a fix to reproduce a defect is exactly
    # when odd environment shapes show up.
    # The guard has to wrap the CALL, not the import: mlir_alloc_walk imports fine with
    # the bindings absent (it sets `ir = None`) and raises from _require_bindings() when
    # actually used. And structural_available() answers with a SUBPROCESS probe, so it
    # can report "yes" for an interpreter whose own import is blocked.
    structural = []
    try:
        if not structural_available():
            raise RuntimeError("iree.compiler.ir not importable")
        import mlir_alloc_walk as maw                         # noqa: PLC0415 - optional dep
        structural.append(Result("multiout-subview: structural extractor whitelists the op",
                                 "stream.resource.subview" in getattr(maw, "KNOWN_ENTRY_OPS", set()),
                                 "KNOWN_ENTRY_OPS = %s" % sorted(getattr(maw, "KNOWN_ENTRY_OPS", []))))
        st = maw.parse_alloc_ir_structural(base)
        structural.append(Result("multiout-subview: structural extractor states a bound",
                                 st["unresolved"] == [] and st["outputs"] == [128]
                                 and st["inputs"] == [64],
                                 "outputs=%s inputs=%s unresolved=%s"
                                 % (st["outputs"], st["inputs"], st["unresolved"])))
        for name, text, tag in variants:
            sr = maw.parse_alloc_ir_structural(text)
            hit = any(str(u).startswith(tag) for u in sr["unresolved"])
            structural.append(Result("multiout-subview: structural extractor refuses -- %s" % name,
                                     hit, "unresolved=%s" % sr["unresolved"]))
    except Exception as e:                                    # noqa: BLE001 - D24/D32 rule
        # A missing prerequisite SKIPs cleanly; it never takes the suite down. Reverting
        # a fix to reproduce a defect is exactly when odd environment shapes show up.
        structural = [Result("multiout-subview: structural extractor agrees", True,
                             "structural extractor unusable here (%s)" % str(e)[:90],
                             skip=True)]
    results += structural

    # -- the stored contract must regenerate byte-for-byte from the stored inputs -----
    stored = load(contract_path)
    res = stored["resources"]
    results.append(Result("multiout-subview: stored contract bounded == per_call + constants",
                          res["bounded_bytes"] == 704
                          and res["static_per_call_bytes"] == 192
                          and res["module_resident_constant_bytes"] == 512,
                          "bounded=%s per_call=%s const=%s" % (res["bounded_bytes"],
                                                               res["static_per_call_bytes"],
                                                               res["module_resident_constant_bytes"])))
    peak_path = os.path.join(MULTIOUT_DIR, "multiout.pip_runtime.json")
    if os.path.exists(peak_path):
        pk = load(peak_path)
        results.append(Result("multiout-subview: measured HAL peak within the bound",
                              pk["hal_device_bytes_peak"] <= res["bounded_bytes"]
                              and pk["n_outputs"] == 2,
                              "peak=%s bounded=%s outputs=%s" % (pk["hal_device_bytes_peak"],
                                                                 res["bounded_bytes"],
                                                                 pk["n_outputs"])))
    else:
        results.append(Result("multiout-subview: measured HAL peak within the bound", False,
                              "missing %s" % peak_path))

    # The stored contract records `constants_confirmation_state: confirmed`, produced by
    # iree-dump-module reading the artifact's .rodata segments. Without that binary the
    # regenerated contract would legitimately carry a different state, so the comparison
    # is SKIPped rather than reported as a regression it is not (D25's lesson about a
    # missing tool masquerading as a finding).
    if not (structural_available() and iree_tools_available()):
        results.append(Result("multiout-subview: contract regenerates unchanged", True,
                              "needs iree.compiler.ir and iree-dump-module", skip=True))
        return results
    out = os.path.join(tmp, "multiout.regen.json")
    rc, _, err = run([PY, MAKE_CONTRACT,
                      "--mlir", os.path.join(MULTIOUT_DIR, "multiout.mlir"),
                      "--vmfb", os.path.join(MULTIOUT_DIR, "multiout.vmfb"),
                      "--layout-ir", ir_path,
                      "--dump-dir", os.path.join(MULTIOUT_DIR, "dump"),
                      "--triple", "x86_64-unknown-linux-gnu", "--cpu", "generic",
                      "--model-name", "multiout",
                      "--elf-analysis", os.path.join(MULTIOUT_DIR, "multiout.elf.json")]
                     + with_structural_override() + ["--out", out])
    if rc != 0:
        results.append(Result("multiout-subview: contract regenerates unchanged", False,
                              "make_contract rc=%d: %s" % (rc, err.strip()[-300:])))
        return results
    # Same comparison the 14/14 regeneration uses, plus provenance.dump_dir: this test
    # passes the fixture path the way the suite was invoked, so that one leaf records
    # where the check ran, not what the compiler produced.
    old_f = dict(flatten(stored))
    new_f = dict(flatten(load(out)))
    ignore = IGNORE_PROVENANCE_KEYS | {"dump_dir"}
    diffs = [(k, old_f.get(k), new_f.get(k)) for k in set(old_f) | set(new_f)
             if k[-1] not in ignore and not (set(k) & IGNORE_PROVENANCE_SUBTREES)
             and old_f.get(k) != new_f.get(k)]
    results.append(Result("multiout-subview: contract regenerates unchanged", not diffs,
                          "" if not diffs else "%d field(s) differ, e.g. %s" % (len(diffs), diffs[:3])))
    return results


def rodata_label_cases():
    """D48 (E26b): an embedded .rodata segment must be classified as constant DATA or
    as a metadata STRING by the label's length, not by the mere presence of backticks.

    iree-dump-module renders an embedded segment's bytes between backticks whenever they
    look printable, so a genuine constant block whose first byte is NUL prints as an EMPTY
    backtick pair. The old test (`"`" in rest`) dropped it from the observed constant
    total; the contract's own figure then contradicted the observation and N1/D28's gate
    refused the model unless --allow-unconfirmed-constants was passed -- which marks the
    contract `overridden`, which E24b/D39's header gate refuses in turn. Net effect: an
    honest f32 model could not produce a deployable header. Type (B), over-rejection.

    The fixture is a real vmfb exhibiting it (D43's rule: a fix justified by "a real model
    does X" needs that model in the tree)."""
    import static_mem_bound as smb                            # noqa: PLC0415 - local module
    results = []
    # D24/D32's lesson applied to this file itself: a missing prerequisite must FAIL
    # cleanly, never take the whole suite down with an AttributeError. Reverting the fix
    # to reproduce the defect is exactly when that happens.
    is_string_label = getattr(smb, "_is_string_label", None)
    if is_string_label is None:
        return [Result("rodata-label: static_mem_bound exposes the label discriminator", False,
                       "static_mem_bound._is_string_label is missing (pre-D48 code?)")]

    # unit: the discriminator itself, no external tool needed
    units = [
        ("real string label (len == size)", "` `hal.device.id`".replace("` ", " "), 13, True),
        ("empty label on a 2816 B data segment", " ``", 2816, False),
        ("no label at all", " ", 704, False),
        ("label shorter than the segment", " `ab`", 64, False),
        ("label longer than the segment", " `abcdef`", 3, False),
    ]
    for name, rest, n, expect in units:
        got = is_string_label(rest, n)
        results.append(Result("rodata-label: %s -> %s" % (name, "string" if expect else "data"),
                              got is expect, "got %r" % got))

    fx = os.path.join(os.path.dirname(HERE), "results", "e26_boundary_utility",
                      "empty_label_rodata_fixture", "empty_label_rodata.vmfb")
    if not os.path.exists(fx):
        results.append(Result("rodata-label: empty-label fixture present", False, "missing %s" % fx))
        return results
    if not iree_tools_available():
        results.append(Result("rodata-label: real vmfb with an empty-label data segment is counted",
                              True, "iree-dump-module not installed", skip=True))
        return results
    ext, data = smb.artifact_rodata_segments(fx)
    results.append(Result("rodata-label: real vmfb -- the 2816 B empty-label segment counts as data",
                          bool(data is not None and 2816 in data and sum(data) == 7856),
                          "external=%s data=%s" % (ext, data)))
    # and the metadata strings in the SAME dump must still be excluded
    results.append(Result("rodata-label: metadata strings in the same dump stay excluded",
                          bool(data is not None and 13 not in data and 6 not in data and 21 not in data),
                          "data=%s" % (data,)))
    # stored models must be unaffected (they had no empty-label segments)
    canon = os.path.join(os.path.dirname(HERE), "results", "e25_equivalence", "build",
                         "model_canonical.vmfb")
    if os.path.exists(canon):
        e2, d2 = smb.artifact_rodata_segments(canon)
        results.append(Result("rodata-label: E25 canonical unchanged (720896 + 5128, no extras)",
                              bool(d2 == [720896, 5128]), "data=%s" % (d2,)))
    return results



E38_DIR = "results/e38_optin_record"


# ----------------------------------------------------------------------------
# E40: the analysis domain and the accounting rules, published machine-readably
# ----------------------------------------------------------------------------
def e40_analysis_domain_cases(tmp):
    """The roadmap (SS5.2/SS5.3) asked for an `analysis_domain` block in the contract.

    These cases pin the two things that made the literal prescription unsafe:
      * the premises must be DERIVED, not retyped -- until E40 the first assumption
        was the literal string "static shapes", so contract.dynamic.* declared it
        while bound_method was NONE. Inert while nothing read it; a machine-readable
        false assertion the moment it is published;
      * the block must not become a second source of truth (D65), so every derived
        value is re-checked against the field it came from and a disagreement is a
        REFUSAL, not a note.
    """
    results = []
    repo = os.path.dirname(HERE)
    import make_contract as mc

    base = load(os.path.join(repo, "results", "e14_aarch64_qemu", "x86_64",
                             "contracts", "contract.conv2d.x86_64.json"))

    def with_domain(**over):
        c = json.loads(json.dumps(base))
        r = c["resources"]
        d = {"static_shapes": r["bound_method"] != "NONE",
             "driver": c["target"]["driver"],
             "entry": c["model"]["entry"],
             "supported_resource_ops": list(smb.SUPPORTED_RESOURCE_OPS),
             "unknown_operation_policy": "UNKNOWN_BOUND",
             "constant_policy": {"map_arm_bound_bytes": r["static_per_call_bytes"],
                                 "copy_arm_bound_bytes": r["bounded_bytes"]}}
        d.update(over)
        c["analysis_domain"] = {"derived": d, "required_premises": {"max_in_flight_calls": 1}}
        return c

    results.append(Result("e40: a consistent analysis_domain reports no drift (over-rejection guard)",
                          mc.analysis_domain_drift(with_domain()) == [],
                          "%s" % mc.analysis_domain_drift(with_domain())))
    for label, over in (("static_shapes", {"static_shapes": False}),
                        ("driver", {"driver": "local-task"}),
                        ("entry", {"entry": "not_infer"}),
                        ("supported_resource_ops", {"supported_resource_ops": ["stream.resource.alloca"]}),
                        ("constant_policy arms", {"constant_policy": {"map_arm_bound_bytes": 1,
                                                                      "copy_arm_bound_bytes": 2}})):
        drift = mc.analysis_domain_drift(with_domain(**over))
        results.append(Result("e40: drift in %s is reported (D65 guard)" % label,
                              bool(drift) and label.split()[0] in " ".join(drift),
                              "drift=%s" % drift))
    # the prose list and the flag must not drift apart again -- that split IS the state
    # E40 found (bound_assumptions[0] == "static shapes" on a contract stating no bound)
    _c = with_domain()
    _c["resources"]["bound_assumptions"] = ["NON-static shapes: ..."] + _c["resources"]["bound_assumptions"][1:]
    _d = mc.analysis_domain_drift(_c)
    results.append(Result("e40: prose assumptions[0] contradicting the static_shapes flag is drift",
                          any("bound_assumptions[0]" in x for x in _d), "drift=%s" % _d))
    _c2 = with_domain()
    _c2["validity"]["assumptions"] = ["static shapes (reworded)"] + _c2["validity"]["assumptions"][1:]
    _d2 = mc.analysis_domain_drift(_c2)
    results.append(Result("e40: validity.assumptions[0] diverging from resources.bound_assumptions[0] is drift",
                          any("validity.assumptions[0]" in x for x in _d2), "drift=%s" % _d2))
    results.append(Result("e40: a missing analysis_domain block is itself drift (absence is not agreement)",
                          mc.analysis_domain_drift(base) == ["analysis_domain.derived is missing"],
                          "%s" % mc.analysis_domain_drift(base)))

    # the source no longer carries the unconditional literal
    src = open(MAKE_CONTRACT).read()
    results.append(Result("e40: make_contract no longer hardcodes \"static shapes\" as assumptions[0]",
                          'assumptions = ["static shapes"' not in src
                          and 'if all_static else' in src.split("assumptions = [")[1][:400],
                          "literal still present" if 'assumptions = ["static shapes"' in src else ""))

    # no contract anywhere may claim static shapes while stating no bound
    liars = []
    for f in sorted(glob.glob(os.path.join(repo, "results", "**", "*.json"), recursive=True)
                    + glob.glob(os.path.join(repo, "contracts", "contract.*.json"))
                    + glob.glob(os.path.join(repo, "plugins", "**", "contract.json"), recursive=True)):
        try:
            c = load(f)
        except Exception:
            continue
        if not isinstance(c, dict) or "resources" not in c:
            continue
        asm = (c["resources"] or {}).get("bound_assumptions") or []
        if asm and asm[0] == "static shapes" and (c["resources"] or {}).get("bound_method") == "NONE":
            liars.append(os.path.relpath(f, repo))
    results.append(Result("e40: no stored contract declares \"static shapes\" while bound_method=NONE",
                          not liars, "%s" % liars[:3]))

    # the two extractors' whitelists must still agree (E19 keeps them independent
    # on purpose; the contract publishes only one of them)
    try:
        import mlir_alloc_walk as maw
        walk_ops = set(maw.KNOWN_ENTRY_OPS)
    except Exception as e:
        walk_ops = None
        results.append(Result("e40: mlir_alloc_walk whitelist readable", False, str(e)[:160]))
    if walk_ops is not None:
        results.append(Result("e40: published supported_resource_ops == both extractors' whitelists",
                              set(smb.SUPPORTED_RESOURCE_OPS) == walk_ops,
                              "published=%s walker=%s" % (sorted(smb.SUPPORTED_RESOURCE_OPS), sorted(walk_ops))))

    # the corrected archived contracts
    for tgt in ("x86_64", "aarch64"):
        c = load(os.path.join(repo, "results", "e14_aarch64_qemu", tgt, "contracts",
                              "contract.dynamic.%s.json" % tgt))
        a0 = (c["resources"]["bound_assumptions"] or [""])[0]
        v0 = (c["validity"]["assumptions"] or [""])[0]
        results.append(Result("e40: archived %s/dynamic no longer declares static shapes (correction)" % tgt,
                              a0.startswith("NON-static shapes") and v0 == a0,
                              "resources=%r validity=%r" % (a0[:40], v0[:40])))
    return results


# ----------------------------------------------------------------------------
# E41: the analysis domain's five conditions -- which are gates, which are not
# ----------------------------------------------------------------------------
def e41_analysis_domain_cases(tmp):
    """Pre-fixed in docs/plans/E40_E41_analysis_domain.md SS3 BEFORE any of it was measured.

    Two of the five conditions are deliberately NOT gates, and these cases pin the
    reason as much as the behaviour -- a later reader must not "finish the job" by
    turning them into refusals:
      * 2+ in-flight calls: no shipped deployment can reach it, and building the
        hazard into a flight app to assert it is absent would be the regression;
      * output held past the next call: enforcing it literally rejects an honest run
        at 50% of its budget (measured).
    """
    results = []
    repo = os.path.dirname(HERE)
    root = os.path.join(repo, "results", "e41_analysis_domain")
    sys.path.insert(0, os.path.join(repo, "plugins", "compiled_learner"))
    import artifact_binding as ab

    # ---- the premise measurement (condition 3) -------------------------------
    probe_path = os.path.join(root, "probe.json")
    if not os.path.isfile(probe_path):
        results.append(Result("e41: probe.json preserved", False, "missing %s" % probe_path))
        return results
    probe = load(probe_path)
    cells = probe["cells"]
    singles = [c for c in cells if c["threads"] == 1]
    results.append(Result("e41: one in-flight call peaks at exactly per_call (every model, both hold modes)",
                          bool(singles) and all(c["peak"] == c["per_call_bytes"] for c in singles),
                          "%s" % [(c["model"], c["hold_outputs"], c["peak"], c["per_call_bytes"])
                                  for c in singles if c["peak"] != c["per_call_bytes"]]))
    over = probe["cells_exceeding_bounded"]
    smart2 = [c for c in over if c["model"] == "smartcam" and c["threads"] == 2]
    results.append(Result("e41: the single-in-flight premise is load-bearing (SmartCam exceeds bounded at N=2)",
                          bool(smart2) and smart2[0]["peak"] == 18764184
                          and smart2[0]["bounded_bytes"] == 18222796,
                          "%s" % smart2))
    # concurrency, not retention, is the mechanism (D50 separated)
    by_key = {(c["model"], c["threads"], c["hold_outputs"]): c["peak"] for c in cells}
    same = [(m, n) for (m, n, h) in by_key if h is False
            and (m, n, True) in by_key and by_key[(m, n, False)] != by_key[(m, n, True)]
            and n == 1]
    results.append(Result("e41: at one in-flight call, holding the output does not change the peak (D50 separated)",
                          not same, "differing: %s" % same))
    nondet = [c for c in cells if not c["deterministic"]]
    results.append(Result("e41: non-determinism is recorded, not averaged away (N x per_call is an upper bound)",
                          all(len(set(c["peaks_observed"])) > 1 for c in nondet)
                          and all(len(set(c["peaks_observed"])) == 1 for c in cells if c["deterministic"]),
                          "%d non-deterministic cell(s)" % len(nondet)))

    # ---- condition 3 is unreachable in every shipped deployment --------------
    for rel in ("native/native_learner.c", "native/cfs_app/fsw/src/ai_learner.c"):
        src = open(os.path.join(repo, rel)).read()
        hits = [k for k in ("pthread_create", "CFE_ES_CreateChildTask", "OS_TaskCreate") if k in src]
        results.append(Result("e41: %s creates no thread or child task (condition 3 unreachable)"
                              % os.path.basename(rel), not hits, "%s" % hits))

    # ---- condition 4 is not a gate, and the number says why ------------------
    b2 = load(os.path.join(repo, "results", "e26_boundary_utility", "x86_64",
                           "ext_b2_resnet", "b2_resnet.contract.json"))["resources"]
    results.append(Result("e41: enforcing condition 4 literally would reject an honest run at 50% of budget",
                          309576 <= b2["bounded_bytes"] and 309576 > b2["static_per_call_bytes"],
                          "D50 peak 309576 vs bounded %d / per_call %d"
                          % (b2["bounded_bytes"], b2["static_per_call_bytes"])))

    # ---- condition 5: the header generator ----------------------------------
    base = load(os.path.join(repo, "results", "e26_boundary_utility", "x86_64",
                             "ext_b3_deepae", "b3_deepae.contract.json"))
    for label, mutate in (
            ("no driver declared anywhere", lambda c: (c["validity"].pop("driver", None),
                                                       c["target"].pop("driver", None))),
            ("validity.driver != target.driver", lambda c: c["validity"].__setitem__("driver", "local-task"))):
        c = json.loads(json.dumps(base))
        mutate(c)
        src = os.path.join(tmp, "e41_drv.json")
        hdr = os.path.join(tmp, "e41_drv.h")
        if os.path.exists(hdr):
            os.remove(hdr)
        with open(src, "w") as f:
            json.dump(c, f)
        rc, _, err = run([PY, GEN_HEADER, src, hdr])
        results.append(Result("e41: header generator refuses -- %s" % label,
                              rc != 0 and not os.path.exists(hdr),
                              "rc=%d wrote_header=%s err=%s" % (rc, os.path.exists(hdr), err.strip()[:140])))

    # ---- condition 5: the OnAIR plugin's pure check --------------------------
    legacy = load(os.path.join(repo, "plugins", "compiled_learner", "runtime", "contract.json"))
    smart = load(os.path.join(repo, "results", "p1_smartcam_feasibility", "build",
                              "smartcam.contract.json"))
    def drv(contract, deployment_driver):
        try:
            return ab.check_declared_driver(contract, deployment_driver)
        except ab.DeclaredDriverError as e:
            return e
    results.append(Result("e41: the legacy fixture (validity=null, target.driver set) is NOT rejected "
                          "(over-rejection guard, D31 shape)",
                          drv(legacy, "local-sync") == "local-sync", "%s" % drv(legacy, "local-sync")))
    results.append(Result("e41: an undeclared deployment driver is refused",
                          isinstance(drv(smart, "local-task"), ab.DeclaredDriverError),
                          "%s" % drv(smart, "local-task")))
    results.append(Result("e41: a contract declaring no driver is refused (absence is not agreement, D29)",
                          isinstance(drv({"validity": None, "target": {}}, "local-sync"),
                                     ab.DeclaredDriverError),
                          "%s" % drv({"validity": None, "target": {}}, "local-sync")))

    # ---- the official OnAIR cells -------------------------------------------
    summ_path = os.path.join(root, "summary.json")
    if not os.path.isfile(summ_path):
        results.append(Result("e41: summary.json present", False, "missing %s" % summ_path))
        return results
    summ = load(summ_path)
    cellmap = summ["onair_cells"]
    e33 = {"smartcam": (True, 5), "smartcam_deny": (False, 0),
           "smartcam_mismatch": (False, 0), "legacy_mlp": (True, 4)}
    for name, (active, infer) in e33.items():
        c = cellmap.get(name) or {}
        results.append(Result("e41: OnAIR cell %s still matches its E33 values under the new gate" % name,
                              c.get("active") is active and c.get("inferences") == infer
                              and c.get("returncode") == 0 and c.get("plugin_constructed") is True
                              and c.get("onair_core_unmodified") is True,
                              "active=%s inferences=%s rc=%s" % (c.get("active"), c.get("inferences"),
                                                                 c.get("returncode"))))
    w = cellmap.get("smartcam_wrong_driver") or {}
    results.append(Result("e41: the new gate fires in the official OnAIR path, before admission and binding",
                          w.get("active") is False and w.get("inferences") == 0
                          and w.get("admission_verdict") is None and w.get("binding_verdict") is None
                          and "driver" in (w.get("inactive_reason") or "") and w.get("returncode") == 0,
                          "active=%s admission=%s binding=%s reason=%s"
                          % (w.get("active"), w.get("admission_verdict"), w.get("binding_verdict"),
                             (w.get("inactive_reason") or "")[:90])))

    # ---- the cell must say which telemetry it feeds OnAIR -------------------
    deps = load(os.path.join(repo, "configs", "deployments", "onair_deployments.json"))["deployments"]
    missing = [n for n, d in deps.items() if not d.get("telemetry")]
    results.append(Result("e41: every OnAIR deployment declares its telemetry file "
                          "(E33's p_legacy cell could not be regenerated without this)",
                          not missing, "%s" % missing))
    data_dir = os.path.join(repo, "configs", "onair_data")
    absent = [n for n, d in deps.items()
              if d.get("telemetry") and not os.path.isfile(os.path.join(data_dir, d["telemetry"] + ".csv"))]
    results.append(Result("e41: every declared telemetry file exists in configs/onair_data",
                          not absent, "%s" % absent))
    return results


# ----------------------------------------------------------------------------
# D72 (v0.44.1): E35's "24/24 verdicts agree" is a corollary, not a measurement
# ----------------------------------------------------------------------------
def e35_d72_structural_agreement_cases():
    """The number is real; its INDEPENDENCE is not, and the source says so.

    e35_baseline_policy_matrix.py skips any model whose three figures disagree, and
    feeds both levels the same three numbers AND the same bound_method. So
    `verdicts_disagreeing: 0` cannot come out otherwise. These cases pin that fact in
    the machine-readable place, so the 24/24 is never re-quoted as 24 independent
    trials -- the E35 plan (SS4-2) had pre-registered that a disagreeing cell "would be
    the core of this experiment", and the implementation cannot produce one.
    """
    results = []
    repo = os.path.dirname(HERE)
    src = open(os.path.join(HERE, "e35_baseline_policy_matrix.py")).read()
    results.append(Result("d72: the matrix still skips models whose three figures disagree "
                          "(so 0 disagreeing cells is structural)",
                          'if not same_numbers or b_level.get("bounded_bytes") is None:' in src
                          and "continue" in src.split('if not same_numbers')[1][:120],
                          "guard not found as expected"))
    results.append(Result("d72: both levels are decided with the SAME bound_method read from the contract",
                          src.count('method = res["bound_method"]') == 1
                          and src.count("as_contract(") >= 3,
                          "method=%d as_contract=%d" % (src.count('method = res["bound_method"]'),
                                                        src.count("as_contract("))))
    # the corollary, demonstrated rather than asserted
    sys.path.insert(0, HERE)
    import admission_policy as ap
    from e35_baseline_policy_matrix import as_contract, bands
    c = as_contract(618856, 309416, 309440, "static_from_stream_layout")
    b = as_contract(618856, 309416, 309440, "static_from_stream_layout")
    diffs = sum(1 for _, budget in bands(618856, 309416) for cond in (False, True)
                if ap.decide(c, budget, allow_conditional_map=cond)["verdict"]
                != ap.decide(b, budget, allow_conditional_map=cond)["verdict"])
    results.append(Result("d72: with identical inputs no band/policy combination can disagree",
                          c == b and diffs == 0, "identical=%s diffs=%d" % (c == b, diffs)))
    # what E35 actually measured is still there and still 4/4
    summ = load(os.path.join(repo, "results", "e35_fair_baseline", "summary.json"))["totals"]
    results.append(Result("d72: the real measurement (three figures + kernel stack, 4/4) is unchanged",
                          summ["models_where_three_figures_agree"] == 4
                          and summ["models_where_kernel_stack_agrees"] == 4
                          and summ["models_total"] == 4,
                          "%s" % summ))
    # the erratum must exist where a machine reader looks, not only in prose (D65)
    ev = open(os.path.join(repo, "docs", "EVIDENCE_v0.38_E35.md"), encoding="utf-8").read()
    results.append(Result("d72: EVIDENCE_v0.38_E35 carries the erratum narrowing the 24/24 claim",
                          "D72" in ev and "따름정리" in ev, "erratum section missing"))
    claude = open(os.path.join(repo, "CLAUDE.md"), encoding="utf-8").read()
    results.append(Result("d72: CLAUDE.md no longer presents 24/24 as an independent measurement",
                          "24/24" not in claude or "따름정리" in claude,
                          "CLAUDE.md still quotes 24/24 without the corollary note"))
    return results






def e43_pure_onair_cases(tmp):
    """E42/E43: the pure-OnAIR baseline, and what it is NOT allowed to say.

    The roadmap asked for four cells. Two of them already existed, so this experiment
    MEASURES two and CITES two -- and the distinction is pinned here, because re-running
    p_admit/p_deny and then counting four new cells is exactly the duplicate-evidence
    inflation D72 corrected.

    The other half of these cases guards the FRAMING. Pure OnAIR has no contract of this
    research's kind; its null admission means "no such step on this path", never "the step
    passed", and never "OnAIR is deficient" (roadmap 7.1, adopted verbatim in the plan).
    """
    results = []
    repo = os.path.dirname(HERE)
    D = os.path.join(repo, "results", "e43_pure_onair")
    summ = load(os.path.join(D, "summary.json"))
    rows = {r["id"]: r for r in summ["rows"]}

    # the four paths, exactly as measured/cited
    for pid, adm, runtime, infers in (("O0", None, True, 5), ("O1", "NOT_EVALUATED", True, 5),
                                      ("O2", "ADMIT", True, 5), ("O3", "NOT_ADMITTED", False, 0)):
        r = rows[pid]
        results.append(Result("e43: %s -- admission %s, runtime_created=%s, %d inference(s)"
                              % (pid, adm, runtime, infers),
                              r["admission_verdict"] == adm and r["runtime_created"] is runtime
                              and r["inferences"] == infers
                              and r["official_loader_constructed"] is True
                              and r["onair_core_unmodified"] is True,
                              "%s" % {k: r.get(k) for k in ("admission_verdict", "runtime_created",
                                                            "inferences", "onair_core_unmodified")}))
    results.append(Result("e43: only O3 refuses before the runtime exists -- that difference IS "
                          "what the proposed path adds",
                          [rows[p]["runtime_created"] for p in ("O0", "O1", "O2", "O3")]
                          == [True, True, True, False],
                          "%s" % {p: rows[p]["runtime_created"] for p in ("O0", "O1", "O2", "O3")}))

    # measured vs cited, and the cited cells' own limitations carried forward
    results.append(Result("e43: two cells are MEASURED here and two are CITED -- not four new cells",
                          summ["cells_measured_here"] == 2 and summ["cells_cited"] == 2
                          and rows["O2"]["kind"].startswith("CITED")
                          and rows["O0"]["kind"].startswith("MEASURED"),
                          "measured=%s cited=%s" % (summ["cells_measured_here"], summ["cells_cited"])))
    results.append(Result("e43: citing p_admit carries D60's limitation (nanobind leak; memory "
                          "release NOT VERIFIED) rather than laundering it",
                          "nanobind" in (rows["O2"]["known_limitation"] or "")
                          and "NOT VERIFIED" in (rows["O2"]["known_limitation"] or ""),
                          "O2 limitation missing"))
    results.append(Result("e43: citing p_deny states that 'runtime not created' rests on the "
                          "documented order, not on a recorded signal",
                          "not on a recorded signal" in (rows["O3"]["known_limitation"] or "")
                          or "rests on" in (rows["O3"]["known_limitation"] or ""),
                          "O3 limitation missing"))

    # O0's absences are by construction, and the plugin says so where a machine reads it
    o0 = rows["O0"]
    results.append(Result("e43: O0 has no contract and no admission gate, recorded as structural "
                          "facts rather than as passes",
                          o0["has_contract"] is False and o0["has_admission_gate"] is False
                          and o0["admission_verdict"] is None,
                          "%s" % {k: o0.get(k) for k in ("has_contract", "has_admission_gate",
                                                         "admission_verdict")}))
    src = open(os.path.join(repo, "plugins", "litert_learner",
                            "litert_learner_plugin.py"), encoding="utf-8").read()
    results.append(Result("e43: the baseline plugin forbids the two framings the roadmap forbids",
                          "not a defect" in src.lower() or "none of those absences is a defect" in src.lower(),
                          "the plugin does not state that its absences are not OnAIR defects"))
    results.append(Result("e43: the baseline records NO memory figure (roadmap 7.5 -- different "
                          "accounting boundaries must not be compared)",
                          "rss" not in src.lower().replace("process rss", "")
                          or "records NO memory figure" in src or "no memory figure at all" in src,
                          "the baseline appears to record a memory figure"))
    results.append(Result("e43: O0 runs the ORIGINAL .tflite, so its NHWC tensor comes from the "
                          "same fixture as the sibling's NCHW one -- a value, not a branch",
                          'sample_file_pattern' in src and 'nhwc' in src.lower(),
                          "the layout choice is not a deployment value"))

    # the harness path-key defect this experiment exposed
    h = open(os.path.join(HERE, "onair_integration_check.py"), encoding="utf-8").read()
    results.append(Result("e43: the harness resolves model_file too, and REFUSES a config-relative "
                          "path under a key it cannot re-root (D62's pattern, third time)",
                          "PATH_KEYS" in h and '"model_file"' in h
                          and "does not know how to re-root" in h,
                          "the harness still resolves only two hardcoded keys"))

    # Q3: O0 reproduces the archived TFLite oracle bit for bit (same original, same LiteRT)
    if _np_ok():
        import numpy as _np                                        # noqa: PLC0415
        recs = []
        rp = os.path.join(D, "o0_pure_onair_litert", "plugin_records.jsonl")
        with open(rp, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        recs.append(json.loads(line))
                    except ValueError:
                        pass
        inf = [r for r in recs if r.get("event") == "inference"]
        orc = {r["sample_id"]: r["output"] for r in
               load(os.path.join(repo, "results", "e31_smartcam_equivalence",
                                 "oracle_tflite.json"))["results"]}
        worst = max((float(_np.abs(_np.asarray(orc[r["sample_id"]], dtype=_np.float64)
                                   - _np.asarray(r["output"], dtype=_np.float64)).max())
                     for r in inf if r["sample_id"] in orc), default=None)
        results.append(Result("e43/Q3: O0's outputs are BIT-IDENTICAL to the archived TFLite "
                              "oracle -- same original model, same interpreter",
                              len(inf) == 5 and worst == 0.0,
                              "n=%d worst_abs=%s" % (len(inf), worst)))
    else:
        results.append(Result("e43/Q3: O0 vs oracle", True, "numpy not installed", skip=True))
    return results


def e46_wgan_cases(tmp):
    """E46: the fourth real public model -- and the two defects importing it exposed.

    What is pinned here:

    (1) THE CONTRACT AND ITS SHAPE. The WGAN denoiser is the first transient-dominated
        model in this repository (131 MB per-call against 4.3 MB constants) -- the exact
        inverse of DeepAE's 171:1 constants-to-per-call. One contract format covering both
        extremes is the claim; the figures are how it is checked.
    (2) THE alpha GUARD, which is the whole reason the converter extension is not a
        two-line registration. ONNX LeakyRelu defaults alpha to 0.01; this model's alpha
        is 0.2. A converter that failed to read it would emit a graph that compiles, runs
        and is silently wrong on the negative half of 11 activations.
    (3) D75 -- the buffer D52 missed -- measured in BOTH directions on really compiled
        code, not argued from source.
    (4) The type-B over-rejection fix in the fixture loader, in all four directions.
    """
    results = []
    repo = os.path.dirname(HERE)
    D = os.path.join(repo, "results", "e46_wgan")

    # (1) contract
    c = load(os.path.join(D, "build", "wgan.contract.json"))
    r = c["resources"]
    results.append(Result("e46: WGAN contract figures and the bounded identity",
                          r["bounded_bytes"] == 135666432
                          and r["static_per_call_bytes"] == 131382784
                          and r["module_resident_constant_bytes"] == 4283648
                          and r["bounded_bytes"] == r["static_per_call_bytes"]
                                                    + r["module_resident_constant_bytes"],
                          "%s" % {k: r.get(k) for k in ("bounded_bytes", "static_per_call_bytes",
                                                        "module_resident_constant_bytes")}))
    results.append(Result("e46: the import needed ZERO overrides and the constants were confirmed",
                          c["provenance"]["overrides_applied"] == []
                          and c["provenance"]["single_invocation"] is True
                          and '"constants_confirmation_state": "confirmed"'
                              in open(os.path.join(D, "build", "wgan.contract.json"),
                                      encoding="utf-8").read(),
                          "overrides=%s single_invocation=%s"
                          % (c["provenance"]["overrides_applied"], c["provenance"]["single_invocation"])))
    results.append(Result("e46: this model is transient-dominated -- the inverse of DeepAE, and the "
                          "reason it is worth adding",
                          r["static_per_call_bytes"] > 20 * r["module_resident_constant_bytes"],
                          "per_call/constants = %.1f" % (r["static_per_call_bytes"]
                                                         / float(r["module_resident_constant_bytes"]))))

    # Q3: HAL peak, and the quantitative boundary it puts on the conditional tier
    sm = load(os.path.join(D, "build", "smoke_pip.json"))
    h = sm["hal_statistics"]
    results.append(Result("e46: HAL peak equals per_call EXACTLY (map arm) and allocated == freed",
                          h["device_bytes_peak"] == r["static_per_call_bytes"]
                          and h["device_bytes_allocated"] == h["device_bytes_freed"],
                          "peak=%s per_call=%s alloc=%s freed=%s"
                          % (h["device_bytes_peak"], r["static_per_call_bytes"],
                             h["device_bytes_allocated"], h["device_bytes_freed"])))
    results.append(Result("e46: the conditional tier buys almost nothing on a transient-dominated "
                          "model -- bounded/per_call is 1.03x here vs 172.30x for DeepAE",
                          abs(r["bounded_bytes"] / float(r["static_per_call_bytes"]) - 1.0326) < 0.001,
                          "bounded/per_call = %.4f"
                          % (r["bounded_bytes"] / float(r["static_per_call_bytes"]))))

    # (2) the alpha guard
    src = open(os.path.join(HERE, "tflite2onnx_ext_elementwise.py"), encoding="utf-8").read()
    sys.path.insert(0, HERE)
    try:
        import tflite2onnx_ext_elementwise as _ext          # noqa: PLC0415
    except ImportError as e:
        results.append(Result("e46: elementwise extension importable", True,
                              "tflite/tflite2onnx not installed: %s" % e, skip=True))
        _ext = None
    man = load(os.path.join(D, "import", "wgan_fpn50_f.transform_manifest.json"))
    alphas = sorted({i["alpha"] for i in man["elementwise_instances"] if i["alpha"] is not None})
    results.append(Result("e46: the model's REAL alpha was read from the flatbuffer and it is NOT "
                          "ONNX's default 0.01",
                          len(alphas) == 1 and abs(alphas[0] - 0.2) < 1e-6,
                          "alphas=%s" % alphas))
    results.append(Result("e46: every LEAKY_RELU and TANH in the model went through the extension",
                          sum(1 for i in man["elementwise_instances"]
                              if i["onnx_type"] == "LeakyRelu") == 11
                          and sum(1 for i in man["elementwise_instances"]
                                  if i["onnx_type"] == "Tanh") == 1,
                          "%d instances" % len(man["elementwise_instances"])))
    if _ext is not None:
        ok_good, _ = _ext.check_elementwise_conditions([1, 4], [1, 4], "float32", "float32", 0.2, True)
        ok_noalpha, _ = _ext.check_elementwise_conditions([1, 4], [1, 4], "float32", "float32", None, True)
        ok_shape, _ = _ext.check_elementwise_conditions([1, 4], [1, 5], "float32", "float32", 0.2, True)
        ok_dtype, _ = _ext.check_elementwise_conditions([1, 4], [1, 4], "float32", "float16", 0.2, True)
        results.append(Result("e46: the extension refuses an unread alpha rather than letting ONNX "
                              "default it (D25/D29/D68 family)",
                              ok_good and not ok_noalpha and not ok_shape and not ok_dtype,
                              "good=%s no_alpha=%s shape=%s dtype=%s"
                              % (ok_good, ok_noalpha, ok_shape, ok_dtype)))
    results.append(Result("e46: the extension documents WHY it needs no C1-C5 (elementwise, "
                          "shape-preserving) instead of copying E30's ceremony",
                          "shape-preserving" in src and "C1-C5" in src and "0.01" in src,
                          "rationale missing from the module docstring"))

    # (3) semantic equivalence, and the OR rule biting again
    cmp_ = load(os.path.join(D, "cell", "comparison.json"))
    t = cmp_["totals"]
    results.append(Result("e46: real noised flight inputs -- 1,655,808 elements, 0 failures",
                          cmp_["verdict"] == "PASS" and t["samples"] == 11
                          and t["elements"] == 1655808 and t["elements_failed"] == 0,
                          "%s" % t))
    results.append(Result("e46: the criterion is E25's, unchanged, and argmax is declared "
                          "not-applicable (an image is not a class vector)",
                          cmp_["criteria"]["abs_tol"] == 1e-4
                          and cmp_["criteria"]["rel_tol"] == 1e-5
                          and cmp_["criteria"]["argmax_mode"] == "not-applicable",
                          "%s" % {k: cmp_["criteria"].get(k) for k in ("abs_tol", "rel_tol", "argmax_mode")}))
    hr = load(os.path.join(D, "cell", "headroom.json"))
    worst_rel = max(v["worst_rel_err"] for v in hr["per_kind"].values())
    results.append(Result("e46: the OR rule was load-bearing AGAIN -- worst rel_err exceeds rel_tol, "
                          "so the abs leg carried the verdict (4th model in a row)",
                          worst_rel > 1e-5 and all(v["elements_failed"] == 0
                                                   for v in hr["per_kind"].values()),
                          "worst_rel=%.3e vs rel_tol 1e-5" % worst_rel))
    results.append(Result("e46: headroom was COMPUTED, and the stored comparison's null is an "
                          "honest null with a reason (not a 0)",
                          all(v["headroom"] > 0.9 for v in hr["per_kind"].values())
                          and cmp_["per_kind"]["real_example"]["headroom"] is None
                          and cmp_["per_kind"]["real_example"]["headroom_unavailable_reason"],
                          "%s" % {k: round(v["headroom"], 4) for k, v in hr["per_kind"].items()}))

    # the first model whose OUTPUT carries a layout
    rr = load(os.path.join(D, "cell", "raw_runs.sha256.json"))
    results.append(Result("e46: iree_runner carries --output-layout as a VALUE and defaults it off",
                          '"--output-layout"' in open(os.path.join(HERE, "iree_runner.py"),
                                                      encoding="utf-8").read()
                          and 'choices=["none", "nchw_to_nhwc"]' in open(
                              os.path.join(HERE, "iree_runner.py"), encoding="utf-8").read(),
                          "option missing or not defaulted to none"))
    results.append(Result("e46: the raw 40 MB run JSONs are not vendored but their regeneration "
                          "command and hashes are (E30/E31/E45 pattern)",
                          "regenerate" in rr and rr["observed"]
                          and not os.path.exists(os.path.join(D, "cell", "oracle_tflite.json"))
                          or bool(rr.get("regenerate")),
                          "raw_runs.sha256.json incomplete"))

    # (4) D75, measured both ways on compiled code
    app = open(os.path.join(repo, "native", "cfs_app", "fsw", "src", "ai_learner.c"),
               encoding="utf-8").read()
    results.append(Result("e46/D75: ai_learner.c's yv[] is now static, like the three buffers D52 "
                          "moved, and the comment says which premise makes that sound",
                          "static float yv[CONTRACT_OUTPUT_ELEMS]" in app
                          and "D75" in app and "max_in_flight_calls" in app,
                          "the fix or its premise note is missing"))
    results.append(Result("e46/D75: no CONTRACT-sized automatic buffer remains in ai_learner.c",
                          not re.search(r"^\s*float\s+\w+\[CONTRACT_(INPUT|OUTPUT)_ELEMS",
                                        app, re.M),
                          "a contract-sized automatic buffer is still declared"))
    meas = open(os.path.join(D, "d75_probe", "measurement.txt"), encoding="utf-8").read()
    results.append(Result("e46/D75: measured BOTH directions on really compiled code -- 602,136 B "
                          "frame before, 8 B after, and the before case exceeds the gate",
                          "602136" in meas and "0x8" in meas and "602151" in meas,
                          "the probe measurement does not carry both frames"))

    # the type-B fix, four directions
    loader = open(os.path.join(HERE, "e32_native_aarch64.py"), encoding="utf-8").read()
    results.append(Result("e46: the fixture loader demands a seed only when there ARE synthetic "
                          "samples (type B fix; three harnesses import this one function)",
                          "n_synth and len(seeds) != 1" in loader
                          and "over-rejection" in loader,
                          "the seed guard is still unconditional"))
    if _np_ok():
        sys.path.insert(0, HERE)
        from e32_native_aarch64 import load_or_regenerate            # noqa: PLC0415
        def _load(d):
            return load_or_regenerate(d, load(os.path.join(d, "manifest.json")))
        e46_fx = os.path.join(D, "cell", "fixture")
        e31_fx = os.path.join(repo, "results", "e31_smartcam_equivalence", "fixture")
        # real-only now loads (it did not before); mixed still loads unchanged
        try:
            n31 = len(_load(e31_fx)); ok31 = n31 == 37
        except SystemExit as e:
            n31, ok31 = str(e), False
        results.append(Result("e46: the mixed E31 fixture (32 synthetic + 3 real + 2 edge) still "
                              "loads unchanged -- no regression", ok31, "%s" % (n31,)))
        # and a synthetic fixture with its seed redacted is STILL refused (no fail-open)
        d2 = os.path.join(tmp, "e46_seedless")
        shutil.copytree(e31_fx, d2)
        m2 = load(os.path.join(d2, "manifest.json"))
        for s2 in m2["samples"]:
            if s2["kind"] == "synthetic":
                s2["detail"]["generator"] = "redacted"
        with open(os.path.join(d2, "manifest.json"), "w") as fh:
            json.dump(m2, fh)
        try:
            _load(d2); refused = False
        except SystemExit:
            refused = True
        results.append(Result("e46: a fixture WITH synthetic samples but no recorded seed is still "
                              "refused (the fix narrows, it does not open)",
                              refused, "a seedless synthetic fixture was accepted"))
        results.append(Result("e46: the fixture built only from real images now loads (it was "
                              "refused before, blocking three harnesses)",
                              os.path.exists(os.path.join(e46_fx, "manifest.json")),
                              "E46 fixture manifest missing"))
    else:
        results.append(Result("e46: fixture loader directions", True, "numpy not installed", skip=True))
    return results


def _np_ok():
    try:
        import numpy                                              # noqa: F401,PLC0415
        return True
    except ImportError:
        return False


def mlir_pass_scope_decision_cases():
    """The 2026-09-11 decision to leave the formal MLIR pass out of this paper.

    A scope decision and a measurement are different things, and this repository has
    confused them before in the other direction (D65: a correction that lived only in
    prose while the machine-readable places still carried the retracted statement).
    The hazard here is the mirror image -- a later reader finding "정규 MLIR pass 제외
    확정" and reading it as "we measured that building it changes nothing". No such
    experiment exists, so the guardrail forbidding that sentence must SURVIVE the
    decision, not be replaced by it. These cases pin both halves.
    """
    results = []
    repo = os.path.dirname(HERE)
    scope = open(os.path.join(repo, "docs", "ASSUMPTIONS_AND_SCOPE.md"),
                 encoding="utf-8").read()
    claude = open(os.path.join(repo, "CLAUDE.md"), encoding="utf-8").read()

    results.append(Result("mlir-pass scope: the decision is recorded in ASSUMPTIONS_AND_SCOPE "
                          "with its date and its reason",
                          "정규 MLIR pass" in scope and "2026-09-11" in scope
                          and "하지 않는다" in scope,
                          "decision section missing from ASSUMPTIONS_AND_SCOPE.md"))
    results.append(Result("mlir-pass scope: the record states explicitly that the decision is "
                          "NOT a measurement",
                          "그런 실험은 없다" in scope or "실측이 아니다" in scope,
                          "the scope document does not distinguish decision from measurement"))
    results.append(Result("mlir-pass scope: the guardrail forbidding the unmeasured claim "
                          "still stands in CLAUDE.md",
                          '정규 pass를 만들어도 결과가 바뀌지 않음을 실측했다' in claude
                          and "pass를 구현해 비교한 실험은 **없다**" in claude,
                          "the guardrail was removed or reworded away"))
    results.append(Result("mlir-pass scope: CLAUDE.md still names the current implementation "
                          "correctly (post-processing verifier, not a pass)",
                          "post-processing verifier" in claude
                          and '"정규 pass"가 아니다' in claude,
                          "the naming correction (F4/N6/S5) was lost"))
    return results


def e45_real_inputs_cases(tmp):
    """E45: real inputs, and the things about them that must not be misread.

    Four kinds of claim are pinned here.

    (1) The VERDICTS as measured, including the one that failed. b3_deepae is a FAIL on
        real inputs while its archived synthetic cell is a PASS, and the pre-fixed
        criterion is the SAME one. A later reader must not be able to find a repository
        where that FAIL quietly became a PASS because a tolerance moved.
    (2) The ACQUISITION POSITION per model: the ad01 bytes are not vendored (the
        distributor forbids redistribution in writing) and no accuracy is claimed for any
        of the three, for reasons that differ per model and are recorded per model.
    (3) The DEFECT INJECTOR is real and reproduces what E31/E34 reported by hand. Before
        E45 neither experiment's negative control could be rebuilt from repository
        contents at all -- the strongest evidence they have rested on an artifact nobody
        could regenerate (D43).
    (4) The SmartCam fidelity tiers stay separate. 19 lossy 614x583 thumbnails are not
        the same evidence as 3 lossless 2048x1944 raws and must never be added into one
        "real images: 22".
    """
    results = []
    repo = os.path.dirname(HERE)
    D = os.path.join(repo, "results", "e45_real_inputs")
    summ = load(os.path.join(D, "summary.json"))

    # (1) verdicts, exactly as measured
    for name, verdict, samples, elements, failed in (
            ("b2_resnet", "PASS", 200, 2000, 0),
            ("b3_deepae", "FAIL", 34, 21760, 94),
            ("smartcam", "PASS", 19, 57, 0)):
        c = summ["cells"][name]["real_inputs"]
        results.append(Result("e45: %s real-input cell is %s (%d samples, %d/%d elements failed)"
                              % (name, verdict, samples, failed, elements),
                              c["verdict"] == verdict and c["samples"] == samples
                              and c["elements"] == elements and c["elements_failed"] == failed,
                              "%s" % {k: c.get(k) for k in
                                      ("verdict", "samples", "elements", "elements_failed")}))
    # the criterion is the inherited one, in the stored comparisons themselves
    for name in ("b2_resnet", "b3_deepae", "smartcam"):
        c = summ["cells"][name]["real_inputs"]
        results.append(Result("e45: %s was judged with the E25 criterion unchanged "
                              "(abs 1e-4 / rel 1e-5)" % name,
                              c["abs_tol"] == 1e-4 and c["rel_tol"] == 1e-5,
                              "abs=%s rel=%s" % (c["abs_tol"], c["rel_tol"])))
    # the FAIL must stay a FAIL: same inputs, same criterion, the archived synthetic cell PASSes
    results.append(Result("e45: b3_deepae FAILs on real inputs while its archived SYNTHETIC cell "
                          "PASSes under the same criterion",
                          summ["cells"]["b3_deepae"]["real_inputs"]["verdict"] == "FAIL"
                          and summ["cells"]["b3_deepae"]["archived_prior_cell"]["verdict"] == "PASS",
                          "real=%s synthetic=%s"
                          % (summ["cells"]["b3_deepae"]["real_inputs"]["verdict"],
                             summ["cells"]["b3_deepae"]["archived_prior_cell"]["verdict"])))

    # (2) acquisition position
    ad = summ["acquisition"]["b3_deepae"]
    results.append(Result("e45: the ad01 bytes are NOT vendored in-tree (the distributor forbids "
                          "redistribution)",
                          ad["bytes_vendored_in_tree"] is False, "%s" % ad.get("bytes_vendored_in_tree")))
    b3m = load(os.path.join(D, "b3_deepae", "manifest.json"))
    results.append(Result("e45: b3 manifest quotes EEMBC's own redistribution statement and the "
                          "purge timeline read from git",
                          "cannot redistribute" in b3m["why_not_vendored"]["statement"]
                          and len(b3m["why_not_vendored"]["purge_timeline_read_from_git"]) == 3,
                          "timeline=%d" % len(b3m["why_not_vendored"].get("purge_timeline_read_from_git", []))))
    results.append(Result("e45: b3 window bytes are absent from the tree but their sha256 are "
                          "recorded (D43 as reproducibility, not byte storage)",
                          not os.path.exists(os.path.join(D, "b3_deepae", "inputs"))
                          and len(b3m["samples"]) == 34
                          and all(r.get("window_sha256") for r in b3m["samples"]),
                          "inputs dir present or a window sha256 is missing"))
    b2m = load(os.path.join(D, "b2_resnet", "manifest.json"))
    results.append(Result("e45: the CIFAR-10 route is gated on the md5 torchvision records for "
                          "the canonical file, not on a mirror URL",
                          b2m["upstream"]["test_batch_md5"] == "40351d587109b95175f43aff81a1287e"
                          and "torchvision" in b2m["upstream"]["md5_attested_by"]
                          and b2m["upstream"]["mirror_is_official"] is False,
                          "%s" % b2m["upstream"].get("test_batch_md5")))
    results.append(Result("e45: the CIFAR-10 subset is MLPerf Tiny's own selector, not one this "
                          "project invented",
                          b2m["subset"]["chosen_by_this_project"] is False
                          and b2m["subset"]["per_class"] == [20] * 10
                          and b2m["cross_check"]["filename_and_label_matched"] == "200/200",
                          "%s" % b2m["subset"]))
    # no accuracy is claimed anywhere, and the reason is per-model
    for name, key in (("b2_resnet", "scope_note"), ("smartcam", "why_no_accuracy")):
        m = load(os.path.join(D, name, "manifest.json"))
        results.append(Result("e45: %s manifest states why no accuracy is claimed" % name,
                              bool(m.get(key)), "missing %s" % key))
    scm = load(os.path.join(D, "smartcam", "manifest.json"))
    results.append(Result("e45: the SmartCam labels are recorded as circular (the label IS the "
                          "model's own argmax), so no accuracy can rest on them",
                          "circular_labels" in scm["why_no_accuracy"]
                          and "argmax" in scm["why_no_accuracy"]["circular_labels"],
                          "circularity not recorded"))

    # (3) the defect injector
    src = open(os.path.join(HERE, "model_fixture.py"), encoding="utf-8").read()
    results.append(Result("e45: model_fixture.py carries the layout defect injector and defaults "
                          "it OFF",
                          '"--layout-defect"' in src and 'default="none"' in src
                          and 'choices=["none", "reshape"]' in src,
                          "injector missing or not defaulted off"))
    fx = load(os.path.join(D, "cells", "smartcam", "fixture", "manifest.json"))
    results.append(Result("e45: a non-defective fixture records layout_defect=none at top level",
                          fx.get("layout_defect") == "none", "%s" % fx.get("layout_defect")))
    # the injector must actually reproduce the FAIL E31 archived by hand
    try:
        import numpy as _np                                   # noqa: PLC0415 - optional probe
    except ImportError:
        _np = None
    if _np is not None:
        F = os.path.join(repo, "results", "e31_smartcam_equivalence", "fixture")
        man = load(os.path.join(F, "manifest.json"))
        real = [s for s in man["samples"] if s["kind"] == "real_example"]
        d = os.path.join(tmp, "e45_negctl")
        _np.save(os.path.join(tmp, "e45_real.npy"),
                 _np.stack([_np.load(os.path.join(F, s["nhwc"]["file"]))[0] for s in real]))
        with open(os.path.join(tmp, "e45_ids.json"), "w") as fh:
            json.dump([s["sample_id"] for s in real], fh)
        rc, _, err = run([PY, os.path.join(HERE, "model_fixture.py"), "--out", d,
                          "--tensors", os.path.join(tmp, "e45_real.npy"),
                          "--tensor-ids", os.path.join(tmp, "e45_ids.json"),
                          "--tensor-kind", "regen_real", "--synthetic", "32", "--seed", "31",
                          "--edge", "--layout", "nhwc_to_nchw", "--layout-defect", "reshape",
                          # the archived .nhwc.npy are ALREADY preprocessed, so the identity
                          # transform is what reproduces them -- passing the image-path std
                          # here would divide them a second time
                          "--height", "224", "--width", "224", "--mean", "0", "--std", "1"])
        built = rc == 0 and os.path.exists(os.path.join(d, "manifest.json"))
        results.append(Result("e45: the injector rebuilds E31's negative-control fixture from "
                              "repository contents", built, "rc=%d %s" % (rc, err[-200:])))
        if built:
            fxm = load(os.path.join(d, "manifest.json"))
            arch = load(os.path.join(F, "manifest.json"))
            ab = {s["sample_id"]: s for s in arch["samples"]}
            # the INPUT side must be identical to the archived fixture; only the entry tensor differs
            same_in = all(s["nhwc"]["sha256"] == ab[s["sample_id"]]["nhwc"]["sha256"]
                          for s in fxm["samples"] if s["sample_id"] in ab)
            diff_entry = any(s["nchw"]["sha256"] != ab[s["sample_id"]]["nchw"]["sha256"]
                             for s in fxm["samples"] if s["sample_id"] in ab)
            results.append(Result("e45: the rebuilt fixture has the SAME inputs as the archive and "
                                  "a DIFFERENT entry tensor (that is the defect)",
                                  same_in and diff_entry,
                                  "same_inputs=%s entry_differs=%s" % (same_in, diff_entry)))
            results.append(Result("e45: the defective fixture labels itself at top level and per "
                                  "sample, so a PASS read from it cannot be mistaken for evidence",
                                  fxm.get("layout_defect") == "reshape"
                                  and all(s.get("layout_defect") == "reshape" for s in fxm["samples"])
                                  and "FAIL" in fxm.get("layout_defect_note", ""),
                                  "%s" % fxm.get("layout_defect")))
    else:
        results.append(Result("e45: injector rebuilds E31's negative control", True,
                              "numpy not installed", skip=True))

    # the measured contrast the negative control exists to show
    det = {(r["cell"], r["inputs"]): r for r in summ["negative_control_detection"]}
    for cell, real_n, synth_n in (("b2_resnet", 180, 0), ("smartcam", 18, 3)):
        r, a = det[(cell, "real_inputs")], det[(cell, "archived_prior_cell")]
        results.append(Result("e45: %s layout defect -- argmax caught %d/%d on real inputs vs "
                              "%d/%d on the archived fixture"
                              % (cell, real_n, r.get("samples", 0), synth_n, a.get("samples", 0)),
                              r.get("argmax_failed") == real_n and a.get("argmax_failed") == synth_n,
                              "real=%s archived=%s" % (r.get("argmax_failed"), a.get("argmax_failed"))))
    results.append(Result("e45: on the archived b2 fixture argmax alone would have passed the "
                          "broken layout on EVERY sample (0/34) -- the reason real inputs matter",
                          det[("b2_resnet", "archived_prior_cell")]["argmax_failed"] == 0
                          and summ["negative_control"]["b2_resnet"]["archived_prior_cell"]["verdict"] == "FAIL",
                          "%s" % det[("b2_resnet", "archived_prior_cell")]))

    # (4) fidelity tiers stay separate
    results.append(Result("e45: SmartCam tiers are recorded separately (19 lossy thumbnails are "
                          "not 3 lossless raws) and the manifest forbids merging them",
                          scm["fidelity_tiers"]["B_thumbnail_jpeg"]["count"] == 19
                          and scm["fidelity_tiers"]["A_raw_png"]["count"] == 3
                          and "do_not_merge_tiers" in scm,
                          "A=%s B=%s" % (scm["fidelity_tiers"]["A_raw_png"]["count"],
                                         scm["fidelity_tiers"]["B_thumbnail_jpeg"]["count"])))
    results.append(Result("e45: every ground-edited SmartCam image was excluded by BYTES, with the "
                          "EXIF tag recorded per file",
                          scm["counts"]["excluded_ground_edited"] == 26
                          and all(e.get("exif_software") for e in scm["excluded"]
                                  if e["reason"] == "ground-edited"),
                          "%s" % scm["counts"]))
    results.append(Result("e45: the new SmartCam images do not overlap the three already in E31",
                          scm["disjointness"]["sha256_overlap_with_tier_A"] == []
                          and scm["disjointness"]["sample_id_overlap_with_tier_A"] == [],
                          "%s" % scm["disjointness"]))

    # the acquisition tool refuses rather than guesses
    fsrc = open(os.path.join(HERE, "fetch_real_inputs.py"), encoding="utf-8").read()
    results.append(Result("e45: the fetcher distinguishes SKIP (unreachable) from FAIL (wrong "
                          "bytes) and never writes on a digest mismatch",
                          "EXIT_SKIP" in fsrc and "digest_mismatch" in fsrc
                          and "def fetch_gated" in fsrc,
                          "refusal paths missing"))
    return results


def e38_optin_witness_cases(tmp):
    """E38: the conditional opt-in must be recorded independently of the verdict.

    E36 ran two cells at the same budget -- one that admitted conditionally and one that
    refused -- and the ONLY thing that said which build had served which cell was the
    verdict itself.  Reading the verdict to learn the setting and then citing the verdict
    as evidence about the setting is circular (eighth external review SS4.1, confirmed
    against the repository: build.log has no `CONDITIONAL` line, and the two trees'
    build_info.json `app_knobs` are byte-identical).

    These cases pin all three records the fix adds -- the binary witness, the build-time
    knob, the run-time `build_config` line -- and, just as importantly, pin the FINDING:
    the archived E36 app_knobs stay identical, so nobody can quietly retouch the archive
    and make the gap disappear.
    """
    results, objdump = [], shutil.which("aarch64-linux-gnu-objdump")
    bindir = os.path.join(E38_DIR, "e36_binaries")
    plain = os.path.join(bindir, "e36_smartcam.ai_learner.so")
    cond = os.path.join(bindir, "e36_smartcam_cond.ai_learner.so")
    PER_CALL, BOUNDED = 9382092, 18222796

    # --- the finding itself, from the archived build records (no toolchain needed) ---
    bi_p = os.path.join(bindir, "e36_smartcam.build_info.json")
    bi_c = os.path.join(bindir, "e36_smartcam_cond.build_info.json")
    if not (os.path.exists(bi_p) and os.path.exists(bi_c)):
        results.append(Result("e38: archived E36 build_info pair present", False,
                              "missing %s / %s" % (bi_p, bi_c)))
        return results
    kp, kc = load(bi_p)["app_knobs"], load(bi_c)["app_knobs"]
    _ok = kp == kc and "AI_LEARNER_ALLOW_CONDITIONAL_MAP" not in kp
    results.append(Result("e38: the two E36 trees' archived app_knobs are byte-identical and omit "
                          "the opt-in -- the gap the fix closes, kept as evidence", _ok,
                          "" if _ok else json.dumps([kp, kc])[:240]))
    _ok = (load(bi_p)["exe"]["ai_learner_so_sha256"] == sha256_file(plain)
           and load(bi_c)["exe"]["ai_learner_so_sha256"] == sha256_file(cond)
           and sha256_file(plain) != sha256_file(cond))
    results.append(Result("e38: each archived .so matches the sha256 its own build_info recorded, "
                          "and the two differ -- the binaries are the ones E36 shipped", _ok, "")
                   if _ok else Result("e38: archived .so sha256 matches its build_info", False,
                                      "%s / %s" % (sha256_file(plain)[:16], sha256_file(cond)[:16])))

    # --- the binary witness itself (needs the cross objdump) ---
    if not objdump:
        results.append(Result("e38: witness reads the opt-in off the archived E36 binaries",
                              True, "aarch64-linux-gnu-objdump not installed", skip=True))
        results.append(Result("e38: witness answers `undetermined`, never `false`, when its "
                              "positive control fails", True,
                              "aarch64-linux-gnu-objdump not installed", skip=True))
    else:
        for label, so, want in (("no opt-in", plain, "0"), ("opt-in", cond, "1")):
            rc, out, err = run([sys.executable, "harness/optin_witness.py", so,
                                "--per-call", str(PER_CALL), "--bounded", str(BOUNDED)])
            rec = json.loads(out) if out.strip().startswith("{") else {}
            _ok = rc == 0 and rec.get("allow_conditional_map_state") == want
            results.append(Result("e38: the archived E36 %s binary itself witnesses "
                                  "AI_LEARNER_ALLOW_CONDITIONAL_MAP=%s -- no run verdict consulted"
                                  % (label, want), _ok,
                                  "" if _ok else (out or err)[:240]))
        rc, out, _ = run([sys.executable, "harness/optin_witness.py", cond,
                          "--per-call", str(PER_CALL), "--bounded", str(BOUNDED)])
        rec = json.loads(out)
        site = (rec.get("conditional_compare_sites") or [{}])[0]
        _ok = site.get("function") == "AI_LEARNER_Init" and site.get("value") == PER_CALL - 1
        results.append(Result("e38: and the site it found is the admission compare in "
                              "AI_LEARNER_Init against CONTRACT_PER_CALL_BYTES", _ok,
                              "" if _ok else json.dumps(site)[:200]))

        # fail-closed: with a bogus `bounded` the positive control cannot pass, and the
        # answer must be `undetermined` -- NOT `false` (D25/D29: absence is not a value).
        rc, out, _ = run([sys.executable, "harness/optin_witness.py", plain,
                          "--per-call", str(PER_CALL), "--bounded", "424242"])
        rec = json.loads(out)
        _ok = rec.get("allow_conditional_map_state") == "undetermined" and "positive control" in rec.get("reason", "")
        results.append(Result("e38: witness answers `undetermined`, never `false`, when its "
                              "positive control fails", _ok, "" if _ok else json.dumps(rec)[:220]))

    # --- the run-time record: emitted before any gate, so refusing cells carry it too ---
    src = read("native/cfs_app/fsw/src/ai_learner.c")
    i_cfg, i_budget = src.find('\\"stage\\":\\"build_config\\"'), src.find("if (!AI_LEARNER_ResolveBudget())")
    _ok = 0 < i_cfg < i_budget
    results.append(Result("e38: ai_learner.c emits `build_config` (with allow_conditional_map) "
                          "BEFORE the budget gate, so a refusing cell records the setting too",
                          _ok, "" if _ok else "build_config at %d, budget gate at %d" % (i_cfg, i_budget)))

    nsrc = read("native/native_learner.c")
    _ok = ("conditional_map_requested" in nsrc
           and '\\"conditional_map_requested\\":%s,\\"conditional_map_applied\\":%s' in nsrc)
    results.append(Result("e38: native_learner.c records the REQUESTED opt-in next to the applied "
                          "one -- its silent reset left no trace otherwise", _ok, ""))

    bsh = read("scripts/51_build_cfs_aarch64.sh")
    _ok = ('"AI_LEARNER_ALLOW_CONDITIONAL_MAP": num("ALLOW_COND")' in bsh
           and "ai_learner_compile_defines" in bsh and '"optin_witness"' in bsh)
    results.append(Result("e38: the build script records the opt-in, the actual -D list and the "
                          "binary witness in build_info.json", _ok, ""))
    _ok = "--expect" in bsh and "optin_witness.py" in bsh
    results.append(Result("e38: and it FAILS THE BUILD when the shipped binary disagrees with the "
                          "requested opt-in (--expect), not just when the -D was missing", _ok, ""))

    # D61 was fixed in script 51 only; script 50 had the same `${VAR:+-D...}` shape against the
    # same kind of persistent, shared CMake tree.  Both must pass the flag unconditionally.
    for script in ("scripts/50_wire_cfs_ai_learner.sh", "scripts/51_build_cfs_aarch64.sh"):
        t = read(script)
        _ok = ("${AI_LEARNER_ALLOW_CONDITIONAL_MAP:+" not in t
               and "${ALLOW_CONDITIONAL_MAP:+" not in t
               and '-DAI_LEARNER_ALLOW_CONDITIONAL_MAP="$ALLOW_CONDITIONAL_MAP"' in t)
        results.append(Result("e38/D61: %s always passes the opt-in explicitly (a shared CMake cache "
                              "makes `unset` mean `last build's value`, not `default`)"
                              % os.path.basename(script), _ok, ""))

    # --- the re-run cells: each carries its own setting, ahead of its own verdict ---
    sp = os.path.join(E38_DIR, "summary.json")
    if not os.path.exists(sp):
        results.append(Result("e38: re-run summary present", False, "missing %s" % sp))
        return results
    s = load(sp)
    for cell, want_optin, want_verdict in (("cond_positive", 1, "ADMIT_CONDITIONAL_MAP"),
                                           ("cond_denied_without_optin", 0, "NOT_ADMITTED")):
        c = s["cells"][cell]
        _ok = (c["build_config"]["allow_conditional_map"] == want_optin
               and c["verdict"] == want_verdict
               and c["build_config_precedes_admission"] is True)
        results.append(Result("e38: the re-run %s cell states its own opt-in (=%d) in the raw log "
                              "before its verdict (%s)" % (cell, want_optin, want_verdict), _ok,
                              "" if _ok else json.dumps(c)[:260]))
        _ok = c["optin_witness"]["allow_conditional_map_state"] == str(want_optin) \
            and c["optin_witness"]["binary_sha256"] == c["ai_learner_so_sha256"]
        results.append(Result("e38: and the binary that produced it witnesses the same value "
                              "(%s)" % cell, _ok, "" if _ok else json.dumps(c.get("optin_witness"))[:220]))

    cp, cd = s["cells"]["cond_positive"], s["cells"]["cond_denied_without_optin"]
    _ok = (cp["budget_bytes"] == cd["budget_bytes"] == 9382092
           and cp["ai_learner_so_sha256"] != cd["ai_learner_so_sha256"])
    results.append(Result("e38: the control is real -- same budget, different binaries, opposite "
                          "verdicts, and the difference is now recorded rather than inferred", _ok,
                          "" if _ok else json.dumps([cp.get("budget_bytes"), cd.get("budget_bytes")])))

    _ok = (cp["hal_peak"] == 9382092 and cp["peak_within_admitted_budget"] is True
           and cd["inferences"] == 0)
    results.append(Result("e38: and the E36 measurements are unchanged by the added record "
                          "(peak = per_call exactly; the control cell still runs zero inferences)",
                          _ok, "" if _ok else json.dumps([cp, cd])[:260]))

    _ok = all(s["cells"][c]["build_config"]["contract_artifact_sha256"]
              == "ecffe6e0bcbadf51c8482c73ab147e91fa857927d1183955e03a3257041c78f1"
              for c in ("cond_positive", "cond_denied_without_optin"))
    results.append(Result("e38: both re-run cells name the same E32 artifact in their own "
                          "build_config -- one model, two settings, not two models", _ok, ""))

    for t in ("e38_smartcam", "e38_smartcam_cond"):
        dep = s["trees"][t].get("deployed_on_guest", {})
        _ok = dep.get("matches_build_info") is True
        results.append(Result("e38: the .so the guest loaded for %s hashes to the one its build "
                              "record names -- the log-to-binary link E36 lacked" % t, _ok,
                              "" if _ok else json.dumps(dep)[:200]))

    # --- x86-64 cross-check: the same stale-cache hazard, cleared and witnessed ---
    xp = os.path.join(E38_DIR, "x86_64_cross_check", "summary.json")
    if not os.path.exists(xp):
        results.append(Result("e38: x86-64 cross-check summary present", False, "missing %s" % xp))
    else:
        x = load(xp)
        by = {st["step"]: st for st in x["steps"]}
        _ok = all(st["witnessed"] == st["expected"] for st in x["steps"]) and x["verdict"] == "PASS"
        results.append(Result("e38/D61: on x86-64, an unset opt-in after a =1 build produces a binary "
                              "that witnesses 0 -- the stale CMake cache is actually cleared", _ok,
                              "" if _ok else json.dumps(x["steps"])[:240]))
        _ok = (by["step1_conditional"]["isa"] == "x86-64"
               and by["step1_conditional"]["conditional_compare_sites"]
               and by["step1_conditional"]["conditional_compare_sites"][0]["value"] == 65579
               and by["step1_conditional"]["positive_control_site_count"] >= 1)
        results.append(Result("e38: the witness's x86-64 branch works on a real binary (cmp against "
                              "per_call-1 in AI_LEARNER_Init), not only the AArch64 mov/movk form",
                              _ok, "" if _ok else json.dumps(by["step1_conditional"])[:240]))
        _ok = (by["step1_conditional"]["binary_sha256"] != by["step2_unset_after_conditional"]["binary_sha256"]
               and by["step2_unset_after_conditional"]["binary_sha256"]
               == by["step3_unset_again"]["binary_sha256"])
        results.append(Result("e38: and the two unset builds are byte-identical to each other and "
                              "different from the opt-in build", _ok, ""))

    # --- native path: the same gap, the same fix, measured ---
    np_ = os.path.join(E38_DIR, "native_requested_vs_applied.json")
    if not os.path.exists(np_):
        results.append(Result("e38: native requested-vs-applied record present", False, "missing %s" % np_))
        return results
    n = load(np_)["cells"]
    k = n["conditional_requested_but_budget_covers_bounded"]
    _ok = (k["conditional_map_requested"] is True and k["conditional_map_applied"] is False
           and k["verdict"] == "ADMIT")
    results.append(Result("e38: native_learner records a requested opt-in that was NOT applied "
                          "(verdict ADMIT) -- the state its silent reset used to erase", _ok,
                          "" if _ok else json.dumps(k)[:200]))
    _ok = (n["conditional_requested_budget_per_call"]["conditional_map_applied"] is True
           and n["conditional_not_requested_budget_per_call"]["verdict"] == "NOT_ADMITTED"
           and n["unconditional_budget_bounded"]["conditional_map_requested"] is False)
    results.append(Result("e38: and the other three native cells are unchanged -- the added field "
                          "reports, it does not decide", _ok, "" if _ok else json.dumps(n)[:240]))
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
        all_results += documented_smoke_path_cases(tmp)
        all_results += preserved_manyconst31_cases()
        all_results += constants_budget_gate_cases(a.root)
        all_results += subset_sum_tristate_cases()
        all_results += workflow_yaml_cases()
        all_results += r5_waive_wrapping_cases()
        all_results += default_plugin_fixture_cases()
        all_results += e25_compare_rule_cases(tmp)
        all_results += e26_instrumentation_expect_cases()
        all_results += call_resolution_cases(tmp)
        all_results += rodata_label_cases()
        all_results += multiout_subview_cases(tmp)
        all_results += a5b_canonical_guest_cases(tmp)
        all_results += ext_b2_resnet_cases()
        all_results += ext_b3_deepae_cases()
        all_results += e27_information_level_cases()
        all_results += e28_stack_failopen_cases()
        all_results += e29_conditional_contract_cases()
        all_results += e27_hardened_baseline_cases()
        all_results += e29b_conditional_verify_cases(tmp)
        all_results += p1_smartcam_feasibility_cases(tmp)
        all_results += e30b_squeeze_extension_cases(tmp)
        all_results += e31_semantic_equivalence_cases(tmp)
        all_results += e32_aarch64_realigned_frame_cases(tmp)
        all_results += e32_admitted_budget_cases()
        all_results += e33_official_onair_cases(tmp)
        all_results += e34_two_models_cases()
        all_results += e34_comparator_generalisation_cases(tmp)
        all_results += e35_fair_baseline_cases()
        all_results += e33_e35_errata_cases()
        all_results += e36_aarch64_cfs_cases()
        all_results += e36b_aarch64_models_cases()
        all_results += e37_evidence_linkage_cases()
        all_results += e37_d60_extension_cases()
        all_results += e37_truncated_record_cases()
        all_results += e37_guest_rerun_cases()
        all_results += e37_peak_vs_budget_cases()
        all_results += e38_optin_witness_cases(tmp)
        all_results += e40_analysis_domain_cases(tmp)
        all_results += e41_analysis_domain_cases(tmp)
        all_results += e35_d72_structural_agreement_cases()
        all_results += e45_real_inputs_cases(tmp)
        all_results += mlir_pass_scope_decision_cases()
        all_results += e46_wgan_cases(tmp)
        all_results += e43_pure_onair_cases(tmp)
        all_results += cited_raw_logs_tracked_cases()
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
