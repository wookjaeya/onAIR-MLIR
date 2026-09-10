# E26 계획 — 부분 메모리 계약 경계의 유용성 (사전 고정 기준)

> **이 문서는 결과보다 먼저 커밋된다.** 아래의 판정 기준·측정 구간·모델 집합은 어떤 수치도
> 보기 전에 고정한 것이며, 실행 후 완화하지 않는다(E25의 규율을 그대로 적용).
> 근거가 된 검증: 일곱 번째 외부 검토 `docs/reviews/REVIEW_v0_22_E25.md` §6,
> 벤치마크 구성 지침 `docs/reviews/BENCHMARK_PLAN_REFERENCE_BASED.md`.

---

## 0. 이 실험이 답하는 것

검토 §6의 세 질문을 그대로 채택한다. **"수치가 맞는가"가 아니라 "이 부분 계약이 실제 cFS 배치
판단에 얼마나 유용한가"**에 답한다.

| # | 질문 |
|---|---|
| Q1 | **상한의 타당성** — 계약과 같은 경계의 실제 메모리 peak가 정적 bound를 넘는가? |
| Q2 | **상한의 보수성** — `bound − peak`가 얼마이며, 모델·실행 경로별 차이는 무엇에서 생기는가? |
| Q3 | **판정의 유용성** — 예산을 bound 전후로 바꿀 때 ADMIT/DENY가 어떻게 달라지는가? |

시간 축(R-5)·다중 앱(R-4)은 다루지 않는다.

### 0.1 두 층을 분리한다 — E26-core / E26-ext

검토 §6("기존 canonical·conv2d·multi-branch를 재사용해 세 질문에 집중하라")과 벤치마크 지침
§7.1(최소 행렬에 B1–B3를 넣으라)은 **층위가 다르다**: 검토는 *무엇을 측정하는가*, 지침은
*어떤 워크로드에서 측정하는가*를 말한다. 한 곳에서만 실제로 충돌하며, 그 충돌은 이렇게 푼다.

| 층 | 모델 | 역할 |
|---|---|---|
| **E26-core** | B0 (canonical · **mlp16k** · conv2d · multibranch) | **E26의 판정을 산출한다.** Q1/Q3의 PASS/FAIL은 여기서 결정된다 |
| **E26-ext** | B2 · B3 · (조건부) B1 | **coverage와 외적 타당성을 보고한다.** 이 층의 결과는 E26 판정을 **차단하지 않는다** |

E26-ext에서 어떤 모델이 막히면 그것은 **coverage 결과로 공개**하고(지침 §8.1·§12), 판정을
미루지 않는다. 반대로 E26-core가 FAIL이면 ext 결과와 무관하게 E26은 FAIL이다.

**지침 채택의 첫 비용은 측정 셀 증가가 아니었다**: 실제로는 CLAUDE.md가 "여기서 닫는다"고
선언한 도구 hardening 축이 재개방됐다(D47·D48). 두 건 모두 **실제로 재현된 과잉 거부**이므로
정당한 재개방이며, "새 결함이 재현될 때만 다시 연다"는 조건을 만족한다.

### 0.2 지침 중 **채택하지 않는** 항목

| 지침 | 이유 |
|---|---|
| §8.3 "QEMU latency는 기능 검증용 **참고치**" | 이 저장소 작업 규율 4가 더 엄격하다 — `platform_check.py`가 `FUNCTIONAL_ONLY`를 반환하는 이 환경에서는 **절대 지연값을 인용하지 않는다.** 참고치로도 싣지 않는다 |
| §10의 `contracts/` · `RESULTS.md` 디렉터리 레이아웃 | 기존 `contracts/`(계약 **스키마**)와 이름이 겹치고, 결과 문서는 EVIDENCE 무수정 규율을 따른다. 산출물은 기존 `results/<실험>/` 관례를 유지한다 |

---

## 1. 벤치마크 포트폴리오 — 지침 반영 결과

지침은 **B0 합성 회귀 + B1 OPS-SAT + B2/B3 MLPerf Tiny + (선택) B4 OrbitAI**를 제안했다.
그 전제를 **실측으로 검증**한 결과 채택·수정·기각이 갈렸다. 아래가 그 결론이다.

### 1.1 채택

| 등급 | 모델 | 상태 | 근거 |
|---|---|---|---|
| **B0** | canonical MLP(E25) · **mlp16k**(E14) · conv2d · multibranch | 그대로 유지, **명칭만 "내부 회귀시험군"으로** | 지침 §3.1. 대표성 주장 금지 |

