# EVIDENCE v0.33 — E30: OPS-SAT SmartCam 반입 타당성 (P1)

**실험 ID**: E30 · **날짜**: 2026-09-10 · **플랫폼 grade**: 결정론적(해시·계약 수치·HAL 통계·IR 구조) —
지연값은 인용하지 않는다 · **상태**: 완료(P1 범위 안에서) · **판정**: **TRANSFORM_REQUIRED → GO**
(감사된 변환 아래에서) · **원자료**: `results/p1_smartcam_feasibility/`

이 문서는 여덟 번째 외부 분석 문서(`docs/reviews/ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md`, 이하 "분석서")가
§9에서 지정한 범위 — *"P1 SmartCam import feasibility만 수행한다"* — 를 그대로 따른 결과다. 분석서가
하지 말라고 한 것(§8: AArch64 게스트 재구축, cFS 실행기 일반화, 전체 데이터셋 정확도, 원본 수동 편집,
소수 샘플로 정확도 주장)은 하지 않았다.

---

## 0. 한 줄 결론

OPS-SAT SmartCam 비행 모델(`model.tflite`, 8,950,028 B)은 **원본을 한 바이트도 고치지 않고**, 알려진
차단점(SQUEEZE)을 **감사된 변환기 확장**으로 넘겨 **한 번의 `iree-compile` 호출**에서 vmfb·layout IR·
계약·헤더까지 도달한다. 계약은 **오버라이드 0개**로 생성되고(`bounded` 18,222,796 = `per_call` 9,382,092 +
`constants` 8,840,704, 디스패치 56), 구조적 추출기·아티팩트 전용 기준선(E27 (b′))이 같은 값을 내며,
pip `iree.runtime`에서 실제로 실행된다(피크 = `per_call` 정확히). **수치 동치(분석서 §5 조건 7)는 하지
않았다 — P2다.** 반입이 만든 **인터페이스 변경 하나(NHWC → NCHW 입력)** 를 P2의 의무로 기록했다.

---

## 1. 원본 고정 (분석서 §5.1) — `source_manifest.json`

| 항목 | 값 |
|---|---|
| 저장소 | `https://github.com/georgeslabreche/opssat-smartcam.git` |
| 커밋 | `be09ecee41f0a5db52afe0ee929dbd339cb68672` (2024-01-20T16:09:03-05:00, clone 시점 HEAD) |
| 경로 | `home/exp1000/models/default/model.tflite` (+ `labels.txt`: bad / earth / edge) |
| 크기 · sha256 | **8,950,028 B** · `fd1ecbd01ad2d46bd35cbac17809cfa24b1d929b8f14871fc1fb6fca5ff06aae` |
| 보존 | `results/p1_smartcam_feasibility/original/model.tflite` — 바이트 동일 복사본, **수정 없음** |
| 도구 | Python 3.11.15 · tflite(schema) 2.18.0 · tflite2onnx 0.4.1 · onnx 1.22.0 · IREE 3.11.0rc20260316 @ `e4a3b04` |

같은 sha256을 `operator_inventory.json`·두 변환 매니페스트·`feasibility_summary.json`이 각각 독립적으로
기록하며, 회귀 시험이 저장된 파일의 실제 해시와 매번 대조한다.

## 2. 모델 구조 기록 (분석서 §5.2) — `operator_inventory.json` (`harness/p1_tflite_inventory.py`)

| 항목 | 값 |
|---|---|
| 입력 | `input_1` **[1,224,224,3] FLOAT32** (shape_signature [-1,224,224,3] — 배치만 기호적, 실행 형상은 정적) |
| 출력 | `Identity` **[1,3] FLOAT32** |
| 연산자 | **68개 / 9종 / custom 0**: CONV_2D 35 · DEPTHWISE_CONV_2D 17 · ADD 10 · MUL 1 · SUB 1 · AVERAGE_POOL_2D 1 · **SQUEEZE 1** · FULLY_CONNECTED 1 · SOFTMAX 1 |
| 텐서 | 177개, **동적 형상 0** |
| 민감 op | SQUEEZE (op 65): `[1,1,1,1280] → [1,1280]`, `squeeze_dims=[1,2]` — 축 크기 1 ✓ · 원소 수 보존 ✓ · dtype 보존 ✓ · 출력 정적 ✓ · 기록된 출력 형상 = 기대 형상 ✓ |
| cFS 인터페이스 적합 | 단일 f32 입력 / 단일 f32 출력 / 정적 ✓ — **입력 150,528 원소(602,112 B)**, 출력 3 원소 |

