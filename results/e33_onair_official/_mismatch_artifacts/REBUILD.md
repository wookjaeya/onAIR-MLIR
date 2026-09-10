# P-mismatch cell artifacts

This directory deliberately pairs the **x86-64 contract** with the **AArch64 vmfb**: same
model, same three contract figures, different artifact — so only the sha256/size binding
can tell them apart. That is the condition the cell exists to exercise.

The vmfb is NOT stored here: it is a byte-for-byte copy of an artifact this repository
already carries, and duplicating 9 MB to make a negative fixture would be storage, not
evidence. Rebuild it with:

```sh
cp results/e32_smartcam_aarch64/build/smartcam.vmfb \
   results/e33_onair_official/_mismatch_artifacts/smartcam.vmfb
```

Expected mismatch (recorded in ../p_mismatch/run.json):

| | value |
|---|---|
| contract `artifact.sha256` | `aa95a6f5ab92cf0e…` (x86-64, 8,915,257 B) |
| file on disk after the copy | `ecffe6e0bcbadf51…` (AArch64, 8,991,281 B) |

The plugin refuses on the SIZE pre-check, before the file is read — the same order the
C gate uses, so the mismatch never reaches a hash computation or a runtime.
