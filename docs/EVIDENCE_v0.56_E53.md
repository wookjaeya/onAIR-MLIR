# EVIDENCE v0.56 — E53: WGAN AArch64 종단 검증

- 실험 ID: **E53** · 날짜: 2026-09-12 · 계획 커밋: `ca8a6b9` (**측정 이전**)
- 사전 고정 기준: `docs/plans/E53_wgan_aarch64.md`
- 근거: `docs/reviews/DECISIONS_v0_52_REVIEW_R2_WGAN.md` §7.2·§9(WGAN AArch64 종단 검증을 "핵심 검증 후
  수행"으로 지정, 이번 세션에서 그 선행조건 — E50 강제 경로 연결·순차 호출 근거·회계 매핑·DeepAE
  원인 — 이 E51·E52로 전부 닫혔음을 확인하고 착수)
- 증거 등급: **결정론적**(계약 수치·HAL allocator 통계·계약-아티팩트 해시·원소별 출력 비교). 지연값 미인용.
- 산출물: `results/e53_wgan_aarch64/{build/aarch64/,ledger.json,native/,cfs/,comparison_cfs_aarch64.json,summary.json}`
- 회귀: 이 컨테이너 **820/820 → 831/831**(§9, D93 영구 회귀 시험 11건 포함)
- **CI 실측**: 이 문서를 커밋한 다음 CI 실행에서 확인해 추가한다(D34 규율 — 추정하지 않는다).

## §0 판정

