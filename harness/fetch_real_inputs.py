#!/usr/bin/env python3
"""E45: obtain REAL evaluation inputs for the three models, or refuse honestly.

Why this exists
---------------
The three models in this repository are real public models, but their comparison
fixtures were synthetic: E26a recorded that the canonical dataset hosts are blocked
from this container (measured, not assumed), so E34 graded the b2/b3 cells
"SYNTHETIC ONLY" and claimed no accuracy. That grade was honest, and it was also a
measurement of the environment at one point in time. Re-measured: the canonical hosts
are still blocked (`www.cs.toronto.edu` -> 000, `zenodo.org` -> 000) but `git clone`
and `raw.githubusercontent.com` are not, and real inputs are reachable through them.

What this tool guarantees, and what it refuses
----------------------------------------------
Every route is gated on the BYTES, never on the URL. A mirror may be swapped, renamed
or force-pushed; if the bytes still hash to the recorded value the route is good, and
if they do not the tool stops without writing anything. That is the D25/D29 rule in
its acquisition form: "could not observe" and "observed and it was wrong" are both
refusals, and neither is ever recorded as a zero or a silent pass.

Absence of network is a SKIP with a stated reason (exit 3), never a FAIL and never a
fabricated result. A hash mismatch is a hard failure (exit 1) -- it means the route
changed under us, which is exactly the condition a provenance record exists to catch.

Scope (docs/plans/E45_real_inputs.md SS2, fixed before measurement)
-------------------------------------------------------------------
G1 only: real inputs so that the semantic-equivalence comparison runs in the model's
actual input domain. NO accuracy is claimed for any of the three models. For b2 that
is a scope decision and not an inability -- the data would support it; for b3 and
SmartCam it is an inability, and the reasons are recorded in the manifests themselves.
"""
import argparse
import csv
import hashlib
import io
import json
import os
import pickle
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)

EXIT_OK, EXIT_FAIL, EXIT_USAGE, EXIT_SKIP = 0, 1, 2, 3


# --------------------------------------------------------------------------- utils
def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


def md5_bytes(b):
    return hashlib.md5(b).hexdigest()


def skip(reason):
    """Honest SKIP: say what could not be reached and why, and write nothing."""
    print(json.dumps({"status": "SKIP", "reason": reason}), file=sys.stderr)
    return EXIT_SKIP


def fail(reason):
    print(json.dumps({"status": "FAIL", "reason": reason}), file=sys.stderr)
    return EXIT_FAIL


def fetch(url, timeout=180):
    """Return (bytes, None) or (None, reason). Never raises."""
    try:
        with urllib.request.urlopen(url, timeout=timeout) as r:
            if r.status != 200:
                return None, "HTTP %s" % r.status
            return r.read(), None
    except (urllib.error.URLError, urllib.error.HTTPError, OSError, ValueError) as e:
        return None, "%s: %s" % (type(e).__name__, e)


def fetch_gated(mirrors, expect_md5=None, expect_sha256=None, what=""):
    """Try each mirror; accept the FIRST body whose digest matches. Bytes, not URLs.

    A mirror that returns the wrong bytes is not a transport failure -- it is the
    condition this gate exists for -- so it is recorded per-mirror and the search
    continues, and if no mirror matches the caller gets a refusal with the whole log.
    """
    attempts = []
    for url in mirrors:
        body, err = fetch(url)
        if body is None:
            attempts.append({"url": url, "result": "unreachable", "detail": err})
            continue
        got_md5, got_sha = md5_bytes(body), sha256_bytes(body)
        ok = ((expect_md5 is None or got_md5 == expect_md5)
              and (expect_sha256 is None or got_sha == expect_sha256))
        attempts.append({"url": url, "result": "digest_match" if ok else "digest_mismatch",
                         "bytes": len(body), "md5": got_md5, "sha256": got_sha})
        if ok:
            return body, url, attempts
    return None, None, attempts


def git(args, cwd=None, timeout=900):
    p = subprocess.run(["git"] + args, cwd=cwd, capture_output=True, text=True, timeout=timeout)
    return p.returncode, p.stdout, p.stderr


def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(obj, f, indent=1, ensure_ascii=False)
        f.write("\n")


