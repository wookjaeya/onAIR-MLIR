#!/usr/bin/env python3
"""E61: the reference outputs of tab:outputs, produced on the evaluation target.

Plan: docs/plans/E61_reference_outputs_on_target.md (committed before the guest runs, 964b18d).
Until now every reference (the original TensorFlow Lite runtime's output) was produced on the
ground side.  This script has two guest-side helpers and one ground-side judge; the comparison
rule is e31_compare.py's, called unchanged (no second judge, no second rule), and the E60 layer
comparison uses e52_deepae_layers' helpers (imported, not copied -- E44).

    (guest)  python3 tflite_oracle.py <model> --fixture <fx> --out oracle_<model>.json   # unchanged tool
    (guest)  python3 e61_reference_on_target.py guest-layers --input <npy> --tflite <ad01> --out layers.json
    python3 harness/e61_reference_on_target.py judge --guest <dir-with-guest-records>
"""
import argparse
import gzip
import hashlib
import json
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
OUT_DIR = os.path.join("results", "e61_reference_on_target")
PLAN = "docs/plans/E61_reference_outputs_on_target.md (committed before the guest runs, 964b18d)"

# model -> (ground-side reference, archived target outputs to re-judge, argmax mode)
MODELS = {
    "b2_resnet": {"ground": "results/e45_real_inputs/cells/b2_resnet/oracle_tflite.json",
                  "manifest": "results/e45_real_inputs/cells/b2_resnet/fixture/manifest.json",
                  "targets": {"native": "results/e48_real_inputs_aarch64/b2_resnet/native_real.json",
                              "cfs": "results/e48_real_inputs_aarch64/b2_resnet/iree_cfs_aarch64.json"},
                  "archived": {"native": "results/e48_real_inputs_aarch64/b2_resnet/comparison_native_aarch64.json",
                               "cfs": "results/e48_real_inputs_aarch64/b2_resnet/comparison_cfs_aarch64.json"},
                  "argmax": "require"},
    "b3_deepae": {"ground": "results/e45_real_inputs/cells/b3_deepae/oracle_tflite.json",
                  "manifest": "results/e45_real_inputs/cells/b3_deepae/fixture/manifest.json",
                  "targets": {"native": "results/e48_real_inputs_aarch64/b3_deepae/native_real.json",
                              "cfs": "results/e48_real_inputs_aarch64/b3_deepae/iree_cfs_aarch64.json"},
                  "archived": {"native": "results/e48_real_inputs_aarch64/b3_deepae/comparison_native_aarch64.json",
                               "cfs": "results/e48_real_inputs_aarch64/b3_deepae/comparison_cfs_aarch64.json"},
                  "argmax": "require"},
    "smartcam": {"ground": "results/e45_real_inputs/cells/smartcam/oracle_tflite.json",
                 "manifest": "results/e45_real_inputs/cells/smartcam/fixture/manifest.json",
                 "targets": {"native": "results/e48_real_inputs_aarch64/smartcam/native_real.json",
                             "cfs": "results/e48_real_inputs_aarch64/smartcam/iree_cfs_aarch64.json"},
                 "archived": {"native": "results/e48_real_inputs_aarch64/smartcam/comparison_native_aarch64.json",
                              "cfs": "results/e48_real_inputs_aarch64/smartcam/comparison_cfs_aarch64.json"},
                 "argmax": "require"},
    # WGAN: E53's target outputs are committed as the app's raw NCHW float32 bytes; the runner record
    # is rebuilt from them (the NCHW->NHWC transpose E53 applied -- checked against E53's own record once).
    "wgan": {"ground": None,
             "manifest": "results/e46_wgan/cell/fixture/manifest.json",
             "targets_raw": {"native": "results/e53_wgan_aarch64/native/e25_outputs_1sample.bin",
                             "cfs": "results/e53_wgan_aarch64/cfs/logs/cfs_B.e25_outputs.bin"},
             "archived": {"native": "results/e53_wgan_aarch64/native/comparison_native_aarch64.json",
                          "cfs": "results/e53_wgan_aarch64/comparison_cfs_aarch64.json"},
             "sample": "img_msec_1536095035794_2_thumbnail",
             "argmax": "not-applicable"},
}
TFLITE = {"b2_resnet": "results/e34_two_models/originals/pretrainedResnet.tflite",
          "b3_deepae": "results/e34_two_models/originals/ad01_fp32.tflite",
          "smartcam": "results/p1_smartcam_feasibility/original/model.tflite",
          "wgan": "results/e46_wgan/original/wgan_fpn50_f.tflite"}


