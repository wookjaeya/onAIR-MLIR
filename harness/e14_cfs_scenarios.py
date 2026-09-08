"""E14 Stage 1: drive cFS AI_LEARNER scenarios A1-A7 (proposal SS11.2) inside the
qemu-system-aarch64 guest from the host, and parse the logs into a summary.

The guest exe tree is the cross-built cFS install (scripts/51_build_cfs_aarch64.sh);
app variants (ai_learner.so built with a given contract header + budget) and
model artifacts are staged next to it.  Each scenario:
  1. installs one variant of cf/ai_learner.so, one cf/cfe_es_startup.scr, and
     one cf/model.vmfb (or none, or a corrupted copy);
  2. runs ./core-cpu1 for a fixed wall time (MALLOC_CHECK_=3 so glibc aborts on
     heap corruption / double free instead of silently continuing);
  3. optionally sends ES commands (restart/delete app) via CI_LAB UDP at given
     offsets (harness/cfs_cmd.py through the hostfwd 1234 port);
  4. copies the log back and extracts every AI_LEARNER JSON line, the EVS
     events of the app, the ES OPERATIONAL transition, app exit / restart lines,
     and crash indicators.

QEMU wall-clock figures (mean_us etc.) are captured but are NOT evidence
(proposal SS14/SS19); the summary marks them as such.

Scenario file (JSON list), one entry per run:
  {"id": "A1_mlp_admit", "model": "mlp16k", "so": "variants/mlp16k_1MiB/ai_learner.so",
   "startup": "variants/mlp16k_1MiB/cfe_es_startup.scr",
   "vmfb": "models/mlp16k.vmfb" | null | {"corrupt_of": "models/mlp16k.vmfb", "flip_offset": 400000},
   "seconds": 150, "commands": [[60, "es-restart-app", "AI_LEARNER"], ...],
   "expect": {"admission": "ADMIT", "binding": "MATCH", "min_completed": 20, "cfs_operational": true, ...}}
"""
import argparse, json, os, pathlib, re, subprocess, sys, time

HERE = pathlib.Path(__file__).resolve().parent
GUEST_DIR = os.environ.get("GUEST_DIR", os.path.expanduser("~/onair-mlir-bench/ext/guest"))
SSH_PORT = os.environ.get("SSH_PORT", "2222")
SSH_OPTS = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-o", "LogLevel=ERROR",
            "-i", f"{GUEST_DIR}/id_ed25519", "-p", SSH_PORT]
CRASH_PATTERNS = ["Segmentation fault", "double free", "free(): invalid", "malloc(): corrupted", "Aborted",
                  "*** Error in", "core dumped", "SIGSEGV", "SIGABRT", "CFE_PSP: Exception"]


def ssh(cmd, check=True, timeout=None):
    r = subprocess.run(["ssh"] + SSH_OPTS + ["ubuntu@127.0.0.1", cmd], capture_output=True, text=True, timeout=timeout)
    if check and r.returncode != 0:
        raise RuntimeError(f"ssh failed ({r.returncode}): {cmd}\n{r.stderr}")
    return r


def scp_to(src, dst):
    subprocess.run(["scp"] + SSH_OPTS[:-2] + ["-P", SSH_PORT, "-r", str(src), f"ubuntu@127.0.0.1:{dst}"], check=True, capture_output=True)


def scp_from(src, dst):
    subprocess.run(["scp"] + SSH_OPTS[:-2] + ["-P", SSH_PORT, "-r", f"ubuntu@127.0.0.1:{src}", str(dst)], check=True, capture_output=True)


