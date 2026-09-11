#!/usr/bin/env python3
"""E31 / P2: build the input fixture that BOTH execution paths share.

The ninth external review (docs/reviews/ONAIR_MLIR_ARCHITECTURE_PLAN_20260910.md SS7.3, SS6.3)
asks for one preprocessing result that feeds the original TFLite model (NHWC) and the imported
IREE model (NCHW), so that resize and normalisation are removed as confounders: whatever the
resize does, both paths see the SAME numbers.

What this writes, per sample:
  <out>/inputs/<sample_id>.nhwc.npy   float32 [1,H,W,3]  -- the original model's input
  <out>/inputs/<sample_id>.nchw.npy   float32 [1,3,H,W]  -- the imported model's input
  <out>/manifest.json                 provenance, preprocessing identifiers, per-sample hashes

Preprocessing is the ORIGINAL's, read from its own config (not invented here):
  resize to (input_width, input_height), float32, (pixel - input_mean) / input_std.
For SmartCam that is 224x224 and pixel/255 -> [0,1]; the model's own MUL(2.0)/SUB(1.0) then
makes [-1,1], so normalising further outside would be a double normalisation.

The NCHW tensor is produced by TRANSPOSE, never reshape, and the generator verifies the round
trip (nchw.transpose(0,2,3,1) == nhwc) for every sample before writing anything. E30 recorded
this layout change as P2's obligation; getting it wrong is the single most likely way to make
an equivalence experiment quietly meaningless.

Usage:
  model_fixture.py --out results/e31_smartcam_equivalence/fixture \
      --images <dir-or-files> --height 224 --width 224 --mean 0 --std 255 \
      --synthetic 32 --seed 31 --edge --source-note "..."
"""
import argparse, hashlib, json, os, sys

import numpy as np


def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


def preprocess_image(path, height, width, mean, std, resample):
    from PIL import Image
    with Image.open(path) as im:
        original_size, original_mode = im.size, im.mode
        rgb = im.convert("RGB")
        resized = rgb.resize((width, height), resample)
        arr = np.asarray(resized, dtype=np.float32)
    assert arr.shape == (height, width, 3), arr.shape
    nhwc = ((arr - float(mean)) / float(std)).astype(np.float32)[None, ...]
    return nhwc, {"original_size": list(original_size), "original_mode": original_mode}


def transpose_differs_from_reshape(shape):
    """Is NHWC->NCHW a real permutation for this SHAPE, judged on labels rather than on data?

    Checked with an arange-labelled array of the same shape, deliberately NOT with the sample's
    own values: a constant sample (the all-zeros edge input) makes transpose and reshape produce
    equal ARRAYS even though the operations differ, so testing the data would refuse a perfectly
    good fixture. That is the same shape of mistake as D57 -- deciding a structural question from
    a value-dependent observation -- made here while writing the fixture for the experiment that
    exists because of it. Labels answer the structural question the guard is actually asking.
    """
    probe = np.arange(int(np.prod(shape)), dtype=np.int64).reshape(shape)
    t = np.ascontiguousarray(probe.transpose(0, 3, 1, 2))
    return not np.array_equal(t.reshape(shape), probe)