이 도구는 `tflite` 스키마 패키지만 쓴다(TensorFlow·`ai_edge_litert` 불필요). 모델이 무엇인지 기록할 뿐
**변환하지 않는다.**

## 3. 반입 시도 (분석서 §5.3) — `import/import_log.txt` (단계별 명령·rc·오류 원문)

### 3.1 원본 그대로 (step 1) — **차단 재현**

```
venv-p1/bin/tflite2onnx original/model.tflite step1/model.onnx
rc=1  NotImplementedError: Unsupported TFLite OP: 43 SQUEEZE!   (tflite2onnx/op/common.py:154 OpFactory.create)
```

`docs/plans/E26_boundary_utility.md` §1.2가 손으로 기록해 둔 차단점이 그대로 재현된다. 실패는 그래프
**파싱 단계**에서 나므로 부분 ONNX도 남지 않는다. 회귀 시험은 이 실패를 기억하지 않고 **매번 다시
일으킨다**(`stock tflite2onnx still refuses … (blocker reproduced live)`).

### 3.2 변환기 확장 (step 2) — `harness/tflite2onnx_ext_squeeze.py` + `harness/p1_tflite_to_onnx.py`

분석서 §5의 권고("원본 TFLite를 직접 고치지 말고 변환 단계에서 처리, 조건이 전부 성립할 때만")대로
tflite2onnx의 `OpFactory`에 `Squeeze` 변환기를 **등록**한다. 원본은 읽기만 한다.

- **조건(분석서 §5 항목 1–4)을 순수 함수로 검사**(`check_squeeze_conditions`) — C1 제거 축 전부 크기 1,
  C2 원소 수 보존, C3 dtype 보존, C4 출력 정적이며 기대 형상과 일치. 하나라도 어긋나면
  `SqueezeConditionError`로 **변환 자체를 거부**한다(조용히 빼거나 재해석하지 않음). TFLite 의미
  (`squeeze_dims` 비어 있으면 크기 1인 축 전부, 음수 축은 정규화)를 먼저 적용한 뒤 검사한다.
- **레이아웃**: tflite2onnx는 Conv/Pool 주변 활성화를 NHWC→NCHW로 바꾸고 형상을 재색인한다. 이
  SQUEEZE의 입력은 AveragePool 출력이라 그 태그를 달고 있어 ONNX에서는 `[1,1280,1,1]`이 된다. 확장은
  `Layout.perm`으로 축을 **[1,2] → [2,3]** 으로 재색인하고 그 뒤 C1을 **한 번 더** 검사한다. 출력은
  rank-2라 레이아웃 전파를 멈춘다(`propagatableTensors() == []`, tflite2onnx 자신의 Reshape와 같음).
- **두 방출 모드**: `squeeze`(ONNX `Squeeze`, opset 11이라 `axes`는 속성 — 의미상 쌍둥이)와
  `reshape`(분석서의 문자 그대로의 제안: 정적 shape initializer를 가진 ONNX `Reshape`).
- **감사 흔적**: `*.transform_manifest.json`에 도구 버전, 원본/ONNX의 sha256·바이트, ONNX I/O 서명, 노드
  히스토그램, SQUEEZE 인스턴스별 C1–C4 판정, `original_modified: false`, `graph.name`을 `infer`로 바꾼 사실
  (엔트리 심볼; 텐서·노드 무변경)을 남긴다.

| 모드 | ONNX | 노드 105 | SQUEEZE 감사 |
|---|---|---|---|
| squeeze | 9,301,420 B · `79c57abc32c1bfa7…` | Conv 52 · Clip 35 · Add 10 · Reshape 2 · Mul 1 · Sub 1 · AveragePool 1 · **Squeeze 1** · Gemm 1 · Softmax 1 | C1–C4 전부 true, `onnx_axes=[2,3]` |
| reshape | 9,301,505 B · `3af9c7a14e1b588a…` | 같되 Squeeze 0 · **Reshape 3** | 동일 |

### 3.3 부수 발견 — tflite2onnx의 출력은 **실행마다 바이트가 다르다**

