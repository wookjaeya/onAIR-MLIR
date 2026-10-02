#!/usr/bin/env python3
"""E67: IREE's own transient-size query at the evaluated compiler revision, on the four AArch64 models.

The v31 manuscript review asked what IREE's native size query / reflection metadata provides in the
evaluated configuration and what it leaves out. At the evaluated revision the facility is opt-in:
it acts only on a `hal.tensor.transients` op, which the two supported routes create for an entry that
takes an added `!hal.buffer {iree.abi.transients}` argument (caller-supplied transient storage) or via
the torch input's --iree-torch-externalize-transients; a hand-written op is a third route (untested). This script records, deterministically:

  1. the four EVALUATED artifacts carry no transient-size reflection or query function
     (iree-dump-module; the evaluated entries take no such argument);
  2. compiling each model's evaluated MLIR with that one argument added (same compiler, same AArch64
     target flags) yields `iree.abi.transients.size.constant`, compared with the specification's T
     (`static_transient_bytes`) and with I, O, C, P, B_u.

The opt-in artifacts are NOT evaluated artifacts: their entry ABI differs. Nothing here is executed;
the reflection value is read from the module, as the upstream sample reads it.

usage: e67_native_transient_query.py [--models m1,m2] [--out results/e67_native_transient_query/summary.json]
       e67_native_transient_query.py --check   (re-derive and compare with the committed summary)
"""
import argparse, gzip, hashlib, json, os, re, shutil, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
OUT = os.path.join(REPO, "results", "e67_native_transient_query", "summary.json")
SPEC = "results/e65_producer_check/reissued/{m}/{m}.contract.json"
MODELS = {
    "b2_resnet": {"mlir": "results/e36b_aarch64_models/b2_resnet/b2_resnet.mlir",
                  "vmfb": "results/e36b_aarch64_models/b2_resnet/b2_resnet.vmfb"},
    "b3_deepae": {"mlir": "results/e36b_aarch64_models/b3_deepae/b3_deepae.mlir",
                  "vmfb": "results/e36b_aarch64_models/b3_deepae/b3_deepae.vmfb"},
    "smartcam": {"mlir": "results/p1_smartcam_feasibility/build/smartcam.mlir.gz",
                 "vmfb": "results/e32_smartcam_aarch64/build/smartcam.vmfb"},
    "wgan": {"mlir": "results/e53_wgan_aarch64/build/aarch64/wgan.mlir",
             "vmfb": "results/e53_wgan_aarch64/build/aarch64/wgan.vmfb"},
}
TARGET = ["--iree-hal-target-backends=llvm-cpu",
          "--iree-llvmcpu-target-triple=aarch64-unknown-linux-gnu",
          "--iree-llvmcpu-target-cpu=cortex-a53"]
ADDED_ARG = ", %transient_storage: !hal.buffer {iree.abi.transients}"
SIG = re.compile(r"^(\s*func\.func @infer\(%arg0: [^)]*)(\) -> )", re.M)


def sha(b):
    return hashlib.sha256(b).hexdigest()


def read_mlir(rel):
    p = os.path.join(REPO, rel)
    raw = open(p, "rb").read()
    return gzip.decompress(raw) if rel.endswith(".gz") else raw


