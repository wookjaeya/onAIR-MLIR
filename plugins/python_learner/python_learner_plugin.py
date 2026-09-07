"""B0 baseline: the same MLP evaluated with a Python ML stack (NumPy).

Identical OnAIR interface and identical timing boundaries as CompiledLearner,
so the only difference between B0 and B1/P is the inference implementation.
"""

import json
import os
import time

import numpy as np

from onair.src.ai_components.ai_plugin_abstract.ai_plugin import AIPlugin


class Plugin(AIPlugin):
    def __init__(self, name, headers, artifact_dir=None):
        super().__init__(name, headers)
        self.artifact_dir = artifact_dir or os.path.join(
            os.path.dirname(__file__), "..", "compiled_learner", "runtime")
        with open(os.path.join(self.artifact_dir, "contract.json")) as f:
            self.contract = json.load(f)
        w = np.load(os.path.join(self.artifact_dir, "weights.npz"))
        self.w = [w[k] for k in sorted(w.files)]
        self.n_in = int(self.contract["interface"]["input"]["shape"][-1])
        self._x = np.zeros((1, self.n_in), dtype=np.float32)
        self.lat = {"L1_kernel": [], "L2a_update": [], "L2b_reason": []}

    def update(self, low_level_data=[], high_level_data={}):
        t0 = time.perf_counter_ns()
        for i, v in enumerate(low_level_data[: self.n_in]):
            try:
                self._x[0, i] = float(v)
            except (TypeError, ValueError):
                self._x[0, i] = 0.0
        self.lat["L2a_update"].append(time.perf_counter_ns() - t0)

    def render_reasoning(self):
        t0 = time.perf_counter_ns()
        t1 = time.perf_counter_ns()
        h = self._x @ self.w[0]
        y = h @ self.w[1]
        t2 = time.perf_counter_ns()
        y = np.asarray(y)
        t3 = time.perf_counter_ns()
        self.lat["L1_kernel"].append(t2 - t1)
        self.lat["L2b_reason"].append(t3 - t0)
        return {"score": float(y.reshape(-1)[0]), "argmax": int(np.argmax(y))}

    def stats(self):
        def pct(ns):
            if not ns:
                return None
            s = sorted(ns)
            g = lambda q: s[min(int(len(s) * q), len(s) - 1)] / 1e3
            return {"n": len(s), "median_us": g(0.5), "p95_us": g(0.95),
                    "p99_us": g(0.99), "max_us": s[-1] / 1e3}
        return {"plugin": self.component_name, "driver": "numpy",
                "boundaries": {k: pct(v) for k, v in self.lat.items()}}
