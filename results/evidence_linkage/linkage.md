# 증거 연결표 — 세 실물 모델 (E37, 자동 생성)

이 파일은 `harness/mk_evidence_linkage.py`가 원자료에서 생성한다. **직접 편집하지 말 것.**
각 셀의 값은 인용한 파일의 인용한 키에서 읽은 것이며, 읽지 못한 셀은 그 사실을 남긴다.

| 셀 | 값 |
|---|---|
| 전체 | 24 (3모델 × 7항목) |
| present | 24 |
| present 아님 | 0 |

## OPS-SAT SmartCam (비행 모델) (`smartcam`)

### 검증 등급 (모델의 실제성 / 가중치 / 입력의 실제성 / 검증한 성질)

| 축 | 등급 | 근거 |
|---|---|---|
| model_reality | FLIGHT-ARTIFACT | `results/p1_smartcam_feasibility/source_manifest.json`:`status_in_this_repo`; `results/p1_smartcam_feasibility/source_manifest.json`:`original_artifact.modified` |
| weights_origin | TRAINED (원본 비행 모델에 베이킹됨) | `results/p1_smartcam_feasibility/source_manifest.json`:`source.path` |
| input_reality | MIXED — 실이미지 3 + 합성 32 + 상수 경계 2 | `results/e31_smartcam_equivalence/fixture/manifest.json`:`counts`; `results/e31_smartcam_equivalence/fixture/manifest.json`:`source.note` |
| verified_property | 의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산 | `results/e31_smartcam_equivalence/summary.json`:`verdict`; `results/e36_aarch64_cfs/summary.json`:`verdicts` |
| not_claimed | — | `results/e31_smartcam_equivalence/summary.json`:`not_claimed`; `results/e36_aarch64_cfs/summary.json`:`not_claimed` |

### 7항목 연결

#### 1. 원본 모델의 출처·파일 해시·입출력 규약 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| https://github.com/georgeslabreche/opssat-smartcam.git | `results/p1_smartcam_feasibility/source_manifest.json` | `source.repo` |
| be09ecee41f0a5db52afe0ee929dbd339cb68672 | `results/p1_smartcam_feasibility/source_manifest.json` | `source.commit` |
| home/exp1000/models/default/model.tflite | `results/p1_smartcam_feasibility/source_manifest.json` | `source.path` |
| results/p1_smartcam_feasibility/original/model.tflite | `results/p1_smartcam_feasibility/source_manifest.json` | `original_artifact.stored_as` |
| fd1ecbd01ad2d46bd35cbac17809cfa24b1d929b8f14871fc1fb6fca5ff06aae | `results/p1_smartcam_feasibility/source_manifest.json` | `original_artifact.sha256` |
| 8950028 | `results/p1_smartcam_feasibility/source_manifest.json` | `original_artifact.bytes` |
| false | `results/p1_smartcam_feasibility/source_manifest.json` | `original_artifact.modified` |
| {"input_shape": [1, 224, 224, 3], "input_dtype": "float32", "input_quantization": [0.0, 0], "output_shape": [1, 3], "output_dtype": "float32"} | `results/e31_smartcam_equivalence/summary.json` | `paths.oracle.signature` |

