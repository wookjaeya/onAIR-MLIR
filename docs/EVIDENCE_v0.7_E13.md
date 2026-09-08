# EVIDENCE v0.7 — 계약–아티팩트 결합, 계측 정정, 실패 처리, E13 코드 대응

선행: `EVIDENCE_v0.6_E11.md`, 외부 검토 `REVIEW_v0_6_E13_RESEARCH_DIRECTION.md`(2026-09-08)
검토 §9의 순서(1 계측 정정 → 2 계약–아티팩트 일치·계측 → 3 자원 회수 → 4 E13)를 그대로 수행했다. 5(대안 비교)는 미착수.

---

## 요약

- **TOPIC** — 계약이 "어느 아티팩트"에 대한 것인지를 gate가 스스로 확인하게 만들고(sha256 결합), v0.6의 계측 경계 오류를 고치고, 실패 경로의 자원 회수를 넣은 뒤, 계약을 만든 IR과 최종 실행 코드(LLVM IR·ELF)의 대응을 확인(E13).
- **Problem** — v0.6까지 gate는 "올바른 모델과 계약을 외부에서 함께 배치했다"는 가정 위에 있었다. 같은 ABI의 다른 모델로 파일만 바꿔도 통과했다. standalone 하네스는 전체 HAL 피크를 per-call 계약과 비교하는 지표 오류가 있었고, 호출당 할당량은 초기화 비용이 섞인 상각값이었다.
- **Solution** — 계약에 아티팩트 sha256·크기·유효 조건을 넣고 gate가 **IREE에 넘길 바로 그 바이트**를 해시해 비교하도록 했다. 모델 교체 공격은 standalone(exit 5)과 cFS 앱(기동 거부) 모두에서 **런타임 생성 전에** 거부된다. 정상 상태 호출당 할당은 **65,544 B(=65,536+8)** 로 검토 §5의 산식과 정확히 일치. E13에서 커널 LLVM IR은 alloca 0·외부 호출 0, ELF는 call 0·스택 프레임 0 — **커널 수준에서 HAL 계약 밖의 메모리는 없다.** 부수 발견: 같은 MLIR·같은 플래그라도 **입력 파일명이 다르면 vmfb 바이트가 달라진다** — 계약은 반드시 배치할 컴파일 호출과 같은 호출에서 생성해야 한다.

---

## 0. 증거 등급
플랫폼 `FUNCTIONAL_ONLY`. 지연은 방향성 관측. **해시 일치·허용/거부 판정·HAL 통계·IR/ELF 구조 분석은 결정론적.** RSS는 정수로 기록되지만 결정론적 보장이 아닌 **관측값**으로 취급한다(검토 §7 반영).

---

## 1. 계약–아티팩트 결합 (검토 §3)

### 1.1 변경
| 항목 | v0.6 | v0.7 |
|---|---|---|
| 계약 내용 | 메모리 수치만 | + `artifact.sha256`, `artifact.bytes`, `validity`(entry, 입출력 형상, driver, profile, 컴파일러·런타임 커밋, 가정, 결합 규칙) |
| 앱 상수 | CMake에 수동 복사 | `harness/gen_contract_header.py`가 `contract.json` → `contract_gen.h` 생성. standalone·cFS 앱 공용 |
| gate 순서 | 예산 판정 → 런타임 생성 → 파일 로드 | 예산 판정 → **파일 로드 → sha256(그 바이트) 비교** → 런타임 생성 → **같은 바이트**를 세션에 전달 |
| 불일치 시 | 없음 | standalone exit 5 / cFS `CFE_STATUS_EXTERNAL_RESOURCE_FAIL`, 런타임 미생성, cleanup |

### 1.2 검증 — 모델 교체 (검토 §3 최우선 사례)
모델 B = h=4096 베이킹(같은 1×9→1×2 ABI, 192,800 B), 계약 A = h=16384.

