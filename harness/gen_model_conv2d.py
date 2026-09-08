"""E14 Stage 1 / proposal §12: generate a small Conv2D model with BAKED
constant weights, IREE-compilable, static shapes, f32 everywhere.

Architecture (NHWC, valid convs, stride 1):
  x: 1 x IN x IN x 1
  -> linalg.conv_2d_nhwc_hwcf, filter 3x3x1xC1           -> 1 x (IN-2) x (IN-2) x C1
  -> bias add + ReLU (linalg.generic, bias broadcast over C)
  -> linalg.conv_2d_nhwc_hwcf, filter 3x3xC1xC2          -> 1 x (IN-4) x (IN-4) x C2
  -> ReLU (linalg.generic)
  -> tensor.collapse_shape                               -> 1 x ((IN-4)^2 * C2)
  -> linalg.matmul with a ((IN-4)^2*C2) x N_OUT weight   -> 1 x N_OUT

Defaults (IN=8, C1=4, C2=8, N_OUT=2): 1x8x8x1 -> 1x6x6x4 -> 1x4x4x8 -> 1x128 -> 1x2.
The input is the ONLY function argument; every weight is an arith.constant
dense<...> tensor inside @infer (like e14/m16k_baked.mlir); conv/matmul
accumulate into an arith.constant dense<0.0> init.

Outputs in --out DIR: model.mlir, weights.npz, model.json, reference.json
(reference output for the canonical input x[i] = 0.1*(i%10), float64 NumPy).
Weights are deterministic from numpy default_rng(--seed) * 0.1; a different
seed gives a byte-different artifact with the same ABI (model-swap scenario).
"""
import argparse, hashlib, json, os, pathlib, sys
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model_reference import canonical_input, conv2d_forward


def dense_literal(a):
    """Nested dense<[...]> literal; %.9e round-trips every float32 exactly."""
    def rec(v):
        if v.ndim == 1:
            return "[" + ",".join(f"{float(e):.9e}" for e in v) + "]"
        return "[" + ",".join(rec(s) for s in v) + "]"
    return "dense<" + rec(np.asarray(a, dtype=np.float32)) + ">"


def tt(shape):
    return "tensor<" + "x".join(str(d) for d in shape) + "xf32>"


