"""Emit the cFS scenario list (proposal SS11.2 A1-A7, plus the SS12/SS13 negative
case) for harness/e14_cfs_scenarios.py from the contracts in the results tree.

Guest layout (remote root, default cfs_e14/):
  cpu1/                                  cross-built cFS exe tree (scripts/51)
  variants/<model>_<tag>/ai_learner.so   app built with that model's contract header and budget tag
  variants/<model>_<tag>/cfe_es_startup.scr   startup script whose AI_LEARNER stack = base + kernel bytes
  models/<model>.vmfb, models/<model>_swap.vmfb
Budget tags: 1MiB=1048576, Bm1=B-1, B=B, Bp1=B+1 (B = contract bounded_bytes); corruptsha = header whose
artifact hash is that of the corrupted vmfb (A5b: gate satisfied, runtime must fail safely).
"""
import argparse, json, pathlib

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="results/e14_aarch64_qemu")
    ap.add_argument("--models", default="mlp16k,conv2d,multibranch")
    ap.add_argument("--dynamic", default="dynamic")
    ap.add_argument("--out", default="results/e14_aarch64_qemu/cfs/scenarios.json")
    ap.add_argument("--run-seconds", type=int, default=150)
    ap.add_argument("--refuse-seconds", type=int, default=70)
    ap.add_argument("--a6-seconds", type=int, default=240)
    ap.add_argument("--a7-seconds", type=int, default=210)
    a = ap.parse_args()
    root = pathlib.Path(a.root)
    scs = []
    for m in a.models.split(","):
        c = json.load(open(root / "aarch64" / "contracts" / f"contract.{m}.aarch64.json"))
        B = c["resources"]["bounded_bytes"]
        ks = c["resources"].get("kernel_task_stack_bytes") or 0
        V = lambda tag: (f"variants/{m}_{tag}/ai_learner.so", f"variants/{m}_{tag}/cfe_es_startup.scr")
        def sc(sid, tag, vmfb, secs, expect, desc, commands=None):
            so, st = V(tag)
            scs.append({"id": sid, "model": m, "desc": desc, "so": so, "startup": st, "vmfb": vmfb,
                        "seconds": secs, "commands": commands or [], "expect": expect,
                        "contract_bounded_bytes": B, "contract_kernel_stack_bytes": ks})
        ok = {"admission": "ADMIT", "binding": "MATCH", "cfs_operational": True, "no_crash": True,
              "peak_within_bounded": True, "hal_peak_le_bounded": B, "kernel_stack_accounted": True, "no_failures": True}
        sc(f"A1_{m}", "1MiB", f"models/{m}.vmfb", a.run_seconds, {**ok, "min_completed": 15}, "A1 normal contract, normal vmfb, sufficient budget (1 MiB)")
        sc(f"A2_{m}_Bm1", "Bm1", f"models/{m}.vmfb", a.refuse_seconds, {"admission": "NOT_ADMITTED", "runtime_created": False, "cfs_operational": True, "no_crash": True}, f"A2 budget B-1={B-1}: app refused, cFS OPERATIONAL")
        sc(f"A2_{m}_B", "B", f"models/{m}.vmfb", a.run_seconds, {**ok, "min_completed": 5}, f"A2/SS14-4 budget B={B}: admitted")
        sc(f"A2_{m}_Bp1", "Bp1", f"models/{m}.vmfb", a.run_seconds, {**ok, "min_completed": 5}, f"A2/SS14-4 budget B+1={B+1}: admitted")
        sc(f"A3_{m}_swap", "1MiB", f"models/{m}_swap.vmfb", a.refuse_seconds, {"admission": "ADMIT", "binding": "CONTRACT_ARTIFACT_MISMATCH", "runtime_created": False, "cfs_operational": True, "no_crash": True, "min_cleanup": 1}, "A3 same-ABI model swap: sha mismatch, IREE runtime not created")
        sc(f"A4_{m}_missing", "1MiB", None, a.refuse_seconds, {"admission": "ADMIT", "runtime_created": False, "cfs_operational": True, "no_crash": True}, "A4 model file absent: error event, cleanup, cFS stays")
        sc(f"A5a_{m}_corrupt_gate", "1MiB", {"corrupt_of": f"models/{m}.vmfb", "flip_offset": 4096}, a.refuse_seconds, {"admission": "ADMIT", "binding": "CONTRACT_ARTIFACT_MISMATCH", "runtime_created": False, "cfs_operational": True, "no_crash": True}, "A5a corrupted vmfb (bit flip): caught by the byte-hash gate before the runtime exists")
        sc(f"A5b_{m}_corrupt_runtime", "corruptsha", {"corrupt_of": f"models/{m}.vmfb", "flip_offset": 4096}, a.refuse_seconds, {"admission": "ADMIT", "binding": "MATCH", "runtime_load_failed": True, "cfs_operational": True, "no_crash": True, "min_cleanup": 1}, "A5b corrupted vmfb whose hash the contract carries: IREE load fails, resources recovered, cFS stays")
        sc(f"A6_{m}_repeat", "1MiB", f"models/{m}.vmfb", a.a6_seconds, {**ok, "min_completed": 30}, "A6 repeated inference: attempted == completed, 0 failures")
        sc(f"A7_{m}_restart", "1MiB", f"models/{m}.vmfb", a.a7_seconds, {**ok, "min_init_count": 3, "min_cleanup": 3, "min_completed": 3}, "A7 ES restart x2 then delete: cleanup each time, re-init binds and re-creates runtime, no double free / crash",
           commands=[[60, "es-restart-app", "AI_LEARNER"], [120, "es-restart-app", "AI_LEARNER"], [175, "es-delete-app", "AI_LEARNER"]])
    d = a.dynamic
    scs.append({"id": f"A8_{d}_unknown_bound", "model": d, "desc": "SS12/SS13 negative case: dynamic-shape model, bound_method NONE -> UNKNOWN_BOUND refused before any runtime allocation",
                "so": f"variants/{d}_1MiB/ai_learner.so", "startup": f"variants/{d}_1MiB/cfe_es_startup.scr", "vmfb": f"models/{d}.vmfb",
                "seconds": a.refuse_seconds, "commands": [], "expect": {"admission": "UNKNOWN_BOUND", "runtime_created": False, "cfs_operational": True, "no_crash": True}})
    pathlib.Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    json.dump(scs, open(a.out, "w"), indent=1)
    print(f"{len(scs)} scenarios -> {a.out}")

if __name__ == "__main__":
    main()
