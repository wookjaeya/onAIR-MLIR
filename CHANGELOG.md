# CHANGELOG

형식: [버전] 날짜 — 변경. 가설 판정 변경은 반드시 "판정:" 접두어, 이전 주장 철회는 "정정:" 접두어로 기록.

## [v0.5] 2026-09-08
- 외부 검토(`REPORT_v0_4_REVIEW.md`) 반영.
- 정정(결함 D3): 상한 계산법 "slice 합" → "post-layout transient alloca 크기". E9 정렬 간극·수명 재사용 사례에서 slice 합이 과소(48<128, 84<128)임을 실증. MLP 60/60 재검증.
- E9: 할당 구조 4사례 (A 정렬, B 수명 재사용, C 대형 체인, D fusion) 4/4 sound·tight.
- 상수 독립 검증: `iree-dump-module` rodata 세그먼트 부분합으로 30/30 확인 (IR 값 재사용 아님).
- 판정 의미: ACCEPT/REJECT/UNBOUNDED → ADMIT / NOT_ADMITTED(보증 불가≠불가능) / UNKNOWN_BOUND(분석 미확보≠상한 부재). pessimistic → conservative_denial.
- E10: 경계값 U−1/U/U+1 18/18 정확.
- E7b: 258 판정, misprediction 0, config-invariant.
- 판정: H3 시험 조건 내 성립, 근거 강화. 중심 문장을 "OnAIR IREE 아티팩트의 부분 메모리 계약·판정기 구현·검증"으로 한정. 런타임 컨텍스트 → 미분류 잔차. TFLM 서술 미검증으로 통일.
- 문서: `docs/EVIDENCE_v0.5_E9.md`.

## [v0.4] 2026-09-07
- 결정: 계약 메모리 경계 = 옵션 (b) per-call 정적 버퍼 + 모듈 상주 상수. 스키마에 `memory_boundary`, `bounded_bytes`, `bound_method: NONE` 추가.
- E7: 메모리 전용 admission checker (`harness/admission_check.py`). 240 판정, misprediction 0, 판정 config-invariant, observed==bounded 240/240.
- E8: 동적 배치 차원 모델 → UNBOUNDED 거절 확인 (정적 상한의 적용 경계).
- 판정: H3 → "메모리 축, 시험 조건 내 성립; 시간 축 미검증".
- 판정: H2 → 논문 주장에서 제외 권고 (E7 config-invariance).
- 문서: `docs/EVIDENCE_v0.4_E7.md`, `REPORT_v0.4.md`(총괄).

## [v0.3.1] 2026-09-07
- 외부 검토(`PROGRESS_v0_3_REVIEW.md`) 반영.
- E6c: 베이킹 모델 정적 상한을 IR 파싱으로 재검증, 30/30. 총 60/60 (v0.3의 "50/50"은 오기).
- 정정: 런타임 컨텍스트 ≈971 KB → ≈244 KB (베이킹 상수 720,896 B 분리, 결함 D2).
- 정정: 파서가 initializer 상수 임포트를 입력으로 오귀속 (D2) → 엔트리 함수 스코프 + 상수 별도 집계.
- 판정: H1 "기각" → "현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류".
- 판정: H2 "부분 지지" → "설정별 비용 차이 관측; 계약 기반 선택의 이점 미입증".
- 판정: H3 "메모리 축 전제 충족" → "정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요".
- 판정: E6 "sound & tight" → "동일 할당 계획에 대한 예측·관측 일치 (가정 명시)".
- 판정: "2.2× 대가 교환" → Native-cFS 후속 가설로 강등.
- 계약 예시: 스코프 노트·가정·상수/런타임 분리 귀속·정오표 추가.
- 잔여 작업 우선순위 변경: 상충 워크로드 탐색(A2)을 H2 유지 시에만; 기본 순서는 E6 범위 정리 → Native-cFS → 메모리 전용 admission checker → 일반성/TFLM.

## [v0.3] 2026-09-07
- E6 정적 메모리 상한 추출 (`harness/static_mem_bound.py`, `static_bound_sweep.py`). 30/30 sound, tightness 1.0, lowering 설정 불변.
- 정정: E1–E5의 컴파일 경로가 매 호출 가중치 전체를 임포트(결함 D1). E6b로 재측정.
- 정정: 컴파일 vs B0 격차 6.3–9.5× → 2.2–4.1×.
- 정정: E5 §4 "순위 붕괴 ρ=+0.18" 철회 (ρ=+0.81).
- 정정: E5 §3 "Pareto front 5개" 철회 (상충 미관측).
- 판정: H2 "확립" → "부분 지지".
- 판정: H3 메모리 축 전제 충족 (정적 상한).
- 판정: C1 `peak_memory` → `static_from_stream_schedule`.
- 계약 예시 갱신: 정적 프로그램 65,580 B + 런타임 컨텍스트 ~971 KB(측정) 분리.
- 문서: `docs/EVIDENCE_v0.3_E6.md`.

## [v0.2] 2026-09-07
- E5 lowering 특성화 추가 (`harness/characterize.py`, 10 설정 × h∈{256,4096,16384}).
- 판정: H2 "강화" → "확립". 근거를 tail 지표(noise 안쪽)에서 결정론적 지표(binary 2.25×, RSS 2.75×, Pareto 5, ρ=+0.18)로 교체.
- 판정: 방향판단 §7 "peak memory 우위" 반증 (B0 40 KB vs compiled 최소 1216 KB).
- 계약 공란 채움 (`contracts/contract.filled.example.json`): profile, peak_memory(measured), bound(measured_max).
- 문서: `docs/EVIDENCE_v0.2_E5.md`.
- 이력 관리 도입: git, `EXPERIMENT_LOG.md`, 본 파일.

## [v0.1] 2026-09-07
- E0–E4 수행. 환경 구축, OnAIR 통합, 크기 스윕, 마샬링 floor, 설정 효과.
- 판정: H1 주가설 → 부분 기각. H2 강화. H3 미검증.
- 문서: `docs/STATUS.md`, `docs/MVP_RESULT.md`, `docs/EVIDENCE_v0.1.md`.

## [v0.0] 2026-09-07
- 연구노트 v0.1 (외부 문서) 검토. Critical 3 / Major 10 / Minor 10.
