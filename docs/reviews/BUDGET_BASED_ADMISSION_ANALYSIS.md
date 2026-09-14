# 참조 기반 메모리 예산과 모델 Admission 실험 분석

## 1. 결론

현재 네 모델의 계약 상한, AArch64 실행, HAL 메모리 관측 및 cFS 승인·거절 배선은 이미 검증됐다. 따라서 다음 실험에서 계약 생성이나 출력 의미 동치를 반복할 필요는 없다.

남은 핵심 질문은 다음 하나다.

> **모델과 독립적으로 산정된 배치 메모리 예산을 적용했을 때, 네 실제 모델의 ADMIT/DENY 결과가 어떻게 달라지는가?**

이를 위해 필요한 신규 실험은 **네 모델 × 참조 기반 예산 프로파일의 AArch64 cFS admission 매트릭스**다. 기존 `U−1` 시험은 판정 경계 구현을 확인하는 회귀시험으로 유지하되, 실제 배치 유용성의 주 증거로 사용하지 않는다.

---

## 2. 현재 확보된 결과와 남은 증거

### 2.1 이미 확보된 결과

| 모델 | 무조건 계약 상한 `U` | 약 MiB | 기존 AArch64 결과 |
|---|---:|---:|---|
| ResNet | 618,856 B | 0.590 MiB | 계약·HAL·cFS 경로 확인 |
| DeepAE | 1,069,632 B | 1.020 MiB | 계약·HAL·cFS 경로 확인 |
| SmartCam | 18,222,796 B | 17.379 MiB | 계약·HAL·cFS 경로 확인 |
| WGAN | 135,666,432 B | 129.382 MiB | AArch64 종단 검증 완료 |

기존 `U` 및 `U−1` 셀은 다음을 확인했다.

- `budget ≥ U`이면 정책이 승인한다.
- `budget < U`이면 정책이 거절한다.
- 거절 시 추론이 시작되지 않는다.
- 승인된 실행의 관측 HAL peak는 적용된 계약 상한 이하에 있었다.

### 2.2 아직 부족한 결과

`U−1`은 모델 계약값으로부터 만든 경계값이다. 따라서 다음 주장에는 충분하지 않다.

> 실제 위성 소프트웨어의 배정 예산에 따라 어떤 모델은 수용되고 어떤 모델은 거절된다.

이를 보이려면 예산이 모델의 `U`를 보고 정해진 값이 아니라 다음 자료에서 **독립적으로 유도된 값**이어야 한다.

1. 대상 AArch64 플랫폼의 물리 RAM
2. 시스템 또는 소프트웨어 요구사항에서 정한 RAM 마진
3. OS·cFS·다른 애플리케이션의 사용량 또는 예약량
4. IREE 런타임·래퍼 등 계약 외 메모리 사용량

---

## 3. 예산 산정의 학술적·공학적 근거

### 3.1 메모리 예산은 프로젝트 요구사항으로 할당되는 값이다

NASA Software Engineering Handbook의 **SWE-109**는 컴퓨터 자원 요구사항에 프로세서·메모리 등의 최대 허용 사용량을 포함하고, 이를 전체 자원 용량의 백분율로 표현할 수 있으며 측정 조건도 함께 명시해야 한다고 설명한다.

- 문서: *SWE-109 — Software Requirements Specification*
- 관련 부분: Computer resource requirements
- URL: <https://swehb.nasa.gov/spaces/7150/pages/16449740/SWE-109%2B-%2BSoftware%2BRequirements%2BSpecification>

따라서 “위성 AI 앱의 보편적인 메모리 예산은 몇 MB”라는 단일 값은 존재하지 않는다. 예산은 대상 시스템의 자원과 임무 요구사항에 따라 할당돼야 한다.

### 3.2 RAM 마진은 생명주기 단계에 따라 적용할 수 있다

