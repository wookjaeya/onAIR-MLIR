#!/usr/bin/env python3
"""E55b SS5 (directive COPY_MAP_ONAIR SS5): connect the OnAIR contribution to the results that
already exist, and run NO new OnAIR experiment.

The directive is explicit on both halves.  SS5.1 keeps one contribution sentence and points it at
E33's official-loader cells.  SS5.3 lists what that sentence may NOT be widened into.  SS5.2 says
the optional four-model / eight-condition table is *not* required here, and building it would be
claiming something this work does not claim -- so it is not built.

Everything below is read out of `results/e33_onair_official/*/run.json`; nothing is re-run and no
number is restated from prose.  Where E33 did not measure something, the field is null with the
reason, never 0 or false (D29/D51/D68) -- which is the whole point of SS5.3: "HAL peak was not
measured" and "output object release is unverified" (D60) are statements about the record, and
turning them into values would be the error this repository has already made four times.
"""
import argparse, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
E33 = "results/e33_onair_official"

# SS5.1 cites three SmartCam conditions.  p_legacy is a fourth E33 cell and is NOT one of them --
# it carries a pre-E40 contract, so its admission is NOT_EVALUATED; it is listed separately so the
# table cannot be read as "four conditions".
CONDITIONS = [
    ("p_admit",    "budget == unconditional bound",          "runs"),
    ("p_deny",     "budget == unconditional bound - 1 byte", "refused at admission"),
    ("p_mismatch", "contract / artifact mismatch",           "refused at binding"),
]


def cell(name):
    p = os.path.join(REPO, E33, name, "run.json")
    if not os.path.isfile(p):
        return {"cell": name, "present": False}
    d = json.load(open(p, encoding="utf-8"))
    init = d.get("plugin_init") or {}
    adm, bind = init.get("admission") or {}, init.get("binding") or {}
    return {"cell": name, "present": True, "raw": os.path.join(E33, name, "run.json"),
            "deployment": d.get("deployment"), "returncode": d.get("returncode"),
            "plugin_constructed": d.get("plugin_constructed"),
            "active": init.get("active"), "inactive_reason": init.get("inactive_reason"),
            "admission_verdict": adm.get("verdict"), "binding_verdict": bind.get("verdict"),
            # WHERE the refusal happened, so a row cannot be misread: p_mismatch is ADMITted by
            # the memory gate (the budget does cover the bound) and then refused by the artifact
            # gate, which is why its admission_verdict is ADMIT and its inference count is 0.
            "refused_at": (None if init.get("active") else
                           ("admission" if adm.get("verdict") not in ("ADMIT", "ADMIT_CONDITIONAL_MAP")
                            else ("binding" if bind.get("verdict") != "MATCH" else "after_both_gates"))),
            "budget_bytes": adm.get("budget_bytes"), "bounded_bytes": adm.get("bounded_bytes"),
            "per_call_bytes": adm.get("per_call_bytes"), "constants_bytes": adm.get("constants_bytes"),
            "admission_mode": ("conditional_map" if adm.get("conditional_available")
                               else "unconditional"),
            "inferences": d.get("inferences"),
            "hal_peak": None,
            "hal_peak_unavailable_reason": ("E33 did not instrument HAL allocation on the OnAIR "
                                            "path; the field is absent from the raw record, not zero"),
            "output_object_release": None,
            "output_object_release_unavailable_reason": ("D60: the raw record of this cell reports "
                                                         "nanobind instances still alive at exit, so "
                                                         "release is UNVERIFIED -- neither released "
                                                         "nor leaked may be written")}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e55b_copy_path/onair_linkage.json")
    a = ap.parse_args()
    rows = [{**cell(n), "condition": c, "expected_role": v} for n, c, v in CONDITIONS]
    legacy = cell("p_legacy")
    doc = {
      "experiment": "E55b SS5", "directive": "docs/reviews/COPY_MAP_ONAIR_RECOMMENDATION_v0.57.md SS5",
      "new_experiment_run": False,
      "new_experiment_note": ("the directive does not require one; this file connects E33's existing "
                              "official-loader cells and nothing was re-executed"),
      "contribution_sentence_ko": ("계약 기반 실행 전 판정을 공식 OnAIR 플러그인 인터페이스에 연결하고, "
                                   "허용 및 거절 시의 실행 동작을 실증했다."),
      "contribution_sentence_source": "directive SS5.1, adopted verbatim",
      "target": "OPS-SAT SmartCam on x86-64, NASA OnAIR official loader (core files unmodified)",
      "conditions": rows,
      "other_e33_cell_not_one_of_the_three": {
          **legacy,
          "why_separate": ("p_legacy carries a pre-E40 contract, so its admission is NOT_EVALUATED. "
                           "It is an E33 cell but not one of the three conditions SS5.1 cites, and "
                           "listing it inline would turn a three-condition table into a four-row one")},
      "optional_table_SS5_2_built": False,
      "optional_table_SS5_2_note": ("SS5.2's four-model eight-condition table is explicitly optional "
                                    "and is only needed when claiming that the verdict code is reused "
                                    "across models. That claim is not made here, so the table is not "
                                    "built -- and SS5.2 also warns that calling the same function "
                                    "twice is a consistency check, not independent verification"),
      "not_claimed": [
        "AArch64 OnAIR: E33 is an x86-64 experiment (SS5.2 last paragraph). Feeding an AArch64 "
        "contract and vmfb through the x86-64 OnAIR path and reporting it as one integrated run is "
        "exactly what the directive forbids",
        "OnAIR memory-bound compliance: the HAL peak was not measured on this path, so repeated-run "
        "compliance is not a claim this evidence supports (SS5.3)",
        "output object lifetime: D60 withdrew the 'released' wording after the raw record showed "
        "nanobind instances alive at exit; the state is UNVERIFIED in both directions",
        "any comparison of OnAIR memory against LiteRT: E42/E43 did not measure it, because the "
        "accounting scopes differ (roadmap SS7.5)",
      ]}
    with open(os.path.join(REPO, a.out), "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=1)
        f.write("\n")
    for r in rows:
        print("%-11s %-40s admission=%-14s refused_at=%-10s active=%-5s inferences=%s"
              % (r["cell"], r["condition"], r.get("admission_verdict"), r.get("refused_at"),
                 r.get("active"), r.get("inferences")))
    print("p_legacy (not one of the three): verdict=%s inferences=%s"
          % (legacy.get("admission_verdict"), legacy.get("inferences")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