def dump(vmfb):
    r = subprocess.run(["iree-dump-module", vmfb], capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError("iree-dump-module failed on %s: %s" % (vmfb, r.stderr[-400:]))
    return r.stdout


def exports(text):
    """Exported function lines of an iree-dump-module listing, with their reflection entries."""
    m = re.search(r"Exported Functions:\n(.*?)(?:\n\n|\Z)", text, re.S)
    block = m.group(1) if m else ""
    funcs, cur = [], None
    for line in block.splitlines():
        f = re.match(r"\s*\[\s*\d+\]\s+(\S+)\((.*)\)\s*->\s*\((.*)\)", line)
        if f:
            cur = {"name": f.group(1), "args": f.group(2), "results": f.group(3), "reflection": {}}
            funcs.append(cur)
            continue
        kv = re.match(r"\s+([\w.]+):\s*(.*)$", line)
        if kv and cur is not None:
            cur["reflection"][kv.group(1)] = kv.group(2).strip()
    return funcs


def one(m, work):
    cfg = MODELS[m]
    spec = json.load(open(os.path.join(REPO, SPEC.format(m=m))))
    res = spec["resources"]
    fig = {"I": res["static_external_input_bytes"], "O": res["static_external_output_bytes"],
           "T": res["static_transient_bytes"], "C": res["module_resident_constant_bytes"],
           "P": res["static_per_call_bytes"], "B_u": res["bounded_bytes"]}
    src = read_mlir(cfg["mlir"])
    ok_model = sha(src) == spec["model"]["sha256"]
    ev = os.path.join(REPO, cfg["vmfb"])
    ok_artifact = sha(open(ev, "rb").read()) == spec["artifact"]["sha256"]
    ev_text = dump(ev)
    ev_exports = exports(ev_text)

    text = src.decode()
    n_sig = len(SIG.findall(text))
    if n_sig != 1:
        raise RuntimeError("%s: expected one @infer signature, found %d" % (m, n_sig))
    opt = SIG.sub(lambda g: g.group(1) + ADDED_ARG + g.group(2), text, count=1)
    d = os.path.join(work, m)
    os.makedirs(d, exist_ok=True)
    mp = os.path.join(d, m + ".mlir")
    open(mp, "w").write(opt)
    vp = os.path.join(d, m + ".vmfb")
    cmd = ["iree-compile", mp] + TARGET + ["-o", vp]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError("%s: iree-compile rc=%d: %s" % (m, r.returncode, r.stderr[-400:]))
    op_exports = exports(dump(vp))
    infer = [f for f in op_exports if f["name"] == "infer"]
    refl = infer[0]["reflection"] if infer else {}
    const = refl.get("iree.abi.transients.size.constant")
    reported = int(const) if const is not None and const.isdigit() else None
    return {
        "model_sha256_matches_specification": ok_model,
        "evaluated_artifact_sha256_matches_specification": ok_artifact,
        "evaluated_artifact": {
            "path": cfg["vmfb"],
            "exports": [f["name"] for f in ev_exports],
            "transient_mentions_in_dump": len(re.findall("transient", ev_text, re.I)),
            "infer_reflection_keys": sorted(next((f["reflection"] for f in ev_exports
                                                  if f["name"] == "infer"), {}).keys()),
        },
        "opt_in": {
            "edit": "added to @infer: " + ADDED_ARG.lstrip(", "),
            "argv": ["iree-compile", "<edited mlir>"] + TARGET + ["-o", "<vmfb>"],
            "exports": [f["name"] for f in op_exports],
            "infer_args": infer[0]["args"] if infer else None,
            "reflection": {k: v for k, v in refl.items() if "transients" in k},
            "reported_transient_size": reported,
        },
        "specification_figures": fig,
        "reported_equals": {k: reported == v for k, v in fig.items()},
    }


def derive(models):
    ver = subprocess.run(["iree-compile", "--version"], capture_output=True, text=True).stdout
    work = tempfile.mkdtemp(prefix="e67_")
    try:
        per = {m: one(m, work) for m in models}
    finally:
        shutil.rmtree(work, ignore_errors=True)
    return {
        "experiment": "E67",
        "compiler_version": " ".join(ver.split()[:8]),
        "question": "what IREE's own transient-size query provides at the evaluated revision, and what it leaves out",
        "models": per,
        "summary": {
            "evaluated_artifacts_without_transient_query": sum(
                1 for v in per.values() if v["evaluated_artifact"]["transient_mentions_in_dump"] == 0
                and v["evaluated_artifact"]["exports"] == ["infer", "__init"]),
            "opt_in_reported_equals_T": sum(1 for v in per.values() if v["reported_equals"]["T"]),
            "opt_in_reported_equals_any_other_figure": sum(
                1 for v in per.values() if any(v["reported_equals"][k] for k in ("I", "O", "C", "P", "B_u"))),
            "n": len(per),
        },
        "not_measured": [
            "execution of the opt-in artifacts (their entry ABI differs from the evaluated artifacts)",
            "the dynamic-size query function (all four sizes fold to a constant)",
            "runtime validation of caller-supplied storage size",
        ],
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--models", default=",".join(MODELS))
    ap.add_argument("--out", default=OUT)
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    models = [m for m in a.models.split(",") if m]
    got = derive(models)
    if a.check:
        ref = json.load(open(a.out))
        same = all(got["models"][m] == ref["models"][m] for m in models)
        print("E67 re-derivation", "matches" if same else "DIFFERS", "for", models)
        return 0 if same else 1
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    json.dump(got, open(a.out, "w"), indent=2, sort_keys=True)
    open(a.out, "a").write("\n")
    print(json.dumps(got["summary"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
