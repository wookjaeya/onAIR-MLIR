"""CompiledLearner: an OnAIR Learner whose inference runs in an MLIR/IREE
ahead-of-time compiled artifact instead of a Python ML framework.

Conforms to onair.src.ai_components.ai_plugin_abstract.ai_plugin.AIPlugin:
  __init__(name, headers), update(low_level_data, high_level_data), render_reasoning()

**The official loader passes two arguments and only two.** `plugin_import.py:49`
calls `plugin.Plugin(construct_name, headers)`, so extra constructor keywords are
unreachable from an official OnAIR config. Deployment settings therefore come from
a JSON file named by the environment variable `ONAIR_MLIR_DEPLOYMENT_CONFIG`, keyed
by `construct_name`. This is a proposed interface; it does not modify OnAIR core.
(ninth review SS6.1; E33)

Input modes, because `AIPlugin` asserts `len(headers) > 0` while an image input
must NOT be spread over 150,528 header fields (ninth review SS6.1):

  telemetry    headers are frame field names; the tensor comes from low_level_data.
               This is the original convention and the MLP path still uses it.
  file_replay  ONE header carries a numeric sample INDEX; the tensor is read from
               the shared fixture. This is how a real image model is replayed.

               The index is numeric because NASA's own CSV parser calls
               `floatify_input`, which turns any non-numeric string into **0.0**
               (`onair/data_handling/parser_util.py:49-65`). A string sample id would
               therefore arrive as 0.0 and every frame would silently replay sample
               zero. The deployment config supplies the ordered `sample_ids`, and an
               index outside that list refuses rather than wrapping.

The two modes are never mixed, and `render_reasoning()` reports which one ran.

Design points carried over and the reasons they exist:

* Three timing boundaries are recorded separately, because a compiled kernel still
  runs behind a Python wrapper (L1 kernel / L2a update / L2b reason). Any claim
  about "inference latency" must state its boundary. Samples are kept in a FIXED
  length ring: an OnAIR run is open-ended and a list that grows per call is a leak,
  not telemetry (ninth review SS6.1, last row).

* Admission is decided BEFORE the runtime is created, by `harness/admission_policy`,
  which is the same decision the C gate makes. A refusal leaves the plugin inactive
  with a stated reason instead of raising through the OnAIR process (SS6.1).

* The verdict carries the budget it was decided ON, and the peak is compared with
  THAT number -- E32/D59 measured a conditional deployment running at 106.4% of its
  approved budget while reporting `peak_within_bounded: true`.

* Contract-artifact binding (external review F10, v0.18/E23): before any
  iree.runtime call the .vmfb's size and sha256 are verified against
  contract.artifact. A mismatch refuses; verify_artifact_hash=False records the
  verdict but does not refuse (explicit opt-out, never the default).

* The entry point and the call ABI come from the contract and are checked against
  the module's actual exports, rather than being hardcoded to `infer(x, *weights)`.

* Every output element is preserved for verification (`last_output`), and the Python
  reference to the result is dropped each call (`del out`). Returning only
  `score`/`argmax` would make a 640-output autoencoder unverifiable, and E31 measured
  that argmax alone accepts a wrong layout on 92% of samples.
  NOTE (v0.38.1 / D60): dropping the reference is NOT the same as observing the device
  buffer released, and this docstring used to say "released". That is withdrawn: the
  status is MEMORY RELEASE NOT VERIFIED on this path -- E33's own runs report unreleased
  nanobind instances at interpreter shutdown and no HAL peak was measured here. The
  opposite ("this leaks") may not be written either. See docs/EVIDENCE_v0.36_E33.md SS10.
"""

import json
import os
import sys
import time
from collections import deque

import numpy as np

from onair.src.ai_components.ai_plugin_abstract.ai_plugin import AIPlugin

from .artifact_binding import ArtifactBindingError, verify_artifact_binding

_HARNESS = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__)))), "harness")
if _HARNESS not in sys.path:
    sys.path.insert(0, _HARNESS)
import admission_policy as ap                                   # noqa: E402

