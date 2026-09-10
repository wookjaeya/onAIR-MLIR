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
