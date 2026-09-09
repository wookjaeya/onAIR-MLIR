# EVIDENCE v0.19 — E24: fail-closed 계약 불변식 닫기 (외부 검토 v0.18-후속 N1–N6, S5)

## 0. 등급과 범위

**증거 등급: 결정론적**(계약/헤더 생성의 성공·실패, 생성물 바이트 비교, 시험 통과 수). 이 실험은
계약 도구 체인의 판정 로직과 그 시험 하네스만 다룬다 — 계약이 계산하는 **수치 자체는 하나도 바꾸지
않았다**(보관 14개 계약 diff 0, 14개 헤더 바이트 동일).

**범위**: `docs/reviews/REVIEW_v0_18_FOLLOWUP.md`(기준 커밋 `52bff0d`)의 N1–N6과 §5(S5). 이 검토는
E21–E23을 "실제 품질 향상"으로 인정하면서도, **검증 불가 또는 모순 상태에서도
`CONTRACT_BOUND_KNOWN=1` 헤더가 생성되는 경로가 남아 있다**고 지적했다. 그 지적은 사실이었다.

**범위 밖**: 게스트 cFS 재실행(환경 부재), OnAIR↔native/cFS 출력 동치(우선순위 8),
weights.npz의 계약 결속(§7), `subset_sum_match`의 tri-state 리팩터링(§7).

## 1. 검증 방법 — 리뷰를 믿지 않고 21개 에이전트로 먼저 재현

이 저장소의 확립된 방법론(E20·E21이 쓴 것)을 그대로 적용했다: 리뷰의 주장을 반영하기 전에 **독립
에이전트가 실제 코드를 실행해 재현**하고, 재현된 것은 다시 **반박 전담 검증자**에게 넘긴다.

- 1차 재현 7건(N1–N6, S5) — 저장소 수정 금지, 실제 명령 실행 필수, "재현 안 되면 refuted가 옳은
  결과"임을 명시.
- finding당 반박 2인 = 14건. 한 명은 **주장 자체를 반박**하도록(다른 방어층이 이미 막고 있지
  않은가, 인위적 조건에만 의존하지 않는가), 다른 한 명은 **제안된 수정이 과잉 거부를 유발하는지**를
  보관 14개 계약으로 실측하도록 지시.

결과: **7건 전부 confirmed, 반박 0건.** 그러나 심각도는 리뷰와 달랐고, 무엇보다 **리뷰가 제안한
수정 3건은 실측 결과 과잉 거부를 유발**했다.

| finding | 리뷰 | 이번 판정 | 리뷰 제안을 그대로 쓸 수 있는가 |
|---|---|---|---|
| N1 상수 모순이 통과 | P0 | **P1** | **아니오** — `dynamic` 계약 2개(A8 시나리오 입력)를 거부 |
| N2 one-invocation None이 통과 | P0 | **P0** | 예(다만 catch-all을 None 전용으로 좁힘) |
| N3 f16이 ALL_F32=1 | P0 | **P1** | **아니오** — 이 저장소 스키마의 정본 형태를 거부 |
| N4 스택 classification 부재가 KNOWN | P1 | **P2** | 예 |
| N5 기본 fixture 거부 회귀 | P1 | **P1** | **아니오** — 생성기를 먼저 고쳐야 함(휘발성) |
| N6 CI 명칭 | P2 | **P2** | 부분 — 블록 통째 SKIP은 43건 손실 |
| S5 잔여 증거 5건 | — | 5건 전부 사실 | 문서 정정만 즉시 가능 |

## 2. N2 (P0) — 비어 있지 않은 dump-dir에서 신호가 None이면 그대로 통과

### 2.1 재현

E21의 F1은 `--dump-dir`이 **완전히 빈** 경우만 막았다. 파일은 있는데 링크된 `.so`만 없으면
`dump_elf_in_vmfb=None`이 되는데, 어느 분기도 None을 보지 않았다.

```
$ cp -r results/e14_aarch64_qemu/aarch64/dump/conv2d /tmp/dump-noso && rm /tmp/dump-noso/*.so
$ python3 harness/make_contract.py ... --dump-dir /tmp/dump-noso ...     # 우회 플래그 없음
exit = 0
provenance.single_invocation = false
provenance.dump_elf          = null
notes                        = []          <- 한 줄도 설명이 없다
$ python3 harness/gen_contract_header.py <그 계약> hdr.h
exit = 0 ; CONTRACT_BOUND_KNOWN 1          <- 배치 가능한 헤더
```

