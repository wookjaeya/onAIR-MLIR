# EVIDENCE v0.20 — E24b: 네 번째 외부 검토(연구 목표 재정리본)의 반례 5건

- 실험 ID: **E24b**
- 날짜: 2026-09-09
- 검토 원문: `docs/reviews/REVIEW_v0_19_E24_RESEARCH_REFRAME.md` (기준 커밋 `f51f66e`)
- 플랫폼 등급: **결정론적**(계약 값·헤더 바이트·시험 결과). 지연값 인용 없음.
- 커밋: `cd50194`(R1/R2/R3) · `6b76dfd`(R4) · `a85ddf3`(R4 시험 정정) · `b47feb7`(스모크 경로) · `bf2be2a`(R5)

## 0. 한 줄 요약

검토 §5.2의 반례 5건(R1–R5)을 전부 실제로 재현하고 수정했다. **다만 심각도 재분류가
두 번 있었고 방향이 서로 반대다**: R1은 검토가 "매우 낮음: 수동 변조 필요"로 분류했으나
정상 `make_contract.py` 경로로 도달 가능한 **claim blocker**였고, R4는 검토가 제안한
문자 그대로의 수정이 **정직한 모델을 통째로 거부**하는 것으로 실측돼 채택하지 않았다.
시험 143/143 → **170/170**(이 컨테이너 실측).

이 실험의 성격은 검토 자신이 §7 "단기 정리 — 별도 대형 실험으로 만들지 않음"으로
분류한 것과 같다. 즉 **연구의 중심 질문(C1–C4)을 진전시키는 실험이 아니라, 그 질문으로
넘어가기 전에 닫아두는 마지막 구현 hardening 묶음이다.** 연구 우선순위 재편은
`CLAUDE.md`에 반영했다.

## 1. 검증 방법

이 저장소의 기존 방법론을 그대로 적용했다 — **리뷰의 주장을 곧이곧대로 반영하지 않고
먼저 실제 코드 실행으로 재현한다.** 반례 5건에 대해 10개 에이전트를 병렬로 돌렸다:

- 재현 5인: 각 반례를 **정상 생성 경로**로 도달할 수 있는지, 아니면 손수정이 필요한지까지 판정
- 과잉 거부 위험 5인: 검토가 제안한 수정을 그대로 적용했을 때 **저장소의 정직한 입력이
  거부되는지**를 실측(`contracts/*.json` 3개 + 보관 14개 + 스크립트가 인라인으로 만드는 계약)

두 번째 축이 이번에도 결정적이었다. 이 저장소의 결함 정의는 양방향이다 —
(A) fail-open: 잘못된 계약을 조용히 ADMIT / (B) 과잉 거부: 정당한 입력을 거부.
E20(D16·D17)과 E24(N1·N3)에 이어 이번에도 (B)가 두 번 나왔다(§5, §7).

## 2. R1 — `--elf-analysis`의 음수 스택 (claim blocker, 심각도 상향)

**검토의 분류**: "매우 낮음: 수동 변조 필요". **실측 판정**: 계약을 손대지 않고
`--elf-analysis` **입력 JSON만** 바꾸면 정상 `make_contract.py` 경로로 재현된다.

- `make_contract.py`가 ELF 분석의 `max_dispatch_frame_bytes`/
  `max_dispatch_invocation_stack_bytes`를 부호 검사 없이 복사했다.
- `elif stack_b:`의 truthiness가 **음수를 "신뢰" 버킷(`bucket_2_task_stack_budget`)으로 승격**시켰다.
- 결과를 실제 C 식으로 컴파일해 확인: `stack_needed = 262144 + (-300000) = -37856`이고
  `CFE_ES_AppInfo_t.StackSize`가 unsigned이므로 `es_stack >= stack_needed`가
  **스택 0에서도 참**이다. E16/D15가 만든 거부 분기가 조용히 작동을 멈추는데
  텔레메트리는 계속 `accounted=true`를 보고한다.
- 스키마에도 `minimum`이 없었다.

**수정**: 생성기가 음수 스택을 거부(우회 플래그 없음 — 정직한 분석은 음수를 내지 않는다),
`make_contract.py`가 ELF 분석의 음수를 애초에 거부, `elif stack_b:`를
`stack_b is not None and stack_b > 0`으로.

