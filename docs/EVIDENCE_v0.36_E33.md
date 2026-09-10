# EVIDENCE v0.36 — E33: 공식 OnAIR 경로 (단계 3)

**사전 고정 기준**: `docs/plans/E33_official_onair_path.md`(커밋 `3f8aa01`, **측정 전**).
**출처**: 아홉 번째 외부 검토 §10 단계 3, §6.1(플러그인 변경 8항목), §6.3, §9.4.
**앞 단계**: E30(P1) → E31(P2, x86-64) → E32(단계 2, AArch64 cFS) → **E33(이 문서)**.

---

## 0. 한 줄 요약

**Q1~Q4 전부 PASS.** NASA OnAIR의 공식 로더가 이 저장소의 플러그인을 구성하고, 실물 SmartCam 모델을
**OnAIR 코어 수정 없이** 실행했으며, 그 출력이 **원본 TFLite oracle** 기준을 만족했다. 예산 미달과
아티팩트 불일치는 추론 0회로 거부되면서 **OnAIR 프로세스는 살아 있었다.**

**E25가 v0.22.1에서 정정한 갭이 이것으로 닫힌다** — 그때 "OnAIR-IREE"라고 부른 것은 실제로는
`iree.runtime` 직접 호출이었고, 공식 로더를 통과한 실행은 이 저장소에 없었다.

## 1. "공식"이 무엇을 뜻하는가 — 흉내가 아니라는 근거

`harness/onair_integration_check.py`는 **플러그인을 import하지 않는다.** 공식 `.ini`를 만들어
OnAIR 체크아웃 안에서 `python driver.py <ini>`를 서브프로세스로 돌리고, 그 실행이 남긴 것만 읽는다.
검토서 §10 단계 3이 못박은 대로 *"`AIPlugin` import를 흉내내는 stub 시험은 통합 완료가 아니다."*

호출 경로는 실측으로 확인됐다 — 첫 실행이 실패했을 때의 트레이스백이 그것을 증명한다:

```
onair/src/run_scripts/execution_engine.py → sim.py → reasoning/agent.py
  → ai_components/learners_interface.py:22 → util/plugin_import.py:49
    → plugin.Plugin(construct_name, headers)
      → plugins/compiled_learner/compiled_learner_plugin.py
```

**OnAIR 코어 무수정**은 의도가 아니라 검사로 확인한다: 실행 전후로 OnAIR 체크아웃의 **추적 파일**
변경이 없어야 한다(`git status --porcelain --untracked-files=no`). 네 셀 전부 `core_unmodified: true`.
(OnAIR 자신의 예제 실행이 남긴 미추적 파일은 별도 필드로 보고하며 "우리가 코어를 고쳤다"로 세지 않는다.)

## 2. NASA 원본을 읽고 나서야 알 수 있었던 제약 셋

이 셋은 계획서 작성·구현 중 **원본 소스에서 확인**한 것이지 추정이 아니다.

| 제약 | 원본 근거 | 설계에 미친 영향 |
|---|---|---|
| 로더는 `Plugin(construct_name, headers)` **두 인자**만 전달 | `plugin_import.py:49` | 생성자 인자 확장 불가 → `ONAIR_MLIR_DEPLOYMENT_CONFIG` 환경변수로 배포 규약 선택(검토서 §6.1 권고) |
| `AIPlugin.__init__`이 `assert len(_headers) > 0` | `ai_plugin.py` | headers가 비면 안 되지만 이미지 입력을 150,528개 필드로 만들 수도 없다 → **입력 모드 둘**(§3) |
| CSV 파서가 **모든 필드를 float화**하고 실패 시 **0.0으로 대체** | `parser_util.py:49-65` | 문자열 샘플 ID는 **전부 0.0**이 되어 매 프레임 0번 샘플을 재생하게 된다 → 프레임은 **숫자 인덱스**를 싣고 순서 목록은 배포 설정에 둔다 |

**세 번째가 특히 중요하다.** 문자열 ID로 설계했다면 다섯 프레임이 모두 첫 이미지를 추론하면서
"5샘플 재생"으로 보였을 것이다 — 조용히 틀린 채로 통과하는 유형이다.

## 3. 입력 모드 둘 — 섞지 않는다

| 모드 | headers | 텐서 출처 | 이 실험의 셀 |
|---|---|---|---|
| `telemetry` | 프레임 필드 이름(기존 규약) | `low_level_data` 값 | P-legacy(MLP 회귀) |
| `file_replay` | **숫자 샘플 인덱스 1개**(`SAMPLE_INDEX`) | E31 fixture의 `.npy` | P-admit·P-deny·P-mismatch |