| 경로 | 결과 |
|---|---|
| E11c standalone | `admission ADMIT` → `binding CONTRACT_ARTIFACT_MISMATCH` (b0802902… ≠ 95e8caff…) → **exit 5, 런타임 미생성** |
| E12c cFS | 동일 판정 → EVS CRITICAL 5 → cleanup → `CFE_ES_ExitApp`; cFS OPERATIONAL |

**계약은 파일명이 아니라 바이트로 식별된다.**

### 1.3 부수 발견 — 컴파일 호출 동일성
E13에서 같은 MLIR·같은 플래그로 다시 컴파일한 vmfb의 해시가 계약 아티팩트와 달랐다(a48be5b8… vs 95e8caff…; ELF 5,160 vs 4,808 B, bytecode 3,440 vs 3,432 B). 원인은 입력 파일명이 실행 파일 심볼명(`module_<name>_linked_…`)에 들어가기 때문이다(본인 분석; 크기 차이가 이름 길이와 정합). **함의**: 계약 생성·실행 파일 덤프·배치 아티팩트는 **한 번의 컴파일 호출**에서 나와야 한다. E13은 이를 지켜 `-o`, `--mlir-print-ir-after`, `--iree-hal-dump-executable-files-to`를 한 호출에 묶었고, 그 호출의 vmfb에 대한 계약으로 standalone이 MATCH, 이전 아티팩트는 MISMATCH가 나왔다(양방향 확인).

---

## 2. 계측 정정 (검토 §4·§5)

| 지표 | v0.6 | v0.7 |
|---|---|---|
| 전체 HAL 피크 비교 대상 | `CONTRACT_PER_CALL_BYTES` (**오류**, 786,476 ≤ 65,580 = false) | **`CONTRACT_BOUNDED_BYTES`** → `peak_within_bounded = true` |
| 호출당 할당 | 누적/호출수 (초기 상수 포함 상각) | **정상 상태**: 워밍업 200회 후 카운터 차이 / 측정 횟수 → **65,544.0 B** = 65,536 + 8 (`steady_within_per_call = true`). 상각값 65,769도 병기 |
| 검증 boolean | summary에 없음 | `peak_within_bounded`, `steady_within_per_call`을 JSON에 포함 |

검토 §5 산식 재확인: E12 `hal_bytes_per_call_amortized` 94,381.3 = (720,932 + 65,544×25)/25 ✓.

---

## 3. 성공 판정·실패 처리·자원 회수 (검토 §6)

| 항목 | v0.7 |
|---|---|
| 카운터 | `attempted / completed / fail_input / fail_invoke / fail_output` 분리. 지연·통계는 completed만 집계 |
| E11b | 3,200/3,200 완료, 실패 0 |
| E12b | 25/25 완료, 실패 0 (ES HK 텔레메트리, 4 s 주기) |
| cleanup | `AI_LEARNER_Cleanup()`: 입력 버퍼 → 세션 → 디바이스 → 인스턴스 → blob(세션 해제 후, D4) 순 해제. 초기화 중간 실패 모든 지점과 정상 종료에서 호출 |
| E12d 모델 파일 부재 | `cannot open /cf/model.vmfb` → cleanup → 앱 종료, cFS OPERATIONAL |
| 알려진 사소 | 불일치 경로에서 cleanup이 2회 호출됨(Init 내부 + 종료). 멱등이라 무해; 기록만 |

**출력값 해석(검토 §6)**: 특징은 패킷 헤더 뒤 9바이트로 임무 의미가 없다. E12는 SB 수신→추론→기록의 **데이터 경로** 검증이지 판단 정확성 실험이 아니다.

---

## 4. E13 — 계약 IR ↔ LLVM IR ↔ 실행 코드 대응 (검토 §8)

### 4.1 방법
`iree-compile … --mlir-print-ir-after=iree-stream-layout-slices --iree-hal-dump-executable-files-to=<dir> -o model.vmfb` **한 호출**로 (a) 계약 IR, (b) 실행 파일 LLVM IR(`*.codegen.ll`), (c) 최종 vmfb를 얻고, vmfb에서 임베디드 ELF를 잘라 `objdump -d`. host(`--iree-llvmcpu-target-cpu=host`)와 generic 두 설정.

