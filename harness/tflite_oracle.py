#!/usr/bin/env python3
"""E31 / P2: run the ORIGINAL .tflite and record its full output for every fixture sample.

This is the reference the imported IREE model is judged against (ninth external review
SS10 step 1: "원본 TFLite 실행 oracle을 확보한다"). It runs the flight artifact unmodified,
through `ai_edge_litert` (LiteRT's own interpreter), and writes every output element -- not a
summary, not an argmax. SS9.3 forbids calling two models equivalent because their argmax agrees.

The oracle reads the NHWC tensor from the shared fixture, so the resize/normalisation are the
fixture's, identical to what the IREE path will receive after the transpose.

Usage:
  tflite_oracle.py MODEL.tflite --fixture <fixture-dir> --out oracle.json
"""
import argparse, hashlib, json, os, sys

import numpy as np


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("model")
    ap.add_argument("--fixture", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    try:
        from ai_edge_litert.interpreter import Interpreter
    except ImportError as e:          # a decision, not a crash (D24/D25)
        print("tflite_oracle: ai_edge_litert not installed: %s" % e, file=sys.stderr)
        return 2

    blob = open(a.model, "rb").read()
    manifest = json.load(open(os.path.join(a.fixture, "manifest.json")))
    it = Interpreter(model_path=a.model)
    it.allocate_tensors()
    ins, outs = it.get_input_details(), it.get_output_details()
    if len(ins) != 1 or len(outs) != 1:
        print("tflite_oracle: expected a single input and output, got %d/%d" % (len(ins), len(outs)),
              file=sys.stderr)
        return 2
    inp, out = ins[0], outs[0]

    rows = []
    for s in manifest["samples"]:
        x = np.load(os.path.join(a.fixture, s["nhwc"]["file"]))
        if list(x.shape) != list(inp["shape"]):
            print("tflite_oracle: sample %s has shape %s, model wants %s"
                  % (s["sample_id"], list(x.shape), list(inp["shape"])), file=sys.stderr)
            return 2
        it.set_tensor(inp["index"], x)
        it.invoke()
        y = np.array(it.get_tensor(out["index"]), copy=True)
        rows.append({"sample_id": s["sample_id"], "kind": s["kind"],
                     "input_sha256": s["nhwc"]["sha256"],
                     "output": [float(v) for v in y.reshape(-1)],
                     "output_shape": list(y.shape), "output_dtype": str(y.dtype),
                     "argmax": int(np.argmax(y)), "sum": float(y.sum())})

    rec = {
        "tool": "harness/tflite_oracle.py",
        "runner": "ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified",
        "model": {"path": a.model, "bytes": len(blob), "sha256": hashlib.sha256(blob).hexdigest()},
        "interpreter_signature": {"input_shape": [int(v) for v in inp["shape"]],
                                  "input_dtype": inp["dtype"].__name__,
                                  "input_quantization": list(inp["quantization"]),
                                  "output_shape": [int(v) for v in out["shape"]],
                                  "output_dtype": out["dtype"].__name__},
        "fixture": {"dir": a.fixture, "total_samples": manifest["total_samples"]},
        "results": rows,
    }
    with open(a.out, "w") as fh:
        json.dump(rec, fh, indent=1)
    print(json.dumps({"model_sha256": rec["model"]["sha256"][:16], "samples": len(rows),
                      "signature": rec["interpreter_signature"]}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
