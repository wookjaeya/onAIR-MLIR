"""E14 Stage 1 / proposal §12: generate a multi-branch (residual) MLP with
BAKED constant weights, IREE-compilable, static shapes, f32 everywhere.

Architecture:
  x: 1 x N_IN
  h = relu(x @ W0)            W0: N_IN x WIDTH      (shared trunk)
  a = relu(h @ WA)            WA: WIDTH x WIDTH     (branch A)
  b = relu(h @ WB)            WB: WIDTH x WIDTH     (branch B)
  j = (a + b) + h                                   (join + residual: a, b, h
                                                     are all live at the join
                                                     -> overlapping lifetimes)
  y = j @ W2                  W2: WIDTH x N_OUT

Defaults (N_IN=16, WIDTH=64, N_OUT=2). The input is the ONLY function
argument; every weight is an arith.constant dense<...> tensor inside @infer
(like e14/m16k_baked.mlir); matmuls accumulate into arith.constant dense<0.0>
inits; ReLU / adds are tensor-level arith ops.

Outputs in --out DIR: model.mlir, weights.npz, model.json, reference.json
(reference output for the canonical input x[i] = 0.1*(i%10), float64 NumPy).
Weights are deterministic from numpy default_rng(--seed) * 0.1; a different
seed gives a byte-different artifact with the same ABI (model-swap scenario).
"""
import argparse, hashlib, json, os, pathlib, sys
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model_reference import canonical_input, multibranch_forward


def dense_literal(a):
    """Nested dense<[...]> literal; %.9e round-trips every float32 exactly."""
    def rec(v):
        if v.ndim == 1:
            return "[" + ",".join(f"{float(e):.9e}" for e in v) + "]"
        return "[" + ",".join(rec(s) for s in v) + "]"
    return "dense<" + rec(np.asarray(a, dtype=np.float32)) + ">"


def tt(shape):
    return "tensor<" + "x".join(str(d) for d in shape) + "xf32>"


def make_src(w, n_in, width, n_out):
    T_x, T_h, T_y = tt((1, n_in)), tt((1, width)), tt((1, n_out))
    T_w0, T_ww, T_w2 = tt((n_in, width)), tt((width, width)), tt((width, n_out))
    return f"""func.func @infer(%x: {T_x}) -> {T_y} {{
  %w0 = arith.constant {dense_literal(w['w0'])} : {T_w0}
  %wa = arith.constant {dense_literal(w['wa'])} : {T_ww}
  %wb = arith.constant {dense_literal(w['wb'])} : {T_ww}
  %w2 = arith.constant {dense_literal(w['w2'])} : {T_w2}
  %zh = arith.constant dense<0.0> : {T_h}
  %zy = arith.constant dense<0.0> : {T_y}
  %h0 = linalg.matmul ins(%x, %w0 : {T_x}, {T_w0}) outs(%zh : {T_h}) -> {T_h}
  %h = arith.maximumf %h0, %zh : {T_h}
  %a0 = linalg.matmul ins(%h, %wa : {T_h}, {T_ww}) outs(%zh : {T_h}) -> {T_h}
  %a = arith.maximumf %a0, %zh : {T_h}
  %b0 = linalg.matmul ins(%h, %wb : {T_h}, {T_ww}) outs(%zh : {T_h}) -> {T_h}
  %b = arith.maximumf %b0, %zh : {T_h}
  %ab = arith.addf %a, %b : {T_h}
  %j = arith.addf %ab, %h : {T_h}
  %y = linalg.matmul ins(%j, %w2 : {T_h}, {T_w2}) outs(%zy : {T_y}) -> {T_y}
  return %y : {T_y}
}}
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--n-in", type=int, default=16)
    ap.add_argument("--width", type=int, default=64)
    ap.add_argument("--n-out", type=int, default=2)
    a = ap.parse_args()

    rng = np.random.default_rng(a.seed)
    w = {
        "w0": (rng.standard_normal((a.n_in, a.width)) * 0.1).astype(np.float32),
        "wa": (rng.standard_normal((a.width, a.width)) * 0.1).astype(np.float32),
        "wb": (rng.standard_normal((a.width, a.width)) * 0.1).astype(np.float32),
        "w2": (rng.standard_normal((a.width, a.n_out)) * 0.1).astype(np.float32),
    }
    out = pathlib.Path(a.out); out.mkdir(parents=True, exist_ok=True)
    src = make_src(w, a.n_in, a.width, a.n_out)
    (out / "model.mlir").write_text(src)
    np.savez(out / "weights.npz", **w)

    in_shape, out_shape = [1, a.n_in], [1, a.n_out]
    x = canonical_input(in_shape)
    y = multibranch_forward(w, x)
    param_count = int(sum(v.size for v in w.values()))
    info = {
        "name": f"multibranch_{a.n_in}x{a.width}x{a.n_out}",
        "arch": "relu(x W0) -> [relu(h WA), relu(h WB)] -> (a+b)+h (residual join) -> matmul W2",
        "input_shape": in_shape, "output_shape": out_shape, "seed": a.seed,
        "param_count": param_count, "param_bytes": param_count * 4,
        "param_bytes_by_tensor": {k: int(v.nbytes) for k, v in w.items()},
        "weight_layouts": {"w0": "KN", "wa": "KN", "wb": "KN", "w2": "KN"},
        "entry": "infer",
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
