# EVIDENCE v0.4 — E7 메모리 전용 admission checker, E8 정적 상한의 적용 경계

선행: `EVIDENCE_v0.3_E6.md`(E6·E6b·E6c·정오표), 외부 검토 `PROGRESS_v0_3_REVIEW.md`
결정 사항: 계약이 책임지는 메모리 경계 = **옵션 (b)** per-call 정적 버퍼 + 모듈 상주 상수.

---

## 요약

- **TOPIC** — E6의 정적 메모리 계산값을 실제 배치 결정(허용/거절/판정불가)으로 바꾸고, 그 결정을 런타임에서 검증(E7). 정적 상한이 존재하지 않는 경우를 구성해 checker가 거절하는지 확인(E8).
- **Problem** — 검토 §9는 "메모리 계산을 추출했다는 사실을 넘어, 그것을 유효한 배치 계약과 실행 전 판정으로 연결하는 기여가 실제로 성립하는지" 확인하라고 요구했다.
- **Solution** — 240건의 판정에서 optimistic misprediction 0건, 판정은 lowering 설정과 무관하게 동일했으며, 동적 형상 모델은 UNBOUNDED로 정확히 거절됐다. **H3의 메모리 축은 시험 조건 내에서 성립한다.**

---

## 0. 경계 결정과 근거

| 구성요소 | 포함 | 근거 |
|---|:---:|---|
| per-call 중간 버퍼·I/O | ✅ 보장 | `stream.resource.pack` / `alloca` / `tensor.import` 정수 상수 (E6) |
| 모듈 상주 상수(베이킹 가중치) | ✅ 보장 | `stream.resource.constants {%c}` 정수 상수 (E6c) |
| IREE 런타임 컨텍스트 (~244 KB) | ✗ 귀속만 | 런타임 구성이 결정, 컴파일러 분석 밖 |
| 스레드 스택, cFS 파이프·버퍼 | ✗ 범위 밖 | Native-cFS 변형에서 별도 처리 |

옵션 (b)의 부수 효과: **bounded_bytes는 가중치를 입력으로 넘기든 상수로 베이킹하든 동일**하다(h=16384: 786,476 B). 배치 방식은 per-call과 모듈 상주 사이의 **분할만** 바꾼다. 이는 경계가 구현 선택에 안정적이라는 뜻이다.

---

## 1. E7 — 메모리 전용 admission checker

### 1.1 설계
입력: 아티팩트의 할당 스케줄 분석 + 예산(bounded 영역). 출력:
- `ACCEPT` — bounded ≤ 예산, 모든 크기 정적
- `REJECT` — bounded > 예산
- `UNBOUNDED` — 크기 중 하나라도 컴파일 시 상수가 아님 → 예산과 무관하게 거절

시간 계약, selector, Pareto 로직 **없음**. 검토 §4가 확인한 대로 H3는 H2와 독립이므로, 가장 작은 실험으로 "계산 → 결정 → 검증" 고리를 닫는다.

검증: 모든 ACCEPT/REJECT에 대해 아티팩트를 실행하고 HAL 피크 + 상수를 관측값으로 삼아 `observed ≤ 예산`을 확인.
- optimistic misprediction = ACCEPT인데 관측이 예산 초과 (**위험한 오류**)
- pessimistic misprediction = REJECT인데 관측이 예산 이내

### 1.2 조건
10 설정 × 3 크기 × {입력, 베이킹} × 예산 {16 KB, 64 KB, 256 KB, 1 MB} = **240 판정**.

### 1.3 결과

| 변형 | h | 16K | 64K | 256K | 1M | bounded |
|---|---:|:---:|:---:|:---:|:---:|---:|
| inputs | 256 | ACC | ACC | ACC | ACC | 12,332 |
| inputs | 4096 | REJ | REJ | ACC | ACC | 196,652 |
| inputs | 16384 | REJ | REJ | REJ | ACC | 786,476 |
| baked | 256 | ACC | ACC | ACC | ACC | 12,332 |
| baked | 4096 | REJ | REJ | ACC | ACC | 196,652 |
| baked | 16384 | REJ | REJ | REJ | ACC | 786,476 |

