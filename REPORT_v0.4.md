# 총괄 보고서 — Statically-Bounded AI Deployment Contracts for NASA OnAIR/cFS

**기준 버전**: v0.4 (git tag `v0.4`, 2026-09-07)
**대상 기간**: 연구노트 v0.1 검토 → E0–E8 (모두 2026-09-07)
**정본 관계**: 본 보고서는 총괄이다. 실험별 근거는 `docs/EVIDENCE_v0.1–v0.4`, 실험 등록·판정 이력·철회·결함 원장은 `EXPERIMENT_LOG.md`, 버전 변경은 `CHANGELOG.md`.

---

## 요약

- **TOPIC** — NASA OnAIR의 AI Learner 플러그인을 MLIR/IREE로 AOT 컴파일하고, 컴파일러의 할당 스케줄에서 도출한 **정적 메모리 계약**으로 cFS 배치 전 admission을 수행하는 연구의 실험적 성립 여부.
- **Problem** — 출발 가설(H1: AOT가 Python보다 빠르고 예측 가능; H2: 계약 기반 lowering 선택이 유리)은 둘 다 데이터로 지지되지 않았고, 그 과정에서 측정 결함 2건(D1 가중치 per-call 복사, D2 상수 오귀속)이 발견·정정됐다.
- **Solution** — 살아남은 결과는 **정적 메모리 계산값 = 런타임 피크(60/60)** 와 이를 이용한 **admission checker(240 판정, optimistic misprediction 0, 동적 형상은 UNBOUNDED 거절)** 다. 연구의 중심은 "lowering 선택(H2)"에서 **"정적 계약(C1) + 실행 전 판정(H3)"** 으로 이동했으며, 시간 축은 적격 플랫폼 부재로 미검증이다.

---

## 1. 연구 맥락

| 항목 | 내용 | 출처 |
|---|---|---|
| OnAIR | NASA GSFC의 Python 기반 온보드 AI 연구 플랫폼. Knowledge Rep→Learner→Planner→Complex 플러그인 파이프라인, csv/Redis/cFS(SBN) 어댑터 | IAAI-25 (NTRS 20240012527) |
| 비행 실증 | ISS STP-H9 SCENIC, 100 MHz FPGA 소프트코어, 칼만 필터 + 파일 기록 플러그인, 40포인트 0.25 Hz, 4일 무오류 | IAAI-25 |
| cFS | NASA 비행 SW 프레임워크, Apache 2.0, RTEMS/VxWorks/Linux, SBN으로 프로세스·파티션 간 SB 브리지 | nasa/cFS, nasa/SBN |
| 출발 연구노트 | *Timing-Contract-Aware MLIR Compilation for AI Plugins in NASA OnAIR/cFS* v0.1 | 사용자 제공 |
| 사전 검토 | Critical 3(아키텍처 자기모순, 스케줄링 모델–플랫폼 불일치, 측정 경계 미정의) / Major 10 / Minor 10 | 대화 기록 |

---

## 2. 실험 환경

| 항목 | 값 |
|---|---|
| 호스트 | 공유 VM, 1 vCPU (Xeon @2.1 GHz), 3.9 GiB, Ubuntu 24.04, gcc 13.3, cmake 3.28, Python 3.12 |
| 툴체인 | IREE 3.11 (iree-base-compiler/runtime), NumPy, OnAIR (nasa/OnAIR main), cFS bundle (native_std) |
| 타이밍 적격성 | `platform_check.py`: ratio_p99 **1.67**, ratio_max **2.26** → **FUNCTIONAL_ONLY** |
| 해석 규칙 | 절대 지연값은 증거 아님. 동일 호스트 연속 측정의 구현 간 비율만, 그것도 1.67× 초과 시에만 방향성 신호. **결정론적 값(바이너리 크기, 정적 메모리, HAL 할당 통계)은 잡음 규칙 비적용** |
| 환경 함정 | (1) `cfe/cmake/Makefile.sample`을 번들에 덮어쓰면 prep 실패 — 번들 자체 Makefile 사용. (2) `/proc/sys/fs/mqueue/msg_max`=10에서 cFE SB 파이프 생성 실패 — 512로 상향 |

---

## 3. 실험 일람

