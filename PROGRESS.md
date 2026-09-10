# PROGRESS — Contract-Guided MLIR Lowering for AI Deployment in NASA OnAIR/cFS

**기준 버전**: v0.3.1 — 이 문서는 그 시점의 한 장 요약이며, **현재 상태의 정본이 아니다.**

> **v0.40에서 확정**: 이 문서는 **v0.3.1 시점 스냅샷으로 동결**되며 작업 규율 6의 "매 버전 갱신"
> 대상에서 제외된다. 실제로 v0.4 이후 갱신된 적이 없고, 정본은 아래 순서다.
> **현재 버전은 v0.38.1이다.** 최신 상태는 `CLAUDE.md`(프로젝트 컨텍스트·우선순위) →
> `EXPERIMENT_LOG.md`(실험 레지스트리·결함 원장) → `CHANGELOG.md` 순으로 읽는다.
> v0.4 총괄은 `REPORT_v0.4.md`, 최신 판정은 `docs/EVIDENCE_v0.34_E31.md`(P2: SmartCam 원본 의미 보존 PASS)·`docs/EVIDENCE_v0.33_E30.md`(P1: SmartCam 반입 타당성, TRANSFORM_REQUIRED → GO)·`docs/EVIDENCE_v0.32_E29b.md`(조건부 검증 논리 수정, D54)·`docs/EVIDENCE_v0.31_E29.md`(조건부 계약: try_map 분기
> 결정 요인 = 모듈 이미지의 64바이트 정렬, 64/64셀 위반 0, 제어 시 map 피크 = `per_call` 정확히)와
> `docs/EVIDENCE_v0.25_E26.md`(계약 경계의 유용성: Q1·Q3 PASS)이고 다음 계획은 `docs/plans/E26_boundary_utility.md`·
> `docs/plans/E27_mlir_contribution.md`다.
> 아래 본문은 v0.3.1 시점 그대로 보존한다(작업 규율 5: 고쳐쓰지 않는다).
**문서 역할**: 현재까지의 진행 상황을 한 장으로 요약하는 정본. 세부 수치·판정 근거는 `docs/EVIDENCE_v0.*.md`, 실험 등록은 `EXPERIMENT_LOG.md`, 변경 이력은 `CHANGELOG.md`가 정본이다.

---

## 요약

- **TOPIC** — NASA OnAIR의 Learner 플러그인을 MLIR/IREE로 AOT 컴파일하고, 배치 계약(timing/memory)으로 lowering을 선택·검증하는 연구의 실험적 타당성 확인.
- **Problem** — 초기 주가설(H1: AOT가 Python보다 빠르고 예측 가능)은 기각됐고, 대체 주가설(H2: 계약 기반 lowering 선택)의 가장 강한 근거는 측정 결함으로 판명되어 철회됐다.
- **Solution** — 살아남은 결과는 **정적 per-call 메모리 계산값이 런타임 HAL 피크와 일치한다(60/60, 시험 조건 내)** 는 E6/E6c이며, 연구의 무게중심을 "lowering 선택"에서 **"정적 per-call 버퍼 계약(C1) + 실행 전 판정(H3)"** 으로 옮기는 것이 데이터에 부합한다. 시간 축은 플랫폼 제약으로 미검증이며, 성능 우위와 계약 기반 선택의 이점은 확인되지 않았다.

---

## 1. 연구 맥락 (한 단락)

OnAIR는 NASA GSFC의 Python 기반 온보드 AI 연구 플랫폼으로, cFS와 SBN 어댑터로 결합되며 ISS STP-H9(SCENIC)에서 100 MHz FPGA 소프트코어 위에서 비행 실증됐다. 본 연구는 OnAIR core를 바꾸지 않고 Learner 플러그인의 추론을 MLIR/IREE 아티팩트로 대체하고, 그 아티팩트에 시간·메모리 계약을 부여해 배치 전 검사를 가능하게 하려는 시도다. 연구노트 v0.1(외부 문서)에 대한 엄격 검토(Critical 3, Major 10, Minor 10) 후 실험에 착수했다.

---

## 2. 진행 타임라인

