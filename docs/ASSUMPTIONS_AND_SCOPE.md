# 연구 가정과 유효성 범위

1. 계약은 `harness/make_contract.py`로 생성하며 생성 후 수동 변경하지 않는다.
2. MLIR, VMFB, layout IR, ELF 분석 및 계약은 문서화된 동일 실험 파이프라인의 산출물이다.
3. hash와 provenance는 실험 대상 식별, 산출물 대응 확인 및 재현성을 위해 사용한다.
4. fail-closed 검사는 악의적 입력이 아니라 분석 실패, 미확인 값, 환경 차이와 잘못된
   산출물 결합을 방지한다.
5. 악의적 변조, 공급망 공격, 전자서명, 키 관리 및 배포 보안은 연구 범위에 포함하지 않는다.
6. 메모리 계약은 전체 OBC가 아니라 `per-call buffers + module constants`만을 대상으로 한다.

## 용어

- hash → **실험 대상 식별 및 artifact consistency**(무결성 증명 아님)
- provenance → **생성 과정과 override의 감사 기록**(신뢰 증명 아님)
- fail-closed → **미확인 증거를 확인된 상한으로 오인하지 않기 위한 정책**

## 신규 지적을 실험으로 등록하기 전의 세 질문

1. 정상 파이프라인(`make_contract.py` + 문서화된 빌드·실행 경로)에서 발생 가능한가?
2. 핵심 주장(메모리 bound 정확성 / admission 판정 / 동일 모델 의미 동치 / MLIR 고유 기여)
   중 하나를 바꾸는가?
3. 실험 유효성 또는 재현성을 훼손하는가?

셋 다 "아니오"면 코드 수정·실험·결함 번호를 부여하지 않는다.

## 논문 방법론 문장

> 본 연구는 계약 JSON이 제안된 계약 생성 파이프라인을 통해 생성되고 이후 수동으로 변경되지
> 않는다고 가정한다. MLIR, VMFB, layout IR, ELF 분석 결과 및 계약은 문서화된 동일 실험
> 과정의 산출물이다. Hash와 provenance 정보는 보안 목적이 아니라 실험 대상 식별, 산출물 간
> 대응 확인 및 결과 재현성을 위해 사용한다. 계약 검증의 fail-closed 정책은 악의적 입력에
> 대한 방어가 아니라, 분석 실패나 미확인 값이 유효한 정적 상한으로 해석되는 것을 방지하기
> 위한 것이다. 악의적 변조, 공급망 공격, 전자서명 및 배포 보안은 본 연구 범위에 포함하지
> 않는다. 또한 본 계약은 전체 온보드 컴퓨터 메모리가 아니라 IREE 컴파일 산출물에서
> 도출되는 호출별 버퍼와 모듈 상수 영역을 대상으로 한다.

---

## 논문 범위 결정 (2026-09-09, 여섯 번째 외부 검토 + 사용자 지시)

`docs/reviews/ONAIR_MLIR_SCI_REVIEW_20260909.md`가 SCI급 기준으로 major revision을 요구했고,
연구 책임자가 **논문의 핵심 논증 범위를 다음으로 확정**했다.

> 논문은 **"MLIR 기반 AI 실행 메모리 admission"**에 집중한다.

### 핵심 논증에서 제외 (검토서 §12와 일치)

| 항목 | 근거 |
|---|---|
| 보안 — 악의적 변조·해시 위조 | 위 가정 5. 이미 범위 밖으로 확정돼 있었다 |
| 공급망·서명·키 관리 | 위 가정 5 |
| QEMU 성능 — latency·jitter·WCET·전력 | `platform_check.py`가 `FUNCTIONAL_ONLY`를 반환하는 환경이다. 실물 하드웨어가 있어야 주장 가능(R-5) |
| cFS 전체 인증(flight qualification) | cFS 오픈소스 번들을 flight-qualified system으로 표현하지 않는다 |

**손상 아티팩트 시험(A5a·A5b)과 51건의 결함 원장은 구현 신뢰성의 보조 증거로 부록에 둔다.
본문의 연구 기여로 확대하지 않는다.** 새 fail-closed 음성 시험을 늘리는 것도 본문 기여가
아니다 — 실제로 재현된 결함이 있을 때만 고치고 원장에 기록한다.

### 계약의 정확한 이름 (검토서 §4.5)