**canonical과 mlp16k는 서로 다른 아티팩트다.** 계약 수치는 설계상 같지만(canonical을 hidden=16384로
만들었다) vmfb sha256이 다르다(`0e250c2f…` vs `4d6f3807…`). 둘 다 측정하며, 같은 값이 나오는 것은
**가정이 아니라 관측**으로 둔다.
| **B2** | **MLPerf Tiny ResNet** (CIFAR-10) | **계약·헤더 완주 확인** (오버라이드 0개) | `results/e26_boundary_utility/mlperf_tiny_resnet_fixture/` |
| **B3** | **MLPerf Tiny Deep AutoEncoder** (ToyADMOS 계열) | 계약·헤더·vmfb 실행 확인 | 조사에서 `bounded=1,069,632` `per_call=6,208` `constants=1,063,424` |

B2·B3는 상수/per-call 비율이 **극단적으로 다르다**(B2 ≈ 1:1, B3 ≈ 171:1, E25 canonical ≈ 11:1).
기존 모델셋에 없던 대비이므로 Q2에 직접 기여한다.

### 1.2 지침 전제 정정 — B1 (OPS-SAT)

**지침 §3.2의 전제가 사실과 다르다.** `georgeslabreche/opssat-smartcam` @ `be09ece`
(지침이 지정한 SHA, 실존 확인)의 실제 비행 모델은:

| 지침의 서술 | 실측 |
|---|---|
| EfficientNet-Lite0 계열 | **MobileNetV2 전이학습**(tfhub `tf2-preview/mobilenet_v2/feature_vector/4`) |
| 8개 클래스 | **3개** (`bad` / `earth` / `edge`) |
| float16 TFLite 변환 | **float32**, 8,950,028 B 단일 `.tflite` (`quant`·`FLOAT16` 문자열 0건) |
| 입력 200×200×3 | 저장소에서 확인 못 함 |

지침이 인용한 **Kelvins 경쟁 사양**(`kelvins.esa.int`)과 **SmartCam 비행 저장소**는 서로 다른
산출물이며, 전자의 사양이 후자에 적용된 것으로 보인다. 저장소에 실제로 있는 것은 **비행한
모델 그 자체**이므로 지침 §3.2 표 기준으로는 오히려 상위 등급(*flight-artifact*)이지만,
**아키텍처·클래스 수·정밀도를 지침대로 쓰면 사실과 다른 서술이 된다.**

**직접 확인한 인터페이스**(`tflite` 스키마로 flatbuffer를 읽어 확인):

| 항목 | 값 |
|---|---|
| 입력 | `input_1` `[1, 224, 224, 3]` **FLOAT32** |
| 출력 | `Identity` `[1, 3]` **FLOAT32** |
| 연산 | ADD · AVERAGE_POOL_2D · CONV_2D · DEPTHWISE_CONV_2D · FULLY_CONNECTED · MUL · SOFTMAX · SUB · **SQUEEZE** |
| 크기·해시 | 8,950,028 B, sha256 `fd1ecbd0…` |
| 라벨 | `bad` / `earth` / `edge` |

**B1의 취급**: E26-ext 2순위, **조건부**. 착수 조건은 하나로 좁혀졌다 —
**`tflite2onnx`의 SQUEEZE 미지원**이 유일한 반입 차단점이다. 대안 3안을 사전 등록한다:
(a) 그래프에서 SQUEEZE를 등가 Reshape로 치환, (b) 변환기 확장, (c) onnxruntime 경유.
**어떤 변형을 쓰든 원본 sha256·변형 스크립트·사유를 fixture에 보존**하고, 변형된 모델을
"비행 모델 그 자체"라고 부르지 않는다(지침 §3.2의 등급 구분).
그 뒤에도 8.84 MB 상수가 cFS per-app 예산·태스크 스택 회계를 감당하는지는 **미측정**이다.

### 1.3 기각·범위 밖