def _load(path):
    p = os.path.join(ROOT, path) if not os.path.isabs(path) else path
    if p.endswith(".gz"):
        with gzip.open(p, "rt", encoding="utf-8") as fh:
            return json.load(fh)
    with open(p, encoding="utf-8") as fh:
        return json.load(fh)


def guest_layers(a):
    """Guest side: LiteRT's intermediates for the E60 window, with E52's preserving-run check."""
    import platform
    import numpy as np
    sys.path.insert(0, HERE)
    import e52_deepae_layers as e52
    x = np.load(a.input).astype(np.float32).reshape(1, 640)
    acts, meta = e52.litert_layers(os.path.abspath(a.tflite), x)
    json.dump({"machine": platform.machine(), "tflite_sha256": hashlib.sha256(open(a.tflite, "rb").read()).hexdigest(),
               "input_sha256": hashlib.sha256(np.ascontiguousarray(np.load(a.input)).tobytes()).hexdigest(),
               "meta": meta, "layers": [None if v is None else [float(t) for t in np.asarray(v).reshape(-1)]
                                        for v in acts]}, open(a.out, "w"))
    print("layers written on %s; preserving run matches default: %s"
          % (platform.machine(), meta["preserving_run_matches_default_output_bitwise"]))


def wgan_runner_record(raw, which):
    import numpy as np
    y = np.fromfile(os.path.join(ROOT, raw), dtype=np.float32)
    if y.size != 3 * 224 * 224:
        raise SystemExit("WGAN raw output %s has %d elements, not 150528" % (raw, y.size))
    y = y.reshape(1, 3, 224, 224).transpose(0, 2, 3, 1)
    m = _load(MODELS["wgan"]["manifest"])
    s = next(s for s in m["samples"] if s["sample_id"] == MODELS["wgan"]["sample"])
    return {"tool": "harness/e61_reference_on_target.py (rebuilt from the committed raw app output)",
            "runner": "E53 %s AArch64 IREE C runtime, raw NCHW float32 -> NHWC" % which,
            "output_layout": "nchw_to_nhwc", "raw_sha256": hashlib.sha256(open(os.path.join(ROOT, raw), "rb").read()).hexdigest(),
            "fixture": {"dir": MODELS["wgan"]["manifest"], "total_samples": 1},
            "results": [{"sample_id": s["sample_id"], "kind": s["kind"], "input_sha256": s["nchw"]["sha256"],   # the tensor IREE consumed (as E53)
                         "output": [float(v) for v in y.reshape(-1)], "output_shape": list(y.shape),
                         "argmax": int(np.argmax(y)), "sum": float(y.sum())}]}


def _q1(guest, ground, ids):
    import numpy as np
    gb = {r["sample_id"]: r for r in guest["results"]}
    hb = {r["sample_id"]: r for r in ground["results"]}
    same, worst, rows = 0, 0.0, []
    for i in ids:
        g = np.asarray(gb[i]["output"], dtype=np.float32)
        h = np.asarray(hb[i]["output"], dtype=np.float32)
        eq = bool(np.array_equal(g, h))
        d = float(np.max(np.abs(g.astype(np.float64) - h.astype(np.float64)))) if g.size == h.size else None
        same += eq
        worst = max(worst, d or 0.0)
        if not eq:
            rows.append({"sample_id": i, "max_abs_diff": d})
    return {"samples": len(ids), "bitwise_identical_samples": same, "max_abs_diff_over_samples": worst,
            "differing_samples": rows}


