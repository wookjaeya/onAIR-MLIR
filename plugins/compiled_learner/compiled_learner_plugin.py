"""CompiledLearner: an OnAIR Learner whose inference runs in an MLIR/IREE
ahead-of-time compiled artifact instead of a Python ML framework.

Conforms to onair.src.ai_components.ai_plugin_abstract.ai_plugin.AIPlugin:
  __init__(name, headers), update(low_level_data, high_level_data), render_reasoning()

Design points that follow from the review of the research note:

* The plugin records three timing boundaries separately, because a compiled
  kernel still runs behind a Python wrapper:
      L1  kernel   - the IREE call alone
      L2a update   - input packing in update()
      L2b reason   - render_reasoning() including L1
  Any claim about "inference latency" must state which boundary it used.

* The plugin loads a contract next to the artifact and refuses to run if the
  declared interface does not match the data it is given. This is the
  deployment-time check the research note calls contract validation; it is
  cheap and it is the part that does not depend on WCET analysis.

* No execution-time bound is invented here. If the contract carries one, the
  plugin only compares observed latency against it and counts violations.

* Contract-artifact binding (external review F10, v0.18/E23): before any
  iree.runtime call the plugin verifies the .vmfb's size and sha256 against
  contract.artifact (plugins/compiled_learner/artifact_binding.py), the same
  gate native/native_learner.c and the cFS app apply. A mismatch raises
  ContractViolation; verify_artifact_hash=False records the verdict but does
  not refuse (explicit opt-out, never the default).
"""

import json
import os
import time

import numpy as np

from onair.src.ai_components.ai_plugin_abstract.ai_plugin import AIPlugin

from .artifact_binding import ArtifactBindingError, verify_artifact_binding


class ContractViolation(Exception):
    """Raised when the loaded artifact does not match its declared contract."""


class Plugin(AIPlugin):
    def __init__(self, name, headers, artifact_dir=None, driver="local-sync",
                 strict=True, verify_artifact_hash=True):
        super().__init__(name, headers)
        self.artifact_dir = artifact_dir or os.path.join(
            os.path.dirname(__file__), "runtime")
        self.driver = driver
        self.strict = strict
        self.verify_artifact_hash = verify_artifact_hash
        self.binding = None  # verdict dict from verify_artifact_binding, set in _load_artifact

        self.contract = self._load_contract()
        self._validate_interface_against_headers()
        self._fn, self._weights = self._load_artifact()

        self.n_in = int(self.contract["interface"]["input"]["shape"][-1])
        self._x = np.zeros((1, self.n_in), dtype=np.float32)
        self._last = None

        # per-boundary latency samples, nanoseconds
        self.lat = {"L1_kernel": [], "L2a_update": [], "L2b_reason": []}
        self.bound_us = self.contract["timing"].get("execution_bound_us")
        self.bound_boundary = self.contract["timing"].get("boundary")
        self.bound_violations = 0

    # ---------- contract ----------

    def _load_contract(self):
        path = os.path.join(self.artifact_dir, "contract.json")
        with open(path) as f:
            c = json.load(f)
        for key in ("interface", "target", "timing", "artifact"):
            if key not in c:
                raise ContractViolation(f"contract missing '{key}': {path}")
        return c

    def _validate_interface_against_headers(self):
        """Deployment-time check: declared input width vs the OnAIR frame width.

        headers is the sequenced list of names for each item in low_level_data,
        so len(headers) is the frame width this plugin will actually receive.
        """
        declared = int(self.contract["interface"]["input"]["shape"][-1])
        available = len(self.headers)
        if declared > available:
            raise ContractViolation(
                f"contract declares input width {declared} but the OnAIR frame "
                f"provides {available} fields")
        if declared != available and self.strict:
            # not fatal by itself, but it means the mapping is implicit
            print(f"[{self.component_name}] note: using first {declared} of "
                  f"{available} frame fields")

    def _load_artifact(self):
        import iree.runtime as rt
        vmfb = os.path.join(self.artifact_dir, self.contract["artifact"]["file"])
        try:
            self.binding = verify_artifact_binding(self.contract, vmfb)
            data = self.binding.pop("data")
        except ArtifactBindingError as e:
            if self.verify_artifact_hash:
                raise ContractViolation(str(e)) from e
            print(f"[{self.component_name}] WARNING verify_artifact_hash=False: {e}")
            self.binding = {"verdict": "UNVERIFIED", "reason": str(e)}
            with open(vmfb, "rb") as f:
                data = f.read()
        ctx = rt.SystemContext(config=rt.Config(self.driver))
        # hand IREE the SAME bytes that were hashed (no re-read window)
        ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, data))
        fn = ctx.modules.module["infer"]
        self._ctx = ctx  # keep alive
        wpath = os.path.join(self.artifact_dir, "weights.npz")
        w = np.load(wpath)
        weights = [w[k] for k in sorted(w.files)]
        return fn, weights

    # ---------- OnAIR interface ----------

    def update(self, low_level_data=[], high_level_data={}):
        t0 = time.perf_counter_ns()
        vals = low_level_data[: self.n_in]
        for i, v in enumerate(vals):
            try:
                self._x[0, i] = float(v)
            except (TypeError, ValueError):
                self._x[0, i] = 0.0
        self.lat["L2a_update"].append(time.perf_counter_ns() - t0)

    def render_reasoning(self):
        t0 = time.perf_counter_ns()
        t1 = time.perf_counter_ns()
        out = self._fn(self._x, *self._weights)
        t2 = time.perf_counter_ns()
        y = np.asarray(out)
        self._last = y
        t3 = time.perf_counter_ns()

        self.lat["L1_kernel"].append(t2 - t1)
        self.lat["L2b_reason"].append(t3 - t0)

        if self.bound_us is not None and self.bound_boundary in self.lat:
            if self.lat[self.bound_boundary][-1] / 1e3 > self.bound_us:
                self.bound_violations += 1

        return {"score": float(y.reshape(-1)[0]),
                "argmax": int(np.argmax(y))}

    # ---------- reporting ----------

    def stats(self):
        def pct(ns):
            if not ns:
                return None
            s = sorted(ns)
            g = lambda q: s[min(int(len(s) * q), len(s) - 1)] / 1e3
            return {"n": len(s), "median_us": g(0.5), "p95_us": g(0.95),
                    "p99_us": g(0.99), "max_us": s[-1] / 1e3}
        return {"plugin": self.component_name,
                "driver": self.driver,
                "contract_bound_us": self.bound_us,
                "bound_boundary": self.bound_boundary,
                "bound_violations": self.bound_violations,
                "boundaries": {k: pct(v) for k, v in self.lat.items()}}