**`<= 0`을 쓰지 않은 이유(과잉 거부 회피)**: `stack == 0`은 정당하다(dispatch 함수가
없는 ELF에서 `max(..., default=0)`). `<= 0`은 constants가 0인 `dynamic` 계약 2개
(A8 음성 시나리오의 입력)도 함께 거부한다.

## 3. R2 — `bounded_bytes`가 자기 구성요소와 대조되지 않음

`bounded_bytes=1`이 `static_per_call_bytes=1352` + `module_resident_constant_bytes=2176`
옆에 적혀 있어도 `BOUND_KNOWN=1` 헤더가 나왔다. C 게이트는 셋 중 첫 번째만 읽는다.

**수정**: `bound_known` 범위에서 `bounded == per_call + constants`를 강제.

**`>=`가 아니라 `==`인 이유**: `make_contract.py`가 셋을 같은 `all_static` 게이트 아래
하나의 dict 리터럴에서 계산하므로 등식이 항등이다(저장소의 정수 계약 전수 확인). `>=`는
거부 집합이 같으면서 **부풀린 자기모순 값만 통과**시키는데, 그건 정당한 ADMIT을
NOT_ADMITTED로 바꾸는 유형 (B)다.

## 4. R3 — `validity`와 `interface`의 shape 충돌

`shape_from()`이 fallback 체인이라 두 표현을 **비교한 적이 없었다**.

**수정**: `_shape_statements()` + `check_shape_agreement()`를 `shape_from()` 호출 전에 실행,
**존재하는 statement끼리만** 대조한다(부재는 불일치가 아니다 —
`contracts/contract.e14_aarch64.json`은 `interface` 블록이 없는 정직한 계약이고,
양쪽 존재를 요구하면 유형 (B)다).

**dtype 절반은 반박**: E24/N3이 이미 두 블록의 합집합을 읽으므로 dtype 충돌은 이미
거부된다. 도달 가능성 `no`(두 표현이 같은 Python 객체에서 파생) — 심층 방어로만 유효.

## 5. R4 — `subset_sum_match`의 세그먼트 절단 (검토 처방 미채택)

검토가 §5.2에서 **유일하게 "가능: 복잡한 artifact에서 발생 가능"으로 표시한 항목**이고,
실측 결과 도달 경로가 검토가 말한 것보다 평범했다.

- 공개 문서화된 스톡 플래그 `--iree-stream-resource-max-allocation-size=1024` 하나로
  정상 단일 컴파일에서 **31개 data 세그먼트**가 나온다(세그먼트 수는 모델 크기가 아니라
  HAL 상수 풀 수에 비례).
- 옛 코드는 25번째부터를 조용히 버리고 **일치하는 총합에 대해 "NOT matched"라고
  계약에 기록**했다 — 배포되는 계약 안의 거짓 진술이고, `cross_target_compare.py:93`이
  그대로 퍼뜨린다. 이 절반이 fail-open 절반(26개 모순 세그먼트 통과, 경계 정확히
  25개로 실측)보다 훨씬 도달하기 쉽다.

**검토의 문자 그대로의 처방("절단은 `unevaluated`로 분리하고 기본 거부")은 채택하지
않았다** — 실측으로 정직한 31세그먼트 모델을 통째로 거부한다(계약 미생성). 대신 열거기를
먼저 고치고 호출부를 단순화했다:

- `subset_sum_match`가 진짜 tri-state — `True`(부분집합 존재) / `False`(**전수 열거 후**
  불일치 = 모순) / `None`(확인 대상 없음·관측 없음·예산 초과).
- 세그먼트 **개수** 절단 대신 `total`로 가지치기한 비트셋 DP(총합보다 큰 세그먼트는
  부분집합에 들어갈 수 없으므로 위치가 아니라 값으로 건너뛴다). 예산은 개수가 아니라
  총합에 건다(256 MiB). 실측: 실제 31세그먼트 0.01 ms, mlp16k 0.25 ms, 16 MiB/40세그먼트
  최악 4 ms.
- N1 게이트에서 carve-out 2개(const==0, 절단)가 사라졌다 — 이제 함수 자신이 `None`으로
  답하고 D25 분기가 처리한다. D17/E20 정렬 패딩 carve-out만 남는다.
