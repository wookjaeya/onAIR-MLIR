# EVIDENCE v0.23 — E26a: 계약 도구가 실제 공개 CNN을 수용하도록 (D47)

- 실험 ID: **E26a**
- 날짜: 2026-09-09
- 입력: 벤치마크 구성 지침 `docs/reviews/BENCHMARK_PLAN_REFERENCE_BASED.md` (B0–B4 포트폴리오)
- 플랫폼 등급: **결정론적**(ELF 정적 분석, 계약 수치, 해시). 지연값은 인용하지 않는다.
- 산출물: `results/e26_boundary_utility/mlperf_tiny_resnet_fixture/`

## 0. 판정

**수정.** 정직한 공개 CNN(MLPerf Tiny ResNet, CIFAR-10)이 이 저장소의 계약 파이프라인에서
**배치 가능한 헤더를 만들지 못하고 거부되던** 유형 (B) 결함(과잉 거부, **D47**)을 재현·수정했다.
수정 후 그 모델은 **오버라이드 0개**로 계약과 헤더까지 완주한다.

- 이 컨테이너 실측: `contract_negative_tests.py` **221/221**(직전 209/209), 신규 12건.
- **보관 14개 계약 diff 0**(값·헤더 전부 불변). 기존 증거는 하나도 바뀌지 않는다.
- CI 세 레그 수치는 CI가 실측한 뒤 기록한다(D34 규율).

## 1. 왜 이 결함이 지금까지 보이지 않았나

벤치마크 지침이 요구한 것은 "합성 모델 대신 출처가 추적되는 실제 워크로드"였다. 그 요구를
따르자마자 **첫 실물 모델에서** 도구가 막혔다.

원인은 단순하다. `harness/elf_stack_frame.py`의 `classify()`는 처음부터 이렇게 말해 왔다:

> bucket (3)/(4) CANDIDATE: N call instruction(s) in the executable; callee stack use is not
> visible in this ELF -> **resolve targets (imports/runtime) before classifying.**

그런데 **그 "resolve" 단계는 구현된 적이 없다.** 호출 명령이 하나라도 있으면 무조건
bucket (3)/(4)였고, `gen_contract_header.py`(E21/D22)가 그 분류를 "분석기 자신이 신뢰하지
않는다"로 읽어 헤더를 거부한다. 그 게이트 자체는 옳다 — 틀린 것은 그 앞의 측정이다.

**이 저장소가 지금까지 측정한 모든 모델은 `total_call_insns = 0`이다**:

| 모델 집합 | `total_call_insns` |
|---|---|
| E14 보관 14개 (mlp16k·conv2d·multibranch·dynamic × 2타깃 × swap) | 전부 **0** |
| E25 canonical (x86-64 / AArch64) | 둘 다 **0** |

손으로 쓴 linalg 모델은 자기완결적 dispatch로 lowering된다. 실제 CNN은 그렇지 않다 —
**활성화 함수 하나로 충분하다.** ResNet의 softmax dispatch가 컴파일러 생성 부동소수 헬퍼를
80번 호출한다.

즉 이 결함은 **합성 모델셋으로는 구조적으로 재현 불가능**했다. 지침이 말하는
"실험 워크로드의 현실성과 외적 타당성" 문제의 구체적 실례다.

## 2. 재현 (실측)

MLPerf Tiny ResNet(`mlcommons/tiny` @ `4addd0f`, `pretrainedResnet.tflite`, 318,144 B,
sha256 `b5c0046d…`)을 TensorFlow 없이 반입해 컴파일했다(경로는 fixture README 참조).
계약은 **오버라이드 0개**로 생성됐다:

```
bounded=618856 per_call=309416 io=12328 transient=297088 constants=309440
dispatches=16 artifact=345952 B  schema: valid
single_invocation=true  overrides_applied=[]  verification_grade=verified
structural_walker.agrees_with_regex_parser=true
```

그런데 헤더 생성이 거부됐다:

