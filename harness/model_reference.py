"""E14 Stage 1: tiny NumPy reference forward passes for the Conv2D and
multi-branch models (proposal §12). Used by gen_model_conv2d.py /
gen_model_multibranch.py to write reference.json, and by anyone who wants an
independent check of a vmfb's output.

Both functions take the weights dict as saved in weights.npz (float32) and an
input array; arithmetic is done in float64 so the reference is independent of
the compiled f32 evaluation order. Layouts match the MLIR exactly:
  conv2d      : NHWC activations, HWCF filters, stride 1, no padding,
                flatten = row-major over (h, w, c)  (tensor.collapse_shape)
  multibranch : row-vector matmuls, ReLU = max(., 0)
"""
import numpy as np


def canonical_input(shape):
    """x[i] = 0.1 * (i % 10) over the flattened row-major index i -- the exact
    input the C learners (native_learner.c / cfs_app) feed."""
    n = int(np.prod(shape))
    return (0.1 * (np.arange(n) % 10)).reshape(shape).astype(np.float64)


def _conv2d_nhwc_hwcf(x, k):
    """Valid (no padding), stride-1 conv. x: (N,H,W,C) k: (KH,KW,C,F)."""
    n, h, w, c = x.shape
    kh, kw, kc, f = k.shape
    assert kc == c
    oh, ow = h - kh + 1, w - kw + 1
    out = np.zeros((n, oh, ow, f), dtype=np.float64)
    for i in range(kh):
        for j in range(kw):
            # (N,OH,OW,C) x (C,F) -> (N,OH,OW,F)
            out += x[:, i:i + oh, j:j + ow, :] @ k[i, j]
    return out


def conv2d_forward(weights, x):
    """x: (1,H,W,1) float. weights: k1 (3,3,1,C1), b1 (C1,), k2 (3,3,C1,C2),
    w3 ((H-4)*(W-4)*C2, n_out). Returns (1, n_out) float64."""
    x = np.asarray(x, dtype=np.float64)
    k1 = np.asarray(weights["k1"], dtype=np.float64)
    b1 = np.asarray(weights["b1"], dtype=np.float64)
    k2 = np.asarray(weights["k2"], dtype=np.float64)
    w3 = np.asarray(weights["w3"], dtype=np.float64)
    a1 = np.maximum(_conv2d_nhwc_hwcf(x, k1) + b1, 0.0)
    a2 = np.maximum(_conv2d_nhwc_hwcf(a1, k2), 0.0)
    flat = a2.reshape(a2.shape[0], -1)          # row-major (h, w, c)
    return flat @ w3


def multibranch_forward(weights, x):
    """x: (1, n_in). weights: w0 (n_in,W), wa (W,W), wb (W,W), w2 (W,n_out).
    h = relu(x w0); a = relu(h wa); b = relu(h wb); y = (a + b + h) w2."""
    x = np.asarray(x, dtype=np.float64)
    w0 = np.asarray(weights["w0"], dtype=np.float64)
    wa = np.asarray(weights["wa"], dtype=np.float64)
    wb = np.asarray(weights["wb"], dtype=np.float64)
    w2 = np.asarray(weights["w2"], dtype=np.float64)
    h = np.maximum(x @ w0, 0.0)
    a = np.maximum(h @ wa, 0.0)
    b = np.maximum(h @ wb, 0.0)
    return ((a + b) + h) @ w2