- ACCEPT 140 / REJECT 100 / UNBOUNDED 0
- **optimistic misprediction 0 / pessimistic 0**
- `observed_bytes == bounded_bytes` **240/240**
- **판정은 10개 lowering 설정 전부에서 동일** (config-invariant) — 메모리 판정은 lowering 선택과 직교한다는 E6 §1.2 결론의 결정 수준 재확인

### 1.4 한계 (반드시 함께 인용)
- 관측값과 계산값이 **같은 할당 계획**에서 나오므로, 0 misprediction은 "구현이 계획대로 동작"의 증거이지 계획 자체의 보편성 증명이 아니다(검토 §5).
- 단일 in-flight 호출, local-sync, 정적 형상, 엔트리 함수 한정.
- 예산 사다리가 bounded 값 사이에 놓이도록 설계되어 ACCEPT/REJECT 양쪽이 모두 발생했지만, 경계값 정확히 근처(bounded = 예산 ± 수 바이트)는 시험하지 않았다.

---

## 2. E8 — 정적 상한이 없는 경우 (동적 배치 차원)

`tensor<?x9xf32>` 입력, `tensor.dim`으로 배치 크기를 읽는 MLP.

```
all_sizes_static : false
unresolved       : ['%1', '%6', '%5']     (SSA 값, 정수 상수 아님)
transient_slices : []
bound_method     : NONE
verdict          : UNBOUNDED
```

파서는 크기가 상수가 아님을 감지했고 checker는 예산과 무관하게 거절했다. "모른다"가 "된다"로 새지 않는다. 이것이 정적 상한의 **적용 경계**다: 형상이 정적일 때만 계약이 생성되며, 동적 형상은 후속 과제(형상 상한 주석 등)로 남긴다.

---

## 3. 가설 판정 (v0.4)

| 가설 | v0.3.1 | **v0.4** | 근거 |
|---|---|---|---|
| **H3** (실행 전 feasibility 판정) | 정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요 | **메모리 축, 시험 조건 내 성립**: 경계 확정(b), 판정기 구현, 240/240 검증, 비적용 경계(E8) 확인. 시간 축은 여전히 미검증 | E7, E8 |
| C1 (계약) | per-call static | **bounded = per-call + 상수**, `bound_method: NONE` 경로 포함 | 스키마 v0.4 |
| H1 | 성능 우위 미관측 | 변화 없음 | — |
| H2 | 선택 이점 미입증 | 변화 없음. E7의 config-invariance는 오히려 "메모리 판정에는 lowering 선택이 필요 없다"는 반대 증거 | E7 |

---

## 4. 연구 서술에 대한 함의 (본인 분석·판단)

1. **연구의 중심 주장은 이제 명확히 C1+H3다.** "컴파일러 할당 스케줄에서 도출한 정적 메모리 계약으로 cFS 배치 전 admission을 수행하며, 시험한 60개 아티팩트 240개 판정에서 optimistic misprediction이 없었고, 정적 상한이 없는 모델은 거절된다." 이것은 재현 가능하고 결정론적이다.
2. **H2는 논문 주장에서 제외한다.** E7의 config-invariance는 메모리 축에서 lowering 선택이 판정에 영향을 주지 않음을 보였다. 시간 축에서만 선택이 의미를 가질 수 있는데, 시간 축은 플랫폼 제약으로 미검증이다.
3. **남은 가장 큰 구멍은 두 개다.** (a) 시험 조건이 2-dispatch MLP 하나라는 일반성(A4), (b) Python 플러그인 경로에서 측정한 것이라 cFS 앱 배치의 실제 메모리 경계(런타임 컨텍스트·파이프)가 미확정(A1).
4. **MLIR 필연성은 여전히 미입증.** TFLM의 정적 아레나도 컴파일 시 크기를 준다. 차이는 "할당 스케줄 IR이 노출되어 분석·검증 가능"이라는 점이며, 이를 B2 비교(A3)로 보여야 한다.

---

## 5. 재현

```bash
python3 harness/admission_check.py --mlir <model.mlir> --shape 9 16384 2 \
        --extra="--iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu" --baked --budget 1048576
python3 harness/admission_sweep.py        # E7 (240 decisions) + E8
```
산출물: `results_admission.json`
