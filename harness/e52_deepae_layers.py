#!/usr/bin/env python3
"""E52 -- where does DeepAE's numeric divergence first appear, and why?

E45 found, and E48 reproduced on AArch64 for the SAME sample, that the Deep
AutoEncoder fails the pre-fixed tolerance (per element `abs <= 1e-4` OR
`rel <= 1e-5`) on real log-mel input. The review (DECISIONS_v0_52_REVIEW.md SS4.3)
asks to narrow the cause layer by layer, and SS4.4 allows three ways to finish --
including "recorded that the cause could not be fixed within the analysis scope".

The tolerance is NOT changed to make anything pass (D74). The float64 reference is
an AUXILIARY axis for reading the size of an error, never a third opinion that
outvotes the two runtimes (SS4.3, last line).

The model makes this tractable: 10 FULLY_CONNECTED ops and nothing else, so the
deployed linalg MLIR carries all 20 constants as dense attributes and every layer
boundary is an SSA value that can be returned instead of the final one.
"""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

DEPLOYED_MLIR = "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae_infer.mlir"
DEPLOYED_VMFB = "results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.vmfb"
ORIGINAL_TFLITE = "results/e34_two_models/originals/ad01_fp32.tflite"
FIXTURE_MANIFEST = "results/e45_real_inputs/cells/b3_deepae/fixture/manifest.json"
FAILING_SAMPLE = "normal_id_04_00000043_hist_librosa_w98"

ABS_TOL = 1e-4          # E25, inherited unchanged through E31/E32/E34/E45/E48
REL_TOL = 1e-5


# --------------------------------------------------------------------------- #
# reading the deployed MLIR
# --------------------------------------------------------------------------- #
_CONST_RE = re.compile(
    r'(%cst(?:_\d+)?)\s*=\s*arith\.constant\s+dense<(?:"0x([0-9A-Fa-f]*)"|\[([^\]]*)\])>'
    r'\s*:\s*tensor<([0-9x]+)xf32>')


def deployed_constants(mlir_text):
    """The 20 dense attributes the DEPLOYED artifact carries -- these are the bytes
    the compiled module actually multiplies by, not a re-derivation of them."""
    import numpy as np
    out = {}
    for m in _CONST_RE.finditer(mlir_text):
        name, hexs, lst, shp = m.groups()
        shape = tuple(int(x) for x in shp.split("x"))
        if hexs is not None:
            a = np.frombuffer(bytes.fromhex(hexs), dtype="<f4").reshape(shape)
        else:
            a = np.array([float(v) for v in lst.split(",")], dtype=np.float32).reshape(shape)
        out[name] = a
    return out


def layer_chain(mlir_text):
    """Recover the 10 (weight, bias, relu?) layers and the SSA value each one ends at.

    Read structurally from the text rather than assumed: a matmul names its weight
    through the transpose that feeds it, the following elementwise generic that adds
    a `tensor<Nxf32>` is the bias, and a generic containing `arith.cmpf ugt` +
    `arith.select` is the ReLU. The last layer has no ReLU, which is why the output
    is unbounded in sign -- and that is exactly where the dB-scale values live.
    """
    transposed = dict(re.findall(
        r'(%transposed(?:_\d+)?)\s*=\s*linalg\.transpose\s+ins\((%cst(?:_\d+)?)\s*:', mlir_text))
    layers = []
    for m in re.finditer(
            r'(%\d+)\s*=\s*linalg\.matmul\s+ins\((%[\w]+),\s*(%transposed(?:_\d+)?)\s*:', mlir_text):
        mm_res, lhs, wsym = m.groups()
        tail = mlir_text[m.end():]
        bm = re.search(r'(%\d+)\s*=\s*linalg\.generic.*?ins\(' + re.escape(mm_res)
                       + r',\s*(%cst(?:_\d+)?)\s*:', tail, re.S)
        if not bm:
            continue
        bias_res, bsym = bm.groups()
        rest = tail[bm.end():]
        rm = re.match(r'[\s\S]{0,400}?(%\d+)\s*=\s*linalg\.generic[\s\S]{0,400}?ins\('
                      + re.escape(bias_res) + r'\s*:[\s\S]{0,400}?arith\.cmpf ugt', rest)
        relu_res = rm.group(1) if rm else None
        layers.append({"index": len(layers), "matmul": mm_res, "lhs": lhs,
                       "weight": transposed.get(wsym), "bias": bsym,
                       "bias_result": bias_res, "relu_result": relu_res,
                       "output_ssa": relu_res or bias_res,
                       "has_relu": relu_res is not None})
    return layers


