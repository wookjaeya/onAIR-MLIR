# EVIDENCE v0.26 — E26c: 다중 출력 모델 과잉 거부 (D49)

- 실험 ID: **E26c**
- 날짜: 2026-09-09
- 입력: 벤치마크 지침(B0–B4) 도입 조사가 남긴 잔여 결함 후보 **C-1**
  (`docs/plans/E26_boundary_utility.md` §6)
- 플랫폼 등급: **결정론적**(layout IR 구조 분석, 계약 수치, HAL 할당자 통계)
- 산출물: `harness/gen_model_multiout.py`, `results/e26c_multiout/`

## 0. 판정

**수정.** 정직한 모델이 계약 자체를 만들 수 없던 세 번째 유형 (B) 결함(과잉 거부, **D49**)을
재현·수정했다. D47(E26a)·D48(E26b)과 마찬가지로 **실제 워크로드를 넣으려는 순간** 드러났고,
셋 다 원인·위치는 다르다.

- 이 컨테이너 실측: **244/244**(직전 229/229), 신규 15건.
- **보관 14개 계약 diff 0**.
- 신규 fixture의 계약은 **오버라이드 0개**로 생성되고, 실측 HAL 피크 **704 B = bounded 704 B**
  (tightness 1.00×).

이 결함은 **독립적으로 두 번 지목됐다**: 지침 도입 조사의 C-1과, 이후 별도로 돌린 반박 검증의
"현재 계약 파이프라인이 실제 CNN 규모·구조를 감당하는가" 축이 같은 결론에 도달했다. 아래의
재현·수정은 어느 쪽 보고도 액면 그대로 받지 않고 **직접 컴파일해서 확인한 것**이다(E24c/F4의
교훈: 에이전트 결론을 그대로 받았다면 맞는 문서를 틀리게 고칠 뻔했다).

## 1. 재현

출력이 둘인 모델을 스톡 플래그로 **한 번** 컴파일하면 IREE는 결과를 **하나의 external 슬랩에
패킹한 뒤 `stream.resource.subview`로 쪼갠다.** 보관된 layout IR의 entry 본문 그대로:

```
%result, %result_timepoint = stream.resource.alloca uninitialized ... !stream.resource<external>{%c128_4}
%1 = stream.resource.subview %result[%c0_1]  : !stream.resource<external>{%c128_4} -> !stream.resource<external>{%c32}
%2 = stream.resource.subview %result[%c64_3] : !stream.resource<external>{%c128_4} -> !stream.resource<external>{%c16}
```

할당은 **1개(128 B)**, 뷰가 **2개**(32 B @0, 16 B @64)다. 결과 실량은 32 + 16 = 48 B이고
각 출력이 64 B HAL 정렬로 패딩돼 128 B 슬랩이 된다. 즉 **파서는 유일한 실제 할당을 이미
건전하게, 그것도 보수적으로 계상하고 있었다.**

그런데 `stream.resource.subview`가 두 추출기의 화이트리스트 어디에도 없었다:

| 파일 | 화이트리스트 | subview |
|---|---|---|
| `harness/static_mem_bound.py` (정규식) | `_KNOWN_ENTRY_OPS` | 없음 |
| `harness/mlir_alloc_walk.py` (구조적) | `KNOWN_ENTRY_OPS` | 없음 |

D13의 fail-closed 규칙이 그대로 발동해 둘 다 `unresolved`로 밀어 넣었다(수정 전 실측):

```
regex     : unresolved = ['unrecognized_op:stream.resource.subview']
structural: unresolved = ['unrecognized_op:stream.resource.subview',
                          'unrecognized_op:stream.resource.subview']
```

`unresolved`가 비어 있지 않으면 `bound_method`는 `UNKNOWN_BOUND`다. **결과적으로 다중 출력
모델은 전부 계약을 만들 수 없었다** — 필요한 정보가 없어서가 아니라, 있는 정보를 쓰지 못해서다.
이것이 이 저장소가 유형 (B)로 부르는 과잉 거부다.

## 2. 수정 — 화이트리스트에 넣되, 신뢰하지 않고 검사한다

`subview`는 구조상 비할당이다. 그 점에서 이미 화이트리스트에 있던 `stream.tensor.export`·
`stream.resource.dealloca`와 같은 부류다. 다만 그 둘과 달리 **검사를 붙였다**: subview는
"이 리소스의 이 구간을 본다"는 **주장**을 담고 있으므로, 그 주장이 자기 소스 안에 들어맞는지
확인할 수 있다.

받아들이는 조건은 둘 다 만족할 때뿐이다.

1. 세 index 피연산자(`source_size`, `offset`, `result_size`)가 전부 상수로 풀린다.
2. `offset + result_size <= source_size`.

하나라도 어긋나면 `unresolved`이고 계약은 나오지 않는다. 구조적 추출기의 피연산자 순서
`[source, source_size, offset, result_size]`는 추측이 아니라 **실제 op에 MLIR API를 걸어
읽은 것**이다.