이 연구의 계약은 **partial per-app model-execution memory contract**다. 다음은 계약에
포함되지 않으며, 별도 버킷이거나 명시적 범위 밖이다.

- IREE runtime/session 고정비
- cFS 앱 및 OSAL 메모리
- 태스크 스택(별도 버킷으로 회계하며 admission gate가 아니다)
- wrapper의 입출력 버퍼
- 파일 로드용 임시 메모리
- 여러 앱 또는 동시 추론의 합성 효과 (R-4)

*"온보드 컴퓨터가 모델을 수용 가능한지 판정한다"*처럼 전체 메모리 feasibility로 확대하지
않는다. admission JSON은 매 판정마다 `"scope":"per_app_local_budget"`으로 이 한계를 명시한다.

### 이 결정이 바꾸지 않는 것

기존 판정과 수치는 그대로다. 바뀌는 것은 **논문 본문에 무엇을 싣고 무엇을 부록·범위 밖으로
두는가**이며, 이는 검토서 §12가 요구한 것과 같다.

### 검증 결과를 받은 뒤의 착수 순위 (드리프트 방지)

검토서는 9개 축을 지적했다. 결과가 한꺼번에 도착하면 전부 쫓아가기 쉬우므로 **착수 전에**
기준을 정한다. 판단 기준은 하나다 — **"MLIR 기반 AI 실행 메모리 admission"이라는 핵심
논증을 바꾸는가.**

| 축 | 핵심 논증에 대한 기여 | 착수 |
|---|---|---|
| **LLVM IR/ELF-only 기준선** — `try_map` 두 분기 구조가 그 층위에 남는가 | **결정적.** 남지 않으면 그것이 "MLIR이라야 얻는 정보"의 실물 후보다 | **최우선** |
| **조건부 계약** — `B_map`/`B_copy` 분기 결정 요인 규명과 제어 가능성 | **결정적.** 검토서가 제안한 새 핵심 기여이며 E26의 172.3× 보수성을 직접 해결한다 | **최우선** |
| **robust VMFB-only 기준선** — 공정한 비교에서도 차이가 남는가 | **결정적.** E27 결론의 존폐가 걸린다 | **최우선** |
| matched-version 비교 | 기존 드리프트 증거가 "정보 수준 차이"인지 "도구 호환성"인지 재분류 | 높음 |
| admission utility 정량화 | R-2의 남은 절반. `B±1`은 off-by-one 검증일 뿐이다 | 높음 |
| 실물 모델의 cFS 셀 | admission 주장의 증거 폭. 즉시 가능하면 실행, 아니면 범위로 명시 | 중간 — **즉시 가능할 때만** |
| 실물 모델의 의미 보존(TFLite↔IREE) | 메모리 admission 논증 자체는 아니다. 경량 도구가 있으면 하고, 없으면 **주장을 좁힌다** | 중간 — **저비용일 때만** |
| 재현성 핀·공개 상태 | 논문 artifact 요건이지 논증이 아니다 | 낮음 — 값싼 것만 |
| 검토서 자체 수치 대조 | 방법론 위생(E24c/F5 전례) | 낮음 — 기록만 |

**하지 않을 것**: 위 표에서 "낮음"인 항목을 실험으로 키우는 것, 새 fail-closed 음성 시험을
늘리는 것, 손상 아티팩트 축을 다시 여는 것. 이것들은 이미 부록으로 강등됐다.

#### 최우선 세 축의 결과 (v0.31 갱신)

| 축 | 결과 |
|---|---|
| **조건부 계약** | **닫힘 — v0.31/E29**(`docs/EVIDENCE_v0.31_E29.md`). 결정 요인은 모듈 이미지 포인터의 **64바이트 정렬**이고(64/64셀, 위반 0), 배포가 제어할 수 있다. 제어 시 map 피크 = `per_call` **정확히**(7/7). cFS에서 배치 예산 172배 감소. 조건부 admission은 opt-in·계약 스키마 변경 0·전제조건을 **측정으로 검증** |
| **robust VMFB-only 기준선** | **닫힘 — v0.31 정정**(`docs/EVIDENCE_v0.29_E27.md` §7). E27의 침묵은 **출하한 구현**의 성질이었다. 굳힌 변종은 드리프트를 `C4_DISASM`으로 거부하고 정직한 7개를 정확히 맞힌다(과잉 거부 0). E27 결론은 존속하되 **가용성**으로 좁혀졌다 |
| **LLVM IR/ELF-only 기준선** | **미결.** 이 세션에서 재검증하지 않았다. 알려진 것: `try_map` 두 분기 구조는 **디바이스 ELF에 없다**(vmfb가 싣는 것은 VM 바이트코드다). 그것이 호스트 프로그램 층위에 남는지, 그리고 그 층위에 닿으려면 컴파일러와 소스가 필요한지(=배포 아티팩트 수준이 아닌지)를 확인하는 것이 다음 질문이다. **E29가 이 축의 실용적 부분은 이미 답했다** — 분기는 정적 층위에 "있는" 것이 아니라 런타임 HAL의 정렬 검사가 정하며, 그래서 앱이 측정해서 검증한다 |

