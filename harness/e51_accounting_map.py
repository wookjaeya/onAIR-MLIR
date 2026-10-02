#!/usr/bin/env python3
"""E51 stage 3 -- U / B / H accounting map, per core cell.

The twelfth external review (docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.3) asks that for
each core experiment cell it be traceable WHICH FIELD AND LOG produced the static
bound U, the deployment budget B and the observed peak H, and that the included /
excluded regions read under the SAME definition.

Two things this tool deliberately does not do (docs/plans/E51_claim_preconditions.md SS3):

  * It does not regenerate archived contracts. E47 measured that regenerating from a
    reduced dump degrades two provenance fields.
  * It does not recompute any value. Every number here is READ from raw data at a
    recorded locator; the only derived cells are comparisons BETWEEN read values.

And it does not invent a second home for facts that already have one. E44's lesson
("count whether the required field already exists") applies directly: the definitions
live in results/e49_research_audit/audit_matrix.json::accounting_scope and are CITED
from there rather than retyped (D65), and the overlap with
results/evidence_linkage/linkage.json is measured and reported instead of duplicated.
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

# The SAME three contract numbers are stored under two different spellings by two
# summary generators: mk_e36_summary writes bounded/per_call/constants, mk_e36b_summary
# and mk_e48_summary write bounded_bytes/static_per_call_bytes/module_resident_constant_bytes.
# No archived summary is rewritten for this (that would be retroactive editing); the
# aliases are declared EXPLICITLY -- not matched fuzzily, because over-general matching is
# itself a defect (D76) -- and each row records which spelling it read.
U_ALIASES = {
    "bounded_bytes": ("bounded_bytes", "bounded"),
    "static_per_call_bytes": ("static_per_call_bytes", "per_call"),
    "module_resident_constant_bytes": ("module_resident_constant_bytes", "constants"),
}


def read_u(con):
    vals, spellings = {}, {}
    for canon, names in U_ALIASES.items():
        for n in names:
            if n in con and con[n] is not None:
                vals[canon] = con[n]
                spellings[canon] = n
                break
        else:
            vals[canon] = None
            spellings[canon] = None
    return vals, spellings


SOURCES = [
    {"id": "e36_smartcam_aarch64_cfs", "path": "results/e36_aarch64_cfs/summary.json",
     "contract_at": ["contract"], "cells_at": ["cells"]},
    {"id": "e36b_resnet_deepae_aarch64", "path": "results/e36b_aarch64_models/summary.json",
     "contract_at": ["models", "*", "contract"], "cells_at": ["models", "*"]},
    {"id": "e48_real_inputs_aarch64", "path": "results/e48_real_inputs_aarch64/summary.json",
     "contract_at": ["models", "*", "contract"], "cells_at": ["models", "*"]},
]

# What identifies a cell: it reports an observed peak, or it reports a verdict with a
# budget. Detected structurally so a new cell in a summary appears here without this
# tool being edited (E48: a literal cell count in two places had to be fixed).
def is_cell(v):
    return isinstance(v, dict) and (
        "hal_peak" in v or ("verdict" in v and ("budget_bytes" in v or "budget" in v)))


def walk_cells(node, path=()):
    if is_cell(node):
        yield ".".join(path), node
        return
    if isinstance(node, dict):
        for k, v in node.items():
            yield from walk_cells(v, path + (k,))


def get_at(doc, spec):
    """Resolve a locator spec with '*' meaning 'every key at this level'.
    Returns {joined_path: value}."""
    out = {}

    def rec(node, spec, path):
        if not spec:
            out[".".join(path)] = node
            return
        head, rest = spec[0], spec[1:]
        if not isinstance(node, dict):
            return
        keys = list(node) if head == "*" else ([head] if head in node else [])
        for k in keys:
            rec(node[k], rest, path + (k,))

    rec(doc, spec, ())
    return out


def nearest_contract(contracts, cell_path):
    """The contract whose locator is the longest prefix of this cell's path."""
    best = None
    for cpath, cval in contracts.items():
        # drop the trailing 'contract' segment; a top-level "contract" key has no
        # dot, so its scope is the document ROOT (''), not the literal name -- the
        # first version returned "contract" there and E36's five cells resolved to
        # no contract at all (7 problems, 0 rows from that source).
        prefix = cpath.rsplit(".", 1)[0] if "." in cpath else ""
        if cell_path == prefix or cell_path.startswith(prefix + ".") or prefix == "":
            if best is None or len(prefix) > len(best[0]):
                best = (prefix, cpath, cval)
    return best


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="results/e51_claim_preconditions/stage3_accounting_map.json")
    a = ap.parse_args()

    # --- definitions: CITED from E49's audit matrix, not retyped here ---------
    am_path = "results/e49_research_audit/audit_matrix.json"
    with open(os.path.join(ROOT, am_path), encoding="utf-8") as fh:
        am = json.load(fh)
    scope = am.get("accounting_scope")
    definitions = {"cited_from": am_path + "::accounting_scope",
                   "definitions": scope,
                   "missing": scope is None}

    rows, problems = [], []
    for src in SOURCES:
        p = os.path.join(ROOT, src["path"])
        if not os.path.isfile(p):
            problems.append({"source": src["path"], "unavailable_reason": "file not found"})
            continue
        with open(p, encoding="utf-8") as fh:
            doc = json.load(fh)
        contracts = get_at(doc, src["contract_at"])
        cells_root = get_at(doc, src["cells_at"])
        for root_path, root_node in cells_root.items():
            for sub, cell in walk_cells(root_node):
                cell_path = ".".join(x for x in (root_path, sub) if x)
                nc = nearest_contract(contracts, cell_path)
                if nc is None:
                    problems.append({"source": src["path"], "cell": cell_path,
                                     "unavailable_reason": "no contract block resolves for this cell"})
                    continue
                cpref, cloc, con = nc
                admitted = cell.get("admitted_budget_bytes")
                mode = cell.get("admission_mode")
                u_vals, u_spellings = read_u(con)
                # WHICH U the admitted budget equals -- a comparison of read values,
                # not a recomputation. `null` when the cell did not record one.
                which_u = None
                if admitted is not None:
                    for k, v in u_vals.items():
                        if v is not None and v == admitted:
                            which_u = k
                            break
                h = cell.get("hal_peak")
                rows.append({
                    "source": src["path"], "cell": cell_path,
                    "verdict": cell.get("verdict"),
                    "admission_mode": mode,
                    "U": {"values": u_vals,
                          "key_spelling_used": u_spellings,
                          "read_from": "%s::%s" % (src["path"], cloc),
                          "produced_by": "harness/make_contract.py (compile-time)"},
                    "B": {"budget_bytes": cell.get("budget_bytes", cell.get("budget")),
                          "budget_source": cell.get("budget_source"),
                          "absence_is_stated": (True if cell.get("budget_invalid_event") else None),
                          "absence_reason": ("budget_invalid_event: 앱이 예산을 파싱하지 못해 초기화를 "
                                             "거부했다 — 예산이 '0' 인 것이 아니라 '없다'"
                                             if cell.get("budget_invalid_event") else None),
                          "admitted_budget_bytes": admitted,
                          "read_from": "%s::%s" % (src["path"], cell_path),
                          "scope": "per_app_local_budget"},
                    "H": {"hal_peak": h,
                          "peak_within_admitted_budget": cell.get("peak_within_admitted_budget"),
                          "read_from": ("%s::%s.hal_peak" % (src["path"], cell_path)) if h is not None else None,
                          "absent_reason": None if h is not None else
                              ("이 셀은 추론을 하지 않았다 (verdict=%s) — HAL 피크가 없는 것이 "
                               "0 이라는 뜻이 아니다" % cell.get("verdict")),
                          "produced_by": "IREE HAL allocator statistics (runtime)"},
                    "admitted_budget_equals": which_u,
                    "H_le_admitted": (None if (h is None or admitted is None) else h <= admitted),
                    "inferences": cell.get("inferences"),
                })

    # --- overlap audit: what already exists elsewhere -------------------------
    link_path = "results/evidence_linkage/linkage.json"
    overlap = {"checked": link_path, "present": False}
    lp = os.path.join(ROOT, link_path)
    if os.path.isfile(lp):
        with open(lp, encoding="utf-8") as fh:
            link = json.load(fh)
        locs = set()
        for mv in (link.get("models") or {}).values():
            for it in (mv.get("items") or {}).values():
                for s in it.get("sources") or []:
                    locs.add("%s::%s" % (s.get("path"), s.get("locator")))
        hit = sum(1 for r in rows if (r["H"]["read_from"] or "") in locs
                  or any(x in locs for x in (r["B"]["read_from"] + ".hal_peak",)))
        overlap = {"checked": link_path, "present": True,
                   "linkage_locator_count": len(locs),
                   "rows_whose_H_locator_already_in_linkage": hit,
                   "note": ("연결표는 셀마다 값을 이미 싣고 있다. 이 표가 더하는 것은 값이 아니라 "
                            "**U·B·H 를 한 정의 아래 한 행으로 놓는 매핑**이다 — 새 수치를 만들지 "
                            "않는다는 것이 이 단계의 제약이다(계획 SS3).")}

    # A cell counts as resolved when U resolves AND B is either a value or an absence
    # the raw data itself explains. E36's malformed_abc / zero_budget cells have no
    # budget BY CONSTRUCTION (budget_invalid_event) -- requiring a number there would
    # mark two honest fail-closed cells as gaps, which is the type (B) shape this
    # project keeps re-finding.
    resolved = [r for r in rows if r["U"]["values"]["bounded_bytes"] is not None
                and (r["B"]["budget_bytes"] is not None or r["B"]["absence_is_stated"])]
    sound = [r for r in rows if r["H_le_admitted"] is False]
    out = {
        "tool": "harness/e51_accounting_map.py",
        "experiment": "E51", "stage": 3,
        "plan": "docs/plans/E51_claim_preconditions.md SS3",
        "review": "docs/reviews/DECISIONS_v0_52_REVIEW.md SS5.3",
        "does_not": ["보관 계약 재생성", "값 재계산", "이미 있는 사실의 두 번째 사본"],
        "definitions": definitions,
        "rows": rows,
        "row_count": len(rows),
        "rows_with_U_and_B_resolved": len(resolved),
        "rows_violating_H_le_admitted": [r["cell"] for r in sound],
        "problems": problems,
        "overlap_audit": overlap,
        "field_name_drift": {
            "what": ("같은 세 수치가 요약 생성기마다 다른 이름으로 저장돼 있다 — "
                     "mk_e36_summary: bounded/per_call/constants, "
                     "mk_e36b_summary·mk_e48_summary: bounded_bytes/static_per_call_bytes/"
                     "module_resident_constant_bytes."),
            "impact": ("수치·판정에는 영향이 없다(값은 같다). 영향은 **판독**에 있다 — 한 철자만 "
                       "아는 판독기는 다른 쪽에서 조용히 null 을 보고한다. 이 도구의 첫 판이 "
                       "실제로 E36 다섯 셀에 그렇게 했다."),
            "handling": "보관 요약을 고쳐 쓰지 않고 별칭을 명시 선언했다; 행마다 읽은 철자를 싣는다.",
            "spellings_seen": sorted({sp for r in rows for sp in r["U"]["key_spelling_used"].values() if sp}),
        },
        "verdict": ("FAIL" if (definitions["missing"] or not rows or sound
                               or len(resolved) != len(rows)) else "PASS"),
    }
    with open(os.path.join(ROOT, a.out), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    for r in rows:
        print("%-34s %-22s U(admitted=%s) B=%s/%s H=%s le=%s"
              % (r["cell"][:34], (r["admission_mode"] or "-"), r["admitted_budget_equals"],
                 r["B"]["budget_bytes"], r["B"]["budget_source"], r["H"]["hal_peak"], r["H_le_admitted"]))
    print("rows=%d resolved=%d problems=%d verdict=%s" % (len(rows), len(resolved), len(problems), out["verdict"]))
    print("wrote", a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