첫 세 번의 step 2 실행이 **세 개의 sha256**을 냈다. 노드·initializer·value_info는 다중집합으로는 전부
동일했고 순서만 달랐다 — `tflite2onnx/graph.py:25-26`이 `initializer`와 `value_info`를 Tensor 객체의
**`set()`** 에 담아 두기 때문에 직렬화 순서가 객체 identity를 따른다(`PYTHONHASHSEED=0`으로도 재현 안 됨).
하류에서는 linalg MLIR의 **상수 번호**가 달라졌다(계약 수치는 동일). 이 저장소가 요구하는 것은 "원본에서
같은 바이트가 다시 나온다"이므로 래퍼가 두 목록을 **이름순으로 정렬**한 뒤 저장하게 했다 — 노드 목록은
리스트라 손대지 않고, 두 목록은 그래프 의미를 담지 않는다. 그 뒤 두 번의 실행이 같은 바이트를 냈고,
회귀 시험이 원본에서 ONNX(sha256)와 linalg MLIR(sha256)까지 **매번 다시 만들어 대조**한다.

### 3.4 ONNX → MLIR (step 3–4)

```
iree-import-onnx step2_*.onnx --opset-version 17 -o step3_*.torch.mlir     rc=0, torch.operator 218
iree-opt step3_*.torch.mlir --pass-pipeline='builtin.module(torch-onnx-to-torch-backend-pipeline,
        torch-backend-to-linalg-on-tensors-backend-pipeline)' -o step4_*.linalg.mlir   rc=0, 잔여 torch op 0
```

`--opset-version 17`은 장식이 아니다(적대적 검증): 없이도 importer는 opset 11을 받아들이지만 그러면
`iree-opt`가 `onnx.Softmax`(opset<13 형식, `axis=-1`)를 legalize하지 못해 rc=1로 실패한다 — 즉 이 플래그가
체인을 성립시키며, 저장된 명령과 회귀 시험 모두 그것을 넘긴다.

엔트리: `func.func @infer(%arg0: tensor<1x3x224x224xf32>) -> tensor<1x3xf32>`. **두 방출 모드의 linalg
MLIR이 바이트 동일**하다(17,750,942 B, `f1f659fafd573825…`) — ONNX `Squeeze(axes)`와 `Reshape(정적 shape)`가
같은 `tensor.collapse_shape`로 내려오고, 정렬 이후에는 상수 번호마저 같다. 따라서 **P1 판정은 방출 모드에
의존하지 않는다**(`variant_reshape/equivalence.json`).

### 3.5 한 번의 `iree-compile` (step 5) — 작업 규율 7

```
iree-compile smartcam.mlir -o smartcam.vmfb --iree-hal-target-device=local --iree-hal-local-target-device-backends=llvm-cpu
  --iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu --iree-llvmcpu-target-cpu=generic
  --mlir-print-ir-after=iree-stream-layout-slices --iree-hal-dump-executable-files-to=dump --mlir-elide-elementsattrs-if-larger=16
  2> smartcam.layout_ir.txt
```

vmfb **8,915,257 B** `aa95a6f5ab92cf0e…`, layout IR 210,468 B, dump 129개(저장은 123개 — LLVM 중간물
6개는 크고 `.gitignore` 함정에 걸리며 어떤 도구도 읽지 않으므로 해시만 `build/dropped_dump_files.sha256`에
남기고 뺐다. 보관 계약은 축소본에서 재생성한 것이며 축소 전 계약과 provenance 목록 외 전 필드 동일).
reshape 모드의 별도 호출도 **바이트 동일한 vmfb**를 냈다 — 이 두 호출에 대한 관측일 뿐이다(E26e는 스레딩
빌드에서 반대를 봤다). 측정에 쓴 vmfb는 보존한다.

## 4. 계약·헤더 (step 6) — 오버라이드 0

| 항목 | 값 |
|---|---|
| `bounded_bytes` | **18,222,796** = `static_per_call_bytes` **9,382,092** + `module_resident_constant_bytes` **8,840,704** |
| `static_per_call_bytes` | = `static_io_bytes` 602,124 (입력 602,112 + 출력 12) + `static_transient_bytes` 8,779,968 |
| 디스패치 | 56 · embedded ELF 55,136 B (`.text` 18,508 B) |
| 커널 스택 | 최대 프레임 **368 B**, 해석된 최심 호출 사슬 **439 B** — 호출 명령 38개가 같은 ELF 안 leaf 타깃 2개로 해석(E26a/D47 경로, 미해석 0) → 헤더 `CONTRACT_KERNEL_STACK_BYTES 439L` |
| 상수 확인 | `constants_confirmation_state: confirmed`(`iree-dump-module` rodata 대조) · 구조적 추출기 일치 |
| provenance | `overrides_applied: []`, `verification_grade: verified`, one-invocation 두 신호 통과 |
| 헤더 | `CONTRACT_BOUND_KNOWN 1` · `CONTRACT_PROVENANCE_VERIFIED 1` · `CONTRACT_DTYPES_ALL_F32 1` · `CONTRACT_INPUT_ELEMS 150528` · `CONTRACT_OUTPUT_ELEMS 3` · 보관 계약에서 **바이트 동일 재생성** |