def make_src(w, in_hw, c1, c2, n_out):
    h1 = in_hw - 2
    h2 = in_hw - 4
    flat = h2 * h2 * c2
    T_x, T_k1, T_a1 = tt((1, in_hw, in_hw, 1)), tt((3, 3, 1, c1)), tt((1, h1, h1, c1))
    T_b1, T_k2, T_a2 = tt((c1,)), tt((3, 3, c1, c2)), tt((1, h2, h2, c2))
    T_f, T_w3, T_y = tt((1, flat)), tt((flat, n_out)), tt((1, n_out))
    id4 = "affine_map<(n, h, w, c) -> (n, h, w, c)>"
    bc = "affine_map<(n, h, w, c) -> (c)>"
    par4 = '["parallel", "parallel", "parallel", "parallel"]'
    return f"""func.func @infer(%x: {T_x}) -> {T_y} {{
  %zero = arith.constant 0.0 : f32
  %k1 = arith.constant {dense_literal(w['k1'])} : {T_k1}
  %b1 = arith.constant {dense_literal(w['b1'])} : {T_b1}
  %k2 = arith.constant {dense_literal(w['k2'])} : {T_k2}
  %w3 = arith.constant {dense_literal(w['w3'])} : {T_w3}
  %z1 = arith.constant dense<0.0> : {T_a1}
  %c1 = linalg.conv_2d_nhwc_hwcf {{dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>}}
        ins(%x, %k1 : {T_x}, {T_k1}) outs(%z1 : {T_a1}) -> {T_a1}
  %e1 = tensor.empty() : {T_a1}
  %a1 = linalg.generic {{indexing_maps = [{id4}, {bc}, {id4}], iterator_types = {par4}}}
        ins(%c1, %b1 : {T_a1}, {T_b1}) outs(%e1 : {T_a1}) {{
  ^bb0(%v: f32, %b: f32, %o: f32):
    %s = arith.addf %v, %b : f32
    %r = arith.maximumf %s, %zero : f32
    linalg.yield %r : f32
  }} -> {T_a1}
  %z2 = arith.constant dense<0.0> : {T_a2}
  %c2 = linalg.conv_2d_nhwc_hwcf {{dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>}}
        ins(%a1, %k2 : {T_a1}, {T_k2}) outs(%z2 : {T_a2}) -> {T_a2}
  %e2 = tensor.empty() : {T_a2}
  %a2 = linalg.generic {{indexing_maps = [{id4}, {id4}], iterator_types = {par4}}}
        ins(%c2 : {T_a2}) outs(%e2 : {T_a2}) {{
  ^bb0(%v: f32, %o: f32):
    %r = arith.maximumf %v, %zero : f32
    linalg.yield %r : f32
  }} -> {T_a2}
  %f = tensor.collapse_shape %a2 [[0], [1, 2, 3]] : {T_a2} into {T_f}
  %z3 = arith.constant dense<0.0> : {T_y}
  %y = linalg.matmul ins(%f, %w3 : {T_f}, {T_w3}) outs(%z3 : {T_y}) -> {T_y}
  return %y : {T_y}
}}
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--in-hw", type=int, default=8)
    ap.add_argument("--c1", type=int, default=4)
    ap.add_argument("--c2", type=int, default=8)
    ap.add_argument("--n-out", type=int, default=2)
    a = ap.parse_args()
    if a.in_hw < 5:
        ap.error("--in-hw must be >= 5 (two valid 3x3 convs)")

    flat = (a.in_hw - 4) ** 2 * a.c2
    rng = np.random.default_rng(a.seed)
    w = {
        "k1": (rng.standard_normal((3, 3, 1, a.c1)) * 0.1).astype(np.float32),
        "b1": (rng.standard_normal((a.c1,)) * 0.1).astype(np.float32),
        "k2": (rng.standard_normal((3, 3, a.c1, a.c2)) * 0.1).astype(np.float32),
        "w3": (rng.standard_normal((flat, a.n_out)) * 0.1).astype(np.float32),
    }
    out = pathlib.Path(a.out); out.mkdir(parents=True, exist_ok=True)
    src = make_src(w, a.in_hw, a.c1, a.c2, a.n_out)
    (out / "model.mlir").write_text(src)
    np.savez(out / "weights.npz", **w)

    in_shape, out_shape = [1, a.in_hw, a.in_hw, 1], [1, a.n_out]
    x = canonical_input(in_shape)
    y = conv2d_forward(w, x)
    param_count = int(sum(v.size for v in w.values()))
    info = {
        "name": f"conv2d_{a.in_hw}x{a.in_hw}_c{a.c1}_c{a.c2}_o{a.n_out}",
        "arch": "conv3x3(nhwc_hwcf)+bias+relu -> conv3x3(nhwc_hwcf)+relu -> collapse -> matmul",
        "input_shape": in_shape, "output_shape": out_shape, "seed": a.seed,
        "param_count": param_count, "param_bytes": param_count * 4,
        # per-tensor bytes: IREE (default flags) inlines constants <= 256 B into
        # the dispatch executable instead of a HAL constant buffer, so the HAL
        # module-resident constant total may be param_bytes minus those.
        "param_bytes_by_tensor": {k: int(v.nbytes) for k, v in w.items()},
        "weight_layouts": {"k1": "HWCF", "b1": "C", "k2": "HWCF", "w3": "KN"},
        "entry": "infer", "flatten_order": "row-major (h, w, c)",
        "source_sha256": hashlib.sha256(src.encode()).hexdigest(),
        "source_bytes": len(src.encode()),
    }
    (out / "model.json").write_text(json.dumps(info, indent=2))
    (out / "reference.json").write_text(json.dumps({
        "input_rule": "0.1*(i%10)", "input_shape": in_shape,
        "output": [float(v) for v in y.reshape(-1)],
        "output_shape": out_shape, "reference_dtype": "float64",
    }, indent=2))
    print(json.dumps({"out": str(out), "name": info["name"], "seed": a.seed,
                      "param_count": param_count, "param_bytes": param_count * 4,
                      "source_bytes": info["source_bytes"],
                      "source_sha256": info["source_sha256"],
                      "reference_output": [float(v) for v in y.reshape(-1)]}))


if __name__ == "__main__":
    main()