### 4.2 Q1 아티팩트 대응
| 설정 | vmfb sha256 | 계약(같은 호출) | standalone binding |
|---|---|---|---|
| host | a48be5b8… | bounded 786,476 = 65,580 + 720,896; rodata [720,896, 5,160] | **MATCH**; 이전 아티팩트(95e8caff…)는 **MISMATCH** |
| generic | 8fc68541… | (동일 메모리 수치) | — |

### 4.3 Q2 메모리 범위 — 계약 밖에 무엇이 있는가
| 관찰 | host | generic |
|---|---:|---:|
| LLVM IR `alloca` | **0** | **0** |
| LLVM IR `declare` (외부 심볼) | `llvm.assume`, `llvm.fmuladd.v32f32`, `llvm.fmuladd.v2f32` | `llvm.assume`, `llvm.fmuladd.v1f32` |
| `malloc`/`free` 참조 | 0 | 0 |
| ELF `call` 명령 | **0** | **0** |
| ELF 스택 프레임(`sub $N,%rsp`) | **없음** | **없음** |
| 함수 | 2 dispatch + `iree_hal_executable_library_query` | 동일 |

**결론(시험 모델 한정)**: 커널 임시값은 레지스터에 있고, 힙·스택 프레임·외부 호출이 없다. 따라서 **커널 수준에서 HAL 계약(bounded_bytes) 밖에 놓이는 메모리는 없다.** 검토 §8의 경고대로 이것을 "런타임 전체에 동적 할당이 없다"로 확장하지 않는다 — 런타임 컨텍스트(잔차)는 여전히 계약 밖이며 별도 확보 대상이다.

### 4.4 Q3 코드 생성 차이 — E4/E5/E6b "원인 미상" 해소
| 항목 | host | generic |
|---|---:|---:|
| ELF 크기 / 명령 수 | 5,160 B / 122 | 4,872 B / 111 |
| 벡터 레지스터 참조 xmm/ymm/zmm | 57 / 0 / **49** | 42 / 0 / **0** |
| FMA (`vfmadd231ps`) | **34** | **0** |
| 스칼라 곱 (`mulss`) | 0 | **9** |
| LLVM IR 벡터 폭 | `<32 x float>` fmuladd | `<1 x float>` fmuladd |

E6b에서 generic 군집이 host 대비 1.8–2.6× 느렸던 이유가 **명령어 수준에서** 확인됐다: generic은 타깃 CPU 미지정으로 baseline x86-64(SSE2)만 가정해 32-폭 벡터 FMA 대신 스칼라 `mulss/addss`를 생성한다. 이것은 성능 **원인의 구조적 근거**이며, 검토 §8대로 명령 수로 WCET나 정확한 속도비를 주장하지는 않는다.

### 4.5 계약과 무관함의 재확인
host·generic의 계약 메모리 수치는 동일(786,476)하고 실행 코드만 다르다 — E6c "정적 상한은 lowering 설정 불변"의 코드 수준 근거.

---

## 5. 표현 수정 (검토 §7)

| v0.6 표현 | v0.7 |
|---|---|
| RSS 분해는 결정론적 | 관측값. 절차·시점·상주 상태에 의존 |
| 41.5 → 4.3 MB는 Python 제거 효과 | Native 경로의 작은 footprint는 유효한 관측이나, 최소 런타임 구성 변경도 포함되어 단일 원인 귀속 불가 |
| cFS init delta 1,888 KB = 앱 비용 | 프로세스 전체 RSS 차이(다른 앱 초기화 병행, SB 파이프 생성 전 측정). 앱 전용 비용 아님 |
| 32 → 125 µs는 희소 호출·캐시 냉각 | 측정 경계 상이(워밍업 후 median vs cFS 평균). 호출 간격·캐시는 **검증할 설명 후보** |
| 거부 시 타 앱 무영향 | 해당 상황에서 cFS 기동과 관측한 앱 초기화 유지. 타 앱 기능·응답시간 무영향은 미검증. 양 로그에 HS 시스템 모니터 초기화 오류 존재(AI 앱과의 인과 근거 없음, 전 앱 정상 근거도 없음) |
| gate는 "모든 할당 이전" | **IREE 초기화 이전**이다. cFS 공유 객체·태스크 자체 할당 이후 |