**아티팩트 전용 기준선(E27 (b′), `harness/e27_baseline_vmfb_only_hardened.py`)** — MLIR도 덤프도 없이
vmfb만 읽는 두 번째 정보원 — 이 `status: value`로 **정확히 같은 세 값**(18,222,796 / 9,382,092 / 8,840,704)
을 낸다. E27의 "정상 조건 (b) = (c)"가 실물 비행 모델 하나에서 더 성립했다(9/9번째 셀; 판정 변경 아님).

**세 번째 정보원 — 비행 flatbuffer 자신의 상수(적대적 검증이 대조)**: `tflite` 스키마로 읽은 원본의 상수 버퍼는
**108개 f32 텐서, 2,210,661 파라미터, 8,842,644 B**(Keras MobileNetV2 α=1.0 no-top 2,257,984 − BN 4×17,056 +
folded bias 17,056 + Dense 1280→3 3,843 + 전처리 스칼라 2 = 정확히 일치). 계약의 `constants` 8,840,704와의 차이
**1,940 B**는 256 B 이하 텐서 15개(bias 벡터 13 + FC bias [3] + 스칼라 2.0/1.0)로, `iree-compile`이 디스패치
실행 파일 안으로 inline한 것이다 — 그 바이트가 embedded ELF `.rodata`에 **그대로** 있다(계약의
`memory_boundary`가 정의상 제외하는 실행 이미지 쪽, `kernel_elf_bytes` 55,136 B에 포함). 즉 원본 → 계약의
상수 대조가 **바이트 단위로 닫힌다**(불일치가 아니라 조정). 부수: hal.executable 40개 / ELF 고유 함수 39개
(`infer_dispatch_35`가 링커 ICF로 `infer_dispatch_23`의 코드에 접힘; 스택 분석은 주소 기준이라 영향 없음) /
디스패치 사이트 56.

**두 분기 구조**: layout IR에 `stream.resource.try_map` 1 · `scf.if` 1 · 상수 블록 `stream.resource.alloc`
1 — E26이 합성·MLPerf Tiny 모델에서 본 구조가 이 비행 모델에도 그대로다. `B_map = per_call` 9,382,092,
`B_copy = bounded` 18,222,796, 비 **1.94×**. (E29의 조건부 계층이 그대로 적용 가능하다는 뜻이지 적용했다는
뜻이 아니다.)

## 5. 스모크 실행 (step 8) — `harness/p1_smoke_pip_runtime.py`, 타당성 기록이지 판정이 아님

pip `iree.runtime`(local-sync)에서 `infer([1,3,224,224] f32) → [1,3] f32`가 완주한다. 고정 입력 두 개
(영벡터, seed 0 균등난수)에 대해 유한·결정적(같은 입력 두 번 = 같은 바이트) 출력이 나오고, 결과를 버리는
호출 10회 뒤의 HAL 통계는 **`device_bytes_peak` 9,382,092 = `per_call` 정확히**, `allocated == freed`
(93,820,920 = 10 × 9,382,092) — 이 프로세스는 map 분기를 탔다 — 스크립트가 정렬을 제어하지는
않지만, **pip 바인딩 자체가 그 전제조건을 강제한다**(`VmModule.copy_buffer`가 64바이트 정렬 사본을 만들고
`wrap_buffer`는 미정렬 이미지를 `ValueError`로 거부한다, 적대적 검증이 4개 정렬 클래스로 확인). 따라서
**이 배포에서 `B_copy`(18,222,796)는 원리적으로 관측되지 않는다** — 그 값은 C 런타임 + E29 shim에서만 나온다. 출력값 자체([0.933, 0.035, 0.032] / [0.934, 0.040, 0.027], 둘 다 argmax 0 = "bad")는 **아무것도
말하지 않는다** — 영벡터와 난수는 영상이 아니고, 정확도·동치는 P2·이후의 질문이다.

