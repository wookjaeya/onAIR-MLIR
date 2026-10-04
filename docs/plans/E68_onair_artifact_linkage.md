# E68 계획 — OnAIR 플러그인의 명세–실행 파일 연결 검사를 평가 타깃에서 실행한다

**사전 고정 문서다. 셀 실행 이전에 커밋한다.** 근거는 v32 원고 독립 메타리뷰
(`JAIS_META_REVIEW_V32_INDEPENDENT_20260929.md`, 2026-09-29) §4 — *"OnAIR가 실제로 로드하는 파일을 문서의 artifact
식별자와 언제 대조하는지"*, *"같은 예산 판정을 낸다는 사실만으로 이전 모델의 문서를 다른 모델에 적용하지 않는다는 점까지
입증되지는 않는다"*. 검토자는 검사 누락을 단정하지 않았고, 구현돼 있다면 절차 설명으로 충분하다고 적었다.
이 실험은 그 절차의 **불일치 경로가 평가 타깃에서 한 번도 실행된 적이 없다**는 공백만 닫는다. **플러그인 코드는 바꾸지 않는다.**
모든 셀은 **AArch64 게스트**에서 돌고, 개발 호스트는 배포 설정·파일 배치·보관 레코드 판독만 한다.

## 0. 착수 전 조사 (실험 아님, 판정 아님)

- **코드가 정한 순서**(`plugins/compiled_learner/compiled_learner_plugin.py`, E66 이후 불변 — `git log -- plugins/` 최신 `4b335a2`):
  배포 옵션(조건부 옵션 → 예산 → 면제 → readback) → 명세 적재(필수 키 `interface`·`target`·`artifact`·`resources`) →
  **문서 수용**(E66) → 인터페이스 읽기(entry·입출력 형상) → 입력 경로 검사(telemetry: 프레임 필드 수 ≥ 입력 원소 수 /
  file_replay: 인덱스 헤더·fixture 디렉터리) → **driver**(배포 driver = 문서 driver, E41) → **예산 비교** →
  **크기**(`artifact.bytes` = 파일 크기, 읽기 전) → **SHA-256**(`artifact.sha256` = 파일 전체 바이트) →
  런타임 생성·모듈 append(해시한 **같은 바이트**를 넘긴다) → **entry**(문서의 entry가 모듈 export에 있는가).
  어느 단계든 거부하면 플러그인은 비활성으로 남고 사유를 init 레코드에 적으며 OnAIR 프로세스는 계속 돈다.
- **entry 검사는 런타임 생성 뒤다** — 모듈을 적재해야 export 목록을 알 수 있기 때문이다. 추론 전이지만 런타임 생성 전은 아니다.
  이 셀을 만들려면 문서를 손으로 고쳐야 한다(평가 네 모델의 entry는 전부 `infer`) — `ASSUMPTIONS_AND_SCOPE.md`의 *"수동 편집으로만
  도달하는 반례"*라 **셀로 만들지 않는다**. 원고에는 코드가 정한 시점으로만 적는다.
- **입출력 인터페이스는 모듈과 따로 대조하지 않는다** — 플러그인은 문서의 형상을 읽고, 그 문서의 인터페이스는 해시가 결속한 바로 그
  아티팩트를 만든 컴파일 호출에서 추출된 것이다(one-invocation). file_replay 모드는 추론마다 샘플 형상을 문서 형상과 대조한다.
- **평가 타깃의 기존 기록**: E57·E62·E65·E66의 게스트 OnAIR init 레코드 45개 중 승인된 배포는 **전부 `binding MATCH`**이고 그때만
  `runtime_created true`다. 불일치 경로(크기·해시·driver)는 **0셀**이다 — E33의 `p_mismatch`·E41의 `smartcam_wrong_driver`는
  개발 호스트 셀이라 원고 근거로 쓰지 않는다.
- **크기**: ResNet `b2_resnet.vmfb` 343,538 B, DeepAE `b3_deepae.vmfb` 1,080,730 B.

## 1. 셀 (전부 ResNet, 재발행 문서 E65/E66, 예산 $B_u$ = 618,856)

기준 배포는 `e66_b2_resnet_Bu`(E66 게스트 셀, 추론 50회·rc 0)이고, 각 거부 셀은 그것과 **한 가지만** 다르다.

| 셀 | 바뀐 것 | 기대 |
|---|---|---|
| `e68_control` | 없음(같은 세션의 양성 대조) | active true · `binding MATCH` · `runtime_created true` · 추론 ≥ 1 |
| `e68_L1_other_model_file` | 문서가 가리키는 파일 자리에 **DeepAE의 아티팩트**(ResNet 문서는 바이트 사본) | 예산 판정 `ADMIT` 기록 뒤 **크기 불일치**로 거부 · `binding null` · `runtime_created false` · 추론 0 |
| `e68_L2_same_size_other_bytes` | 같은 크기·다른 바이트(ResNet 아티팩트에 `harness/corrupt_vmfb.py --method flip --offset 4096`) | `ADMIT` 기록 뒤 **SHA-256 불일치**로 거부 · `runtime_created false` · 추론 0 |
| `e68_L3_driver` | 배포 driver `local-task`(문서는 `local-sync`) | **예산 비교 전** driver 불일치로 거부 · `admission null` · `runtime_created false` · 추론 0 |

L1이 검토자의 시나리오(이전 모델의 문서를 다른 모델의 파일에 적용)이고, L2는 크기가 같을 때 해시가 따로 막는지를 가른다.
L2 파일은 결정적 생성물이다 — 생성기가 호스트에서 만든 파일의 sha256을 매니페스트에 싣고, 게스트가 실제로 적재 시도한 파일의 sha256을
`guest_env.txt`에 남겨 둘이 같아야 한다.

## 2. 판정 (Q1–Q3)

- **Q1 (양성 대조)**: `e68_control`이 기대대로 실행된다. 이것이 실패하면 L1–L3의 거부를 해석하지 않는다.
- **Q2 (거부 셀)**: L1–L3이 전부 기대 단계에서 거부되고 `runtime_created false` · 추론 0 · OnAIR rc 0.
  거부 사유 문자열이 기대 단계를 가리켜야 한다(L1 `size`, L2 `sha256`, L3 `driver`). 다른 단계에서 거부되면 FAIL이다
  (예: L1이 크기가 아니라 다른 이유로 멈추면 크기 검사를 관측한 것이 아니다).
- **Q3 (귀속)**: 각 거부 셀의 배포가 기준 배포와 기대한 한 키에서만 다르다(설정 파일에서 유도, 손으로 쓴 표가 아니다).

## 3. 주장하지 않는 것

- entry 불일치 거부(셀 없음, 코드가 정한 시점만) · 입출력 인터페이스의 모듈 대조(하지 않는다) · 악의적 변조 방어(범위 밖 —
  해시는 식별·재현 수단) · 다른 모델의 거부 셀(ResNet 하나) · 지연.
