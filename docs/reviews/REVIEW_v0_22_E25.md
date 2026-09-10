# onAIR-MLIR v0.22 / E25 연구 현황 검토

> 기준 커밋: `44c27ac2d3333cf6c2b3ae7a120cefba5085f795`  
> 검토일: 2026-09-09  
> 범위: 직전 저장소 검토 결과의 문서화. 핵심 연구 주장, 실험 증거, E26·E27 진행 방향을 대상으로 한다.

## 1. 종합 판정

**E25는 실질적인 연구 진전이다. canonical 모델의 AArch64 cFS 실행까지 확인됐으며, 이제 E26으로 진행할 근거가 확보됐다.**

현재 성과는 고정된 모델·입력·컴파일 설정에서의 계산 결과 일치와 cFS 내부 추론 통합이다. 이를 OnAIR 프레임워크 전체의 동치나 두 ISA에서의 메모리 상한 검증 완료로 확대해서는 안 된다. 필요한 것은 짧은 주장 범위 정정이며, 방어적 구현 검토를 다시 시작할 이유는 없다.

## 2. 독립 재검토 결과

저장된 출력에 비교 스크립트를 다시 실행하고, 모델·가중치·입력·VMFB의 대응을 확인했다.

| 확인 항목 | 결과 |
|---|---|
| 저장된 가중치와 입력으로 NumPy reference 재계산 | 저장된 reference와 일치, 최대 절대 차이 0 |
| IREE Python·native C·cFS x86-64·cFS AArch64의 reference 대비 비교 | 네 경로 모두 사전 허용 오차 통과 |
| 네 IREE 경로 사이 비교 | 6쌍 모두 비트 동일 |
| AArch64 두 번의 실행 출력 | 바이트 단위 동일 |
| canonical source·weight·input hash | manifest와 일치 |
| x86-64 및 AArch64 VMFB 크기·hash | 각 계약과 일치 |
| 비교 JSON 재생성 | 저장된 `comparison_all.json`과 동일 |

검토 범위는 **저장된 결과의 재계산·대조와 코드 확인**이다. QEMU/cFS 전체를 새로 빌드·실행한 검증은 아니다.

각 경로는 64개 입력 × 2개 출력, 즉 128개 원소를 비교한다. 네 경로 합계는 **512/512 원소 통과**, argmax는 **각 경로 64/64 일치**다. Evidence의 `256/256 원소`는 집계 표현을 정정하면 된다. PASS 판정에는 영향이 없다.

## 3. E25가 입증한 것

다음 문장이 현재 증거에 부합한다.

> 고정한 canonical 모델과 64개 입력에 대해 IREE Python, native C, cFS x86-64 및 cFS AArch64의 계산 결과가 사전 허용 오차 내에서 reference와 일치했다. 네 IREE 실행 경로 사이에서는 비트 동일도 관측됐다.

모델은 활성화 없는 `x @ w0 @ w1` 구조이며, 결과의 적용 범위는 해당 모델·입력 집합·컴파일러 버전·타깃 설정이다. 두 번의 AArch64 실행 일치는 해당 조건에서의 반복성 증거로 해석한다.

**이전 검토 정정:** “AArch64에서는 비트 동일이 성립하지 않는다”는 단정은 잘못이었다. 정확한 표현은 “서로 다른 ISA에서는 비트 동일을 보장하지 않으므로 tolerance로 판정한다”이다. 이번처럼 실제 결과가 비트 동일할 수 있다. 출력 일치만으로 두 ISA의 누산 순서까지 같다고 단정할 수는 없다.

## 4. 완료 주장에 필요한 두 가지 구분

### 4.1 계산 경로 동치와 OnAIR 전체 데이터 흐름 동치

현재 Evidence의 `OnAIR-IREE`는 IREE Python 바인딩 실행이다. 기존 `CompiledLearner`는 여전히 외부 `weights.npz`를 읽고 이를 추론 인수로 전달한다. 따라서 canonical baked 모델 실험의 성공이 기존 플러그인의 전환 완료를 뜻하지는 않는다.

cFS E25 모드는 실제 앱 초기화에서 계약·binding 검사를 통과한 뒤 파일 입력을 직접 추론한다. Software Bus 메시지 수신과 feature 변환을 통한 전체 데이터 흐름은 해당 시험에 포함되지 않는다.

**권고:** E25를 “canonical 모델의 계산 결과 동치 및 cFS 내부 추론 경로 통합 검증”으로 정리하고 E26으로 진행한다. OnAIR 전체 프레임워크나 메시지 전처리까지 완료했다고 주장하지 않으면 된다. 현재 목표를 위해 별도 프레임워크 전체 검증 실험을 확대할 필요는 없다.

### 4.2 출력 동치와 메모리 상한 검증

`harness/cross_target_compare.py`의 `both_sound`는 두 타깃의 메모리 관측 결과가 상한을 만족하는지를 종합하는 값이다. 출력이 같다는 사실로 이를 채울 수 없다.

**이전 검토 정정:** E25로 E14의 `both_sound: null`까지 해소된다고 동의했던 판단은 철회한다. E25는 canonical 모델의 cross-target 출력 비교 증거를 추가했다. 기존 E14 전체 모델의 메모리 soundness 공백까지 닫은 것은 아니다.