NASA Software Engineering Handbook의 **9.12 Resource Margins**는 GSFC 비행 소프트웨어 RAM 마진 예시를 다음과 같이 제시한다.

| 단계 | RAM 마진 | 산정 방법 |
|---|---:|---|
| SRR | 50% | Estimate |
| PDR | 50% | Analysis |
| CDR | 40% | Analysis/Measured |
| Ship/Flight | 30% | Measured |

동 문서는 일반적인 마진 계산식도 제시한다.

\[
M=\frac{R_{available}-R_{estimated}}{R_{available}}
\]

- 문서: *NASA Software Engineering Handbook 9.12 — Resource Margins*
- 관련 부분: GSFC Table 3.07-1, lines 66–75 및 margin 식
- URL: <https://swehb.nasa.gov/spaces/SWEHBVD/pages/102695803/9.12%2BResource%2BMargins>

해당 수치는 모든 위성에 강제되는 보편값이 아니라 NASA 센터의 자원 마진 지침이다. 본 연구에서는 **참조 가능한 배치 프로파일을 구성하는 근거**로 사용해야 한다.

### 3.3 계획값과 실측값을 마진에 대조해야 한다

NASA NPR 7150.2D §5.4.5는 계획 및 실제 컴퓨터 자원 사용량—메모리 용량과 partition allocation 포함—을 추적하고, 코딩·시험·검증 과정에서 실측값으로 갱신하여 마진과 비교하도록 설명한다.

- 문서: *NPR 7150.2D — NASA Software Engineering Requirements*
- 조항: §5.4.5, SWE-199 및 Note
- URL: <https://nodis3.gsfc.nasa.gov/displayDir.cfm?Internal_ID=N_PR_7150_002D_&page_name=Chapter5>

### 3.4 구성요소별 메모리 할당과 측정 전제를 명시해야 한다

NASA Software Engineering Handbook의 **SWE-111**은 각 소프트웨어 구성요소의 계획된 하드웨어 자원 사용량, 소프트웨어 아키텍처 전반의 메모리 할당, 메모리 마진 및 정상·최악 조건 등의 전제를 설계 문서에 포함하도록 설명한다.

- 문서: *SWE-111 — Software Design Description*
- 관련 부분: Planned utilization of computer hardware resources
- URL: <https://swehb.nasa.gov/spaces/7150/pages/16450560/SWE-111%2B-%2BSoftware%2BDesign%2BDescription>

---

## 4. 참조 기반 예산 산정식

### 4.1 시스템 수준 사용 가능 RAM

대상 플랫폼의 물리 RAM을 `R_physical`, 적용할 RAM 마진을 `M_phase`라고 하면:

\[
R_{usable}=R_{physical}(1-M_{phase})
\]

### 4.2 AI 실행에 배정할 수 있는 잔여 예산

\[
B_{AI}=R_{usable}
-R_{OS/cFS}
-R_{other\ apps}
-R_{reserved}
\]

여기서 각 항목은 다음과 같이 확보한다.

| 항목 | 근거 |
|---|---|
| `R_physical` | 대상 OBC/DPU 제조사 공식 데이터시트 |
| `M_phase` | NASA 9.12의 단계별 RAM 마진 또는 선정 임무의 공식 기준 |
| `R_OS/cFS` | 동일 AArch64 환경에서 AI 앱을 제외한 cFS 기준 실행의 실측 peak |
| `R_other apps` | 함께 구동하는 cFS 앱의 실측 또는 사전 할당값 |
| `R_reserved` | 임무가 명시한 추가 예약량; 없으면 0으로 두고 명시 |

### 4.3 계약과 동일한 회계 영역으로 변환

현재 계약은 OBC 전체 RSS가 아니라 IREE 모델 실행의 부분 메모리 영역을 대상으로 한다. 따라서 전체 AI 예산과 계약 상한을 바로 비교하면 안 된다.

\[
B_{contract}=B_{AI}-R_{noncontract\ AI}
\]

