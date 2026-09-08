"""E14 Stage 1 cross-target matrix driver (proposal SS8, SS13, SS15).

Stage A (compile): for every model x target, run ONE iree-compile invocation
that emits, together, (a) the deployable vmfb, (b) the allocation IR after
iree-stream-layout-slices (stderr), (c) the executable dumps (LLVM IR, embedded
ELF).  This is the one-invocation rule of EVIDENCE_v0.7 SS1.3: the contract
must describe the very bytes that are deployed, and the input path/basename is
part of the symbol names, so nothing is ever re-compiled separately.

Stage B (extract): contract JSON from the SAVED outputs of that invocation
(harness/make_contract.py + harness/elf_stack_frame.py), the C header
(harness/gen_contract_header.py) and an objdump of the embedded ELF.

Large constant payloads are elided from the printed IR
(--mlir-elide-elementsattrs-if-larger) so the layout IR can be committed; the
elision only affects printing, not compilation, and the size operands the
contract parser needs ({%cN}) are unaffected.  The sha256 of the printed IR is
recorded in the contract's provenance block.

Usage:
  python3 harness/e14_matrix.py compile  --root results/e14_aarch64_qemu [--models mlp16k,...] [--targets aarch64,x86_64]
  python3 harness/e14_matrix.py extract  --root results/e14_aarch64_qemu [...]
"""
import argparse, hashlib, json, os, pathlib, shutil, subprocess, sys, time

HERE = pathlib.Path(__file__).resolve().parent
TARGETS = {
    "aarch64": {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53",
                "objdump": "aarch64-linux-gnu-objdump", "readelf": "aarch64-linux-gnu-readelf"},
    "x86_64":  {"triple": "x86_64-unknown-linux-gnu", "cpu": "host",
                "objdump": "objdump", "readelf": "readelf"},
}
ELIDE = 16  # elements; constants larger than this are printed elided


def sha256(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def find_models(root, only):
    out = []
    for d in sorted((root / "models").iterdir()):
        if not d.is_dir():
            continue
        mlirs = sorted(d.glob("*.mlir"))
        if not mlirs:
            continue
        if only and d.name not in only:
            continue
        out.append((d.name, mlirs[0]))
    return out


def compile_one(root, model, mlir, tgt):
    t = TARGETS[tgt]
    outdir = root / tgt
    for sub in ("vmfb", "layout_ir", "dump", "contracts", "llvm_ir", "elf", "objdump", "headers"):
        (outdir / sub).mkdir(parents=True, exist_ok=True)
    vmfb = outdir / "vmfb" / f"{model}.vmfb"
    ir = outdir / "layout_ir" / f"{model}.layout_ir.txt"
    dump = outdir / "dump" / model
    if dump.exists():
        shutil.rmtree(dump)
    dump.mkdir(parents=True)
    cmd = ["iree-compile", str(mlir),
           "--iree-hal-target-backends=llvm-cpu",
           f"--iree-llvmcpu-target-triple={t['triple']}",
           f"--iree-llvmcpu-target-cpu={t['cpu']}",
           "--mlir-print-ir-after=iree-stream-layout-slices",
           f"--mlir-elide-elementsattrs-if-larger={ELIDE}",
           f"--iree-hal-dump-executable-files-to={dump}",
           "-o", str(vmfb)]
    t0 = time.time()
    with open(ir, "w") as err:
        r = subprocess.run(cmd, stderr=err, stdout=subprocess.PIPE, text=True)
    dt = time.time() - t0
    if r.returncode != 0:
        print(f"[{model}/{tgt}] iree-compile FAILED rc={r.returncode}; see {ir}")
        return None
    rec = {"model": model, "target": tgt, "mlir": str(mlir), "mlir_basename": mlir.name,
           "command": cmd, "vmfb": str(vmfb), "vmfb_bytes": vmfb.stat().st_size,
           "vmfb_sha256": sha256(vmfb), "layout_ir": str(ir), "layout_ir_sha256": sha256(ir),
           "dump_dir": str(dump), "dump_files": sorted(p.name for p in dump.iterdir()),
           "compile_seconds": round(dt, 2), "single_invocation": True}
    (outdir / "vmfb" / f"{model}.invocation.json").write_text(json.dumps(rec, indent=2))
    print(f"[{model}/{tgt}] vmfb {rec['vmfb_bytes']} B sha256 {rec['vmfb_sha256'][:16]}… ({dt:.1f}s) dump: {rec['dump_files']}")
    return rec


def extract_one(root, model, mlir, tgt):
    t = TARGETS[tgt]
    outdir = root / tgt
    inv = json.loads((outdir / "vmfb" / f"{model}.invocation.json").read_text())
    dump = pathlib.Path(inv["dump_dir"])
    # embedded ELF + LLVM IR from the dump dir
    sys.path.insert(0, str(HERE))
    import elf_stack_frame as esf
    elf_src = esf.extract_embedded_elf(str(dump))
    elf = outdir / "elf" / f"{model}.kernel.elf"
    shutil.copyfile(elf_src, elf)
    lls = sorted(dump.glob("*.codegen.ll"))
    ll = None
    if lls:
        ll = outdir / "llvm_ir" / f"{model}.{lls[0].name}"
        shutil.copyfile(lls[0], ll)
    objd = outdir / "objdump" / f"{model}.kernel.objdump.txt"
    with open(objd, "w") as f:
        subprocess.run([t["objdump"], "-d", str(elf)], stdout=f, check=True)
    elf_json = outdir / "elf" / f"{model}.elf_analysis.json"
    cmd = [sys.executable, str(HERE / "elf_stack_frame.py"), "--elf", str(elf), "--objdump", t["objdump"], "--out", str(elf_json)]
    if ll:
        cmd += ["--ll", str(ll)]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL)
    contract = outdir / "contracts" / f"contract.{model}.{tgt}.json"
    cmd = [sys.executable, str(HERE / "make_contract.py"), "--mlir", str(mlir), "--vmfb", inv["vmfb"],
           "--layout-ir", inv["layout_ir"], "--dump-dir", str(dump), "--triple", t["triple"], "--cpu", t["cpu"],
           "--model-name", model, "--elf-analysis", str(elf_json), "--out", str(contract),
           "--extra-args", f"--mlir-elide-elementsattrs-if-larger={ELIDE}"]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL)
    hdr = outdir / "headers" / f"contract_gen.{model}.h"
    subprocess.run([sys.executable, str(HERE / "gen_contract_header.py"), str(contract), str(hdr)], check=True, stdout=subprocess.DEVNULL)
    c = json.loads(contract.read_text())
    r = c["resources"]
    print(f"[{model}/{tgt}] bound_method={r['bound_method']} bounded={r.get('bounded_bytes')} per_call={r.get('static_per_call_bytes')} "
          f"const={r.get('module_resident_constant_bytes')} kernel_stack={r.get('kernel_task_stack_bytes')} calls={r.get('kernel_external_call_insns')} alloca={r.get('llvm_alloca_count')}")
    return c


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stage", choices=["compile", "extract"])
    ap.add_argument("--root", default="results/e14_aarch64_qemu")
    ap.add_argument("--models", default="")
    ap.add_argument("--targets", default="aarch64,x86_64")
    a = ap.parse_args()
    root = pathlib.Path(a.root)
    only = [m for m in a.models.split(",") if m]
    tgts = [t for t in a.targets.split(",") if t]
    for model, mlir in find_models(root, only):
        for tgt in tgts:
            (compile_one if a.stage == "compile" else extract_one)(root, model, mlir, tgt)


if __name__ == "__main__":
    main()