| ID | 내용 | 핵심 결과 | 비고 |
|---|---|---|---|
| E0 | cFS 빌드·기동(LC 7.0.1, SBN), OnAIR CSV/Kalman 완주, IREE 컴파일·실행 | 전부 PASS | 환경 |
| E0-int | `CompiledLearner`/`PythonLearner`를 OnAIR `AIPlugin`으로 통합 | **OnAIR core 변경 0줄** | 함정: `ServiceManager({})` 선초기화 |
| E1 | 모델 크기 스윕 h=16…65536 | compiled 6–9× 느림, 교차점 없음 | **D1 영향** |
| E2 | 지연 분산 | 소형에서 compiled p99/med 더 나쁨 | D1 영향 |
| E3 | 마샬링 floor | 항등 호출 4.70 µs | — |
| E4 | lowering 4종 | 1.87× 편차 | D1 영향 |
| E5 | lowering 10종 × 3크기, 메모리 포함 | Pareto 5, ρ=+0.18, 메모리 B0 우위 | D1 영향, **§3·§4·§5 철회** |
| E6 | 정적 메모리 상한 (입력 변형) | 계산값 = HAL 피크 30/30, 설정 불변 | 결정론적 |
| E6b | **정정**: 가중치 베이킹 재특성화 | 격차 2.2–4.1×, ρ=+0.81, Pareto 붕괴 | D1 해소 |
| E6c | 베이킹 모델 정적 상한 IR 파싱 | 30/30, 상수 720,896 B 모듈 상주로 분리 | D2 해소 |
| E7 | 메모리 전용 admission checker | **240 판정, misprediction 0, config-invariant** | 결정론적 |
| E8 | 동적 배치 차원 모델 | `all_sizes_static=false` → **UNBOUNDED** 거절 | 적용 경계 |

---

## 4. 가설 판정 최종 (v0.4)

| 가설 | 판정 | 결정적 근거 | 미검증 |
|---|---|---|---|
| **H1** AOT-compiled Learner가 Python Learner 대비 tail·variability 개선 | **현 모델·구현·플랫폼에서 성능 우위 미관측; 예측성 일반화 보류** | IREE 플러그인 L1 median이 NumPy/BLAS 플러그인 대비 2.2–4.1× 느림, p99도 열세; p99/median 차이는 noise 내 | Native-cFS 변형, PASS 플랫폼 |
| **H2** 계약 기반 lowering 선택이 고정 설정보다 유리 | **설정별 비용 차이 관측; 선택의 이점 미입증 → 논문 주장에서 제외 권고** | 타깃 CPU 미지정 시 최대 2.6× 손해; `local-task` RSS +2.5 MB; 다목적 상충 미관측; **메모리 판정은 설정 불변(E7)** | 시간 축에서만 의미 가능 |
| **H3** 실행 전 feasibility 판정 | **메모리 축, 시험 조건 내 성립** | 경계 (b) 확정, 60/60 일치, 240/240 판정 검증, E8 비적용 경계 | 시간 축, 일반성(다중 dispatch·fusion), Native-cFS 실제 경계 |
| **C1** 배치 계약 | 메모리: `static_from_stream_schedule`(bounded = per-call + 상수), `bound_method: NONE` 경로 포함; 시간: null | 스키마 v0.4 | 시간 축 |
| 기능 동등성 | 시험 범위 내 수치 일치 | max_abs_diff ≤ 4.05e-6 (입력) / 3.58e-7 (베이킹), f32 | 허용 오차 기준·argmax 일치·입력 범위 |

---

## 5. 핵심 수치 (정정 반영)

### 5.1 지연 (L1 커널 median, 베이킹 가중치, FUNCTIONAL_ONLY 플랫폼)

| h | B0 NumPy/BLAS | 최적 compiled | 비율 | generic 설정 손해 |
|---:|---:|---:|---:|---:|
| 256 | 2.0 µs | 8.3 µs | 4.14× | 1.1× |
| 4096 | 5.8 µs | 15.9 µs | 2.73× | 1.8× |
| 16384 | 17.5 µs | 38.9 µs | 2.22× | 2.6× |

### 5.2 메모리 (h=16384, 결정론적)

| 구성요소 | 값 | 출처 | 보장 |
|---|---:|---|:---:|
| per-call 중간 버퍼 | 65,536 B | `stream.resource.pack` | ✅ |
| per-call I/O | 44 B | `tensor.import`/`alloca` | ✅ |
| 모듈 상주 상수 | 720,896 B | `stream.resource.constants` | ✅ |
| **bounded_bytes** | **786,476 B** | 합 | ✅ |
| HAL 런타임 피크 (per-call) | 65,580 B | allocator 통계 | 검증 |
| 런타임 컨텍스트 (잔차) | ≈ 244 KB (local-sync) / +2.5 MB (local-task) | RSS − bounded | ✗ 귀속만 |

### 5.3 검증 건수

| 검증 | 건수 |
|---|---:|
| 정적 계산 = HAL 피크 (입력 변형, E6) | 30/30 |
| 정적 계산 = HAL 피크 (베이킹 변형, E6c) | 30/30 |
| admission 판정 검증 (E7) | 240/240, misprediction 0 |
| 동적 형상 거절 (E8) | 1/1 |