`R_noncontract AI`에는 계약에 포함되지 않은 IREE 고정 런타임, 플러그인·래퍼, 스레드 스택 및 입출력 복사 버퍼 등이 포함된다. 최종 판정은 다음과 같다.

\[
\operatorname{ADMIT}(model)=
\begin{cases}
\text{ADMIT}, & U_{model}\le B_{contract}\\
\text{DENY}, & U_{model}>B_{contract}
\end{cases}
\]

---

## 5. 추가 실험의 최소 구성

### 5.1 실험 목적

외부 자료와 동일 환경의 실측값으로 산정한 메모리 예산이 네 모델의 배치 가능성을 서로 다르게 판정하는지 확인한다.

### 5.2 고정할 항목

- 네 모델의 기존 계약 JSON과 `U`
- 계약 및 VMFB SHA-256
- AArch64 VMFB
- cFS AI Learner 실행 경로
- admission 정책 구현
- 순차 실행 및 계약 회계 전제

계약 생성, 모델 변환, 의미 동치 시험은 반복하지 않는다. 기존 증거를 참조한다.

### 5.3 변경할 독립변수

- 참조 기반 배치 예산 프로파일만 변경한다.
- 가능하면 PDR, CDR, Ship/Flight 등 두 개 이상의 마진 프로파일을 사용한다.
- 예산은 모델별 계약값을 확인하기 전에 산정식과 입력 자료를 고정한다.

### 5.4 모델별 실행

각 예산 프로파일에서 네 모델을 동일한 방식으로 실행하고 다음을 기록한다.

| 기록 필드 | 의미 |
|---|---|
| `budget_profile_id` | 사전 정의된 예산 프로파일 |
| `budget_source` | 데이터시트·NASA 지침·실측 파일 |
| `physical_ram_bytes` | 참조 플랫폼 RAM |
| `margin_fraction` | 적용 마진 |
| `non_model_reserved_bytes` | OS/cFS·다른 앱·고정 오버헤드 |
| `contract_budget_bytes` | 계약 회계 영역에 배정된 최종 예산 |
| `contract_bounded_bytes` | 기존 모델 계약 상한 `U` |
| `verdict` | `ADMIT` 또는 `DENY` |
| `runtime_created` | 런타임 생성 여부 |
| `inference_count` | 실제 추론 횟수 |
| `hal_peak_bytes` | 승인 셀의 HAL peak |
| `contract_sha256` | 기존 계약 불변 확인 |
| `artifact_sha256` | 기존 VMFB 불변 확인 |

### 5.5 통과 기준

| 상황 | 필수 결과 |
|---|---|
| `U ≤ B_contract` | `ADMIT`, 런타임 생성, 추론 1회 이상 |
| `U > B_contract` | `DENY`, 런타임 미생성, 추론 0회 |
| 승인된 실행 | `HAL peak ≤ 적용된 계약 상한 또는 승인 예산` |
| 모든 셀 | 계약·VMFB 해시 불변, cFS 비정상 종료 없음 |

---

## 6. 최종 결과표 형식

| 예산 프로파일 | `B_contract` | ResNet | DeepAE | SmartCam | WGAN |
|---|---:|---|---|---|---|
| Profile A | 측정 후 기입 | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY |
| Profile B | 측정 후 기입 | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY |
| Profile C | 측정 후 기입 | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY | ADMIT/DENY |

각 판정 옆에는 최소한 `U`, `B_contract`, 런타임 생성 여부 및 추론 횟수로 추적 가능한 근거를 남긴다.

---

## 7. `U−1` 시험의 위치

`U−1` 시험은 삭제하지 않는다. 다만 역할을 다음처럼 제한한다.

| 시험 | 역할 | 연구의 주 증거 여부 |
|---|---|---|
| `U−1`, `U`, `U+1` | 비교 연산·경계값·off-by-one 오류 검증 | 보조/회귀 증거 |
| 참조 기반 예산 | 실제 자원 할당에 따른 모델 배치 판단 | 주 증거 |

