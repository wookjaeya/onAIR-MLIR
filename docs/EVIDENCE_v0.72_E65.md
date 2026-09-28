# EVIDENCE v0.72 — E65: 생산 리비전 확인과 상한 보류(M1), OnAIR 조건부 옵션의 구성 오류화(M2), 경미 1–3

- **근거 요청**: 22차 원고 메타리뷰(`JAIS_onair_mlir_v26_metareview_only.md`, 2026-09-28, 연구 책임자 전달) — 필수 M1·M2, 경미 1–3.
- **사전 고정 기준**: `docs/plans/E65_producer_revision_and_plugin_option.md`(커밋 `7b67d89`, **구현·재발행·게스트 셀 이전**).
- **대상**: 모든 셀은 AArch64 QEMU 게스트(qemu-system-aarch64, Cortex-A53, 이번 부팅 4 vCPU·2 GiB — `guest/onair/guest_env.txt`).
  개발 호스트에서는 평가 타깃용 **지상 측 분석**(명세 생성·헤더 생성)만 했다. 모델은 실행하지 않았다.
- **증거 등급**: 결정론적(아티팩트 바이트, 명세 필드, 헤더 바이트, 게스트 로그 레코드). 지연은 재지 않았다.
- **판정: Q1~Q5 PASS, Q6 관측 기록** (`results/e65_producer_check/summary.json` — 원자료에서 유도).

## 1. 무엇이 문제였나

### 1.1 M1 — 생산 리비전이 기계 판독 필드에 없었다 (D109)

E59가 이전 리비전(IREE 3.10.0rc20260107)으로 컴파일한 AArch64 아티팩트 4개에 대해 분석기는 **상한을 싣고 `verification_grade:
verified`인 명세**를 발행했다(`results/e59_info_levels_aarch64/drift_310/*/*.contract.json`). 불일치는 `provenance.notes`의 자유
텍스트(`iree-dump-module failed … bytecode version mismatch`)에만 있었고, `validity.compiler`는 아티팩트를 만든 리비전이 아니라
**분석 호스트**의 리비전이었다(D107에 기록만 해 둔 사실). 헤더 생성기는 그 명세에서 `BOUND_KNOWN 1` 헤더를 냈다 — 이번에 실제로
재현했다(아래 Q2(b)의 헤더가 그것이다). 원고는 그 수치를 *"diagnostic rather than admissible"*이라 적었지만 **그것을 강제하는
장치가 없었다.** 이 저장소의 원칙(*"확인할 수 없는 것은 통과가 아니다"*, D25·D29·D68)과 정면으로 어긋난다.

### 1.2 M2 — OnAIR 플러그인의 조건부 옵션이 절차적으로만 꺼져 있었다 (D110)

`compiled_learner_plugin.py:113`이 `bool(d.get("allow_conditional_map", False))`로 설정을 읽어 `admission_policy.decide`에 넘겼다.
플러그인은 map 분기 전제(모듈 이미지 64바이트 정렬, append 후 상수 할당 0)를 확인하지 않는다(파이썬 바인딩이 이미지 주소를
드러내지 않는다). 따라서 운영자가 켜면 **확인 없이 `B_m`으로 승인**할 수 있었다 — D53의 모양이다. 지금까지는 모든 배포 설정이
`false`를 적었을 뿐이다. 부수: `bool("false")`는 참이므로 문자열 `"false"`는 **켜진 것으로** 읽혔다.

## 2. 무엇을 바꿨나

### 2.1 아티팩트가 선언하는 생산 정보를 읽는다 — `harness/vmfb_module_info.py`

vmfb의 첫 ZIP 엔트리 `module.fb`는 크기 접두 FlatBuffer(`BytecodeModuleDef`, 식별자 `IREE`)이고 필드 13이
`bytecode_version = (major << 16) | minor`다. **컴파일러 리비전 문자열은 아티팩트에 없다**(모듈 `attrs`는 비어 있고 임베디드 ELF의
`.comment`는 `IREE` 한 줄). 따라서 읽을 수 있는 생산 정보는 bytecode 버전뿐이고, 이 검사는 **같은 bytecode 버전을 내는 서로 다른
리비전을 구별하지 못한다** — 명세가 그 한계를 `validity.producer_check.granularity`에 스스로 싣는다.