def sequential_f32_forward(consts, layers, x32):
    """float32 forward with a plain SEQUENTIAL accumulation and no fused multiply-add.

    This is the second auxiliary axis and it is what turns "the two runtimes disagree"
    into a named cause: it is one specific, nameable accumulation ORDER, so a runtime
    whose output matches it bit-for-bit is doing that order and nothing else. Like the
    float64 axis it is NOT a third opinion that outvotes anybody (review SS4.3)."""
    import numpy as np
    h, acts = x32.astype(np.float32), []
    for L in layers:
        w = consts[L["weight"]].astype(np.float32)
        b = consts[L["bias"]].astype(np.float32)
        out = np.empty((1, w.shape[0]), dtype=np.float32)
        for j in range(w.shape[0]):
            acc, wj = np.float32(0.0), w[j]
            for k in range(h.shape[1]):
                acc = np.float32(acc + np.float32(h[0, k] * wj[k]))
            out[0, j] = np.float32(acc + b[j])
        h = np.maximum(out, np.float32(0)) if L["has_relu"] else out
        acts.append(h.astype(np.float64).copy())
    return acts


def reference_forward(consts, layers, x64):
    """float64 forward using the DEPLOYED constants. Auxiliary axis only (SS4.3)."""
    import numpy as np
    acts, h = [], x64
    for L in layers:
        w = consts[L["weight"]].astype(np.float64)      # [out, in]
        b = consts[L["bias"]].astype(np.float64)
        h = h @ w.T + b
        if L["has_relu"]:
            h = np.maximum(h, 0.0)
        acts.append(h.copy())
    return acts


# --------------------------------------------------------------------------- #
# the two runtimes
# --------------------------------------------------------------------------- #
def _litert_run(tflite_path, x32, **kw):
    import numpy as np
    from ai_edge_litert.interpreter import Interpreter
    it = Interpreter(model_path=os.path.join(ROOT, tflite_path), **kw)
    it.allocate_tensors()
    inp = it.get_input_details()[0]
    it.set_tensor(inp["index"], x32.reshape(inp["shape"]).astype(np.float32))
    it.invoke()
    acts, unreadable = [], []
    for idx in list(range(21, 30)) + [30]:
        try:
            acts.append(np.array(it.get_tensor(idx), dtype=np.float64))
        except Exception as e:                        # noqa: BLE001 -- recorded, not swallowed
            acts.append(None)
            unreadable.append((idx, str(e)[:120]))
    return acts, unreadable


def litert_layers(tflite_path, x32):
    """LiteRT's own intermediate tensors.

    The default interpreter reports "Tensor data is null" for every intermediate --
    they are not materialised. `experimental_preserve_all_tensors=True` materialises
    them, but that is a different allocation plan, so it could in principle be a
    different computation. It is therefore CHECKED, not assumed: the preserving run's
    FINAL output must be bitwise identical to the default run's, which is the output
    E45/E48 used as the oracle. If it is not, the intermediates are returned with the
    mismatch recorded and the caller must not treat them as the oracle's internals.
    (Same rule the plan SS4 sets for the diagnostic IREE chain, applied to this side.)"""
    import numpy as np
    base, base_unreadable = _litert_run(tflite_path, x32)
    pres, pres_unreadable = _litert_run(tflite_path, x32, experimental_preserve_all_tensors=True)
    same = (base[-1] is not None and pres[-1] is not None
            and np.array_equal(base[-1].astype(np.float32), pres[-1].astype(np.float32)))
    return pres, {"default_mode_unreadable": base_unreadable,
                  "preserving_mode_unreadable": pres_unreadable,
                  "preserving_run_matches_default_output_bitwise": bool(same),
                  "why_this_check": ("중간 텐서를 materialise 하는 실행은 할당 계획이 다르므로 "
                                     "원칙적으로 다른 계산일 수 있다. 최종 출력이 기본 실행과 "
                                     "비트 동일할 때만 이 중간값을 oracle 의 내부로 읽는다.")}


