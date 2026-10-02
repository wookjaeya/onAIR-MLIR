"""Contract <-> artifact binding check for the OnAIR CompiledLearner plugin.

External review F10 (docs/reviews/REVIEW_v0_15_LATEST.md, v0.18/E23) found that
the OnAIR plugin loaded the .vmfb named by contract["artifact"]["file"] straight
into iree.runtime with no sha256 or size check, while the native C
(native/native_learner.c) and cFS (native/cfs_app) paths refuse a mismatching
artifact BEFORE any IREE call (size precheck, D15/E16, then sha256). The OnAIR
path was therefore fail-open on exactly the A3/A5a binding scenarios the C
paths are verified against.

This module is deliberately dependency-free (stdlib only) so the gate can be
unit-tested (harness/contract_negative_tests.py) in an environment without
OnAIR or iree.runtime installed; the plugin imports it.

Order mirrors native_learner.c: size first (cheap, refuses without reading a
mismatching blob into memory), then sha256 of the exact bytes that will be
handed to IREE. Fails closed: a contract lacking artifact.bytes or
artifact.sha256 is refused rather than skipping the missing check.
"""
import hashlib
import os


class ArtifactBindingError(Exception):
    """The artifact on disk is not the one the contract describes."""


def verify_artifact_binding(contract, vmfb_path):
    """Return {"verdict": "MATCH", ...} or raise ArtifactBindingError.

    Checks, in order: artifact.bytes present and equal to the file size;
    artifact.sha256 present and equal to sha256 of the file's exact bytes.
    The returned dict also carries the data bytes so the caller hands IREE the
    SAME bytes that were hashed (no re-read window)."""
    art = contract.get("artifact") or {}
    declared_bytes = art.get("bytes")
    declared_sha = art.get("sha256")
    if declared_bytes is None:
        raise ArtifactBindingError("contract.artifact.bytes missing: cannot verify artifact size (fail-closed)")
    if not declared_sha:
        raise ArtifactBindingError("contract.artifact.sha256 missing: cannot verify artifact identity (fail-closed)")
    actual_bytes = os.path.getsize(vmfb_path)
    if actual_bytes != int(declared_bytes):
        raise ArtifactBindingError(
            "CONTRACT_ARTIFACT_MISMATCH: size %d != contract artifact.bytes %d (refused before reading %s)"
            % (actual_bytes, int(declared_bytes), vmfb_path))
    with open(vmfb_path, "rb") as f:
        data = f.read()
    actual_sha = hashlib.sha256(data).hexdigest()
    if actual_sha != declared_sha:
        raise ArtifactBindingError(
            "CONTRACT_ARTIFACT_MISMATCH: sha256 %s... != contract artifact.sha256 %s... (%s)"
            % (actual_sha[:16], str(declared_sha)[:16], vmfb_path))
    return {"verdict": "MATCH", "artifact_bytes": actual_bytes, "artifact_sha256": actual_sha, "data": data}


class DeclaredDriverError(Exception):
    """The deployment would run the artifact on a driver the contract did not declare."""