- 판독 위치는 ZIP 멤버가 아니라 **런타임이 읽는 방식 그대로**다(`runtime/src/iree/vm/bytecode/archive.c`의 local header 건너뛰기 →
  크기 접두 → `prefix <= 남은 바이트`). **첫 구현은 ZIP 멤버를 읽었고 39개 아티팩트 전부를 거부했다** — 모든 아티팩트에서 접두값이
  멤버 길이보다 4바이트 크다. 런타임을 흉내 내지 않는 판독기는 런타임이 적재하는 아티팩트를 거부한다(유형 B, 판정 전에 잡음).
- 저장소 추적 vmfb **39개 전수**: 17.0이 34개, 16.0이 **정확히 알려진 이전 리비전 5개**(E27 x86-64 1 + E59 AArch64 4), 판독 실패 0.
- 읽지 못하면 버전 0.0이 아니라 **예외**다(`not_observed`).

### 2.2 분석기 — 불일치면 상한을 보류한다 (`harness/make_contract.py`)

- `CHECKED_PRODUCER` = 할당 대응 K를 점검한 리비전(3.11.0rc20260316 @ `e4a3b04`, bytecode **17.0** — 그 리비전의
  `vm/bytecode/utils/isa.h:26,32`).
- `validity.producer_check` = `{state: match|mismatch|not_observed, artifact_bytecode_version, checked_*, source, granularity,
  consequence}`. `validity.compiler_fields_describe: "analysis_host"`로 `compiler*` 필드가 무엇을 말하는지 적는다(D107).
- **상한은 `all_static`이고 `state == match`일 때만** 진술된다. 아니면 `bound_method = NONE`, 수치는
  `resources.diagnostic_figures_when_bound_withheld`에만 실린다 — 동적 형상의 *상한 없는 명세*와 같은 모양이다.
  메타리뷰가 허용한 두 선택지(*발행 중단* / *상한 없는 문서*) 중 후자를 택한 이유: 정보 수준 비교(원고 VI.A)가 이 문서의 진단 수치를
  쓰며, 상한 없는 문서는 이미 헤더·비행 앱이 거부하는 경로다.
- 첫 가정 항목은 상한이 없는 이유를 말한다(*"static shapes, but no bound is stated: producer bytecode version …"*). 첫 판은
  `"static shapes"`를 그대로 두고 이유를 뒤에 붙였는데 **E40의 코퍼스 가드(D70)가 그것을 잡았다** — 상한 없는 명세의 첫 전제가
  맨 `"static shapes"`인 것이 D70이 없앤 상태다. 가드를 넓히지 않고 문구를 고쳤다.
- E40 드리프트 가드: `bound_method != NONE` ⇔ `static_shapes ∧ producer match`. E65 이전 문서(검사 필드 없음)에는 옛 항등식을 쓴다.

### 2.3 헤더 생성기 — 불일치 문서를 거부한다 (`harness/gen_contract_header.py`)

- `producer_check.state != match` → **거부**(rc 1, 헤더 없음). `--allow-producer-mismatch`는 **상한을 싣지 않는** 헤더
  (`BOUND_KNOWN 0`)만 쓴다 — 탈출구로도 상한은 나오지 않는다. 그 헤더가 Q2(a)의 입력이다.
- **E65 이전 문서가 상한을 진술하면 기본 거부**(`--allow-unchecked-producer`로만 수용, 헤더 바이트 불변). 부재를 일치로 읽지 않는다(D29).
  provenance 블록이 없는 문서(`contracts/*.json`, OnAIR fixture)는 E24b의 provenance 게이트와 같은 이유로 범위 밖이다.
- 시험 영향: E65 이전 fixture 위에 선 헤더 **양성** 시험 9건이 새 이유로 거부됐다. 같은 fixture 위의 **음성** 시험이 새 이유로
  공허하게 통과하지 않도록(D89)
  fixture에 **그 fixture 자신의 vmfb에서 읽은** 생산 검사를 붙였다(`with_producer_check`, 리터럴 `match`가 아니다). 이를 먼저 잡은 것은
  그 묶음의 *sanity* 양성 대조였다 — 음성 시험들이 실제로 공허해지기 전에 멈췄다. vmfb가 보관되지 않은 ResNet fixture(E26a)와
  역사 문서의 헤더 바이트 재현 시험 둘은 플래그를 명시했다.

### 2.4 OnAIR 플러그인 — 조건부 옵션을 구성 오류로 거부한다

