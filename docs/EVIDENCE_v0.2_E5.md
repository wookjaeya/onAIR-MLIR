# 실험 E5 — Lowering Characterization 및 가설 영향 (v0.2)

선행 문서: `EVIDENCE_v0.1.md` (E0–E4), `현재_실험_결과에_대한_연구_방향_판단.md`
본 실험 목적: 검토에서 지적한 **M4(peak memory 미측정)** 를 메우고, 방향 판단 문서의 **Priority 2(lowering design space 확대)** 를 수행하여 C3 selector의 실제 입력인 매핑을 구축한다.

---

## 요약

- **TOPIC** — 동일 모델에 대해 10개 lowering configuration을 생성하고 `l_i → (C_median, C_p95, C_p99, M_peak, S_binary)` 매핑을 3개 모델 크기에서 측정.
- **Problem** — 매핑은 존재하지만, 세 가지가 동시에 확인됐다: (1) 지표마다 승자가 다르고, (2) **모델 크기가 바뀌면 순위가 붕괴하며**(Spearman ρ=+0.18), (3) **메모리 축에서 B0가 오히려 압도적으로 우수하다**(40 KB vs 1216 KB).
- **Solution** — (1)(2)는 C3의 필요성을 크게 강화한다. 그러나 (3)은 방향 판단 문서 §7이 "제안 framework의 추가 축"으로 지목한 peak memory 우위 주장을 **직접 반증**하므로, 그 주장을 철회하거나 정적 할당·Native-cFS 조건으로 재정의해야 한다.

---

## 1. 방법

- 모델: MLP `1×9 → h → 2`, `linalg.matmul` 2단. h ∈ {256, 4096, 16384}.
- 설정 10종: target 선택(default, cpu_host, avx2, avx512, generic_cpu), 코드 생성 전략(no_embedded, host_no_embed, opt_size, no_slow_vec), 런타임 실행 모델(host_task = `local-task` 드라이버).
- **각 설정을 독립 서브프로세스에서 측정.** peak RSS는 프로세스 전역이므로 한 프로세스에서 여러 설정을 재면 최악값이 모두에게 귀속된다.
- 메모리 두 값 분리 기록:
  - `M_rss_delta_kb` — 아티팩트 로드 직전 → 추론 루프 종료 후 RSS 증가분. **배치되는 아티팩트에 귀속되는 값**이며 계약의 메모리 예산과 비교할 대상.
  - `M_rss_peak_kb` — 워커 전체 `ru_maxrss`. 워커 간 비교용.
- B0(NumPy/BLAS)는 동일 워커·동일 회계로 측정해 비교 가능성을 확보.
- 수치 동등성: 전 설정 `max_abs_diff = 4.05e-6` (f32) — **모든 설정이 기능 동등**.

**증거 등급**: 플랫폼 `timing_grade = FUNCTIONAL_ONLY`, noise ratio p99 **1.67×**. 아래에서 1.67배를 초과하는 차이만 유의 신호로 취급한다. 단, `S_binary_bytes`는 결정론적 값이므로 noise 규칙이 적용되지 않는다.

---

## 2. 매핑 결과 (h=16384, n=1200)

| config | median (µs) | p95 | p99 | p99/med | RSS delta (KB) | binary (B) |
|---|---:|---:|---:|---:|---:|---:|
| **B0 numpy/BLAS** | **16.6** | 19.5 | 31.1 | 1.87 | **40** | — |
| no_slow_vec | **79.2** | 112.9 | **124.7** | 1.58 | 1284 | 11692 |
| avx512 | 84.8 | 124.4 | 140.6 | 1.66 | 1280 | 10892 |
| host_no_embed | 95.6 | 133.9 | 153.9 | 1.61 | 1304 | 23538 |
| cpu_host | 96.8 | 134.8 | 165.8 | 1.71 | **1220** | 11724 |
| opt_size | 97.7 | 131.7 | 146.7 | 1.50 | 1288 | 11724 |
| host_task | 101.9 | 138.4 | 161.4 | 1.58 | **3340** | 11724 |
| generic_cpu | 136.1 | 180.8 | 219.0 | 1.61 | 1284 | 10516 |
| default | 141.8 | 189.2 | 222.2 | 1.57 | 1216 | **10452** |
| avx2 | 151.9 | 194.8 | 220.8 | 1.45 | 1280 | 10548 |
| no_embedded | 164.1 | 203.8 | 222.0 | **1.35** | 1308 | 22586 |

