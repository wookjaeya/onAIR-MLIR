# E54 계획 — 참조 기반 메모리 예산과 모델 admission 매트릭스

- 근거: `docs/reviews/BUDGET_BASED_ADMISSION_ANALYSIS.md`(연구 책임자 지시, 커밋 `c08d790`에 원문 보존)
- 이 문서는 **측정·구현 이전에 커밋**한다(작업 규율). 기준 커밋: `c08d790`.
- 대상 버전: **v0.57 / E54**

## §0 이 실험이 답하는 것과 답하지 않는 것

지시 문서 §1이 남은 질문을 하나로 못박았다:

> 모델과 독립적으로 산정된 배치 메모리 예산을 적용했을 때, 네 실제 모델의 ADMIT/DENY 결과가
> 어떻게 달라지는가?

**답하는 것**: 외부 근거(플랫폼 RAM·NASA 생명주기 마진)와 동일 환경 실측(cFS 기준선·계약 외 AI
오버헤드)에서 유도한 예산을 기존 admission 판정기에 입력했을 때 네 실물 모델의 AArch64 cFS
ADMIT/DENY와 그 실행 결과(런타임 생성 여부·추론 횟수·승인 셀의 HAL peak).

**답하지 않는 것**(지시 §5.2가 반복을 금지한 항목): 계약 생성 · 모델 변환 · 의미 동치 · 컴파일.
네 모델의 AArch64 계약·vmfb·헤더는 **이미 커밋된 산출물을 해시로 참조**하며 재컴파일하지 않는다.
또한 **조건부 계층(map arm)은 다루지 않는다** — 게스트에 배포된 네 변종이 전부
`allow_conditional_map:0`이고, 이 실험은 무조건 계층의 예산 판정을 묻는다.

**이 실험이 주장하지 않는 것**: 예산이 물리 RAM을 *예약*한다는 것(E44: 예산은 부여된 값이고
예약 호출은 소스 85파일에서 0건) · 관측 HAL peak가 프로세스 RSS와 같다는 것(D78) · AArch64 게스트가
어떤 비행 하드웨어의 재현이라는 것(`docs/reviews/BENCHMARK_PLAN_REFERENCE_BASED.md:156`).

## §1 착수 전 확인 (측정 아님 — 이 절의 값은 전부 이 세션에서 직접 재확인했다)

### 1.1 외부 근거의 도달 가능성 — 지시 문서가 인용한 1차 출처는 **전부 차단됐다**

지시 문서가 URL로 인용한 네 NASA 출처를 `harness/e39b_prior_art_fulltext.py:213`의 프로브 관용구
(curl + `%{http_code}`)와 **WebFetch 두 경로로** 각각 시험했다. 전부 실패했다.

| 출처 | curl | WebFetch |
|---|---|---|
| SWE-109 (swehb.nasa.gov) | `000` (rc=56, CONNECT 403) | `EGRESS_BLOCKED` |
| 9.12 Resource Margins (swehb.nasa.gov) | `000` (rc=56) | `EGRESS_BLOCKED` |
| NPR 7150.2D Ch.5 (nodis3.gsfc.nasa.gov) | `000` (rc=56) | `EGRESS_BLOCKED` |
| SWE-111 (swehb.nasa.gov) | `000` (rc=56) | `EGRESS_BLOCKED` |

추가로 시험한 경로도 전부 차단: `ntrs.nasa.gov`·`standards.nasa.gov`·`www.nasa.gov`(양 경로),
`web.archive.org`, `r.jina.ai`, GitHub 코드 검색 8회, WebSearch. **따라서
"이 문서를 조달할 수 없다"가 아니라 "이 호스트들이 이 N개 경로에서 차단됐다"로 적는다**(D74/E45, E47).

**도달한 것 하나**: NPR 7150.2**C** 전문 미러를 커밋 고정 URL로 받았다 —
`raw.githubusercontent.com/aadityc91/TechChunkBench/be6d54100ce27d1b002edea999aa3db75a327ab0/data/processed/nasa_std.txt`,
HTTP **200**, 329,340 B, sha256 `273aeb15c93e2183b3ae610c449854fa3808128ac38872cac4ab852dd265cb7d`
(이 세션에서 직접 받아 해시 확인). `5.4.5 … [SWE-199]`와 그 note(계획·실측 자원 사용량을 추적해
마진과 비교)가 들어 있다. **개정 C이지 D가 아니다.**