`file_replay`는 headers가 1개라 `assert len(_headers) > 0`을 만족하면서 이미지를 header로 펴지 않는다.
인덱스가 범위를 벗어나거나 정수가 아니면 **거부**한다(감싸서 다른 이미지를 재생하지 않는다).

## 4. 셀별 결과

| 셀 | 예산 | 로더 구성 | active | 추론 | rc | OnAIR 코어 |
|---|---:|---|---|---:|---:|---|
| **P-admit** | `bounded` 18,222,796 | ✔ | **true** | **5** | 0 | 무수정 |
| **P-deny** | `bounded−1` | ✔ | **false** | **0** | **0** | 무수정 |
| **P-mismatch** | `bounded` | ✔ | **false** | **0** | **0** | 무수정 |
| **P-legacy** | (미설정) | ✔ | true | 4 | 0 | 무수정 |

- **P-deny**: `admission NOT_ADMITTED — bounded 18,222,796 > budget 18,222,795`. 플러그인은
  **비활성 상태로 사유를 보고**하고 OnAIR는 정상 종료했다. 예외가 프로세스를 관통하지 않는다.
- **P-mismatch**: x86-64 계약에 **AArch64 vmfb**를 짝지었다(같은 모델·같은 계약 세 수치·다른
  아티팩트라 sha256 결속만이 구분한다). 거부 사유:
  `CONTRACT_ARTIFACT_MISMATCH: size 8991281 != contract artifact.bytes 8915257 (refused before reading …)`
  — **파일을 읽기도 전에** 크기 선검사로 거부했다. C 게이트와 같은 순서다.
- **P-legacy**: 기존 MLP fixture가 `telemetry` 모드·외부 `weights.npz`로 그대로 돈다. 이 계약은
  구식이라 `bounded/per_call/constants` 삼중항이 없고, 그래서 admission은 **`NOT_EVALUATED`**로
  기록된다 — 없는 경계를 지어내지 않는다. **새 기능이 기존 정직한 입력을 거부하지 않았다**(유형 B 회귀 0).

## 5. 의미 판정 (Q1) — PASS

기준은 **E25 → E31 → E32에서 변경 없이 승계**, 기준값은 **원본 TFLite oracle**(E31의 것을 그대로 쓰고
다시 돌리지 않았다), 판정 도구는 `harness/e31_compare.py` 그대로.

| 샘플 | 원소 | 실패 | argmax | 최악 abs |
|---:|---:|---:|---|---:|
| 5 | 15 | **0** | 5/5 | **5.364e-07** |

최악 원소가 E31의 x86-64 값(5.364e-07)과 같다 — 같은 vmfb·같은 런타임이므로 놀랍지 않지만,
**공식 로더를 통과했다는 사실이 계산을 바꾸지 않았음**을 확인한 것이다.

## 6. 실측으로 드러난 것 — 프레임워크가 입력 없이 한 번 더 호출한다

첫 P-admit 실행이 **5프레임에 6개 결과**를 냈다. 6번째는 `edge_ones`의 **바이트 동일 반복**이었다.
원인은 OnAIR이 데이터 소스 소진 후 `update()` 없이 `render_reasoning()`을 한 번 더 부르는 것이다.

이것을 그대로 두면 두 가지가 나쁘다. 추론 한 번을 낭비하고(예산을 쓰는 배포에서 실재하는 비용),
더 중요하게는 **검증 하네스가 그것을 새 샘플로 셀 수 있다** — 이 저장소가 반복해서 만난
*"세지 않은 것을 통과로 읽는"* 계열이다. 그래서 플러그인이 입력 신선도를 추적해, 갱신 없는 호출에는
**추론하지 않고 이전 답을 `stale: True`로 되돌린다.** 수정 후 정확히 **5회**.

변환기(`harness/e33_onair_outputs.py`)도 같은 샘플이 두 번 채점되면 **거부**한다. 한 층에서 막는 것에
의존하지 않는다.

## 7. 부수 — 내 자신의 기준을 어긴 첫 구현

계획서 §4-3은 *"OnAIR 프로세스가 예외로 죽지 않는다"*를 요구했다. **첫 구현이 그것을 어겼다**:
계약 로딩이 예외 가드 **밖**에 있어, 계약 파일 이름이 다르다는 이유로 `ContractViolation`이
`plugin_import`를 관통해 **OnAIR 실행 전체를 rc=1로 죽였다**(실측). 거부할 수 있는 모든 것을 가드
안으로 옮겼다. 계약을 못 읽는 것과 예산이 모자란 것은 OnAIR 입장에서 똑같이 치명적이다.

## 8. 판정 (계획서 §4)

