"""LiteRTLearner: the PURE OnAIR baseline (path O0 of the roadmap's section 7).

What this is for
----------------
Roadmap section 7.1 states the purpose exactly, and it is not "find a fault in OnAIR":

    이 비교의 목적은 OnAIR의 결함을 찾는 것이 아니라 다음을 분리하는 것이다:
    기존 OnAIR 실행 경로에 본 연구가 추가하는 기능은 무엇인가?

So this plugin runs a public AI model through NASA's official OnAIR loader with NO
part of this research attached. It is the control, and what it LACKS is the point:

    CompiledLearner (O1..O3)                 LiteRTLearner (O0)
    ------------------------------------     -------------------------------------
    loads a static memory contract           no contract exists on this path
    artifact size + sha256 binding gate      none
    admission_policy.decide -> ADMIT/DENY    none; `admission` is null, not "PASS"
    check_declared_driver                    none
    creates an IREE runtime                  creates a LiteRT interpreter

**None of those absences is a defect of OnAIR.** OnAIR never claimed to do them.
They are precisely the functions the proposed path adds, which is why the comparison
is worth running at all. Anything written from this plugin's output that reads as
"OnAIR violated the contract" or "OnAIR cannot manage memory" is forbidden by the
roadmap section 7.1 and by docs/plans/E42_E43_pure_onair_baseline.md section 0.

What is deliberately SHARED with the sibling, so the comparison is fair
----------------------------------------------------------------------
  * the official loader interface -- `Plugin(construct_name, headers)`, two arguments
    and only two (onair plugin_import.py:49). Settings come from the same
    ONAIR_MLIR_DEPLOYMENT_CONFIG json, keyed the same way;
  * `file_replay` input mode with the SAME numeric-index convention, because NASA's
    CSV parser floatifies every field and a string sample id would silently replay
    sample zero (parser_util.floatify_input);
  * the SAME five samples E33's p_admit replayed, so O0 lines up with O2/O3 cell for
    cell rather than being a differently-shaped run;
  * the SAME JSONL record schema, so one summary generator reads all four paths;
  * the SAME input-freshness rule. OnAIR calls render_reasoning() once more after the
    data source is exhausted with no fresh update(); E33 measured 6 results for 5
    frames. A repeat marked `stale` is honest; inferring again is not.

What is deliberately NOT measured here (roadmap section 7.5, adopted verbatim)
-----------------------------------------------------------------------------
    LiteRT 프로세스 RSS와 MLIR/IREE 부분 계약값은 회계 범위가 다르므로
    직접 우열 비교에 사용하지 않는다.

This plugin therefore records NO memory figure at all. Recording one and then asking
readers not to compare it with a contract value would not survive contact with a
reader; not recording it is the only version of that rule that holds.

The tensor layout differs from the sibling and that is data, not a branch
------------------------------------------------------------------------
The original .tflite takes NHWC; the imported IREE artifact takes NCHW. Both live in
the same fixture as `<id>.nhwc.npy` and `<id>.nchw.npy`, and which one is read is the
deployment's `sample_file_pattern` -- a value, as E34 established for every other
per-model difference.
"""

import json
import os
import time
from collections import deque

import numpy as np

from onair.src.ai_components.ai_plugin_abstract.ai_plugin import AIPlugin

LAT_RING = 4096
DEPLOYMENT_ENV = "ONAIR_MLIR_DEPLOYMENT_CONFIG"


class BaselineConfigError(Exception):
    """Raised when this baseline cannot be configured as declared.

    NOTE the asymmetry with the sibling's ContractViolation, which is the whole point:
    that one can refuse because a CONTRACT was violated. This one has no contract, so
    the only things it can refuse for are a missing model file, a missing fixture, or a
    malformed deployment entry. A reader comparing refusal counts must read the reasons.
    """