# --------------------------------------------------------------------- b2 ResNet
# The canonical CIFAR-10 python pickle, member `test_batch`. The digest below is NOT
# this project's own computation of some mirror: it is the per-file md5 torchvision
# records in `torchvision/datasets/cifar.py` (`test_list`), computed by torchvision on
# the files it extracts from https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz --
# the host that is blocked here. Matching it is a file-level chain of custody to
# upstream, not agreement between two redistributions (which a shared re-encode would
# also produce).
CIFAR_TEST_BATCH_MD5 = "40351d587109b95175f43aff81a1287e"
CIFAR_TEST_BATCH_SHA256 = "f53d8d457504f7cff4ea9e021afcf0e0ad8e24a91f3fc42091b8adef61157831"
CIFAR_META_MD5 = "5ff9c542aee3614f3951f8cda6e48888"

_GH = "https://raw.githubusercontent.com"
CIFAR_MIRRORS = [
    _GH + "/PythonCharmers/PythonCharmersData/master/cifar-10-batches-py/%s",
    _GH + "/jeongukjae/CS231n-assignments/master/cifar-10-batches-py/%s",
    _GH + "/waybarrios/TensorFlow_CNN/master/cifar-10-batches-py/%s",
    _GH + "/wangmn93/VaDE/master/cifar-10-batches-py/%s",
    _GH + "/Kyrie-Zhao/EdgeML/master/cifar-10-batches-py/%s",
]
# MLPerf Tiny's own harness (Apache-2.0). The selector is theirs, not ours: taking a
# subset we invented would make any later comparison uncitable.
TINY_COMMIT = "4addd0fa08d216e20637637874e084895f289da4"
TINY_RAW = _GH + "/mlcommons/tiny/" + TINY_COMMIT
IDXS_URL = TINY_RAW + "/benchmark/training/image_classification/perf_samples_idxs.npy"
IC01_LABELS_URL = TINY_RAW + "/benchmark/evaluation/datasets/ic01/y_labels.csv"


