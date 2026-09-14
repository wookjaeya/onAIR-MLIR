# EVIDENCE v0.55 — E39b: 선행연구 원문 대조와 등급 상향

- 실험 ID: **E39b** · 날짜: 2026-09-12 · 계획 커밋: `56a817d` (**측정 이전**)
- 사전 고정 기준: `docs/plans/E39b_prior_art_fulltext.md`
- 근거: `docs/EVIDENCE_v0.49_E47.md` §7(E39a의 과잉 일반화 정정) · `DECISIONS_v0_52_REVIEW.md` §5 "병행"
- 증거 등급: **결정론적**(커밋 고정 URL · sha256 · 인용의 기계 검증). 지연값 없음.
- 산출물: `results/e39_prior_art/fulltext/fulltext_check.json`
- 회귀: 이 컨테이너 **809/809 → 821/821** (FAIL 0 · SKIP 0)
- **CI 실측**(커밋 `c31598d`, run 230, 3레그 success): `full` **815/815 + 4 SKIP** · `without-iree` **645/645 + 36 SKIP** · `stdlib-only` **645/645 + 36 SKIP**. 세 레그 전부 **PASS +12 · SKIP 증가 0**이라 E39b 신규 12건이 **전부 나타난다** — 즉 **live 재실행 가드가 CI에서도 실제로 돌았고**, 그것은 CI 러너에서도 `raw.githubusercontent.com`에 도달한다는 뜻이다(이 컨테이너의 관측이 다른 환경에서 재현됐다). 이 컨테이너(실입력이 있으면 **821/821 + 0 SKIP**)와 `full`의 PASS 차이 **6건**은 E38이 확립한 다섯(PyYAML 1 · objdump 미설치 SKIP 2 · 그 툴체인이 없으면 분기가 아예 없어 존재하지 않는 2)에 **E52의 실입력 live 재실행 1건**이 더해진 것이고, SKIP 차이 4건도 같은 넷이다.

## §0 판정

**Q1~Q5 전부 PASS.** 세 문헌을 전문 취득해 **인용 13건 전부를 기계가 원문에서 확인**했고,
그 대조가 **E39a 서술 5건의 정정을 요구**했다. `peer_reviewed_fulltext`는 **0건**이다.

## §1 취득 — 브랜치가 아니라 커밋에 고정

| 문헌 | 커밋 | 바이트 | 등급 |
|---|---|---:|---|
| TVM USMP RFC 0009 | `8e5c1250` | 30,902 | `project_doc_fulltext` |
| ExecuTorch memory planning | `df6147af` | 7,815 | `project_doc_fulltext` |
| TFLM memory management | `d0318206` | 9,849 | `project_doc_fulltext` |
| TFLM `micro_interpreter.h` | `d0318206` | 8,712 | `source_fulltext` |

`git ls-remote`로 각 저장소의 main tip을 읽어 **커밋 고정 URL**로 받았고, 브랜치 URL로 받은
바이트와 **네 건 모두 동일**함을 확인했다 — 브랜치 tip은 움직이므로 거기서 뜬 해시는 **문서가
아니라 한 순간의 식별자**다. 원문은 **저장소에 반입하지 않는다**(라이선스가 제각각이고 이 저장소가
필요로 하는 것은 대조 결과이지 사본이 아니다 — E45의 ad01 규칙과 같은 형태).

**계획 §2가 미리 막은 fail-open**: GitHub의 RFC·docs·헤더를 *"논문 원문을 읽었다"*로 승격하면
그것이 E47이 경고한 A9 등급의 fail-open이다. 등급 값 자체를 **문서 종류별로 분리**했고
`fulltext`(논문 원문)는 **이 실험에서 부여 가능한 값이 아니다**.

## §2 대조 — 인용을 기계가 검증한다

각 주장은 **인용**(원문에 있어야 한다)이나 **부재 문자열**(없어야 한다)을 달고, 도구가 취득한
바이트에서 직접 확인한다. 지어내거나 드리프트한 인용은 기록되는 대신 **실행을 실패시킨다**.
**13건 전부 통과**(`quote_found` 거짓 0 · `absent_confirmed` 거짓 0 · unchecked 0).

### 정정 5건

| 문헌 | 축 | E39a | 원문 대조 결과 |
|---|---|---|---|
| TVM USMP | A2 | *"workspace pool + **constant pool**"* | **`constant pool` 0건.** 그 역할은 `--usmp-parameter-pools`가 한다 — 개념 대응은 맞고 **용어가 원문과 다르다** |
| ExecuTorch | A1 | *"컴파일러 IR (**EXIR**)"* | **`EXIR` 0건.** 입력은 `ExportedProgram`이고 emission 직전 단계라는 점만 확인된다 |
| ExecuTorch | A5 | *"**enforced** (사용자 할당 버퍼)"* | 문서가 말하는 것은 *계획하지 않은 I/O는 사용자가 버퍼를 준다*까지다. **계획된 arena를 누가 잡는지는 이 문서에 없다** — E44의 구분(호출의 존재 ≠ 이 예산의 예약)을 적용하면 `enforced`는 이 문헌만으로 확정되지 않는다 |
| ExecuTorch | basis | *"greedy best-fit **기본**"* | 두 알고리즘(naive·Greedy)을 **제공**한다는 것은 확인되지만 **어느 쪽이 기본값인지는 이 문서에 없다** |
| TFLM | A9 | *"`docs/memory_management.md`는 이 값을 **'For debugging only'**로만 표기하고"* | **D91 — 아래 §3** |

## §3 D91 — 1차 문헌 귀속이 한 줄 어긋나 있었다