class Plugin(AIPlugin):
    def __init__(self, name, headers):
        super().__init__(name, headers)
        self.deployment = self._load_deployment(name)
        d = self.deployment

        self.model_path = d.get("model_file")
        self.input_mode = d.get("input_mode", "file_replay")

        # state that must exist even when the plugin refuses to activate, so a refusal
        # is a reported state rather than an exception through the OnAIR process
        self.active = False
        self.inactive_reason = None
        # These three stay null on this path BY CONSTRUCTION. They are in the record so
        # the four paths share one schema; a null here means "this path has no such
        # step", never "the step passed".
        self.admission = None
        self.binding = None
        self.contract = None
        self.last_output = None
        self.last_sample_id = None
        self.n_infer = 0
        self.n_input_errors = 0
        self._input_fresh = False
        self.n_stale_calls = 0
        self._interp = None
        self._in_index = None
        self._out_index = None
        self.in_shape = ()
        self.out_elems = 0
        self._x = None
        self.lat = {k: deque(maxlen=LAT_RING) for k in ("L1_kernel", "L2a_update", "L2b_reason")}

        self.record_path = d.get("record_path")
        if self.record_path and not os.path.isabs(self.record_path):
            self.record_path = os.path.abspath(self.record_path)

        try:
            self._open_model()
            self._validate_inputs_against_headers()
            self.active = True
        except (BaselineConfigError, OSError, KeyError, ValueError) as e:
            self.inactive_reason = "%s: %s" % (type(e).__name__, e)
            print("[%s] INACTIVE -- %s" % (self.component_name, self.inactive_reason))

        self._record({"event": "init", "active": self.active,
                      "inactive_reason": self.inactive_reason,
                      "input_mode": self.input_mode,
                      "admission": self.admission, "binding": self.binding,
                      "entry": None,
                      "path": "O0_pure_onair_litert",
                      "has_contract": False,
                      "has_admission_gate": False,
                      "has_artifact_binding_gate": False,
                      "absences_are_by_construction":
                          "this baseline has no contract, no admission and no artifact "
                          "binding. Those nulls mean 'no such step on this path', NOT "
                          "'the step passed', and they are NOT defects of OnAIR -- they "
                          "are what the proposed path adds (roadmap 7.1).",
                      "model_file": self.model_path,
                      "deployment_source": self.deployment.get("source")})

    def _record(self, obj):
        if not self.record_path:
            return
        try:
            os.makedirs(os.path.dirname(self.record_path), exist_ok=True)
            with open(self.record_path, "a", encoding="utf-8") as f:
                f.write(json.dumps(obj, default=str) + "\n")
        except OSError as e:
            print("[%s] record failed: %s" % (self.component_name, e))

    def _load_deployment(self, name):
        path = os.environ.get(DEPLOYMENT_ENV)
        if not path:
            raise BaselineConfigError(
                "%s is not set; this baseline has no historical defaults to fall back on"
                % DEPLOYMENT_ENV)
        with open(path, encoding="utf-8") as f:
            doc = json.load(f)
        deployments = doc.get("deployments", doc)
        if name not in deployments:
            raise BaselineConfigError(
                "%s=%s has no entry for construct name %r (has: %s)"
                % (DEPLOYMENT_ENV, path, name, sorted(deployments)))
        d = dict(deployments[name])
        d["source"] = "%s[%s]" % (path, name)
        base = os.path.dirname(os.path.abspath(path))
        for key in ("model_file", "fixture_dir"):
            if d.get(key) and not os.path.isabs(d[key]):
                d[key] = os.path.normpath(os.path.join(base, d[key]))
        return d

    def _open_model(self):
        """Open the ORIGINAL .tflite with LiteRT. No hash check, no size check -- this
        path has no contract to check them against, and inventing one here would make
        the baseline a weaker copy of the proposed path instead of a control."""
        if not self.model_path:
            raise BaselineConfigError("deployment declares no `model_file`")
        if not os.path.exists(self.model_path):
            raise BaselineConfigError("model not found: %s" % self.model_path)
        try:
            from ai_edge_litert.interpreter import Interpreter    # noqa: PLC0415
        except ImportError as e:                                  # a decision, not a crash
            raise BaselineConfigError("ai_edge_litert not installed: %s" % e) from None
        self._interp = Interpreter(model_path=self.model_path)
        self._interp.allocate_tensors()
        di = self._interp.get_input_details()
        do = self._interp.get_output_details()
        if len(di) != 1 or len(do) != 1:
            raise BaselineConfigError(
                "this baseline handles single-input single-output models; got %d in / %d out"
                % (len(di), len(do)))
        self._in_index, self._out_index = di[0]["index"], do[0]["index"]
        self.in_shape = tuple(int(v) for v in di[0]["shape"])
        self.out_elems = int(np.prod([int(v) for v in do[0]["shape"]]))
        self._x = np.zeros(self.in_shape, dtype=np.float32)

    def _validate_inputs_against_headers(self):
        if self.input_mode != "file_replay":
            raise BaselineConfigError(
                "this baseline runs in file_replay mode only (got %r): an image tensor must "
                "not be spread over %d OnAIR header fields"
                % (self.input_mode, int(np.prod(self.in_shape))))
        want = self.deployment.get("sample_index_header", "SAMPLE_INDEX")
        if want not in self.headers:
            raise BaselineConfigError(
                "file_replay: header %r (the numeric sample index) is not in the OnAIR frame (%s)"
                % (want, list(self.headers)[:8]))
        self._sample_index_pos = list(self.headers).index(want)
        self._sample_ids = list(self.deployment.get("sample_ids") or [])
        if not self._sample_ids:
            raise BaselineConfigError(
                "file_replay needs an ordered `sample_ids` list: NASA's CSV parser floatifies "
                "every field, so the frame can only carry an index")
        fx = self.deployment.get("fixture_dir")
        if not fx or not os.path.isdir(fx):
            raise BaselineConfigError("file_replay needs an existing fixture_dir (got %r)" % fx)

    def update(self, low_level_data=[], high_level_data={}):
        if not self.active:
            return
        t0 = time.perf_counter_ns()
        self._load_sample_by_index(low_level_data[self._sample_index_pos])
        self._input_fresh = True
        self.lat["L2a_update"].append(time.perf_counter_ns() - t0)

    def _load_sample_by_index(self, raw):
        try:
            f = float(raw)
        except (TypeError, ValueError):
            self.n_input_errors += 1
            raise BaselineConfigError("file_replay: sample index %r is not numeric" % (raw,)) from None
        idx = int(f)
        if idx != f:
            self.n_input_errors += 1
            raise BaselineConfigError("file_replay: sample index %r is not an integer" % (raw,))
        if not 0 <= idx < len(self._sample_ids):
            self.n_input_errors += 1
            raise BaselineConfigError(
                "file_replay: sample index %d is outside the configured range 0..%d"
                % (idx, len(self._sample_ids) - 1))
        self._load_sample(self._sample_ids[idx])

    def _load_sample(self, sample_id):
        fx = self.deployment["fixture_dir"]
        # NHWC here vs NCHW for the sibling -- a VALUE in the deployment, not a branch
        pattern = self.deployment.get("sample_file_pattern", "inputs/%s.nhwc.npy")
        path = os.path.join(fx, pattern % sample_id)
        if not os.path.exists(path):
            self.n_input_errors += 1
            raise BaselineConfigError("file_replay: no fixture array for sample %r at %s"
                                      % (sample_id, path))
        arr = np.load(path).astype(np.float32, copy=False)
        if tuple(arr.shape) != self.in_shape:
            self.n_input_errors += 1
            raise BaselineConfigError(
                "file_replay: sample %r has shape %s, the model's input is %s"
                % (sample_id, tuple(arr.shape), self.in_shape))
        self._x = np.ascontiguousarray(arr)
        self.last_sample_id = sample_id

    def render_reasoning(self):
        if not self.active:
            return {"active": False, "reason": self.inactive_reason, "inferences": self.n_infer}
        if not self._input_fresh:
            self.n_stale_calls += 1
            return {"active": True, "mode": self.input_mode, "stale": True,
                    "sample_id": self.last_sample_id,
                    "output_elements": len(self.last_output or []),
                    "score": (self.last_output or [None])[0],
                    "argmax": int(np.argmax(self.last_output)) if self.last_output else None}
        self._input_fresh = False
        t0 = time.perf_counter_ns()
        self._interp.set_tensor(self._in_index, self._x)
        t1 = time.perf_counter_ns()
        self._interp.invoke()
        t2 = time.perf_counter_ns()
        y = np.array(self._interp.get_tensor(self._out_index), copy=True).reshape(-1)
        t3 = time.perf_counter_ns()

        self.lat["L1_kernel"].append(t2 - t1)
        self.lat["L2b_reason"].append(t3 - t0)
        self.n_infer += 1
        self.last_output = [float(v) for v in y]
        self._record({"event": "inference", "n": self.n_infer,
                      "sample_id": self.last_sample_id,
                      "output": self.last_output,
                      "output_elements": len(self.last_output),
                      "argmax": int(np.argmax(y)),
                      "sum": float(y.sum())})
        return {"active": True, "mode": self.input_mode, "stale": False,
                "sample_id": self.last_sample_id,
                "output_elements": len(self.last_output),
                "score": self.last_output[0],
                "argmax": int(np.argmax(y)),
                "inferences": self.n_infer,
                "admission": None,
                "admission_note": "this path has no admission step; null is not a pass"}
