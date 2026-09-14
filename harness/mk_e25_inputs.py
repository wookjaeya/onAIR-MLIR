#!/usr/bin/env python3
"""E48 SS4-3: build the guest's `/cf/e25_inputs.bin` and its replay order FROM a fixture.

Until E48 this file was produced by hand beside the runs (E25/E32/E36b), so the one thing a
reader needs in order to trust a cFS equivalence cell -- *which inputs did it replay?* -- was
not derivable from the repository.  It is the same class of gap D71 closed for the OnAIR
telemetry declaration and E23 closed for the A5b corruption: the number was real, the
procedure was not in code.

The app reads the file as a flat run of f32 vectors of CONTRACT_INPUT_ELEMS each
(`ai_learner.c` SS548) and writes CONTRACT_OUTPUT_ELEMS f32 per completed inference, in the
same order.  So the order file is not a guess about the binary -- it is the list this tool
wrote it from, and `e32_cfs_outputs.py` re-hashes every input against the fixture manifest
before scoring, which is what makes the pairing checkable rather than assumed.

Fail-closed, both directions:
  * every sample's .npy is hashed against the manifest and a mismatch REFUSES (plan SS6 P1 --
    comparing against a differently-generated fixture is the silent version of this failure);
  * the entry layout is taken as a VALUE (--layout nchw|nhwc), never branched on the model;
  * the element count is checked against the contract when one is given, so a fixture built
    for another model cannot be staged as this one's inputs.

    python3 harness/mk_e25_inputs.py --fixture FX --layout nchw \
        --contract results/.../b2_resnet.contract.json \
        --out-bin /tmp/e25_inputs.bin --out-order results/.../replay_order.json
"""
import argparse
import hashlib
import json
import os
import sys

import numpy as np


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def contract_input_elems(path):
    with open(path, encoding="utf-8") as fh:
        con = json.load(fh)
    iface = con.get("interface") or {}
    ins = iface.get("inputs") or ([iface["input"]] if iface.get("input") else [])
    if len(ins) != 1:
        raise SystemExit("refusing: contract does not declare exactly one input: %s" % path)
    shape = ins[0].get("shape")
    if not shape or any((not isinstance(d, int)) or d <= 0 for d in shape):
        raise SystemExit("refusing: contract input shape is not fully static: %r" % (shape,))
    n = 1
    for d in shape:
        n *= d
    return n, shape


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fixture", required=True, help="fixture dir with manifest.json + inputs/")
    ap.add_argument("--layout", default="nchw", choices=["nchw", "nhwc"],
                    help="which array of each sample the entry takes -- a VALUE, not a per-model branch")
    ap.add_argument("--contract", default=None, help="contract of the vmfb that will replay these")
    ap.add_argument("--kinds", default=None,
                    help="comma list of sample kinds to include (default: all, in manifest order)")
    ap.add_argument("--out-bin", required=True)
    ap.add_argument("--out-order", required=True)
    a = ap.parse_args()

    fx = os.path.abspath(a.fixture)
    with open(os.path.join(fx, "manifest.json"), encoding="utf-8") as fh:
        man = json.load(fh)
    keep = set(a.kinds.split(",")) if a.kinds else None

    want_elems = want_shape = None
    if a.contract:
        want_elems, want_shape = contract_input_elems(a.contract)

    vecs, order, checked = [], [], 0
    for s in man["samples"]:
        if keep is not None and s.get("kind") not in keep:
            continue
        ent = s.get(a.layout)
        if ent is None:
            raise SystemExit("refusing: sample %s has no %s array" % (s.get("sample_id"), a.layout))
        p = os.path.join(fx, ent["file"])
        arr = np.load(p)
        # The manifest hashes the ARRAY bytes, not the .npy file (model_fixture.py :251 --
        # `sha256_bytes(nchw.tobytes())`), and e32_cfs_outputs.py :88 re-hashes the same way.
        # This tool's first version hashed the file and refused all three honest fixtures:
        # a type-(B) over-rejection in the very check that exists to prevent scoring against
        # the wrong inputs. Caught before it reached a verdict, recorded because the direction
        # matters -- a wrong hash rule fails closed here, but only because it fails on
        # everything, which is not the same as being right.
        got = hashlib.sha256(arr.tobytes()).hexdigest()
        if got != ent["sha256"]:
            # plan SS6 P1: a regenerated fixture that differs is not a comparison, it is a
            # different experiment wearing the same name.
            raise SystemExit("refusing: %s sha256 %s != manifest %s" % (p, got[:16], ent["sha256"][:16]))
        checked += 1
        arr = arr.astype(np.float32, copy=False).reshape(-1)
        if want_elems is not None and arr.size != want_elems:
            raise SystemExit("refusing: %s has %d elements, contract entry takes %d (shape %r)"
                             % (ent["file"], arr.size, want_elems, want_shape))
        vecs.append(arr)
        order.append({"sample_id": s["sample_id"], "kind": s.get("kind")})

    if not vecs:
        raise SystemExit("refusing: no samples selected (kinds=%s)" % a.kinds)

    blob = np.concatenate(vecs)
    os.makedirs(os.path.dirname(os.path.abspath(a.out_bin)) or ".", exist_ok=True)
    blob.tofile(a.out_bin)
    os.makedirs(os.path.dirname(os.path.abspath(a.out_order)) or ".", exist_ok=True)
    with open(a.out_order, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(order, ensure_ascii=False) + "\n")

    print(json.dumps({
        "fixture": fx, "layout": a.layout, "samples": len(order),
        "elems_per_sample": int(vecs[0].size), "bytes": int(blob.nbytes),
        "sha256_inputs_bin": sha256_file(a.out_bin),
        "manifest_hashes_verified": checked,
        "contract": a.contract, "contract_input_elems": want_elems,
        "out_bin": a.out_bin, "out_order": a.out_order,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