**결정적 한계**: GSFC RAM 마진 백분율(SRR 50 / PDR 50 / CDR 40 / Ship-Flight 30)은 **이 컨테이너가
받은 어떤 바이트에도 없다**. 따라서 이 값은 **1차 출처 인용이 아니라 in-repo 지시 문서에서 전사한
값**이며, 등급을 분리해 기록한다.

**출처 등급 어휘**(E39b가 `fulltext`/`project_doc_fulltext`를 분리한 것과 같은 이유):

| 등급 | 뜻 | 이 실험에서 해당 |
|---|---|---|
| `primary_fetched` | 1차 출처를 실제로 받았다 | 플랫폼 두 건(§1.2) |
| `mirror_adjacent_revision_fetched` | 받았으나 인접 개정본 미러다 | NPR 7150.2C |
| `transcribed_from_directive_primary_blocked` | 1차가 차단돼 지시 문서에서 전사 | **마진 백분율** |

### 1.2 플랫폼 — 두 건 모두 이 세션에서 직접 받아 본문을 읽었다

| 프로파일 | 플랫폼 | R_physical | ISA | 출처(HTTP 200, 직접 확인) |
|---|---|---:|---|---|
| **P-A** | Xiphos **Q8S** | 4 GiB = **4,294,967,296 B** | **AArch64** (quad Cortex-A53 ≤1.2 GHz, Zynq UltraScale+ XCZU7EG) | satcatalog S3 미러 PDF, sha256 `24f13dab…d5d`. 본문: *"Memory … 4GB LPDDR4 DRAM (with EDAC)"*, *"Quad-core ARM Cortex-A53 Application Processing Unit"*, *"Space-Qualified Software and Logic"* |
| **P-B** | OPS-SAT **SEPP** 봉투 | 1 GiB = **1,073,741,824 B** | **ARM 32-bit**(Cortex-A9 계열) | `georgeslabreche/opssat-smartcam@be09ece` README:75 *"The SEPP is a powerful ALTERA Cyclone V with a 800 MHz CPU clock and 1GB DDR3 RAM."*, :97 *"the spacecraft's SEPP processor (ARM 32-bit)"* |

- P-A는 **이 게스트의 `-cpu cortex-a53`와 같은 코어**이고 유일하게 "AArch64 × 우주 인증 × 도달 가능"을
  동시에 만족한다. 벤더 사이트(`xiphos.com`)는 `000`이라 **미러임을 명시**한다. 데이터시트가 적은 것은
  *"first flight … planned for Q3 2019"*이며, 비행 실적 연도는 이 문서에서 확인되지 않으므로 쓰지 않는다.
- P-B는 **우리 모델 둘(SmartCam·WGAN)이 실제로 실린 플랫폼**이라 provenance가 가장 강하지만 **ISA가
  다르다**. 그래서 P-B는 플랫폼 재현이 아니라 **RAM 봉투(envelope)**로만 쓰고,
  `BENCHMARK_PLAN_REFERENCE_BASED.md:156`의 금지를 그대로 승계한다.
- **배제한 후보와 사유(경로와 코드를 함께 적는다)**: NVIDIA Jetson(`developer.nvidia.com` 000,
  데이터시트 PDF 000) · Raspberry Pi CM4(`raspberrypi.com` 000, `datasheets.raspberrypi.com` 000,
  docs API 403) · Unibap iX5(satcatalog 403, `unibap.com` 000) · MLPerf Tiny STM32L4R5ZI
  (`st.com` 000, 그리고 Cortex-M4라 AArch64가 아니다). **RAM 수치를 기억에서 인용하지 않는다.**

### 1.3 게스트 환경 (R_physical이 **아니다** — 실행 가능성의 천장일 뿐)

실행 중인 게스트는 스크립트 기본값(`MEM=1024`)이 아니라 **`-m 1536`**으로 떠 있고,
게스트 `MemTotal` = **1,523,044,352 B**(이 세션 실측). 이 값은 **참조 플랫폼의 R_physical이 아니며**,
승인 셀이 실제로 돌 수 있는지만 제한한다(최대 `U`가 135.7 MB이므로 제한되지 않는다).

