# MLPerf Tiny Visual Wake Words — 실물 근거 (E26-ext)

**세 번째 공개 실물 모델**이며, 지금까지 중 **HAL 실측까지 완주한 첫 외부 모델**이다
(B2 ResNet과 B3 DeepAE는 계약·헤더까지, 이 모델은 native 예산 sweep까지).

## 출처

| 항목 | 값 |
|---|---|
| 저장소 | `mlcommons/tiny` (Apache-2.0), 지침 지정 SHA `4addd0f` |
| 원본 | `benchmark/training/visual_wake_words/trained_models/vww_96_float.tflite` |
| 원본 크기·해시 | 866,284 B, sha256 `115bbc094d2119561320a21f01b6500a18bea8cc8589282ab007097bec8af38c` |
| 구조 | MobileNetV1 계열, 96×96 입력, f32 |
| 반입 | `docs/plans/E26_boundary_utility.md` §1.4 경로 (tflite2onnx → import_onnx → iree-opt → **한 번의** iree-compile) |

**정확도는 재현하지 않았다** — 평가 데이터셋 접근이 이 환경에서 막혀 있다(§1.3).

## 계약 (오버라이드 0개)

```
bounded_bytes                   = 1,298,952
static_per_call_bytes           =   457,224
module_resident_constant_bytes  =   841,728
artifact                        =   891,028 B
provenance: single_invocation=true, overrides_applied=[], verification_grade=verified
```

## native x86-64 예산 sweep (`../x86_64/native_ext/`)

| 예산 | verdict | HAL peak |
|---|---|---|
| `B−1` = 1,298,951 | **NOT_ADMITTED** | — |
| `B` = 1,298,952 | ADMIT | **1,298,952** |
| `B+1` = 1,298,953 | ADMIT | **1,298,952** |

**`peak == bounded` 정확히 일치**(할당 분기, tightness 1.00×) — E26-core의 B0 모델들이
같은 배포에서 보인 것과 같다. unsafe admit 0건.

## 이 fixture의 지위

**E26-ext**다 — E26의 Q1/Q3 **판정은 E26-core(B0)가 산출**하며, 이 모델은 그 결과가 실제
공개 워크로드에서도 재현되는지를 **보고**한다(계획 §0.1). 판정을 차단하거나 대체하지 않는다.

## 파일

| 파일 | 무엇 |
|---|---|
| `vww.mlir` | 사전 lowering된 linalg MLIR — **계약을 만든 그 입력**(1.7 MB) |
| `vww.vmfb` | 그 한 번의 컴파일 산출물 (891,028 B) |
| `vww.contract.json` / `vww.elf.json` / `vww.h` | 계약·ELF 분석·배치 가능 C 헤더 |

`dump/`는 보존하지 않았다(1.7 MB, 계약 재생성은 `vww.mlir` 한 번의 컴파일로 가능).