```
gen_contract_header: bound_method=static_from_stream_layout and a numeric stack figure is
present (439), but the ELF analysis flagged it as unreliable
(kernel_stack_classification='bucket_3_or_4_unresolved_calls'
 kernel_dynamic_stack_alloc=False kernel_external_call_insns=80)
-- refusing to emit a header that would report it as known
```

**그 80개 호출이 무엇인지 직접 확인했다**(`objdump`/`readelf`, fixture에 보존):

| 관측 | 값 |
|---|---|
| 서로 다른 call 타깃 | **2개** (`0x53c0` 72회, `0x5440` 8회) |
| `.text` 범위 | `0x2e50`–`0x54fc` → **두 타깃 모두 내부** |
| `.plt` 섹션 | **없음** |
| `undefined_symbols` | **`[]`**, 재배치는 전부 `R_X86_64_RELATIVE` |
| 두 헬퍼 | leaf, `push`/`sub rsp` 없음 → **프레임 0 B** |
| 실제 추가 스택 | 반환 주소 **8 B** |

즉 **호출된 코드가 같은 ELF 안에 있고 그 스택이 정적으로 완전히 보인다.** "no static
task-stack bound"라는 보고는 사실과 다르다.

## 3. 수정 — 해석은 하되, 증명할 수 없으면 거부한다

`elf_stack_frame.py`에 호출 그래프 해석을 넣었다. **한 방향으로만 작동한다**: 미해석을
해석으로 바꿀 수는 있어도 그 반대는 없고, 증명하지 못하는 첫 지점에서 즉시 포기한다.

거부를 유지하는 조건(전부 시험으로 고정):

| 조건 | 이유 |
|---|---|
| 간접 호출 (`call *%rax`, `blr`) | 타깃을 알 수 없다 |
| 이 ELF 실행 섹션 **밖** 타깃 | 외부/런타임 호출 — 스택이 보이지 않는다 |
| 콜리가 다른 알려진 함수로 점프 (꼬리 호출) | 그 함수의 프레임을 몰래 삼키게 된다 |
| 콜리 안의 간접 분기 / 읽을 수 없는 분기 타깃 | 범위를 확정할 수 없다 |
| 콜리의 동적 스택 증가 | 정적 상한이 없다 |
| 재귀 (호출 체인에 이미 있는 주소) | 깊이가 정적이지 않다 |
| 분석 파일에 해석 결과 자체가 없음 (옛 JSON) | **부재는 "해석됐다"가 아니다** — 총 호출 수로 되돌아간다 |

콜리의 범위는 **CFG를 실제로 순회해** 찾는다. 첫 구현은 "첫 `ret`까지"로 잘랐는데, 함수는
여러 `ret`을 가질 수 있고 **바로 이 ResNet 헬퍼(`0x5440`)가 자기 첫 `ret`을 건너뛰는 전방
분기를 갖는다** — 그래서 첫 구현은 이 실물에서 **거짓 거부**를 냈다. 시험으로 고정했다.

수정 후:

```
unresolved_call_insns = 0
distinct_targets      = ['0x53c0', '0x5440']
callees               = frame_bytes 0, invocation_stack_bytes 8, chain_stack_bytes 8 (둘 다)
max_dispatch_invocation_stack_bytes            = 439
max_dispatch_invocation_stack_bytes_with_calls = 439
  (호출하는 softmax dispatch만 보면 240 -> 248; 최대치는 호출 없는 conv dispatch의 439)
```

헤더:

```
#define CONTRACT_BOUND_KNOWN 1
#define CONTRACT_PROVENANCE_VERIFIED 1
#define CONTRACT_BOUNDED_BYTES 618856L
#define CONTRACT_KERNEL_STACK_BYTES_KNOWN 1
#define CONTRACT_KERNEL_STACK_BYTES 439L
#define CONTRACT_DTYPES_ALL_F32 1
```

### 3.1 계약 쪽에서 고친 것 — 필드 이름이 거짓말을 하고 있었다