**설정 간 편차**: median **2.07×**, RSS delta **2.75×**, binary **2.25×**. 앞의 두 개는 noise(1.67×)를 초과.

---

## 3. 발견 1 — 지표마다 승자가 다르다 (C3 지지)

| 지표 | 최적 설정 | 값 |
|---|---|---|
| median | no_slow_vec | 79.2 µs |
| p99 | no_slow_vec | 124.7 µs |
| p99/median (분산) | no_embedded | 1.35 |
| RSS delta | default | 1216 KB |
| binary size | default | 10452 B |

**Pareto front (median, RSS delta, binary)**: `no_slow_vec`, `avx512`, `cpu_host`, `generic_cpu`, `default` — 5개가 서로 지배하지 않는다.

**가설 영향(H2)**: EVIDENCE v0.1의 §3.3은 p99/median 차이 1.15×가 noise 안쪽이라 지지되지 않는다고 판정했다. **E5는 이를 대체한다.** median↔RSS↔binary 사이의 승자 불일치는 결정론적 지표(binary)와 noise 초과 지표(median 2.07×, RSS 2.75×)에 근거하므로, "단일 목적함수로는 부족하다"는 §6의 결론이 **이제 증거로 지지된다.** 다만 근거는 tail 지표가 아니라 **메모리·바이너리 축**이다.

---

## 4. 발견 2 — 모델 크기가 바뀌면 순위가 붕괴한다 (C3 강하게 지지)

median 기준 순위의 Spearman 상관:

| 비교 | ρ |
|---|---:|
| h=256 vs h=4096 | **+0.103** |
| h=256 vs h=16384 | **+0.176** |
| h=4096 vs h=16384 | +0.842 |

정규화 median (설정/최적, >1.67 = noise 초과):

| config | h=256 | h=4096 | h=16384 |
|---|---:|---:|---:|
| no_slow_vec | 1.08 | **1.00** | **1.00** |
| host_no_embed | **1.00** | 1.04 | 1.21 |
| opt_size | 1.20 | 1.02 | 1.23 |
| generic_cpu | 1.06 | 1.62 | **1.72** |
| default | 1.20 | 1.63 | **1.79** |
| avx2 | 1.15 | 1.63 | **1.92** |
| no_embedded | 1.06 | 1.51 | **2.07** |

`no_embedded`는 h=256에서 최적 대비 1.06배(3위)였다가 h=16384에서 2.07배(10위)로 전락한다. 반대로 `opt_size`는 9위 → 2위 → 5위로 움직인다.

**가설 영향(H2)**: 이것이 E5의 가장 강한 결과다.
- **고정 default 설정은 어떤 값으로 잡아도 틀린다.** 한 모델에 맞춘 설정이 다른 모델에서 최대 2배 손해를 낸다.
- 따라서 lowering 선택은 1회성 튜닝이 아니라 **모델·타깃별로 반복되어야 하는 절차**이며, 이것이 자동화(C3)를 정당화한다.
- 동시에 이 결과는 신규성 방어에도 쓰인다: "그냥 좋은 플래그를 한 번 찾으면 되지 않나"라는 반론에 대해 ρ=+0.18이 직접적인 반증이다.

