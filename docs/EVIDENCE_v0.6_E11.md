# EVIDENCE v0.6 — E11 Native 변형, E12 cFS 앱 통합

선행: `EVIDENCE_v0.5_E9.md`(E9·E10·D3), 외부 검토 `REPORT_v0_4_REVIEW.md` §8·§9-4
본 문서는 검토 §9의 4번째 항목 "Native-cFS 연결: 부분 메모리 계약이 실제 앱의 예산 배정과 결합되는 방식"을 실증한다.

---

## 요약

- **TOPIC** — Python·NumPy 없이 IREE 런타임을 C로 직접 구동하는 Native 변형(E11)과, 이를 cFS 앱 `AI_LEARNER`로 통합해 앱 초기화 시 계약 vs 예산 admission을 수행하는 구성(E12).
- **Problem** — v0.5까지의 모든 측정은 Python 플러그인 경로였다. cFS 앱 배치에서 (1) 계약의 bounded_bytes가 실제 런타임 피크와 여전히 일치하는지, (2) admission이 앱 기동을 실제로 막을 수 있는지, (3) Python 제거 시 메모리·지연이 어떻게 되는지는 미확인이었다.
- **Solution** — (1) Native 런타임에서 HAL 피크 = **786,476 B = bounded_bytes 정확히** (상수가 allocator를 통과하는 구성에서도 경계 (b)가 성립), (2) cFS 앱 초기화에서 NOT_ADMITTED 시 **앱만 기동 거부되고 cFS는 OPERATIONAL 유지**, ADMIT 시 실제 ES HK 텔레메트리 패킷으로 추론 수행, (3) 프로세스 RSS 41.5 MB → **4.3 MB**, L1 median 38.9 → **32.2 µs**.

---

## 0. 증거 등급

플랫폼 `FUNCTIONAL_ONLY`(ratio_p99 1.67). 지연 절대값은 방향성 관측. **HAL 피크·admission 판정·RSS 분해는 결정론적 또는 정수 비교**이며 잡음 규칙 비적용.

---

## 1. 환경 (재현 조건)

| 항목 | 값 |
|---|---|
| IREE 런타임 | 소스 빌드, **컴파일러와 동일 커밋 e4a3b04** (3.11.0rc20260316). 최소 구성: local-sync 드라이버, embedded ELF loader, 스레딩 없음, ukernel 없음 → 195 오브젝트, 22 s |
| PIC | cFS 앱은 `.so`이므로 `-DCMAKE_POSITION_INDEPENDENT_CODE=ON` 재빌드 |
| 계약 주입 | `contract.filled.example.json`의 bounded/per_call/constants를 `-D`로 컴파일 시 주입 |
| 모델 | h=16384 베이킹 가중치, `cpu_host` 프로파일, vmfb 733,472 B |
| cFS | 번들 native_std, 앱 `apps/ai_learner`, 우선순위 55, 스택 256 KiB, `CFE_ES_HK_TLM_MID` 구독(sch_lab이 4 s마다 발행) |

---

## 2. E11 — Native 표준 C 변형 (standalone)

### 2.1 설계
`native/native_learner.c`: (1) **런타임 생성 이전에** `CONTRACT_BOUNDED_BYTES ≤ budget` 판정, 미허용 시 exit 3; (2) instance→device(local-sync)→session→module 순으로 올리며 각 단계 RSS 기록; (3) 입력 버퍼 1회 할당 후 재사용; (4) 3,000회 추론 지연 + HAL allocator 통계.

### 2.2 결과

| 항목 | 값 |
|---|---:|
| admission 1 MiB / 256 KiB | ADMIT / **NOT_ADMITTED (exit 3, 런타임 미생성)** |
| 경계값 786,475 / 786,476 | NOT_ADMITTED / ADMIT |
| L1 median / p99 / max | **32.23 / 54.07 / 2514 µs** (max는 플랫폼 잡음) |
| HAL `device_bytes_peak` | **786,476 B** |
| HAL bytes/call | 65,769 (per-call 65,580 + 초기 상수 할당 상각) |
| RSS 분해 | 런타임 224 KB · 모듈 로드 1,592 KB · 추론 220 KB · **총 2,036 KB** |
| 프로세스 RSS | **4,316 KB** (Python 워커 41,556 KB) |