**손으로 파일을 지우지 않아도 도달한다**: 컴파일 시 메타 플래그
`--iree-hal-dump-executable-files-to` 대신 구성 요소 플래그
(`--iree-hal-dump-executable-{sources,intermediates}-to`)만 주면 정확히 이 모양의 dump-dir이 나온다.

**escalation(이게 fail-open인 이유)**: 같은 dump-dir에 **다른 모델의 vmfb**를 짝지어도 계약이
나왔다 — D10이 닫았던 구멍이 None 경로로 재개방된 것이다.

### 2.2 수정

세 신호가 `None`일 때를 잡는 catch-all을 신설하되 **None 전용으로 한정**했다. `False`는 이미
우회 불가능한 전용 분기가 있고, 거기에 섞으면 (a) 진단이 중복되고 (b) **검증된 불일치를
`--allow-*`로 우회 가능한 것처럼 오도**한다. `single_invocation`도 `is not False` → `is True`.
D14 이후 계산만 하고 버리던 두 신호(`layout_dispatch_names`, `layout_dispatches_in_dump`)를
provenance에 기록해 "무엇이 확인됐는지"를 검토 가능하게 만들었다.

**gen_contract_header에 두 번째 게이트는 넣지 않았다.** 반박 검증이 실측했다: `provenance`를
required로 두지 않는 이 저장소 스키마에서 체크인된 예시 계약 3개는 provenance가 없는 정상
계약이고, `native/build.sh`와 `scripts/62_compile_and_check_aarch64.sh`(CLAUDE.md가 스모크
테스트로 문서화한 경로)가 만드는 계약도 그렇다 — `is not True` 게이트는 이들을 전부 거부한다.
2.2의 수정이 들어가면 `single_invocation=false` 계약은 **의도적으로 `--allow-unverified-invocation`을
준 경우에만** 생기므로, 두 번째 게이트의 실효는 "운영자가 배치 시점에 그 의도를 한 번 더
반복하게 만드는 것"뿐이다. 그 이득보다 위 두 스크립트를 깨뜨리는 손해가 크다.

## 3. N1 (P1) — "관측했더니 모순"이 "관측 불가"보다 약하게 처리됨

### 3.1 재현

E23의 D25는 `iree-dump-module`을 실행하지 못한 경우(`None`)를 거부하도록 만들었다. 그런데 도구가
실제로 돌아 **관측 결과가 IR 상수량과 모순**되는 경우(`False`)는 `constants_check_note` 문자열로만
남고 거부되지 않았다. 더 강한 부정 증거가 더 약하게 처리된 것이다.

가짜 `iree-dump-module`을 PATH에 놓아 `.rodata` 한 세그먼트를 2176 → 1로 보고하게 했다:

```
make_contract exit       = 0
constants confirmed      = false
constants_check_note     = "module constant total 2176 B NOT matched by artifact .rodata segments [1, 6344]"
provenance.notes         = []            <- 다른 저하 신호는 전부 여기 기록되는데 이것만 빠진다
gen_contract_header exit = 0 ; CONTRACT_BOUND_KNOWN 1
헤더는 정상본과 바이트 동일 (diff 결과 없음)
```

### 3.2 왜 리뷰의 수정을 그대로 쓸 수 없는가 (실측)

리뷰는 `consts_confirmed is not True`를 기본 거부하라고 했다. 그렇게 하면 **보관 14개 중 2개가
거부된다** — `dynamic`(aarch64/x86_64)이다. 원인은 `subset_sum_match()`가 `total <= 0`일 때도
`False`를 반환하기 때문이다. 즉 "확인할 것이 없음"과 "확인했더니 모순"이 같은 값으로 인코딩돼
있다. D25가 한 단계 위에서 배운 tri-state 교훈이 여기서 반복된다. 이 두 계약은 A8
(UNKNOWN_BOUND 거부) 시나리오의 입력이므로, 거부하면 그 음성 시험 자체를 만들 수 없게 된다.