**관측자 효과(D50의 새 얼굴)**: 이 바인딩에서 결과를 호스트로 읽으면(`np.asarray` / `to_host()` /
`_map_to_host()`) 그 12 B HAL 버퍼가 `del` + `gc.collect()` 뒤에도 프로세스 끝까지 "allocated"로 남는다
(5회 읽기 = 60 B 보유, 이후 호출의 피크 +48). **적대적 검증의 정정**: 결과를 *읽지 않고 붙들기만* 해도
피크는 같은 양만큼 오르지만 그쪽은 `del` + `gc`로 **해제된다** — 프로세스 수명 동안 고정되는 것은 호스트
읽기뿐이다. 두 기전 모두 같은 처방(결과를 버리는 호출로 피크를 먼저 읽기)으로 닫힌다. 그래서 스크립트는 **결과를 버리는 호출로 피크를 먼저 읽고**
그 다음에야 출력을 읽으며, 읽은 뒤의 통계를 `hal_statistics_after_host_reads`로 **따로 남긴다**(숨기지
않는다). E26e가 반환 버퍼 5개를 리스트에 담아 두었다가 `refutes_hypothesis`를 낼 뻔한 것과 같은 계열이다.

## 6. 반입이 만든 인터페이스 변경 둘 — P2의 의무 (숨기지 않는다)

| | 비행 TFLite | IREE 엔트리 |
|---|---|---|
| 입력 | `[1,224,224,3]` **NHWC** | `[1,3,224,224]` **NCHW** |
| 원소 수 / dtype | 150,528 / f32 | 150,528 / f32 |
| 원소 **순서** | — | **보존되지 않음** |

tflite2onnx는 Transpose 노드를 넣는 대신 Conv 가중치 52개를 OHWI→OIHW로 재배열하고 입력을 NCHW로 선언한다
(적대적 검증이 52/52 필터 일치와, 같은 150,528개 float를 reshape로 넣을 때와 전치해 넣을 때 softmax가 달라짐을
vmfb에서 직접 확인). 이 저장소의 두 C 실행기(`native_learner.c`·`ai_learner.c`)는 계약 헤더의 형상으로
rank-4 `{1,3,224,224}` dense row-major 버퍼 뷰를 만들고 그 payload를 **평면 인덱스 순서로** 채울 뿐 —
계약에는 형상만 있고 NHWC/NCHW 의미는 없다. 따라서 **P2는 TFLite 입력을 NHWC→NCHW로 전치한 사본을 IREE
엔트리에 먹여야** 같은 입력을 비교하는 것이 된다. 대안(그래프 입력에 ONNX Transpose를 넣어 엔트리가 비행
형상을 유지하게 하는 것)은 새 단일 호출 빌드와 계약 변경을 뜻하므로 P2의 설계 선택으로 남긴다.

**둘째 좁힘(적대적 검증이 지적)**: 비행 flatbuffer의 `shape_signature`는 배치를 기호적으로 남겨 두었다
(`[-1,224,224,3]`, 177개 텐서 중 69개가 -1을 가짐). 실행 형상은 배치 1이고 IREE 엔트리는 배치 1로 고정된다 —
레이아웃 외의 두 번째 인터페이스 좁힘이며 P2는 배치 1에서 비교한다. "NHWC"라는 라벨 자체는 flatbuffer의
메타데이터가 아니라 TFLite CONV_2D 연산자 규약에서 온 것임도 `feasibility_summary.json`에 적었다.

## 7. 판정과 산출물 (분석서 §5.4)

| 산출물 | 위치 |
|---|---|
| `source_manifest.json` | `results/p1_smartcam_feasibility/` |
| `operator_inventory.json` | 〃 (`harness/p1_tflite_inventory.py`) |
| `import_log.txt` | `import/` — step 1–8 명령·rc·오류 원문·해시 |
| 변환 스크립트 | `harness/tflite2onnx_ext_squeeze.py` + `harness/p1_tflite_to_onnx.py` |
| 변환 전후 manifest | `import/step2_smartcam_ext_{squeeze,reshape}.transform_manifest.json` |
| `feasibility_summary.json` | **TRANSFORM_REQUIRED**, `go_with_transform: true`, 조건 7 "NOT DONE — P2", 비주장 목록 |
| 부수 | `build/`(mlir.gz·vmfb·layout IR·ELF 분석·계약·헤더·아티팩트 전용 기준선·스모크·축소 dump), `variant_reshape/equivalence.json` |