| 항목 | 판정 | 이유 |
|---|---|---|
| **B4 OrbitAI (AROW)** | **범위 밖** | 신경망이 아니라 C++ 온라인 선형 학습기의 85~434 B 직렬화 상태. IREE 텐서 파이프라인의 대상이 아니다(지침 §3.5도 선택 항목으로 둠) |
| **정확도 기준(Top-1 85% / AUC 0.85) 재현** | **불가, 명시적 범위 밖** | 평가 데이터셋 호스트가 전부 연결 거부: `www.cs.toronto.edu`(CIFAR-10)·`zenodo.org`(ToyADMOS)·`huggingface.co` 모두 http=000(직접 확인). GitHub JPEG 미러로는 Top-1 0.751로 기준 미달 — **미러는 지표 재현에 부적합**하다 |
| **네이티브 int8 ABI** | **범위 밖** | 8개 파일 약 35곳 + 스키마에 quantization(scale/zero_point) 신설 + 고정 시험 6건 재작성이 필요. 추가로 얻는 것은 경계 I/O 97 B(11%)뿐 |

### 1.4 반입 경로 (검증됨, TensorFlow 불필요)

`iree-import-tflite`는 **쓸 수 없다** — `_pywrap_mlir`가
`ExperimentalTFLiteToTosaBytecode`를 export하지 않아 래퍼가 `NameError`로 깨진다(두 조사가
독립 확인). 크기 문제가 아니다(`tensorflow-cpu` 273.8 MB는 규칙 이내).

> **정정(E26c 반박 검증)**: 이 문장은 처음에 "TF 2.21에서"라고 썼다. 실측은 **TF 2.19.1·
> 2.20.0·2.21.0 셋 다** 같은 심볼을 export하지 않는다 — 2.21 특유의 회귀가 아니므로
> 다운그레이드로 우회할 수 없다. 아울러 차단 축을 정확히 적을 것: `iree-tools-tflite`는
> PyPI에 살아 있고 최신 휠(20260316.1567)은 이 저장소의 `iree-compile`(3.11.0rc20260316 @
> `e4a3b04`)과 **같은 릴리스 실행 산출물**이다. 즉 막는 것은 IREE 쪽 버전 불일치가 아니라
> **TensorFlow↔TOSA↔IREE 축**이며, 그 휠 자체는 Requires-Dist가 없는 3,552 B shim이라
> 날짜 일치가 기능 호환을 함의하지 않는다.

확립된 경로:

```
tflite2onnx  (순수 파이썬: numpy/onnx/tflite)          # .tflite -> .onnx (opset 11)
onnx: graph.name = "infer"                             # 비식별자 그래프명 정규화
iree-import-onnx --opset-version 17                    # 17 승격 필수(opset 11 Softmax legalize 실패)
iree-opt --pass-pipeline='builtin.module(
    torch-onnx-to-torch-backend-pipeline,
    torch-backend-to-linalg-on-tensors-backend-pipeline)'   -> <model>.mlir  (고정 산출물)
iree-compile  <한 번의 호출>                            # 계약·layout IR·dump·vmfb
```

**`iree-opt` 사전 lowering이 필수다.** 없으면 `$async` coarse-fence 래퍼가 생기고
`iree.abi.declaration`이 0개라 `make_contract.py`가 세 지점에서 hard-fail 한다.
사전 lowering 후에는 저장소의 수기 linalg 모델과 **동형**이 되어 도구 수정 없이 통과한다.

**작업 규율 7(one-invocation)과의 관계**: 전처리는 `.mlir` 입력 파일을 만들 뿐이고, 계약
산출물은 보존된 그 `.mlir` **하나에서 한 번의 `iree-compile`**로 나온다
(`provenance.single_invocation = true` 확인). **그 `.mlir`을 고정 산출물로 보존**해야 하며,
재컴파일로 얻은 IR로 검증하면 규율 위반이다.

### 1.5 반입 시 확인된 함정 (E26에서 반드시 기록할 것)

- **같은 폴더의 `.h5`와 `.tflite`가 다른 가중치일 수 있다** — MLPerf `ad01`에서 실측
  (출력 max|Δ| = 0.615). **어느 파일이 정본인지와 sha256을 계약·증거에 반드시 기록**한다.
- `tflite2onnx`는 int8 텐서에 "not supported/tested yet" 경고를 낸다 → **f32 변종만** 쓴다.
- TFLite 그래프명이 MLIR 식별자로 부적합하면(`pre-alpha` 등) entry 탐색이 깨진다 → 개명 필요.

---

## 2. 사전 고정 판정 기준

> **이 절은 측정 시작 후 수정되지 않았다.** 이후 갱신(§0.1 층 분리, §1.2의 B1 사양 확인)은
> 범위·사실 기록이며 판정 기준에는 손대지 않았다. 기준을 결과에 맞춰 고치지 않는다는 규율이
> 이 문서의 존재 이유다.

