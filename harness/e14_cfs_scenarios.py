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
   "vmfb": "models/mlp16k.vmfb" | null
         | {"corrupt_of": "models/mlp16k.vmfb", "corrupt_method": "flip", "flip_offset": 400000}
         | {"corrupt_of": "models/mlp16k.vmfb", "corrupt_method": "flatbuffer_root_uoffset"},
   "seconds": 150, "commands": [[60, "es-restart-app", "AI_LEARNER"], ...],
   "expect": {"admission": "ADMIT", "binding": "MATCH", "min_completed": 20, "cfs_operational": true, ...}}

Two optional keys wire a cell's *inputs* and its *budget* (E48 SS4-3).  Until E48 both were
done by hand outside this runner (E32/E36/E36b staged /cf/e25_inputs.bin over ssh and exported
AI_LEARNER_BUDGET_OVERRIDE in an ad-hoc shell line), so the scenario file -- the thing the
summary cites -- did not say which inputs a cell replayed or which budget it judged on:

  "stage": {"e25_inputs.bin": "/local/path/inputs.bin"}   -> copied into cpu1/cf/ before the run
  "fetch": ["e25_outputs.bin"]                            -> copied back out of cpu1/cf/ after it
  "env":   {"AI_LEARNER_BUDGET_OVERRIDE": "18222796"}     -> exported for ./core-cpu1 only

cpu1/cf/e25_inputs.bin and e25_outputs.bin are ALWAYS removed before staging, so a cell can
never silently replay the previous cell's inputs: the app switches to equivalence mode purely
on that file's existence (ai_learner.c SS536), which makes a leftover file a mode change nobody
declared.  A cell that wants equivalence mode must say so with "stage".  What was actually
staged and exported is echoed back in the result as `staged`/`env` -- the E38/D69 rule: the
setting a verdict was produced under is recorded next to the verdict, not inferred from it.

