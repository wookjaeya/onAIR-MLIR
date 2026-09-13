#!/usr/bin/env python3
"""E54: reference-based deployment memory budgets, computed BEFORE any admission cell runs.

    R_usable(p)          = R_physical(p) * (1 - M_phase)
    B_AI(p)              = R_usable(p) - R_OS_cFS - R_other_apps - R_reserved
    B_contract(p, model) = B_AI(p) - R_noncontract_AI(model)
    ADMIT(model | p)    <=>  U(model) <= B_contract(p, model)

Nothing here reads a model's U to pick a budget.  `R_noncontract_AI` depends on the model
only through terms the contract itself declares as EXCLUDED from U (accounting_rules.excluded):
the IREE runtime context, the module image, the task stack, and the app's own static I/O
buffers.  That dependency is the formula of the directive (SS4.3), not a tuning knob.

Overhead rule, fixed in advance and applied uniformly: every overhead term takes the UPPER
end of what was measured.  That direction shrinks budgets (makes ADMIT harder), so it cannot
have been chosen to manufacture an ADMIT -- and it is outcome-independent either way.

Scope reconciliation (plan SS2.5): B_* are process/system-RAM quantities and U is a HAL
device-allocation quantity.  They are comparable here only because this deployment's driver
is local-sync with an in-process heap allocator, so HAL bytes are a SUBSET of process RSS.
This does NOT license "HAL peak == RSS" (D78 measured a 1.87x gap in the other direction).
"""
import argparse, glob, json, os, re, statistics, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --- Reference platforms.  Values transcribed from sources fetched in this session; the
#     source manifest (results/e54_reference_budget/sources/) carries URL + sha256 + quote.
PLATFORMS = {
    "PA": {
        "name": "Xiphos Q8S",
        "r_physical_bytes": 4 * 1024 * 1024 * 1024,
        "isa": "AArch64 (quad Cortex-A53)",
        "source_grade": "mirror_adjacent_revision_fetched",
        "note": "same core family as this guest's -cpu cortex-a53",
    },
    "PB": {
        "name": "OPS-SAT SEPP (RAM envelope only)",
        "r_physical_bytes": 1 * 1024 * 1024 * 1024,
        "isa": "ARM 32-bit (Cortex-A9 class) -- NOT this guest's ISA",
        "source_grade": "primary_fetched",
        "note": "RAM envelope only; platform reproduction is forbidden (BENCHMARK_PLAN_REFERENCE_BASED.md:156)",
    },
}

# --- Lifecycle margins.  The primary NASA sources (SWE-109, 9.12 Resource Margins,
#     NPR 7150.2D ch.5, SWE-111) were unreachable on every path tried in this session
#     (curl 000 / WebFetch EGRESS_BLOCKED -- see sources/probe_log.json).  These percentages
#     therefore appear in NO fetched bytes and are graded accordingly.  Never cite them as
#     a primary-source quotation (plan SS8).
MARGINS = {
    "pdr50": {"fraction": 0.50, "phase": "PDR", "grade": "transcribed_from_directive_primary_blocked"},
    "ship30": {"fraction": 0.30, "phase": "Ship/Flight", "grade": "transcribed_from_directive_primary_blocked"},
}

AI_LEARNER_STACK_BASE_BYTES = 262144  # cFS startup stack base the build writes (WIRING.md rule)

MODELS = {
    "b2_resnet": "results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json",
    "b3_deepae": "results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json",
    "smartcam": "results/e32_smartcam_aarch64/build/smartcam.contract.json",
    "wgan": "results/e53_wgan_aarch64/build/aarch64/wgan.contract.json",
}

APP_SRC = "native/cfs_app/fsw/src/ai_learner.c"
# float out[CONTRACT_OUTPUT_ELEMS];  /  static char outs[CONTRACT_OUTPUT_ELEMS * 16 + 8];
_BUF_RE = re.compile(
    r"\b(float|double|char|int|uint8)\s+(\w+)\s*\[\s*CONTRACT_(INPUT|OUTPUT)_ELEMS"
    r"(?:\s*\*\s*(\d+))?(?:\s*\+\s*(\d+))?\s*\]")
_CTYPE_BYTES = {"float": 4, "double": 8, "char": 1, "int": 4, "uint8": 1}


