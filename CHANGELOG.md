# CHANGELOG

형식: [버전] 날짜 — 변경. 가설 판정 변경은 반드시 "판정:" 접두어, 이전 주장 철회는 "정정:" 접두어로 기록.

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