def parse_log(text):
    js = []
    for line in text.splitlines():
        # OS_printf lines may be interleaved with EVS text; recover the JSON prefix
        m = re.search(r'\{"app":"AI_LEARNER".*', line)
        if not m:
            continue
        frag = m.group(0)
        # take the longest balanced-brace prefix
        depth = 0
        for i, ch in enumerate(frag):
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    frag = frag[:i + 1]
                    break
        try:
            js.append(json.loads(frag))
        except json.JSONDecodeError:
            js.append({"stage": "unparsed", "raw": frag[:200]})
    evs = [l for l in text.splitlines() if "/AI_LEARNER " in l]
    stages = {}
    for j in js:
        stages.setdefault(j.get("stage"), []).append(j)
    last = lambda s: stages.get(s, [None])[-1]
    exit_m = re.search(r"^EXIT=(\d+)", text, re.M)
    res = {
        "admission": [j.get("verdict") for j in stages.get("admission", [])],
        "binding": [j.get("verdict") for j in stages.get("binding", [])],
        "stack": last("stack"),
        "runtime_load_failed": stages.get("runtime_load_failed"),
        "last_run": last("run"), "last_mem": last("mem"),
        "cleanup": stages.get("cleanup", []),
        "init_count": len(stages.get("admission", [])),
        "cfs_operational": "CFE_ES_Main entering OPERATIONAL state" in text,
        "app_exit_lines": [l for l in text.splitlines() if re.search(r"AI_LEARNER", l) and re.search(r"ExitApp|ErrExit|Exit Application|Restart Application|Delete Application|Stop Application|Restart App", l)],
        "es_restart_events": [l for l in text.splitlines() if re.search(r"CFE_ES .*(Restart|Reload|Stop|Delete) Application.*AI_LEARNER|AI_LEARNER.*(restart|Restart)", l)],
        "evs_ai_learner": evs,
        "crash_indicators": [p for p in CRASH_PATTERNS if p in text],
        "core_exit_code": int(exit_m.group(1)) if exit_m else None,
        "unparsed_json": [j for j in js if j.get("stage") == "unparsed"],
        "note": "mean_us/max_us/last_us are QEMU TCG wall-clock: NOT evidence (proposal SS19)",
    }
    return res


def check_expect(res, exp):
    fails = []
    def last(k): return res[k][-1] if res.get(k) else None
    for k, v in (exp or {}).items():
        if k == "admission" and last("admission") != v: fails.append(f"admission {last('admission')} != {v}")
        elif k == "binding" and last("binding") != v: fails.append(f"binding {last('binding')} != {v}")
        elif k == "min_completed":
            c = (res.get("last_run") or {}).get("completed", 0)
            if c < v: fails.append(f"completed {c} < {v}")
        elif k == "no_failures":
            r = res.get("last_run") or {}
            if any(r.get(f, 0) for f in ("fail_input", "fail_invoke", "fail_output")) or (r and r.get("attempted") != r.get("completed")):
                fails.append(f"failures/attempted!=completed in {r}")
        elif k == "cfs_operational" and res["cfs_operational"] != v: fails.append(f"cfs_operational {res['cfs_operational']} != {v}")
        elif k == "peak_within_bounded":
            m = res.get("last_mem") or {}
            if m.get("peak_within_bounded") != v: fails.append(f"peak_within_bounded {m.get('peak_within_bounded')} != {v}")
        elif k == "hal_peak_le_bounded":
            m = res.get("last_mem") or {}
            if m.get("hal_peak") is None or m["hal_peak"] > v: fails.append(f"hal_peak {m.get('hal_peak')} > {v}")
        elif k == "no_crash" and v and res["crash_indicators"]: fails.append(f"crash indicators {res['crash_indicators']}")
        elif k == "init_count" and res["init_count"] != v: fails.append(f"init_count {res['init_count']} != {v}")
        elif k == "min_init_count" and res["init_count"] < v: fails.append(f"init_count {res['init_count']} < {v}")
        elif k == "runtime_created" and (bool(res.get("last_run")) or bool(res.get("stack"))) != v: fails.append(f"runtime_created != {v}")
        elif k == "kernel_stack_accounted":
            s = res.get("stack") or {}
            if s.get("kernel_stack_accounted") != v: fails.append(f"kernel_stack_accounted {s.get('kernel_stack_accounted')} != {v}")
        elif k == "runtime_load_failed" and bool(res.get("runtime_load_failed")) != v: fails.append(f"runtime_load_failed != {v}")
        elif k == "min_cleanup" and sum(1 for c in res["cleanup"]) < v: fails.append(f"cleanup lines {len(res['cleanup'])} < {v}")
    return fails


