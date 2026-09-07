# EXPERIMENT LOG — onair-mlir-bench

규칙
- 실험 ID는 불변이다. 재실행은 새 ID(예: E5b)를 받는다.
- 각 항목은 `platform_grade`를 반드시 기록한다. FUNCTIONAL_ONLY 결과는 방향성 관측이며 논문 증거가 아니다.
- 판정 변경은 여기서 하지 않는다. 판정은 `docs/EVIDENCE_v*.md`에서 버전으로 관리하고, 여기에는 어느 문서가 판정했는지만 링크한다.
- 모든 항목은 git 커밋 해시로 산출물에 연결된다 (`git log --oneline`).

| ID | 날짜 | 실험 | 플랫폼 grade | 산출물 | 결과 요약 | 판정 문서 | 커밋 |
|---|---|---|---|---|---|---|---|
| E0-env | 2026-09-07 | cFS/OnAIR/IREE 빌드·기동 | n/a | `scripts/*.sh`, `docs/STATUS.md` | cFS OPERATIONAL(LC 7.0.1, SBN 포함), OnAIR CSV/Kalman 완주, IREE 컴파일·실행 | STATUS | 278e448 |
| E0-platform | 2026-09-07 | 타이밍 적격성 게이트 | **FUNCTIONAL_ONLY** | `harness/platform_check.py`, `results_platform.json` | ratio_p99 1.67, ratio_max 2.26 | STATUS §2 | fd94420 |
| E0-integration | 2026-09-07 | OnAIR 플러그인 통합 | n/a | `plugins/compiled_learner`, `plugins/python_learner` | OnAIR core 변경 0줄, 로더 경유 완주. 함정: ServiceManager 선초기화 | EVIDENCE v0.1 §1 | ff926f7 |
| E1 | 2026-09-07 | 모델 크기 스윕 (latency) | FUNCTIONAL_ONLY | `harness/sweep.py`, `results_sweep*.json` | compiled/numpy 6.3–9.5×, 교차점 없음 | EVIDENCE v0.1 §2 | 3c82702 |
| E2 | 2026-09-07 | 모델 크기 스윕 (dispersion) | FUNCTIONAL_ONLY | 동상 | 소형에서 compiled p99/med 더 나쁨; 대형 역전은 noise 안 | EVIDENCE v0.1 §3 | 3c82702 |
| E3 | 2026-09-07 | 마샬링 floor | FUNCTIONAL_ONLY | `results_findings.json` | identity-call 4.70 µs → 격차 원인은 커널 품질 | EVIDENCE v0.1 §4 | 3c82702 |
| E4 | 2026-09-07 | lowering 설정 효과 (4종, h=16384) | FUNCTIONAL_ONLY | `results_findings.json` | median 1.87× 편차, avx2 < default | EVIDENCE v0.1 §5 | 3c82702 |
| E5 | 2026-09-07 | lowering 특성화 (10종 × 3크기, 메모리 포함) | FUNCTIONAL_ONLY (binary·RSS는 결정론적) | `harness/characterize.py`, `results_characterization_*.json` | Pareto 5개; 크기 간 ρ=+0.18; **메모리 축 반증** (B0 40 KB vs 1216 KB) | EVIDENCE v0.2 | 833edb6 |
| E6 | 2026-09-07 | 정적 메모리 상한 산출 (P2b) | 결정론적 | `harness/static_mem_bound.py`, `harness/static_bound_sweep.py`, `results_static_bound.json` | 정적 상한 = HAL 피크, 30/30 sound, tightness 1.0; 설정 불변 | EVIDENCE v0.3 §1 | 45213d6 |
| **E6c** | 2026-09-07 | 베이킹 모델 정적 상한 IR 파싱 (검토 §5 분모 해소) | 결정론적 | `results_static_bound_baked.json` | 30/30 sound·tight; 상수 720,896 B 모듈 상주로 분리 귀속 | EVIDENCE v0.3 §7 | (v0.3.1) |
| **E6b** | 2026-09-07 | **정정**: 가중치 베이킹 재특성화 | FUNCTIONAL_ONLY | `harness/characterize_baked.py`, `results_characterization_baked.json` | E1–E5가 매 호출 가중치 복사를 포함. 정정 후 격차 2.2–4.1×, ρ=+0.81, Pareto 붕괴 | EVIDENCE v0.3 §2 | c78c7ab |

## 가설 판정 이력

| 버전 | H1 | H2 | H3 | 근거 실험 |
|---|---|---|---|---|
| v0.0 (연구노트) | 주가설 | 보조 | 보조 | — |
| v0.1 | 부분 기각 | 강화 (근거 noise 안쪽) | 미검증 | E1–E4 |
| v0.2 | 기각 유지 | **확립** (결정론적 근거로 교체) | 미검증(입력 확보) | E5 |
| **v0.3** | 기각 유지 (격차 2.2–4.1×로 정정) | **격하: 부분 지지** (ρ 근거 철회) | **메모리 축 전제 충족** (정적 상한 sound) | E6, E6b |
| **v0.3.1** | 현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류 | 설정별 비용 차이 관측; **계약 기반 선택의 이점 미입증** | 정적 per-call 버퍼 계약의 후보 근거 확보; 경계·가정·판정기 검증 필요 | E6c, 외부 검토 |

## 반증된 주장 이력

| 주장 | 출처 | 반증 실험 | 버전 |
|---|---|---|---|
| "AOT가 Python보다 빠르고 예측 가능" (H1) | 연구노트 v0.1 §5 | E1, E2 | v0.1 |
| "median과 tail 랭킹이 다르다" | 방향판단 §3.3 | E4 재분석: 차이 1.15× < noise 1.67× | v0.2 |
| "peak memory가 제안 framework의 우위 축" | 방향판단 §7 | E5: B0 대비 5.2–30.4× 더 씀 | v0.2 |
| "모델 크기가 바뀌면 순위 붕괴 (ρ=+0.18)" | EVIDENCE v0.2 §4 | E6b: 가중치 복사 인공물, ρ=+0.81 | v0.3 |
| "Pareto front 5개" | EVIDENCE v0.2 §3 | E6b: 상충 미관측 | v0.3 |
| "E5 메모리 축 반증 배수 5.2–30.4×" | EVIDENCE v0.2 §5 | E6: 배수는 런타임 컨텍스트 귀속; 프로그램 정적 65.6 KB | v0.3 |

## 방법론 결함 이력

| ID | 결함 | 영향 실험 | 발견 경로 | 조치 |
|---|---|---|---|---|
| D2 | 정적 상한 파서가 initializer 내 상수 임포트를 입력으로 오귀속; 런타임 컨텍스트를 721 KB 과대 산정 | E6b 해석, contract 예시 | 외부 검토 §5·§6 + E6c | 엔트리 함수 스코프 파싱, 상수 별도 집계, 정오표 |
| D1 | 가중치를 호출 인자로 전달 → 매 호출 전체 가중치 디바이스 임포트 | E1–E5 | E6 HAL 통계 `bytes_per_call == 전체 입력 크기` | E6b 재측정; 이후 모든 하네스는 `bytes_per_call` 기록 의무 |
