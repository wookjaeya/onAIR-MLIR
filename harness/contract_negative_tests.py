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

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import static_mem_bound as smb  # noqa: E402

PY = sys.executable
MAKE_CONTRACT = os.path.join(HERE, "make_contract.py")
GEN_HEADER = os.path.join(HERE, "gen_contract_header.py")

TARGET_INFO = {
    "aarch64": {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53"},
    "x86_64": {"triple": "x86_64-unknown-linux-gnu", "cpu": "host"},
}


# ----------------------------------------------------------------------------
# small helpers
# ----------------------------------------------------------------------------
class Result:
    def __init__(self, name, ok, detail=""):
        self.name = name
        self.ok = ok
        self.detail = detail

    def __repr__(self):
        return "%-6s %-70s %s" % ("PASS" if self.ok else "FAIL", self.name, self.detail)


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
            allow_missing_abi_declaration=False, allow_unverified_invocation=False,
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
        results.append(Result("structural-hard-fail: iree.compiler.ir available (prerequisite for remaining cases)",
                              False, "mlir_alloc_walk's structural extractor is not usable in this environment"))
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
        return [Result("structural-bugfix: iree.compiler.ir available (prerequisite)", False,
                       "mlir_alloc_walk's structural extractor is not usable in this environment")]

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
            cmd = [PY, MAKE_CONTRACT, "--mlir", inv["mlir"], "--vmfb", inv["vmfb"], "--layout-ir", inv["layout_ir"],
                  "--dump-dir", dump_dir, "--triple", ti["triple"], "--cpu", ti["cpu"], "--model-name", model,
                  "--elf-analysis", elf_json, "--out", new_contract,
                  "--extra-args", "--mlir-elide-elementsattrs-if-larger=16"]
            rc, o, err = run(cmd)
            if rc != 0:
                results.append(Result("regression: %s/%s make_contract succeeds (incl. schema validation)" % (tgt, model), False,
                                      "rc=%d stderr=%s" % (rc, err.strip()[:200])))
                continue
            old = dict(flatten(load(contract_path)))
            new = dict(flatten(load(new_contract)))
            diffs = [(k, old.get(k), new.get(k)) for k in set(old) | set(new)
                    if k[-1] not in IGNORE_PROVENANCE_KEYS and not (set(k) & IGNORE_PROVENANCE_SUBTREES)
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
            results.append(Result("regression: %s/%s structural cross-check ran and agreed" % (tgt, model),
                                  avail is True and agree is True,
                                  "available=%s agrees_with_regex_parser=%s" % (avail, agree)))
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
        if not a.skip_regression:
            all_results += regression_check(a.root, tmp)

        print("=" * 100)
        for r in all_results:
            print(r)
        print("=" * 100)
        n_fail = sum(1 for r in all_results if not r.ok)
        print("%d/%d checks passed" % (len(all_results) - n_fail, len(all_results)))
        return 1 if n_fail else 0


if __name__ == "__main__":
    sys.exit(main())
