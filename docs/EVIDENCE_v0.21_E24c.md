# EVIDENCE v0.21 — E24c: 다섯 번째 외부 검토(F1–F5)

- 실험 ID: **E24c**
- 날짜: 2026-09-09
- 검토 원문: `docs/reviews/REVIEW_v0_20_E24b.md` (기준 커밋 `c680424`)
- 플랫폼 등급: **결정론적**(계약 값·헤더 바이트·세그먼트 수·시험 결과). 지연값 인용 없음.
- 커밋: `3d1f640`(F4) · `c924a47`(F5) · `7bf6115`(F2) · `1758b8e`(F3)

## 0. 한 줄 요약

5건 전부 재현했고 4건을 수정했다. **F1은 수정하지 않았다 — 리뷰의 권고를 그대로
적용하면 상태가 나빠진다는 것을 실측했기 때문이다**(§2). 시험 170/170 → **191/191**.

이 검토는 §7·§8에서 "F1–F3는 별도 대형 실험으로 키우지 말고 짧은 hardening으로 닫은 뒤
E25 → E26 → E27로 전환하라"고 명시했다. 그 지침을 그대로 따랐다 — 이번 작업은
연구 질문을 진전시키는 실험이 아니라 그 앞을 닫는 마지막 정리이며, 다음은 E25다.

| | 재현 | 정상 경로 도달 | 리뷰 서술 | 심각도 | 조치 |
|---|---|---|---|---|---|
| F1 provenance 삭제 | ✅ | **no** | accurate | P3 | **미채택**(권고가 악화) + threat model 항목 |
| F2 산술 검사 | ✅ | no | **partially_accurate** | P2 | 수정(D41) |
| F3 subset-sum 예산 | ✅ | **yes** | accurate | P2 | 수정(D42, **처방보다 좁게**) |
| F4 31-seg 미보존 | ✅ | yes | accurate | P2 | 실물 보존(D43) |
| F5 unsigned 서술 | ✅ | — | accurate | P2 | 정정 7곳(D44) |

## 1. 검증 방법

이 저장소의 기존 방법론 그대로 — 리뷰를 믿지 않고 먼저 실행으로 재현한다. 15개 에이전트:
finding당 재현 1인 + **각 권고의 과잉 거부 위험 2인**(서로 다른 렌즈: 정직한 입력 전수 /
다운스트림·빌드). 과잉 거부 축은 E20(D16·D17)·E24(N1·N3)·E24b(R4)에서 세 번 결정적이었다.

이번에는 과잉 거부 판정 10건이 전부 `breaks=False`였다 — 단, 각 검증자가 좁힌 범위 조건
(스코프 유지, `>= 0`이지 `> 0` 아님, 결정 절차 선행)을 지켰을 때에 한한다. 그 조건을
빼면 각각 유형 (B)가 된다.

**에이전트를 액면 그대로 믿지 않은 것이 이번에도 결정적이었다**: F4 재현 에이전트는
"3~5개 세그먼트만 나온다, 재현 안 됨"으로 보고했으나, 직접 확인하니 상수 수가 적은 기존
모델을 쓴 결과였다. 그대로 받아들였으면 **맞는 문서를 틀리게 정정할 뻔했다**(§5).

## 2. F1 — 리뷰 권고 미채택 (권고가 상태를 악화시킴)

### 2.1 재현된 것

세 갈래 모두 실행으로 재현됐다: (1) override 계약에서 `provenance` 블록을 삭제하면 헤더
생성이 성공하고, (2) 헤더는 `CONTRACT_PROVENANCE_VERIFIED 0`을 담으며, (3)
`native/`·`plugins/`·`scripts/` 어디에도 그 매크로의 소비자가 없다(`grep` 결과 0건).

### 2.2 그러나 권고를 적용하면 나빠진다 — 실측

검토의 권고는 "새 스키마 버전에서 provenance를 **필수**로 하고, legacy는
`--allow-legacy-contract`로만 허용"이다. 검증자가 실측한 반례:

> 같은 override 계약에 손으로 `provenance = {"single_invocation": true}` 한 블록만 써 넣으면
> `CONTRACT_PROVENANCE_VERIFIED`가 **1**로 나온다.