`make_contract.py`의 `kernel_external_call_insns`는 이름과 달리 **`total_call_insns`**
(내부 호출 포함)로 채워지고 있었다. 그리고 헤더 게이트는 그 값을 *"콜리 스택을 볼 수 없는
호출의 수"*로 읽는다. 모든 기존 모델이 0이라 두 해석이 갈린 적이 없었을 뿐이다.

이제 이 필드는 **해석되지 않은 호출의 수**를 담는다(옛 분석 파일이면 총 호출 수로 폴백 —
보수적 방향). 계약에는 **판정만** 넣고(이 수, 분류, 설명 문구) 콜리별 상세는 ELF 분석 JSON에
남겼다 — 그래서 **보관 14개 계약이 바이트 단위로 불변**이다.

`kernel_task_stack_invocation_bytes`는 체인 포함 값을 쓴다. 기존 모델은 호출이 없어 값이 같다.

## 4. 시험 (12건 신설, `call_resolution_cases()`)

| 시험 | 기대 |
|---|---|
| 지역 직접 호출 | 해석됨, 호출자+콜리 프레임 **둘 다** 합산 |
| 간접 호출 / 범위 밖 호출 / 꼬리 호출 / 콜리 동적 alloca / 콜리 간접 분기 / 재귀 | **전부 미해석 유지** |
| 실물 ResNet ELF | 80 호출·2 타깃·해석됨·`with_calls=439` |
| 호출하는 dispatch의 체인 | 자기 프레임 + 콜리(240 → 248) |
| 그 계약 → 헤더 | 오버라이드 없이 `KERNEL_STACK_BYTES_KNOWN 1`, `439L` |
| **ELF 없이 디스어셈블만** | 함수 경계 휴리스틱이 과분할 → **거부로 저하**(틀린 수치가 아니라) |
| 옛 분석 JSON | `make_contract`가 총 호출 수로 폴백 |

**revert-and-confirm-fail**: 수정 전 코드로 되돌리면 12건 중 **11건이 실패**한다
(통과하는 1건은 계약→헤더 경로만 보는 시험이라 분석기 버전과 무관하다).

## 5. 이 실험으로 주장할 수 있는 것 / 없는 것

**주장 가능**
- 공개 표준 CNN 하나(MLPerf Tiny ResNet)에서 이 저장소의 계약이 **오버라이드 없이** 생성되고
  배치 가능한 C 헤더까지 간다.
- 그 과정에서 합성 모델셋이 구조적으로 드러낼 수 없던 과잉 거부 1건을 재현·수정했다.
- 호출 그래프 해석은 증명 가능한 경우에만 작동하며, 정보가 나쁘면 **거부로 저하**한다.

**주장하지 않음**
- 이 모델의 **정확도(Top-1)** — CIFAR-10 평가셋 호스트가 이 환경에서 막혀 있다(직접 확인).
  이 fixture는 계약 생성 가능성의 근거이지 품질 근거가 아니다.
- **모든** CNN이 통과한다 — 해석되는 것은 내부 직접 호출뿐이고, 런타임 호출이나 간접 호출이
  있는 모델은 여전히(정당하게) 거부된다.
- 이 모델의 HAL 관측 peak가 계약 이하라는 것 — **아직 실행하지 않았다**(E26의 대상).
- 양자화(int8) 모델 — 별개 문제이며 범위 밖(§6).

## 6. 남은 것

- **E26 본 측정**: 이 모델을 포함해 계약값 대 HAL peak의 soundness·tightness·admission 유용성.
  계측 분리는 v0.22.2에서 이미 넣었다.
- **AArch64**: 이 모델의 AArch64 컴파일과 해석은 아직 하지 않았다(헬퍼가 `bl`로 나타날 것이며
  같은 해석기가 다루도록 작성했으나 **실측하지 않았다**).
- **양자화**: 네이티브 int8 ABI는 8개 파일 약 35곳 + 스키마 신설이 필요해 범위 밖으로 둔다.
  "f32 ABI + 내부 int8 연산" 변종은 코드 수정 없이 통과함을 별도로 확인했다(계획서 참조).