⚠️ 단서: h=256 구간의 설정 간 차이 대부분(1.00–1.20)은 noise 안쪽이므로, 그 구간 내부의 세부 순위는 신뢰할 수 없다. 신뢰 가능한 진술은 **"h=256에서 상위권이던 설정이 h=16384에서 noise를 초과하여 하위로 밀린다"** 이다(`no_embedded` 1.06 → 2.07, `avx2` 1.15 → 1.92).

---

## 5. 발견 3 — 메모리 축에서 B0가 압도적으로 우수하다 (방향 판단 §7 반증)

| h | 최적 compiled median / B0 | B0 RSS delta | compiled 최소 RSS delta | 배수 |
|---:|---:|---:|---:|---:|
| 256 | 6.13× 느림 | 96 KB | 500 KB | 5.2× |
| 4096 | 4.83× 느림 | 48 KB | 624 KB | 13.0× |
| 16384 | 4.76× 느림 | 40 KB | 1216 KB | **30.4×** |

`M_rss_peak_kb`(워커 전체)로 봐도 B0 37,232 KB vs compiled 41,556–43,840 KB로 B0가 4–6 MB 작다.

**가설 영향 — 중요**:
방향 판단 문서 §7은 "제안 framework가 목표로 하는 추가적인 축"으로 **peak memory/resource constraint** 를 들었다. E5는 현재 구성에서 이 축이 **반대 방향**임을 보여준다. 이유는 IREE 런타임 컨텍스트(VM 인스턴스, 모듈, HAL 디바이스) 생성 비용이 약 1.2 MB이고, 모델이 커져도 이 상수가 남기 때문이다. `host_task` 드라이버는 3.34 MB로 더 나쁘다.

**해석상의 단서(반드시 명시할 것)**: 이 비교는 완전한 등가가 아니다. B0의 `rss_delta`는 `import numpy` 시점에 이미 로드된 BLAS를 포함하지 않는 반면, compiled의 `rss_delta`는 IREE 런타임 초기화를 포함한다. 그러나 **배치 관점에서는 이 비대칭이 곧 현실**이다 — OnAIR 프로세스에는 NumPy가 이미 상주하지만 IREE 런타임은 추가 비용이다.

**따라서 필요한 조치**:
1. §7의 "peak memory 우위" 주장을 **현 상태로는 철회**한다.
2. 메모리 축을 살리려면 조건을 바꿔야 한다 — (a) **Native-cFS 변형**에서 Python·NumPy 자체를 제거했을 때의 총 상주 메모리 비교, (b) IREE의 정적/임베디드 런타임 구성(`--iree-llvmcpu-link-embedded` 계열, bare-metal 타깃)으로 런타임 상수를 줄인 구성, (c) 동적 할당 부재라는 **정성적 속성**(값이 작다가 아니라 예측 가능하다)으로 재정의.
3. (c)가 가장 방어 가능하다: 계약이 요구하는 것은 "작은 메모리"가 아니라 "**컴파일 시점에 알려진 상한**"이다. 현재 측정값은 상한이 아니라 관측 최대이므로, 정적 상한 산출이 곧 컴파일러 기여가 된다.

---

## 6. 발견 4 — 런타임 실행 모델은 별개 축이다

`host_task`(동일 아티팩트, `local-task` 드라이버)는 `cpu_host` 대비 median 96.8 → 101.9 µs, RSS delta 1220 → 3340 KB.
단일 코어에서 멀티스레드 태스크 시스템은 **속도 이득 없이 메모리만 2.7배** 쓴다.

**가설 영향**: 계약의 `target` 필드에 컴파일 플래그뿐 아니라 **런타임 드라이버**가 포함되어야 함을 실증한다. 현재 `contract.schema.json`은 `target.driver`를 이미 갖고 있으므로 스키마 변경은 불필요하다.

---

## 7. C1 → C3 경로 실증

특성화 결과로 계약의 공란을 채웠다 (`plugins/compiled_learner/runtime/contract.json`):