### 2.3 핵심 발견 — 경계 (b)의 견고성
Python 바인딩에서는 상수가 매핑되어 HAL 피크가 65,580이었으나, **Native 런타임에서는 상수 720,896 B가 device allocator를 통해 할당**되어 피크가 786,476이 됐다. 상수가 allocator를 지나는지는 런타임 구성이 결정하지만, **`bounded_bytes = per-call + 상수`는 두 경우 모두를 정확히 덮는다.** v0.4의 경계 결정이 구현 차이에 대해 견고함이 실증됐다.

### 2.4 부수 관측
모듈 로드 1,592 KB는 vmfb를 `malloc`으로 읽은 사본(733 KB)과 device 복사(704 KB)가 **동시에** 존재하기 때문이다. 임베디드 rodata(`objcopy`) 또는 `mmap`으로 사본을 없애면 약 700 KB 절감 가능 — 후속 항목.

### 2.5 결함 D4 (하네스)
모듈 바이트를 세션 해제 **전에** `free` → 해제 시 `iree_vm_bytecode_module_lookup_function`에서 segfault. `iree_allocator_null()`로 넘긴 데이터는 세션이 zero-copy 참조한다. 순서 수정으로 해소. 결과에 영향 없음(크래시 이전에 측정 완료).

---

## 3. E12 — cFS 앱 `AI_LEARNER`

### 3.1 설계
`native/cfs_app/fsw/src/ai_learner.c`:
- `AI_LEARNER_Init`: EVS 등록 → **admission(계약 vs `AI_LEARNER_BUDGET_BYTES`)** → 미허용 시 CRITICAL 이벤트 + `CFE_STATUS_EXTERNAL_RESOURCE_FAIL` 반환(앱 기동 거부) → 허용 시 IREE 런타임 생성 → `/cf/model.vmfb` 로드(`OS_TranslatePath`) → SB 파이프·구독.
- 메인 루프: `CFE_ES_RunLoop` + `CFE_SB_ReceiveBuffer(1 s)`; 패킷 수신마다 헤더 뒤 9바이트를 특징으로 추론; 5회마다 EVS 이벤트 + JSON 2줄(run/mem).

### 3.2 결과 — ADMIT 구성 (예산 1 MiB)

```
{"stage":"admission","verdict":"ADMIT","bounded":786476,"budget":1048576,"per_call":65580,"constants":720896}
EVS 66/1/AI_LEARNER 3: AI_LEARNER initialized: model 733472 B, rss_delta_init=1888 KB
EVS 66/1/AI_LEARNER 4: AI_LEARNER n=25 mean=125.3us max=193.8us hal_peak=786476 within_contract=1
{"stage":"mem","n":25,"hal_peak":786476,"hal_bytes_per_call":94381.3,"peak_within_bounded":true,"rss_kb":8392,"rss_delta_init_kb":1888}
```

- 실제 cFS SB 트래픽(ES HK 텔레메트리, 4 s 주기)으로 25회 추론.
- **HAL 피크 786,476 = bounded_bytes**, `peak_within_bounded=true` 지속.
- 앱 초기화 RSS 증가 1,888 KB (Native standalone의 런타임+모듈 로드 1,816 KB와 정합).
- 지연 mean 125 µs — standalone 32 µs의 약 4배. 4 s 간격 호출은 캐시가 식고 cFS 다른 태스크와 공존하므로 예상 범위. **희소 호출이 per-call 지연을 키운다**는 점은 이전에 지적한 데이터율 의존성(검토 C2)과 정합.

### 3.3 결과 — NOT_ADMITTED 구성 (예산 256 KiB)

```
EVS 66/1/AI_LEARNER 1: AI_LEARNER NOT_ADMITTED: contract bounded=786476 > budget=262144; app will not start
{"stage":"admission","verdict":"NOT_ADMITTED","bounded":786476,"budget":262144}
CFE_ES_ExitApp: Application AI_LEARNER called CFE_ES_ExitApp
EVS 66/1/CFE_ES 14: ErrExit Application AI_LEARNER Success.
```

- 앱은 **런타임 생성 전에** 종료. 이후 로그에서 `CFE_ES_Main entering OPERATIONAL state`, SAMPLE_APP·LC 정상 초기화 확인 → **거부가 다른 앱·cFS 코어에 영향 없음.**