| 질문 | 지표 | 판정 |
|---|---|---|
| **Q1 soundness** | 셀(모델×경로×구간)마다 `hal_peak ≤ bounded_bytes` | **하나라도 초과 → 그 셀 FAIL**, 결함 원장 등록. 사후 완화 없음 |
| **Q2 보수성** | `slack = bounded − peak`; 그리고 **분기 판정**(§3) | 판정 없음(보고). 단 원인 미확정이면 "미확정"으로 명시 |
| **Q3-i 안전성** | 예산 `B ∈ {bounded−1, bounded, bounded+1}`에서 verdict와 실측 peak | **ADMIT인데 `peak > budget`인 셀 = unsafe admit = FAIL.** 0건이어야 PASS |
| **Q3-ii 과보수 대역** | `peak ≤ budget < bounded` 구간의 폭 | 보고 |
| **Q3-iii 커버리지** | `bounded / (앱 전체 메모리 증가분)` | 보고. **분모는 RSS이므로 x86-64 값만 근거**, 게스트 값은 표시용 |
| **귀속 분리** | ① 계약 영역(HAL) ② IREE 런타임 컨텍스트 ③ 모듈 로드 ④ 래퍼/앱 ⑤ OSAL/cFS 기저 | 보고. ②~⑤를 "고정 오버헤드 버킷"으로 다룰 수 있는지는 x86-64 3회 반복의 범위로 판단 |
| **추출 coverage** (지침 §8.1) | 계약 생성 성공 모델 수 / 시도 모델 수 | **실패 모델과 원인을 숨기지 않고 공개**한다 |

`P ≤ B`가 관측됐다는 결과는 **관측 범위 내 경험적 soundness**다. 모든 입력·플랫폼에 대한
형식적 증명으로 확대하지 않는다(지침 §8.1 마지막 문단 그대로 채택).

---

## 3. Q2의 재구성 — tightness는 컴파일러가 emit한 분기의 함수다

**v0.9부터 미해결이던 conv2d의 `native 1,352` vs `cFS 3,528`에 기전 설명이 생겼다.**
layout IR을 직접 읽어 확인했다(`results/e14_aarch64_qemu/x86_64/layout_ir/conv2d.layout_ir.txt:104`):

```mlir
%did_map, %result = stream.resource.try_map ... %buffer_cst[%c0] : !util.buffer
                        -> i1, !stream.resource<constant>{%c2176}
%2:2 = scf.if %did_map -> (...) {
  scf.yield %1, %result                                   // 매핑 성공: HAL 할당 없음
} else {
  %8 = stream.resource.alloc uninitialized ... {%c2176}    // 실패: 상수만큼 HAL 할당
  ...
}
```

- 매핑 성공 분기 → HAL peak = `static_per_call_bytes`
- 실패 분기 → HAL peak = `static_per_call_bytes + module_resident_constant_bytes`
- **conv2d: 1,352 + 2,176 = 3,528** — 관측된 두 값이 정확히 이 두 분기다.

보관 모델 전수 확인: `dynamic`을 제외한 12개 layout IR **전부** `try_map` 1개 + `alloc` 폴백
1개 구조다.

**따라서 `bounded_bytes`는 이 `scf.if` 두 분기의 최댓값이다.** 그래서
- **soundness는 두 분기 모두에서 구조적으로 성립**하고,
- **tightness만 어느 분기가 실행됐느냐의 함수**다.

**E26의 Q2는 이것을 검증한다**(가설이며, 아직 실행으로 확인하지 않았다):

| 관측 | 해석 |
|---|---|
| `peak == per_call` | 매핑 성공 분기 |
| `peak == per_call + constants` | 매핑 실패 분기 |
| 그 외 | **가설 반증** — 원인을 규명하거나 "미확정"으로 기록 |

부수 가설(별도 확인): 상수가 vmfb에 **embedded**인지 **external**인지가 분기를 가르는가?
(conv2d 2,176 = embedded / mlp16k 720,896 = external). **추측이며 측정으로 확정한다.**

---

## 4. 측정 매트릭스

| 축 | 값 |
|---|---|
| 모델 | **B0**: canonical(E25) · mlp16k(E14) · conv2d · multibranch — **B2**: MLPerf Tiny ResNet — **B3**: MLPerf Tiny DeepAE |
| ISA | x86-64, AArch64 |
| 실행 | standalone IREE(native C), cFS+IREE |
| 구간 | `after_init`(추론 0회) / `after_first_call` / `steady` |
| 예산 | `B−1`, `B`, `B+1` |
| 관측 | 정적 계약, 같은 경계의 HAL peak, admission 결과, 출력, RSS 버킷 |