```json
"target":    { "profile": "no_slow_vec", "driver": "local-sync" },
"resources": { "binary_size_bytes": 11692,
               "peak_memory_bytes": 1314816,
               "peak_memory_method": "measured_rss_delta" },
"timing":    { "boundary": "L1_kernel",
               "execution_bound_us": 262.963,
               "bound_method": "measured_max",
               "sample_count": 1200,
               "platform_timing_grade": "FUNCTIONAL_ONLY" }
```

`bound_method`가 `measured_max`인 한, 이 계약은 **feasibility를 반증할 수만 있고 보증할 수 없다.** 이 제한은 계약 파일 자체에 문자열로 남겼다.

---

## 8. 가설 종합 판정 갱신

| 가설 | v0.1 판정 | v0.2 판정 | 변경 사유 |
|---|---|---|---|
| **H1** (AOT → tail·variability 개선) | 부분 기각 | **기각 유지** | E5에서도 최적 compiled가 B0 대비 4.8–6.1배 느림. 분산(p99/med)도 B0 1.87 vs compiled 1.35–1.71로 compiled가 유리해 보이나 차이 1.39배 < noise 1.67배 → 판별 불가 |
| **H2** (계약 인지 lowering 선택) | 강화(단, 근거가 noise 안쪽) | **확립** | 근거를 tail 지표에서 **결정론적·noise 초과 지표**로 교체: median 2.07×, RSS 2.75×, binary 2.25×, Pareto front 5개, **크기 간 ρ=+0.18** |
| **H3** (사전 feasibility 판정) | 미검증 | **미검증(단, 입력 확보)** | 매핑과 계약이 채워져 selector 구현이 가능해짐. 판정 실험은 PASS 플랫폼 필요 |
| §7 "peak memory 우위" | 미측정 | **반증** | B0 대비 5.2–30.4배 더 씀 |

---

## 9. 연구 서술에 반영할 사항

1. **H2의 근거 문장을 교체한다.** "median과 tail의 랭킹이 다르다"(noise 안쪽) → **"지표별 최적이 다르고 Pareto front가 5개이며, 모델 크기가 바뀌면 순위 상관이 ρ=+0.18로 붕괴한다"**.
2. **"고정 default는 틀린다"를 논문의 motivating figure로 삼는다.** §4 정규화 표가 그 그림이다.
3. **메모리 주장은 "작다"가 아니라 "정적으로 알 수 있다"로 재정의한다.** 현재 값은 관측 최대이므로, **정적 메모리 상한 산출 패스**가 남은 유일한 진짜 컴파일러 기여 후보다.
4. **Native-cFS 변형의 우선순위를 올린다.** Python·NumPy 상주 비용을 제거하지 않으면 메모리 축에서 B0를 이길 수 없다.

## 10. 다음 실험

| # | 실험 | 검증 대상 | 현 플랫폼 |
|---|---|---|---|
| P2b | bufferization 결과에서 **정적 메모리 상한** 산출 패스 | 진짜 컴파일러 기여 | 가능 |
| P3 | Native-cFS 변형(정적 링크, Python 제거) | §7 메모리 축 복원, H1 잔여 | 가능 |
| P4 | deadline/부하 스윕 → deadline miss ratio | **H2 본검증** | PASS 필요 |
| P1 | ARM64 PASS 플랫폼 이관 | H1/H3 판정 | 하드웨어 필요 |
| P5 | contract selector 구현 + false-safe 평가 | H3 | P4 이후 |

---

## 부록 — 재현

```bash
python3 harness/characterize.py --n-hidden 256   --iters 3000 --warmup 500 \
        --out results_characterization_256.json
python3 harness/characterize.py --n-hidden 4096  --iters 1500 --warmup 300 \
        --out results_characterization_4096.json
python3 harness/characterize.py --n-hidden 16384 --iters 1200 --warmup 250 \
        --out results_characterization_16384.json
```
