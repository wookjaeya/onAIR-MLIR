#!/usr/bin/env python3
"""E33 / stage 3: run this repository's plugin through NASA OnAIR's OWN driver and
loader, and collect what actually happened.

The point of this harness is that it does NOT import the plugin itself. It
materialises an official `.ini`, runs `python driver.py <ini>` inside the OnAIR
checkout, and reads back only what the run left behind. A test that imports
`AIPlugin` and calls the class directly proves nothing about the official loading
path (ninth review SS10 stage 3: "AIPlugin import를 흉내내는 stub 시험은 통합 완료가
아니다").

Two things are verified about the run itself rather than assumed:

  * that NASA's `plugin_import.import_plugins` really constructed our Plugin --
    checked by a marker the plugin writes at construction, not by our own log line;
  * that OnAIR core was not modified -- checked with `git status`/`git diff` inside
    the OnAIR checkout BEFORE and AFTER, because "we didn't mean to change it" is
    not evidence.

    python3 harness/onair_integration_check.py --deployment smartcam \
        --onair ~/onair-mlir-bench/ext/OnAIR --out results/e33_onair_official/p_admit
"""
import argparse
import json
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
DEF_ONAIR = os.path.expanduser("~/onair-mlir-bench/ext/OnAIR")


def git_state(repo):
    """Return a dict describing whether the checkout is dirty. Never raises."""
    def run(args):
        p = subprocess.run(["git", "-C", repo] + args, capture_output=True, text=True)
        return p.stdout.strip() if p.returncode == 0 else None
    return {"head": run(["rev-parse", "HEAD"]),
            "status_porcelain": run(["status", "--porcelain"]),
            # tracked-file changes only: an untracked artifact left by OnAIR's own
            # example run is not "we modified OnAIR core", and conflating the two
            # would make this check cry wolf on every checkout that has ever been used
            "tracked_dirty": run(["status", "--porcelain", "--untracked-files=no"]),
            "diff_stat": run(["diff", "--stat"])}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--deployment", required=True,
                    help="construct name; must exist in the deployment config")
    ap.add_argument("--config", default=os.path.join(ROOT, "configs", "deployments",
                                                     "onair_deployments.json"))
    ap.add_argument("--template", default=os.path.join(ROOT, "configs",
                                                       "onair_compiled_learner.ini"))
    ap.add_argument("--data-dir", default=os.path.join(ROOT, "configs", "onair_data"))
    ap.add_argument("--plugin-dir", default=os.path.join(ROOT, "plugins", "compiled_learner"))
    ap.add_argument("--onair", default=DEF_ONAIR)
    ap.add_argument("--timeout", type=int, default=3600)
    ap.add_argument("--out", required=True, help="directory for this cell's artifacts")
    a = ap.parse_args()

    if not os.path.isdir(a.onair):
        raise SystemExit("OnAIR checkout not found: %s" % a.onair)
    driver = os.path.join(a.onair, "driver.py")
    if not os.path.exists(driver):
        raise SystemExit("NASA driver.py not found: %s" % driver)

    os.makedirs(a.out, exist_ok=True)
    record = os.path.join(os.path.abspath(a.out), "plugin_records.jsonl")
    if os.path.exists(record):
        os.remove(record)

    # the deployment config the plugin will read, with this cell's record path injected
    with open(a.config, encoding="utf-8") as f:
        dep = json.load(f)
    if a.deployment not in dep["deployments"]:
        raise SystemExit("no deployment %r in %s" % (a.deployment, a.config))
    dep["deployments"][a.deployment]["record_path"] = record
    # keep relative paths resolvable: the plugin resolves them against the config's dir
    cell_config = os.path.join(os.path.abspath(a.out), "deployment.json")
    # E42/E43: this list used to be ("artifact_dir", "fixture_dir") -- the two keys the
    # compiled_learner deployment happens to use. The LiteRT baseline declares `model_file`
    # instead, and an unresolved `../..` path silently became `results/results/...` relative
    # to the CELL directory. It refused with a clear message (the plugin reports refusals as
    # state), but the harness had produced the wrong config in the first place.
    #
    # That is D62's pattern for the third time: a procedure set up for one deployment shape,
    # applied to another, is the test of that procedure. So rather than only adding the key,
    # the loop now REFUSES any `..`-relative path under a key it does not know how to resolve
    # -- a new deployment key can no longer be silently mis-rooted.
    #
    # The set stays explicit rather than "anything ending in _file": `contract_file` is a bare
    # filename joined to artifact_dir, and resolving it would make that join return the wrong
    # absolute path. Over-generalising here would be its own defect.
    PATH_KEYS = ("artifact_dir", "fixture_dir", "model_file")
    cfg_dir = os.path.dirname(os.path.abspath(a.config))
    for name, d in dep["deployments"].items():
        for key, val in d.items():
            if not isinstance(val, str) or key in PATH_KEYS or key.startswith("_"):
                continue
            if val.startswith("..") or val.startswith("./"):
                raise SystemExit(
                    "onair_integration_check: deployment %r carries a config-relative path "
                    "under %r (%r), which this harness does not know how to re-root. Add the "
                    "key to PATH_KEYS or make the value absolute -- silently leaving it "
                    "relative would re-root it against the cell directory." % (name, key, val))
        for key in PATH_KEYS:
            if d.get(key) and not os.path.isabs(d[key]):
                d[key] = os.path.normpath(os.path.join(cfg_dir, d[key]))
    with open(cell_config, "w", encoding="utf-8") as f:
        json.dump(dep, f, indent=1)

    # the official ini, with absolute paths substituted into the template
    with open(a.template, encoding="utf-8") as f:
        ini = f.read()
    # E41: the telemetry file is per-cell, not per-template. It used to be hardcoded
    # to smartcam_replay, so the archived E33 p_legacy cell -- which needs the 9-field
    # legacy_mlp.csv -- could not be regenerated from repository contents: a fresh run
    # fed it 2 fields and the plugin refused. The cell says which telemetry it needs.
    telemetry = dep["deployments"][a.deployment].get("telemetry")
    if not telemetry:
        raise SystemExit("onair_integration_check: deployment %r declares no `telemetry` "
                         "(which configs/onair_data/<name>.csv to feed OnAIR); refusing to "
                         "guess -- a wrong telemetry file changes what the cell measured"
                         % a.deployment)
    ini = (ini.replace("ONAIR_MLIR_DATA_DIR", os.path.abspath(a.data_dir))
              .replace("ONAIR_MLIR_PLUGIN_DIR", os.path.abspath(a.plugin_dir))
              .replace("ONAIR_MLIR_TELEMETRY", telemetry)
              .replace("'smartcam':", "'%s':" % a.deployment))
    cell_ini = os.path.join(os.path.abspath(a.out), "onair.ini")
    with open(cell_ini, "w", encoding="utf-8") as f:
        f.write(ini)

    before = git_state(a.onair)
    env = dict(os.environ)
    env["ONAIR_MLIR_DEPLOYMENT_CONFIG"] = cell_config
    env["PYTHONPATH"] = os.pathsep.join(x for x in (a.onair, env.get("PYTHONPATH", "")) if x)
    p = subprocess.run([sys.executable, "driver.py", cell_ini], cwd=a.onair, env=env,
                       capture_output=True, text=True, timeout=a.timeout)
    after = git_state(a.onair)

    records = []
    if os.path.exists(record):
        with open(record, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        records.append(json.loads(line))
                    except ValueError:
                        pass
    init = next((r for r in records if r.get("event") == "init"), None)
    infers = [r for r in records if r.get("event") == "inference"]

    doc = {
        "tool": "harness/onair_integration_check.py",
        "deployment": a.deployment,
        "onair": {"path": a.onair, "head": before["head"],
                  "core_unmodified": (not (before["tracked_dirty"] or "").strip()
                                      and not (after["tracked_dirty"] or "").strip()),
                  "untracked_unchanged": before["status_porcelain"] == after["status_porcelain"],
                  "tracked_dirty_before": before["tracked_dirty"],
                  "tracked_dirty_after": after["tracked_dirty"],
                  "status_before": before["status_porcelain"],
                  "status_after": after["status_porcelain"],
                  "check_note": "OnAIR core must be untouched: no TRACKED file may be modified "
                                "before or after the run. Untracked files left by OnAIR's own "
                                "example runs are reported separately and are not a modification"},
        "invocation": {"cmd": [sys.executable, "driver.py", os.path.basename(cell_ini)],
                       "cwd": a.onair, "env_var": "ONAIR_MLIR_DEPLOYMENT_CONFIG",
                       "ini": cell_ini, "deployment_config": cell_config},
        "returncode": p.returncode,
        "plugin_constructed": init is not None,
        "plugin_init": init,
        "inferences": len(infers),
        "stdout_tail": (p.stdout or "")[-4000:],
        "stderr_tail": (p.stderr or "")[-4000:],
        "records_file": record,
    }
    with open(os.path.join(a.out, "run.json"), "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=1)
    print(json.dumps({"deployment": a.deployment, "returncode": p.returncode,
                      "plugin_constructed": doc["plugin_constructed"],
                      "active": (init or {}).get("active"),
                      "inferences": len(infers),
                      "onair_core_unmodified": doc["onair"]["core_unmodified"]}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