1차 검증자가 제안한 carve-out(`const_b > 0 and confirmed is False`)도 **여전히 과잉 거부한다**:
반박 검증자가 저장소 시험을 돌려 `structural-bugfix(B): packing-padded mlp16k layout IR still
ACCEPTED`가 FAIL하는 것을 확인했다. 그것은 **D17/E20이 과잉 거부 결함으로 고친 바로 그
정렬 패딩 사례**다(`const_b = 720960 >= dense_sum = 720896`, 건전한 과대추정).

### 3.3 채택한 게이트

```python
_consts_truncated = data_segs is not None and len(data_segs) > SUBSET_SUM_MAX_SEGMENTS
_consts_pad_ok    = bool(consts_confirmed_dense) and dense_sum > 0 and const_b >= dense_sum
if const_b > 0 and consts_confirmed is False and not _consts_truncated and not _consts_pad_ok:
    ...  # notes에 기록 + --allow-unconfirmed-constants 없으면 거부
```

carve-out 3개는 각각 `subset_sum_match`가 `False`로 뭉뚱그리는 서로 다른 상태다: (1) 확인 대상
없음, (2) 세그먼트 24개 초과로 열거 포기, (3) 정렬 패딩. 새 플래그
`--allow-unconfirmed-constants`는 `--allow-unverified-invocation`과 **분리**했다 — 전자는
"관측했고 불일치", 후자는 "관측 못 함"으로 의미가 다르다.

## 4. N3 (P1) — 빈 dtype 집합이 "전부 f32"로 읽힘 (공허참)

`contracts/contract.schema.json`은 `interface.input`/`output`(단수형)을 required로 두고
`inputs`/`outputs`(복수형 배열)는 **선언조차 하지 않는다**. 그런데 `gen_contract_header.py`는
개수와 dtype을 복수형에서만 읽었다. 복수형이 없으면 dtype 집합이 **빈 집합**이 되고,
게이트와 매크로가 둘 다 `dtypes - {"f32"}`를 검사하므로 빈 집합과 `{"f32"}`가 구분되지 않는다.

실측한 변종 3개가 전부 `CONTRACT_DTYPES_ALL_F32 1`을 냈다: (m1) 복수형 삭제 + 단수형 f16,
(m2) 복수형 빈 배열 + 단수형 f16, (m3) **복수형은 f32인데 단수형이 f16**(두 표현이 서로 모순).
기존 음성 시험(L234)은 복수형만 변형해서 이 경로를 하나도 잡지 못했다.

**수정**: 스키마 필수 필드인 단수형의 dtype을 집합에 합치고, 매크로에 `dtypes and`(빈 관측으로
"전부 f32"를 주장하지 않음)를 요구했다. **복수형 부재 시 거부하는 strict 변종은 채택하지
않았다** — 실측으로 `contracts/contract.filled.example.json`·`contract.e13_host.json`(이 저장소
스키마가 선언하는 정본 형태의 정직한 f32 계약)을 거부한다.

**추가로 발견한 과잉 거부 1건(내 수정이 만든 것)**: 단수형을 `interface`에서만 읽으면
`contracts/contract.e14_aarch64.json`이 거부된다 — 이 계약은 `interface` 블록 자체가 없고 dtype을
`validity.input/output`에 f32로 선언한다. 같은 파일의 `shape_from()`이 이미 두 블록을 다 보는 것과
같은 규칙으로 맞춰 해소했다. 이것은 검증 워크플로우의 반박자도 놓친 것으로, 실제 데이터를
직접 돌려 확인하지 않았다면 새 과잉 거부를 출하할 뻔했다.

## 5. N4 (P2) — 신뢰 신호의 '부재'가 '신뢰함'과 구분되지 않음

E21의 F6(D22)은 세 불신뢰 신호를 검사하지만 `bool()`/`not in (None, ...)`으로 읽어서,
**필드가 없는 것**과 **필드가 "신뢰함"이라 말하는 것**이 같아졌다. 보관 conv2d 계약에서
`kernel_stack_classification` 키만 지워도 `KERNEL_STACK_BYTES_KNOWN=1` 헤더가 바이트 동일하게
나온다(키를 `null`로 두거나, 세 키를 전부 지워도 마찬가지, `kernel_external_call_insns`만
지워도 마찬가지 — 리뷰가 서술한 것보다 구멍이 넓다).

