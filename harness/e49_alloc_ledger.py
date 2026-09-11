#!/usr/bin/env python3
"""E49: per-model ALLOCATION LEDGER -- every contract component traced to an IR operation.

`docs/reviews/MEMORY_CONTRACT_CORE_VALIDATION_GUIDE.md` SS5 (SND-1/SND-2) asks for something
this repository did not have: a table that says, for each model, WHICH operation in the
post-layout IR produced each byte of `I`, `O`, `T` and `C`, and whether the contract's
totals are exactly the sum of that table.  Until now the contract carried the sums and the
negative tests pinned the refusals, but nothing wrote down the derivation itself.

Three deliberate choices:

1. **The production parser is not modified.**  `static_mem_bound.parse_alloc_ir` returns
   sizes without the operation they came from; teaching it to carry provenance would change
   a tool whose output 33 archived contracts are pinned against.  This walks the same IR
   independently and then CHECKS the contract, which is the direction that can fail loudly.

2. **A mismatch refuses.**  If the ledger's sums do not equal the contract's components, the
   tool exits non-zero.  A ledger that quietly disagrees with the artifact it describes is
   worse than no ledger.

3. **Independence is reported, not asserted.**  The regex parser and `mlir_alloc_walk` are
   different implementations but read the SAME layout IR, so agreement between them is not
   evidence of independent error (D60 made exactly this correction about the kernel-stack
   analyser).  The ledger records which sources it had and says so.

    python3 harness/e49_alloc_ledger.py --contract C.json --layout-ir C.layout_ir.txt \\
        --model b2_resnet --out results/e49_research_audit/ledger/b2_resnet.json
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)

# Classification of the resource-producing operations this repository supports.  The names
# come from static_mem_bound.py's whitelist; the CLASS column is what the guide's SS4 table
# calls I / O / T / C.  An operation outside this map is NOT silently ignored -- it lands in
# `unclassified` and the ledger refuses.
OP_CLASS = {
    "stream.tensor.import": "I",          # external input resource
    "stream.resource.alloca": "O_or_T",   # external output slab OR transient slab
    "stream.resource.constants": "C",     # module-resident constants
    "stream.resource.try_map": "C",       # the map arm of the same constants
}


def entry_body(ir, entry="infer"):
    """The LAST printed state of the public entry function (same rule as the parser)."""
    ms = list(re.finditer(r"(util\.func|func\.func)\s+public\s+@" + re.escape(entry) + r"\b.*?\n\}",
                          ir, re.S))
    return (ms[-1].group(0), len(ms)) if ms else (ir, 0)


def const_table(ir):
    t = {}
    for m in re.finditer(r"(%[\w#]+)\s*=\s*arith\.constant\s+(\d+)\s*:\s*index", ir):
        t[m.group(1)] = int(m.group(2))
    return t


def resolve(sym, consts):
    if sym in consts:
        return consts[sym], "arith.constant"
    m = re.fullmatch(r"%c(\d+)(?:_\d+)?", sym)
    if m:
        return int(m.group(1)), "ssa-name literal"
    return None, None


def build_ledger(ir, entry="infer"):
    body, n_entry = entry_body(ir, entry)
    consts = const_table(ir)
    rows, unclassified = [], []

    # inputs: stream.tensor.import ... : ... in !stream.resource<external>{%size}
    for m in re.finditer(r"stream\.tensor\.import[^\n]*?\{(%[\w#]+)\}", body):
        v, how = resolve(m.group(1), consts)
        rows.append({"op": "stream.tensor.import", "class": "I", "size_symbol": m.group(1),
                     "bytes": v, "resolved_by": how, "scope": "entry",
                     "text": m.group(0).strip()[:160]})

    # allocas: the lifetime word right before {%size} says external (output) vs transient
    for m in re.finditer(r"stream\.resource\.alloca[^\n]*?!stream\.resource<(\w+)>\{(%[\w#]+)\}", body):
        life, sym = m.group(1), m.group(2)
        v, how = resolve(sym, consts)
        rows.append({"op": "stream.resource.alloca", "class": "O" if life == "external" else "T",
                     "lifetime": life, "size_symbol": sym, "bytes": v, "resolved_by": how,
                     "scope": "entry", "text": m.group(0).strip()[:160]})

    # constants live OUTSIDE the entry (util.initializer) -- scope matters, E6c
    for m in re.finditer(r"stream\.resource\.(constants|try_map)[^\n]*?\{(%[\w#]+)\}", ir):
        v, how = resolve(m.group(2), consts)
        rows.append({"op": "stream.resource." + m.group(1), "class": "C", "size_symbol": m.group(2),
                     "bytes": v, "resolved_by": how, "scope": "module (initializer)",
                     "text": m.group(0).strip()[:160]})

    # Everything else that appears in the entry body, classified explicitly.
    #
    # D84: the production parser's own regex is `stream\.(resource|tensor)\.\w+` -- it does not
    # even LOOK at the other stream families. That limit is safe only because the post-layout
    # entry contains no `stream.async.*` (those are the pre-scheduling allocating ops: clone,
    # constant, splat), and because `stream.cmd.*` / `stream.timepoint.*` do not allocate.
    # Measured across the 25 archived layout IRs: `stream.async.*` appears 1,020 times in the
    # FILES and 0 times inside the last entry print. That is an observation, not a guarantee --
    # and nothing was checking it. So the ledger checks it: an async op inside the entry means
    # layout did not finish, and the whole derivation is then unsound, so it REFUSES.
    NON_ALLOCATING = ("stream.cmd.", "stream.timepoint.")
    VIEWS_OR_FREES = ("stream.resource.subview", "stream.tensor.export",
                      "stream.resource.dealloca", "stream.resource.size")
    async_in_entry = []
    for m in re.finditer(r"\bstream\.(\w+)\.(\w+)", body):
        op = "stream.%s.%s" % (m.group(1), m.group(2))
        if op in OP_CLASS or op in VIEWS_OR_FREES or op.startswith(NON_ALLOCATING):
            continue
        if op.startswith("stream.async."):
            async_in_entry.append(op)
            continue
        unclassified.append(op)

    return {"rows": rows, "unclassified": sorted(set(unclassified)),
            "async_in_entry": sorted(set(async_in_entry)),
            "non_allocating_seen": sorted({("stream.%s.%s" % (m.group(1), m.group(2)))
                                           for m in re.finditer(r"\bstream\.(\w+)\.(\w+)", body)
                                           if ("stream." + m.group(1) + ".").startswith(NON_ALLOCATING)}),
            "entry_print_states": n_entry}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--contract", required=True)
    ap.add_argument("--layout-ir", required=True)
    ap.add_argument("--model", required=True)
    ap.add_argument("--entry", default=None, help="default: read from the contract")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    with open(a.contract, encoding="utf-8") as fh:
        con = json.load(fh)
    res = con["resources"]
    entry = a.entry or (con.get("model") or {}).get("entry") or "infer"
    ir = open(a.layout_ir, encoding="utf-8", errors="replace").read()
    led = build_ledger(ir, entry)

    def total(cls):
        return sum(r["bytes"] or 0 for r in led["rows"] if r["class"] == cls)

    # the map arm and the copy arm describe the SAME constants twice (E26's scf.if structure),
    # so C is the MAX of what the two ops report, never their sum.
    c_vals = [r["bytes"] or 0 for r in led["rows"] if r["class"] == "C"]
    derived = {"I": total("I"), "O": total("O"), "T": total("T"),
               "C": max(c_vals) if c_vals else 0}
    contract = {"I": res.get("static_external_input_bytes"),
                "O": res.get("static_external_output_bytes"),
                "T": res.get("static_transient_bytes"),
                "C": res.get("module_resident_constant_bytes")}
    agree = {k: (derived[k] == contract[k]) for k in derived}

    out = {
        "tool": "harness/e49_alloc_ledger.py",
        "experiment": "E49",
        "purpose": ("검증 지침 §5 SND-1/SND-2 — 계약의 I·O·T·C 를 IR operation 단위로 추적하고 "
                    "합이 계약값과 같은지 대조한다. 생산 파서는 건드리지 않는다."),
        "model": a.model, "entry": entry,
        "contract": os.path.relpath(a.contract, ROOT),
        "layout_ir": os.path.relpath(a.layout_ir, ROOT),
        "rows": led["rows"],
        "unclassified_ops": led["unclassified"],
        "async_ops_in_entry": led["async_in_entry"],
        "non_allocating_ops_in_entry": led["non_allocating_seen"],
        "parser_scan_scope_note": (
            "생산 파서(static_mem_bound.py)의 정규식은 `stream.(resource|tensor).*` 두 계열만 "
            "본다 — 다른 계열은 화이트리스트 밖이 아니라 **스캔 대상이 아니다**. 그 한정이 "
            "안전한 조건은 post-layout entry 에 `stream.async.*`(할당하는 pre-scheduling op)가 "
            "남지 않는 것이고, 보관 layout IR 25개에서 파일 전체 1,020회 vs **마지막 entry "
            "print 안 0회**로 측정된다. 그것은 관측이지 보장이 아니므로 이 원장이 검사한다."),
        "entry_print_states": led["entry_print_states"],
        "derived_totals": derived,
        "contract_totals": contract,
        "agreement": agree,
        "all_agree": (all(agree.values()) and not led["unclassified"]
                      and not led["async_in_entry"]),
        "per_call_identity": {
            "derived_I_plus_O_plus_T": derived["I"] + derived["O"] + derived["T"],
            "contract_static_per_call_bytes": res.get("static_per_call_bytes"),
            "equal": derived["I"] + derived["O"] + derived["T"] == res.get("static_per_call_bytes"),
        },
        "independence_note": ("정규식 파서와 mlir_alloc_walk 는 다른 구현이지만 **같은 layout IR** 을 "
                              "읽는다. 둘의 일치는 구현 독립성의 증거이지 **오류 독립성**의 증거가 "
                              "아니다 — D60 이 커널 스택 분석기에 대해 내린 것과 같은 정정이다. "
                              "이 원장도 같은 IR 을 읽으므로 같은 한계를 갖는다."),
        "c_is_max_not_sum": ("constants 는 map arm(try_map)과 copy arm(constants)이 같은 바이트를 "
                             "두 번 보고하므로 합이 아니라 최댓값이다(E26 의 scf.if 구조)."),
    }
    os.makedirs(os.path.dirname(os.path.abspath(a.out)) or ".", exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"model": a.model, "all_agree": out["all_agree"],
                      "derived": derived, "contract": contract,
                      "unclassified": led["unclassified"],
                      "per_call_equal": out["per_call_identity"]["equal"],
                      "out": a.out}, ensure_ascii=False))
    return 0 if out["all_agree"] and out["per_call_identity"]["equal"] else 1


if __name__ == "__main__":
    sys.exit(main())