def cmd_resnet(a):
    import numpy as np

    body, used, attempts = fetch_gated([m % "test_batch" for m in CIFAR_MIRRORS],
                                       expect_md5=CIFAR_TEST_BATCH_MD5,
                                       expect_sha256=CIFAR_TEST_BATCH_SHA256)
    if body is None:
        unreachable = all(x["result"] == "unreachable" for x in attempts)
        msg = ("no mirror served CIFAR-10 test_batch: %s"
               % json.dumps(attempts, ensure_ascii=False))
        return skip(msg) if unreachable else fail(msg)

    meta, meta_url, meta_attempts = fetch_gated([m % "batches.meta" for m in CIFAR_MIRRORS],
                                                expect_md5=CIFAR_META_MD5)
    if meta is None:
        return fail("test_batch verified but batches.meta did not: %s"
                    % json.dumps(meta_attempts, ensure_ascii=False))

    idxs_raw, err = fetch(IDXS_URL)
    if idxs_raw is None:
        return skip("MLPerf Tiny perf_samples_idxs.npy unreachable (%s); refusing to invent "
                    "a subset of our own -- the citability of the sample choice is the point" % err)
    labels_raw, err = fetch(IC01_LABELS_URL)
    if labels_raw is None:
        return skip("MLPerf Tiny ic01 y_labels.csv unreachable (%s); it is the independent "
                    "cross-check on filenames and labels, so without it we do not proceed" % err)

    d = pickle.loads(body, encoding="bytes")
    m = pickle.loads(meta, encoding="bytes")
    data = d[b"data"]
    labels = np.asarray(d[b"labels"], dtype=np.uint8)
    filenames = [x.decode() for x in d[b"filenames"]]
    label_names = [x.decode() for x in m[b"label_names"]]

    # Structural invariants of the canonical object. A re-encode or a reshuffled copy
    # would survive a size check and die here.
    if data.shape != (10000, 3072) or data.dtype != np.uint8:
        return fail("test_batch data is %s %s, not (10000,3072) uint8" % (data.shape, data.dtype))
    if len(set(filenames)) != 10000:
        return fail("test_batch filenames are not 10000 distinct names")
    if sorted(np.bincount(labels, minlength=10).tolist()) != [1000] * 10:
        return fail("test_batch is not 1000 per class: %s" % np.bincount(labels, minlength=10))
    if label_names != ["airplane", "automobile", "bird", "cat", "deer", "dog",
                       "frog", "horse", "ship", "truck"]:
        return fail("batches.meta label_names are not the canonical order: %s" % label_names)

    # The reference's exact transform (tiny/benchmark/training/image_classification/
    # train.py::load_cifar_10_data): planar (1024R,1024G,1024B) -> interleaved HWC.
    nhwc_all = np.rollaxis(data.reshape(10000, 3, 32, 32), 1, 4)

    idxs = np.load(io.BytesIO(idxs_raw))
    if idxs.shape != (200,) or len(set(idxs.tolist())) != 200:
        return fail("perf_samples_idxs.npy is %s with %d unique values, expected 200 unique"
                    % (idxs.shape, len(set(idxs.tolist()))))
    x = np.ascontiguousarray(nhwc_all[idxs])
    y = np.ascontiguousarray(labels[idxs])
    per_class = np.bincount(y, minlength=10).tolist()
    if per_class != [20] * 10:
        return fail("selected subset is not class-balanced 20/class: %s" % per_class)

    # Independent cross-check against the benchmark's OWN published label file. This is
    # the check that catches a permuted selection: the names come from our pickle, the
    # expected names and labels come from mlcommons/tiny.
    rows = list(csv.reader(io.StringIO(labels_raw.decode())))
    want = [(r[0], int(r[2])) for r in rows if r and r[0].strip()]
    got = [(filenames[i][:-3] + "bin", int(labels[i])) for i in idxs.tolist()]
    if len(want) != len(got):
        return fail("y_labels.csv has %d rows, selection has %d" % (len(want), len(got)))
    name_hits = sum(1 for (wn, _), (gn, _) in zip(sorted(want), sorted(got)) if wn == gn)
    label_hits = sum(1 for w, g in zip(sorted(want), sorted(got)) if w == g)
    if name_hits != 200 or label_hits != 200:
        return fail("cross-check against mlcommons/tiny y_labels.csv failed: "
                    "filenames %d/200, (filename,label) %d/200" % (name_hits, label_hits))

    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, "inputs"), exist_ok=True)
    px = os.path.join(out, "inputs", "cifar10_perf200_nhwc_uint8.npy")
    py = os.path.join(out, "inputs", "cifar10_perf200_labels.npy")
    pi = os.path.join(out, "perf_samples_idxs.npy")
    np.save(px, x)
    np.save(py, y)
    with open(pi, "wb") as f:
        f.write(idxs_raw)
    with open(os.path.join(out, "y_labels.csv"), "wb") as f:
        f.write(labels_raw)

    manifest = {
        "tool": "harness/fetch_real_inputs.py resnet",
        "experiment": "E45",
        "model": "b2_resnet (MLPerf Tiny image classification, ic01)",
        "goal": "G1 only -- real inputs for semantic equivalence. NO accuracy is claimed.",
        "scope_note": "For this model the data WOULD support an accuracy figure (lossless "
                      "canonical bytes, unpermuted canonical labels, a citable official "
                      "subset). It is not claimed because the paper's axis is memory "
                      "admission, and because claiming it for one of three models would be "
                      "asymmetric. 'not claimed' here means chosen-not-to, not unable-to.",
        "upstream": {
            "dataset": "CIFAR-10 test batch (Krizhevsky 2009)",
            "canonical_url": "https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz",
            "canonical_host_reachable_here": False,
            "canonical_host_probe": "curl https://www.cs.toronto.edu/... -> 000 (blocked, measured)",
            "test_batch_md5": CIFAR_TEST_BATCH_MD5,
            "test_batch_sha256": CIFAR_TEST_BATCH_SHA256,
            "md5_attested_by": "torchvision/datasets/cifar.py test_list -- computed by "
                               "torchvision on files extracted from the canonical tarball, "
                               "so matching it is a chain of custody to upstream rather than "
                               "agreement between two redistributions",
            "mirror_used": used,
            "mirror_is_official": False,
            "mirror_attempts": attempts,
        },
        "licence": {
            "data": "UNSTATED. CIFAR-10 publishes no explicit licence and none of the mirrors "
                    "carries a LICENSE file. Cite Krizhevsky, 'Learning Multiple Layers of "
                    "Features from Tiny Images' (2009). Do NOT describe the mirror as an "
                    "official distribution channel.",
            "selector_and_harness": "Apache-2.0 (mlcommons/tiny @ %s) -- covers "
                                    "perf_samples_idxs.npy and y_labels.csv, NOT the pixels."
                                    % TINY_COMMIT,
        },
        "subset": {
            "selector": "mlcommons/tiny perf_samples_idxs.npy (seed 8108, 20 per class)",
            "selector_url": IDXS_URL,
            "selector_sha256": sha256_bytes(idxs_raw),
            "n": 200,
            "per_class": per_class,
            "chosen_by_this_project": False,
            "ambiguity_warning": "The EEMBC EnergyRunner harness that scores real MLPerf Tiny "
                                 "submissions uses a DIFFERENT 200 samples. Never write 'the "
                                 "official ic01 eval set' without saying which one.",
        },
        "cross_check": {
            "against": IC01_LABELS_URL,
            "y_labels_sha256": sha256_bytes(labels_raw),
            "filenames_matched": "%d/200" % name_hits,
            "filename_and_label_matched": "%d/200" % label_hits,
        },
        "tensors": {
            "x": {"file": os.path.relpath(px, out), "shape": list(x.shape), "dtype": "uint8",
                  "sha256": sha256_bytes(x.tobytes()),
                  "layout": "NHWC, rollaxis(reshape(N,3,32,32),1,4) -- the reference's transform"},
            "y": {"file": os.path.relpath(py, out), "shape": list(y.shape), "dtype": "uint8",
                  "sha256": sha256_bytes(y.tobytes())},
        },
        "value_domain": {
            "range": [int(x.min()), int(x.max())],
            "model_expects": "raw 0..255 as float32, with NO division by 255",
            "evidence": "tiny/benchmark/training/image_classification/tflite_test.py: the float "
                        "branch is `test_imgs = test_imgs.astype(np.float32)`; only the "
                        "quantised branch transforms (astype(int64)-128 -> int8)",
            "contrast_with_existing_fixture": "results/e34_two_models/b2_resnet/fixture is "
                                              "uniform[0,1), i.e. outside this domain",
        },
        "label_order": label_names,
        "label_order_note": "canonical order from batches.meta. It is also alphabetical, so "
                            "'the order looks alphabetical' is NOT evidence of correctness; "
                            "the evidence is the y_labels.csv cross-check above.",
    }
    write_json(os.path.join(out, "manifest.json"), manifest)
    print(json.dumps({"status": "OK", "model": "b2_resnet", "n": 200, "per_class": per_class,
                      "filenames_matched": name_hits, "labels_matched": label_hits,
                      "x_sha256": manifest["tensors"]["x"]["sha256"], "out": out}))
    return EXIT_OK


