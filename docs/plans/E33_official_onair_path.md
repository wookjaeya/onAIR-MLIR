# E33 계획 — 공식 OnAIR 경로 갱신 (단계 3) · **사전 고정 기준**

**규율**: §3(무엇을 실행하는가)·§4(판정 기준)·§5(무엇이 반증하는가)는 **결과를 보기 전에 고정**하고
그대로 커밋한다. 결과를 본 뒤 기준을 넓히지 않는다(E26·E27·E31·E32와 같은 절차).

**출처**: 아홉 번째 외부 검토 `docs/reviews/ONAIR_MLIR_ARCHITECTURE_PLAN_20260910.md`
§10 단계 3, §6.1(플러그인 변경안 8항목), §6.3(파일 목록), §9.4(반복 실행), §2.2·§4.2(경로 분리).

---

## 1. 질문

> **NASA OnAIR의 공식 확장점을, OnAIR 코어를 수정하지 않고, 최신 실물 모델(SmartCam)과
> 메모리 admission에 연결할 수 있는가? 그리고 그렇게 실행한 출력이 원본 의미를 보존하는가?**

E25는 *"OnAIR-IREE"*라고 부른 것이 실제로는 `iree.runtime` **직접 호출**이었음을 v0.22.1에서
정정했다. 즉 **공식 플러그인 로더를 통과한 실행은 이 저장소에 아직 없다.** 단계 3이 그 항목이다.

## 2. 원본 대조로 확인한 제약 (계획 작성 시점, 소스 확인)

| 사실 | 근거 |
|---|---|
| 로더는 `plugin.Plugin(construct_name, headers)` **두 인자만** 전달한다 | `onair/src/util/plugin_import.py:49` |
| `AIPlugin.__init__`은 `assert len(_headers) > 0` | `onair/src/ai_components/ai_plugin_abstract/ai_plugin.py` |
| 플러그인은 `[PLUGINS] LearnersPluginDict = {'name':'plugins/<dir>'}`로 등록된다 | `onair/config/default_config.ini` |
| 모듈 디렉터리에 `__init__.py`가 있어야 하고 파일명은 `<dir>_plugin.py` | `plugin_import.py:37-47` |

따라서 **생성자 인자를 늘리는 방식은 공식 설정에서 활성화되지 않는다.** 검토서 §6.1의 권고대로
환경변수 `ONAIR_MLIR_DEPLOYMENT_CONFIG`가 가리키는 설정 파일에서 `construct_name`으로 배포 규약을
선택한다. **이는 제안 인터페이스이며 OnAIR 코어를 수정하지 않는다.**

`assert len(headers) > 0`과 "이미지 입력을 수십만 header 필드로 만들지 않는다"(§6.1)는 함께 성립해야
하므로, 입력 모드를 둘로 나눈다(§3.2).

## 3. 무엇을 실행하는가 — **측정 전 고정**

### 3.1 경로

| 경로 | 무엇 | 이 실험에서의 역할 |
|---|---|---|
| **공식 OnAIR** | NASA `driver.py` → `plugin_import` → 이 저장소의 `Plugin` | **이 실험의 대상** |
| E31의 원본 TFLite oracle | 재실행하지 않고 보관본 사용 | 기준값 |

**cFS는 이 실험의 범위가 아니다.** 검토서 §2.3·§10 단계 3이 못박은 대로, 단독 CSV OnAIR 실행을
"cFS 연계"라고 부르지 않는다. SBN 흐름은 **하지 않으며**, 하지 않았다고 명시한다.

### 3.2 입력 모드 두 가지 — 섞지 않는다

| 모드 | headers의 의미 | 텐서 출처 | 용도 |
|---|---|---|---|
| `telemetry` | 프레임 필드 이름(기존 규약) | `low_level_data` 값 그대로 | 기존 MLP 회귀(하위 호환) |
| `file_replay` | **샘플 식별자 한 개**(예: `SAMPLE_ID`) | E31 fixture의 `.npy` | SmartCam |

`file_replay`에서 headers는 **1개**면 충분하므로 `assert len(_headers) > 0`을 만족하면서 150,528개
필드를 만들지 않는다. 두 모드의 결과를 섞어 집계하지 않는다.

### 3.3 실행할 셀

| 셀 | 내용 | 기대 |
|---|---|---|
| **P-admit** | 예산 = `bounded`, SmartCam 5샘플(E32의 S-cfs와 같은 집합) 재생 | 로드·ADMIT·5회 추론, 전체 출력 |
| **P-deny** | 예산 = `bounded − 1` | **플러그인 비활성**(사유 표시), 추론 0회, **OnAIR 프로세스는 계속 동작** |
| **P-mismatch** | 계약이 지목한 것과 다른 아티팩트 | 로드 전 거부(E23/D27 게이트) |
| **P-legacy** | 기존 MLP(`telemetry` 모드, 외부 weights) | 회귀 — 기존 경로가 깨지지 않았다 |

