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

**두 분기 구조**: layout IR에 `stream.resource.try_map` 1 · `scf.if` 1 · 상수 블록 `stream.resource.alloc`
1 — E26이 합성·MLPerf Tiny 모델에서 본 구조가 이 비행 모델에도 그대로다. `B_map = per_call` 9,382,092,
`B_copy = bounded` 18,222,796, 비 **1.94×**. (E29의 조건부 계층이 그대로 적용 가능하다는 뜻이지 적용했다는
뜻이 아니다.)

## 5. 스모크 실행 (step 8) — `harness/p1_smoke_pip_runtime.py`, 타당성 기록이지 판정이 아님

pip `iree.runtime`(local-sync)에서 `infer([1,3,224,224] f32) → [1,3] f32`가 완주한다. 고정 입력 두 개
(영벡터, seed 0 균등난수)에 대해 유한·결정적(같은 입력 두 번 = 같은 바이트) 출력이 나오고, 결과를 버리는
호출 10회 뒤의 HAL 통계는 **`device_bytes_peak` 9,382,092 = `per_call` 정확히**, `allocated == freed`
(93,820,920 = 10 × 9,382,092) — 이 프로세스는 map 분기를 탔다(E29의 정렬 결정 요인을 제어하지는
않았다). 출력값 자체([0.933, 0.035, 0.032] / [0.934, 0.040, 0.027], 둘 다 argmax 0 = "bad")는 **아무것도
말하지 않는다** — 영벡터와 난수는 영상이 아니고, 정확도·동치는 P2·이후의 질문이다.

**관측자 효과(D50의 새 얼굴)**: 이 바인딩에서 결과를 호스트로 읽으면(`np.asarray` / `to_host()` / `map()`
어느 것이든) 그 12 B HAL 버퍼가 `del` + `gc.collect()` 뒤에도 프로세스 끝까지 "allocated"로 남는다
(5회 읽기 = 60 B 보유, 이후 호출의 피크 +48). 그래서 스크립트는 **결과를 버리는 호출로 피크를 먼저 읽고**
그 다음에야 출력을 읽으며, 읽은 뒤의 통계를 `hal_statistics_after_host_reads`로 **따로 남긴다**(숨기지
않는다). E26e가 반환 버퍼 5개를 리스트에 담아 두었다가 `refutes_hypothesis`를 낼 뻔한 것과 같은 계열이다.

## 6. 반입이 만든 인터페이스 변경 — P2의 의무 (숨기지 않는다)

| | 비행 TFLite | IREE 엔트리 |
|---|---|---|
| 입력 | `[1,224,224,3]` **NHWC** | `[1,3,224,224]` **NCHW** |
| 원소 수 / dtype | 150,528 / f32 | 150,528 / f32 |
| 원소 **순서** | — | **보존되지 않음** |

tflite2onnx는 Transpose 노드를 넣는 대신 Conv 가중치를 재배열하고 입력을 NCHW로 선언한다. 이 저장소의 두
C 실행기(`native_learner.c`·`ai_learner.c`)는 `CONTRACT_INPUT_ELEMS` 길이의 평면 f32 벡터를 받을 뿐
레이아웃을 모른다. 따라서 **P2는 TFLite 입력을 NHWC→NCHW로 전치한 사본을 IREE 엔트리에 먹여야** 같은
입력을 비교하는 것이 된다. `feasibility_summary.json`·`import_log.txt`에 같은 문장으로 적어 두었다.

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
없는 환경에서는 해당 시험이 명시적으로 SKIP한다(D24/D25).

## 8. 적대적 검증 (이 세션, 9개 반박 에이전트 + finding당 2인 검증) — 진행 중

이 커밋 시점에 9개 주장 묶음(provenance · SQUEEZE 변환 · 결정론 · 인터페이스 변경 · 계약 수치 · 두 분기
구조 · fixture 무결성 · 범위·주장 · 확장의 과잉 거부)에 대해 반박 에이전트가 돌고 있다. 완료된 2건
(provenance, 결정론)은 **반박 실패**(주장 유지)이며 노트만 남겼다 — provenance: 재클론 + `cmp`로 바이트
동일, `git hash-object` 일치, `cloned_at_utc`가 실제로는 매니페스트 기록 시각이었음(필드명 정정 반영);
결정론: `--opset-version 17` 없이도 importer가 opset 11을 수용, 정렬은 고유 이름에 의존(ONNX checker가
보장), 매니페스트는 경로를 담아 디렉터리 간 바이트 비결정. 나머지 결과와 확인된 finding의 반영은 **후속
커밋에서 이 절에 덧붙인다**(작업 규율 3·5: 본문은 고쳐쓰지 않고 정오표로).

## 9. 주장하지 않음

- **수치 동치**(TFLite ↔ IREE) — P2. 이 문서의 어떤 출력값도 정확도의 근거가 아니다.
- **정확도** — 어떤 데이터셋에서도 평가하지 않았다.
- **AArch64·cFS 실행** — P3. 헤더는 생성됐지만 C 경로는 돌리지 않았다.
- **soundness·tightness** — 스모크의 `peak == per_call`은 pip 런타임 한 프로세스의 관측이며 E26 셀이 아니다.
- **일반화** — 이 모델·이 컴파일러 버전·이 변환기 버전의 결과다. 다른 TFLite 모델의 다른 op(예: WGAN)이 같은
  경로를 통과한다고 말하지 않는다.
- **`iree-compile` 바이트 재현성** — 두 호출이 일치한 것은 관측이며 성질이 아니다(E26e).
- **실물 비행 하드웨어** — 이 세션은 x86-64 컨테이너다.