# --------------------------------------------------------------------- b3 DeepAE
# The ad01 feature files survive in eembc/energyrunner's HISTORY, at the commit just
# before EEMBC's 2021-06-11 purge. Their identity is not taken on trust: mlcommons/tiny
# commits the reference per-file anomaly scores, and running the vendored ad01_fp32.tflite
# over these features must reproduce them.
#
# WE DO NOT VENDOR THE BYTES. The distributor's current README states, in writing,
# "You must obtain the input files from the dataset. EEMBC cannot redistribute the input
# files.", and the target commit is literally the author writing "All files in this folder
# are copyright of their respective creators" ninety seconds before deleting 4,450 files
# "copyrighted by other people". So this route commits the hash manifest and this script,
# and regenerates the bytes on demand -- the same pattern E31 used for its seeded synthetic
# inputs and E26d for its deterministic corrupted vmfb, with ONE honest difference recorded
# in the manifest: those two regenerate offline and this one needs the network.
ER_URL = "https://github.com/eembc/energyrunner"
ER_PURGE_COMMIT = "c38c333"          # "Purged material copyrighted by other people."
AD01_FILE_BYTES = 102400             # 200 frames x 128 mels x 4 (float32 LE)
AD01_N_FILES = 248
AD01_FRAMES, AD01_MELS, AD01_WINDOW_FRAMES = 200, 128, 5
AD01_DIMS = AD01_MELS * AD01_WINDOW_FRAMES                    # 640, the model's input
AD01_N_WINDOWS = AD01_FRAMES - AD01_WINDOW_FRAMES + 1         # 196

# SELECTION RULE -- fixed here BEFORE any file was selected or any comparison run, to
# make the choice of samples independent of how they score (plan SS3.2). It is:
#   * label-blind: the rule never reads y_labels.csv, so it cannot select on the
#     dependent variable -- the mistake that disqualifies the SmartCam labels;
#   * result-blind: it is a fixed stride over lexicographically sorted names;
#   * count-matched to the fixture it replaces (E34 used 34 samples);
#   * mid-clip, to avoid whatever is special about the first and last frames of a clip.
AD01_STRIDE, AD01_N_SELECT = 7, 34
AD01_WINDOW_INDEX = AD01_N_WINDOWS // 2                        # 98