- **재컴파일 금지**: B0는 보관 vmfb·계약·헤더를 그대로 쓴다. B2·B3는 §1.4 경로로 만든
  `.mlir`을 **고정 산출물로 보존**하고 그 하나로만 컴파일한다.
- HAL 통계는 결정론적이므로 1회 + 결정성 확인 1회. RSS는 x86-64에서 3회.
- E14/E17이 이미 채운 셀(conv2d native, mlp16k cFS 경계값)은 재실행하지 않고 인용한다.

### 4.0 AArch64 게스트 `B−1` 셀은 빌드되지 않는다 (실측, 정상 동작)

`scripts/51_build_cfs_aarch64.sh`를 `AI_LEARNER_BUDGET_BYTES = bounded − 1`로 돌리면 실패한다:

```
51_build_cfs_aarch64: ERROR: contract sha256 4e5b2972... not found in ai_learner.so
                      (wrong header compiled in?)
```

**앱의 결함이 아니다.** 예산이 bound보다 작으면 컴파일러가 admission 실패를 **정적으로 판정**해
그 뒤의 artifact-binding 코드를 통째로 죽은 코드로 제거하고(`-O2`), 빌드 검증이 사라진 sha256
문자열을 정직하게 보고한 것이다. CLAUDE.md의 함정 표에 있는 `CONTRACT_BOUND_KNOWN=0` 사례와
**같은 기전, 다른 방아쇠**다.

따라서 게스트의 `B−1` 셀은 이 스크립트로 만들 수 없다. **DENY 동작은 x86-64 cFS의 `B−1` 셀이
이미 실행으로 보였으므로**(NOT_ADMITTED), 게스트에서는 `B`·`B+1`만 측정하고 이 사실을 기록한다.

### 4.1 측정 위생 (v0.22.2에서 이미 구현)

**모든 cFS 시나리오의 expect에 `e25_mode_active: false`와 `mem_init_present: true`를 넣는다.**
`/cf/e25_inputs.bin`이 있으면 앱이 초기화 중 64회 추론을 먼저 돌려 구간 분리가 파괴된다.
레코드 **부재는 `false`가 아니라 실패**로 처리된다(그 레코드를 내지 않는 옛 앱은 증언할 수 없다).

---

## 5. 실행 순서

1. **이 문서 커밋** (기준 고정) ← *현재 단계*
2. x86-64 native + cFS 측정 — `results/e26_boundary_utility/x86_64/`
3. AArch64 qemu-user + 게스트 측정 — `results/e26_boundary_utility/aarch64/`.
   게스트 세션에서 **A5b_canonical 1건**(`harness/corrupt_vmfb.py`)도 함께 실행해 R-1 잔여를 닫는다.
4. **Q2 분기 판정** — §3의 가설을 셀별로 검증
5. `cross_target_compare --native-summaries`로 **`both_sound` 실제로 채우기**
   (E25가 채우지 못한 것 — v0.22.1 정정 참조). E14 파일은 덮어쓰지 않고 새 디렉터리에.
6. `docs/EVIDENCE_v0.25_E26.md` + 원장 갱신

---

## 6. 알려진 잔여 결함 후보 (E26 착수 전 판단 필요)

조사에서 **재현됐으나 아직 고치지 않은** 과잉 거부 후보. 각각 실험 1건으로 처리하거나
**명시적 범위 밖**으로 둔다 — 조용히 우회하지 않는다.

| # | 증상 | 영향 |
|---|---|---|
| ~~C-1~~ | ~~**다출력 모델 계약 불가**~~ — **E26c에서 해소(D49)**. 아래 참조 | ~~다출력 모델 전부~~ |
| C-2 | **헤더의 경계 시그니처 dtype 게이트** — `gen_contract_header.py`가 **엔트리 시그니처**를 단일 f32 in/out으로 강제해 f16 모델과 2입력 모델은 계약이 유효한데도 헤더 거부. dtype 전용 우회 플래그는 없다 | 실전 CNN(다입력·f16) |
| C-3 | **cFS 앱의 feature 버퍼가 스택 배열이다** — `native/cfs_app/fsw/src/ai_learner.c:440`이 추론마다 `float feat[CONTRACT_INPUT_ELEMS]`를 **스택에** 잡는다. 입력 원소 수가 계약에서 오므로 9~256짜리 모델에서는 문제가 없지만, **영상 모델에서는 태스크 스택을 넘는다** | **B1을 SQUEEZE보다 먼저 막는다** |