### 1.4 모델 — 커밋된 AArch64 산출물 (재컴파일 없음, 전부 이 세션에서 계약에서 직접 읽음)

| 모델 | `U` = `bounded_bytes` | `per_call` | `constants` | vmfb bytes | 배포 스택 `CONTRACT_KERNEL_STACK_BYTES` | 계약 경로 |
|---|---:|---:|---:|---:|---:|---|
| b2_resnet | 618,856 | 309,416 | 309,440 | 343,538 | 1,232 | `results/e36b_aarch64_models/b2_resnet/b2_resnet.contract.json` |
| b3_deepae | 1,069,632 | 6,208 | 1,063,424 | 1,080,730 | 16 | `results/e36b_aarch64_models/b3_deepae/b3_deepae.contract.json` |
| smartcam | 18,222,796 | 9,382,092 | 8,840,704 | 8,991,281 | 1,919 | `results/e32_smartcam_aarch64/build/smartcam.contract.json` |
| wgan | 135,666,432 | 131,382,784 | 4,283,648 | 4,321,533 | 880 | `results/e53_wgan_aarch64/build/aarch64/wgan.contract.json` |

네 계약 전부 `aarch64-unknown-linux-gnu` · `bound_method=static_from_stream_layout` ·
`constants_confirmation_state=confirmed` · `provenance.overrides_applied=[]`(0건).

**스택 값의 출처를 못박는다**(D90 계열 — 같은 개념의 두 철자): 계약에는
`kernel_task_stack_bytes`(프레임)와 `kernel_task_stack_invocation_bytes`(복귀주소 포함) 둘이 있고
값이 다를 수 있다(smartcam 1,856 vs 1,919). **배포 헤더가 싣는 값은 invocation 쪽**이다
(`harness/gen_contract_header.py:288`이 그 필드를 우선하고 없을 때만 다른 쪽으로 폴백). 위 표의
스택 열은 **헤더에 실제로 박힌 값**이다.

**범위 한정**: 네 계약 중 E40의 `analysis_domain` 블록을 싣는 것은 **wgan 하나뿐**이다. 따라서
map/copy 두 분기와 64바이트 정렬 전제에 관한 서술은 **wgan에만** 붙일 수 있고 나머지 셋에는 붙일 수
없다. (E49가 *"계약 30개 중 1개"*로 센 수치는 E46·E53 이후 **35개 중 2개**로 갱신된다 — 이 실험이
세어 확인한 값이며, E49 §축 C의 서술을 그만큼 갱신한다.)

## §2 예산 산정 — **측정 전에 고정하는 식과 입력**

### 2.1 식 (지시 §4, 그대로 채택)

```
R_usable(p)            = R_physical(p) × (1 − M_phase)
B_AI(p)                = R_usable(p) − R_OS/cFS − R_other_apps − R_reserved
B_contract(p, model)   = B_AI(p) − R_noncontract_AI(model)
ADMIT(model | p)       ⟺  U(model) ≤ B_contract(p, model)
```

`R_noncontract_AI`가 모델에 의존하므로 `B_contract`도 (프로파일, 모델) 쌍이다. 이것은 지시 §4.3의
식을 그대로 적용한 결과이며(모듈 이미지 크기 자체가 모델마다 다르다), **U를 보고 조정하는 것이
아니다** — 대수적으로는 `U(m) + R_noncontract_AI(m) ≤ B_AI(p)`, 즉 *"그 모델의 총 발자국이 AI에
배정된 예산에 들어가는가"*다.

### 2.2 마진 프로파일 (지시 §5.3: 둘 이상)

**PDR 50%** 와 **Ship/Flight 30%** 를 쓴다 — 전사한 표(SRR 50 / PDR 50 / CDR 40 / Ship 30)에서
SRR 이후 구간의 양 극단이다. 등급은 `transcribed_from_directive_primary_blocked`.

### 2.3 `R_noncontract_AI` — **계약 자신의 제외 목록에서 만든다**

RSS 델타(`process_rss_delta_init_kb`)를 그대로 쓰지 않는다. 그 델타는 모듈 append와 (copy arm에서)
상수 복사를 포함해 **`U` 안의 바이트와 겹칠 수 있고**, 겹친 채로 빼면 D78을 실험 수준에서 되풀이한다.
대신 계약이 **스스로 제외한다고 적은 항목**만 더한다:

```
R_noncontract_AI(m) = IREE_fixed_runtime_ctx        (계약 scope: "excludes IREE runtime context (VM, HAL device, module tables)")
                    + artifact.bytes(m)             (모듈 이미지 상주 — D78/`excluded_module_image`)
                    + AI_LEARNER_STACK_BASE_BYTES (262,144) + CONTRACT_KERNEL_STACK_BYTES(m)
                                                   (계약 scope: "and the task stack")
                    + app_io_buffers(m)             (앱의 static I/O 버퍼: 4·in + 4·out + 16·out — D52/D75)
```

`IREE_fixed_runtime_ctx`는 보관된 AArch64 `mem_init` 레코드에서
`rss_kb_after_session − rss_kb_before_runtime`로 **유도**한다(재측정 없음). `before_runtime`이 blob을
읽고 해시한 **뒤** 표본된다는 것이 이 유도를 가능하게 하는 성질이며(`ai_learner.c:413-420, 446`),
그래서 모듈 이미지가 이 항에 이중 계상되지 않는다.

### 2.4 새로 측정해야 하는 것 — **모델도 예산도 개입하지 않는 측정**

| ID | 측정 | 방법 | 왜 새로 재야 하나 |
|---|---|---|---|
| **M1** | 게스트 `MemTotal` | 게스트에서 `/proc/meminfo` | 이미 실측(§1.3). 보관 기록에는 없었다 |
| **M2** | `R_OS/cFS` | **AI_LEARNER를 뺀** `cfe_es_startup.scr`로 cFS를 띄우고 `core-cpu1` 프로세스 RSS의 관측 peak를 게스트 셸에서 표본(`ps -o rss=`) | **보관된 AArch64 cFS 로그 전부에 AI_LEARNER가 들어 있다.** 빼서 역산하면 8셀에 1,387 KB 폭이 생겨 측정이 아니라 추정이 된다 |
| **M3** | `R_other_apps` | 최소 앱 집합 startup으로 한 번 더 표본해 M2와 분리 | cFS native_std는 13개 앱을 **한 프로세스**에 `.so`로 적재하므로 VmRSS 하나에 전부 접힌다. 분리되지 않으면 **0이 아니라 "분리 불가"로 기록**한다(D29/D51/D68) |

`R_reserved`는 지시 §4.2대로 **임무가 명시한 값이 없으므로 0으로 두고 그 사실을 기록**한다. OPS-SAT
문서에서 실험 앱별 메모리 할당량을 찾았으나 **없었다**(SmartCam README 전문 검색).

### 2.5 회계 범위의 화해 — **이 실험의 핵심 방법론 결정**

`B_AI`는 프로세스/시스템 RAM 범위이고 `U`는 **HAL 디바이스 할당** 범위다. 둘을 그냥 비교하면 D78을
실험 수준에서 되풀이한다. 이 배포에서 화해가 성립하는 근거는 하나다:

> 이 배포의 IREE 드라이버는 `local-sync`이고 HAL 할당자는 **같은 프로세스 안의 heap 할당자**다
> (E29가 `iree_hal_heap_buffer_wrap()`/`buffer_heap.c`로 분기 결정 요인을 규명했고, D78이 상수
> 바이트가 모듈 이미지 안에서 프로세스 RAM에 상주함을 기록했다). 따라서 **HAL 할당 바이트는 프로세스
> RSS의 부분집합**이고, `B_contract`(프로세스 RAM에서 계약 외 항목을 뺀 잔여)와 `U`(HAL 상한)의
> 비교는 **충분조건 시험으로서 건전하다**.

**그러나 이것이 허가하지 않는 것**: `HAL peak == RSS`(D78이 같은 계약에서 1.87× 괴리를 기록한다) ·
예산이 물리 메모리를 예약한다는 것(E44) · 다른 드라이버·다른 할당자 배포로의 일반화.

## §3 셀 — **측정 전 고정**

### 3.1 Part 1 — 참조 기반 매트릭스 (**주 증거**)

2 플랫폼 × 2 마진 = **4 프로파일** × 4 모델 = **16 셀**.