#### 일곱 번째 외부 검토(2026-09-09, 종합 검토)의 분류 (v0.32)

`docs/reviews/ONAIR_MLIR_RESEARCH_CONSOLIDATED_REVIEW_20260909.md`. Core / Supporting / Out-of-scope로
먼저 분류한다(E24 계열 규율).

| 항목 | 분류 | 상태 |
|---|---|---|
| **P0 E29b** — §4.1 조건부 검증 `> per_call`은 `constants < per_call`에서 fail-open; §4.2 거부 전 일시 할당 | **Core** | **완료(v0.32/E29b, D54)**. 검토서 예측이 실물로 재현됐고, §4.2는 선택지 1(append 전 확정)로 닫음 |
| **P1** — 실물 모델 provenance·import feasibility (SmartCam, WGAN, ResNet, DeepAE) | **Core** (논문의 "가장 강한 문장"의 전제) | **SmartCam 완료(v0.33/E30, `docs/EVIDENCE_v0.33_E30.md`)** — 여덟 번째 외부 분석서(`docs/reviews/ONAIR_MLIR_P1_SEQUENCE_ANALYSIS_1.md`)가 "SmartCam 한 모델로 P1을 먼저 종료"하라고 했고 그대로 했다. 판정 **TRANSFORM_REQUIRED → GO**: 원본 무수정(commit `be09ece`, sha `fd1ecbd0…`), stock tflite2onnx의 SQUEEZE 거부 재현, C1–C4 검사 변환기 확장으로 한 번의 `iree-compile`까지 완주, 계약 오버라이드 0(bounded 18,222,796 = 9,382,092 + 8,840,704), 아티팩트 전용 기준선 일치. **P2 의무**: 엔트리 입력이 NCHW라 TFLite 입력을 전치해야 하고 배치는 1로 고정된다. v0.33.1/E30b(D56): 적대적 검증이 확장의 잠재 fail-open(부분 squeeze의 조용한 전치)을 합성 사례로 재현 → C5 신설, 비행 모델 무관. ResNet·DeepAE는 E26e·E26f 반입이 이미 있고(단, P1 형식의 provenance manifest는 없음), **WGAN은 미착수**(분석서 §7: 대형 출력 사례가 필요할 때). 이전 사전 확인: `wgan_fpn50_p.tflite` 4,299,472 B(sha `5258e859e5ca968f…`); `iree-import-tflite`는 이 환경에 없어 반입 경로는 E26f/E30과 같은 `tflite2onnx → iree-import-onnx` |
| **P2** — x86-64 구현 검증(TFLite↔IREE 출력 비교) | Core | 미착수 |
| **P3** — AArch64 본 실험(Native·cFS, SmartCam/WGAN/ResNet/DeepAE) | Core | 미착수. AArch64 게스트 재구축 필요(scripts/60·61·70·71·51) |
| **P4** — LLVM IR/ELF-only 기준선 | Core (R-3 강화) | 미착수 — 순위표의 미결 축과 동일 |
| **P5** — 논문용 통합 결과표 | Supporting | P2–P4 이후 |
| §11 cFS 앱 일반화(다중 출력·큰 출력·SB 패킷 대신 파일 공급) | Supporting (P3의 전제) | 미착수. 단, §11-1(입력 tensor를 stack 밖으로)은 **E28/D52로 이미 완료**(static) |
| §5.3 제외 후보(OrbitAI RF, RaVAEn, PhiSat, 임의 축소 CNN) | Out-of-scope | 검토서 판단 그대로 채택 |
| §9.3 QEMU latency/jitter/WCET/전력 | Out-of-scope | 기존 규율(R-5)과 동일 |