def check_declared_driver(contract, deployment_driver):
    """E41: refuse a deployment driver the contract does not declare.

    The bound is stated under one execution environment -- `local-sync` is in
    `resources.bound_assumptions`, and E40 publishes it machine-readably as
    `analysis_domain.derived.driver`. The two C runners cannot disagree with it (the
    contract header IS the device selector), but the OnAIR plugin takes its driver from
    the deployment config, so until E41 the two could differ with nothing to notice.

    Reads from `analysis_domain.derived`, `validity` or `target`: the legacy OnAIR
    fixture has `validity: null` but a `target.driver`, and requiring only the first
    would reject an honest contract (the D31 shape). If NONE declares a driver that is
    a refusal too -- absence is not agreement (D29).

    This is a DECLARATION check, like the target-triple and ABI checks. E41b measured the
    same VMFB under `local-sync` and `local-task` and got a byte-identical HAL peak at one
    in-flight call in 6/6 cells (results/e41b_driver_peak/summary.json); that is not a claim
    that other drivers are safe or unsafe, and it does not establish the loading arm across
    drivers -- only that this check is about what the contract says, not about measured harm.

    Returns the declared driver on success; raises DeclaredDriverError otherwise.
    """
    declared = [d for d in (
        ((contract.get("analysis_domain") or {}).get("derived") or {}).get("driver"),
        (contract.get("validity") or {}).get("driver"),
        (contract.get("target") or {}).get("driver"),
    ) if d]
    if not declared:
        raise DeclaredDriverError(
            "the contract declares no driver (analysis_domain/validity/target); "
            "refusing to run it on %r" % (deployment_driver,))
    if len(set(declared)) != 1:
        raise DeclaredDriverError("the contract declares conflicting drivers %r" % sorted(set(declared)))
    if declared[0] != deployment_driver:
        raise DeclaredDriverError(
            "deployment driver %r != contract driver %r (the bound is stated for the "
            "declared driver only)" % (deployment_driver, declared[0]))
    return declared[0]


class ConfigurationError(Exception):
    """E65/M2: the deployment asks for something this path cannot honour."""


CONDITIONAL_MAP_KEY = "allow_conditional_map"


def check_conditional_map_option(deployment):
    """E65/M2: the conditional policy is not available on the OnAIR plugin path.

    Admitting on the map-arm figure (B_m = static_per_call_bytes) is sound only once the
    map-arm premise has been MEASURED before the runtime is created (module image 64-byte
    aligned) and confirmed after append (no constant allocation). The two C executors do
    both (E29b/D54); this plugin does neither -- the Python binding places its own copy of
    the image and does not expose the address -- so passing the option through to the
    admission policy would admit on B_m without the check (the D53 shape). Until E65 that
    was prevented only procedurally: every deployment wrote `false`.

    Accepted: the key absent, or the boolean `false`. Everything else is a configuration
    error -- including `true`, and including non-boolean values such as the string
    "false", which the previous `bool(...)` read as True.

    Returns False on success; raises ConfigurationError otherwise.
    """
    if CONDITIONAL_MAP_KEY not in deployment:
        return False
    value = deployment[CONDITIONAL_MAP_KEY]
    if value is False:
        return False
    if value is True:
        raise ConfigurationError(
            "%s=true: the conditional policy is not available on this path, which does not "
            "verify the map-arm premise before creating the runtime" % CONDITIONAL_MAP_KEY)
    raise ConfigurationError("%s=%r is not a boolean" % (CONDITIONAL_MAP_KEY, value))


BUDGET_KEY = "budget_bytes"


def check_budget_option(deployment):
    """E66/D112: the budget the deployment declares, validated as the flight application validates it.

    The cFS application refuses a budget that does not resolve to a positive integer as
    BUDGET_INVALID (ai_learner.c, `v <= 0`). This path used to pass `int(budget_bytes)` to the
    admission policy, which bypassed the policy's own type check: `true` became 1, the string
    "618856" and the float 618856.9 became 618856 (ADMIT), and 0 was compared as a budget
    (NOT_ADMITTED) instead of being refused as invalid.

    Returns None when the key is absent or null (the plugin's documented NOT_EVALUATED mode is
    unchanged), the value when it is an int (not bool) greater than zero, and raises
    ConfigurationError otherwise.
    """
    value = deployment.get(BUDGET_KEY)
    if value is None:
        return None
    if isinstance(value, bool) or not isinstance(value, int):
        raise ConfigurationError("%s=%r is not an integer" % (BUDGET_KEY, value))
    if value <= 0:
        raise ConfigurationError("%s=%d does not resolve to a positive integer (the flight "
                                 "application refuses the same value as BUDGET_INVALID)" % (BUDGET_KEY, value))
    return value


class DocumentNotAccepted(ConfigurationError):
    """E66/D111: the specification document is one the header generator refuses by default."""


UNCHECKED_PRODUCER_KEY = "allow_unchecked_producer"