| 프로파일 ID | 플랫폼 | 마진 |
|---|---|---|
| `PA_pdr50` | Q8S 4 GiB | 50% |
| `PA_ship30` | Q8S 4 GiB | 30% |
| `PB_pdr50` | SEPP 봉투 1 GiB | 50% |
| `PB_ship30` | SEPP 봉투 1 GiB | 30% |

각 셀: `AI_LEARNER_BUDGET_OVERRIDE = B_contract(p, m)`로 AArch64 cFS 게스트에서 실행.

### 3.2 Part 2 — 민감도 스윕 (**보조, 지시 §8.2가 허용한 범위에서 분리 기록**)

모델당 **2의 거듭제곱 격자에서 `U`를 감싸는 두 예산**: `2^k < U ≤ 2^(k+1)`의 두 값.
이 격자는 **모델과 무관하게 고정**돼 있으므로 `U−1`과 달리 *모델 계약값의 함수가 아니다* — 지시 §7이
`U−1`에 대해 지적한 약점이 여기서는 성립하지 않는다.

| 모델 | DENY 쪽 `2^k` | ADMIT 쪽 `2^(k+1)` |
|---|---:|---:|
| b2_resnet (U 618,856) | 524,288 (2^19) | 1,048,576 (2^20) |
| b3_deepae (U 1,069,632) | 1,048,576 (2^20) | 2,097,152 (2^21) |
| smartcam (U 18,222,796) | 16,777,216 (2^24) | 33,554,432 (2^25) |
| wgan (U 135,666,432) | 134,217,728 (2^27) | 268,435,456 (2^28) |

8 셀. **이것을 실제 임무 예산으로 표현하지 않는다**(지시 §9).

### 3.3 실행 순서가 곧 비순환성의 증거

1. 이 계획서 커밋(식·입력·프로파일·셀 고정) ← **지금**
2. M2·M3 측정(모델 없음·예산 없음) → 원자료 커밋
3. `B_contract` 계산 → **예산 매니페스트 커밋**
4. 그 다음에야 admission 셀 실행

`U`를 보고 예산을 고친 적이 없음은 **커밋 순서**가 증언한다. 다만 아래 §6의 정직성 한계를 함께 읽어야 한다.

### 3.4 비용 (QEMU TCG wall-clock — 일정 산정용이며 성능 증거가 아니다, 작업 규율 4)

DENY 셀 ~90 s · b2_resnet/b3_deepae ADMIT ~60 s · smartcam ADMIT ~120 s · **wgan ADMIT ~2,400 s**
(단일 추론 최대 1,984 s 관측). wgan ADMIT 셀이 비용을 지배한다.

## §4 판정 기준 — **측정 전 고정** (지시 §5.5 그대로)

| 상황 | 필수 결과 |
|---|---|
| `U ≤ B_contract` | `ADMIT` · 런타임 생성 · 추론 **1회 이상** |
| `U > B_contract` | `NOT_ADMITTED` · **런타임 미생성** · 추론 **0회** |
| 승인된 실행 | `HAL peak ≤ 승인 근거 예산`(D53/D59 — `bounded`가 아니라 **승인한 그 수**와 비교) |
| 모든 셀 | 계약·vmfb 해시 불변 · cFS 비정상 종료 없음 · 거부 후 cFS 잔여 기능 생존 |

런타임 생성 여부는 **`mem_init` 레코드의 유무**로 판정한다(D80: `stack` 레코드는 E16 이후 거부 셀에도
남으므로 증인이 될 수 없다).

기록 필드는 지시 §5.4의 13개를 그대로 싣는다(`budget_profile_id` … `artifact_sha256`).

## §5 무엇이 이 실험을 반증하는가 (미리 적는다)

1. **`U > B_contract`인데 ADMIT되거나 추론이 1회라도 돈다** → 게이트의 fail-open. 즉시 결함 등록.
2. **`U ≤ B_contract`인데 NOT_ADMITTED** → 과잉 거부(유형 B). 즉시 결함 등록.
3. **승인 셀의 HAL peak가 승인 근거 예산을 넘는다** → soundness 위반. 원인 규명 전까지 PASS로 적지 않는다.
4. **예산 주입이 조용히 실패한다**(오버라이드가 무시되고 컴파일 매크로로 되돌아감) → E36/D61이 고친
   자리의 회귀. 각 배치에 malformed 오버라이드 셀 1건을 넣어 `BUDGET_INVALID` 경로를 함께 확인한다.