| 연구 질문 | 현재 상태 |
|---|---|
| 같은 모델이 두 ISA에서 같은 출력을 내는가? | E25의 모델·입력 조건에서 확인 |
| 두 ISA의 계약값이 같은가? | canonical 모델에서 확인 |
| 두 ISA의 실제 메모리 사용량이 계약 상한 이내인가? | 대응하는 메모리 계측이 별도로 필요 |
| 여러 모델에서도 계약 경계가 유용한가? | E26 핵심 과제 |
| MLIR 정보를 사용하는 고유한 이점은 무엇인가? | E27에서 입증 필요 |

현재 canonical 모델의 계약값은 양쪽 ISA에서 `bounded=786476 B`, `per_call=65580 B`, `constants=720896 B`로 같다. 이는 해당 구성의 관측 결과이며, 계약값의 일반적인 ISA 독립성을 증명하지는 않는다.

## 5. 필요한 최소 정리

| 항목 | 조치 | 중요도 |
|---|---|---|
| E25 완료 범위 | 계산 엔진과 cFS 파일 입력 경로로 명시 | 연구 주장 정확성 |
| `both_sound` 공백 해소 표현 | 출력 동치와 메모리 검증을 분리 | 연구 주장 정확성 |
| 비교 스크립트의 ISA별 판정 | 동일 VMFB는 비트 동일, cross-ISA는 사전 tolerance 적용 | 후속 실험 유효성 |
| Evidence의 원소 수 | 경로당 128, 네 경로 총 512로 정정 | 집계 표현 |
| README의 AArch64 미실행 표기 등 | E25 완료 현황과 동기화 | 문서 정리 |

현재 `e25_compare.py`는 모든 IREE 경로 쌍에 비트 동일을 요구한다. 이번 결과는 그 강한 조건도 만족하므로 PASS는 유효하다. 다만 다른 모델의 cross-ISA 결과가 tolerance를 만족하고 비트만 다를 때 잘못 FAIL 처리하지 않도록 후속 사용 전에 사전 계획과 일치시켜야 한다. 이는 기준 완화가 아니라 이미 정한 비교 조건의 구현이다.

## 6. E26 권고

기존 canonical 모델·conv2d·multi-branch를 재사용해 다음 세 질문에 집중한다.

1. **상한의 타당성:** 계약 영역의 실제 메모리 peak가 정적 bound를 넘는가?
2. **상한의 보수성:** `bound − peak`가 얼마이며 모델·실행 경로별 차이는 무엇에서 생기는가?
3. **판정의 유용성:** 예산을 bound 전후로 바꿀 때 ADMIT/DENY가 어떻게 달라지는가?

계약과 같은 영역의 peak를 비교하고, runtime·wrapper·cFS/OSAL 비용은 별도로 귀속한다. 관측에서 상한 초과가 없었다는 결과와 모든 실행에 대한 수학적 증명은 구분한다.

### E26 측정 전 필수 사항

**초기 메모리 측정에서는 `e25_inputs.bin`을 제거하거나 E25 모드를 비활성화한다.** 현재 코드는 이 파일이 있으면 초기화 중 64회 추론을 먼저 실행한다. 이후 초기화·최초 추론·정상 실행의 메모리 통계와 peak가 섞일 수 있으므로 측정 구간을 명확히 분리해야 한다.

이는 보안이나 일반 구현 보강이 아니라 E26의 측정 정확성에 직접 관련된 사항이다.

## 7. E27 및 연구 범위

E26 이후에는 MLIR 단계의 shape·할당·dispatch 정보가 LLVM IR/ELF 또는 runtime 계측에 비해 계약 생성에 어떤 이점을 주는지 비교한다. 정규 MLIR pass 구현 여부 자체보다 분석 가능 범위·정확성·보수성·수작업 요구량의 차이가 핵심이다.

저장소가 `THREAT_MODEL.md`를 `ASSUMPTIONS_AND_SCOPE.md`로 축소한 것은 합의한 방향과 일치한다. 후속 검토도 정상 연구 파이프라인의 결과와 핵심 주장에 영향을 주는 사항에 한정한다. 수동 계약 위조, 서명·키 관리, 공급망 및 배포 보안은 다시 연구 항목으로 등록하지 않는다.

## 8. 최종 진행 방향

**E25의 주장 범위와 판정 도구를 짧게 정리한 뒤 E26 → E27로 진행한다.** 현재는 동일 모델의 계산과 cFS 실행 증거를 확보했고, 이제 부분 메모리 계약의 실제 유용성과 MLIR 접근의 고유 기여를 평가할 단계다.

## 근거

- [검토 커밋](https://github.com/wookjaeya/onAIR-MLIR/commit/44c27ac2d3333cf6c2b3ae7a120cefba5085f795)
- [E25 Evidence](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/docs/EVIDENCE_v0.22_E25.md)
- [전체 경로 비교 결과](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/results/e25_equivalence/build/comparison_all.json)
- [E25 비교 스크립트](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/harness/e25_compare.py)
- [cross-target 비교 지표](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/harness/cross_target_compare.py)
- [cFS 앱](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/native/cfs_app/fsw/src/ai_learner.c)
- [OnAIR 플러그인](https://github.com/wookjaeya/onAIR-MLIR/blob/44c27ac2d3333cf6c2b3ae7a120cefba5085f795/plugins/compiled_learner/compiled_learner_plugin.py)
