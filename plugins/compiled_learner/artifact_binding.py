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