`CLAUDE.md`의 TFLM 이력 절은 두 문장을 연달아 쓴다: (1) `micro_interpreter.h`의
`arena_used_bytes()` 주석을 원문 인용하고, (2) *"다만 `docs/memory_management.md`는 이 값을
**'For debugging only'**로만 표기하고"*라고 대비한다.

**원문 대조 결과 (2)가 틀렸다**:

- `memory_management.md`(커밋 `d031820`, 9,849 B): `arena_used_bytes` **0건** · `debugging` **0건**
- `micro_interpreter.h:143`: `// For debugging only.`
- `:144-148`: (1)이 인용한 바로 그 네 줄
- `:149`: `size_t arena_used_bytes() const`

즉 *"For debugging only."*는 **(1)이 인용한 그 헤더의 같은 주석 블록에서 바로 윗줄**이다.
저장소는 그것을 **다른 파일에 귀속**했고, 그 대비를 *"TFLM 문서는 우리가 확보한 종류의 건전성
근거를 제시하지 않는다"*의 근거로 썼다.

**결론은 바뀌지 않는다** — *"모든 유효 입력에 대한 상한임을 증명한다"*는 주장이 두 문헌 어디에도
없다는 것은 이제 **원문에서 확인된다**(`upper bound` 0건). 바뀌는 것은 **어느 문헌이 무엇을
말했는지**이고, 그것은 인용을 쓰는 문서에서 가장 기본적인 것이다.

## §4 D92 — E47의 정정이 생성기에 닿지 않았다 (D65의 네 번째 얼굴)

E47 §7이 E39a의 *"`WebFetch`가 전 외부 호스트에서 `EGRESS_BLOCKED`"*를 **두 호스트 시험에서
내린 과잉 일반화**라고 정정했다. 그런데 `harness/mk_prior_art_table.py`가 **그 문장을 계속
emit하고 있었고**, 생성물 `prior_art.md`가 매 재생성마다 철회된 서술을 다시 실었다.

**정정이 산문에만 남았는지, 기계가 읽는 자리와 소스에도 닿았는지 확인하라**(D65)의 재발이고,
이번에는 **정정을 한 실험 자신이 자기 정정을 생성기에 반영하지 않았다**. 생성기의 docstring과
출력 문구를 둘 다 고쳤고, 회귀 시험이 **금지된 두 철자**를 검사한다.

**부수**: 그 가드의 첫 판이 PASS인데 detail에 *"generator still carries it"*을 인쇄했다 —
교체한 문장이 **철회하는 바로 그 어구를 인용**하기 때문이다. E44가 고친 것과 같은 형태(한 행
안에서 detail과 판정이 다른 말을 한다)라 함께 고쳤다.

## §5 등급은 행이 아니라 축 단위로 지지된다

A9는 **행 단위 필드**인데 대조는 **축 단위**로 했다. 행 전체의 등급을 올리면 대조하지 않은 축
(A6·A7·A8 등)까지 함께 오른다 — **조용한 과잉 주장**이다. 그래서 각 행이
`A9.axes_checked_against_fulltext`를 함께 싣는다:

| 행 | 등급 | 원문 대조한 축 |
|---|---|---|
| `tvm_usmp` | `project_doc_fulltext` | A1 · A2 |
| `executorch_memplan` | `project_doc_fulltext` | A1 · A2 · A3 · A5 |
| `tflm_mlsys2021` | `project_doc_fulltext+source_fulltext` | A2 · A3 |

**TFLM의 논문(MLSys 2021)은 별개 문헌이다** — 문서를 읽었다고 논문 등급이 오르지 않으므로
`A9.paper_grade`가 `search_summary`로 **따로 남는다**. 나머지 **여덟 행의 A9는 불변**이고
시험이 그것을 고정한다.

## §6 Q5 — 도달 불가 다섯을 다시 쟀다

E45·E47의 교훈(*"이 호스트가 막혔다"*는 관측이고 *"이 자료를 조달할 수 없다"*는 결론이며 그 사이에
**어느 경로를 재 봤는가**가 있다)을 이 실험 자신에게 적용했다. 다섯 호스트를 **다시 재서** 전부
`000`임을 기록했다 — `arxiv.org` · `api.crossref.org` · `proceedings.mlsys.org` ·
`ieeexplore.ieee.org` · `ojs.aaai.org`. 이제 그 문장은 **측정과 함께** 있다.

## §7 revert-and-confirm-fail

| 되돌린 것 | 결과 |
|---|---|
| 생성기의 과잉 일반화 문장 복원 | **1건 FAIL** |
| 한 행의 `axes_checked_against_fulltext` 제거 | **1건 FAIL** |
| 전부 복원 | 12/12 |

## §8 주장하지 않는 것

- ***"선행연구 비교표가 검증됐다"*** → **아니다.** 검증된 것은 **11개 중 3개**이고, 그 셋도
  **축 단위**다(§5).
- ***"논문 원문을 읽었다"*** → **한 건도 읽지 못했다.** `fulltext` **0건**.
- ***"TFLM 문서에 건전성 근거가 없음을 증명했다"*** → 확인한 것은 **이 두 문헌의 이 커밋에
  `upper bound`가 0건**이라는 것까지다.
- ***"이 문서들이 앞으로도 같다"*** → 커밋에 고정했으므로 **그 커밋의 바이트**에 대한 진술이다.

## §9 다음

검토서 §5의 병행 항목이 닫혔다. 남은 것은 **연구 책임자 결정 대기** — 논문 초고 착수 · PR #3 병합 ·
태그 정책이다.