#### 2. 컴파일러 버전·타깃 옵션·VMFB·계약의 대응 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53", "profile": "cortex-a53", "driver": "local-sync", "backend": "llvm-cpu", "executable_format": "embedded-elf", "executab… | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `target` |
| smartcam.vmfb | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `artifact.file` |
| ecffe6e0bcbadf51c8482c73ab147e91fa857927d1183955e03a3257041c78f1 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `artifact.sha256` |
| 8991281 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `artifact.bytes` |
| true | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `provenance.single_invocation` |
| f1f659fafd57382583135ed4998706d50848cd35aed0510aece59b75ae6ce8a4 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `provenance.mlir_sha256` |
| 18222796 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `resources.bounded_bytes` |
| 9382092 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `resources.static_per_call_bytes` |
| 8840704 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` | `resources.module_resident_constant_bytes` |
| aa95a6f5ab92cf0ef62737c1227403d0a176c1c1ae24bf210b3e59b4cf60ead8 | `results/p1_smartcam_feasibility/build/smartcam.contract.json` | `artifact.sha256` |
| IREE (https://iree.dev):   IREE compiler version 3.11.0rc20260316 @ e4a3b0405d7d23554da26403658d0e8c3c5ecf25   LLVM version 23.0.0git   Optimized build | `results/p1_smartcam_feasibility/source_manifest.json` | `tools.iree_compile_version` |

#### 3. 입력 fixture와 전처리, 원본 실행기의 기준 출력 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"edge": 2, "real_example": 3, "synthetic": 32} | `results/e31_smartcam_equivalence/fixture/manifest.json` | `counts` |
| {"formula": "(pixel - mean) / std", "mean": 0.0, "std": 255.0, "note": "the ORIGINAL model's own config values; the model's internal MUL/SUB completes the range, so do not normali… | `results/e31_smartcam_equivalence/summary.json` | `fixture.preprocessing` |
| {"to": [224, 224], "resample": "BILINEAR", "note": "applied ONCE here so both paths receive identical tensors; this is NOT a claim that it matches the flight software's own resize… | `results/e31_smartcam_equivalence/summary.json` | `fixture.resize` |
| {"nhwc": "original TFLite input", "nchw": "imported IREE entry input", "operation": "numpy transpose(0,3,1,2)", "verified": "round trip nchw.transpose(0,2,3,1) == nhwc for every s… | `results/e31_smartcam_equivalence/summary.json` | `fixture.layout` |
| ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified | `results/e31_smartcam_equivalence/summary.json` | `paths.oracle.runner` |
| fd1ecbd01ad2d46bd35cbac17809cfa24b1d929b8f14871fc1fb6fca5ff06aae | `results/e31_smartcam_equivalence/summary.json` | `paths.oracle.model_sha256` |
| {"source": "docs/plans/E31_smartcam_semantic_equivalence.md SS4, committed before measurement", "inherited_from": "E25 SS3.2, unchanged (ninth review SS9.3)", "abs_tol": 0.0001, "… | `results/e31_smartcam_equivalence/summary.json` | `criteria` |

#### 4. AArch64 cFS의 승인 예산·실제 판정·추론 실행 여부 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| ADMIT | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.verdict` |
| 18222797 | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.budget_bytes` |
| macro | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.budget_source` |
| 35 | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.inferences` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.hal_peak` |
| 18222797 | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.admitted_budget_bytes` |
| true | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.peak_within_admitted_budget` |
| unconditional | `results/e36_aarch64_cfs/summary.json` | `cells.regression_no_override.admission_mode` |
| ADMIT | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.verdict` |
| 18222796 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.budget_bytes` |
| override | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.budget_source` |
| 34 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.inferences` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.hal_peak` |
| 18222796 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.admitted_budget_bytes` |
| true | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.peak_within_admitted_budget` |
| unconditional | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.admission_mode` |
| NOT_ADMITTED | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.verdict` |
| 18222795 | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.budget_bytes` |
| override | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.budget_source` |
| 0 | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.inferences` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.hal_peak` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.admitted_budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.peak_within_admitted_budget` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.deny_B_minus_1.admission_mode` |
| ADMIT_CONDITIONAL_MAP | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.verdict` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.budget_bytes` |
| override | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.budget_source` |
| 35 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.inferences` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.hal_peak` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.admitted_budget_bytes` |
| true | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.peak_within_admitted_budget` |
| conditional_map | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.admission_mode` |
| NOT_ADMITTED | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.verdict` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.budget_bytes` |
| override | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.budget_source` |
| 0 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.inferences` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.hal_peak` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.admitted_budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.peak_within_admitted_budget` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.cond_denied_without_optin.admission_mode` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.verdict` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.budget_source` |
| 0 | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.inferences` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.hal_peak` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.admitted_budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.peak_within_admitted_budget` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.malformed_abc.admission_mode` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.verdict` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.budget_source` |
| 0 | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.inferences` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.hal_peak` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.admitted_budget_bytes` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.peak_within_admitted_budget` |
| null | `results/e36_aarch64_cfs/summary.json` | `cells.zero_budget.admission_mode` |

#### 5. 전체 출력 비교 결과 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"samples": 37, "elements": 111, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "real_example": 3, "synthetic": 32}} | `results/e31_smartcam_equivalence/comparison.json` | `totals` |
| PASS | `results/e31_smartcam_equivalence/comparison.json` | `verdict` |
| {"samples": 37, "elements": 111, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "real_example": 3, "synthetic": 32}} | `results/e32_smartcam_aarch64/native/comparison.json` | `totals` |
| PASS | `results/e32_smartcam_aarch64/native/comparison.json` | `verdict` |
| {"samples": 5, "elements": 15, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "real_example": 3}} | `results/e32_smartcam_aarch64/cfs/comparison.json` | `totals` |
| PASS | `results/e32_smartcam_aarch64/cfs/comparison.json` | `verdict` |

