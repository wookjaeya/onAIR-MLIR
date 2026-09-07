# Experiment environment — build report

**TOPIC** / NASA cFS + OnAIR + MLIR(IREE) 실험환경을 이 컨테이너에서 실제로 구축·검증한 결과.
**Problem** / 기능 스택은 전부 세울 수 있으나, 이 컨테이너는 1 vCPU 공유 VM이라 tail-latency 증거를 생산할 수 없다.
**Solution** / 검증된 설치 스크립트·계측 하네스·계약 스키마를 제공하고, 타이밍 실험은 전용 하드웨어로 이관한다.

## 1. 이 컨테이너에서 실제로 확인된 것

| 항목 | 결과 | 증거 |
|---|---|---|
| cFS 빌드 | 성공 | `make native_std.prep && make native_std.install` 완료, `exe/cpu1`에 `core-cpu1` 및 앱 `.so` 생성 |
| cFS 기동 | 성공 | `CFE_ES_Main entering OPERATIONAL state`, LC/SC/MM/HK/DS/CF/CI_LAB 초기화 로그 확인 |
| SBN 존재 | 확인 | 번들 서브모듈 `apps/sbn` (nasa/SBN), 기동 시 `SBN_UDP Lib Initialized.` |
| LC 앱 동작 | 확인 | `66/1/LC 2: LC Initialized. Version 7.0.1.255` |
| OnAIR 실행 | 성공 | `driver.py onair/config/kalman_csv_output_example.ini` 1440 스텝 완주 |
| OnAIR 어댑터 | 확인 | `onair/data_handling/{csv_parser,redis_adapter,sbn_adapter}.py`, 설정 `sbn_cfs_config.ini` |
| IREE 컴파일 | 성공 | `mlp.mlir` → `.vmfb` 10,554 B (llvm-cpu, x86_64) |
| IREE 실행·수치 동등성 | 성공 | NumPy 참조 대비 `max_abs_diff = 3.05e-5` (f32) |

### 발견된 함정 두 가지 (스크립트에 주석으로 고정)
1. `cfe/cmake/Makefile.sample`과 `cfe/cmake/sample_defs`를 번들 루트에 덮어쓰면 prep이 `Target "hs" not found`로 실패한다. 번들 자체의 `Makefile`/`sample_defs`를 써야 한다.
2. `/proc/sys/fs/mqueue/msg_max` 기본값 10에서는 cFE SB 파이프 생성이 `errno=22`로 실패해 EVS/ES가 초기화되지 못한다. 512로 올리면 정상 기동한다.

## 2. 이 컨테이너에서 얻을 수 없는 것

`harness/platform_check.py` 실행 결과:

```
cpus=1  clock_res_ns=1.0
median=790.1us  p99=1319.5us  max=1786.6us
ratio_p99=1.67  ratio_max=2.26
timing_grade=FUNCTIONAL_ONLY
```

플랫폼 자체의 잡음이 median 대비 p99 1.67배, max 2.26배다. 연구노트가 측정하려는 대상(구현 간 tail latency 차이)과 같은 크기이거나 그보다 크므로, 이 환경에서 나온 p99/max 수치는 H1의 증거가 될 수 없다. 그 밖의 제약: 파일시스템이 세션 간 초기화됨(영속성 없음), ARM64/RISC-V 실기 없음, PREEMPT_RT·코어 격리·`SCHED_FIFO` 보장 없음, RTEMS 타깃 없음.

## 3. 그럼에도 나온 예비 관측 (재현은 필요, 증거 아님)

동일 MLP(1x32 → 64 → 2)에서 L1(커널 호출) 경계:

| 구현 | median | p99 | max |
|---|---:|---:|---:|
| IREE local-sync (Python 바인딩 경유) | 14.7 us | 38.4 us | 191.8 us |
| NumPy | 1.9 us | 4.7 us | 85.1 us |

이 규모에서는 **컴파일된 커널이 NumPy보다 느리다.** 원인은 커널 연산이 아니라 Python↔런타임 마샬링 오버헤드로 보인다(본인 분석). 이는 검토에서 지적한 C3(측정 경계 정의)와 M1(TFLite Micro 베이스라인 필요)이 실제로 결과를 좌우한다는 것을 보여준다. 즉 H1은 "작은 텔레메트리 모델 + Python 래퍼" 조건에서 기각될 가능성이 있으며, 모델 크기 스윕이 MVP의 필수 요소다.

## 4. 권장 실험 플랫폼

| 단계 | 플랫폼 | 목적 | 이 컨테이너 |
|---|---|---|---|
| S0 | 이 컨테이너 | 기능 통합, 스크립트·하네스 개발, 수치 동등성 | 가능 |
| S1 | 전용 ARM64 SBC, 코어 격리 + `SCHED_FIFO` | L1/L2/L3 지연 분포 | 불가 |
| S2 | 동일 HW + PREEMPT_RT, cFS 부하 동반 | 데드라인 미스, ΔR_cFS | 불가 |
| S3 | RISC-V (HPSC 방향 정합) 또는 RTEMS | 이식성·비행 근접성 | 불가 |

S1 최소 사양 제안: 4코어 이상 ARM64 SBC, 1코어를 `isolcpus`로 격리, `cpufreq` performance 고정, 온도 스로틀링 로깅. `platform_check.py`가 `PASS`를 반환해야 결과를 타이밍 증거로 인정한다.

## 5. 다음 작업 순서

1. `sbn_cfs_config.ini` 기반으로 cFS ↔ OnAIR 실연결(현재 CSV 경로만 검증됨).
2. `CompiledLearner` 플러그인 구현 — `AIPlugin` 상속, `update()`에서 입력 패킹, `render_reasoning()`에서 IREE 호출.
3. B2(TFLite Micro) 베이스라인 추가.
4. 모델 크기 스윕(1x32 MLP → 소형 1D-CNN)으로 컴파일 이득이 마샬링 오버헤드를 넘어서는 지점 탐색.
5. S1 하드웨어 확보 후 `platform_check.py` PASS 조건에서 본 측정.

## 6. 파일

```
scripts/00_env.sh          의존성 + mqueue 한계 상향 (검증됨)
scripts/10_build_cfs.sh    cFS 클론·빌드 (검증됨, 함정 주석 포함)
scripts/11_run_cfs.sh      cFS 기동 (exe 디렉터리에서 실행)
scripts/20_setup_onair.sh  OnAIR 설치 + CSV/Kalman 예제 실행 (검증됨)
scripts/30_setup_iree.sh   IREE 컴파일러/런타임 (검증됨)
models/mlp_1x32_64_2.mlir  최소 MLP (linalg.matmul 2단)
harness/compile_model.py   프로파일별 컴파일 + 매니페스트(실행시간 항목은 의도적으로 비움)
harness/run_learner.py     L1/L2/L3 경계를 분리한 지연 하네스
harness/platform_check.py  타이밍 실험 적격성 게이트 (PASS / FUNCTIONAL_ONLY)
contracts/contract.schema.json  계약 스키마 (boundary·bound_method 필수)
```