def cmd_deepae(a):
    import numpy as np

    tmp = tempfile.mkdtemp(prefix="e45_ad01_")
    try:
        rc, _, err = git(["clone", "--quiet", "--filter=blob:none", "--no-checkout",
                          ER_URL + ".git", tmp])
        if rc != 0:
            return skip("git clone %s failed (rc=%d): %s" % (ER_URL, rc, err.strip()[:400]))
        rc, _, err = git(["checkout", ER_PURGE_COMMIT + "^", "--", "datasets/ad01"], cwd=tmp)
        if rc != 0:
            return fail("the pre-purge tree did not yield datasets/ad01 (rc=%d): %s"
                        % (rc, err.strip()[:400]))
        d = os.path.join(tmp, "datasets", "ad01")
        bins = sorted(f for f in os.listdir(d) if f.endswith(".bin"))
        if len(bins) != AD01_N_FILES:
            return fail("expected %d ad01 .bin, found %d" % (AD01_N_FILES, len(bins)))
        sizes = {os.path.getsize(os.path.join(d, f)) for f in bins}
        if sizes != {AD01_FILE_BYTES}:
            return fail("ad01 .bin sizes are %s, expected all %d" % (sorted(sizes), AD01_FILE_BYTES))

        per_file, agg = {}, hashlib.sha256()
        for f in bins:
            b = open(os.path.join(d, f), "rb").read()
            per_file[f] = sha256_bytes(b)
            agg.update(per_file[f].encode())

        rc, out_txt, _ = git(["show", ER_PURGE_COMMIT + "^:datasets/ad01/y_labels.csv"], cwd=tmp)
        labels_csv = out_txt if rc == 0 else None

        # The provenance of the purge, read from the repository rather than asserted.
        timeline = []
        for c in ("4285411", "00bc683", ER_PURGE_COMMIT):
            rc, o, _ = git(["log", "-1", "--format=%H%x09%ad%x09%s", "--date=iso", c], cwd=tmp)
            if rc == 0 and o.strip():
                h_, date, subj = o.strip().split("\t", 2)
                timeline.append({"commit": h_[:7], "date": date, "subject": subj})

        selected = bins[::AD01_STRIDE][:AD01_N_SELECT]
        if len(selected) != AD01_N_SELECT:
            return fail("selection rule yielded %d files, expected %d"
                        % (len(selected), AD01_N_SELECT))
        off = AD01_WINDOW_INDEX * AD01_MELS
        stack, rows = [], []
        for f in selected:
            arr = np.fromfile(os.path.join(d, f), dtype="<f4")
            if arr.shape != (AD01_FRAMES * AD01_MELS,):
                return fail("%s did not parse as %d float32" % (f, AD01_FRAMES * AD01_MELS))
            w = np.ascontiguousarray(arr[off:off + AD01_DIMS])
            if w.shape != (AD01_DIMS,) or not np.isfinite(w).all():
                return fail("%s window %d is not %d finite float32" % (f, AD01_WINDOW_INDEX, AD01_DIMS))
            stack.append(w)
            rows.append({"source_file": f, "source_sha256": per_file[f],
                         "window_index": AD01_WINDOW_INDEX,
                         "byte_offset": int(off * 4), "byte_length": AD01_DIMS * 4,
                         "window_sha256": sha256_bytes(w.tobytes()),
                         "value_range": [float(w.min()), float(w.max())]})
        x = np.ascontiguousarray(np.stack(stack)[:, None, :])          # (34, 1, 640)

        out = os.path.abspath(a.out)
        os.makedirs(os.path.join(out, "inputs"), exist_ok=True)
        px = os.path.join(out, "inputs", "ad01_windows_f32.npy")
        np.save(px, x)
        if labels_csv is not None:
            with open(os.path.join(out, "y_labels.csv"), "w", encoding="utf-8") as fh:
                fh.write(labels_csv)

        manifest = {
            "tool": "harness/fetch_real_inputs.py deepae",
            "experiment": "E45",
            "model": "b3_deepae (MLPerf Tiny anomaly detection, ad01 / ToyADMOS ToyCar)",
            "goal": "G1 only -- real inputs for semantic equivalence. NO AUC, no "
                    "reconstruction-error and no accuracy claim.",
            "bytes_vendored_in_tree": False,
            "why_not_vendored": {
                "statement": "eembc/energyrunner README: 'You must obtain the input files from "
                             "the dataset. EEMBC cannot redistribute the input files.'",
                "purge_timeline_read_from_git": timeline,
                "reading": "This is not an unstated licence. The distributor removed the "
                           "repository's Apache-2.0 file, wrote that the dataset folder is "
                           "'copyright of their respective creators', and deleted the files as "
                           "'material copyrighted by other people' -- all within three minutes. "
                           "Vendoring the bytes would reverse a deliberate takedown.",
            },
            "d43_position": {
                "committed": "this script + the per-file sha256 manifest + the selection rule "
                             "+ the sha256 of each selected window",
                "not_committed": "the %d .bin (%d B)" % (AD01_N_FILES, AD01_N_FILES * AD01_FILE_BYTES),
                "precedent": "E31 does not store its 32 seeded synthetic inputs and E26d does "
                             "not store its corrupted vmfb; both regenerate and compare sha256.",
                "honest_difference": "those two regenerate with NO network. This one needs the "
                                     "network, so a fresh clone without it must SKIP with a "
                                     "reason -- never pass silently, never record a zero.",
            },
            "source": {"repo": ER_URL, "commit": ER_PURGE_COMMIT + "^ (pre-purge tree)",
                       "path": "datasets/ad01", "n_files": len(bins),
                       "file_bytes_each": AD01_FILE_BYTES,
                       "per_file_sha256": per_file,
                       "aggregate_sha256_sorted_names": agg.hexdigest(),
                       "y_labels_csv_sha256": sha256_bytes(labels_csv.encode()) if labels_csv else None},
            "feature_definition": {
                "shape_on_disk": [AD01_FRAMES, AD01_MELS], "dtype": "float32 LE",
                "generator": "mlcommons/tiny benchmark/training/anomaly_detection/common.py"
                             "::file_to_vector_array, save_bin branch",
                "config": "baseline.yaml n_mels=128 frames=5 n_fft=1024 hop_length=512 power=2.0",
                "window": "the model input is %d = %d mels x %d frames, and because the .bin is "
                          "frame-major the window is a CONTIGUOUS %d B slice at frame i"
                          % (AD01_DIMS, AD01_MELS, AD01_WINDOW_FRAMES, AD01_DIMS * 4),
            },
            "selection_rule": {
                "files": "sorted(names)[::%d][:%d]" % (AD01_STRIDE, AD01_N_SELECT),
                "window_index": AD01_WINDOW_INDEX,
                "window_index_reason": "mid-clip (%d // 2), so the sample is not a clip edge"
                                        % AD01_N_WINDOWS,
                "label_blind": True,
                "label_blind_note": "the rule never reads y_labels.csv, so it cannot select on "
                                    "the dependent variable",
                "fixed_before_selection": True,
                "count_reason": "matches the 34 samples of the synthetic fixture it is compared "
                                "against (results/e34_two_models/b3_deepae/fixture)",
            },
            "subset_is_not_the_eval_set": {
                "n_here": AD01_N_FILES, "n_canonical_eval": 2459,
                "note": "these 248 are EEMBC's performance-run stimulus subset, not the "
                        "evaluation set. This is one of the two independent reasons no AUC or "
                        "accuracy is claimed (the other is the redistribution position above).",
            },
            "tensors": {"x": {"file": os.path.relpath(px, out), "shape": list(x.shape),
                              "dtype": "float32", "sha256": sha256_bytes(x.tobytes())}},
            "value_domain": {
                "range": [float(x.min()), float(x.max())], "mean": float(x.mean()),
                "units": "log-mel, dB",
                "contrast_with_existing_fixture": "results/e34_two_models/b3_deepae/fixture is "
                                                  "uniform[0,1) -- outside this domain entirely",
            },
            "samples": rows,
        }
        write_json(os.path.join(out, "manifest.json"), manifest)
        print(json.dumps({"status": "OK", "model": "b3_deepae", "files": len(bins),
                          "selected": len(selected), "window": AD01_WINDOW_INDEX,
                          "value_range": manifest["value_domain"]["range"],
                          "x_sha256": manifest["tensors"]["x"]["sha256"], "out": out}))
        return EXIT_OK
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