`U−1`을 실제 임무의 메모리 부족 사례로 해석해서는 안 된다.

---

## 8. 결과 해석 원칙

### 8.1 일부 모델이 거절되는 경우

다음과 같이 해석한다.

> 동일한 참조 기반 메모리 예산에서 모델별 계약 상한의 차이가 서로 다른 admission 결과로 이어졌으며, 거절된 모델은 런타임 생성과 추론 전에 차단됐다.

이는 모델의 일반적인 실행 불가능성을 의미하지 않는다. 해당 **예산 프로파일에서의 배치 불가**를 의미한다.

### 8.2 모든 모델이 승인되는 경우

거절을 만들기 위해 예산을 임의로 줄이지 않는다. 다음과 같이 보고한다.

> 선정한 참조 플랫폼과 자원 할당 조건에서는 네 모델이 모두 배정 예산 안에 있었다.

필요하면 별도의 power-of-two 예산 스윕을 민감도 분석으로 수행할 수 있지만, 이를 실제 임무 예산으로 표현하지 않는다.

### 8.3 모든 모델이 거절되는 경우

예산 회계 범위, 비계약 오버헤드 및 마진 적용 방식이 지나치게 보수적인지 먼저 점검한다. 정당한 산정 결과라면 그대로 보고하고 더 큰 플랫폼 또는 다른 할당 정책을 별도 프로파일로 추가한다.

---

## 9. 금지할 편의적 설정

- 각 모델의 `U`를 본 뒤 원하는 결과가 나오도록 예산을 조정하는 것
- 물리 RAM 전체를 AI 모델 계약 예산으로 간주하는 것
- OS/cFS·다른 앱·IREE 고정비용을 제외하지 않는 것
- 서로 다른 회계 범위의 RSS와 HAL peak를 직접 비교하는 것
- `U−1` 거절을 실제 임무 예산 부족의 증거로 표현하는 것
- 참조 기반 프로파일과 민감도 스윕을 하나의 실제 배치 사례처럼 합치는 것
- 모든 모델이 승인됐다는 이유만으로 실험 후 예산을 낮추는 것

---

## 10. 권장 실행 순서

1. 대상 AArch64 플랫폼과 공식 RAM 사양 선정
2. 적용할 NASA 생명주기 마진 선정
3. AArch64 cFS 기준 실행에서 비모델 메모리 사용량 측정
4. 계약 외 AI 런타임·래퍼 비용 분리
5. 모델 결과를 보기 전에 예산 프로파일과 산정식을 고정
6. 네 모델 × 예산 프로파일 실행
7. ADMIT/DENY, 런타임 생성 및 추론 횟수 확인
8. 승인 셀의 HAL peak 확인
9. 기존 `U−1` 결과와 참조 기반 결과를 별도 범주로 보관

---

## 11. 최종 판단

추가로 필요한 것은 새로운 계약 분석 기법이 아니라 **외부 근거와 시스템 실측으로 산정된 예산을 기존 계약 판정기에 입력하는 실험**이다.

이 실험이 완료되면 연구의 증거 구조는 다음과 같이 정리된다.

1. **계약 생성:** MLIR/IREE로 모델별 메모리 상한을 도출했다.
2. **상한 검증:** AArch64 실행에서 관측된 HAL peak가 계약 범위 안에 있었다.
3. **정책 정확성:** `U−1/U/U+1` 경계에서 승인·거절 로직이 정확히 작동했다.
4. **배치 유용성:** 참조 기반의 실제 예산 조건에서 네 모델의 수용 가능 여부를 실행 전에 판정했다.

현재 부족한 것은 네 번째 항목이며, **네 모델 × 참조 기반 예산 프로파일 admission 매트릭스**로 직접 보완할 수 있다.