# harness/gen_contract_header.py BOUND_METHOD_WHITELIST -- kept literally equal; the parity test
# in harness/contract_negative_tests.py (e66) compares the two sets.
BOUND_METHODS = frozenset({"static_from_stream_schedule", "static_from_stream_layout", "NONE"})


def _is_int(v):
    return isinstance(v, int) and not isinstance(v, bool)


def check_unchecked_producer_option(deployment):
    """E66: the plugin's counterpart of gen_contract_header.py --allow-unchecked-producer.

    Accepted: the key absent, `false` or `true` (booleans only, as E65 decided for the
    conditional option). Anything else is a configuration error. Returns the boolean."""
    if UNCHECKED_PRODUCER_KEY not in deployment:
        return False
    value = deployment[UNCHECKED_PRODUCER_KEY]
    if value is True or value is False:
        return value
    raise ConfigurationError("%s=%r is not a boolean" % (UNCHECKED_PRODUCER_KEY, value))


def check_document_acceptance(contract, allow_unchecked_producer=False):
    """E66/D111: refuse, before the runtime exists, every document the header generator refuses by default.

    The cFS path turns the document into a C header at build time, and gen_contract_header.py
    refuses by default: an unrecognized bound_method; a document that states a bound, carries a
    provenance block, and records an override, a grade other than "verified", or a
    single_invocation that is not true (E24b/D39); a document whose producer_check is not
    "match" (E65/M1); and a document that states a bound, carries a provenance block, and has no
    producer_check at all (E65/M1 -- absence is not a match). This plugin reads the JSON directly
    and used to apply only the budget comparison, so it admitted the last two kinds of document
    and the override-issued one (reproduced: ADMIT at B_u for each).

    The scope is the generator's, deliberately: the provenance rules apply only to documents that
    carry a provenance block (every document the analyzer issues does), because refusing the
    hand-written fixtures without one was the E24b over-refusal (D31). A document without a
    bound_method is left to the admission policy, which refuses it as an unknown bound whenever
    a budget is configured.

    Returns {"verdict": "accepted", "waived": [...]} or raises DocumentNotAccepted.
    """
    res = contract.get("resources") or {}
    val = contract.get("validity") or {}
    prov = contract.get("provenance")
    method = res.get("bound_method")
    if method is not None and method not in BOUND_METHODS:
        raise DocumentNotAccepted("unrecognized resources.bound_method %r" % (method,))
    bounded = res.get("bounded_bytes")
    bound_known = (method is not None and method != "NONE" and _is_int(bounded) and bounded >= 0
                   and not (res.get("unresolved_sizes") or []))
    if bound_known and isinstance(prov, dict):
        bad = []
        ov = prov.get("overrides_applied")
        if isinstance(ov, list) and ov:
            bad.append("provenance.overrides_applied=%s" % (ov,))
        grade = prov.get("verification_grade")
        if grade is not None and grade != "verified":
            bad.append("provenance.verification_grade=%r" % (grade,))
        if prov.get("single_invocation") is not True:
            bad.append("provenance.single_invocation=%r" % (prov.get("single_invocation"),))
        if bad:
            raise DocumentNotAccepted("the document's own provenance says it was not fully verified: %s"
                                      % "; ".join(bad))
    waived = []
    pc = val.get("producer_check")
    if isinstance(pc, dict):
        if pc.get("state") != "match":
            raise DocumentNotAccepted(
                "validity.producer_check.state=%r (artifact bytecode %r, checked %r): the analysis "
                "was not examined for the revision that produced this artifact"
                % (pc.get("state"), pc.get("artifact_bytecode_version"), pc.get("checked_bytecode_version")))
    elif isinstance(prov, dict) and bound_known:
        if not allow_unchecked_producer:
            raise DocumentNotAccepted(
                "the document states a bound but carries no validity.producer_check, so the artifact's "
                "bytecode version was never compared with the examined revision (a missing comparison "
                "is not read as a match)")
        waived.append(UNCHECKED_PRODUCER_KEY)
    return {"verdict": "accepted", "waived": waived}