**Q1~Q6 전부 PASS, `e53_complete: true`.** 검토서 §7.2가 요구한 완료 기준(*"계약 원장(I·O·T·C)·
AArch64 native 의미 동치·cFS `B`/`B−1` 승인·거절·같은 회계 영역의 HAL 관측이 하나의 추적 가능한
경로로 연결돼야 한다"*)이 `results/e53_wgan_aarch64/summary.json` 하나의 산출물에서 확인된다.

**결과별 서술(계획 §5가 측정 전에 고정)**: *"AArch64 cFS에서 호출당 메모리가 기존 최대 사례
(SmartCam `per_call` 9,382,092 B)의 14배인 실물 모델(WGAN `per_call` 131,382,784 B)에 대해서도
계약 생성·원장 대조·의미 동치·실행 전 예산 판정·같은 회계 영역의 실행 관측이 하나의 경로로 연결됨을
확인했다."* **조건부 계층(map 분기 opt-in)은 다루지 않았다** — §7.2의 7단계는 무조건 계층만 요구하고,
E46이 이미 WGAN에서 조건부 계층의 이득이 3.3%(1.03×)뿐임을 정량화해 두었다.

## §1 Q1 — 계약 생성

같은 `wgan.mlir`(모델 sha256 `0671e0817a03683a...` — x86-64(`results/e46_wgan/build/`)와 **바이트
동일**, one-invocation)에서 **한 번의 `iree-compile`**로 AArch64 vmfb(4,321,533 B)·계약·헤더를 생성했다.

| | AArch64 | x86-64(E46, 인용) |
|---|---:|---:|
| `bounded_bytes` | 135,666,432 | 135,666,432 |
| `static_per_call_bytes` | 131,382,784 | 131,382,784 |
| `module_resident_constant_bytes` | 4,283,648 | 4,283,648 |
| `static_external_input_bytes` | 602,112 | 602,112 |
| `static_external_output_bytes` | 602,112 | 602,112 |
| `bound_method` | `static_from_stream_layout` | `static_from_stream_layout` |
| `constants_confirmation_state` | `confirmed` | `confirmed` |
| `overrides_applied` | `[]` (0건) | `[]` (0건) |
| `kernel_task_stack_bytes` | 880 | 432 |
| `target.triple` | `aarch64-unknown-linux-gnu` | `x86_64-unknown-linux-gnu` |

**세 수치·`bound_method`·상수 확인 상태·오버라이드 0건은 ISA와 무관하게 동일하고, 다른 것은
`target.triple`과 커널 스택(880 vs 432 B, ELF 호출 프레임의 ISA 차이)뿐**이다 — E32(SmartCam)·
E36b(ResNet·DeepAE)가 이미 보인 패턴이 저장소 최대 규모 모델에서도 재현된다. 구조적 추출기
크로스체크(`agrees_with_regex_parser`)도 통과(§2의 원장 대조가 독립적으로 재확인한다).

## §2 Q2 — 원장 대조 (`harness/e49_alloc_ledger.py`)

**계약이 생성되는 도구를 고치지 않고**, 같은 layout IR을 독립적으로 훑는 E49 원장으로 I·O·T·C를
대조했다(새 모델 목록에 추가하는 것이 아니라 그 도구가 이미 값으로 모델을 받는지 확인 — D65 회피).

| 항목 | IR에서 유도(`derived_totals`) | 계약(`contract_totals`) | 일치 |
|---|---:|---:|---|
| I (input) | 602,112 | 602,112 | ✔ |
| O (output) | 602,112 | 602,112 | ✔ |
| T (transient) | 130,178,560 | 130,178,560 | ✔ |
| C (constants) | 4,283,648 | 4,283,648 | ✔ |

`I + O + T = 131,382,784 = static_per_call_bytes`(`per_call_identity.equal: true`), `unclassified_ops`
0건, entry 안 `stream.async.*`(pre-scheduling 할당 op) 0건 — E49/E50이 정한 "정적 파서의 좁은 스캔이
안전한 조건"이 이 모델에서도 성립한다. `all_agree: true`.

## §3 Q3 — native 의미 동치 (qemu-user AArch64)

**계획 §2가 미리 정한 대로 `native_learner.c`는 건드리지 않았다.** E25 등가성 모드(`argv[4..5]`)는
벤치마크 루프(§5의 D93 참고)보다 **먼저** 실행되고 결과를 `fwrite`+`fclose`로 완전히 flush하므로,
그 지점까지만 기다리면 된다 — admission(`ADMIT`)·binding(`MATCH`, artifact sha256 = contract
sha256)·`map_branch`(`module_ptr_mod64: 0`, `arm: map`) 모두 정상, `e25_equivalence` 레코드가
`completed: 1/1`을 보고한다.

**샘플**: `img_msec_1536095035794_2_thumbnail`(실이미지, E46 fixture의 실이미지 9장 중 1장 —
qemu-user 아래 WGAN 1회 추론의 실측 비용이 커 11샘플에서 1샘플로 좁혔다, §5 참고).

원본 TFLite oracle(`ai_edge_litert`, `harness/tflite_oracle.py`로 이 세션에서 재생성, E46 규칙대로
원자료는 반입하지 않음)과 `harness/e31_compare.py`(수정 없이 그대로 재사용, `--subset`으로 이 1샘플만
선언, `--argmax not-applicable` — WGAN은 분류기가 아니다, E46 그대로)로 대조:

| | 원소 | 실패 | worst abs | worst rel | 판정 |
|---|---:|---:|---:|---:|---|
| native (qemu-user) vs oracle | 150,528 | **0** | 8.9407e-07 | 2.4867e-06 | **PASS** |

## §4 Q4 — cFS 예산 경계 (AArch64 게스트)

| 셀 | 예산 | 판정 | 추론 | HAL peak | cFS 생존 |
|---|---:|---|---:|---:|---|
| `cfs_Bm1` | 135,666,431 (`bounded−1`) | **NOT_ADMITTED** | **0** | — | 앱 8개 계속 로드, `CFE_ES_ExitApp` 정상 |
| `cfs_B` | 135,666,432 (`bounded`) | **ADMIT** | **4/4** | 131,382,784 | 정상 (timeout SIGINT 종료) |

두 셀 모두 `budget_source: override`(E36/E38의 런타임 오버라이드 배선을 그대로 재사용, 새 배선 0건).
`cfs_Bm1`은 예산이 **`bounded`보다 정확히 1 B 작을 때** 거부하고, 거부 이후에도 `cs·ds·fm·hk·hs·md·
mm·sc` 8개 앱이 계속 로드된다(로그로 확인, E36 계열 관측의 재현).

## §5 D93 — cFS 승인 셀이 FAIL로 잘못 기록됐다 (fail-open이 아니라 과잉 거부, 즉시 발견·수정)

`cfs_B`의 raw 게스트 로그는 EVS 텍스트로 **`completed=4/4 ... hal_peak=131382784 within_bounded=1`**을
네 번(1/4, 2/4, 3/4, 4/4) 보고하고, `"stage":"mem"` JSON도 같은 값을 담고 있는데,
`harness/e14_cfs_scenarios.py::check_expect`의 `min_completed`가 `"stage":"run"` JSON에서만 값을
읽어 `last_run: None` → `completed 0 < 1`로 **거부**했다.

**원인**: `AI_LEARNER_Json`(`native/cfs_app/fsw/src/ai_learner.c`)의 콘솔 라인 버퍼가 `char line[768]`
고정 크기다. WGAN의 출력(150,528 f32)을 통째로 담는 `"stage":"run"` 라인이 배열 중간에서 끊겨
`parse_log`의 균형 중괄호 스캔이 닫는 `}`를 못 찾고 `unparsed_json`으로 분류된다. **이것은 D68이
이미 밝힌 것과 정확히 같은 기전**(DeepAE의 640원소 출력도 766자에서 잘린다)인데, D68의 수정은
`mk_e36b_summary.py`(하류 리포터)에만 들어갔지 **이 셀의 `"pass"` 값을 실제로 정하는
`e14_cfs_scenarios.py::check_expect`에는 닿지 않았다** — DeepAE에서는 이 게이트에 `min_completed`를
건 적이 없어 드러나지 않았을 뿐이다.

**수정**: `min_completed`가 `last_run` 부재 시 `"stage":"mem"`(같은 순간에 같은 `g.n_infer` 값을
배열 없이 담아 이 truncation을 겪지 않음, 소스로 확인)으로 fallback한다. `native/cfs_app/fsw/src/
ai_learner.c`·`native/native_learner.c`는 계획이 금지한 대로 건드리지 않았다 — 근본 원인(`line[768]`)은
열려 있고, 다음에 이보다 더 큰 출력을 넣는 모델이 다시 밟을 수 있다.

**실제 원자료로 revert-and-confirm-fail**: `cfs_B.log`(수집된 그대로)에 대해 되돌린 코드는
`['completed 0 < 1']`을, 고친 코드는 `[]`를 낸다. 오프라인 재판정 모드(`e14_cfs_scenarios.py
--reparse`, 이번에 신설)로 게스트를 다시 실행하지 않고 이미 수집한 로그만 재판정해 `summary.json`의
`cfs_B`를 FAIL→PASS로 정정했다.

**부수 발견 (native 프로세스 오설정)**: 이 실험의 native 리허설 1차 시도는 E25 등가성 인자
(`argv[4..5]`)를 빠뜨린 채 실행돼, `native_learner.c`의 벤치마킹 루프
(`WARMUP_CALLS=200`, 모델과 무관한 고정 상수)가 WGAN 1회 추론당 실측 비용(qemu-user 아래 admission부터
1회 추론까지 총 **~11분**)을 200배 넘게 반복하며 4시간 넘게 끝나지 않았다. 죽이고 올바른 인자로
재실행하니 admission+binding+**1회 실추론**이 11분 만에 끝났다 — **qemu-user는 이 워크로드에서
qemu-system-aarch64(cFS, 1회 추론당 EVS `mean_us` 실측 ~1,800~2,000초 ≈ 30~33분)보다 실측으로
훨씬 빠르다.** 코드는 건드리지 않았다(WARMUP_CALLS를 값으로 빼는 것은 이 실험의 필요를 넘는
변경이라 하지 않았다) — E25 등가성 블록이 그 루프보다 먼저 완료·flush되므로, 필요한 값을 얻은
즉시 남은 루프를 죽이는 것으로 충분했다.

## §6 Q5 — HAL 대조

`cfs_B`의 HAL peak **131,382,784**는 무조건 계층의 상한(`bounded_bytes` 135,666,432) **이하**다
(soundness 위반 0, E26 이래 관측 범위 유지). 값이 `bounded_bytes`가 아니라 `static_per_call_bytes`와
**정확히 같다** — `map_branch.arm: "map"`(E29의 64바이트 정렬 전제가 이 배포에서도 우연히 성립,
`module_ptr_mod64: 0`)이기 때문이며, 계약이 선언하는 두 분기 중 더 tight한 쪽을 이 배포가 실제로
탄 것이다(D78의 회계 범위 주의 그대로 — process RAM이 아니라 HAL 디바이스 할당 회계).

**native와 cFS의 출력이 비트 동일하다**: 같은 vmfb·같은 입력에서 두 실행 경로(qemu-user 단독
프로세스 / qemu-system-aarch64 게스트 안의 cFS 앱)의 602,112 B 출력을 직접 바이트 비교해
`np.array_equal` **True**, 최대 절대차 **0.0**을 확인했다 — 계획 §4의 반증 조건 4("native와 cFS의
출력이 다르다")는 발생하지 않았다.

## §7 Q6 — 구성 비교

§1의 표가 그 자체로 답이다 — 세 수치·`bound_method`·상수 확인 상태·오버라이드는 ISA 독립이고,
`target.triple`과 커널 스택 바이트 수만 ISA에 종속된다. **VMFB 비트 동일성은 요구하지 않았고
확인하지도 않았다**(계획이 명시적으로 요구하지 않음 — ISA가 다르므로 애초에 의미가 없다).

## §8 하지 않은 것 (명시)

- **조건부 계층**(`AI_LEARNER_ALLOW_CONDITIONAL_MAP` opt-in) — §7.2의 7단계는 무조건 계층만
  요구하고, E46이 이미 WGAN에서 그 이득이 1.03×(3.3%)뿐임을 정량화했다. 새로 켜지 않았다.
- **정확도** — E46 G2 그대로(평가셋 없음, 원본 재인코딩 JPEG를 기준값으로 쓸 수 없음).
- **지연·처리량** — `FUNCTIONAL_ONLY` 호스트, qemu 아래.
- **OnAIR AArch64** — §7.1과 분리된 범위.
- **11샘플 전부** — qemu-user 아래 WGAN 1회 추론의 실측 비용(§5) 때문에 native·cFS 모두 **실이미지
  1장**으로 좁혔다. 이 실험의 반증 조건은 "그 1샘플이 실패하는가"이지 "11샘플 커버리지"가 아니며,
  §3·§6이 그 1샘플에서 native·cFS·oracle 셋이 모두 일치함을 보인다.
- **`native_learner.c`의 `WARMUP_CALLS=200` 자체를 고치는 것** — §5가 발견한 비용 문제를 회피할
  방법(E25 블록이 먼저 끝난다)이 있어 코드 변경 없이 진행했다. 상수 자체는 열려 있다.

## §9 회귀

**D93을 영구 회귀 시험으로 고정했다** — 검증만 하고 넘어가지 않고 `harness/contract_negative_tests.py`에
`e53_wgan_aarch64_cases()` 11건을 신설했다: (1) 합성 재현(잘린 `run` + 온전한 `mem`에서 폴백이 작동),
(2) 둘 다 없을 때는 여전히 거부(유형 A 과잉 승인 방지), (3) 소스 수준 확인(폴백 코드·`--reparse`
존재·`ai_learner.c` 미수정), (4) **실제 원자료**(`cfs_B.log`)로 truncation 재현 + `check_expect` PASS,
(5) 최종 `summary.json`의 `cfs_B.pass`·Q1~Q6·`e53_complete` 확인, (6) 계약 동일성·native/cFS 바이트
동일성. **revert-and-confirm-fail**: 폴백 코드(`or res.get("last_mem")`)만 제거하면 이 중 3건이 정확히
그 이유로 FAIL(`['completed 0 < 1']`), 복원하면 11/11 PASS.

이 컨테이너 **831/831**(820/820 + 신규 11건, D93 수정 후. 로그 원자료 커밋 전 한때 819/820+1 FAIL —
D55 가드가 아직 커밋되지 않은 `cfs_B.log`를 잡은 것, 커밋 후 해소). `contract_negative_tests.py`
나머지 전건 유지, 보관 14개 계약 diff 0.

**CI 실측**(커밋 `788234c`, run 34690758943, 3레그 success): `full` **826/826 + 4 SKIP** ·
`without-iree` **656/656 + 36 SKIP** · `stdlib-only` **656/656 + 36 SKIP**. 컨테이너 831/831과
`full`의 차이 5건은 E38이 확립한 설명 그대로다(PyYAML 미설치 1 · `aarch64-linux-gnu-objdump`
미설치로 정직하게 SKIP되는 2 · 그 툴체인이 없으면 witness를 실제로 돌리는 분기가 아예 없어
존재하지 않는 2). 직전 커밋(`d3f80f9`, run 34690054862) 대비 세 레그 전부 **PASS +11 · SKIP
증가 0**이라 `e53_wgan_aarch64_cases()` 신규 11건이 **전부 나타난다** — `check_expect`/`parse_log`
(stdlib 전용)와 커밋된 JSON·bin 원자료만 읽으므로 툴체인 유무와 무관하게 세 레그 모두에서 실제로
돈다.