def to_nchw(nhwc):
    """Transpose, not reshape -- and prove it round-trips before anyone uses it."""
    nchw = np.ascontiguousarray(nhwc.transpose(0, 3, 1, 2))
    back = nchw.transpose(0, 2, 3, 1)
    if not np.array_equal(back, nhwc):
        raise AssertionError("NHWC->NCHW transpose does not round-trip; refusing to write the fixture")
    # For these shapes the permutation must genuinely move elements; if it did not, the fixture
    # would not be exercising the layout change E30 recorded as P2's obligation at all.
    if nhwc.shape[1] * nhwc.shape[2] > 1 and nhwc.shape[3] > 1:
        if not transpose_differs_from_reshape(nhwc.shape):
            raise AssertionError("for shape %s the NHWC->NCHW permutation does not reorder elements; "
                                 "the fixture would not be testing the layout change" % (list(nhwc.shape),))
    return nchw


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--images", nargs="*", default=[], help="image files, or directories to scan")
    ap.add_argument("--height", type=int, default=0)
    ap.add_argument("--width", type=int, default=0)
    ap.add_argument("--channels", type=int, default=3)
    ap.add_argument("--mean", type=float, default=0.0)
    ap.add_argument("--std", type=float, default=1.0)
    # E34 (stage 4): the model convention is DATA, not a branch. `nhwc_to_nchw` is the
    # image case E31 built; `none` is a model whose entry takes the original tensor
    # unchanged (a rank-2 autoencoder has no layout to convert). Adding a third mode
    # must stay a value here rather than an `if model == ...` anywhere downstream.
    ap.add_argument("--layout", choices=["nhwc_to_nchw", "none"], default="nhwc_to_nchw")
    # E45: a DELIBERATE defect injector, in-tree for the same reason harness/corrupt_vmfb.py
    # is: E31 and E34 both report a negative control (reshape instead of transpose) whose
    # fixture cannot be regenerated from repository contents, so the strongest evidence those
    # experiments have -- that argmax alone would have passed a broken layout -- rests on an
    # artifact nobody can rebuild (D43). This flag rebuilds it.
    # It is loud on purpose: the manifest records `layout_defect` at top level and every
    # sample row carries it, so a defective fixture can never be mistaken for a good one.
    ap.add_argument("--layout-defect", choices=["none", "reshape"], default="none",
                    help="DEFECT INJECTION. `reshape` builds the entry tensor with reshape "
                         "instead of transpose -- the exact layout error E31/E34 use as their "
                         "negative control. Never use this to produce a positive result.")
    ap.add_argument("--shape", type=int, nargs="*", default=None,
                    help="full input shape for --layout none (e.g. 1 640)")
    ap.add_argument("--experiment", default="E31 (P2: SmartCam semantic preservation)")
    ap.add_argument("--resample", default="BILINEAR")
    # E45: real inputs arrive as a pre-built stack of tensors, not as image files -- a
    # CIFAR-10 pickle and an ad01 feature .bin are not images and cannot go through
    # `--images`. This is a VALUE (a path and a kind label), not a per-model branch: the
    # same option serves b2 (uint8 NHWC images), b3 (float32 log-mel windows) and any
    # future model, and everything after it is the code that already existed.
    ap.add_argument("--tensors", default=None,
                    help="path to a .npy stack of samples, leading axis = sample index; each "
                         "slice must already have this fixture's sample shape")
    ap.add_argument("--tensor-kind", default="real_dataset",
                    help="the `kind` recorded for --tensors samples; the comparison reports "
                         "results per kind, so this label must say what the data actually is")
    ap.add_argument("--tensor-ids", default=None,
                    help="optional JSON list of sample ids for --tensors (default: <kind>_NNN)")
    ap.add_argument("--tensor-source", default="",
                    help="provenance sentence recorded with every --tensors sample")
    ap.add_argument("--synthetic", type=int, default=0, help="count of uniform[0,1) samples (coverage only)")
    ap.add_argument("--seed", type=int, default=31)
    ap.add_argument("--edge", action="store_true", help="add all-zeros and all-ones samples")
    ap.add_argument("--source-note", default="")
    ap.add_argument("--source-repo", default="")
    ap.add_argument("--source-commit", default="")
    a = ap.parse_args()

    if a.layout == "none":
        if not a.shape:
            print("model_fixture: --layout none needs --shape", file=sys.stderr)
            return 2
        if a.images:
            print("model_fixture: --layout none does not preprocess images", file=sys.stderr)
            return 2
        sample_shape = tuple(int(v) for v in a.shape)
    else:
        if not (a.height and a.width):
            print("model_fixture: --layout nhwc_to_nchw needs --height and --width", file=sys.stderr)
            return 2
        sample_shape = (1, a.height, a.width, a.channels)

    files = []
    for item in a.images:
        if os.path.isdir(item):
            files += [os.path.join(item, f) for f in sorted(os.listdir(item))
                      if f.lower().endswith((".png", ".jpg", ".jpeg"))]
        elif os.path.exists(item):
            files.append(item)
        else:
            print("model_fixture: no such image path: %s" % item, file=sys.stderr)
            return 2

    in_dir = os.path.join(a.out, "inputs")
    os.makedirs(in_dir, exist_ok=True)
    samples = []

    if files:
        try:
            from PIL import Image
        except ImportError as e:      # a decision, not a crash (D24)
            print("model_fixture: Pillow not installed, cannot preprocess images: %s" % e, file=sys.stderr)
            return 2
        resample = getattr(Image, a.resample)
        for path in files:
            sid = os.path.splitext(os.path.basename(path))[0]
            nhwc, meta = preprocess_image(path, a.height, a.width, a.mean, a.std, resample)
            samples.append((sid, "real_example", nhwc, dict(meta, source_file=path,
                                                            source_sha256=sha256_bytes(open(path, "rb").read()))))

    if a.tensors:
        stack = np.load(a.tensors)
        if stack.ndim < 2:
            print("model_fixture: --tensors must have a leading sample axis", file=sys.stderr)
            return 2
        ids = None
        if a.tensor_ids:
            ids = json.load(open(a.tensor_ids, encoding="utf-8"))
            if len(ids) != stack.shape[0]:
                print("model_fixture: --tensor-ids has %d ids for %d samples"
                      % (len(ids), stack.shape[0]), file=sys.stderr)
                return 2
        raw_dtype, raw_lo, raw_hi = str(stack.dtype), float(stack.min()), float(stack.max())
        for k in range(stack.shape[0]):
            one = np.ascontiguousarray(stack[k], dtype=np.float32)
            # The entry takes one sample at a time; a stack slice may or may not carry the
            # leading 1. Add it when it is missing rather than demanding one shape, because
            # refusing an honest (200,32,32,3) stack would be an over-rejection.
            if one.shape == tuple(sample_shape[1:]):
                one = one[None, ...]
            if one.shape != tuple(sample_shape):
                print("model_fixture: --tensors sample %d has shape %s, fixture expects %s"
                      % (k, list(one.shape), list(sample_shape)), file=sys.stderr)
                return 2
            # Same (x - mean)/std as the image path, so normalisation is recorded in ONE place
            # and a fixture cannot end up with two different transforms depending on its source.
            one = ((one - float(a.mean)) / float(a.std)).astype(np.float32)
            sid = ids[k] if ids else "%s_%03d" % (a.tensor_kind, k)
            samples.append((sid, a.tensor_kind, one,
                            {"tensors_file": os.path.abspath(a.tensors), "index": k,
                             "raw_dtype": raw_dtype, "raw_value_range": [raw_lo, raw_hi],
                             "source": a.tensor_source,
                             "note": "REAL data: this sample was not generated here"}))

    if a.synthetic:
        rng = np.random.default_rng(a.seed)
        for k in range(a.synthetic):
            nhwc = rng.random(sample_shape, dtype=np.float32)
            samples.append(("synthetic_%02d" % k, "synthetic", nhwc,
                            {"generator": "numpy.random.default_rng(%d).random, uniform [0,1)" % a.seed,
                             "index": k,
                             "note": "COVERAGE ONLY -- not real data, never to be reported as such"}))

    if a.edge:
        samples.append(("edge_zeros", "edge", np.zeros(sample_shape, np.float32),
                        {"note": "all 0.0"}))
        samples.append(("edge_ones", "edge", np.ones(sample_shape, np.float32),
                        {"note": "all 1.0 (the top of the [0,1] range this preprocessing produces)"}))

    if not samples:
        print("model_fixture: no samples requested", file=sys.stderr)
        return 2

    rows = []
    for sid, kind, nhwc, meta in samples:
        if a.layout == "nhwc_to_nchw":
            if a.layout_defect == "reshape":
                # Deliberately WRONG: same bytes, same shape, different element order. This is
                # the control, and it must never be produced by accident -- hence the flag.
                nchw = np.ascontiguousarray(
                    nhwc.reshape(nhwc.shape[0], nhwc.shape[3], nhwc.shape[1], nhwc.shape[2]))
            else:
                nchw = to_nchw(nhwc)               # raises if the transpose is not a real transpose
            p_nhwc = os.path.join(in_dir, sid + ".nhwc.npy")
            p_nchw = os.path.join(in_dir, sid + ".nchw.npy")
            np.save(p_nhwc, nhwc); np.save(p_nchw, nchw)
        else:
            # No layout conversion: the original tensor IS the entry tensor. Both manifest
            # entries name the SAME file, so downstream tools keep reading `nhwc` for the
            # oracle and `nchw` for the entry with no model-specific branch, and the two
            # hashes are equal because it is one array (E34/stage 4).
            nchw = nhwc
            p_nhwc = p_nchw = os.path.join(in_dir, sid + ".nchw.npy")
            np.save(p_nchw, nchw)
        rows.append({
            "sample_id": sid, "kind": kind,
            "nhwc": {"file": os.path.relpath(p_nhwc, a.out), "shape": list(nhwc.shape),
                     "dtype": str(nhwc.dtype), "sha256": sha256_bytes(nhwc.tobytes())},
            "nchw": {"file": os.path.relpath(p_nchw, a.out), "shape": list(nchw.shape),
                     "dtype": str(nchw.dtype), "sha256": sha256_bytes(nchw.tobytes())},
            "value_range": [float(nhwc.min()), float(nhwc.max())],
            "layout_defect": a.layout_defect,
            "detail": meta,
        })

    manifest = {
        "tool": "harness/model_fixture.py",
        "experiment": a.experiment,
        "input_shape": list(sample_shape),
        "layout_defect": a.layout_defect,
        "layout_defect_note": ("none -- the entry tensor is produced by transpose, verified to "
                               "round-trip" if a.layout_defect == "none" else
                               "DEFECTIVE ON PURPOSE: the entry tensor was produced by RESHAPE, "
                               "not transpose. This fixture exists to make a comparison FAIL. "
                               "A PASS read from it would be meaningless."),
        "preprocessing": ({
            "resize": {"to": [a.width, a.height], "resample": a.resample,
                       "note": "applied ONCE here so both paths receive identical tensors; this is NOT a "
                               "claim that it matches the flight software's own resizer"},
            "normalisation": {"formula": "(pixel - mean) / std", "mean": a.mean, "std": a.std,
                              "note": "the ORIGINAL model's own config values; the model's internal "
                                      "MUL/SUB completes the range, so do not normalise again outside"},
            "layout": {"nhwc": "original TFLite input", "nchw": "imported IREE entry input",
                       "operation": "numpy transpose(0,3,1,2)",
                       "verified": "round trip nchw.transpose(0,2,3,1) == nhwc for every sample; "
                                   "and transpose != reshape asserted for these shapes"},
        } if files else {
            "resize": None,
            "normalisation": None,
            "normalisation_note": "no image was preprocessed in this fixture, so no normalisation "
                                  "is claimed; the samples are generated directly in the value range "
                                  "the entry expects",
            "layout": ({"nhwc": "original TFLite input", "nchw": "imported IREE entry input",
                        "operation": "numpy transpose(0,3,1,2)",
                        "verified": "round trip and transpose != reshape asserted for these shapes"}
                       if a.layout == "nhwc_to_nchw" else
                       {"operation": "none",
                        "note": "the entry takes the original tensor unchanged (no layout to convert), "
                                "so both manifest entries name the same file and the same sha256"}),
        }),
        "source": {"repo": a.source_repo, "commit": a.source_commit, "note": a.source_note},
        "counts": {k: sum(1 for r in rows if r["kind"] == k) for k in sorted({r["kind"] for r in rows})},
        "total_samples": len(rows),
        "samples": rows,
    }
    with open(os.path.join(a.out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    print(json.dumps({"total_samples": manifest["total_samples"], "counts": manifest["counts"],
                      "out": a.out}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