**판정**: 분석서의 세 등급 중 **TRANSFORM_REQUIRED** — 원본 그대로는 반입되지 않고(step 1), 감사된 변환
아래에서 MLIR·VMFB·계약이 생성된다(step 2–6). 변환은 §5 조건 1–6을 코드·매니페스트·해시로 충족하며,
조건 7(수치 동치)은 분석서가 P2로 지정했다.

**회귀 시험**: `harness/contract_negative_tests.py::p1_smartcam_feasibility_cases` 31건 — 원본 해시 대조,
인벤토리 C1–C4, 차단점 **실시간 재현**, 두 매니페스트, 인터페이스 변경 기록, 계약 수치·항등식·오버라이드 0·
기준선 일치·방출 모드 수렴·두 분기 구조·헤더 재생성, 스모크 기록, 순수 함수 위반 7건 거부, 원본에서
ONNX(두 모드) → linalg MLIR **sha256 재생성**, 축소 fixture에서 계약 재생성 diff 0. 이 컨테이너
**322/322 → 353/353**. 변환기 패키지(`tflite`·`tflite2onnx`·`onnx`, `requirements.txt`에 고정)나 IREE 도구가
없는 환경에서는 해당 시험이 명시적으로 SKIP한다(D24/D25). **CI 실측**(커밋 `5267025`, run 110, 3레그 success): `full` **352/352 + 1 SKIP**(PyYAML) · `without-iree` **237/237 + 20 SKIP** · `stdlib-only` **237/237 + 20 SKIP** — 컨테이너 353/353과 `full`의 차이 1건은 PyYAML 유무(D34), SKIP 16→20은 p1-smartcam의 변환기 의존 시험 3건 + 계약 재생성 1건이 해당 패키지·IREE 도구 없이는 정직하게 SKIP하기 때문이다.

## 8. 적대적 검증 (이 세션, 9개 반박 에이전트 + finding당 2인 검증) + E30b (D56)

E30의 주장을 9개 묶음(provenance · SQUEEZE 변환 · 결정론 · 인터페이스 변경 · 계약 수치 · 두 분기 구조 · fixture
무결성 · 범위·주장 · 확장의 과잉 거부)으로 나눠 각각 독립 반박 에이전트에 맡기고, note가 아닌 finding은 2인이
따로 재현·판정했다(E20 이후의 이 저장소 관례). 이 절은 완료된 묶음부터 적고 나머지는 후속 커밋에서 덧붙인다.

### 8.1 반박 실패(주장 유지) — 일곱 묶음

