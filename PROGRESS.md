# PROGRESS — Contract-Guided MLIR Lowering for AI Deployment in NASA OnAIR/cFS

**기준 버전**: v0.3 (git tag `v0.3`, 2026-09-07)
**문서 역할**: 현재까지의 진행 상황을 한 장으로 요약하는 정본. 세부 수치·판정 근거는 `docs/EVIDENCE_v0.*.md`, 실험 등록은 `EXPERIMENT_LOG.md`, 변경 이력은 `CHANGELOG.md`가 정본이다.

---

## 요약

- **TOPIC** — NASA OnAIR의 Learner 플러그인을 MLIR/IREE로 AOT 컴파일하고, 배치 계약(timing/memory)으로 lowering을 선택·검증하는 연구의 실험적 타당성 확인.
- **Problem** — 초기 주가설(H1: AOT가 Python보다 빠르고 예측 가능)은 기각됐고, 대체 주가설(H2: 계약 기반 lowering 선택)의 가장 강한 근거는 측정 결함으로 판명되어 철회됐다.
- **Solution** — 살아남은 결과는 **정적 메모리 상한이 런타임 피크와 정확히 일치한다(50/50)** 는 E6이며, 연구의 무게중심을 "lowering 선택"에서 **"정적으로 보장된 배치 계약(C1) + 실행 전 판정(H3)"** 으로 옮기는 것이 데이터에 부합한다. 시간 축은 플랫폼 제약으로 아직 미검증이다.

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
| **H1** AOT → tail·variability 개선 | **기각** | 최적 compiled가 B0(NumPy/BLAS) 대비 2.2–4.1× 느림(정정 후). 소형 모델에서 분산도 더 나쁨 | Native-cFS 변형·PASS 플랫폼에서 잔여 가능성만 |
| **H2** 계약 기반 lowering 선택 | **부분 지지** | 타깃 CPU 미지정 시 크기에 비례해 최대 2.6× 손해; 런타임 실행 모델은 RSS +2.5 MB. **다목적 상충은 미관측** | 상충이 존재하는 워크로드 발견 여부가 생사 결정 |
| **H3** 실행 전 feasibility 판정 | **메모리 축 전제 충족** | 정적 상한 sound & tight | 시간 축 상한(PASS 플랫폼), selector 구현 |
| C1 계약 | 메모리: **static**, 시간: null | `bound_method: static_from_stream_schedule` | 시간 축 |
| 기능 동등성 | 충족 | max_abs_diff ≤ 4.05e-6 (f32), 전 설정 | 양자화 시 재검증 |

---

## 4. 핵심 수치 (정정 반영, 가중치 베이킹 기준)

| 항목 | 값 |
|---|---|
| 플랫폼 등급 | FUNCTIONAL_ONLY (1 vCPU, ratio_p99 1.67) — 절대 지연값 인용 불가 |
| compiled / B0, h=256 / 4096 / 16384 | 4.14× / 2.73× / 2.22× |
| 정적 프로그램 메모리 (h=16384) | 65,580 B = 중간 65,536 + I/O 44 |
| 런타임 피크 (HAL) | 65,580 B — **상한과 동일** |
| 정적 상한 검증 | 50/50 (10설정 × 3크기 × {입력, 베이킹}) sound, tightness 1.000 |
| 런타임 컨텍스트 (측정) | ≈ 971 KB (local-sync), ≈ 3 MB (local-task) — 컴파일러 보장 밖 |
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
3. **H1 기각은 서술을 바꿔 유지한다.** "느리다"가 아니라 "2.2×의 대가로 정적 메모리 보장과 Python 런타임 제거를 얻는다"는 교환. 이 교환의 실재는 Native-cFS 변형에서만 검증 가능.
4. **B0는 강한 베이스라인으로 유지한다.** 약화 금지.

---

## 7. 잔여 작업

**A. 현 플랫폼 가능 (우선순위순)**
- A2 상충 워크로드 탐색(1D-CNN/Conv2D, 타일·fusion) — **H2 생사 결정**
- A1 Native-cFS 변형(정적 링크, SB 구독→추론→발행) — H1 잔여, 런타임 컨텍스트 감소 검증
- A4 정적 상한을 동적 형상·다중 dispatch 모델로 확장 — E6 일반성
- A3 B2 = TFLite Micro 베이스라인 — MLIR 필연성

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