`artifact_binding.check_conditional_map_option`(stdlib 순수 함수): 키 부재 또는 불리언 `false`만 수용, `true`와 **모든 비불리언**
(`"false"`·`0`·`null`)은 `ConfigurationError`. 플러그인은 이것을 가드 안 **맨 처음**(명세 적재 이전) 호출하고, 정책에 넘기는 값은 상수
`False`다. init 레코드에 `allow_conditional_map_requested`(배포가 쓴 값)를 싣는다. 저장소의 모든 배포 설정 중 거부되는 것은 E65 거부
셀 하나뿐이다(과잉 거부 0).

## 3. 결과

### Q1 — 이전 리비전 4개를 현재 분석기로 재분석 (PASS)

| 모델 | 아티팩트 bytecode | state | bound_method | 진단 bounded | E59가 발행했던 상한 | 헤더 기본 | `--allow-producer-mismatch` |
|---|---|---|---|---|---|---|---|
| ResNet | 16.0 | mismatch | NONE | 618,856 | 618,856 | 거부 | BOUND_KNOWN 0 |
| DeepAE | 16.0 | mismatch | NONE | 1,069,632 | 1,069,632 | 거부 | BOUND_KNOWN 0 |
| SmartCam | 16.0 | mismatch | NONE | 18,222,796 | 18,222,796 | 거부 | BOUND_KNOWN 0 |
| WGAN | 16.0 | mismatch | NONE | 135,666,432 | 135,666,432 | 거부 | BOUND_KNOWN 0 |

진단 수치는 E59가 상한으로 발행했던 값과 같다 — 바뀐 것은 수치가 아니라 그 수치의 **지위**다.

### Q2 — 게스트 비행 응용 (PASS, 두 셀)

같은 이전 리비전 ResNet 아티팩트(sha256 `55586e31…`), 예산 `B_u` = 618,856, 조건부 opt-in 0, 두 빌드의 게스트 `.so` sha256이 빌드
기록과 일치(`guest/guest_so_sha256.txt` ↔ `guest/trees/*/so_sha256.txt`).

| 셀 | 헤더 출처 | build_config bound_known | admission | binding | 런타임 | 추론 | 이후 cFS |
|---|---|---|---|---|---|---|---|
| (a) `e65_drift_nobound` | 현재 분석기의 명세(상한 보류) | false | **UNKNOWN_BOUND** | — | 생성 전 종료 | 0 | 앱 적재 계속 |
| (b) `e65_drift_legacy` | E59가 발행한 명세(상한 있음) | true | ADMIT | MATCH | **적재에서 거부** | 0 | 앱 적재 계속 |

(b)의 런타임 레코드: `verifier.c:176: INVALID_ARGUMENT; bytecode version mismatch; runtime supports 17.0, module has 16.0`.
원고의 *"런타임 검증기가 적재 시 거부할 것(소스 판독, 적재 시도 없음)"*이 **관측**이 됐다. 두 층이 겹친다 — 새 분석기는 그 문서를
내지 않고, 옛 문서를 누가 가져와도 런타임이 모듈을 적재하지 않는다. (a)의 *"런타임 생성 전"*은 여전히 `mem_init` 부재로 추론한다(D80).

### Q3 — OnAIR 공식 로더, 게스트 (PASS, 두 셀)

E62 ResNet fix-arm 배포와 같고 **옵션만** 다른 두 셀(예산 `B_u`, 같은 아티팩트·fixture·텔레메트리).

| 셀 | 옵션 | active | inactive_reason | runtime_created | admission | 추론 |
|---|---|---|---|---|---|---|
| `…_conditional_requested` | `true` | false | `ConfigurationError: allow_conditional_map=true: …` | false | null | 0 |
| `…_conditional_false_control` | `false` | true | — | true | ADMIT | 50 |

두 셀 모두 OnAIR 프로세스 rc 0, OnAIR 코어 추적 파일 변경 0.

### Q4 — 평가 명세 4개 재발행 (PASS)

보관 단일 호출 산출물에서 재발행: 세 수치 불변, 헤더 **바이트 동일**, 4/4 `producer_check: match`, 4/4 `analysis_domain`
(출력 해제 `released_before_next_call`, `max_in_flight_calls: 1`, 64바이트 정렬 전제). 재발행 전 그 블록을 가진 것은 WGAN뿐이었다
(`archived_documents_with_analysis_domain: ["wgan"]`) — 경미 1의 비대칭이 그대로 확인됐다. 재발행본은 `results/e65_producer_check/reissued/`.
ResNet·DeepAE의 다른 잎은 `provenance.dump_dir_files` 목록 하나뿐이다(보관 dump가 축소본, E64와 같다).