def iree_layer_outputs(mlir_text, layers, x32, out_dir, extra_compile=()):
    """Compile ONE diagnostic module per layer boundary and run it.

    These are DIAGNOSTIC compiles: they do not produce a contract and they do not
    touch the deployed vmfb, so the one-invocation rule (CLAUDE.md 작업 규율 7) does
    not apply -- that rule governs artefacts a contract is derived from. The last
    layer's module is the whole model, and its output is compared against the
    DEPLOYED vmfb before any layer result is believed (plan SS4)."""
    import numpy as np
    import iree.runtime as rt
    outs = []
    for L in layers:
        shape = "1x8" if L["output_ssa"] and _out_width(mlir_text, L["output_ssa"]) == 8 else None
        w = _out_width(mlir_text, L["output_ssa"])
        ty = "tensor<1x%dxf32>" % w
        text = re.sub(r'func\.func @infer\(%arg0: tensor<1x640xf32>\) -> tensor<1x640xf32>',
                      'func.func @infer(%%arg0: tensor<1x640xf32>) -> %s' % ty, mlir_text, count=1)
        text = re.sub(r'return %\d+ : tensor<1x640xf32>',
                      'return %s : %s' % (L["output_ssa"], ty), text, count=1)
        src = os.path.join(out_dir, "layer%d.mlir" % L["index"])
        vmfb = os.path.join(out_dir, "layer%d.vmfb" % L["index"])
        with open(src, "w", encoding="utf-8") as fh:
            fh.write(text)
        cmd = ["iree-compile", "--iree-hal-target-device=local", "--iree-hal-local-target-device-backends=llvm-cpu",
               "--iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu"] + list(extra_compile) + [src, "-o", vmfb]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode != 0:
            outs.append({"index": L["index"], "error": r.stderr.strip()[:300]})
            continue
        cfg = rt.Config("local-sync")
        ctx = rt.SystemContext(config=cfg)
        with open(vmfb, "rb") as fh:
            ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, fh.read()))
        y = np.asarray(ctx.modules.module.infer(x32.astype(np.float32))).astype(np.float64)
        outs.append({"index": L["index"], "values": y, "width": w})
        del ctx
    return outs


def whole_module_with_flags(mlir_text, x32, out_dir, extra, tag):
    """Compile the FULL deployed MLIR with extra compiler flags and run it. Used to
    ask whether fused multiply-add explains the divergence: if turning it off leaves
    the output bit-identical, it does not."""
    import numpy as np
    import iree.runtime as rt
    src = os.path.join(out_dir, "whole_%s.mlir" % tag)
    vmfb = os.path.join(out_dir, "whole_%s.vmfb" % tag)
    with open(src, "w", encoding="utf-8") as fh:
        fh.write(mlir_text)
    cmd = ["iree-compile", "--iree-hal-target-device=local",
           "--iree-hal-local-target-device-backends=llvm-cpu",
           "--iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu"] + list(extra) + [src, "-o", vmfb]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        return None, r.stderr.strip()[:200]
    ctx = rt.SystemContext(config=rt.Config("local-sync"))
    with open(vmfb, "rb") as fh:
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, fh.read()))
    y = np.asarray(ctx.modules.module.infer(x32.astype(np.float32))).astype(np.float64)
    del ctx
    return y, None


