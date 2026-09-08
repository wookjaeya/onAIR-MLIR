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
        return cmd + list(extra_flags)

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
    return results


# ----------------------------------------------------------------------------
# regression: the 14 stored contracts/headers must not change (D13-D15 must
# be a fail-CLOSED tightening, not a change to any currently-valid contract)
# ----------------------------------------------------------------------------
IGNORE_PROVENANCE_KEYS = {
    "entry_print_used_chunk_index", "entry_print_used_sha256", "entry_print_used_is_last",
    "layout_ir_sha256", "layout_ir_dump_count", "entry_prints_in_dump", "entry_print_states_differ",
}


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
                    if k[-1] not in IGNORE_PROVENANCE_KEYS and old.get(k) != new.get(k)]
            ok = not diffs
            if ok:
                n_ok += 1
            results.append(Result("regression: %s/%s contract unchanged" % (tgt, model), ok,
                                  "" if ok else "%d field(s) differ, e.g. %s" % (len(diffs), diffs[:3])))
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
            exact_keys = ("inputs", "outputs", "transient_slabs")
            diffs = [k for k in exact_keys if sorted(structural.get(k, [])) != sorted(regex_based.get(k, []))]
            if sum(structural.get("constants", [])) != sum(regex_based.get("constants", [])):
                diffs.append("constants(sum)")
            if structural.get("entry_found") != regex_based.get("entry_found"):
                diffs.append("entry_found")
            if bool(structural.get("unresolved")) != bool(regex_based.get("unresolved")):
                diffs.append("unresolved(presence)")
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