A corrupted-vmfb entry MUST name corrupt_method explicitly (harness/corrupt_vmfb.py; external review
F8, docs/reviews/REVIEW_v0_15_LATEST.md, v0.18/E23) -- _corruption_step() below fails closed
(ValueError) on a missing or unrecognized value rather than defaulting to either method.
"""
import argparse, hashlib, json, os, pathlib, re, subprocess, sys, time

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
        # E26: the init-time allocator snapshot (before any inference) and the explicit
        # statement of whether the E25 equivalence mode fired. A memory measurement must
        # be able to PROVE the mode was off -- with it on, 64 inferences run during Init
        # and the run loop's first `mem` record no longer separates init from steady.
        "mem_init": last("mem_init"), "e25_mode": last("e25_mode"),
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
            # D93 (E53): AI_LEARNER_Json's console line buffer (native/cfs_app/fsw/src/
            # ai_learner.c, `char line[768]`) is fixed-size; the "run" stage record embeds
            # the full per-call output array, so a model whose output is large enough
            # (WGAN: ~150K f32 elements) overflows it and the app's own vsnprintf silently
            # truncates the line before the closing brace. parse_log's balanced-brace scan
            # then never finds a match, so the line lands in unparsed_json and `last_run`
            # stays None even though the run genuinely completed (confirmed against the
            # guest's own EVS text and the un-truncated "mem" stage record, printed in the
            # same report block with the identical g.n_infer value). Read "mem" as a
            # fallback -- it carries the same completed count and is never subject to this
            # truncation, since it has no per-call array in it.
            c = (res.get("last_run") or res.get("last_mem") or {}).get("completed", 0)
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
        elif k == "runtime_created":
            # D80 (E48): this used to read `last_run or stack`, and `stack` stopped meaning
            # "the runtime exists" in E16 -- that experiment moved the stack check to the TOP
            # of Init(), BEFORE any resource is acquired, precisely so a refusal happens before
            # allocation.  From then on every refused cell also emits a `stack` record, so
            # `runtime_created: False` became structurally impossible to satisfy: an honest
            # NOT_ADMITTED cell failed the expectation (type B), and symmetrically a cell
            # expecting True would have passed on the stack record alone with no runtime at all.
            # It stayed hidden because the only scenarios using this key (A3/A4/A8, generated by
            # e14_make_scenarios.py) were last run in E14, before the move.
            # `mem_init` is the honest witness: the app emits it after the IREE session and the
            # input buffer exist and before any inference (E26 instrumentation).  The archived
            # E14 cells have neither `mem_init` nor `run`, so their verdicts are unchanged.
            created = bool(res.get("last_run")) or bool(res.get("mem_init")) or bool(res.get("last_mem"))
            if created != v: fails.append(f"runtime_created {created} != {v}")
        elif k == "kernel_stack_accounted":
            s = res.get("stack") or {}
            if s.get("kernel_stack_accounted") != v: fails.append(f"kernel_stack_accounted {s.get('kernel_stack_accounted')} != {v}")
        elif k == "runtime_load_failed" and bool(res.get("runtime_load_failed")) != v: fails.append(f"runtime_load_failed != {v}")
        elif k == "min_cleanup" and sum(1 for c in res["cleanup"]) < v: fails.append(f"cleanup lines {len(res['cleanup'])} < {v}")
        elif k == "e25_mode_active":
            # ABSENT is not "false" (D29's lesson): an app build without the E26 record
            # cannot testify that the mode was off, so it fails this expectation rather
            # than passing by silence.
            m = res.get("e25_mode")
            if m is None: fails.append("e25_mode record absent (app too old to testify); expected active=%r" % (v,))
            elif m.get("active") != v: fails.append(f"e25_mode active {m.get('active')} != {v}")
        elif k == "mem_init_present":
            if v and res.get("mem_init") is None: fails.append("mem_init record absent")
    return fails


CORRUPT_METHODS = ("flip", "flatbuffer_root_uoffset")
_corrupt_vmfb_staged = set()  # remote_root values that already have corrupt_vmfb.py scp'd this run


def _corruption_step(v, tree, remote_root, dry):
    """Build the shell step(s) that turn `{corrupt_of}` into a corrupted
    `{tree}/cf/model.vmfb` on the guest, per v["corrupt_method"].

    Fails closed (raises ValueError) if corrupt_method is missing or
    unrecognized -- external review F8 (docs/reviews/REVIEW_v0_15_LATEST.md)
    found that A5a and A5b previously shared the same unstructured "flip"
    corruption with no method field distinguishing them at all, so a typo'd
    or omitted corrupt_of/method silently fell back to A5a's mechanism even
    for a scenario meant to exercise A5b's structural corruption path.
    """
    method = v.get("corrupt_method")
    if method not in CORRUPT_METHODS:
        raise ValueError(f"vmfb.corrupt_method={method!r} not in {CORRUPT_METHODS} "
                          f"(scenario vmfb={v!r}) -- refusing to guess a corruption mechanism")
    if method == "flip":
        off = v.get("flip_offset", 4096)
        return [f"cp {v['corrupt_of']} {tree}/cf/model.vmfb && python3 -c \"import sys;p='{tree}/cf/model.vmfb';b=bytearray(open(p,'rb').read());b[{off}]^=0xFF;open(p,'wb').write(bytes(b))\""]
    # flatbuffer_root_uoffset: structural corruption (docs/EVIDENCE_v0.12_E17.md §2.1) --
    # done by harness/corrupt_vmfb.py itself (module.fb-aware ZIP surgery), staged onto
    # the guest once per remote_root rather than reimplemented as a one-liner.
    if remote_root not in _corrupt_vmfb_staged and not dry:
        scp_to(HERE / "corrupt_vmfb.py", f"{remote_root}/corrupt_vmfb.py")
        _corrupt_vmfb_staged.add(remote_root)
    entry = v.get("corrupt_entry", "module.fb")
    # `corrupt_vmfb.py` is referenced RELATIVE to the cwd (the chain has already
    # `cd {remote_root}`-ed -- see the NOTE in run_scenario: a remote_root-prefixed
    # path here would resolve to remote_root/remote_root/... and fail the chain).
    return [f"cp {v['corrupt_of']} {tree}/cf/model.vmfb.src && "
            f"python3 corrupt_vmfb.py --method flatbuffer_root_uoffset --entry {entry} "
            f"--in {tree}/cf/model.vmfb.src --out {tree}/cf/model.vmfb"]


def run_scenario(sc, remote_root, out_dir, dry=False):
    sid = sc["id"]
    # NOTE: steps[0] is `cd {remote_root}`, and every later step in this same
    # command chain runs from THAT directory -- so `tree` here must be relative
    # to remote_root ("cpu1"), not remote_root-prefixed, or cp/cd below resolve
    # to remote_root/remote_root/cpu1 and silently fail (bug found E14 Stage 1:
    # scenario runs produced no remote log at all because the first `cp` in the
    # && chain failed).
    tree = "cpu1"
    # E48 SS4-3: equivalence-mode inputs are staged by this runner, not by hand beside it.
    # The unconditional rm is the point -- see the module docstring.
    steps = [f"cd {remote_root}", f"cp {sc['so']} {tree}/cf/ai_learner.so", f"cp {sc['startup']} {tree}/cf/cfe_es_startup.scr",
             f"rm -f {tree}/cf/model.vmfb"]
    # The wipe of the equivalence files runs in its OWN ssh call, BEFORE staging -- never as a
    # step of the chain below.  The first version of this code put it in the chain and so
    # deleted the file it had just scp'd: that cell ran with e25 mode OFF and still reported
    # ADMIT with a correct hal_peak, because nothing about admission depends on the inputs.
    # What caught it was not a test but the E26 hygiene record the app emits unconditionally
    # ({"stage":"e25_mode","active":false}) -- the instrumentation built to PROVE the mode was
    # off proved it was wrongly off.  Hence also the readback below: staged-then-verified.
    wipe = f"rm -f {remote_root}/{tree}/cf/e25_inputs.bin {remote_root}/{tree}/cf/e25_outputs.bin"
    if dry:
        print(f"[pre] {wipe}")
    else:
        ssh(wipe)
    staged = {}
    for name, local in sorted((sc.get("stage") or {}).items()):
        if "/" in name or name in ("", ".", ".."):
            raise ValueError(f"{sid}: stage key must be a bare filename under cf/, got {name!r}")
        lp = pathlib.Path(local)
        if not lp.is_file():
            raise ValueError(f"{sid}: stage source not found: {local}")
        nbytes = lp.stat().st_size
        if not dry:
            scp_to(lp, f"{remote_root}/{tree}/cf/{name}")
            got = ssh(f"stat -c %s {remote_root}/{tree}/cf/{name}", check=False).stdout.strip()
            if got != str(nbytes):
                raise RuntimeError(f"{sid}: staged {name} is {got!r} bytes on the guest, expected {nbytes}")
        staged[name] = {"local": str(lp), "bytes": nbytes,
                        "sha256": hashlib.sha256(lp.read_bytes()).hexdigest(),
                        "verified_on_guest": not dry}
    v = sc.get("vmfb")
    if isinstance(v, str):
        steps.append(f"cp {v} {tree}/cf/model.vmfb")
    elif isinstance(v, dict):
        steps.extend(_corruption_step(v, tree, remote_root, dry))
    secs = int(sc.get("seconds", 120))
    env = {str(k): str(val) for k, val in sorted((sc.get("env") or {}).items())}
    for k in env:
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", k):
            raise ValueError(f"{sid}: env key is not a shell identifier: {k!r}")
        if not re.fullmatch(r"[-+0-9A-Za-z_./:=]*", env[k]):
            raise ValueError(f"{sid}: env value needs quoting, refused: {k}={env[k]!r}")
    env_pfx = "".join(f"{k}={val} " for k, val in env.items())
    steps.append(f"cd {tree} && rm -f {sid}.log && (MALLOC_CHECK_=3 {env_pfx}timeout -s INT -k 15 {secs} ./core-cpu1 > {sid}.log 2>&1; echo EXIT=$? >> {sid}.log)")
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
    fetched = {}
    for name in (sc.get("fetch") or []):
        if "/" in name or name in ("", ".", ".."):
            raise ValueError(f"{sid}: fetch entry must be a bare filename under cf/, got {name!r}")
        dest = out_dir / f"{sid}.{name}"
        try:
            scp_from(f"{remote_root}/{tree}/cf/{name}", dest)
        except subprocess.CalledProcessError:
            # Absence is recorded as absence, never as an empty result (D25/D29/D51).
            fetched[name] = {"present": False, "why": "not produced by the run (scp failed)"}
            continue
        fetched[name] = {"present": True, "path": str(dest), "bytes": dest.stat().st_size,
                         "sha256": hashlib.sha256(dest.read_bytes()).hexdigest()}
    text = local_log.read_text(errors="replace")
    res = parse_log(text)
    res.update({"id": sid, "model": sc.get("model"), "scenario": sc.get("desc"), "seconds": secs, "commands_sent": sent,
                "log": str(local_log), "expect": sc.get("expect"),
                "staged": staged, "env": env, "fetched": fetched})
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
    ap.add_argument("--reparse", action="store_true",
                     help="offline, no SSH: re-run parse_log/check_expect over the ALREADY-FETCHED "
                          "local log for each --only scenario and rewrite its summary.json entry in "
                          "place (D93 / E53). staged/env/fetched/seconds/commands_sent are carried "
                          "over from the previous entry since they cannot be re-derived from the log "
                          "alone. Use this to re-judge a real, already-collected guest run after fixing "
                          "check_expect -- never to substitute for a run that never happened.")
    a = ap.parse_args()
    out = pathlib.Path(a.out); (out / "logs").mkdir(parents=True, exist_ok=True)
    scs = json.load(open(a.scenarios))
    only = [s for s in a.only.split(",") if s]
    results = []
    summ_path = out / "summary.json"
    prev = json.load(open(summ_path)) if summ_path.exists() else {"scenarios": []}
    if a.reparse:
        for sc in scs:
            if only and sc["id"] not in only:
                continue
            sid = sc["id"]
            prior = next((x for x in prev["scenarios"] if x["id"] == sid), None)
            if prior is None:
                raise SystemExit(f"{sid}: no prior summary.json entry to reparse -- run it for real first")
            local_log = out / "logs" / f"{sid}.log"
            if not local_log.exists():
                raise SystemExit(f"{sid}: no local log at {local_log} to reparse")
            text = local_log.read_text(errors="replace")
            res = parse_log(text)
            res.update({"id": sid, "model": sc.get("model"), "scenario": sc.get("desc"),
                        "seconds": prior.get("seconds"), "commands_sent": prior.get("commands_sent", []),
                        "log": str(local_log), "expect": sc.get("expect"),
                        "staged": prior.get("staged", {}), "env": prior.get("env", {}),
                        "fetched": prior.get("fetched", {})})
            res["expect_failures"] = check_expect(res, sc.get("expect"))
            res["pass"] = not res["expect_failures"]
            results.append(res)
            prev["scenarios"] = [x for x in prev["scenarios"] if x["id"] != sid] + [res]
            json.dump(prev, open(summ_path, "w"), indent=2)
            lr = res.get("last_run") or {}
            print(f"[{sid}] reparsed -> {'PASS' if res['pass'] else 'FAIL'}: "
                  f"completed={lr.get('completed')}/{lr.get('attempted')} {res['expect_failures']}", flush=True)
        print(json.dumps({"ran": len(results), "passed": sum(1 for r in results if r["pass"]),
                          "failed": [r["id"] for r in results if not r["pass"]]}))
        return
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