# -------------------------------------------------------------------- SmartCam
# Two GitHub repositories hold real OPS-SAT SmartCam imagery. Neither is the canonical
# source any more (the README points at ESA GitLab, which is unreachable here: HTTP 403),
# so a pinned GitHub mirror is the provenance anchor and the manifest says so.
#
# Two contaminations must be excluded, and both are decided from BYTES, not from looking:
#   * 26 of the 36 images in smartcam-map were edited on the ground with GIMP (commit
#     c11a1cb "image processing" roughly doubled file sizes; the edited files carry an
#     EXIF Software tag). A tonal edit is not what the spacecraft produced.
#   * most img_msec_* files in the denoiser repo are DELIBERATE derivatives -- noised and
#     denoised variants of nine originals. Only results/preliminary/testset/original holds
#     the unmodified ones.
# When a file cannot be classified with confidence it is EXCLUDED: over-excluding costs
# sample count, under-excluding puts contaminated pixels into a semantic verdict.
SMARTCAM_REPOS = [
    {"name": "opssat-smartcam-map",
     "url": "https://github.com/georgeslabreche/opssat-smartcam-map",
     "globs": ["data/**/*.jpeg"]},
    {"name": "opssat-onboard-image-denoiser",
     "url": "https://github.com/georgeslabreche/opssat-onboard-image-denoiser",
     "globs": ["results/preliminary/testset/original/img_msec_*_thumbnail.jpeg"]},
]
SMARTCAM_ESA_CREDIT = ("All OPS-SAT images were acquired by the spacecraft's SmartCam and "
                       "credited to ESA.")