---

## 6. 방법론 결함·정정 원장

| ID | 결함 | 발견 | 영향 | 조치 |
|---|---|---|---|---|
| **D1** | 하네스가 가중치를 호출 인자로 전달 → 매 호출 전체 가중치(≤720 KB) 디바이스 할당 | E6 HAL `bytes_per_call == 전체 입력` | E1–E5 지연 2–3배 과대, ρ=+0.18·Pareto 5·메모리 배수 30× 모두 인공물 | E6b 재측정; 이후 `bytes_per_call` 기록 의무 |
| **D2** | 정적 상한 파서가 initializer 내 상수 임포트를 입력으로 오귀속; 런타임 컨텍스트 721 KB 과대 | 외부 검토 §5·§6 + E6c | 계약 예시·EVIDENCE v0.3 §7 수치 | 엔트리 함수 스코프 파싱, 상수 별도 집계, 정오표 |

| 철회된 주장 | 출처 | 정정 |
|---|---|---|
| compiled가 B0 대비 6.3–9.5× 느림 | v0.1 §2 | 2.2–4.1× |
| 모델 크기별 순위 붕괴 ρ=+0.18 | v0.2 §4 | ρ=+0.81 |
| Pareto front 5개 | v0.2 §3 | 상충 미관측 |
| 메모리 축 B0 대비 5.2–30.4× 열세 | v0.2 §5 | 배수는 런타임 컨텍스트·상수 귀속 |
| median↔tail 랭킹 상이 | 방향판단 §3.3 | 차이 1.15× < noise |
| "2.2× 대가로 정적 보장 + Python 제거" 교환 | v0.3 §4 | 후속 가설로 강등 |
| E6 "50/50" | PROGRESS v0.3 | 60/60 (오기) |
| 런타임 컨텍스트 ≈971 KB | v0.3 §7 | ≈244 KB |

---

## 7. 연구 방향 판단 (본인 분석·판단)

1. **중심 주장**: "컴파일러 할당 스케줄에서 도출한 정적 메모리 계약으로 cFS 배치 전 admission을 수행한다. 60개 아티팩트·240 판정에서 optimistic misprediction 0, 정적 상한이 없는 모델은 거절된다." 결정론적·재현 가능·컴파일러 고유.
2. **제외**: H1(성능 우위)과 H2(선택 이점)는 논문 주장에서 뺀다. H2는 E7의 config-invariance가 반대 증거다.
3. **제목 방향**: "Contract-Guided MLIR Lowering…" → **"Statically-Bounded AI Deployment Contracts for NASA OnAIR/cFS"** 계열. "Predictable"·"Timing"은 시간 축 증거가 나올 때까지 제목에 넣지 않는다.
4. **B0 유지**: NumPy/BLAS 플러그인은 강한 베이스라인이며 약화하지 않는다. 비교 명칭은 "Python vs AOT"가 아니라 **"NumPy/BLAS 플러그인 vs IREE 플러그인"**.
5. **MLIR 필연성은 미입증**: TFLM의 정적 아레나도 컴파일 시 크기를 준다. 차별점 후보는 "할당 스케줄 IR이 노출되어 독립 파싱·검증 가능"이며 B2 비교로 보여야 한다.

---

## 8. 한계 (논문에 그대로 옮길 수준)

| 한계 | 영향 |
|---|---|
| 플랫폼 FUNCTIONAL_ONLY | 시간 축 결과 전무. `execution_bound_us` null |
| 워크로드: 2-dispatch MLP 하나 | 정적 상한·admission의 일반성 미확인 (fusion, 다중 dispatch, 버퍼 재사용) |
| Python 플러그인 경로에서 측정 | cFS 앱 배치의 실제 경계(런타임 컨텍스트·파이프·스택) 미확정 |
| 정적 분석과 HAL이 같은 할당 계획 | 일치는 구현 검증이지 계획의 보편성 증명 아님 |
| 단일 in-flight 호출, local-sync | 동시 추론·비동기 dispatch 미고려 |
| 기능 동등성 기준 미정의 | 허용 오차·argmax 일치·입력 범위 필요 |
| 예산 경계값 근처 미시험 | bounded = 예산 ± 수 바이트 사례 없음 |

---

## 9. 잔여 작업

**현 플랫폼 가능 (우선순위)**
1. **A1 Native-cFS 변형** — IREE 정적 라이브러리를 cFS C 앱에 링크, SB 수신→추론→발행. 런타임 컨텍스트·파이프 포함 실제 메모리 경계 측정. Python 제거의 실재 확인.
2. **A4 일반성** — 다중 dispatch·fusion·버퍼 재사용 모델(소형 CNN)로 E6/E7 재검증. `stream.resource.pack`의 lifetime 패킹이 있을 때 "slice 합 = 보수적 상한"이 실제로 보수적인지 확인.
3. **A3 B2 = TFLite Micro** — 동일 경계에서 비교, MLIR 필연성.
4. 기능 동등성 기준 정의(허용 오차, argmax 일치), 예산 경계값 시험.
5. A2 상충 워크로드 탐색 — H2를 되살릴 때만.