#### 6. HAL peak와 해당 정책의 승인 예산 비교 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.hal_peak` |
| 18222796 | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.admitted_budget_bytes` |
| true | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.peak_within_admitted_budget` |
| unconditional | `results/e36_aarch64_cfs/summary.json` | `cells.admit_B.admission_mode` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.hal_peak` |
| 9382092 | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.admitted_budget_bytes` |
| true | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.peak_within_admitted_budget` |
| conditional_map | `results/e36_aarch64_cfs/summary.json` | `cells.cond_positive.admission_mode` |

#### 7. 각 결과를 생성한 명령·원시 로그·판정 스크립트 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 원본 반입 → 한 번의 iree-compile → 계약 | `results/p1_smartcam_feasibility/import/import_log.txt` | script=있음, raw=있음, git=추적, 최종코드재판정=해당없음 |
| 입력 fixture 생성 | `results/e31_smartcam_equivalence/fixture/manifest.json` | script=있음, raw=있음, git=추적, 최종코드재판정=해당없음 |
| 원본 TFLite oracle (기준 출력) | `results/e31_smartcam_equivalence/oracle_tflite.json` | script=있음, raw=있음, git=추적, 최종코드재판정=해당없음 |
| x86-64 pip iree.runtime 실행 + 판정 | `results/e31_smartcam_equivalence/comparison.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 native(qemu-user) 실행 + 판정 | `results/e32_smartcam_aarch64/native/comparison.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 cFS 게스트 셀 7개 (승인·거부·조건부·대조군·무효 예산) | `results/e36_aarch64_cfs/summary.json` | script=있음, raw=있음, git=추적, AI_LEARNER_BUDGET_OVERRIDE in ai_learner.c=예, AI_LEARNER_ALLOW_CONDITIONAL_MAP in ai_learner.c=예, ALLOW_CONDITIONAL_MAP in 51_build_cfs_aarch64.sh=예, 최종코드재판정=동일 |
| cFS 게스트 출력 비교 | `results/e32_smartcam_aarch64/cfs/comparison.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |

#### 8. 공개 실입력으로 같은 경로를 다시 밟은 기록 (AArch64 native·cFS, E48) — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"real_example": 19} | `results/e45_real_inputs/cells/smartcam/fixture/manifest.json` | `counts` |
| 19 | `results/e48_real_inputs_aarch64/smartcam/staged_inputs.json` | `samples` |
| ef3a3d9659dba573ad81cebce1e79a9ebcb2428193fc3d0235942fdcb957e4f9 | `results/e48_real_inputs_aarch64/smartcam/staged_inputs.json` | `sha256_inputs_bin` |
| 19 | `results/e48_real_inputs_aarch64/smartcam/staged_inputs.json` | `manifest_hashes_verified` |
| results/e45_real_inputs/cells/smartcam/fixture/manifest.json | `results/e48_real_inputs_aarch64/smartcam/staged_inputs.json` | `fixture_manifest_source` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.semantics_native_aarch64.verdict` |
| 0 | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.semantics_native_aarch64.elements_failed` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.semantics_cfs_aarch64.verdict` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.x86_64_pip_runtime_E45.verdict` |
| true | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.verdict_agrees_with_x86` |
| ADMIT | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.cfs_admit_B.verdict` |
| 282 | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.cfs_admit_B.inferences` |
| NOT_ADMITTED | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.cfs_deny_B_minus_1.verdict` |
| 0 | `results/e48_real_inputs_aarch64/summary.json` | `models.smartcam.cfs_deny_B_minus_1.inferences` |

## MLPerf Tiny ResNet (CIFAR-10 image classification) (`b2_resnet`)

### 검증 등급 (모델의 실제성 / 가중치 / 입력의 실제성 / 검증한 성질)