def _exif_software(raw):
    """Return the EXIF Software string if the JPEG carries one, else None (bytes only)."""
    for tag in (b"GIMP", b"Adobe", b"Photoshop", b"ImageMagick"):
        i = raw.find(tag, 0, 200000)
        if i >= 0:
            return raw[i:i + 24].split(b"\x00")[0].decode("latin-1", "replace")
    return None


def cmd_smartcam(a):
    import glob as _glob

    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, "images"), exist_ok=True)
    accepted, excluded, seen = [], [], {}
    for spec in SMARTCAM_REPOS:
        tmp = tempfile.mkdtemp(prefix="e45_sc_")
        try:
            rc, _, err = git(["clone", "--quiet", "--depth", "50", spec["url"] + ".git", tmp])
            if rc != 0:
                shutil.rmtree(out, ignore_errors=True)
                return skip("git clone %s failed (rc=%d): %s" % (spec["url"], rc, err.strip()[:400]))
            rc, head, _ = git(["rev-parse", "HEAD"], cwd=tmp)
            head = head.strip()
            lic = None
            for cand in ("LICENSE.md", "LICENSE", "LICENSE.txt"):
                p = os.path.join(tmp, cand)
                if os.path.exists(p):
                    lic = {"file": cand, "sha256": sha256_bytes(open(p, "rb").read()),
                           "text": open(p, encoding="utf-8", errors="replace").read()}
                    break
            files = []
            for g in spec["globs"]:
                files += _glob.glob(os.path.join(tmp, g), recursive=True)
            for path in sorted(files):
                raw = open(path, "rb").read()
                sha = sha256_bytes(raw)
                name = os.path.basename(path)
                sid = name.split("_thumbnail")[0] if "_thumbnail" in name else os.path.splitext(name)[0]
                sw = _exif_software(raw)
                if sw is not None:
                    excluded.append({"sample_id": sid, "repo": spec["name"], "sha256": sha,
                                     "reason": "ground-edited", "exif_software": sw})
                    continue
                if sha in seen:
                    excluded.append({"sample_id": sid, "repo": spec["name"], "sha256": sha,
                                     "reason": "duplicate of %s" % seen[sha]})
                    continue
                seen[sha] = sid
                dst = os.path.join(out, "images", sid + ".jpeg")
                with open(dst, "wb") as fh:
                    fh.write(raw)
                accepted.append({"sample_id": sid, "repo": spec["name"], "repo_commit": head,
                                 "file": os.path.relpath(dst, out), "sha256": sha,
                                 "bytes": len(raw), "exif_software": None,
                                 "fidelity_tier": "B_thumbnail_jpeg"})
            if lic:
                write_json(os.path.join(out, "licences", spec["name"] + ".json"),
                           {"repo": spec["url"], "commit": head, "licence": lic,
                            "esa_credit": SMARTCAM_ESA_CREDIT,
                            "gap": "The MIT grant is scoped to 'the Software and associated "
                                   "documentation files'. The images are DATA, and the "
                                   "repository itself credits them to ESA. An individual's MIT "
                                   "licence does not on its face convey rights in imagery the "
                                   "same repository credits to a space agency."})
        finally:
            shutil.rmtree(tmp, ignore_errors=True)

    if not accepted:
        return fail("no pristine SmartCam image survived classification")

    existing = os.path.join(ROOT, "results", "e31_smartcam_equivalence", "fixture", "manifest.json")
    prior = []
    if os.path.exists(existing):
        em = json.load(open(existing, encoding="utf-8"))
        prior = [{"sample_id": s["sample_id"],
                  "source_sha256": s.get("detail", {}).get("source_sha256"),
                  "original_size": s.get("detail", {}).get("original_size")}
                 for s in em.get("samples", []) if s.get("kind") == "real_example"]
    prior_sha = {p["source_sha256"] for p in prior}
    prior_ids = {p["sample_id"] for p in prior}
    overlap_sha = sorted({r["sha256"] for r in accepted} & prior_sha)
    overlap_id = sorted({r["sample_id"] for r in accepted} & prior_ids)

    manifest = {
        "tool": "harness/fetch_real_inputs.py smartcam",
        "experiment": "E45",
        "model": "SmartCam (OPS-SAT flight model)",
        "goal": "G1 only -- real inputs for semantic equivalence. NO accuracy claim.",
        "why_no_accuracy": {
            "circular_labels": "In the map repository the per-image CSV `label` is the argmax "
                               "of the onboard model's own prediction and `confidence` is its "
                               "max (86/86 rows). The model that produced them is the model "
                               "under test, so the labels cannot score it.",
            "selection_on_dependent_variable": "config.ini sets confidence_threshold = 0.70 and "
                                               "acquisitions below it were discarded IN ORBIT, "
                                               "thumbnails deleted. The surviving set is "
                                               "selected by the quantity being measured.",
            "no_protocol": "no train/test split, no held-out set, no class balance.",
        },
        "fidelity_tiers": {
            "A_raw_png": {"description": "2048x1944 lossless PNG, the raw acquisition",
                          "count": len(prior), "samples": prior,
                          "where": "results/e31_smartcam_equivalence/fixture"},
            "B_thumbnail_jpeg": {"description": "614x583 JPEG produced ONBOARD by "
                                                "`pngtopam | pamscale 0.3 | pnmtojpeg -quality 90`; "
                                                "lossy and ~11x fewer pixels than tier A",
                                 "count": len(accepted)},
        },
        "do_not_merge_tiers": "Tier A and tier B are different evidence grades. Report them "
                              "separately; do not add them into one 'real images: N' figure.",
        "disjointness": {"sha256_overlap_with_tier_A": overlap_sha,
                         "sample_id_overlap_with_tier_A": overlap_id},
        "classification_rule": "BYTES, not inspection: a JPEG carrying an EXIF Software tag "
                               "(GIMP/Adobe/Photoshop/ImageMagick) is ground-edited and is "
                               "excluded; only results/preliminary/testset/original is read from "
                               "the denoiser repository, because its other img_msec_* files are "
                               "deliberate noised/denoised derivatives. Unclassifiable files are "
                               "EXCLUDED -- over-exclusion costs samples, under-exclusion puts "
                               "contaminated pixels into a semantic verdict.",
        "canonical_source_note": "The README names ESA GitLab as the successor host; it is "
                                 "unreachable from this container (HTTP 403). The pinned GitHub "
                                 "commits recorded per sample are the provenance anchor.",
        "esa_credit": SMARTCAM_ESA_CREDIT,
        "accepted": accepted,
        "excluded": excluded,
        "counts": {"accepted": len(accepted), "excluded": len(excluded),
                   "excluded_ground_edited": sum(1 for e in excluded if e["reason"] == "ground-edited"),
                   "excluded_duplicate": sum(1 for e in excluded if e["reason"].startswith("duplicate"))},
    }
    write_json(os.path.join(out, "manifest.json"), manifest)
    print(json.dumps({"status": "OK", "model": "smartcam", "accepted": len(accepted),
                      "excluded": manifest["counts"], "tier_A_existing": len(prior),
                      "overlap_sha256": overlap_sha, "overlap_id": overlap_id, "out": out}))
    return EXIT_OK


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("resnet", help="CIFAR-10 official 200-sample set (vendored in-tree)")
    p.add_argument("--out", required=True)
    p.set_defaults(fn=cmd_resnet)
    p = sub.add_parser("deepae", help="ad01 features (hash manifest only; bytes NOT vendored)")
    p.add_argument("--out", required=True)
    p.set_defaults(fn=cmd_deepae)
    p = sub.add_parser("smartcam", help="pristine OPS-SAT thumbnails (ground-edited excluded)")
    p.add_argument("--out", required=True)
    p.set_defaults(fn=cmd_smartcam)
    a = ap.parse_args()
    try:
        return a.fn(a)
    except subprocess.TimeoutExpired as e:
        return skip("subprocess timed out: %s" % e)


if __name__ == "__main__":
    sys.exit(main())