**PASS 플랫폼 필요**
- B1 시간 축 계약 최초 기록 (`execution_bound_us`, `bound_method`)
- B2 cFS 부하 동반 deadline miss ratio, ΔR_cFS
- B3 시간+메모리 결합 admission, optimistic misprediction 평가

**문서**
- 연구노트 v0.2 전면 개정(제목·thesis·가설·검토 Critical 3·D1/D2 명시·참고문헌)

---

## 10. 저장소

```
onair-mlir-bench/            git: 커밋 1건 = 실험 1건, 태그 v0.2 v0.3 v0.3.1 v0.4
├── REPORT_v0.4.md           ← 본 문서
├── PROGRESS.md              한 장 요약 (v0.3.1)
├── EXPERIMENT_LOG.md        실험 레지스트리 · 판정 이력 · 철회 원장 · 결함 원장
├── CHANGELOG.md             버전별 변경 (판정:/정정: 접두어)
├── scripts/                 환경 구축 (검증됨)
├── plugins/                 compiled_learner (IREE), python_learner (B0)
├── harness/
│   ├── platform_check.py    타이밍 적격성 게이트
│   ├── sweep.py             E1–E3 (D1)
│   ├── characterize.py      E5 (D1)
│   ├── characterize_baked.py E6b
│   ├── static_mem_bound.py  E6/E6c 정적 상한 (엔트리 스코프, 상수 분리)
│   ├── static_bound_sweep.py
│   ├── admission_check.py   E7 판정기
│   └── admission_sweep.py   E7 240판정 + E8
├── contracts/
│   ├── contract.schema.json v0.4 (memory_boundary, bounded_bytes, NONE)
│   └── contract.filled.example.json
├── results_*.json           원자료 (sweep, characterization, static_bound, admission)
└── docs/
    ├── STATUS.md, MVP_RESULT.md
    ├── EVIDENCE_v0.1.md     E0–E4
    ├── EVIDENCE_v0.2_E5.md  E5 (일부 철회)
    ├── EVIDENCE_v0.3_E6.md  E6·E6b·E6c·정오표
    └── EVIDENCE_v0.4_E7.md  E7·E8
```

---

## 11. 참고문헌 (검증 상태)

| 문헌 | 식별자 | 상태 |
|---|---|---|
| Gizzi et al., OnAIR: Applications of the NASA On-Board AI Research Platform, IAAI-25 | https://ntrs.nasa.gov/api/citations/20240012527/downloads/IAAI25_OnAIR.pdf ; DOI 10.1609/aaai.v39i28.35156 | 원문 확인 |
| Gizzi et al., The OnAIR Platform, SPAICE 2024 | https://ntrs.nasa.gov/api/citations/20240009778/downloads/SPAICE-Camera-Ready.pdf | 검색 확인 |
| nasa/OnAIR, nasa/cFS, nasa/SBN, nasa/LC (GitHub) | 저장소 | 소스 확인·빌드 |
| NASA/CR-20205010026, Open Source cFS FSW Final Report | https://ntrs.nasa.gov/api/citations/20205010026 | 검색 확인 |
| TinyIREE, arXiv 2205.14479 | https://arxiv.org/abs/2205.14479 | 검색 확인 |
| IREE RISC-V 문서; LLVM RISC-V Vector 문서 | iree.dev ; llvm.org | 검색 확인 |
| Kang et al., LaLaRAND, RTSS 2021 | DOI 10.1109/RTSS52674.2021.00038 | 검색 확인 |
| NNEF, SmallSat 2024 | https://digitalcommons.usu.edu/smallsat/2024/all2024/19 | 검색 확인 |
| Hahn et al., LLVMTA, WCET 2022 | DOI 10.4230/OASIcs.WCET.2022.2 | 검색 확인 |
| SpaceCube 프로파일링 (MicroBlaze/RocketChip), IEEE 2024 | researchgate 380555381 | 검색 확인 |
| NASA/SiFive HPSC (2022) | businesswire 20220906005374 | 검색 확인 |
| 외부 검토 `PROGRESS_v0_3_REVIEW.md` | 사용자 제공 | 반영 완료 |

미검증: TFLite Micro 정적 아레나 특성(공식 문서 인용 필요), LLVM MicroBlaze 백엔드 부재, CPython on RTEMS, IREE `stream.resource.pack`의 lifetime 패킹 세부.