### 3.4 검토 §8 요구사항 대응
검토는 "런타임 컨텍스트·스택·파이프 비용을 별도 확보하고 남은 영역을 모델 버퍼·상수 예산으로 배정하는 연결"을 요구했다. E12에서 그 연결은 `AI_LEARNER_BUDGET_BYTES`(앱 설정) ↔ `CONTRACT_BOUNDED_BYTES`(컴파일러 산출)의 비교이며, 스택(256 KiB, 기동 스크립트)·파이프(깊이 8)·런타임 잔차(≈224 KB, E11 측정)는 예산 **밖**에서 별도 확보된다. 즉 부분 계약과 앱 예산의 결합 방식이 코드로 고정됐다.

---

## 4. 판정 (v0.6)

| 항목 | v0.5 | **v0.6** |
|---|---|---|
| Native-cFS 예산 연결 (검토 §9-4) | 미착수 | **구현·실행 검증**: ADMIT 경로 추론 25회, NOT_ADMITTED 경로 앱 기동 거부, cFS 무영향 |
| 경계 (b) | 구현 1종에서 검증 | **런타임 구성 2종**(상수 매핑 / 상수 할당)에서 bounded_bytes 일치 |
| "Python 제거" 후속 가설 | 미검증 | **측정됨**: RSS 41.5 → 4.3 MB, L1 median 38.9 → 32.2 µs (standalone). 교환 관계를 같은 경로에서 서술 가능 |
| H1 | 성능 우위 미관측 | 변화 없음 (Native도 NumPy/BLAS 대비 1.84× 느림) |
| H3 (메모리 축) | 시험 조건 내 성립 | **cFS 앱 배치 형태에서도 성립** (시험 조건: 단일 앱, 단일 모델, native_std) |
| 중심 문장 | "OnAIR IREE 아티팩트의 부분 메모리 계약·판정기 구현·검증" | **"…판정기를 구현·검증했고, 동일 계약을 cFS 앱 초기화 admission에 연결해 허용·거부 양 경로를 실행 검증했다"** |

---

## 5. 한계 (반드시 함께 인용)

| 한계 | 영향 |
|---|---|
| cFS native_std(Linux POSIX OSAL) | RTEMS/VxWorks 실기와 메모리 회계 상이. 계약 비교 논리는 OS 독립적이나 잔차 수치는 아님 |
| 단일 앱·단일 모델·희소 호출(4 s) | 다중 AI 앱 동시 admission, 고빈도 호출은 미시험 |
| 예산이 컴파일 시 상수 | 런타임 예산 변경·재협상 없음 |
| 특징 추출이 임의(헤더 뒤 9바이트) | 기능적 의미 없음; 데이터 경로 검증 목적 |
| 지연은 FUNCTIONAL_ONLY 플랫폼 | 절대값 인용 불가 |
| vmfb 사본 이중 존재 | 모듈 로드 RSS 과대(≈700 KB) — 최적화 여지, 계약 범위 밖 |

---

## 6. 결함 원장 추가

| ID | 결함 | 발견 | 영향 | 조치 |
|---|---|---|---|---|
| D4 | 세션 해제 전 모듈 데이터 free → 해제 시 segfault | E11 gdb 백트레이스 | 하네스 종료 단계만; 측정값 무영향 | 해제 순서 수정, WIRING.md에 기록 |

---

## 7. 재현

```bash
# IREE runtime (same commit as compiler), minimal, PIC
cd iree-src && git checkout e4a3b04 && mkdir build-rt && cd build-rt && cmake .. -G Ninja \
  -DIREE_BUILD_COMPILER=OFF -DIREE_HAL_DRIVER_DEFAULTS=OFF -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
  -DIREE_HAL_EXECUTABLE_LOADER_DEFAULTS=OFF -DIREE_HAL_EXECUTABLE_LOADER_EMBEDDED_ELF=ON \
  -DIREE_ENABLE_THREADING=OFF -DIREE_BUILD_UKERNELS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  && ninja iree_runtime_impl iree_hal_drivers_local_sync_sync_driver iree_hal_local_loaders_embedded_elf_loader iree_vm_bytecode_module iree_modules_hal_hal flatcc_parsing flatcc_runtime printf_printf
# E11
cd native && bash build.sh && ./native_learner model_16384_baked.vmfb 1048576 3000
# E12: see native/cfs_app/WIRING.md
```
산출물: `native/results/summary.json`, `native/results/cfs_run_admit.log`, `native/results/cfs_run_deny.log`