LAT_RING = 4096          # fixed-size latency history; an OnAIR run has no natural end
DEPLOYMENT_ENV = "ONAIR_MLIR_DEPLOYMENT_CONFIG"


class ContractViolation(Exception):
    """Raised when the loaded artifact does not match its declared contract."""


class Plugin(AIPlugin):
    def __init__(self, name, headers):
        super().__init__(name, headers)
        self.deployment = self._load_deployment(name)
        d = self.deployment
        self.artifact_dir = d.get("artifact_dir") or os.path.join(
            os.path.dirname(__file__), "runtime")
        self.driver = d.get("driver", "local-sync")
        self.input_mode = d.get("input_mode", "telemetry")
        if self.input_mode not in ("telemetry", "file_replay"):
            raise ContractViolation("unknown input_mode %r (telemetry | file_replay)"
                                    % self.input_mode)
        self.verify_artifact_hash = bool(d.get("verify_artifact_hash", True))
        self.allow_conditional_map = bool(d.get("allow_conditional_map", False))
        self.budget_bytes = d.get("budget_bytes")

        # state that must exist even when the plugin refuses to activate, so that a
        # refusal is a reported state rather than an exception through OnAIR
        self.active = False
        self.inactive_reason = None
        self.admission = None
        self.binding = None
        self.last_output = None
        self.last_sample_id = None
        self.n_infer = 0
        self.n_input_errors = 0
        # OnAIR calls render_reasoning() once more after the data source is exhausted,
        # with no fresh update() before it (measured: E33 P-admit produced 6 results for
        # 5 frames, the 6th a byte-identical repeat of the 5th). Inferring again on a
        # stale input spends a call and, worse, emits a result that a verification
        # harness could count as a new sample. Track freshness and say so instead.
        self._input_fresh = False
        self.n_stale_calls = 0
        self._fn = None
        self._weights = []
        self._ctx = None
        self.lat = {k: deque(maxlen=LAT_RING) for k in ("L1_kernel", "L2a_update", "L2b_reason")}

        # Optional evidence channel: the official run has no return path for full
        # outputs, so when the deployment names one, every inference appends one JSON
        # line here. This is how stage 3's outputs reach the same comparator that
        # judged every other path (E31/E32), rather than being re-summarised.
        self.record_path = d.get("record_path")
        if self.record_path and not os.path.isabs(self.record_path):
            self.record_path = os.path.abspath(self.record_path)

        self.contract = None
        self.entry = None
        self.in_shape = ()
        self.in_elems = 0
        self.out_elems = 0
        self._x = None
        self.bound_us = None
        self.bound_boundary = None
        self.bound_violations = 0

        # EVERYTHING that can refuse lives inside this guard. A ContractViolation
        # raised while reading the contract is exactly as fatal to OnAIR as one raised
        # while admitting, and stage 3's criterion is that neither takes the process
        # down (plan SS4-3). The first version of this file loaded the contract above the
        # guard and killed the OnAIR run on a missing file -- measured, then fixed.
        try:
            self.contract = self._load_contract()
            self.entry = self.contract["interface"].get("entry", "infer")
            self.in_shape = tuple(int(v) for v in self.contract["interface"]["input"]["shape"])
            self.in_elems = int(np.prod(self.in_shape))
            self.out_elems = int(np.prod([int(v) for v in
                                          self.contract["interface"]["output"]["shape"]]))
            self._x = np.zeros(self.in_shape, dtype=np.float32)
            self.bound_us = self.contract.get("timing", {}).get("execution_bound_us")
            self.bound_boundary = self.contract.get("timing", {}).get("boundary")
            self._validate_inputs_against_headers()
            self._decide_admission()
            self._load_artifact()
            self.active = True
        except (ContractViolation, ap.AdmissionInputError, OSError, KeyError, ValueError) as e:
            # Never take the OnAIR process down with us: stay inactive and say why.
            self.inactive_reason = "%s: %s" % (type(e).__name__, e)
            print("[%s] INACTIVE -- %s" % (self.component_name, self.inactive_reason))
        self._record({"event": "init", "active": self.active,
                      "inactive_reason": self.inactive_reason,
                      "input_mode": self.input_mode,
                      "admission": self.admission, "binding": self.binding,
                      "entry": getattr(self, "entry", None),
                      "deployment_source": self.deployment.get("source")})

    def _record(self, obj):
        if not self.record_path:
            return
        try:
            os.makedirs(os.path.dirname(self.record_path), exist_ok=True)
            with open(self.record_path, "a", encoding="utf-8") as f:
                f.write(json.dumps(obj, default=str) + "\n")
        except OSError as e:
            # An unwritable evidence channel must not change what the run does.
            print("[%s] record failed: %s" % (self.component_name, e))

    # ---------- deployment configuration ----------

    def _load_deployment(self, name):
        """Settings come from ONAIR_MLIR_DEPLOYMENT_CONFIG because the official loader
        passes only (construct_name, headers). Absent the variable, fall back to the
        historical defaults so the original MLP fixture keeps working unchanged."""
        path = os.environ.get(DEPLOYMENT_ENV)
        if not path:
            return {"source": "defaults (no %s set)" % DEPLOYMENT_ENV}
        with open(path, encoding="utf-8") as f:
            doc = json.load(f)
        deployments = doc.get("deployments", doc)
        if name not in deployments:
            raise ContractViolation(
                "%s=%s has no entry for construct name %r (has: %s)"
                % (DEPLOYMENT_ENV, path, name, sorted(deployments)))
        d = dict(deployments[name])
        d["source"] = "%s[%s]" % (path, name)
        base = os.path.dirname(os.path.abspath(path))
        for key in ("artifact_dir", "fixture_dir"):
            if d.get(key) and not os.path.isabs(d[key]):
                d[key] = os.path.normpath(os.path.join(base, d[key]))
        return d

    # ---------- contract ----------

    def _load_contract(self):
        # the file name is configurable because a real artifact directory holds
        # `<model>.contract.json`, not a generic `contract.json`
        path = os.path.join(self.artifact_dir,
                            self.deployment.get("contract_file", "contract.json"))
        if not os.path.exists(path):
            raise ContractViolation("contract not found: %s" % path)
        with open(path, encoding="utf-8") as f:
            c = json.load(f)
        for key in ("interface", "target", "artifact", "resources"):
            if key not in c:
                raise ContractViolation("contract missing %r: %s" % (key, path))
        return c

    def _validate_inputs_against_headers(self):
        """What headers must satisfy depends on the input mode -- comparing an image
        tensor's element count with the OnAIR frame width is the wrong question."""
        if self.input_mode == "telemetry":
            if self.in_elems > len(self.headers):
                raise ContractViolation(
                    "telemetry mode: contract needs %d input elements but the OnAIR frame "
                    "provides %d fields" % (self.in_elems, len(self.headers)))
            return
        want = self.deployment.get("sample_index_header", "SAMPLE_INDEX")
        if want not in self.headers:
            raise ContractViolation(
                "file_replay mode: header %r (the numeric sample index) is not in the OnAIR "
                "frame (%s)" % (want, list(self.headers)[:8]))
        self._sample_index_pos = list(self.headers).index(want)
        self._sample_ids = list(self.deployment.get("sample_ids") or [])
        if not self._sample_ids:
            raise ContractViolation(
                "file_replay mode needs an ordered `sample_ids` list in the deployment config: "
                "NASA's CSV parser floatifies every field, so the frame can only carry an index")
        fx = self.deployment.get("fixture_dir")
        if not fx or not os.path.isdir(fx):
            raise ContractViolation("file_replay mode needs an existing fixture_dir (got %r)" % fx)

    def _decide_admission(self):
        """Decide BEFORE the artifact is opened, so a refusal never touches the runtime."""
        if self.budget_bytes is None:
            self.admission = {"verdict": "NOT_EVALUATED", "admitted_budget_bytes": None,
                              "reason": "no budget_bytes configured for this deployment"}
            return
        self.admission = ap.decide(self.contract, int(self.budget_bytes),
                                   allow_conditional_map=self.allow_conditional_map)
        if not ap.admitted(self.admission["verdict"]):
            raise ContractViolation("admission %s -- %s"
                                    % (self.admission["verdict"], self.admission["reason"]))

    def _load_artifact(self):
        import iree.runtime as rt                               # noqa: PLC0415
        vmfb = os.path.join(self.artifact_dir, self.contract["artifact"]["file"])
        try:
            self.binding = verify_artifact_binding(self.contract, vmfb)
            data = self.binding.pop("data")
        except ArtifactBindingError as e:
            if self.verify_artifact_hash:
                raise ContractViolation(str(e)) from e
            print("[%s] WARNING verify_artifact_hash=False: %s" % (self.component_name, e))
            self.binding = {"verdict": "UNVERIFIED", "reason": str(e)}
            with open(vmfb, "rb") as f:
                data = f.read()
        ctx = rt.SystemContext(config=rt.Config(self.driver))
        # hand IREE the SAME bytes that were hashed (no re-read window)
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, data))
        module = ctx.modules.module
        exports = set(getattr(module, "vm_module", module).function_names) \
            if hasattr(getattr(module, "vm_module", module), "function_names") else None
        if exports is not None and self.entry not in exports:
            raise ContractViolation(
                "contract entry %r is not exported by the module (exports: %s)"
                % (self.entry, sorted(exports)[:8]))
        try:
            self._fn = module[self.entry]
        except KeyError as e:
            raise ContractViolation("contract entry %r not callable on the module" % self.entry) from e
        self._ctx = ctx

        # ABI: baked-weight models take infer(x); the legacy MLP fixture takes
        # infer(x, *weights) with the weights in a sibling .npz. Which one applies is
        # read from the deployment, not guessed from whether a file happens to exist.
        abi = self.deployment.get("call_abi", "auto")
        wpath = os.path.join(self.artifact_dir, "weights.npz")
        if abi == "input_only":
            self._weights = []
        elif abi == "input_plus_external_weights":
            if not os.path.exists(wpath):
                raise ContractViolation("call_abi requires weights.npz, absent at %s" % wpath)
            w = np.load(wpath)
            self._weights = [w[k] for k in sorted(w.files)]
        elif abi == "auto":
            if os.path.exists(wpath):
                w = np.load(wpath)
                self._weights = [w[k] for k in sorted(w.files)]
            else:
                self._weights = []
        else:
            raise ContractViolation("unknown call_abi %r" % abi)

    # ---------- OnAIR interface ----------

    def update(self, low_level_data=[], high_level_data={}):
        if not self.active:
            return
        t0 = time.perf_counter_ns()
        if self.input_mode == "telemetry":
            flat = self._x.reshape(-1)
            for i, v in enumerate(low_level_data[: self.in_elems]):
                try:
                    flat[i] = float(v)
                except (TypeError, ValueError):
                    # An unconvertible field is an input error, not a zero. Substituting
                    # 0.0 would fold bad data into a normal-looking inference (SS6.1).
                    self.n_input_errors += 1
                    raise ContractViolation(
                        "telemetry field %d (%r) is not convertible to float"
                        % (i, v)) from None
        else:
            self._load_sample_by_index(low_level_data[self._sample_index_pos])
        self._input_fresh = True
        self.lat["L2a_update"].append(time.perf_counter_ns() - t0)

    def _load_sample_by_index(self, raw):
        """Resolve the frame's numeric index to a fixture sample. Out of range or
        non-integral refuses -- wrapping would replay the wrong image silently, and a
        non-numeric field has already been turned into 0.0 by NASA's parser."""
        try:
            f = float(raw)
        except (TypeError, ValueError):
            self.n_input_errors += 1
            raise ContractViolation("file_replay: sample index %r is not numeric" % (raw,)) from None
        idx = int(f)
        if idx != f:
            self.n_input_errors += 1
            raise ContractViolation("file_replay: sample index %r is not an integer" % (raw,))
        if not 0 <= idx < len(self._sample_ids):
            self.n_input_errors += 1
            raise ContractViolation(
                "file_replay: sample index %d is outside the configured range 0..%d"
                % (idx, len(self._sample_ids) - 1))
        self._load_sample(self._sample_ids[idx])

    def _load_sample(self, sample_id):
        """Read the fixture tensor for this sample id. A missing or wrongly shaped
        sample refuses -- it must never be scored as if it had been inferred."""
        fx = self.deployment["fixture_dir"]
        pattern = self.deployment.get("sample_file_pattern", "inputs/%s.nchw.npy")
        path = os.path.join(fx, pattern % sample_id)
        if not os.path.exists(path):
            self.n_input_errors += 1
            raise ContractViolation("file_replay: no fixture array for sample %r at %s"
                                    % (sample_id, path))
        arr = np.load(path).astype(np.float32, copy=False)
        if tuple(arr.shape) != self.in_shape:
            self.n_input_errors += 1
            raise ContractViolation("file_replay: sample %r has shape %s, contract declares %s"
                                    % (sample_id, tuple(arr.shape), self.in_shape))
        self._x = np.ascontiguousarray(arr)
        self.last_sample_id = sample_id

    def render_reasoning(self):
        if not self.active:
            return {"active": False, "reason": self.inactive_reason,
                    "inferences": self.n_infer}
        if not self._input_fresh:
            # No update() since the last inference: repeat the previous answer instead
            # of spending a call on an input we already scored, and mark it so a
            # verification harness cannot count it as a new sample.
            self.n_stale_calls += 1
            return {"active": True, "mode": self.input_mode, "stale": True,
                    "sample_id": self.last_sample_id,
                    "output_elements": len(self.last_output or []),
                    "score": (self.last_output or [None])[0],
                    "argmax": int(np.argmax(self.last_output)) if self.last_output else None}
        self._input_fresh = False
        t0 = time.perf_counter_ns()
        t1 = time.perf_counter_ns()
        out = self._fn(self._x, *self._weights)
        t2 = time.perf_counter_ns()
        # read every element back, then let the device buffer go: the contract's
        # per-call term counts ONE live input/output pair (E32/D59)
        y = np.array(out, copy=True).reshape(-1)
        del out
        t3 = time.perf_counter_ns()

        self.lat["L1_kernel"].append(t2 - t1)
        self.lat["L2b_reason"].append(t3 - t0)
        self.n_infer += 1
        self.last_output = [float(v) for v in y]
        self._record({"event": "inference", "n": self.n_infer,
                      "sample_id": self.last_sample_id, "mode": self.input_mode,
                      "output": self.last_output,
                      "admitted_budget_bytes": (self.admission or {}).get("admitted_budget_bytes")})

        if self.bound_us is not None and self.bound_boundary in self.lat:
            if self.lat[self.bound_boundary][-1] / 1e3 > self.bound_us:
                self.bound_violations += 1

        # The framework gets a summary; the FULL output stays available for
        # verification (a 640-output autoencoder has no meaningful argmax).
        return {"active": True, "mode": self.input_mode,
                "sample_id": self.last_sample_id,
                "output_elements": len(self.last_output),
                "score": self.last_output[0],
                "argmax": int(np.argmax(y)) if y.size else None}

    # ---------- reporting ----------

    def stats(self):
        def pct(ns):
            if not ns:
                return None
            s = sorted(ns)
            def g(q):
                return s[min(int(len(s) * q), len(s) - 1)] / 1e3
            return {"n": len(s), "median_us": g(0.5), "p95_us": g(0.95),
                    "p99_us": g(0.99), "max_us": s[-1] / 1e3}
        return {"plugin": self.component_name,
                "active": self.active,
                "inactive_reason": self.inactive_reason,
                "input_mode": self.input_mode,
                "driver": self.driver,
                "deployment_source": self.deployment.get("source"),
                "entry": getattr(self, "entry", None),
                "admission": self.admission,
                "binding": self.binding,
                "inferences": self.n_infer,
                "input_errors": self.n_input_errors,
                "stale_render_calls": self.n_stale_calls,
                "latency_ring": LAT_RING,
                "contract_bound_us": self.bound_us,
                "bound_boundary": self.bound_boundary,
                "bound_violations": self.bound_violations,
                "boundaries": {k: pct(list(v)) for k, v in self.lat.items()},
                "timing_note": "boundaries are recorded for provenance only; this repository "
                               "does not cite latency (platform_check FUNCTIONAL_ONLY)"}