| 단계 | 내용 | 산출물 | 상태 |
|---|---|---|---|
| 검토 | 연구노트 v0.1 엄격 검토 | (대화 기록) | 완료 |
| E0 | cFS 빌드·기동(LC 7.0.1, SBN 포함), OnAIR CSV/Kalman 완주, IREE 컴파일·실행, 플랫폼 게이트 | `scripts/`, `docs/STATUS.md` | 완료 |
| E0-int | `CompiledLearner`/`PythonLearner`를 OnAIR `AIPlugin`으로 통합, core 변경 0줄 | `plugins/` | 완료 |
| E1–E3 | 모델 크기 스윕, 분산, 마샬링 floor | `harness/sweep.py` | 완료 (D1 영향) |
| E4 | lowering 설정 4종 효과 | `results_findings.json` | 완료 (D1 영향) |
| E5 | lowering 특성화 10종×3크기, 메모리 포함 | `harness/characterize.py` | 완료 (D1 영향) |
| E6 | 정적 메모리 상한 추출·검증 | `harness/static_mem_bound.py` | 완료 |
| E6b | **정정**: 가중치 베이킹 재특성화 | `harness/characterize_baked.py` | 완료 |
| 이력 | git + 실험 레지스트리 + 철회 원장 + 결함 원장 | `EXPERIMENT_LOG.md`, `CHANGELOG.md` | 운영 중 |

---

## 3. 현재 가설 판정 (v0.3)

| 가설 | 판정 | 핵심 근거 | 남은 검증 |
|---|---|---|---|
| **H1** AOT → tail·variability 개선 | **현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류** | IREE 플러그인의 L1 median이 NumPy/BLAS 플러그인 대비 2.2–4.1× 느림; p99도 열세; p99/median 차이는 noise 내 | Native-cFS 변형·PASS 플랫폼 |
| **H2** 계약 기반 lowering 선택 | **설정별 비용 차이 관측; 계약 기반 선택의 이점 미입증** | 타깃 CPU 미지정 시 최대 2.6× 손해; `local-task` RSS +2.5 MB. 다목적 상충 미관측 → 고정 설정으로 충분할 가능성 | 예산·모델 조건에 따라 적합 설정이 바뀌고 선택이 고정 설정보다 우수함을 보여야 함 |
| **H3** 실행 전 feasibility 판정 | **정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요** | E6/E6c 60/60 일치 (H2와 독립적으로 연구 가능) | 계약 경계 확정, admission checker, 시간 축 |
| C1 계약 | per-call 메모리: **static**(가정 명시), 시간: null | `bound_method: static_from_stream_schedule`; 상수·런타임 컨텍스트는 귀속만 | 시간 축, 전체 배치 메모리 경계 |
| 기능 동등성 | **시험 범위 내 수치 일치** | max_abs_diff ≤ 4.05e-6 (입력) / 3.58e-7 (베이킹) | 허용 오차 기준·argmax 일치·입력 범위 정의 |

---

## 4. 핵심 수치 (정정 반영, 가중치 베이킹 기준)

| 항목 | 값 |
|---|---|
| 플랫폼 등급 | FUNCTIONAL_ONLY (1 vCPU, ratio_p99 1.67) — 절대 지연값 인용 불가 |
| compiled / B0 (L1 커널 **median**), h=256 / 4096 / 16384 | 4.14× / 2.73× / 2.22× |
| 정적 per-call 버퍼 (h=16384) | 65,580 B = 중간 65,536 + I/O 44 |
| 런타임 피크 (HAL) | 65,580 B — 계산값과 일치 |
| 정적 계산·HAL 일치 검증 | **60/60** = 입력 30/30 (E6) + 베이킹 30/30 (E6c); 가정: 정적 형상·단일 호출·local-sync·엔트리 함수 |
| 모듈 상주 상수 (베이킹 가중치) | 720,896 B — 로드 시 매핑, per-call 아님 |
| 런타임 컨텍스트 (측정, 잔차) | ≈ 244 KB (local-sync), local-task는 +2.5 MB — 컴파일러 보장 밖 (v0.3의 971 KB는 상수 포함 오류) |
| 타깃 CPU 미지정 손해 | h=256 1.1× → h=4096 1.8× → h=16384 2.6× |
| host-tuned 군집 내 편차 | 1.00–1.04 (noise 안쪽, 판별 불가) |
| 순위 안정성 ρ (256 vs 16384) | +0.81 (정정 전 +0.18은 철회) |

---

## 5. 철회·정정 원장 (요약)

| 원 주장 | 정정 | 사유 |
|---|---|---|
| compiled가 B0 대비 6.3–9.5× 느림 | 2.2–4.1× | 결함 D1 |
| 모델 크기별 순위 붕괴 ρ=+0.18 | ρ=+0.81, 철회 | 결함 D1 |
| Pareto front 5개 | 상충 미관측, 철회 | 결함 D1 |
| 메모리 축에서 B0 대비 5.2–30.4× 열세 | 프로그램 정적 65.6 KB(보장); 배수는 런타임 컨텍스트 귀속 | E6 분해 |
| median과 tail 랭킹 상이 (방향판단 §3.3) | 차이 1.15× < noise, 지지 불가 | v0.1 재분석 |