## 3. revert-and-confirm-fail (2단계)

이 저장소의 규율대로 수정 전 코드로 되돌려 신규 시험이 **실제로** 실패함을 확인했다. 이번에는
결함이 두 겹이라 되돌리기도 두 번 했다.

| 되돌린 것 | FAIL | 무엇을 증명하는가 |
|---|---|---|
| 화이트리스트만 (검사 코드는 남김) | **7건** | 과잉 거부가 실재했다 — 정직한 모델이 계약을 못 만든다 |
| 검사 코드까지 (화이트리스트는 남김) | **4건** | 검사가 실제로 일을 한다 — 없으면 거짓말하는 subview 두 종류가 **그대로 통과**한다(fail-open) |

두 번째 줄이 중요하다. 화이트리스트에 넣기만 하고 끝냈다면 유형 (B)를 고치면서 유형 (A)를
새로 심는 것이었고, 시험이 그것을 잡는다.

## 4. 실물 근거 보존 (D43 규칙)

"실제 모델이 X를 한다"로 정당화한 수정은 그 모델이 저장소에 있어야 한다.

- `harness/gen_model_multiout.py` — 생성기. 두 가지가 의도적이다: **비-splat 난수 가중치**
  (splat `dense<0.05>`는 상수 슬랩 없이 실체화돼 `module_resident_constant_bytes`가 0이 되고
  시험하는 것이 줄어든다), **서로 다른 크기의 결과 2개**(offset·window가 둘 다 달라야
  봉쇄 검사가 우연히 만족되지 않는다).
- `results/e26c_multiout/` — **한 번의 `iree-compile` 호출** 산출물(작업 규율 7).
  128 KB. `dump/`는 축소본(`.o`/`.bc`/`.s` 없음 — `.gitignore` 트랩 회피)이며, 보관된 계약은
  **이 축소본에서 그대로 재생성된다**(시험이 매번 확인).

계약 수치:

| 항목 | 값 |
|---|---|
| `static_per_call_bytes` | 192 (입력 64 + 출력 슬랩 128) |
| `module_resident_constant_bytes` | 512 |
| `bounded_bytes` | 704 |
| `constants_confirmation_state` | `confirmed` |
| `single_invocation` | `true` |
| 구조적 크로스체크 | `agrees_with_regex_parser: true` |
| 오버라이드 | **0개** |

`iree.runtime` local-sync 5회 실행의 HAL 할당자 통계: `device_bytes_peak` = **704 B**,
출력 2개(`[1,8]`, `[1,4]`). **피크 = bounded, tightness 1.00×.**

## 5. 남는 제약 — 계약은 되고 C 배치는 안 된다

`harness/gen_contract_header.py`는 이 계약을 받고도 헤더를 쓰지 않는다:

```
gen_contract_header: bound_method=static_from_stream_layout but interface is not the
single-f32-input/single-f32-output shape native_learner.c/ai_learner.c hardcode
(inputs=1 outputs=2 dtypes=['f32'])
```

이것은 **과잉 거부가 아니다.** 두 C 실행기가 실제로 단일 입출력을 가정하고 있고, 게이트는
그 사실을 정확히 말하고 있다(C-2와 같은 경계 시그니처 게이트). 따라서 E26c가 연 것은
**계약 생성 경로**이며, 다중 출력 모델의 **C/cFS 배치**는 여전히 열려 있지 않다. 그 확장은
별도 항목이다.

## 6. 범위 밖 (명시)

- 다중 출력 모델의 native C / cFS 배치 — §5.
- `stream.resource.subview`가 **비-entry** 영역(예: initializer)에 나오는 경우의 회계.
  이번 fixture에도 entry 밖에 subview가 1개 더 있으나, 상수 회계는 별도 경로(`dense` 스캔)로
  하고 있어 이번 변경의 대상이 아니다.
- 다른 IREE 버전에서 같은 패킹 패턴이 유지되는지 — R-2에 남는다.

## 7. 함께 처리한 정정

같은 세션의 반박 검증(8건: UPHELD 1, QUALIFIED 7, 반전 0)에서 **저장소에 실제로 커밋된
서술 중 틀린 것 1건**을 찾아 고쳤다. `docs/plans/E26_boundary_utility.md` §1.4가
`iree-import-tflite`의 차단을 "TF 2.21에서"라고 특정했으나, 실측은 **2.19.1·2.20.0·2.21.0
셋 다** 같은 심볼을 export하지 않는다 — 버전 다운그레이드로 우회할 수 없고, 막는 축도
IREE 쪽 버전 불일치가 아니라 TensorFlow↔TOSA↔IREE다. 나머지 QUALIFIED 6건은 조사 보고서
내부 서술에 대한 정밀화이며 커밋된 문서를 바꾸지 않는다.