**C-1은 E26c에서 닫혔다(D49)**. 직접 재현했다 — 스톡 2출력 모델을 한 번의 `iree-compile`로
컴파일하니 entry에 `stream.resource.alloca` **1개(128 B)**와 `stream.resource.subview` **2개**
(32 B @0, 16 B @64)가 나왔다. 즉 파서는 유일한 실제 할당을 이미 건전하게(그것도 보수적으로:
128 ≥ 32+16) 계상하고 있었고, 거부는 순전히 화이트리스트 누락 때문이었다 — 유형 (B) 과잉 거부.
두 추출기에 op을 추가하되 **검사 없이 신뢰하지는 않는다**: 세 index 피연산자가 전부 상수로
풀리고 `offset + result_size <= source_size`일 때만 통과하며, 그렇지 않으면 `unresolved`다.
근거 실물은 `harness/gen_model_multiout.py` + `results/e26c_multiout/`(D43 규칙)이고,
실측 HAL 피크 **704 B = bounded 704 B**로 tightness 1.00×다.
**남는 제약**: C 헤더 생성기는 여전히 단일 f32 in/out만 허용하므로 다출력 모델은 *계약은
생성되고 C 배치는 거부*된다(C-2와 같은 경계 시그니처 게이트). 이는 두 C 실행기가 실제로
가정하는 바이므로 과잉 거부가 아니라 정확한 진술이다.

**C-2의 정확한 범위**(반박 검증에서 좁혀짐): 이것은 **양자화 게이트가 아니라 경계 시그니처
dtype 게이트**다. int8 연산을 내부에 두고 **f32로 입출력하는 표준 양자화 배포 형태**는 코드 수정
없이 통과한다(조사에서 실측 확인). 또한 세 게이트가 전부 `bound_known` 조건 아래 있어,
`bound_method=NONE`인 계약(예: 동적 형상 i8 모델)은 **헤더가 생성된다** —
`CONTRACT_BOUND_KNOWN 0` · `CONTRACT_DTYPES_ALL_F32 0`이 찍혀 C 게이트가 뒤에서 거부하므로
배치는 막히지만, *"헤더를 쓰지 않는다"*는 서술은 그 영역에서 정확하지 않다.

**C-3은 산술로 확정된다**: OPS-SAT의 `[1,224,224,3]`은 150,528 원소 × 4 B = **602,112 B**이고,
태스크 스택은 `base 262,144 + kernel`이다 — **2.3배 초과**. 즉 B1의 착수 조건은 §1.2가 말한
SQUEEZE 반입 문제 **이전에** 이 앱 구조를 고치는 것이다(HAL 입력 버퍼를 직접 쓰거나 정적 버퍼로
옮기는 것이 후보이며, 같은 함수의 `zeros`는 이미 `static`이다 — `:322`).

C-1·C-2·C-3 모두 **B2/B3에는 영향이 없다**(단일 f32 in/out, 입력 12,328 B / 2,560 B).
B1(MobileNetV2 224×224×3)과 임무형 다입력 모델을 넣을 때 비로소 걸린다.

---

## 7. 주장 가드레일 (지침 §13 그대로 채택)

**가능**
- 실제 비행 유래 및 공개 임베디드 AI 모델에서 계약을 추출할 수 있는지 **평가했다**.
- 동일 메모리 경계에서 정적 계약과 HAL 관측 peak를 비교했다.
- cFS가 실행 전 예산 경계에서 일관되게 ADMIT/DENY하는지 검증했다.
- 미지원·동적 사례의 fail-closed 동작과 추출 coverage를 **공개했다**.

**금지**
- QEMU 결과로 실제 우주용 보드의 WCET·전력·실시간성을 입증했다는 서술
- 공개 사양으로 재학습/변환한 모델이 실제 비행 가중치와 동일하다는 서술
- OnAIR를 직접 통과하지 않은 실행을 OnAIR 통합 결과라고 부르는 것
- 관측된 `P ≤ B`만으로 보편적·형식적 soundness를 증명했다는 서술
- 합성 MLP 하나로 위성 AI 전반의 대표성을 주장하는 것
- **MLPerf Tiny의 정확도 기준을 만족한다는 서술** (이 환경에서 평가 데이터 확보 불가)
- 보안·공급망·서명 문제를 본 연구의 필수 검증 범위로 확장하는 것