**결함 D1**: E1–E5 하네스가 가중치를 호출 인자로 넘겨 매 호출 전체 가중치(≤720 KB)를 디바이스로 임포트. E6의 HAL 통계 `bytes_per_call`에서 발견. 이후 모든 하네스는 `bytes_per_call` 기록 의무.

---

## 6. 연구 방향에 대한 현재 판단 (본인 분석·판단)

1. **H2의 신규성 위험이 현실화됐다.** 정정 후 남은 결론은 "타깃 CPU를 지정하라"는 상식이다. 상충 워크로드(CNN 타일링, 양자화)가 없으면 H2는 논문이 되지 않는다.
2. **가장 강한 다리는 E6이다.** 결정론적·재현 가능·컴파일러 고유. 축을 **C1+H3**로 옮기면 제목은 "Contract-Guided Lowering"에서 **"Statically-Bounded AI Deployment Contracts for cFS"** 계열로 바뀐다.
3. **"2.2× 대가로 정적 보장 + Python 제거" 교환은 후속 가설이다.** 한 경로의 측정 비용과 미구현 경로의 이점을 결합해 서술하지 않는다. Native-cFS 변형에서 비용·메모리를 다시 측정한 뒤에만 교환 관계를 말할 수 있다.
5. **H3는 H2와 독립이다.** 최적 설정 선택(H2)과 주어진 아티팩트의 예산 내 실행 판정(H3)은 별개 문제이므로, H2가 실패해도 H3 연구는 성립한다. 따라서 상충 워크로드 탐색은 H2를 주가설로 유지할 때만 최우선이다.
4. **B0는 강한 베이스라인으로 유지한다.** 약화 금지.

---

## 7. 잔여 작업

**A. 현 플랫폼 가능 (우선순위순, v0.3.1에서 재배열)**
- A0 **E6 증거 범위 정리** — 계약 경계(포함/제외 메모리 구성요소), 상한 가정, 검증의 독립성 명문화 (대부분 v0.3.1 정오표로 완료; 계약 경계 결정 남음)
- A1 Native-cFS 변형(정적 링크, SB 구독→추론→발행) — Python 제거·런타임 비용 감소의 실재 확인
- A5 **메모리 계약 전용 최소 admission checker** — 예산 vs 계약으로 허용/거절, 허용 아티팩트가 경계 내 실행되는지 확인 (시간 계약·selector 불필요)
- A4 정적 상한을 다중 dispatch·버퍼 재사용 모델로 확장 — E6 일반성 (동적 형상은 후순위)
- A3 B2 = TFLite Micro 베이스라인 — 대안 대비
- A2 상충 워크로드 탐색 — **H2를 주가설로 유지할 때만**

**B. PASS 플랫폼 필요**
- B1 시간 축 계약 최초 기록
- B2 deadline/부하 스윕, ΔR_cFS — H2 본검증
- B3 selector + optimistic misprediction 평가 — H3

**C. 문서**
- C1 연구노트 v0.2 개정(검토 Critical 3건 + v0.3 판정 + D1 명시)
- C2 참고문헌 목록

---

## 8. 저장소 구성

```
onair-mlir-bench/
├── PROGRESS.md                 ← 본 문서
├── EXPERIMENT_LOG.md           실험 레지스트리 · 판정 이력 · 철회 원장 · 결함 원장
├── CHANGELOG.md                버전별 변경 (판정:/정정: 접두어)
├── scripts/                    검증된 환경 구축 (cFS, OnAIR, IREE, mqueue 수정)
├── plugins/
│   ├── compiled_learner/       OnAIR AIPlugin, IREE 아티팩트 + 계약 로드
│   └── python_learner/         B0, 동일 인터페이스·동일 측정 경계
├── harness/
│   ├── platform_check.py       타이밍 적격성 게이트 (PASS / FUNCTIONAL_ONLY)
│   ├── sweep.py                E1–E3 (D1 영향)
│   ├── characterize.py         E5 (D1 영향)
│   ├── characterize_baked.py   E6b (정정)
│   ├── static_mem_bound.py     E6 정적 상한 추출 + HAL 검증
│   └── static_bound_sweep.py   E6 설정×크기 스윕
├── contracts/
│   ├── contract.schema.json    boundary · bound_method 필수
│   └── contract.filled.example.json  정적 메모리 채움, 시간 null
├── results_*.json              원자료
└── docs/
    ├── STATUS.md               환경 구축 보고
    ├── MVP_RESULT.md           최초 go/no-go
    ├── EVIDENCE_v0.1.md        E0–E4 판정
    ├── EVIDENCE_v0.2_E5.md     E5 판정 (일부 v0.3에서 철회)
    └── EVIDENCE_v0.3_E6.md     E6 · E6b · 정정 원장
```

git: 커밋 1건 = 실험 1건, 태그 `v0.2`, `v0.3`. 정정은 삭제 없이 덧붙임.