def judge(a):
    import numpy as np
    out_dir = a.out or os.path.join(ROOT, OUT_DIR)
    os.makedirs(os.path.join(out_dir, "comparisons"), exist_ok=True)
    doc = {"experiment": "E61", "plan": PLAN, "generated_by": "harness/e61_reference_on_target.py",
           "rule": "e31_compare.py, unchanged (E25: per element abs<=1e-4 OR rel<=1e-5)", "models": {}}
    tmp = tempfile.mkdtemp(prefix="e61_")
    for m, cfg in MODELS.items():
        gpath = os.path.join(a.guest, "oracle_%s.json.gz" % m)
        rec = {"guest_reference": os.path.relpath(gpath, ROOT) if gpath.startswith(ROOT) else gpath}
        if not os.path.exists(gpath):
            rec.update({"valid": False, "invalid_reason": "guest reference absent"})
            doc["models"][m] = rec
            continue
        g = _load(gpath)
        man = _load(cfg["manifest"])
        want_ids = [cfg["sample"]] if m == "wgan" else [s["sample_id"] for s in man["samples"]]
        by_man = {s["sample_id"]: s["nhwc"]["sha256"] for s in man["samples"]}
        why = []
        if g.get("machine") != "aarch64":
            why.append("machine=%r" % g.get("machine"))
        tsha = hashlib.sha256(open(os.path.join(ROOT, TFLITE[m]), "rb").read()).hexdigest()
        if g["model"]["sha256"] != tsha:
            why.append("model sha256 %s != preserved original %s" % (g["model"]["sha256"][:12], tsha[:12]))
        gids = [r["sample_id"] for r in g["results"]]
        if gids != want_ids:
            why.append("sample ids differ from the fixture manifest")
        if any(r["input_sha256"] != by_man.get(r["sample_id"]) for r in g["results"]):
            why.append("an input sha256 differs from the manifest")
        rec.update({"valid": not why, "invalid_reason": "; ".join(why) or None, "machine": g.get("machine"),
                    "model_sha256": g["model"]["sha256"], "samples": len(gids)})
        if why:
            doc["models"][m] = rec
            continue
        ground = _load(cfg["ground"]) if cfg["ground"] else (_load(a.wgan_ground) if a.wgan_ground else None)
        if ground is not None:
            rec["Q1"] = _q1(g, ground, want_ids)
            rec["Q1"]["ground_reference"] = cfg["ground"] or a.wgan_ground
            if not cfg["ground"]:
                rec["Q1"]["ground_reference_note"] = ("not in the repository: E53 cited this ground-side file by a /tmp "
                                                      "path; Q1 for WGAN is re-derivable only where that file exists")
        else:
            rec["Q1"] = {"unavailable_reason": "ground-side WGAN reference not supplied (--wgan-ground)"}
        # Q2: re-judge the archived target outputs against the GUEST reference, same options as before
        ogz = os.path.join(tmp, "oracle_%s.json" % m)
        json.dump(g, open(ogz, "w"))
        rec["Q2"] = {}
        for which in ("native", "cfs"):
            if m == "wgan":
                ip = os.path.join(tmp, "iree_%s_%s.json" % (m, which))
                json.dump(wgan_runner_record(cfg["targets_raw"][which], which), open(ip, "w"))
                target = cfg["targets_raw"][which]
            else:
                ip = os.path.join(ROOT, cfg["targets"][which])
                target = cfg["targets"][which]
            cp = os.path.join(out_dir, "comparisons", "%s_%s.json" % (m, which))
            cmd = [sys.executable, os.path.join(HERE, "e31_compare.py"), "--oracle", ogz, "--iree", ip,
                   "--out", cp, "--argmax", cfg["argmax"], "--detail", "failures"]
            r = subprocess.run(cmd, capture_output=True, text=True)
            if r.returncode != 0:
                rec["Q2"][which] = {"error": (r.stderr or r.stdout)[-300:]}
                continue
            c = _load(cp)
            c["paths"]["oracle"]["file"] = rec["guest_reference"]
            c["paths"]["iree"]["file"] = target
            json.dump(c, open(cp, "w"), indent=1)
            arch = _load(cfg["archived"][which])
            rec["Q2"][which] = {"target_outputs": target, "verdict": c["verdict"], "totals": c["totals"],
                                "worst_element": c.get("worst_element"),
                                "ground_reference_verdict": arch["verdict"], "ground_reference_totals": arch["totals"],
                                "same_as_ground_reference": c["verdict"] == arch["verdict"] and
                                c["totals"]["elements_failed"] == arch["totals"]["elements_failed"] and
                                c["totals"]["argmax_failed"] == arch["totals"]["argmax_failed"]}
        doc["models"][m] = rec
    # E60 layers against the guest's own intermediates
    lp = os.path.join(a.guest, "e60_layers_litert.json.gz")
    if os.path.exists(lp):
        sys.path.insert(0, HERE)
        import e52_deepae_layers as e52
        gl = _load(lp)
        go = _load(os.path.join(ROOT, "results/e60_deepae_layers_aarch64/guest/guest_outputs.json"))
        tgt = [np.asarray(l["values"], dtype=np.float64) for l in sorted(go["layers"], key=lambda r: r["index"])]
        e60 = _load(os.path.join(ROOT, "results/e60_deepae_layers_aarch64/layers.json"))
        viol = [None if gl["layers"][i] is None else e52.violations(tgt[i], gl["layers"][i])["violations"]
                for i in range(10)]
        first = next((i for i, v in enumerate(viol) if v), None)
        doc["e60_layers"] = {
            "machine": gl["machine"], "input_sha256": gl["input_sha256"],
            "preserving_run_matches_default_output_bitwise": gl["meta"]["preserving_run_matches_default_output_bitwise"],
            "violations_per_layer_vs_guest_reference": viol, "L1_first_layer_over_tolerance": first,
            "L2_layer_with_most_violations": max(range(10), key=lambda i: viol[i] or 0) if any(viol) else None,
            "violations_per_layer_vs_ground_reference_E60": e60["violations_per_layer_vs_reference_runtime"],
            "guest_final_layer_equals_guest_oracle_for_this_window": None}
        g3 = _load(os.path.join(a.guest, "oracle_b3_deepae.json.gz"))
        row = next((r for r in g3["results"] if r["sample_id"] == e60["sample"]), None)
        if row is not None and gl["layers"][-1] is not None:
            doc["e60_layers"]["guest_final_layer_equals_guest_oracle_for_this_window"] = bool(
                np.array_equal(np.asarray(gl["layers"][-1], dtype=np.float32), np.asarray(row["output"], dtype=np.float32)))
    valid = [m for m, r in doc["models"].items() if r.get("valid")]
    doc["verdict"] = {"all_valid": len(valid) == len(MODELS),
                      "Q1_all_bitwise_identical": all(doc["models"][m].get("Q1", {}).get("bitwise_identical_samples")
                                                      == doc["models"][m].get("Q1", {}).get("samples") for m in valid),
                      "Q2_rows": {m: {w: (doc["models"][m]["Q2"][w].get("verdict"),
                                          doc["models"][m]["Q2"][w].get("totals", {}).get("elements_failed"))
                                      for w in ("native", "cfs")} for m in valid}}
    doc["not_claimed"] = ["LiteRT correctness or a third reference value", "accuracy (not an evaluation set, E45 SS5)",
                          "the mechanism of any difference between the two ISAs' LiteRT builds"]
    json.dump(doc, open(os.path.join(out_dir, "summary.json"), "w"), indent=1)
    print(json.dumps(doc["verdict"], indent=1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("step", choices=["guest-layers", "judge"])
    ap.add_argument("--input")
    ap.add_argument("--tflite")
    ap.add_argument("--guest", help="directory holding the guest records (oracle_<model>.json.gz, e60_layers_litert.json.gz)")
    ap.add_argument("--wgan-ground", help="ground-side WGAN reference (not in the repository; E53 cited a /tmp path)")
    ap.add_argument("--out")
    a = ap.parse_args()
    {"guest-layers": guest_layers, "judge": judge}[a.step](a)


if __name__ == "__main__":
    main()