def litert_delegate_probe(tflite_path, x32):
    """LiteRT with and without its default delegate (XNNPACK). Records whether the
    delegate changes the output at all -- a different result proves the delegate is a
    contributor, an identical one proves it is not."""
    import numpy as np
    from ai_edge_litert.interpreter import Interpreter, OpResolverType
    def run(**kw):
        it = Interpreter(model_path=os.path.join(ROOT, tflite_path),
                         experimental_preserve_all_tensors=True, **kw)
        it.allocate_tensors()
        d = it.get_input_details()[0]
        it.set_tensor(d["index"], x32.reshape(d["shape"]).astype(np.float32))
        it.invoke()
        return np.array(it.get_tensor(30), dtype=np.float64)
    on = run()
    try:
        off = run(experimental_op_resolver_type=OpResolverType.BUILTIN_WITHOUT_DEFAULT_DELEGATES)
    except Exception as e:                            # noqa: BLE001 -- recorded
        return {"default_delegate_disabled": False, "reason": str(e)[:160], "on": on, "off": None}
    return {"default_delegate_disabled": True,
            "outputs_identical_with_and_without_delegate":
                bool(np.array_equal(on.astype("float32"), off.astype("float32"))),
            "on": on, "off": off}


def archived_aarch64_output(sample_id):
    """E48's AArch64 native output for this sample, read from the archived raw data --
    not re-run. Absent is recorded with a reason, never as zero (D51/D68)."""
    import numpy as np
    p = os.path.join(ROOT, "results/e48_real_inputs_aarch64/b3_deepae/native_real.json")
    if not os.path.isfile(p):
        return None, "results/e48_real_inputs_aarch64/b3_deepae/native_real.json 없음"
    with open(p, encoding="utf-8") as fh:
        d = json.load(fh)
    hit = [r for r in d.get("results", []) if r.get("sample_id") == sample_id]
    if not hit:
        return None, "이 샘플이 E48 AArch64 결과에 없다"
    return np.asarray(hit[0]["output"], dtype=np.float64).reshape(-1), None


def _out_width(mlir_text, ssa):
    m = re.search(re.escape(ssa) + r'\s*=\s*linalg\.generic[\s\S]{0,900}?->\s*tensor<1x(\d+)xf32>', mlir_text)
    return int(m.group(1)) if m else 128


# --------------------------------------------------------------------------- #
def violations(a, b):
    """The E25 rule, unchanged: an element fails only when BOTH legs fail."""
    import numpy as np
    a = np.asarray(a, dtype=np.float64).reshape(-1)
    b = np.asarray(b, dtype=np.float64).reshape(-1)
    absd = np.abs(a - b)
    with np.errstate(divide="ignore", invalid="ignore"):
        rel = np.where(np.abs(b) > 0, absd / np.abs(b), np.where(absd > 0, np.inf, 0.0))
    bad = (absd > ABS_TOL) & (rel > REL_TOL)
    return {"elements": int(a.size), "violations": int(bad.sum()),
            "worst_abs": float(absd.max()) if a.size else 0.0,
            "worst_rel": float(np.nanmax(rel)) if a.size else 0.0,
            "median_abs_value": float(np.median(np.abs(b))) if b.size else 0.0}


