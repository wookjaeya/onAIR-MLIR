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
| **E14-S0** | 2026-09-08 | 교차 ISA(x86-64→AArch64) 계약 건전성: 컴파일·구조 분석·qemu-user 확인 | 결정론적(계약·IR·ELF·admission) / qemu-user 시간값은 비증거 | `e14/aarch64/`, `contracts/contract.e14_aarch64.json`, `scripts/60-62_*.sh` | bounded_bytes 동일(786,476); HAL peak/per-call/경계값/모델교체/동적형상 x86-64와 일치; **AArch64에 16B 스택 프레임(x86-64엔 없음)** 발견 | EVIDENCE v0.8 | (v0.8) |
| **E14-S1** | 대기 | qemu-system-aarch64 Linux 게스트 + cFS-in-guest + Conv2D/multi-branch 모델 | — | `docs/plans/E14_stage1_qemu_system_cfs.md` | 미착수 — Claude Code 이관 (게스트 이미지·영속 저장·반복 자동화 필요) | 계획 문서 | — |
| **E11b** | 2026-09-08 | standalone 계측 정정 + 결합 | 결정론적(HAL·해시) | `native/native_learner.c`, `summary.json` | peak↔bounded true; 정상 상태 per-call **65,544**; 3200/3200 완료; binding MATCH | EVIDENCE v0.7 §2 | 0e887df |
| **E11c** | 2026-09-08 | 모델 교체(같은 ABI) + 계약 A | 결정론적 | 동상 | CONTRACT_ARTIFACT_MISMATCH, exit 5, 런타임 미생성 | v0.7 §1.2 | 0e887df |
| **E12b/c/d** | 2026-09-08 | cFS: 일치 / 교체 / 파일 부재 | 결정론적 | `native/results/cfs_run_*.log` | 25/25 완료 / 기동 거부+cleanup / cleanup; 3경우 cFS OPERATIONAL | v0.7 §1–3 | 0e887df |
| **E13** | 2026-09-08 | 계약 IR ↔ LLVM IR ↔ ELF 대응 (host/generic) | 결정론적 | `e13/`, `contracts/contract.e13_host.json` | 커널 alloca 0·call 0·스택 프레임 0; host AVX-512 FMA 34 vs generic 스칼라; 같은 호출 계약 MATCH | v0.7 §4 | 0e887df |
| **E11** | 2026-09-08 | Native C 변형 (standalone, Python 없음) | FUNCTIONAL_ONLY (HAL·RSS·admission은 결정론적) | `native/native_learner.c`, `native/build.sh`, `native/results/summary.json` | admission ADMIT/NOT_ADMITTED(exit 3); HAL 피크 786,476 = bounded; RSS 4.3 MB; median 32.2 µs | EVIDENCE v0.6 §2 | 271a237 |
| **E12** | 2026-09-08 | cFS 앱 `AI_LEARNER` 통합 | 동상 | `native/cfs_app/`, `native/results/cfs_run_*.log` | ADMIT: ES HK 패킷 추론 25회, 피크=bounded; NOT_ADMITTED: 앱 기동 거부, cFS OPERATIONAL 유지 | EVIDENCE v0.6 §3 | 271a237 |
| **E9** | 2026-09-08 | 할당 구조 4사례 (정렬·수명·대형·fusion) | 결정론적 | `harness/structural_cases.py`, `results_structural_cases.json` | slice 합은 2/4 과소(D3); post-layout 슬랩 4/4 sound·tight | EVIDENCE v0.5 §1 | (v0.5) |
| **E10** | 2026-09-08 | 경계값 U−1/U/U+1 | 결정론적 | `results_admission.json` (`boundary_test`) | 18/18 정확 | EVIDENCE v0.5 §5 | (v0.5) |
| **E7b** | 2026-09-08 | E7 재실행 (post-layout, 새 판정 의미, 상수 독립 확인) | 결정론적 | `results_admission.json` | 258 판정, misprediction 0, 상수 129/129 아티팩트 확인 | EVIDENCE v0.5 §6 | (v0.5) |
| **E7** | 2026-09-07 | 메모리 전용 admission checker (A5) | 결정론적 | `harness/admission_check.py`, `admission_sweep.py`, `results_admission.json` | 240 판정, optimistic/pessimistic misprediction 0, config-invariant | EVIDENCE v0.4 §1 | (v0.4) |
| **E8** | 2026-09-07 | 동적 형상 모델의 UNBOUNDED 판정 | 결정론적 | `results_admission.json` (`E8_dynamic_shape`) | all_sizes_static=false → UNBOUNDED, 예산 무관 거절 | EVIDENCE v0.4 §2 | (v0.4) |
| **E6b** | 2026-09-07 | **정정**: 가중치 베이킹 재특성화 | FUNCTIONAL_ONLY | `harness/characterize_baked.py`, `results_characterization_baked.json` | E1–E5가 매 호출 가중치 복사를 포함. 정정 후 격차 2.2–4.1×, ρ=+0.81, Pareto 붕괴 | EVIDENCE v0.3 §2 | c78c7ab |