### Q5 — 합산 규칙 (PASS)

(a) 보관 AArch64 ResNet 엔트리 마지막 print에 한 줄씩 넣은 편집(재컴파일 없음):

| 셀 | transient slab | T | O | per_call | 추출기 일치 |
|---|---|---|---|---|---|
| 편집 없음(대조) | [297,088] | 297,088 | 40 | 309,416 | 예 |
| transient slab 추가(256) | [297,088, 256] | **297,344** | 40 | 309,672 | 예 |
| 출력 할당 추가(40) | [297,088] | 297,088 | **80** | 309,456 | 예 |

(b) 두 출력 합성 모델(`gen_model_multiout.py`의 E26c MLIR)을 평가 타깃용으로 **한 번의 호출**로 컴파일: 출력 텐서 48 B(1×8·1×4 f32)가
**128 B 슬랩 하나**와 봉쇄 검사를 통과한 subview로 읽혔다. per_call 192, constants 512, bounded 704, 오버라이드 0, 추출기 일치,
`producer_check: match`. 헤더는 단일 입출력 제한으로 **정당하게 거부**된다(두 C 실행기가 그 가정을 하므로 과잉 거부가 아니다 — E26c와 같음).
보관: `results/e65_producer_check/multiout_aarch64/`(축소 dump).

### Q6 — 런타임 리비전 (관측)

게스트 IREE 파이썬 런타임(`~/e57/pylib`, iree-base-runtime 3.11.0)의 `iree/_runtime_libs/version.py`:
`VERSION = "3.11.0rc20260316"`, `REVISIONS = {"IREE": "e4a3b0405d7d23554da26403658d0e8c3c5ecf25"}` — 컴파일러와 **같은 리비전**이다.
C 런타임은 같은 커밋의 소스 체크아웃에서 빌드했다(`~/onair-mlir-bench/ext/iree-src` `git rev-parse HEAD` = `e4a3b04…`).

## 4. 가드와 되돌림 확인

`contract_negative_tests.py::e65_producer_check_cases` 12건 + 회귀 14개 모델별 생산 검사 고정 14건.
되돌림: 분석기 게이트 → `e65/12`(라이브) FAIL · 헤더 게이트 → `e65/3`·`e65/4` FAIL · 플러그인 검사 → `e65/8` FAIL.
분석기 게이트의 되돌림은 도구가 있는 레그(`full`)에서만 잡힌다 — 축소 레그에서 `e65/12`는 정직한 SKIP이다.
이 컨테이너 **970/970 + 2 SKIP → 996/996 + 2 SKIP**, 보관 14개 계약 diff 0(새 블록은 subtree로 제외하고 모델별로 고정).

## 5. 주장하지 않는 것

- bytecode 버전 검사는 **같은 버전을 내는 다른 리비전을 구별하지 못한다**. `match`는 *"점검한 리비전과 같은 bytecode 버전"*이지
  *"같은 리비전"*이 아니다.
- 이전 리비전에 대해 K를 점검하지 않았다. Q2(b)는 런타임이 그 모듈을 적재하지 않음을 보일 뿐이다.
- 다중 slab·다중 출력의 **실행 피크**(Q5는 분석기 수준).
- OnAIR 플러그인에서 조건부 정책이 쓰일 수 있다는 것 — 이 경로에는 전제 확인이 없으므로 **제공하지 않는다**.
- 지연·정확도.

## 6. 결함 원장

- **D109**: 이전 리비전 아티팩트 4개가 상한·`verified` 등급으로 발행됐고 불일치는 자유 텍스트뿐이었다(헤더 `BOUND_KNOWN 1`).
  수정 2.1–2.3.
- **D110**: OnAIR 플러그인이 조건부 옵션을 전제 확인 없이 정책에 넘겼고, 문자열 `"false"`를 참으로 읽었다. 수정 2.4.

**교훈**: ***"진단일 뿐"이라는 문장은 그것을 강제하는 필드와 거부 지점이 있을 때만 사실이다*** ·
***판독기는 대상이 읽히는 방식 그대로 읽어야 한다 — ZIP 멤버를 읽은 첫 판은 런타임이 적재하는 아티팩트를 전부 거부했다.***