수정은 세 신호를 `is not False` / `!= 0` / `not in (...)`로 바꿔 `None`을 명시적으로 불신뢰로
둔 것이다. `bound_known` 조건부 범위 제한은 **넣지 않았다** — 주변 게이트가 이미 그 범위를
제공하고, 조건을 넣으면 dynamic 경로의 fail-open이 되살아난다(반박 검증 2인이 각각 실측).
`and is_int(stack)` 가드도 함께 넣었는데, 이는 no-ELF 경로에서 기존 코드가 이미 내던 오진
("a numeric stack figure is present (None)")까지 고친다.

## 6. N5·N6 — 요약 (상세는 커밋 메시지와 §9 정오표)

- **N5(P1)**: E23이 D27로 추가한 OnAIR 바인딩 게이트가 **저장소 기본 fixture를 거부**했다 —
  결함 유형 (B) 과잉 거부. 리뷰의 "fixture 재생성" 권고는 그대로 쓸 수 없다: `gen_model.py`도 같은
  결손을 갖고 `sweep.py`가 그 디렉터리를 매 스텝 재작성하므로 **데이터만 고치면 휘발성**이다.
  생성기 → fixture → 스키마 순으로 고치고, `artifact_binding_and_corruption_cases()` 밖에 stdlib
  전용 독립 함수로 통합 시험을 등록했다(그 함수는 E14 vmfb 부재 시 조기 반환하므로 무의존성
  환경에서 조용히 스킵된다).
- **N6(P2)**: CI `without-deps` 레그가 `jsonschema`를 설치하므로 정확히는 "without IREE"다.
  표현 문제만이 아니었다 — `jsonschema`만 없는 조건에서 시험이 **98/113, FAIL 15건**(전부 거짓
  경보)을 냈고, `scripts/99_bootstrap_all.sh` 경로가 그것을 설치하지 않아 **도달 가능**했다.
  `schema_validator_available()` + 좁은 degrade로 고쳤다(블록 통째 SKIP은 jsonschema가 전혀
  필요 없는 43건까지 버린다 — 거짓 경보를 피하려고 보는 것을 그만두는 것은 하네스에서
  fail-open과 같은 실패 형태다). CI에 `stdlib-only` 레그 신설.

### 6.1 D33 — 이 실험 자신이 만든 결함 (CI가 다시 잡았다)

위 N6 수정으로 CI에 `stdlib-only` 레그를 추가하면서, 그 단계의 `run:` 스칼라에 콜론+공백이 든
Python 문자열(`print('stdlib-only leg: no packages installed')`)을 넣었다. YAML에서 따옴표 없는
스칼라 안의 `": "`는 매핑 구분자이므로 **워크플로우 파일 전체가 파싱 불가**가 됐고, 푸시 즉시
실행이 실패했다 — 실행 이름이 워크플로우 이름이 아니라 **파일 경로**로 표시되는 것이 그 신호다
(단계가 하나도 시작되지 않았다).

이것은 **CI가 구조적으로 "어떤 시험이 실패했다"로 보고할 수 없는 유일한 결함 부류**다. D24(모듈
부재 크래시)·D25(콘솔 스크립트 부재 크래시)와 같은 계열 — 하네스가 자신이 덮어야 할 조건을 볼 수
없는 상태다. 그래서 수정과 함께 `workflow_yaml_cases()`를 신설해 `.github/workflows/*.yml`이
파싱되고 `name`·`jobs`를 선언하는지 검사하도록 했다(PyYAML 부재 시 SKIP — 이 저장소 의존성이
아니고, GitHub 자신의 파서가 최종 권위다). 깨진 YAML로 되돌려 그 시험이 실제로 같은
`ScannerError`를 잡아내는 것을 확인했다.


### 6.2 같은 실수의 세 번째 반복 — 저자 환경 수치를 인용한 것

이 문서의 초판은 `full` 레그를 **143/143**으로 적었다. 그것은 이 컨테이너의 값이고, `fresh
clone` + `pip install -r requirements.txt`의 값은 **142/142 + 1 SKIP**이다 — PyYAML이
`requirements.txt`에 없기 때문이다. **CI가 다시 반증했다.**