| 축 | 등급 | 근거 |
|---|---|---|
| model_reality | PUBLIC-PRETRAINED (MLPerf Tiny 참조 모델) | `results/e34_two_models/summary.json`:`originals_preserved.repo`; `results/e34_two_models/summary.json`:`originals_preserved.files[0].source_path` |
| weights_origin | TRAINED (MLCommons가 배포한 trained_models) | `results/e34_two_models/summary.json`:`originals_preserved.files[0].source_path` |
| input_reality | SYNTHETIC-ONLY — 합성 32 + 상수 경계 2, 실데이터 0 | `results/e34_two_models/b2_resnet/fixture/manifest.json`:`counts`; `results/e34_two_models/summary.json`:`cells.b2_resnet.semantic_grade` |
| verified_property | 의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산 | `results/e36b_aarch64_models/summary.json`:`models.b2_resnet.semantics_cfs_aarch64.verdict`; `results/e36b_aarch64_models/summary.json`:`verdicts` |
| not_claimed | — | `results/e34_two_models/summary.json`:`not_claimed`; `results/e36b_aarch64_models/summary.json`:`not_claimed` |

### 7항목 연결

#### 1. 원본 모델의 출처·파일 해시·입출력 규약 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| https://github.com/mlcommons/tiny | `results/e34_two_models/summary.json` | `originals_preserved.repo` |
| 4addd0fa08d216e20637637874e084895f289da4 | `results/e34_two_models/summary.json` | `originals_preserved.commit` |
| Apache-2.0 | `results/e34_two_models/summary.json` | `originals_preserved.license` |
| pretrainedResnet.tflite | `results/e34_two_models/summary.json` | `originals_preserved.files[0].file` |
| benchmark/training/image_classification/trained_models/pretrainedResnet.tflite | `results/e34_two_models/summary.json` | `originals_preserved.files[0].source_path` |
| b5c0046d6e0328b4956afd6baa29555a29b1f1c65bdd45aaed75b7cd484d9f79 | `results/e34_two_models/summary.json` | `originals_preserved.files[0].sha256` |
| 318144 | `results/e34_two_models/summary.json` | `originals_preserved.files[0].bytes` |
| ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified | `results/e34_two_models/summary.json` | `cells.b2_resnet.oracle_runner` |
| {"input": {"shape": [1, 3, 32, 32], "dtype": "f32"}, "output": {"shape": [1, 10], "dtype": "f32"}, "inputs": [{"shape": [1, 3, 32, 32], "dtype": "f32"}], "outputs": [{"shape": [1,… | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `interface` |

#### 2. 컴파일러 버전·타깃 옵션·VMFB·계약의 대응 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53", "profile": "cortex-a53", "driver": "local-sync", "backend": "llvm-cpu", "executable_format": "embedded-elf", "executab… | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `target` |
| b2_resnet.vmfb | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `artifact.file` |
| 2e0bc7dc67af80b795ff4847292e51326bf7349a34c434755c365faf4457fabb | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `artifact.sha256` |
| 343538 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `artifact.bytes` |
| true | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `provenance.single_invocation` |
| f74133512fc23eafd29b40c4c5e86eda174fde0a25baa2164d76dca0bb628ec2 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `provenance.mlir_sha256` |
| 618856 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `resources.bounded_bytes` |
| 309416 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `resources.static_per_call_bytes` |
| 309440 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | `resources.module_resident_constant_bytes` |
| 961f02c2c0ab0179f79ac5e2aa7c51f24ace40fa100a031121d8021e1e379fa0 | `results/e26_boundary_utility/x86_64/ext_b2_resnet/b2_resnet.contract.json` | `artifact.sha256` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.contract_identical_to_x86_64` |

#### 3. 입력 fixture와 전처리, 원본 실행기의 기준 출력 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"edge": 2, "synthetic": 32} | `results/e34_two_models/b2_resnet/fixture/manifest.json` | `counts` |
| [1, 32, 32, 3] | `results/e34_two_models/summary.json` | `cells.b2_resnet.input_shape` |
| numpy transpose(0,3,1,2) | `results/e34_two_models/summary.json` | `cells.b2_resnet.layout` |
| ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified | `results/e34_two_models/summary.json` | `cells.b2_resnet.oracle_runner` |
| {"source": "docs/plans/E31_smartcam_semantic_equivalence.md SS4, committed before measurement", "inherited_from": "E25 SS3.2, unchanged (ninth review SS9.3)", "abs_tol": 0.0001, "… | `results/e34_two_models/b2_resnet/comparison.json` | `criteria` |

#### 4. AArch64 cFS의 승인 예산·실제 판정·추론 실행 여부 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| ADMIT | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.verdict` |
| 618856 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.budget_bytes` |
| macro | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.budget_source` |
| 45 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.inferences` |
| 309416 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.hal_peak` |
| 618856 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.admitted_budget_bytes` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.peak_within_admitted_budget` |
| unconditional | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.admission_mode` |
| NOT_ADMITTED | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.verdict` |
| 618855 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.budget_bytes` |
| override | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.budget_source` |
| 0 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.inferences` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.hal_peak` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.admitted_budget_bytes` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.peak_within_admitted_budget` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.admission_mode` |

#### 5. 전체 출력 비교 결과 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"samples": 34, "elements": 340, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e34_two_models/b2_resnet/comparison.json` | `totals` |
| PASS | `results/e34_two_models/b2_resnet/comparison.json` | `verdict` |
| {"samples": 34, "elements": 340, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e36b_aarch64_models/b2_resnet/comparison_aarch64.json` | `totals` |
| PASS | `results/e36b_aarch64_models/b2_resnet/comparison_aarch64.json` | `verdict` |
| {"samples": 34, "elements": 340, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e36b_aarch64_models/b2_resnet/comparison_cfs_aarch64.json` | `totals` |
| PASS | `results/e36b_aarch64_models/b2_resnet/comparison_cfs_aarch64.json` | `verdict` |

#### 6. HAL peak와 해당 정책의 승인 예산 비교 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 309416 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.hal_peak` |
| 618856 | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.budget` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.peak_within_admitted_budget` |
| unconditional | `results/e36b_aarch64_models/summary.json` | `models.b2_resnet.cfs_admit.admission_mode` |

#### 7. 각 결과를 생성한 명령·원시 로그·판정 스크립트 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 원본 보존 + 한 번의 iree-compile(AArch64) → 계약 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` | script=있음, raw=있음, git=추적, 최종코드재판정=해당없음 |
| 입력 fixture + 원본 TFLite oracle | `results/e34_two_models/b2_resnet/fixture/manifest.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 native(qemu-user) 실행 + 판정 | `results/e36b_aarch64_models/b2_resnet/comparison_aarch64.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 cFS 승인·거부 셀 | `results/e36b_aarch64_models/cfs/resnet_admit_B.log` | script=있음, raw=있음, git=추적, AI_LEARNER_BUDGET_OVERRIDE in ai_learner.c=예, 최종코드재판정=동일 |

#### 8. 공개 실입력으로 같은 경로를 다시 밟은 기록 (AArch64 native·cFS, E48) — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"real_cifar10": 200} | `results/e45_real_inputs/cells/b2_resnet/fixture/manifest.json` | `counts` |
| 200 | `results/e48_real_inputs_aarch64/b2_resnet/staged_inputs.json` | `samples` |
| da3a6462af066c4c3a08776841ce102e94baef0006f21ed858267dcffb9db460 | `results/e48_real_inputs_aarch64/b2_resnet/staged_inputs.json` | `sha256_inputs_bin` |
| 200 | `results/e48_real_inputs_aarch64/b2_resnet/staged_inputs.json` | `manifest_hashes_verified` |
| results/e45_real_inputs/cells/b2_resnet/fixture/manifest.json | `results/e48_real_inputs_aarch64/b2_resnet/staged_inputs.json` | `fixture_manifest_source` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.semantics_native_aarch64.verdict` |
| 0 | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.semantics_native_aarch64.elements_failed` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.semantics_cfs_aarch64.verdict` |
| PASS | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.x86_64_pip_runtime_E45.verdict` |
| true | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.verdict_agrees_with_x86` |
| ADMIT | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.cfs_admit_B.verdict` |
| 204 | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.cfs_admit_B.inferences` |
| NOT_ADMITTED | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.verdict` |
| 0 | `results/e48_real_inputs_aarch64/summary.json` | `models.b2_resnet.cfs_deny_B_minus_1.inferences` |

## MLPerf Tiny Deep AutoEncoder (anomaly detection) (`b3_deepae`)

### 검증 등급 (모델의 실제성 / 가중치 / 입력의 실제성 / 검증한 성질)

| 축 | 등급 | 근거 |
|---|---|---|
| model_reality | PUBLIC-PRETRAINED (MLPerf Tiny 참조 모델) | `results/e34_two_models/summary.json`:`originals_preserved.repo`; `results/e34_two_models/summary.json`:`originals_preserved.files[1].source_path` |
| weights_origin | TRAINED (MLCommons가 배포한 trained_models) | `results/e34_two_models/summary.json`:`originals_preserved.files[1].source_path` |
| input_reality | SYNTHETIC-ONLY — 합성 32 + 상수 경계 2, 실데이터 0 | `results/e34_two_models/b3_deepae/fixture/manifest.json`:`counts`; `results/e34_two_models/summary.json`:`cells.b3_deepae.semantic_grade` |
| verified_property | 의미 동치(전체 출력) + 계약·admission + HAL peak ≤ 승인 예산 | `results/e36b_aarch64_models/summary.json`:`models.b3_deepae.semantics_cfs_aarch64.verdict`; `results/e36b_aarch64_models/summary.json`:`verdicts` |
| not_claimed | — | `results/e34_two_models/summary.json`:`not_claimed`; `results/e36b_aarch64_models/summary.json`:`not_claimed` |

### 7항목 연결

#### 1. 원본 모델의 출처·파일 해시·입출력 규약 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| https://github.com/mlcommons/tiny | `results/e34_two_models/summary.json` | `originals_preserved.repo` |
| 4addd0fa08d216e20637637874e084895f289da4 | `results/e34_two_models/summary.json` | `originals_preserved.commit` |
| Apache-2.0 | `results/e34_two_models/summary.json` | `originals_preserved.license` |
| ad01_fp32.tflite | `results/e34_two_models/summary.json` | `originals_preserved.files[1].file` |
| benchmark/training/anomaly_detection/trained_models/ad01_fp32.tflite | `results/e34_two_models/summary.json` | `originals_preserved.files[1].source_path` |
| c66636f4d7f8af8b10518e7be750a22c9d8d46ec97326b40b0d94c097e0aad9b | `results/e34_two_models/summary.json` | `originals_preserved.files[1].sha256` |
| 1067648 | `results/e34_two_models/summary.json` | `originals_preserved.files[1].bytes` |
| ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified | `results/e34_two_models/summary.json` | `cells.b3_deepae.oracle_runner` |
| {"input": {"shape": [1, 640], "dtype": "f32"}, "output": {"shape": [1, 640], "dtype": "f32"}, "inputs": [{"shape": [1, 640], "dtype": "f32"}], "outputs": [{"shape": [1, 640], "dty… | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `interface` |

#### 2. 컴파일러 버전·타깃 옵션·VMFB·계약의 대응 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"triple": "aarch64-unknown-linux-gnu", "cpu": "cortex-a53", "profile": "cortex-a53", "driver": "local-sync", "backend": "llvm-cpu", "executable_format": "embedded-elf", "executab… | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `target` |
| b3_deepae.vmfb | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `artifact.file` |
| 9ff64bd168e07135c196423d44408e7780984c977912b67c8240c0db522c4d7c | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `artifact.sha256` |
| 1080730 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `artifact.bytes` |
| true | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `provenance.single_invocation` |
| e40c75d867241532e578ab0a2dd4028cede1f4d0a593433284f55a574e3f3241 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `provenance.mlir_sha256` |
| 1069632 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `resources.bounded_bytes` |
| 6208 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `resources.static_per_call_bytes` |
| 1063424 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | `resources.module_resident_constant_bytes` |
| 8361791ddcf381b3e9a78012d1e5f0192f1cd6bd8595349b0a7a7ee743f75429 | `results/e26_boundary_utility/x86_64/ext_b3_deepae/b3_deepae.contract.json` | `artifact.sha256` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.contract_identical_to_x86_64` |

#### 3. 입력 fixture와 전처리, 원본 실행기의 기준 출력 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"edge": 2, "synthetic": 32} | `results/e34_two_models/b3_deepae/fixture/manifest.json` | `counts` |
| [1, 640] | `results/e34_two_models/summary.json` | `cells.b3_deepae.input_shape` |
| none | `results/e34_two_models/summary.json` | `cells.b3_deepae.layout` |
| ai_edge_litert Interpreter (LiteRT), original flatbuffer unmodified | `results/e34_two_models/summary.json` | `cells.b3_deepae.oracle_runner` |
| {"source": "docs/plans/E31_smartcam_semantic_equivalence.md SS4, committed before measurement", "inherited_from": "E25 SS3.2, unchanged (ninth review SS9.3)", "abs_tol": 0.0001, "… | `results/e34_two_models/b3_deepae/comparison.json` | `criteria` |

#### 4. AArch64 cFS의 승인 예산·실제 판정·추론 실행 여부 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| ADMIT | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.verdict` |
| 1069632 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.budget_bytes` |
| macro | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.budget_source` |
| 35 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.inferences` |
| 6208 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.hal_peak` |
| 1069632 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.admitted_budget_bytes` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.peak_within_admitted_budget` |
| unconditional | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.admission_mode` |
| NOT_ADMITTED | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.verdict` |
| 1069631 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.budget_bytes` |
| override | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.budget_source` |
| 0 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.inferences` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.hal_peak` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.admitted_budget_bytes` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.peak_within_admitted_budget` |
| null | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.admission_mode` |

#### 5. 전체 출력 비교 결과 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"samples": 34, "elements": 21760, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e34_two_models/b3_deepae/comparison.json` | `totals` |
| PASS | `results/e34_two_models/b3_deepae/comparison.json` | `verdict` |
| {"samples": 34, "elements": 21760, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e36b_aarch64_models/b3_deepae/comparison_aarch64.json` | `totals` |
| PASS | `results/e36b_aarch64_models/b3_deepae/comparison_aarch64.json` | `verdict` |
| {"samples": 34, "elements": 21760, "elements_failed": 0, "argmax_failed": 0, "by_kind": {"edge": 2, "synthetic": 32}} | `results/e36b_aarch64_models/b3_deepae/comparison_cfs_aarch64.json` | `totals` |
| PASS | `results/e36b_aarch64_models/b3_deepae/comparison_cfs_aarch64.json` | `verdict` |

#### 6. HAL peak와 해당 정책의 승인 예산 비교 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 6208 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.hal_peak` |
| 1069632 | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.budget` |
| true | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.peak_within_admitted_budget` |
| unconditional | `results/e36b_aarch64_models/summary.json` | `models.b3_deepae.cfs_admit.admission_mode` |

#### 7. 각 결과를 생성한 명령·원시 로그·판정 스크립트 — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| 원본 보존 + 한 번의 iree-compile(AArch64) → 계약 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` | script=있음, raw=있음, git=추적, 최종코드재판정=해당없음 |
| 입력 fixture + 원본 TFLite oracle | `results/e34_two_models/b3_deepae/fixture/manifest.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 native(qemu-user) 실행 + 판정 | `results/e36b_aarch64_models/b3_deepae/comparison_aarch64.json` | script=있음, raw=있음, git=추적, 최종코드재판정=동일 |
| AArch64 cFS 승인·거부 셀 | `results/e36b_aarch64_models/cfs/deepae_admit_B.log` | script=있음, raw=있음, git=추적, AI_LEARNER_BUDGET_OVERRIDE in ai_learner.c=예, 최종코드재판정=동일 |

#### 8. 공개 실입력으로 같은 경로를 다시 밟은 기록 (AArch64 native·cFS, E48) — **present**

| 값 | 원자료 | 키 |
|---|---|---|
| {"real_ad01": 34} | `results/e45_real_inputs/cells/b3_deepae/fixture/manifest.json` | `counts` |
| 34 | `results/e48_real_inputs_aarch64/b3_deepae/staged_inputs.json` | `samples` |
| d7f741654ec1d54f72b9bb5280a16a6140295a8bb737ec5d727e962a580df969 | `results/e48_real_inputs_aarch64/b3_deepae/staged_inputs.json` | `sha256_inputs_bin` |
| 34 | `results/e48_real_inputs_aarch64/b3_deepae/staged_inputs.json` | `manifest_hashes_verified` |
| results/e45_real_inputs/cells/b3_deepae/fixture/manifest.json | `results/e48_real_inputs_aarch64/b3_deepae/staged_inputs.json` | `fixture_manifest_source` |
| FAIL | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.semantics_native_aarch64.verdict` |
| 46 | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.semantics_native_aarch64.elements_failed` |
| FAIL | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.semantics_cfs_aarch64.verdict` |
| FAIL | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.x86_64_pip_runtime_E45.verdict` |
| true | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.verdict_agrees_with_x86` |
| ADMIT | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.cfs_admit_B.verdict` |
| 148 | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.cfs_admit_B.inferences` |
| NOT_ADMITTED | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.verdict` |
| 0 | `results/e48_real_inputs_aarch64/summary.json` | `models.b3_deepae.cfs_deny_B_minus_1.inferences` |

