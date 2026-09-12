#!/usr/bin/env python3
"""E54: turn the ALREADY-COMMITTED budgets.json into guest scenario files.

This script never decides a budget.  Part 1 budgets are read verbatim from budgets.json
(committed before any cell ran).  Part 2 budgets come from a power-of-two grid that is fixed
independently of every model: the two grid points that bracket U.  That grid is not a function
of any contract value the way `U-1` is, which is why the directive's objection to `U-1` as
evidence does not apply to it -- and it is still NOT a mission budget (plan SS8).

The two parts are emitted as SEPARATE scenario files and carry a `part` field, so nothing
downstream can merge a reference profile with a sensitivity sweep into one deployment story.
"""
import argparse, json, os, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Which guest tree holds each model, and the input replayed by an admitted cell.
# admit_seconds is sized from OBSERVED inference rates, not guessed: E48 saw 204 inferences in
# 900 s (b2_resnet), 148 in 600 s (b3_deepae) and 282 in 2400 s (smartcam); E53 saw 4 in 10800 s
# (wgan).  The pass criterion needs >= 1 inference, so each window is set to comfortably exceed
# boot + one inference at that observed rate.  DENY_SECONDS matches the 180 s E48 used.
DEPLOY = {
    "b2_resnet": {"root": "cfs_e48", "vmfb": "models/b2_resnet.vmfb",
                  "so": "variants/b2_resnet/ai_learner.so",
                  "startup": "variants/b2_resnet/cfe_es_startup.scr", "admit_seconds": 300},
    "b3_deepae": {"root": "cfs_e48", "vmfb": "models/b3_deepae.vmfb",
                  "so": "variants/b3_deepae/ai_learner.so",
                  "startup": "variants/b3_deepae/cfe_es_startup.scr", "admit_seconds": 300},
    "smartcam": {"root": "cfs_e48", "vmfb": "models/smartcam.vmfb",
                 "so": "variants/smartcam/ai_learner.so",
                 "startup": "variants/smartcam/cfe_es_startup.scr", "admit_seconds": 420},
    "wgan": {"root": "e53_wgan", "vmfb": "models/wgan.vmfb",
             "so": "variants/wgan/ai_learner.so",
             "startup": "variants/wgan/cfe_es_startup.scr", "admit_seconds": 3000,
             "stage": {"e25_inputs.bin": "results/e53_wgan_aarch64/e25_inputs_1sample.bin"}},
}
DENY_SECONDS = 180


def bracket(u):
    """The two power-of-two grid points bracketing U: 2^k < U <= 2^(k+1)."""
    k = 0
    while (1 << (k + 1)) < u:
        k += 1
    return 1 << k, 1 << (k + 1)


def cell(cid, part, model, budget, expect_admit, note):
    d = DEPLOY[model]
    sc = {
        "id": cid, "part": part, "model": model,
        "desc": note,
        "so": d["so"], "startup": d["startup"], "vmfb": d["vmfb"],
        "seconds": d["admit_seconds"] if expect_admit else DENY_SECONDS,
        "env": {"AI_LEARNER_BUDGET_OVERRIDE": str(budget)},
        "expect": {"admission": "ADMIT" if expect_admit else "NOT_ADMITTED",
                   "min_completed": 1 if expect_admit else 0},
    }
    if expect_admit and "stage" in d:
        sc["stage"] = d["stage"]
        sc["fetch"] = ["e25_outputs.bin"]
    return sc


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--budgets", default="results/e54_reference_budget/budgets.json")
    ap.add_argument("--outdir", default="results/e54_reference_budget")
    a = ap.parse_args()

    b = json.load(open(os.path.join(REPO, a.budgets), encoding="utf-8"))
    by_root = {}

    for c in b["cells"]:
        m = c["model"]
        sc = cell(c["cell_id"], "part1_reference_profile", m, c["B_contract_bytes"],
                  c["predicted_verdict"] == "ADMIT",
                  f"E54 Part 1: reference budget {c['budget_profile_id']} "
                  f"(B_contract={c['B_contract_bytes']}, U={c['U_bounded_bytes']})")
        by_root.setdefault(DEPLOY[m]["root"], {}).setdefault("part1", []).append(sc)

    for m, mm in b["models"].items():
        u = mm["U_bounded_bytes"]
        lo, hi = bracket(u)
        if not (lo < u <= hi):
            raise SystemExit(f"E54: bracket({u}) = ({lo}, {hi}) does not bracket U")
        by_root.setdefault(DEPLOY[m]["root"], {}).setdefault("part2", []).extend([
            cell(f"sweep_{m}_pow2_below", "part2_sensitivity_sweep", m, lo, False,
                 f"E54 Part 2 (NOT a mission budget): power-of-two grid point {lo} < U={u}"),
            cell(f"sweep_{m}_pow2_above", "part2_sensitivity_sweep", m, hi, True,
                 f"E54 Part 2 (NOT a mission budget): power-of-two grid point {hi} >= U={u}"),
        ])

    total = 0
    for root, parts in sorted(by_root.items()):
        for part, cells in sorted(parts.items()):
            p = os.path.join(REPO, a.outdir, f"scenarios_{root}_{part}.json")
            with open(p, "w", encoding="utf-8") as f:
                json.dump(cells, f, indent=2)
                f.write("\n")
            total += len(cells)
            print(f"{len(cells):2d} cells -> {os.path.relpath(p, REPO)}  (remote root: {root})")
    print(f"total {total} cells")
    return 0


if __name__ == "__main__":
    sys.exit(main())