| 묶음 | 결과 | 독립 확인 / 노트 |
|---|---|---|
| provenance | 유지 | 재클론 후 `cmp` 바이트 동일, `git hash-object` 일치, 매니페스트 5곳의 sha·크기·커밋 일치, gitignore 0건. 노트: `cloned_at_utc`가 실제로는 매니페스트 기록 시각 → 필드명 정정 |
| 결정론 | 유지 | `PYTHONHASHSEED` 0/1/random 세 실행 sha 동일; 정렬을 뺀 사본으로 옛 비결정성 재현; 정렬은 두 목록의 순열임을 확인; ONNX→torch→linalg 해시 전부 재현. 노트: `--opset-version 17` 없이도 importer는 수용하지만 그러면 `iree-opt`가 `onnx.Softmax`(opset<13 형식)에서 실패 — 플래그가 load-bearing임을 §3.4에 명시. 정렬은 고유 이름에 의존(ONNX checker가 보장) |
| SQUEEZE 변환 | 유지(비행 모델) | perm 방향(`new_shape[i] = old_shape[perm[i]]`)·Pooling의 레이아웃 태그·shape inference·`tensor.collapse_shape [[0],[1,2,3]]`·Conv 필터 52/52가 OHWI→OIHW 순열로 바이트 일치. **그러나 비행 모델 밖에서 잠재 fail-open을 찾았다 → §8.2 (D56)** |
| 인터페이스 변경 | 유지 | 같은 150,528 float를 reshape로/전치해 넣으면 softmax가 달라짐을 vmfb에서 직접 확인; 'P2는 전치해야'가 필요조건임을 ONNX prefix 평가로 확인. low: **배치 고정**(shape_signature −1 → 1)이 두 번째 좁힘 — §6에 반영. 노트: 'NHWC' 라벨의 출처는 CONV_2D 규약(flatbuffer에 레이아웃 메타데이터 없음), C 실행기는 rank-4 계약 형상 버퍼 뷰를 평면 순서로 채움(문구 정정) |
| 두 분기 구조·스모크 | 유지 | layout IR의 `try_map` 1·`scf.if %did_map` 1(참조 2회)·실패 분기 alloc이 **정확히 8,840,704**(93개 dense_resource 합, 패딩 0)이며 한쪽 분기에만 있는 다른 할당은 없음; 스모크 JSON 재실행이 61개 필드 전부 동일. 중요한 노트 둘 — (a) **pip 바인딩에서는 map 분기가 API 보장**이다(`VmModule.copy_buffer`가 정렬 사본을 만들고 `wrap_buffer`는 미정렬이면 `ValueError`), 즉 이 배포에서 `B_copy`는 원리적으로 관측 불가이고 검증자는 C 런타임 + E29 shim으로만 18,222,796을 봤다. (b) D50 서술 정정: 결과를 **읽지 않고 붙들기만 해도** 피크가 출력당 12 B 오르지만 그건 해제 가능하고, **호스트로 읽으면** 프로세스 수명 동안 고정된다(`map()`은 이 바인딩의 공개 API가 아님 — `_map_to_host()`). 스모크가 쓰는 처방(결과를 버리는 호출로 피크를 먼저 읽기)은 두 기전 모두에 옳다 |
| fixture 무결성 | 유지(+정정 3건) | `mlir.gz`↔계약 해시, dump 123개↔provenance 목록 0 불일치, 재컴파일로 vmfb·dump 129개 바이트 동일 재현, step 1–8의 모든 sha 대조, gitignore 0건, 시험 31/31. **medium 1건이 실물 결함**: `build/smartcam.elf.json`이 scratchpad 경로와 **삭제된 `.o` 항목**을 담고 있어 축소 fixture에서 그대로 재생성되지 않았다(수치·ELF sha는 동일) — 계약의 "diff 0"이 그 파일을 재사용해야만 성립했다. **커밋 `0397931`에서 저장소 루트 경로로 재생성**(계약은 `provenance.elf_analysis.sha256` 한 줄만 변경, 헤더 바이트 동일), `import_log`의 `cmd:` 줄을 실제 산출 형식으로 교정, `variant_reshape` 헤더의 "바이트 동일" 과장 정정 |
| 계약 수치 | 유지 | 세 번째 정보원(flatbuffer 상수 8,842,644 B)과 **1,940 B까지 조정**(§4), io/transient/constants 각 항의 IR 근거, 재생성 diff 0, 헤더 바이트 동일, 하드닝 기준선 dict 동일. 노트: executable 40 vs ELF 함수 39(ICF alias) |

### 8.2 E30b — SQUEEZE 확장의 잠재 fail-open (D56), 재현·수정

반박 에이전트가 `tflite` 빌더 API로 **합성 flatbuffer**(NHWC 입력 → 1×1 AvgPool → SQUEEZE)를 만들어 보였다:
C1–C4를 전부 통과하는 TFLite-유효 **부분 squeeze** — 예: `[1,1,7,64]`, dims `[1]` → `[1,7,64]` — 가 NHWC→NCHW로
재색인된 텐서(`[1,64,1,7]`) 위에서 방출돼 **데이터가 조용히 전치**된다. 형상·원소 수·dtype이 전부 보존되고
onnx checker·shape inference·`iree-compile`·런타임이 모두 통과하는데 숫자만 틀리다. 비행 모델은 남는 축이
{N,C}라 두 레이아웃에서 순서가 같아 **영향이 없었다** — 그래서 합성 사례가 아니면 원리적으로 볼 수 없었다
(E26a/D47과 같은 부류의 교훈).

이 세션이 그 생성기를 저장소 도구로 고정하고(`harness/gen_tflite_squeeze_cases.py`, D43 규칙) **revert-and-
confirm-fail**로 확인했다 — C5만 끄면:

| 사례 (NHWC 입력, dims → TFLite 출력) | reshape 모드 | squeeze 모드 |
|---|---|---|
| sq_H `[1,1,7,64]`, [1] → `[1,7,64]` | CONVERTED, 실행 `[1,7,64]`, **max_abs_diff 5.464** | CONVERTED, 선언 출력 `[1,7,64]` vs 실제 `[1,64,7]` → 하류 `tensor_static_info_cast`에서 실패 |
| sq_H77 `[1,1,7,7]`, [1] → `[1,7,7]` | CONVERTED, **1.886** | CONVERTED, 실행 `[1,7,7]`, **1.886**(정방이라 어디서도 안 잡힘) |
| sq_N `[1,3,3,4]`, [0] → `[3,3,4]` | CONVERTED, **2.612** | 하류 cast 실패 |