**하지 않을 것(재확인)**: P1–P3를 한 세션에 몰아서 시작하지 않는다. 검토서 자신이 §12에서 P0 → P1 →
P2 → P3 순서를 지정했고, P1의 op 목록·치환 규칙(§6.2 SQUEEZE 등)이 확정되기 전에 cFS 앱 일반화(§11)를
손대는 것은 드리프트다.

**남은 표의 나머지 축**(matched-version 재분류, admission utility 정량화, 실물 모델의 cFS 셀,
의미 보존, 재현성 핀, 검토서 수치 대조)은 순위표의 등급 그대로다. 특히 **AArch64 게스트
cFS 셀**(E26-ext 두 실물 모델 + E29의 조건부 셀)은 여전히 미실행이다.

### TFLite의 위치 (2026-09-09, `docs/reviews/TFLITE_COMPARISON_ROLE_20260909.md`)

**TFLite는 경쟁 대상이 아니라 원본 기준선이다.**

> TFLite 비교는 제안 방식의 경쟁 우위를 직접 증명하는 실험이 아니라, 실제 레퍼런스 모델이
> MLIR/IREE 및 cFS 배치 경로에서도 원래의 의미를 유지한다는 것을 확인하는 검증층이다.
> MLIR의 고유 기여는 **같은 IREE 실행**을 대상으로 한 정적·조건부 메모리 계약과 admission
> baseline 비교에서 논증한다.

세 가지를 구분한다.

| 대상 | 이 연구에서의 역할 |
|---|---|
| `.tflite` 모델 파일 | 실제 레퍼런스 모델의 원본 |
| TensorFlow Lite **runtime** | 원본 출력의 기준선(의미 보존 확인용) |
| TensorFlow Lite **Micro** | **필수 baseline이 아니다** — MCU용 정적 arena 런타임이라 이 논문의 대상(AArch64 CPU + cFS)과 실행환경이 다르다. 포함하더라도 별도 보조 실험 |

**MLIR 기여의 주 baseline은 TFLite가 아니다.** 같은 원본 모델·같은 VMFB·같은 ISA·같은 IREE
버전·같은 로딩 방식·같은 memory scope·같은 fail-closed 정책·같은 입력에서 **정보 수준만**
바꾼 사다리로 논증한다: 파일 크기 → artifact-only → runtime profile → MLIR universal →
MLIR conditional.

#### 메모리 비교의 범위 규율

서로 다른 것을 비교하지 않는다. 특히 **MLIR partial contract를 TFLite process RSS와 비교하지
않는다.** 범위를 넷으로 나눠 같은 범위끼리만 정량 비교한다.

| 범위 | 포함 | 비교 |
|---|---|---|
| S1 모델 buffer | activation, transient, per-call 할당 | 직접 비교 가능 |
| S2 모델 상수 | weights/constants의 map 또는 copy | 정책을 맞춘 뒤 비교 |
| S3 runtime/session | interpreter·HAL·driver 상태 | 별도 보고 |
| S4 process total | 코드·shared library·cFS/OSAL·스택·allocator overhead | **계약값과 직접 비교 금지** |

분리 계측이 불가능하면 TFLite peak는 설명적 참고값으로만 제시하고 계약 soundness 판단에
쓰지 않는다.

#### 의미 보존 주장의 단계적 축소 (이 환경의 제약)

공식 평가 데이터셋 호스트가 이 환경에서 차단돼 있음을 직접 확인했다(CIFAR-10·ToyADMOS).
따라서 주장을 다음 순서로 **가능한 가장 강한 단계까지만** 한다.

1. 공식 평가셋 전체로 accuracy/AUC 재현 → **이 환경에서 불가**
2. 고정 golden/sample 입력에 대한 **출력 동치**(abs/rel 오차 + argmax 일치) → 경량 런타임을
   설치할 수 있으면 수행
3. 둘 다 불가하면 **의미 보존을 주장하지 않는다** — "공개 모델의 그래프와 가중치를 반입해
   메모리 계약 성질을 측정했다"로 범위를 좁힌다

*"정확도가 보존됐다"*는 1단계 없이는 쓰지 않는다.

#### 이 위치 정리가 닫는 것

TFLM Bazel 빌드 우회(`grpc` 의존성 오버라이드 연쇄)는 **재개 대상이 아니다.** 노동집약적이고
핵심 논증을 바꾸지 않는다. `CLAUDE.md`의 TFLM 착수 이력은 이력으로만 남긴다.
