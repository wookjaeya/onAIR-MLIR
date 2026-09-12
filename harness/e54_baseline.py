#!/usr/bin/env python3
"""E54: build baseline.json (R_OS/cFS, R_other_apps) from the M2/M3 guest measurements.

Neither measurement involves a model or a budget: both trees have no ai_learner.so and no
model.vmfb -- the files are physically absent, which each raw record asserts.

    M2 = cFS with the full app suite MINUS AI_LEARNER
    M3 = cFS with libs + lab infrastructure only

The intended decomposition is R_OS_cFS (OS + cFE core + infrastructure) + R_other_apps (the
mission app suite) = M2.  Whether M3 actually resolves the second term is a QUESTION, not an
assumption, so the separability rule is fixed here and applied to the data:

    the configurations separate  <=>  min(M2 reps) > max(M3 reps)

If they do not separate, R_other_apps is set to 0 WITH the reason -- not because the term was
measured as zero (D29/D51/D68 forbid that), but because R_OS_cFS is taken from M2, which
already contains the mission apps; counting them again would double-count.  The distinction
between "measured zero" and "already inside another term" is written into the record.

Overhead rule (plan/tool-wide): every overhead term takes the UPPER end of what was measured.
"""
import argparse, glob, json, os, statistics, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_reps(raw_dir):
    reps = {"m2": [], "m3": []}
    for p in sorted(glob.glob(os.path.join(raw_dir, "e54_m*_rep*.json"))):
        d = json.load(open(p, encoding="utf-8"))
        d["_file"] = os.path.relpath(p, REPO)
        reps.setdefault(d["tag"], []).append(d)
    for tag, rows in reps.items():
        if not rows:
            raise SystemExit(f"E54: no {tag} measurements in {raw_dir} -- refusing to invent one")
        for r in rows:
            if r["ai_learner_present_in_cf"] or r["vmfb_present_in_cf"]:
                raise SystemExit(f"E54: {r['_file']} has an AI artifact in cf/; this baseline "
                                 f"must be model-independent by construction")
    return reps


def summarise(rows, key):
    v = [r[key] for r in rows if isinstance(r.get(key), int)]
    if not v:
        raise SystemExit(f"E54: no usable {key} samples")
    return {"n": len(v), "min": min(v), "max": max(v), "median": statistics.median(v), "values": v}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw-dir", default="results/e54_reference_budget/baseline/raw")
    ap.add_argument("--out", default="results/e54_reference_budget/baseline/baseline.json")
    a = ap.parse_args()

    raw_dir = os.path.join(REPO, a.raw_dir)
    reps = load_reps(raw_dir)

    # VmHWM is the kernel's own high-water mark: independent of our polling cadence, which is
    # coarse under TCG emulation (a nominal 0.25 s loop lands ~40 samples in 90 s).
    m2 = summarise(reps["m2"], "core_cpu1_vmhwm_kb")
    m3 = summarise(reps["m3"], "core_cpu1_vmhwm_kb")
    sysused = summarise(reps["m2"] + reps["m3"], "system_used_before_kb")
    harness = summarise(reps["m2"] + reps["m3"], "harness_sshd_bash_systemd_rss_before_kb")

    separable = m2["min"] > m3["max"]
    if separable:
        r_other_apps_kb = m2["max"] - m3["max"]
        note = (f"separable: min(M2)={m2['min']} kB > max(M3)={m3['max']} kB across "
                f"{m2['n']}+{m3['n']} runs; R_other_apps = max(M2) - max(M3)")
        r_os_cfs_kb = sysused["max"] + m3["max"]
    else:
        r_other_apps_kb = 0
        note = (f"NOT separable: min(M2)={m2['min']} kB is not above max(M3)={m3['max']} kB "
                f"(M2 {m2['values']}, M3 {m3['values']}). cFS loads every app as a .so into ONE "
                f"process, so run-to-run variation of that single VmRSS is comparable to the "
                f"mission apps' contribution. R_other_apps is therefore 0 NOT because it was "
                f"measured as zero, but because R_OS_cFS is taken from M2, which already "
                f"contains the mission apps -- adding it again would double-count.")
        r_os_cfs_kb = sysused["max"] + m2["max"]

    out = {
        "experiment": "E54",
        "measurement": "cFS baseline with NO AI_LEARNER and NO model artifact",
        "m2": {"description": "full app suite minus ai_learner",
               "apps_emitting_evs": sorted({r["apps_emitting_evs"] for r in reps["m2"]}),
               "startup_apps_declared": sorted({r["startup_apps_declared"] for r in reps["m2"]}),
               "core_cpu1_vmhwm_kb": m2, "raw": [r["_file"] for r in reps["m2"]]},
        "m3": {"description": "libs + lab infrastructure only",
               "apps_emitting_evs": sorted({r["apps_emitting_evs"] for r in reps["m3"]}),
               "startup_apps_declared": sorted({r["startup_apps_declared"] for r in reps["m3"]}),
               "core_cpu1_vmhwm_kb": m3, "raw": [r["_file"] for r in reps["m3"]]},
        "guest_system_used_before_cfs_kb": sysused,
        "harness_rss_included_in_system_used_kb": harness,
        "harness_note": "These measurements are taken over ssh, so sshd/bash/systemd RSS is inside "
                        "system_used_before. It is NOT subtracted: leaving it in enlarges the "
                        "overhead and therefore shrinks the budget, which is the safe direction "
                        "and is applied uniformly rather than chosen per result.",
        "separability_rule": "configs separate iff min(M2 VmHWM) > max(M3 VmHWM)",
        "separable": separable,
        "r_other_apps_note": note,
        "r_os_cfs_bytes": r_os_cfs_kb * 1024,
        "r_os_cfs_derivation": ("max(guest system used before cFS, harness included) + "
                                + ("max(M3 VmHWM)" if separable else "max(M2 VmHWM)")),
        "r_other_apps_bytes": r_other_apps_kb * 1024,
        "scope": "process/system RAM (NOT HAL device allocation -- see budgets.json scope_note)",
    }
    dest = os.path.join(REPO, a.out)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    with open(dest, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"wrote {a.out}")
    print(f"  M2 VmHWM kB {m2['values']}   M3 VmHWM kB {m3['values']}")
    print(f"  separable={separable}")
    print(f"  R_OS_cFS   = {out['r_os_cfs_bytes']:,} B")
    print(f"  R_other_apps = {out['r_other_apps_bytes']:,} B")
    return 0


if __name__ == "__main__":
    sys.exit(main())