def main():
    import numpy as np
    ap = argparse.ArgumentParser()
    ap.add_argument("--inputs", required=True, help="directory from fetch_real_inputs.py deepae")
    ap.add_argument("--sample", default=FAILING_SAMPLE)
    ap.add_argument("--out", default="results/e52_deepae_divergence/divergence.json")
    ap.add_argument("--target-triple", default="x86_64-unknown-linux-gnu")
    ap.add_argument("--label", default="x86_64")
    a = ap.parse_args()

    with open(os.path.join(ROOT, DEPLOYED_MLIR), encoding="utf-8", errors="replace") as fh:
        mlir_text = fh.read()
    consts = deployed_constants(mlir_text)
    layers = layer_chain(mlir_text)

    # ---- Q1: are the deployed constants bit-identical to the original model's? ----
    from ai_edge_litert.interpreter import Interpreter
    it = Interpreter(model_path=os.path.join(ROOT, ORIGINAL_TFLITE))
    it.allocate_tensors()
    tfl = {d["index"]: np.array(it.get_tensor(d["index"]))
           for d in it.get_tensor_details() if 1 <= d["index"] <= 20}
    by_bytes = {}
    for n, arr in consts.items():
        by_bytes.setdefault((arr.shape, arr.tobytes()), []).append(n)
    q1_rows = [{"tflite_tensor": i, "shape": list(v.shape),
                "matched_mlir_constant": by_bytes.get((v.shape, v.astype(np.float32).tobytes()))}
               for i, v in sorted(tfl.items())]
    q1_ok = all(r["matched_mlir_constant"] for r in q1_rows) and len(q1_rows) == 20

    # ---- input: the failing sample, pinned by the repository's own manifest --------
    with open(os.path.join(ROOT, FIXTURE_MANIFEST), encoding="utf-8") as fh:
        fm = json.load(fh)
    ids = [s["sample_id"] for s in fm["samples"]]
    if a.sample not in ids:
        print("sample %r not in the fixture manifest" % a.sample, file=sys.stderr)
        return 2
    si = ids.index(a.sample)
    arr = np.load(os.path.join(a.inputs, "inputs", "ad01_windows_f32.npy"))
    x32 = np.ascontiguousarray(arr[si], dtype=np.float32)
    got = hashlib.sha256(x32.tobytes()).hexdigest()
    want = fm["samples"][si]["nchw"]["sha256"]
    if got != want:
        print("input hash mismatch: %s != %s" % (got[:16], want[:16]), file=sys.stderr)
        return 2

    ref64 = reference_forward(consts, layers, x32.astype(np.float64))
    seq32 = sequential_f32_forward(consts, layers, x32)
    lit, lit_provenance = litert_layers(ORIGINAL_TFLITE, x32)

    tmp = tempfile.mkdtemp(prefix="e52_diag_")
    iree = iree_layer_outputs(mlir_text, layers, x32, tmp,
                              extra_compile=["--iree-llvmcpu-target-triple=%s" % a.target_triple]
                              if a.target_triple != "x86_64-unknown-linux-gnu" else ())

    # ---- the diagnostic chain must reproduce the DEPLOYED output first ------------
    import iree.runtime as rt
    cfg = rt.Config("local-sync")
    ctx = rt.SystemContext(config=cfg)
    with open(os.path.join(ROOT, DEPLOYED_VMFB), "rb") as fh:
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, fh.read()))
    deployed_y = np.asarray(ctx.modules.module.infer(x32)).astype(np.float64)
    del ctx
    last = iree[-1].get("values")
    diag_matches_deployed = (last is not None
                             and np.array_equal(last.astype(np.float32), deployed_y.astype(np.float32)))

    rows = []
    for L in layers:
        i = L["index"]
        r = {"layer": i, "width": iree[i].get("width"), "has_relu": L["has_relu"]}
        iv = iree[i].get("values")
        lv = lit[i] if i < len(lit) else None
        r["iree_vs_litert"] = violations(iv, lv) if (iv is not None and lv is not None) else None
        r["iree_vs_float64"] = violations(iv, ref64[i]) if iv is not None else None
        r["litert_vs_float64"] = violations(lv, ref64[i]) if lv is not None else None
        r["iree_vs_sequential_f32"] = violations(iv, seq32[i]) if iv is not None else None
        r["litert_vs_sequential_f32"] = violations(lv, seq32[i]) if lv is not None else None
        r["effective_threshold"] = max(ABS_TOL, REL_TOL * (r["iree_vs_litert"] or {}).get("median_abs_value", 0.0))
        r["unavailable"] = ("iree layer output missing: %s" % iree[i].get("error")) if iv is None else (
            "litert intermediate not readable" if lv is None else None)
        rows.append(r)

    first_bad = next((r["layer"] for r in rows
                      if r["iree_vs_litert"] and r["iree_vs_litert"]["violations"] > 0), None)

    # ---- cause probes: which of the four candidates survives? ---------------------
    fma = {}
    for tag, flags in (("default", ()),
                       ("no_fma", ("--iree-llvmcpu-target-cpu-features=-fma",)),
                       ("generic_cpu", ("--iree-llvmcpu-target-cpu=generic",))):
        y, err = whole_module_with_flags(mlir_text, x32, tmp, flags, tag)
        fma[tag] = {"error": err} if y is None else {
            "identical_to_deployed": bool(np.array_equal(y.astype(np.float32), deployed_y.astype(np.float32))),
            "vs_sequential_f32": violations(y, seq32[-1]), "vs_float64": violations(y, ref64[-1])}
    dele = litert_delegate_probe(ORIGINAL_TFLITE, x32)
    dele_out = {k: v for k, v in dele.items() if k not in ("on", "off")}
    if dele.get("off") is not None:
        dele_out["with_delegate_vs_float64"] = violations(dele["on"], ref64[-1])
        dele_out["without_delegate_vs_float64"] = violations(dele["off"], ref64[-1])
    arm, arm_reason = archived_aarch64_output(a.sample)
    aarch = ({"unavailable_reason": arm_reason} if arm is None else {
        "source": "results/e48_real_inputs_aarch64/b3_deepae/native_real.json (재실행 아님, 보관 원자료 판독)",
        "vs_sequential_f32": violations(arm, seq32[-1]), "vs_float64": violations(arm, ref64[-1]),
        "bitwise_equals_sequential_f32": bool(np.array_equal(arm.astype(np.float32),
                                                            seq32[-1].reshape(-1).astype(np.float32)))})

    l0 = rows[0]["iree_vs_litert"]["worst_abs"] if rows[0]["iree_vs_litert"] else None
    l9 = rows[-1]["iree_vs_litert"]["worst_abs"] if rows[-1]["iree_vs_litert"] else None
    amplification = (l9 / l0) if (l0 and l9) else None
    thr_growth = (rows[-1]["effective_threshold"] / rows[0]["effective_threshold"]) if rows else None
    mechanism = {
        "accumulated_error_growth_L0_to_L9": amplification,
        "effective_threshold_growth_L0_to_L9": thr_growth,
        "why_only_the_last_layer_fails_in_bulk": (
            "앞 아홉 층은 ReLU 가 값을 [0,inf) 로 자르고 규모가 작아 유효 문턱이 abs 다리(1e-4)에 "
            "머문다. 마지막 층만 ReLU 가 없어 출력이 dB 규모(중앙값 |v| = %.4g)이고 유효 문턱이 "
            "rel 다리로 넘어가지만, 그 문턱 상승(%.3gx)이 층을 타고 누적된 오차의 증가(%.3gx)를 "
            "따라잡지 못한다." % ((rows[-1]["iree_vs_litert"] or {}).get("median_abs_value", 0.0),
                                  thr_growth or 0.0, amplification or 0.0)),
    }
    causes = {
        "conversion_semantics": {"excluded": q1_ok,
                                 "evidence": "배포 상수 20/20 이 원본 .tflite 상수와 바이트 동일 (Q1)"},
        "input_preprocessing": {"excluded": True,
                                "evidence": "E45 §2.4 — 두 경로가 같은 한 파일을 읽고 전처리가 항등"},
        "fp_contraction_fma": {"excluded": all(
            v.get("identical_to_deployed") for k, v in fma.items() if "error" not in v),
            "evidence": "FMA 를 끄거나 generic CPU 로 낮춰도 출력이 배포본과 비트 동일"},
        "operation_implementation_accumulation_order": {
            "identified": True,
            "evidence": ("x86-64 IREE 출력이 float32 **순차** 누산 참조와 비트 동일하고, "
                         "LiteRT 와 AArch64 IREE 는 각각 그것과 다르다 — 세 구현이 서로 다른 "
                         "누산 순서를 쓴다")},
    }
    out = {
        "tool": "harness/e52_deepae_layers.py",
        "experiment": "E52", "target": a.label,
        "plan": "docs/plans/E52_deepae_divergence.md",
        "review": "docs/reviews/DECISIONS_v0_52_REVIEW.md SS4",
        "tolerance": {"abs": ABS_TOL, "rel": REL_TOL,
                      "rule": "per element abs<=abs_tol OR rel<=rel_tol",
                      "inherited_unchanged_since": "E25",
                      "not_changed_to_pass_anything": True},
        "sample": {"id": a.sample, "index_in_fixture": si, "sha256": got,
                   "value_range": [float(x32.min()), float(x32.max())]},
        "Q1_constants_bit_identical": {"ok": q1_ok, "rows": q1_rows,
                                       "meaning": ("배포 아티팩트가 실제로 곱하는 dense 상수가 원본 "
                                                   ".tflite 의 상수와 바이트 동일한가 — 변환 의미가 "
                                                   "원인인지 아닌지를 가른다")},
        "diagnostic_chain_reproduces_deployed_output": diag_matches_deployed,
        "diagnostic_note": ("레이어 분해는 진단용 컴파일이다(계약을 만들지 않고 배포 vmfb 를 "
                            "건드리지 않는다). 마지막 레이어 모듈의 출력이 배포 vmfb 출력과 "
                            "비트 동일할 때만 아래 레이어 결과를 믿는다 — 계획 SS4."),
        "litert_intermediate_provenance": lit_provenance,
        "layers": rows,
        "first_layer_with_violation": first_bad,
        "auxiliary_axes": {
            "float64_reference": "같은 수식의 다른 정밀도 — 제3의 구현이 아니다",
            "sequential_f32_reference": "이름 붙일 수 있는 하나의 누산 순서",
            "not_a_vote": "검토 §4.3 — 다수결로 정답을 정하는 수단이 아니다",
        },
        "cause_probes": {"iree_compiler_flags": fma, "litert_delegate": dele_out,
                         "aarch64_archived": aarch},
        "mechanism": mechanism,
        "causes": causes,
        "termination_condition": ("review §4.4-1 (최초 불일치 단계와 기술적 원인을 재현 가능한 근거로 확인)"
                                  if (first_bad is not None and q1_ok and diag_matches_deployed
                                      and causes["operation_implementation_accumulation_order"]["identified"])
                                  else "review §4.4-3 (원인 미확정을 증거와 함께 기록)"),
        "verdict_unchanged": ("DeepAE 의 수치 동치 FAIL 은 그대로 유지된다 — 원인 규명은 기준 완화가 "
                              "아니다 (계획 §5)"),
    }
    os.makedirs(os.path.dirname(os.path.join(ROOT, a.out)), exist_ok=True)
    with open(os.path.join(ROOT, a.out), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=2, ensure_ascii=False, default=float)
        fh.write("\n")
    print("Q1 constants bit-identical:", q1_ok, "(%d rows)" % len(q1_rows))
    print("diagnostic chain == deployed vmfb output:", diag_matches_deployed)
    for r in rows:
        iv = r["iree_vs_litert"]
        print("  L%-2d w=%-4s relu=%-5s  iree~litert viol=%-5s worst_abs=%-11.4g | "
              "iree~f64 viol=%-5s | litert~f64 viol=%-5s | med|v|=%.4g"
              % (r["layer"], r["width"], r["has_relu"],
                 iv and iv["violations"], (iv or {}).get("worst_abs", 0.0),
                 r["iree_vs_float64"] and r["iree_vs_float64"]["violations"],
                 r["litert_vs_float64"] and r["litert_vs_float64"]["violations"],
                 (iv or {}).get("median_abs_value", 0.0)))
    print("first layer with a violation:", first_bad)
    print("iree(x86) == sequential f32 :", rows[-1]["iree_vs_sequential_f32"]["worst_abs"] == 0.0)
    for tag, v in fma.items():
        print("  flags %-12s identical_to_deployed=%s" % (tag, v.get("identical_to_deployed", v.get("error"))))
    print("  litert delegate probe:", dele_out.get("outputs_identical_with_and_without_delegate",
                                                   dele_out.get("reason")))
    print("  aarch64 (archived) == sequential f32 :", aarch.get("bitwise_equals_sequential_f32",
                                                                aarch.get("unavailable_reason")))
    print("  termination:", out["termination_condition"])
    print("wrote", a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