이건 이 저장소가 세 번째 겪는 같은 부류다: F9(E22 — "96/96, 환경 구축 불필요"가 저자 환경
에서만 성립), D25(E23 — 로컬 import 차단이 콘솔 스크립트를 남겨 CI만 잡을 수 있던 조건),
그리고 이번. 교훈은 매번 같다 — **"내 환경에서 돌려봤다"는 fresh checkout의 근거가 아니다.**
E24가 `stdlib-only` 레그를 신설한 이유도 정확히 이것이었는데, 정작 그 레그가 잡아낸 첫 대상이
E24 자신의 문서 수치였다.

수정: 이 문서·README·CLAUDE.md·EXPERIMENT_LOG의 수치를 전부 **CI 실측값**으로 바꿨다. PyYAML을
`requirements.txt`에 추가하지는 않았다 — §6.1의 시험은 본질적으로 **푸시 전 로컬 가드**이고
(워크플로우 파일이 깨지면 CI는 애초에 실행되지 않으므로 CI에서는 잡을 수 없다), 이 검사
하나 때문에 배포 의존성을 늘리는 것은 균형이 맞지 않는다.


## 7. 이번 실험이 다루지 않는 것 (범위 밖)

- **`subset_sum_match`의 tri-state 리팩터링**: §3의 carve-out 3개는 이 함수가 `False`로
  뭉뚱그리는 세 상태를 호출부에서 분리한 것이다. 구조적으로는 함수 자신이 `None`("확인할 것
  없음", "열거 포기")과 `False`("전수 열거 후 불일치")를 구분하는 것이 옳다. 그렇게 하면
  저장된 `dynamic` 계약 2개의 `constants_check_note` 텍스트가 바뀌어 diff-0 회귀 불변식을
  깨뜨리므로, 의도적 재생성을 동반하는 별도 작업으로 남긴다.
- **weights.npz의 계약 결속**: 기본 OnAIR fixture에서 계약이 서명하는 것은 `model.vmfb`
  10,642 B뿐이고 `weights.npz` 2,884,078 B는 계약 밖이다 — 가중치 교체 형태의 A3는 이 게이트를
  통과한다(§9.1(b) 정오표에 기록). 구조적 해결(baked-weight 이관 또는 artifact bundle manifest)은
  "정상 입력"의 정의를 바꾸므로 우선순위 8의 별도 실험이다. 반박 검증이 실측했다: 이번에
  `weights`/`input_mapping`을 required로 만들면 **보관 14개 계약 전부**가 두 계층 모두에서
  거부된다(배포 모델이 baked-weight라 어떤 재생성으로도 weights 블록을 만들 수 없다).
- **기본 fixture의 스키마 적합성**: `artifact.bytes`를 채운 뒤에도 이 fixture는 `resources`·
  `timing` 블록이 현행 스키마에 미달한다(E0 시절 부분 계약, 6건 위반). 이번에 복원한 것은
  **바인딩 게이트 통과와 플러그인 기동**뿐이며 "현행 세대 계약이 됐다"는 주장은 하지 않는다.
- **게스트 cFS 재실행**: 새 A5b 생성기(E23)로 AArch64 게스트 시나리오를 재실행한 raw log는
  여전히 없다(환경 부재). S5 항목 1은 사실이며 해소되지 않았다.
- **출력 동치 end-to-end 시험**: S5 항목 2도 사실이며 우선순위 8에 그대로 남는다.

## 8. 판정

리뷰가 지적한 **"검증 불가·모순 상태에서도 배치 가능한 헤더가 나온다"는 경로 4개를 실제
재현 후 닫았다**(N1·N2·N3·N4). E23이 함께 출하한 과잉 거부 회귀 1건(N5)과, 시험 하네스가
`jsonschema` 부재를 거짓 FAIL로 보고하던 문제(N6)도 고쳤다.

동시에 이 실험은 **리뷰를 그대로 적용했다면 새 과잉 거부 3건을 만들었을 것**임을 실측으로
보였다(§3.2, §4). 이 저장소의 결함 정의가 양방향(fail-open과 과잉 거부 모두 결함)이라는 점이
이번에도 결정적이었다 — E20이 D16·D17로 겪었던 함정과 같은 종류다.

시험 **125/125 → 142/142 + 1 SKIP**(CI 실측, 신규 18건). 수정 전 코드로 되돌려 신규 시험이 실제로 실패함을
확인(revert-and-confirm-fail): make_contract/gen_contract_header 12건, 기본 fixture 1건,
워크플로우 YAML 1건(§6.1) = 14건. 나머지 4건은 내 수정이 정상 입력을 거부하지 않는지 지키는
**과잉 거부 가드**(dtype을 `validity.*`에만 적은 계약이 여전히 통과하는지, 상수 0인 모델이
여전히 빌드되는지 등)라 수정 전에도 통과하는 것이 옳다. 보관 14개 계약 diff 0, 14개 헤더
바이트 동일, 레거시 예시 계약 3개 영향 0.

**CI 실측(커밋 `dc13ad9`, GitHub 러너)**: `full` **142/142 + 1 SKIP** · `without-iree`
**58/58 + 9 SKIP** · `stdlib-only` **58/58 + 9 SKIP**. 이 저장소 컨테이너에서는 `full`이
**143/143**인데, 그 차이는 PyYAML이 시스템 패키지로 깔려 있어 §6.1의 시험이 실제로 돌기
때문이다 — `requirements.txt`에는 없으므로 **fresh clone의 값은 142/142 + 1 SKIP이 맞다**.
처음 이 문서에 쓴 143/143은 저자 환경 수치였고, CI가 그것을 반증했다(§6.2).

`without-iree`와 `stdlib-only`가 같은 값인 것도 실측이다: IREE 도구가 없으면 `jsonschema`를
쓰는 경로(14개 계약 재생성)가 이미 전부 SKIP되므로, 이 커밋에서 두 레그는 같은 것을 측정한다.
`without-iree` 레그는 **오늘은 `stdlib-only` 대비 추가 커버리지가 없다** — IREE와 무관하게
`jsonschema`를 쓰는 경로가 생기면 그때 갈라진다. E23이 이 레그에 대해 기록한 48/48+6은 그
시점의 값이며, E24가 IREE를 요구하지 않는 시험을 여럿 추가해 58/58+9로 올라갔다.

**리뷰가 제시한 "안전하게 쓸 수 있는 문장"에 대해**: 리뷰 §6은 E24를 닫은 뒤에야 그 문장을
논문 핵심 주장으로 쓸 수 있다고 했다. 이번 실험은 그 합격조건 9개 중 1·2·4·5·6·8을 닫았고,
3(헤더 단계 `single_invocation` 게이트)은 **실측 근거로 채택하지 않았으며**(§2.2), 7(weights)과
9(게스트 재실행)는 범위 밖으로 남는다. 따라서 이 저장소의 중심 문장은
`docs/EVIDENCE_v0.9_E14_stage1.md` §11.8의 정오표 반영 개정판을 **그대로 유지한다** — 이번
실험은 그 문장을 넓히지 않고, 그 문장이 전제하는 "잘못된 계약은 배치 전에 거부된다"는 성질의
반례 4개를 제거했다.

## 9. 재현

```bash
# 게이트 양방향 (N1/N2)
cp -r results/e14_aarch64_qemu/aarch64/dump/conv2d /tmp/d && rm /tmp/d/*.so
python3 harness/make_contract.py --mlir results/e14_aarch64_qemu/models/conv2d/conv2d_baked.mlir \
  --vmfb results/e14_aarch64_qemu/aarch64/vmfb/conv2d.vmfb \
  --layout-ir results/e14_aarch64_qemu/aarch64/layout_ir/conv2d.layout_ir.txt \
  --dump-dir /tmp/d --triple aarch64-unknown-linux-gnu --cpu cortex-a53 --model-name conv2d \
  --out /tmp/c.json --extra-args "--mlir-elide-elementsattrs-if-larger=16"   # exit 1, 파일 없음

# 전체 시험 (세 환경)
python3 harness/contract_negative_tests.py   # 142/142+1 SKIP (fresh clone) / 143/143 (PyYAML 있으면)
PYTHONPATH=<jsonschema 스텁 디렉터리> python3 harness/contract_negative_tests.py   # 이 컨테이너 142/142+1
env -i PATH=<pip 없는 venv>/bin:/usr/bin:/bin <venv>/bin/python3 \
  harness/contract_negative_tests.py                           # 58/58 + 9 SKIP (CI와 동일)
```