## 가설 판정 이력

| 버전 | H1 | H2 | H3 | 근거 실험 |
|---|---|---|---|---|
| v0.0 (연구노트) | 주가설 | 보조 | 보조 | — |
| v0.1 | 부분 기각 | 강화 (근거 noise 안쪽) | 미검증 | E1–E4 |
| v0.2 | 기각 유지 | **확립** (결정론적 근거로 교체) | 미검증(입력 확보) | E5 |
| **v0.3** | 기각 유지 (격차 2.2–4.1×로 정정) | **격하: 부분 지지** (ρ 근거 철회) | **메모리 축 전제 충족** (정적 상한 sound) | E6, E6b |
| **v0.8** | 변화 없음 | 변화 없음 | H3 일반성 범위 확대: **ISA(x86-64/AArch64) 불변 확인**(단일 MLP 한정); AArch64 태스크 스택 잔차 첫 발견, 명시적 회계 필요 | E14-S0 |
| **v0.7** | 변화 없음 | 변화 없음 (설정별 지연 차이의 구조적 원인 확인: AVX-512 FMA vs 스칼라) | 검증 범위 확장: 결합·계측·실패 처리·코드 대응 | E11b/c, E12b/c/d, E13 |
| **v0.6** | 변화 없음 (Native 1.84×) | 변화 없음 | **cFS 앱 배치 형태에서도 성립** (단일 앱·모델·native_std); 경계 (b) 런타임 구성 2종에서 견고 | E11, E12 |
| **v0.5** | 변화 없음 | 변화 없음 | 시험 조건 내 성립, **근거 강화** (구조 4종, 경계값, 상수 독립 검증); 중심 문장을 검토 §8 권고로 교체 | E9, E10, E7b |
| **v0.4** | 변화 없음 | 변화 없음 (E7 config-invariance는 메모리 판정에 선택 불필요라는 반대 증거) | **메모리 축, 시험 조건 내 성립** (경계 b, 240/240, E8) | E7, E8 |
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
| D7 | 호출당 할당 = 초기화 비용 포함 상각값 | 검토 v0.6 §5 | 지표 의미 | 정상 상태 카운터 차이(65,544) |
| D6 | 계약이 아티팩트를 식별하지 않음 | 검토 v0.6 §3 | gate 보장 조건부 | sha256·크기 결합, 헤더 생성 |
| D5 | 전체 HAL 피크를 per-call 계약과 비교 | 검토 v0.6 §4 | summary 누락 | bounded 비교 |
| D4 | 세션 해제 전 모듈 데이터 free → 해제 시 segfault | E11 하네스 종료 | 측정값 무영향 | 해제 순서 수정 |
| D3 | 상한 = slice 합 → 정렬 패딩 무시로 과소 추정 (E9-A 48<128, E9-B 84<128) | v0.3–v0.4 상한 방법 | 검토 §7 예측 → E9 실증 | post-layout transient alloca 크기로 교체; MLP 60/60 재검증 |
| D2 | 정적 상한 파서가 initializer 내 상수 임포트를 입력으로 오귀속; 런타임 컨텍스트를 721 KB 과대 산정 | E6b 해석, contract 예시 | 외부 검토 §5·§6 + E6c | 엔트리 함수 스코프 파싱, 상수 별도 집계, 정오표 |
| D1 | 가중치를 호출 인자로 전달 → 매 호출 전체 가중치 디바이스 임포트 | E1–E5 | E6 HAL 통계 `bytes_per_call == 전체 입력 크기` | E6b 재측정; 이후 모든 하네스는 `bytes_per_call` 기록 의무 |

| "slice 합은 보수적 상한" | EVIDENCE v0.3 §1.1 / v0.4 §0 | E9: 정렬 패딩으로 과소 | v0.5 |
| "cFS 배치 전 admission 수행" | REPORT v0.4 | cFS 통합 미완; 검토 §8 문장으로 교체 | v0.5 |