즉 provenance를 필수로 만들면 **삭제 경로(VERIFIED=0)가 위조 경로(VERIFIED=1)로 바뀐다.**
`verification_grade`의 부재를 신뢰로 읽는 것은 E24b가 의도적으로 택한 것이고(엄격 해석은
보관 14개를 전부 거부한다), 그 성질이 남아 있는 한 블록의 **존재**를 요구하는 것은
방어가 아니다. 서명이나 신뢰된 생성기 가정만이 닫을 수 있다.

또 실측된 사실: **삭제 경로가 만든 헤더는 `--allow-override-contract`로 만든 헤더와
바이트 동일**하다. 즉 새로운 fail-open이 아니라, 이미 문서화된 opt-out과 같은 결과에
도달하는 다른 경로다.

### 2.3 C 소비자 — 지금도 만들지 않는다

`CONTRACT_PROVENANCE_VERIFIED`를 C 게이트에 넣지 않은 이유는 `EVIDENCE_v0.20_E24b.md`
§10과 같다(cFS + IREE C 런타임을 이 컨테이너가 재빌드할 수 없다). 검증에서 **추가 근거가
하나 더 나왔다**: 넣더라도 `_Static_assert`/`#error`가 아니라 `GATE_BOUND_KNOWN` 조건부
런타임 검사여야 한다. `dynamic` 모델은 정당하게 `BOUND_KNOWN 0` / `PROVENANCE_VERIFIED 0`을
내므로, 컴파일 타임 단언은 그 앱을 **빌드 불가**로 만들어 A8 음성 시나리오를 삭제한다 —
E23이 D31로 출하한 과잉 거부와 같은 모양이다.

### 2.4 그래서 무엇이 남는가