분석서의 문자 그대로의 제안(정적 `Reshape`)이 **셋 다 침묵**하는 쪽이다. 수정은 **C5 — 남는 축이 레이아웃
순열 아래에서 TFLite 순서를 유지해야 한다**(`check_kept_axis_order(rank, dims, perm)`, 순수 함수: 남는 축
k를 `perm.index(k)`로 보내 단조 증가인지). 위반은 Transpose를 끼워 넣는 대신 **명시적 거부**한다 — 분석서
§5의 "조건이 전부 성립할 때만 자동 변환"이 요구하는 것이 정확히 그것이다. 같은 검증이 찾은 셋도 고쳤다:
SqueezeOptions 테이블 부재가 `AttributeError` **크래시**였던 것(TFLite는 빈 squeeze_dims로 해석; 결정을 빚진
자리의 크래시, D24 부류) → 빈 dims 결정; 중복 축을 그대로 전달하던 것 → collapse; 항등 사례(size-1 축 없음)를
C1 위반으로 거부하던 것 → 공허참으로 허용(단, 레이아웃 태그가 있으면 C5가 거부 — 그것도 Transpose가 필요한
경우다).

수정 후 합성 11건(`harness/e30b_squeeze_probe.py`, CONVERTED는 IREE로 컴파일·실행해 `np.squeeze` 의미와 비트
대조): **CONVERTED 5**(sq_HW·sq_neg·sq_dup·sq_empty·sq_noopt — 전부 IREE 출력 = TFLite 의미, max_abs_diff 0.0,
`sq_noopt`는 크래시 대신 결정), **REFUSED 6**(C5: sq_H·sq_H77·sq_N·sq_identity / C1: bad_c1 / C4: bad_c4),
크래시 0, 거부는 ONNX를 쓰기 전에 일어남, reshape 모드도 같은 셋을 거부. 비행 모델의 ONNX 바이트는 **불변**
(`79c57abc…`, C5 감사 필드만 매니페스트에 추가). 회귀 시험 18건 신설, 이 컨테이너 **353/353 → 371/371**. **CI 실측**(커밋 `39a4692`, run 112, 3레그 success): `full` **370/370 + 1 SKIP**(PyYAML) · `without-iree` **240/240 + 21 SKIP** · `stdlib-only` **240/240 + 21 SKIP** — 컨테이너 371/371과 `full`의 차이 1건은 PyYAML 유무(D34), SKIP 20→21은 e30b의 합성 사례 시험이 변환기 패키지 없이는 정직하게 SKIP하기 때문이다.

**교훈**: *"형상·원소 수·dtype이 보존된다"는 데이터 순서가 보존된다는 뜻이 아니다.* 구조 조건은 레이아웃
변환을 통과한 **뒤에도** 성립해야 하고, 그 검사는 변환기가 스스로 해야 한다 — 하류 도구는 정방 텐서에서
아무것도 알아채지 못했다.

### 8.3 남은 묶음

두 분기 구조 · fixture 무결성 · 범위·주장 · 확장의 과잉 거부 네 묶음과, 위 finding들에 대한 2인 검증 표는
워크플로우가 끝나는 대로 이 절에 **덧붙인다**(본문은 고쳐쓰지 않는다).

## 9. 주장하지 않음

- **수치 동치**(TFLite ↔ IREE) — P2. 이 문서의 어떤 출력값도 정확도의 근거가 아니다.
- **정확도** — 어떤 데이터셋에서도 평가하지 않았다.
- **AArch64·cFS 실행** — P3. 헤더는 생성됐지만 C 경로는 돌리지 않았다.
- **soundness·tightness** — 스모크의 `peak == per_call`은 pip 런타임 한 프로세스의 관측이며 E26 셀이 아니다.
- **일반화** — 이 모델·이 컴파일러 버전·이 변환기 버전의 결과다. 다른 TFLite 모델의 다른 op(예: WGAN)이 같은
  경로를 통과한다고 말하지 않는다.
- **`iree-compile` 바이트 재현성** — 두 호출이 일치한 것은 관측이며 성질이 아니다(E26e).
- **실물 비행 하드웨어** — 이 세션은 x86-64 컨테이너다.