---

## 6. 판정 (v0.7)

| 항목 | v0.6 | **v0.7** |
|---|---|---|
| 계약 적용 대상 | 외부 가정 | **gate가 바이트 해시로 확인**; 모델 교체 2경로 거부 |
| 계측 경계 | per-call 지표 오류 | 전체 피크↔bounded, 정상 상태 per-call 65,544 ↔ per-call 계약 |
| 실패 처리 | 없음 | 단계별 카운터, cleanup, 로드 실패 시 회수 |
| 커널 수준 계약 밖 메모리 | 미확인 | **없음** (alloca 0, call 0, 스택 프레임 0; 시험 모델 한정) |
| 설정별 지연 차이의 원인 | 측정만 | **AVX-512 FMA vs 스칼라** 구조적 근거 |
| 컴파일 호출 동일성 | 미인식 | **필수 규칙**으로 확정 |
| H1/H2/H3 | — | 변화 없음. H3 메모리 축: 결합·실패 처리·코드 대응까지 확장된 검증 범위 |

### 중심 문장 (검토 §9 권고 반영)
> 부분 메모리 계약을 Native 실행과 cFS 초기화 gate에 연결하고, 시험한 모델에서 허용·거부 경로와 HAL 피크의 일치를 확인했다. gate는 계약을 아티팩트 바이트 해시로 결합해 모델 교체를 런타임 생성 전에 거부하며, 정상 상태 호출당 할당·단계별 실패·자원 회수를 계측한다. 계약을 만든 IR과 최종 실행 코드의 대응을 같은 컴파일 호출에서 확인했고, 시험 모델의 커널에는 힙·스택·외부 호출이 없었다. 동일 경계의 대안 비교는 후속 대상이다.

---

## 7. 결함 원장 추가

| ID | 결함 | 발견 | 영향 | 조치 |
|---|---|---|---|---|
| D5 | standalone이 전체 HAL 피크를 per-call 계약과 비교 (`per_call_within_contract=false`) | 검토 §4 | v0.6 summary 누락, 소스-요약 불일치 | bounded 비교 + 정상 상태 per-call 분리 |
| D6 | 계약이 아티팩트를 식별하지 않음 (파일 교체로 통과) | 검토 §3 | v0.6 gate 보장은 조건부 | sha256·크기 결합, 헤더 자동 생성 |
| D7 | 호출당 할당이 초기화 비용 포함 상각값 | 검토 §5 | 지표 의미 오해 | 정상 상태 카운터 차이 |
| (규칙) | 계약·덤프·배치 아티팩트는 한 컴파일 호출에서 | E13 §1.3 | 재컴파일 시 해시 불일치 | 파이프라인 규칙으로 명문화 |

---

## 8. 재현
```bash
python3 harness/gen_contract_header.py contracts/contract.filled.example.json native/contract_gen.h
cd native && bash build.sh ../contracts/contract.filled.example.json
./native_learner model_16384_baked.vmfb 1048576 3000        # E11b MATCH
./native_learner <model_B_4096.vmfb> 1048576 100           # E11c MISMATCH exit 5
# E12b/c/d: native/cfs_app/WIRING.md ; logs in native/results/cfs_run_{A_match,B_mismatch,missing_model}.log
# E13:
iree-compile e13/m16k_baked.mlir --iree-hal-target-backends=llvm-cpu --iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu \
  --iree-llvmcpu-target-cpu=host --mlir-print-ir-after=iree-stream-layout-slices \
  --iree-hal-dump-executable-files-to=e13/host -o e13/host/model.vmfb
```
산출물: `contracts/contract.e13_host.json`, `e13/{host,generic}/{*.codegen.ll,kernel.elf,kernel.objdump.txt}`, `native/results/summary.json`