| 질문 | 결과 |
|---|---|
| **Q1** 의미 | **PASS** — 15/15 원소, argmax 5/5, 최악 abs 5.364e-07 |
| **Q2** 공식성 | **PASS** — 네 셀 전부 NASA 로더가 구성, OnAIR 코어 추적 파일 변경 0 |
| **Q3** admission | **PASS** — P-deny·P-mismatch 모두 추론 0 · 프로세스 생존 · 사유 보고 |
| **Q4** 수명주기 | **PASS** — 매 호출 출력 소비·해제, 지연 이력은 고정 링, 신선하지 않은 호출은 추론하지 않음 |
| 기존 경로 회귀 | **PASS** — MLP가 telemetry 모드로 그대로 동작 |

**단계 3 완료.**

**CI 실측**(커밋 `8186a72`, run 128, 3레그 success): `full` **452/452 + 1 SKIP**(PyYAML) · `without-iree` **312/312 + 26 SKIP** · `stdlib-only` **312/312 + 26 SKIP** — 컨테이너 453/453과 `full`의 차이 1건은 PyYAML 유무(D34). 축소 레그가 281→312로 **정확히 +31**이라 E33 신규 31건이 **전부 나타난다**(신규 SKIP 0): 보관 JSON 판독과 `admission_policy` 순수 단위 시험이라 툴체인 없이 실제로 돈다.

## 9. 하지 않은 것 (범위)

- **SBN·cFS 연계**: 하지 않았다. **단독 CSV OnAIR 실행을 cFS 연계라고 부르지 않는다**(검토서 §2.3).
  이 실험이 보인 것은 *공식 OnAIR 프로세스 안에서의 실행*까지다.
- **정확도**: 평가셋이 없다.
- **지연·처리량**: `FUNCTIONAL_ONLY` 호스트다. 플러그인이 세 경계를 기록하지만 **성능 근거로 인용하지
  않는다**(도구 자신이 그 문장을 출력에 싣는다).
- **AArch64에서의 OnAIR**: x86-64 호스트 한정.
- **다른 모델**(단계 4), **공정한 기준선**(단계 5), **모델 hot-swap**(검토서 §6.2가 필수에서 제외).
- **메모리 실측**: 이 경로에서 HAL 피크를 재지 않았다. pip 바인딩의 호스트 읽기가 버퍼를 붙드는
  D50 조건이 그대로 적용되므로, 메모리는 E26·E29·E32가 재는 자리다.

## 10. 정오표 (v0.38.1 — D60)

**철회**: §8 판정표 Q4 행의 *"매 호출 출력 소비·**해제**"* 중 **"해제"**를 철회한다.

같은 셀의 원자료 `results/e33_onair_official/p_admit/run.json`의 `stderr_tail`이 프로세스 종료 시
아래를 남기고 있었고, **이 EVIDENCE는 그것을 한 줄도 기록하지 않았다**(저장소 전체에서
`nanobind|leak|누수` grep 0건):

```
nanobind: leaked 10 instances!
 - leaked instance ... of type "iree._runtime_libs._runtime.HalBufferView"
 - leaked instance ... of type "iree._runtime_libs._runtime.MappedMemory"
 ...
nanobind: leaked 5 keep_alive records!
nanobind: this is likely caused by a reference counting issue in the binding code.
```

**정정 후 상태: 메모리 해제 미검증.** 양방향으로 못박는다.

- *"매 호출 출력 버퍼를 해제했다"*고 **쓸 수 없다** — 원자료가 종료 시점의 미해제 인스턴스를 보고한다.
- *"OnAIR 경로에 메모리 누수가 있다"*고도 **쓸 수 없다** — 경고 본문 자신이 원인을 IREE 바인딩의
  참조 계수 문제로 지목하고, 이 경로에서 HAL 피크를 재지 않았으며(§9), 장기 RSS 추이도 측정하지 않았다.

Q4의 나머지 근거(고정 크기 지연 링, 신선하지 않은 호출에서 추론하지 않음)는 코드와 레코드로 확인되므로
**Q4 자체를 FAIL로 바꾸지 않는다.** 바뀌는 것은 그 PASS가 **무엇을 뜻하는가**다 — 호출 규약 수명주기는
확인됐고, **런타임 객체 해제는 미검증**이다.

**주장 범위**: OnAIR를 *기존 생태계 호환성의 보조 증거*로 쓰는 범위에서는 E33으로 충분하다.
OnAIR 경로까지 **계약의 메모리 준수 대상**으로 주장하려면 반복 실행·HAL 피크·객체 수명 검증이
따로 필요하다(**미실행**).

**발견 경로**: 외부 검토 문서가 `run.json`을 직접 읽어 지적했고 이 세션이 저장소 원자료로 재확인했다.
그 검토 문서는 근거 위치를 "§9"로 인용했으나 §9에는 없다 — **없다는 것이 바로 결함**이었다.
D55(요약만 커밋되고 원자료 누락)·D45(`both_sound` 오귀속)와 같은 계열이다.