def run_scenario(sc, remote_root, out_dir, dry=False):
    sid = sc["id"]
    # NOTE: steps[0] is `cd {remote_root}`, and every later step in this same
    # command chain runs from THAT directory -- so `tree` here must be relative
    # to remote_root ("cpu1"), not remote_root-prefixed, or cp/cd below resolve
    # to remote_root/remote_root/cpu1 and silently fail (bug found E14 Stage 1:
    # scenario runs produced no remote log at all because the first `cp` in the
    # && chain failed).
    tree = "cpu1"
    steps = [f"cd {remote_root}", f"cp {sc['so']} {tree}/cf/ai_learner.so", f"cp {sc['startup']} {tree}/cf/cfe_es_startup.scr", f"rm -f {tree}/cf/model.vmfb"]
    v = sc.get("vmfb")
    if isinstance(v, str):
        steps.append(f"cp {v} {tree}/cf/model.vmfb")
    elif isinstance(v, dict):
        off = v.get("flip_offset", 4096)
        steps.append(f"cp {v['corrupt_of']} {tree}/cf/model.vmfb && python3 -c \"import sys;p='{tree}/cf/model.vmfb';b=bytearray(open(p,'rb').read());b[{off}]^=0xFF;open(p,'wb').write(bytes(b))\"")
    secs = int(sc.get("seconds", 120))
    steps.append(f"cd {tree} && rm -f {sid}.log && (MALLOC_CHECK_=3 timeout -s INT -k 15 {secs} ./core-cpu1 > {sid}.log 2>&1; echo EXIT=$? >> {sid}.log)")
    cmd = " && ".join(steps[:-1]) + " && " + steps[-1]
    print(f"[{sid}] starting ({secs}s) …", flush=True)
    if dry:
        print(cmd); return None
    t0 = time.time()
    p = subprocess.Popen(["ssh"] + SSH_OPTS + ["ubuntu@127.0.0.1", cmd], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)
    sent = []
    for off, *args in sorted(sc.get("commands", []), key=lambda c: c[0]):
        while time.time() - t0 < off and p.poll() is None:
            time.sleep(1)
        if p.poll() is not None:
            break
        r = subprocess.run([sys.executable, str(HERE / "cfs_cmd.py"), "--host", "127.0.0.1", "--port", "1234"] + list(args), capture_output=True, text=True)
        sent.append({"t": round(time.time() - t0, 1), "cmd": args, "rc": r.returncode, "out": r.stdout.strip()[-200:]})
        print(f"[{sid}]   t={sent[-1]['t']}s sent {args} rc={r.returncode}", flush=True)
    p.wait(timeout=secs + 120)
    local_log = out_dir / f"{sid}.log"
    scp_from(f"{remote_root}/{tree}/{sid}.log", local_log)
    text = local_log.read_text(errors="replace")
    res = parse_log(text)
    res.update({"id": sid, "model": sc.get("model"), "scenario": sc.get("desc"), "seconds": secs, "commands_sent": sent,
                "log": str(local_log), "expect": sc.get("expect")})
    res["expect_failures"] = check_expect(res, sc.get("expect"))
    res["pass"] = not res["expect_failures"]
    lr = res.get("last_run") or {}
    print(f"[{sid}] {'PASS' if res['pass'] else 'FAIL'}: admission={res['admission']} binding={res['binding']} completed={lr.get('completed')}/{lr.get('attempted')} "
          f"hal_peak={(res.get('last_mem') or {}).get('hal_peak')} operational={res['cfs_operational']} crash={res['crash_indicators']} exit={res['core_exit_code']} {res['expect_failures']}", flush=True)
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("scenarios", help="JSON list of scenarios")
    ap.add_argument("--remote-root", default="cfs_e14", help="guest dir holding cpu1/, variants/, models/")
    ap.add_argument("--out", default="results/e14_aarch64_qemu/cfs")
    ap.add_argument("--only", default="")
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    out = pathlib.Path(a.out); (out / "logs").mkdir(parents=True, exist_ok=True)
    scs = json.load(open(a.scenarios))
    only = [s for s in a.only.split(",") if s]
    results = []
    summ_path = out / "summary.json"
    prev = json.load(open(summ_path)) if summ_path.exists() else {"scenarios": []}
    for sc in scs:
        if only and sc["id"] not in only:
            continue
        r = run_scenario(sc, a.remote_root, out / "logs", a.dry_run)
        if r:
            results.append(r)
            prev["scenarios"] = [x for x in prev["scenarios"] if x["id"] != r["id"]] + [r]
            json.dump(prev, open(summ_path, "w"), indent=2)
    print(json.dumps({"ran": len(results), "passed": sum(1 for r in results if r["pass"]), "failed": [r["id"] for r in results if not r["pass"]]}))


if __name__ == "__main__":
    main()