5. **계약 또는 vmfb 해시가 변한다** → 이 실험이 참조만 한다는 전제가 깨진 것이다.

## §6 정직성 한계 — **미리 적는다**

지시 §5.3은 *"예산은 모델별 계약값을 확인하기 전에 산정식과 입력 자료를 고정한다"*고 요구한다.
**나는 네 모델의 `U`를 이미 알고 있다**(E32·E36b·E53에서 측정했고 §1.4에 적혀 있다). 따라서 이
실험이 보장할 수 있는 것은 *"U를 모르는 상태에서 예산을 정했다"*가 아니라 다음까지다:

> 예산의 **입력 자료와 산정식을 외부 근거·실측에서만 가져왔고**, 그것을 판정에 쓰기 전에 커밋했다
> (§3.3의 순서). 지시 §9가 금지한 *"원하는 결과가 나오도록 예산을 조정하는 것"*은 하지 않았으며,
> 그 사실은 커밋 순서와 원자료로 검증 가능하다.

이 구분을 EVIDENCE 문서에도 그대로 싣는다. **"U를 보지 않고 정했다"고 쓰지 않는다.**

## §7 결과별로 무엇을 쓸 것인가 — **미리 정한다** (지시 §8)

- **일부 모델이 거절되는 경우**: *"동일한 참조 기반 메모리 예산에서 모델별 계약 상한의 차이가 서로
  다른 admission 결과로 이어졌으며, 거절된 모델은 런타임 생성과 추론 전에 차단됐다."* 이는 그 모델의
  일반적 실행 불가능성이 아니라 **그 예산 프로파일에서의 배치 불가**를 뜻한다.
- **모든 모델이 승인되는 경우**(§2의 수치로 볼 때 Part 1에서 유력하다): *"선정한 참조 플랫폼과 자원
  할당 조건에서는 네 모델이 모두 배정 예산 안에 있었다."* **거절을 만들려고 예산을 줄이지 않는다.**
  판별력은 Part 2(민감도 스윕)가 담당하며, 그것을 실제 임무 예산이라고 부르지 않는다.
- **모든 모델이 거절되는 경우**: 회계 범위·비계약 오버헤드·마진 적용이 지나치게 보수적인지 먼저
  점검하고, 정당한 산정 결과면 그대로 보고한 뒤 더 큰 플랫폼을 별도 프로파일로 추가한다.

## §8 금지 (지시 §9를 이 실험의 규칙으로 채택)

- 각 모델의 `U`를 본 뒤 원하는 결과가 나오도록 예산을 조정하는 것
- 물리 RAM 전체를 AI 모델 계약 예산으로 간주하는 것
- OS/cFS·다른 앱·IREE 고정비용을 제외하지 않는 것
- 서로 다른 회계 범위의 RSS와 HAL peak를 직접 비교하는 것
- `U−1` 거절을 실제 임무 예산 부족의 증거로 표현하는 것
- 참조 기반 프로파일과 민감도 스윕을 하나의 실제 배치 사례처럼 합치는 것
- 모든 모델이 승인됐다는 이유만으로 실험 후 예산을 낮추는 것
- **마진 백분율을 1차 출처 인용인 것처럼 쓰는 것**(§1.1의 등급을 반드시 병기)

## §9 산출물

```
results/e54_reference_budget/
  sources/            프로브 기록(호스트×경로×HTTP 코드) · 플랫폼 출처 매니페스트(URL·sha256·인용문)
  baseline/           M2·M3 원자료(AI_LEARNER 없는 cFS 실행 로그, RSS 표본) + baseline.json
  budgets.json        프로파일별 B_AI · 모델별 R_noncontract_AI · B_contract  (셀 실행 전 커밋)
  cells/              24 셀의 게스트 raw log
  scenarios_*.json    두 remote root 배치의 시나리오 정의
  summary.json        지시 §5.4의 13개 기록 필드 + Part 1/Part 2 분리 + 판정
docs/EVIDENCE_v0.57_E54.md
```

회귀: 보관 14개 계약 diff 0 · `contract_negative_tests.py` 전건 유지 + E54 가드 신설 ·
네 모델의 계약/vmfb 해시 불변.