- `constants_check_note`가 세 상태를 각각 명시한다. 옛 텍스트
  `"0 B NOT matched by artifact .rodata segments [7440]"`은 상수가 0인 모델에 대한
  **거짓 진술**이었다.

**의도적 재생성**: `dynamic` 계약 2개의 3개 필드(총 6개 스칼라)가 바뀐다
(`constants_*_confirmed_in_artifact` false→null, note는 참인 문장으로). 이것이
`EVIDENCE_v0.19_E24.md` §7이 "범위 밖, 의도적 재생성 동반 필요"로 남겼던 바로 그
비용이며, 실측대로 정확히 그만큼이다(다른 12개 계약·14개 헤더 무변화).

**시험 자체의 결함도 하나 나왔다(`a85ddf3`)**: 처음 쓴 tri-state 회귀 시험이 일치
세그먼트를 리스트 맨 앞에 뒀는데, 옛 코드의 절단은 **앞 24개를 남기므로** 수정 전
함수도 `True`를 냈다 — revert-and-confirm-fail이 성립하지 않는 **공허한 시험**이었다.
수정 전 함수를 직접 호출해보다 발견했고, 일치 세그먼트를 index 30으로 옮겨 고쳤다.

## 6. R5 — 적용된 override가 계약에 기록되지 않음

`make_contract.py`의 `--allow-*` 탈출구는 거부를 억제하고도 자신이 쓴 계약에 아무 흔적을
남기지 않았다. ABI·triple·ELF·one-invocation 검사를 **전부** 우회한 계약과 전부 통과한
계약이, 사람이 free-text `provenance.notes`를 직접 diff하지 않는 한 구별 불가였다.
그리고 그 계약을 읽는 유일한 소비자인 `gen_contract_header.py`는 **provenance를 한 글자도
읽지 않았으므로** 두 경우가 같은 배치 가능 헤더를 만들었다.

### 6.1 `waive()` — 거부 지점이 아니라 플래그 접근을 감싼 이유

독립 검증자가 경고한 실패 양식이 이것이다: 거부 지점 옆에 기록을 덧붙이는 **기계적
패치는 결합형 게이트**(`if <조건> and not a.allow_...`) **2곳을 놓친다**(`make_contract.py`의
`rodata_unavailable`·`unverifiable` 게이트). 그러면 override가 적용됐는데
`overrides_applied=[]` / `verification_grade="verified"`라고 **주장하는** 계약이 나온다 —
아무것도 기록하지 않는 현 상태보다 엄격히 나쁜 신규 fail-open이다.

```python
def waive(flag, enabled):
    """Return `enabled`; record `flag` when it actually suppresses a refusal."""
    if enabled and flag not in overrides_applied:
        overrides_applied.append(flag)
    return bool(enabled)
```

Python의 단축 평가 덕에 결합형도 올바른 의미를 공짜로 얻는다 — `waive()`는 오류 조건이
참일 때만 도달하므로 **실제로 무언가를 억제할 때만** 기록된다. 소비 지점 11곳 전부 적용했고
(`--no-validate`는 `main()`에서 소비되므로 `build_contract` 안에서 무조건 기록),
플래그를 넘겼지만 아무것도 억제하지 않은 경우는 **기록하지 않는다**(무고). 후자를
시험으로 고정한 이유는 "argparse가 본 플래그를 전부 기록"하는 구현이면 정상 계약이
`overridden`으로 등급이 떨어지고, 아래 헤더 게이트를 통해 유형 (B) 과잉 거부가 되기 때문이다.

### 6.2 헤더 게이트와 범위(실측으로 좁힘)

`gen_contract_header.py`가 이제 provenance를 읽고, override가 기록됐거나
`single_invocation`이 `True`가 아닌 계약에서 **배치 가능한 헤더 생성을 기본 거부**한다
(`--allow-override-contract`가 명시적 opt-out, 그 경우 `CONTRACT_PROVENANCE_VERIFIED 0`).

범위는 세 가지로 좁혔고 전부 실측 근거가 있다:

| 좁힌 조건 | 이유(실측) |
|---|---|
| `bound_known`일 때만 | `NONE`-bound 계약은 어차피 `KNOWN=0`이라 C 게이트가 거부한다. 여기서 막으면 A8 음성 시나리오의 입력인 `dynamic` 계약 2개를 거부 |
| provenance **블록이 있을 때만** | `contracts/*.json` 3개와 OnAIR plugin fixture는 provenance가 아예 없다. 거부하면 `CLAUDE.md`가 문서화한 스모크 경로가 깨진다 — E23이 D31로 출하한 것과 같은 실수 |
| `verification_grade` **부재**는 불신뢰가 아님 | 보관 14개 계약은 이 필드보다 앞선다. 엄격 해석은 14/14를 거부 |

스키마에도 두 필드를 **선택**으로만 추가했다(필수화하면 보관 14개가 전부 무효).

보관 헤더 14개를 재생성했다 — 추가된 줄은 `CONTRACT_PROVENANCE_VERIFIED`뿐이고
(12×`1`, `dynamic` 2×`0`) **다른 바이트 변화 0**이다.

### 6.3 드리프트 가드가 행위 시험보다 강한 것을 실측

revert-and-confirm-fail: 수정 전 코드에서 신규 8건 전부 FAIL. 더 중요한 확인은
**결합형 게이트 1곳만 wrapping을 벗기는 드리프트**를 시뮬레이션한 결과다.

| 시험 | 드리프트 주입 시 |
|---|---|
| R5 행위 시험 5건(기록·무고·등급·헤더 거부·override 통과) | **전부 PASS** |
| `R5: no bare a.allow_* access bypasses waive()` (소스 수준) | **FAIL** |

검증자가 경고한 실패 양식이 실제로 그 형태임을 확인했다. 그래서 행위 시험만이 아니라
**드리프트를 원천 차단하는 불변식**(선언된 모든 `--allow-*`가 `waive()`를 거쳐 소비되고,
맨 플래그 접근이 남아 있지 않다)을 함께 고정했다.

## 7. 부수 발견 — 문서화된 스모크 경로 2개가 이미 깨져 있었음

R5 검증 중 별개 결함으로 발견했다. `CLAUDE.md`가 스모크 테스트로 문서화한
`cd native && bash build.sh`와 `scripts/62_compile_and_check_aarch64.sh`가 둘 다
`gen_contract_header.py`에서 rc=1로 죽고 있었다. 원인 셋:

1. **기존(E15~)**: `native/build.sh`의 기본 계약(`contracts/contract.filled.example.json`)에
   ELF 스택 분석이 없어 D13/D15 게이트가 거부. **E24b 이전 생성기로도 rc=1**임을 확인했으므로
   이번에 추가한 게이트 때문이 아니다.
2. **기존(E15~)**: `scripts/62`의 인라인 계약이 `bound_method`를 아예 선언하지 않아
   `'unspecified'`로 거부.
3. **E24가 만든 것**: N3 게이트("bound-known 계약은 dtype을 어딘가에 말해야 한다")가
   dtype 미선언 인라인 계약을 거부. **E24는 과잉 거부 위험을 `contracts/*.json`과 보관
   14개 계약으로 측정했고, 스크립트가 인라인으로 만드는 계약은 확인하지 않았다** —
   유형 (B) 회귀를 출하한 것이다.

수정: 두 스크립트가 `--allow-unknown-stack`을 넘기고(둘 다 ELF 분석 없는 예시/예산
계약이다 — 실배포 계약은 `--elf-analysis`와 함께 `make_contract.py`가 만들며 이 플래그가
필요 없다), `scripts/62`의 인라인 계약이 `bound_method`와 dtype을 선언한다. 그 수치
(786476/65580/720896)는 mlp16k의 실제 post-layout 값이고 모델은 f32이므로, 둘 다 새 주장이
아니라 사실의 명시다. 회귀 시험 2건을 신설했다(`documented_smoke_path_cases` — 스크립트를
실행하지 않고 같은 계약 모양을 만들어 헤더까지 도달하는지 확인하므로 툴체인 없는
환경에서도 돈다).

**교훈(반복 3회째)**: "과잉 거부 위험을 측정했다"는 주장은 **어떤 입력 집합에서**
측정했는지에 전적으로 의존한다. E24는 커밋된 계약 파일만 봤고, 스크립트가 런타임에
만드는 계약을 보지 않았다.