def app_io_buffer_terms(src_path):
    """Count the app's contract-sized static buffers BY READING THE SOURCE.

    The plan's prose named three of them (4*in + 4*out + 16*out).  Counting finds six.
    Counting, not quoting, is the rule (E44): a term that exists in the binary but not in
    the prose would otherwise be silently omitted from the overhead.
    """
    txt = open(os.path.join(REPO, src_path), encoding="utf-8").read()
    terms = []
    for ctype, name, which, mult, addend in _BUF_RE.findall(txt):
        terms.append({
            "name": name, "ctype": ctype, "elems_of": which.lower(),
            "bytes_per_elem": _CTYPE_BYTES[ctype] * (int(mult) if mult else 1),
            "constant_addend_bytes": int(addend) if addend else 0,
        })
    if not terms:
        raise SystemExit(f"E54: no contract-sized app buffers found in {src_path} -- refusing to "
                         f"report an overhead of zero (absence is not zero)")
    return terms


def app_io_buffer_bytes(terms, in_elems, out_elems):
    total = 0
    for t in terms:
        n = in_elems if t["elems_of"] == "input" else out_elems
        total += t["bytes_per_elem"] * n + t["constant_addend_bytes"]
    return total


def iree_fixed_runtime_ctx(results_root):
    """Derive the IREE runtime context cost from ARCHIVED AArch64 mem_init records.

    ai_learner.c samples rss_kb_before_runtime at :446 (after the blob is read and hashed)
    and rss_kb_after_session at :461 (immediately BEFORE append_bytecode_module).  So the
    delta spans exactly instance+device+session creation: it excludes the module image and
    excludes any constants copy, and therefore double-counts nothing that is inside U.
    """
    obs = []
    for path in glob.glob(os.path.join(results_root, "**", "*.log"), recursive=True):
        try:
            txt = open(path, encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        for m in re.finditer(r'\{"app":"AI_LEARNER","stage":"mem_init".*?\}', txt):
            try:
                d = json.loads(m.group(0))
            except ValueError:
                continue
            if "aarch64" not in str(d.get("target", "")):
                continue
            b, a = d.get("rss_kb_before_runtime"), d.get("rss_kb_after_session")
            if not isinstance(b, int) or not isinstance(a, int):
                continue
            obs.append({"model": d.get("model"), "delta_kb": a - b,
                        "source": os.path.relpath(path, REPO)})
    if not obs:
        raise SystemExit("E54: no archived AArch64 mem_init records found -- refusing to "
                         "substitute 0 for an unmeasured term (D29/D51/D68)")
    deltas = [o["delta_kb"] for o in obs]
    return {
        "observations": len(obs),
        "models_seen": sorted({o["model"] for o in obs}),
        "delta_kb_min": min(deltas), "delta_kb_max": max(deltas),
        "delta_kb_median": statistics.median(deltas),
        "chosen_kb": max(deltas),
        "chosen_bytes": max(deltas) * 1024,
        "rule": "max over archived AArch64 cells (overhead terms take the upper end)",
        "spans": "iree_runtime_instance_create + device + session_create; excludes module "
                 "image and module append (ai_learner.c:446 -> :461)",
        "per_observation": obs,
    }


def load_baseline(path):
    d = json.load(open(path, encoding="utf-8"))
    return d


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--baseline", default="results/e54_reference_budget/baseline/baseline.json")
    ap.add_argument("--out", default="results/e54_reference_budget/budgets.json")
    a = ap.parse_args()

    base = load_baseline(os.path.join(REPO, a.baseline))
    terms = app_io_buffer_terms(APP_SRC)
    iree_ctx = iree_fixed_runtime_ctx(os.path.join(REPO, "results"))

    r_os_cfs = base["r_os_cfs_bytes"]
    r_other_apps = base["r_other_apps_bytes"]
    r_other_apps_note = base["r_other_apps_note"]
    r_reserved = 0  # E44: no reservation-capable call exists in 85 source files; declared, not enforced.

    models = {}
    for name, rel in MODELS.items():
        c = json.load(open(os.path.join(REPO, rel), encoding="utf-8"))
        res = c["resources"]
        in_b = res["static_external_input_bytes"]
        out_b = res["static_external_output_bytes"]
        in_elems, out_elems = in_b // 4, out_b // 4  # f32 interface (CONTRACT_DTYPES_ALL_F32)
        stack = res.get("kernel_task_stack_invocation_bytes")
        if stack is None:
            stack = res.get("kernel_task_stack_bytes")
        if stack is None:
            raise SystemExit(f"E54: {name} declares no kernel task stack -- refusing to use 0")
        io_b = app_io_buffer_bytes(terms, in_elems, out_elems)
        artifact_b = res["binary_size_bytes"]
        r_nc = iree_ctx["chosen_bytes"] + artifact_b + AI_LEARNER_STACK_BASE_BYTES + stack + io_b
        models[name] = {
            "contract_path": rel,
            "U_bounded_bytes": res["bounded_bytes"],
            "static_per_call_bytes": res["static_per_call_bytes"],
            "module_resident_constant_bytes": res["module_resident_constant_bytes"],
            "input_elems": in_elems, "output_elems": out_elems,
            "R_noncontract_AI_bytes": r_nc,
            "R_noncontract_AI_terms": {
                "iree_fixed_runtime_ctx_bytes": iree_ctx["chosen_bytes"],
                "module_image_artifact_bytes": artifact_b,
                "task_stack_base_bytes": AI_LEARNER_STACK_BASE_BYTES,
                "task_stack_kernel_bytes": stack,
                "app_static_io_buffer_bytes": io_b,
            },
        }

    profiles, cells = {}, []
    for pid, p in PLATFORMS.items():
        for mid, m in MARGINS.items():
            prof = f"{pid}_{mid}"
            usable = int(p["r_physical_bytes"] * (1.0 - m["fraction"]))
            b_ai = usable - r_os_cfs - r_other_apps - r_reserved
            profiles[prof] = {
                "platform": pid, "platform_name": p["name"],
                "platform_isa": p["isa"], "platform_source_grade": p["source_grade"],
                "margin_id": mid, "margin_phase": m["phase"],
                "margin_fraction": m["fraction"], "margin_source_grade": m["grade"],
                "R_physical_bytes": p["r_physical_bytes"],
                "R_usable_bytes": usable,
                "R_OS_cFS_bytes": r_os_cfs,
                "R_other_apps_bytes": r_other_apps,
                "R_other_apps_note": r_other_apps_note,
                "R_reserved_bytes": r_reserved,
                "R_reserved_note": "0 by declaration: no mission-declared reservation, and E44 "
                                   "counted 0 reservation-capable calls in 85 source files",
                "B_AI_bytes": b_ai,
            }
            for name, mm in models.items():
                b_contract = b_ai - mm["R_noncontract_AI_bytes"]
                cells.append({
                    "cell_id": f"{prof}__{name}",
                    "budget_profile_id": prof, "model": name,
                    "B_contract_bytes": b_contract,
                    "U_bounded_bytes": mm["U_bounded_bytes"],
                    "predicted_verdict": "ADMIT" if mm["U_bounded_bytes"] <= b_contract else "NOT_ADMITTED",
                    "headroom_bytes": b_contract - mm["U_bounded_bytes"],
                })

    out = {
        "experiment": "E54",
        "plan": "docs/plans/E54_reference_budget_admission.md",
        "directive": "docs/reviews/BUDGET_BASED_ADMISSION_ANALYSIS.md",
        "formula": "B_contract(p,m) = R_physical(p)*(1-M) - R_OS_cFS - R_other_apps - R_reserved "
                   "- R_noncontract_AI(m)",
        "overhead_rule": "every overhead term takes the upper end of what was measured",
        "scope_note": "B_* are process/system RAM; U is HAL device allocation. Comparable only "
                      "because local-sync allocates HAL buffers on the in-process heap, so HAL "
                      "bytes are a subset of process RSS. Not a licence for 'HAL peak == RSS' (D78).",
        "platforms": PLATFORMS,
        "margins": MARGINS,
        "baseline": base,
        "iree_fixed_runtime_ctx": iree_ctx,
        "app_io_buffer_terms": terms,
        "app_io_buffer_terms_note":
            "counted from " + APP_SRC + " (E44: count, do not quote). The plan's prose named "
            "three terms; counting finds " + str(len(terms)) + ".",
        "models": models,
        "profiles": profiles,
        "cells": cells,
    }
    dest = os.path.join(REPO, a.out)
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    with open(dest, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2, sort_keys=False)
        f.write("\n")
    print(f"wrote {a.out}: {len(profiles)} profiles x {len(models)} models = {len(cells)} cells")
    for c in cells:
        print(f"  {c['cell_id']:28s} B_contract={c['B_contract_bytes']:>14,}  "
              f"U={c['U_bounded_bytes']:>12,}  -> {c['predicted_verdict']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
