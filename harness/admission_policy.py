#!/usr/bin/env python3
"""Pure admission decision: contract + configured budget -> verdict. No side effects.

Why this is its own module (ninth review SS6.3): `harness/admission_check.py` carries the
early experiment's flow -- it compiles, it measures, it writes files. A deployment
plugin must not import that by name and inherit those side effects. This module
does nothing but decide, so the OnAIR plugin and the tests can share ONE decision
with the C gate's semantics instead of each re-deriving it.

The semantics mirror `native/cfs_app/fsw/src/ai_learner.c` and
`native/native_learner.c`, and the parts that matter are the ones this repository
had to learn the hard way:

  * UNKNOWN bound is a refusal, never a pass (D12/D13).
  * The conditional (map-arm) tier is opt-in, and it is only reachable when the
    budget does NOT already cover the unconditional bound -- otherwise the
    unconditional answer is the honest one and the conditional tier adds risk for
    nothing (E29).
  * The verdict carries the budget it was decided ON, so a later check can compare
    the peak with that number rather than with `bounded` (E32/D59). Reporting the
    verdict without the number it used is exactly the defect D59 recorded.
  * Nothing here allocates, loads, compiles or measures. A refusal must be
    reachable before the artifact is opened.
"""

ADMIT = "ADMIT"
ADMIT_CONDITIONAL_MAP = "ADMIT_CONDITIONAL_MAP"
NOT_ADMITTED = "NOT_ADMITTED"
REFUSED_UNKNOWN_BOUND = "REFUSED_UNKNOWN_BOUND"


class AdmissionInputError(ValueError):
    """The contract does not carry what a decision needs. Never a silent pass."""


def _int_field(res, key, required=True):
    v = res.get(key)
    if v is None:
        if required:
            raise AdmissionInputError("contract.resources.%s is absent" % key)
        return None
    if isinstance(v, bool) or not isinstance(v, int):
        raise AdmissionInputError("contract.resources.%s is %r, not an integer" % (key, v))
    if v < 0:
        raise AdmissionInputError("contract.resources.%s is negative (%d)" % (key, v))
    return v


def decide(contract, budget_bytes, allow_conditional_map=False):
    """Return a verdict dict. Raises AdmissionInputError rather than guessing.

    The returned dict always carries `admitted_budget_bytes`: the figure the
    verdict was reached on, which is what a post-hoc memory check must compare
    against (E32/D59). For a refusal it is None.
    """
    if isinstance(budget_bytes, bool) or not isinstance(budget_bytes, int):
        raise AdmissionInputError("budget_bytes is %r, not an integer" % (budget_bytes,))
    if budget_bytes < 0:
        raise AdmissionInputError("budget_bytes is negative (%d)" % budget_bytes)

    res = contract.get("resources")
    if not isinstance(res, dict):
        raise AdmissionInputError("contract has no resources object")

    method = res.get("bound_method")
    if not method or method in ("NONE", "none", "unspecified", "UNKNOWN_BOUND"):
        return {"verdict": REFUSED_UNKNOWN_BOUND, "admitted_budget_bytes": None,
                "reason": "bound_method is %r -- an unknown bound is refused, never passed" % method,
                "bounded_bytes": None, "per_call_bytes": None, "budget_bytes": budget_bytes,
                "conditional_available": False}

    bounded = _int_field(res, "bounded_bytes")
    per_call = _int_field(res, "static_per_call_bytes")
    constants = _int_field(res, "module_resident_constant_bytes")
    if bounded != per_call + constants:
        raise AdmissionInputError(
            "contract is self-inconsistent: bounded %d != per_call %d + constants %d"
            % (bounded, per_call, constants))

    common = {"bounded_bytes": bounded, "per_call_bytes": per_call,
              "constants_bytes": constants, "budget_bytes": budget_bytes,
              "bound_method": method, "scope": "per_app_local_budget"}

    if bounded <= budget_bytes:
        # the unconditional answer already fits: never enter the conditional tier,
        # which would trade a proven bound for one that depends on a precondition
        return dict(common, verdict=ADMIT, admitted_budget_bytes=budget_bytes,
                    conditional_available=False,
                    reason="bounded %d <= budget %d" % (bounded, budget_bytes))

    if allow_conditional_map and per_call <= budget_bytes:
        return dict(common, verdict=ADMIT_CONDITIONAL_MAP, admitted_budget_bytes=per_call,
                    conditional_available=True,
                    reason="bounded %d > budget %d, but the map arm's bound %d fits; the runtime "
                           "MUST verify the arm before inference and the peak MUST be compared "
                           "with %d, not with bounded (E29/E29b/E32-D59)"
                           % (bounded, budget_bytes, per_call, per_call))

    return dict(common, verdict=NOT_ADMITTED, admitted_budget_bytes=None,
                conditional_available=bool(per_call <= budget_bytes),
                reason="bounded %d > budget %d%s" % (
                    bounded, budget_bytes,
                    "" if not (per_call <= budget_bytes)
                    else " (the map arm's bound would fit, but the conditional tier is opt-in "
                         "and was not enabled)"))


def admitted(verdict):
    """True only for the two admitting verdicts. Anything unrecognised is False."""
    return verdict in (ADMIT, ADMIT_CONDITIONAL_MAP)