## 8. 신규 결함 번호

| ID | 요약 |
|---|---|
| D35 | `--elf-analysis`의 음수 스택이 정상 경로로 `KNOWN` 헤더가 되고, cFS 스택 게이트가 unsigned 비교 때문에 **모든 스택 크기에서 참인 항등식**이 됨(R1) |
| D36 | `bounded_bytes`가 같은 계약이 명시한 구성요소 합과 대조되지 않음(R2) |
| D37 | `validity`와 `interface`의 shape 표현이 fallback 체인이라 서로 비교된 적이 없음(R3) |
| D38 | `subset_sum_match`의 24개 세그먼트 절단이 (a) 정직한 31세그먼트 모델에 대해 **계약 안에 거짓 진술**을 쓰고 (b) 26개 이상에서 모순을 통과시킴(R4) |
| D39 | 적용된 `--allow-*`/`--no-validate` override가 계약에 기록되지 않고, `gen_contract_header.py`가 provenance를 전혀 읽지 않아 우회 계약과 검증 계약이 같은 배치 가능 헤더를 만듦(R5) |
| D40 | `CLAUDE.md`가 문서화한 스모크 경로 2개가 rc=1로 깨져 있었고, 그중 1건은 **E24의 N3 게이트가 만든 유형 (B) 회귀**(§7) |

## 9. 시험 수치

| 단계 | 이 컨테이너 실측 |
|---|---|
| E24 종료 시점 | 143/143 |
| R1·R2·R3 후 | 151/151 |
| R4 후 | 160/160 |
| 스모크 경로 후 | 162/162 |
| R5 후 | **170/170** |

이 컨테이너에는 `iree-base-compiler`·`iree-base-runtime`·`jsonschema`·PyYAML이 모두
있으므로 위 값은 **`full` 레그에 대응하는 상한**이다. **D34의 교훈에 따라 CI 세 레그의
값은 추정하지 않는다** — 푸시 후 CI가 실측한 값을 §9.1에 기록한다.

### 9.1 CI 실측 (푸시 후 기록)

(측정 후 채움)

## 10. 이번 범위 밖 (명시)

- 검토 §5.2가 함께 제안한 **C `_Static_assert` 추가**: `CONTRACT_PROVENANCE_VERIFIED`를
  소비하는 C 측 게이트는 **의도적으로 만들지 않았다.** 두 C 게이트는 이 컨테이너가
  재빌드할 수 없는 바이너리(cFS + IREE C 런타임)에 있고, `contracts/`의 예시 fixture가
  빌드에 실패하게 만드는 것은 E23이 D31로 출하한 과잉 거부와 정확히 같다. 매크로는
  지금 방출되므로 사실이 JSON만이 아니라 헤더와 함께 이동한다 — 소비는 x86-64 cFS
  환경을 재구축하는 세션의 몫이다.
- 검토 §5.2의 `deployment_eligible=false`: 같은 사실을 `verification_grade`로 기록했다.
  별도 boolean을 두면 두 필드가 어긋날 수 있어 단일 등급 + 근거 목록을 택했다.
- 검토 §5.1의 C1–C4(연구 핵심 질문)와 §7의 E25–E27: 이번 실험 범위가 아니다.
  `CLAUDE.md` 우선순위를 그 순서로 재편했다.
- 게스트 cFS 재실행(환경 부재), `weights.npz` 계약 결속.

## 11. 재현

```bash
python3 harness/contract_negative_tests.py            # 170/170 (전 의존성 설치 시)
python3 harness/contract_negative_tests.py --skip-regression   # 회귀 14×3 제외

# R5 드리프트 가드가 행위 시험보다 강함을 직접 확인 (§6.3)
python3 - <<'PY'
p="harness/make_contract.py"; s=open(p).read()
open(p,"w").write(s.replace('if unverifiable and not waive("--allow-unverified-invocation", a.allow_unverified_invocation):',
                            'if unverifiable and not a.allow_unverified_invocation:',1))
PY
python3 harness/contract_negative_tests.py --skip-regression | grep " R5"   # 행위 5건 PASS, 가드 1건 FAIL
git checkout harness/make_contract.py
```