이것은 코드로 닫을 문제가 아니라 **threat model 결정**이다. `CLAUDE.md`의 우선순위 0번이
이미 그 결정을 대기 항목으로 두고 있고, 검토 §5.2도 같은 말을 한다("계약 JSON을 외부
교환 형식으로 취급한다면 P1, 신뢰된 생성기 출력만 인정한다면 P2 hardening"). 결정 전에는
어느 쪽 코드를 넣어도 근거가 없다. 논문이 신뢰된 생성기 가정을 택하면 현 상태로 충분하고,
비신뢰 교환 형식을 택하면 필요한 것은 provenance 필수화가 아니라 **서명**이다.

## 3. F2 — "합을 확인할 수 없음"이 "합이 맞음"으로 붕괴 (D41)

D36(E24b/R2)의 `bounded == per_call + constants` 검사가
`is_int(_pc) and is_int(_cb) and bounded != _pc + _cb` 형태라, 두 값이 우연히 정수일 때만
실행됐다. 재현된 두 변종:

| 변종 | 결과 | 실제 메커니즘 |
|---|---|---|
| `static_per_call_bytes = null`, `bounded = 3528` | `BOUND_KNOWN 1` | 검사가 **실행되지 않음** |
| `per_call = bounded+1`, `constants = -1` | `BOUND_KNOWN 1` | 검사가 **돌고 공허하게 통과**(3529 + (-1) == 3528) |

**리뷰 서술은 첫 변종만 설명한다.** 두 번째는 "둘 다 정수"이고 검사가 실제로 실행된다 —
원인은 정수 여부가 아니라 **비음수 검사 부재**다. 이 구분은 수정 형태를 바꾼다.

이것은 이 저장소가 이미 세 번 고친 그 모양(D25 rodata `None`-vs-`[]`, D28 `None` 신호
통과, D29 스택 신뢰 신호 부재)이 게이트 안에 그대로 있던 것이다 — "관측할 수 없었다"가
"관측했고 일관됐다"로 붕괴.

**정상 경로 도달은 아니다**(`make_contract.py`가 세 값을 하나의 dict 리터럴에서 같은
`all_static` 게이트로, 부호 없는 정규식 캡처에서 만든다) → claim blocker가 아닌 hardening.

수정: `bound_known`일 때 두 구성요소가 **비음수 정수**임을 요구. 실측으로 좁힌 세 성질 —
`bound_known` 스코프 유지(풀면 A8 입력인 `dynamic` 2개 거부), `>= 0`이지 `> 0` 아님
(constants==0은 정당하고 실제 발생), `is_int`를 건너뛰기 조건이 아니라 요구 조건으로.
스키마 바이트 필드에 `minimum: 0`도 추가.

## 4. F3 — 예산 초과 "평가 불가"가 통과 (D42, **리뷰 처방보다 좁게**)

`subset_sum_match`가 총량 > 256 MiB에서 `None`을 반환하는데, 호출부는
`rodata_unavailable`(도구 부재)과 `False`(모순)만 거부했다. **같은 증거 상태**("독립 확인을
할 수 없었다")가 원인에 따라 다르게 처리되던 비대칭이다 — D25는 더 약한 근거로 거부하고
N1은 더 강한 근거로 거부하는데, 그 사이가 통과했다.

### 4.1 리뷰 처방을 그대로 쓰지 않은 이유 (실측)

"예산 초과를 기본 거부"는 **총량이 정확히 한 세그먼트인 정직한 >256 MiB 모델**을 거부한다:

| | `subset_sum_match(300 MiB, [300 MiB, 7])` |
|---|---|
| E24c 이전 (예산 검사가 먼저) | `None` → 리뷰 처방이면 **거부** |
| E24c (결정 절차가 먼저) | `True` → 거부하지 않음 |

### 4.2 채택한 형태 — 결정을 먼저, 예산 검사를 나중에

1. 총량과 정확히 같은 세그먼트가 있으면 즉시 `True` (O(n)).
2. 후보 세그먼트가 20개 이하면 `itertools.combinations`로 전수 결정 — **비용이 총량이
   아니라 개수에 의존**하므로 비트셋 DP가 감당 못 하는 바로 그 지점에서 감당 가능하다.
3. 둘 다 결론이 안 날 때만 `None`.

검증: 예산 초과 4종(한 세그먼트 일치 / 부분합 존재 / 전수 모순 / 세그먼트 과다) 전부
의도한 답, 무작위 3,000건 brute force 교차검증 **0 불일치**, in-budget 경로 비용 변화 없음.

### 4.3 기계 판독 가능한 상태 — 리뷰가 실제로 요구한 것

`constants_confirmation_state` 신설: `confirmed` / `contradicted` / `nothing_to_confirm` /
`not_observed` / `unevaluable_budget_exceeded`. E24b가 `constants_check_note`를 상태별
문장으로 고쳤지만 그것은 **자유 텍스트**라 게이트도 `cross_target_compare.py`도 소비할 수
없었다. 스키마에 선택 필드로 추가(부재를 특정 상태로 읽지 않는다 — E24b/R5와 같은 이유).

그리고 상태가 `unevaluable_budget_exceeded`면 기본 거부, `--allow-unverified-invocation`으로만
우회(D25와 같은 증거 상태이므로 같은 플래그). 이 저장소 아티팩트로는 도달 불가하므로
(최대 상수 총량 720,896 B = 예산의 1/372) E19가 하드 실패 배선을 확인한 것과 같은
in-process 방식으로 실제 발동을 확인했다.

## 5. F4 — 31상수 사례의 실물 근거 보존 (D43)

D38(24세그먼트 절단 제거)을 정당화한 "정상 단일 컴파일이 옛 상한보다 많은 세그먼트를
만든다"는 주장이 **합성 정수 배열로만** 고정돼 있었고, 실물 IREE 산출물이 저장소에 없어
저장소 내용만으로는 재현할 수 없었다. 작업 규율 4(증거 등급 명시)에 비추어 타당한 지적이다.

### 5.1 먼저 재현부터 — 에이전트 결론을 그대로 받지 않았다

재현 에이전트는 "3~5개 세그먼트, 재현 안 됨"으로 보고했다. 직접 확인하니 그것은 상수 수가
적은 기존 모델(mlp16k 등)을 쓴 결과였다. 세그먼트 수는 모델 크기가 아니라 **상수 풀 수**에
비례한다는 원래 서술대로, 31상수 모델에서는 실제로 옛 상한을 넘는다.

### 5.2 보존한 것

`harness/gen_model_manyconst.py`(신규)와 `results/e24c_manyconst31/`(440 KB, **한 번의
`iree-compile` 호출** 산출물: mlir·vmfb·layout IR·dump·`iree-dump-module` 출력·ELF 분석·
계약·헤더 + `invocation.json`에 argv·컴파일러 버전·sha256·관측 세그먼트 목록).

착수 중 두 가지가 걸렸고 둘 다 기록해 둔다:

- **dispatch가 하나면 안 된다.** 처음 만든 모델은 dispatch가 1개라 dump 파일명이
  `module_infer_dispatch_0_*`가 되고 mlir basename이 들어가지 않아, `make_contract.py`의
  one-invocation 검사(D10)가 **정당하게 거부**했다. 16x32 tail로 두 번째 dispatch를 강제하면
  `module_manyconst31_linked_*`가 생겨 통과한다. 생성기 docstring에 이 이유를 적었다.
- **dump/는 축소본이다.** `.o`/`.bc`/`.s`/`*.ll` 중간산출물을 뺐다. 계약이 **모든 수치
  동일**하게 재생성됨을 확인했고(차이는 `provenance.dump_dir_files` 목록뿐),
  `.gitignore`의 `*.o`(negation이 `results/e14_aarch64_qemu/**`에만 걸려 있음) 트랩도 함께
  피한다. 경로는 `e14_matrix.find_models()`가 glob하는 `<root>/models/*`를 피해 새 최상위에 뒀다.

### 5.3 수치 정정

이 저장소 자신의 `artifact_rodata_segments()` 기준으로는 **33개**다(embedded 1024 B 상수
슬랩 32 + external 1). 문서에 쓴 "31"은 모델의 상수 개수다. 결론(옛 24개 상한 초과)은 동일하다.

### 5.4 실물 기반 revert-and-confirm

같은 실물 입력에 대해:

| 구현 | `subset_sum_match(33792, segs)` |
|---|---|
| 현재 (tri-state) | `True` |
| E24b 이전 (앞 24개만) | `False` — 앞 24개 합 24576 < 33792 |

즉 **정직한 계약에 거짓 진술을 썼을 것**임을 합성 배열이 아니라 실물로 실증했다.
6건 회귀 시험으로 고정(4건은 stdlib 전용이라 모든 CI 레그에서 실행).

## 6. F5 — "unsigned 비교" 원인 서술 철회 (D44)

`docs/EVIDENCE_v0.20_E24b.md` §12에 정오표를 넣었고, 요약은 다음과 같다.

`native/cfs_app/fsw/src/ai_learner.c`의 `es_stack`과 `stack_needed`는 **둘 다 signed `long`**
이고 `info.StackSize`는 명시적으로 `(long)`으로 캐스트된다. unsigned 비교가 아니다.
올바른 인과는 `stack_needed = 262144 + (-300000) = -37856`(음수)이라 비음수인 어떤
`es_stack`도 `>=`를 만족한다는 것이다.

**인과가 반대로 틀렸다는 점이 중요하다** — 실제 unsigned 비교였다면
`(unsigned long)(-37856) = 1.8e19`로 wrap돼 현실적인 모든 스택에서 오히려 **거부**됐을
것이다(재컴파일 확인). 즉 "실제 C 식으로 컴파일해 확인"이라는 표시가 **실행이 반증하는
주장**에 찍혀 있었다. 작업 규율 4가 경계하는 형태 그대로다.

**판정은 유지되고 하나가 추가된다**: 항등식 결론은 올바른 signed 해석에서도 성립하고,
재컴파일 결과 `es_stack = -1`(`CFE_ES_GetAppInfo` 실패 시 초기값)에서도 참이다 — 검토도
E24b도 짚지 않은 것으로, 음수 계약 스택은 "정보를 못 얻으면 거부한다"는 방어까지
무력화한다. D35의 claim blocker 판정과 E24b의 코드 수정은 전부 유효하다.

정정 7곳. 그중 **가장 위험했던 것은 대소문자 무시 `grep`으로만 잡히는
`harness/gen_contract_header.py`의 음수 스택 가드 바로 위 주석**이다 — 살아있는
fail-closed 가드의 존재 이유를 설명하는 자리라 유지보수자의 판단 근거가 된다. 그 주석에
"`(long)` 캐스트를 unsigned 해석을 근거로 제거하지 말 것"이라는 경고도 넣었다(제거하면
정상값 262335를 포함해 **모든** 스택이 거부됨을 실측).

## 7. 신규 결함 번호

| ID | 요약 |
|---|---|
| D41 | D36의 합 항등식이 `is_int` 검사를 **건너뛰기 조건**으로 써서 `null` 구성요소가 검사를 무력화하고, 비음수 검사 부재로 `-1` 구성요소가 항등식을 공허하게 만족시킴(F2) |
| D42 | `subset_sum_match`의 예산 초과 `None`이 기본 거부되지 않아, D25("관측 불가")와 N1("관측했더니 모순") 사이의 같은 증거 상태가 통과. 기계 판독 가능한 판별자도 없었음(F3) |
| D43 | D38을 정당화한 ">24 세그먼트" 사례의 실물 IREE 산출물이 보존되지 않아 저장소 내용만으로 재현 불가. 수치도 부정확(모델 상수 31개 ≠ 세그먼트 33개)(F4) |
| D44 | **방법론**: D35의 원인을 "unsigned 비교"로 서술했으나 실제 코드는 signed `long` 비교다. 인과가 반대로 틀렸고(unsigned였다면 거부됐다), 그 서술에 "컴파일로 확인" 표시가 붙어 있었다. 7곳에 전파(F5) |

## 8. 시험 수치

| 단계 | 이 컨테이너 실측 |
|---|---|
| E24b 종료 시점 | 170/170 |
| F4 후 | 176/176 |
| F5 후 (행위 변화 없음) | 176/176 |
| F2 후 | 180/180 |
| F3 후 | **191/191** |

D34의 교훈에 따라 CI 세 레그 값은 추정하지 않았다 — 실측을 §8.1에 기록했다.

### 8.1 CI 실측 (커밋 `50f16d0`, run 34317796718 — 세 레그 전부 success)

| 레그 | 설치물 | v0.20 실측 | **v0.21 실측** |
|---|---|---|---|
| `full` | `requirements.txt` | 169/169 + 1 SKIP | **190/190 + 1 SKIP** |
| `without-iree` | `jsonschema`만 | 85/85 + 9 SKIP | **103/103 + 11 SKIP** |
| `stdlib-only` | 아무것도 설치 안 함 | 85/85 + 9 SKIP | **103/103 + 11 SKIP** |

- `full`의 SKIP 1건은 워크플로우 YAML 파싱 검사이며 PyYAML이 `requirements.txt`에 없어서다.
  이 개발 컨테이너는 PyYAML이 있어 191/191이다 — D34가 지적한 조건이므로 추정하지 않고
  양쪽을 조건과 함께 병기한다.
- 뒤 두 레그의 SKIP이 9 → 11로 늘어난 것은 E24c가 추가한 시험 중 2건
  (`manyconst31` 세그먼트 재관측, F3 게이트 발동)이 `iree-dump-module`을 요구하기 때문이다.
  **정직한 SKIP이며 커버리지 손실이 아니다** — 같은 사실을 도구 없이 확인하는 4건
  (기록된 세그먼트 목록으로 현재/옛 구현 대조)이 그 레그에서도 실행된다.
- `full` 레그에서 보관 14개 계약 **diff 0**, 14개 헤더 **바이트 동일**이 CI에서 재확인됐다
  (`constants_confirmation_state`는 새로 기록되는 사실이라 diff에서 제외 — §4.3).

## 9. 이번 범위 밖 (명시)

- **F1의 코드 수정** — §2. threat model 결정(`CLAUDE.md` 우선순위 0) 전에는 근거가 없다.
- **`plugins/compiled_learner/runtime/contract.json`의 스키마 미달 6건** — F2 작업 중 확인:
  `memory_boundary` 등이 없어 **E24c 이전부터** 스키마 무효였다(제 변경이 만든 것이 아님을
  `git stash`로 확인). 검토 §6도 "정리 대상이나 핵심 반증은 아님"으로 분류했다. D31의
  교훈대로 생성기(`harness/gen_model.py`)부터 고쳐야 휘발되지 않으므로 별도 항목으로 남긴다.
- **C 게이트의 `CONTRACT_PROVENANCE_VERIFIED` 소비** — §2.3.
- E25·E26·E27(연구 질문) — 이번 작업의 목적이 그 앞을 닫는 것이었다.

## 10. 재현

```bash
python3 harness/contract_negative_tests.py            # 191/191 (전 의존성 설치 시)

# F4의 실물 근거를 처음부터 다시 만들기 (results/e24c_manyconst31/invocation.json의 argv와 동일)
python3 harness/gen_model_manyconst.py --out /tmp/manyconst31.mlir
iree-compile /tmp/manyconst31.mlir -o /tmp/manyconst31.vmfb \
  --iree-hal-target-device=local --iree-hal-local-target-device-backends=llvm-cpu \
  --iree-llvmcpu-target-triple=x86_64-unknown-linux-gnu --iree-llvmcpu-target-cpu=host \
  --iree-stream-resource-max-allocation-size=1024
iree-dump-module /tmp/manyconst31.vmfb | grep -c 'rodata\['
```