P-admit의 5샘플은 **E32와 같은 집합**(실이미지 3 + 경계 2)으로 고정한다. E31이 실증한 대로 상수
경계 입력만으로는 레이아웃 오류를 잡을 수 없으므로 비상수 실이미지를 전부 포함한다.

### 3.4 반복 실행 — 검토서 §9.4

**출력을 매번 읽는다.** E30 스모크의 결과 폐기 호출은 반입 타당성 범위였다. 플러그인은 결과를 읽고
**놓아준 뒤** 다음 호출로 간다. 지연 표본과 출력 배열을 **무한히 쌓지 않는다**(고정 길이 버퍼).
E32/D59가 실측한 조건 — *`per_call`의 io 항은 동시에 살아 있는 입력을 하나로 센다* — 을 이 경로에서도
지키는지 본다.

## 4. 판정 기준 — **측정 전 고정**

1. **의미(Q1)**: 공식 경로의 전체 출력이 **원본 TFLite oracle** 대비 E25→E31→E32에서 **변경 없이
   승계한** 기준을 만족한다: 원소별 `abs_err <= 1e-4` **OR** `rel_err <= 1e-5`.
   판정 도구는 `harness/e31_compare.py` 그대로. **argmax 단독 판정 금지.**
2. **공식성(Q2)**: 실행이 **NASA `driver.py` → `plugin_import.import_plugins` → `Plugin(...)`**을
   실제로 통과했음이 기록된다. **OnAIR 코어 파일은 수정하지 않는다**(수정 여부를 실행 후 diff로 확인).
   `AIPlugin`을 import만 흉내내는 stub 시험은 통합 완료가 아니다(§10 단계 3).
3. **admission(Q3)**: P-deny에서 **추론 0회**이고 플러그인이 사유를 보고하며 **OnAIR 프로세스가
   예외로 죽지 않는다**. P-mismatch는 런타임 적재 전에 거부한다.
4. **수명주기(Q4)**: 반복 호출에서 출력을 매번 소비하고, 지연·출력 버퍼가 호출 수에 비례해 늘지 않는다.

**Q1~Q4를 전부 만족해야 단계 3 완료다.** 하나라도 미달이면 미달로 적는다.

## 5. 무엇이 이 실험을 반증하는가 (미리 적는다)

1. **의미 불일치** → 플러그인의 입력·ABI를 먼저 고친다. 출력을 축약하거나 tolerance를 넓히지 않는다.
2. **공식 로더를 통과하지 못함**(생성자 인자 문제 등) → 그 사실이 결과다. OnAIR 코어를 고쳐서
   통과시키지 않는다. 코어 수정이 필요하다면 **단계 3은 미완료**이고 그 이유를 적는다.
3. **P-deny가 추론을 수행** → fail-open(유형 A). **P-admit이 거부됨** → 과잉 거부(유형 B). 둘 다 결함이다.
4. **기존 MLP 경로가 깨짐** → 유형 (B) 회귀다. 새 기능이 기존 정직한 입력을 거부하면 개선이 아니다.

## 6. 하지 않는 것 (범위)

- **SBN / cFS 연계**: 하지 않는다. 단독 OnAIR 실행을 cFS 연계라고 부르지 않는다(§2.3).
- **정확도 평가**: 평가셋이 없다.
- **지연·처리량**: `FUNCTIONAL_ONLY` 호스트다. 플러그인이 지연을 기록하지만 **성능 근거로 인용하지
  않는다**(경계 이름을 붙여 기록만 한다).
- **AArch64에서의 OnAIR 실행**: 하지 않는다(x86-64 호스트 한정).
- **다른 모델**(단계 4), **공정한 기준선**(단계 5).
- **임의 모델 hot-swap**: 검토서 §6.2가 필수 과제에서 뺐다. 모델 변경은 새 계약·설정으로 재시작이다.

## 7. 산출물

```
plugins/compiled_learner/compiled_learner_plugin.py   (수정)
harness/admission_policy.py                            (신설 — 부작용 없는 판정)
harness/onair_integration_check.py                     (신설 — 공식 driver 실행·수집)
configs/onair_compiled_learner.ini                     (신설 — 공식 LearnersPluginDict 등록)
configs/deployments/smartcam.json                      (신설 — 모델·예산·입출력 규약)
results/e33_onair_official/                            셀별 원자료·전체 출력·판정·summary.json
docs/EVIDENCE_v0.36_E33.md
```
