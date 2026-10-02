# EVIDENCE v0.75 — E68: OnAIR 플러그인의 명세–실행 파일 연결 검사를 평가 타깃에서 실행하다

- **근거 요청**: v32 원고 독립 메타리뷰(`JAIS_META_REVIEW_V32_INDEPENDENT_20260929.md`, 2026-09-29) §4 — OnAIR가 로드하는 파일을 문서의
  artifact 식별자와 언제 대조하는가, 문서의 어떤 조건(entry·입출력 인터페이스·target/driver)을 확인하는가, 불일치하면 어떤 상태로 멈추는가.
  검토자는 검사 누락을 단정하지 않았고 *"같은 예산 판정을 낸다는 사실만으로 이전 모델의 문서를 다른 모델에 적용하지 않는다는 점까지
  입증되지는 않는다"*고 적었다.
- **사전 고정 기준**: `docs/plans/E68_onair_artifact_linkage.md`(커밋 `c51ad37`, **셀 실행 이전**).
- **대상**: 모든 셀은 AArch64 QEMU 게스트(qemu-system-aarch64, Cortex-A53, 이번 부팅 4 vCPU·2 GiB — `results/e68_onair_linkage/guest/guest_env.txt`).
  개발 호스트는 파일 배치·배포 설정·보관 레코드 판독만 했다. **플러그인 코드는 바꾸지 않았다**(게스트가 import한 네 파일의 sha256이 E66과 같다).
- **증거 등급**: 결정론적(플러그인 init 레코드, 파일 크기·해시). 지연은 재지 않았다.
- **판정: Q1~Q3 PASS** (`results/e68_onair_linkage/summary.json` — 원자료에서 유도).

## 1. 공백

크기·SHA-256 검사(`plugins/compiled_learner/artifact_binding.py::verify_artifact_binding`, E23/D27)와 driver 검사(E41)는 구현돼 있었고, 평가 타깃의
승인된 OnAIR 배포는 전부 `binding MATCH`를 기록했다(E57·E62·E65·E66 init 레코드 **44개** 중 승인 27개, 전부 MATCH이고 그때만 런타임 생성 —
계획 §0의 *"45개"*는 세지 않고 적은 오기다. 사전 고정 문서라 고치지 않고 여기 적는다). 그러나 **불일치 경로는 평가 타깃에서 0셀**이었다
— E33 `p_mismatch`·E41 `smartcam_wrong_driver`는 개발 호스트 셀이라 원고 근거로 쓰지 않는다.

## 2. 셀과 결과 (ResNet, 재발행 문서, 예산 $B_u$ = 618,856)

기준 배포 `e66_b2_resnet_Bu`와 각 셀이 다른 키는 설정 파일에서 유도했다(`deployment_keys_differing_from_base`).

| 셀 | 바뀐 키 | 적재 시도한 파일 | 예산 판정 | 바인딩 | 런타임 | 추론 | 거부 사유 |
|---|---|---|---|---|---|---|---|
| `e68_control` | 없음 | ResNet 343,538 B `2e0bc7dc…` | ADMIT | MATCH | 생성 | 50 | — |
| `e68_L1_other_model_file` | `artifact_dir` | **DeepAE** 1,080,730 B `9ff64bd1…` | ADMIT | 없음 | **미생성** | 0 | `size 1080730 != contract artifact.bytes 343538 (refused before reading …)` |
| `e68_L2_same_size_other_bytes` | `artifact_dir` | 343,538 B `b11049d8…`(4096번째 바이트 반전) | ADMIT | 없음 | **미생성** | 0 | `sha256 b11049d8aa6efd12... != contract artifact.sha256 2e0bc7dc67af80b7...` |
| `e68_L3_driver` | `driver`(`local-task`) | — | **없음** | 없음 | **미생성** | 0 | `deployment driver 'local-task' != contract driver 'local-sync'` |

- **Q1**: 대조 셀이 같은 세션에서 기대대로 실행됐다(E66과 같은 50회).
- **Q2**: 세 거부가 전부 **기대한 단계**에서 났다. L1·L2는 예산 비교가 이미 `ADMIT`을 낸 뒤 파일 검사에서 멈췄다 — **예산 판정만으로는 통과했을
  배포**를 파일 연결이 막았다는 뜻이고, 검토자가 요구한 시나리오(이전 모델의 문서를 다른 모델의 파일에 적용)가 L1이다. L3은 예산 비교 전에 멈췄다.
  세 셀 모두 OnAIR rc 0·코어 무수정이고 플러그인은 비활성으로 남았다.
- **Q3**: 각 거부 셀이 기준 배포와 기대한 한 키에서만 다르고, 게스트가 기록한 두 파일의 sha256이 호스트 매니페스트와 같다.

## 3. 코드가 정한 순서 (셀이 아닌 서술)

플러그인 초기화의 가드 안 순서는 배포 옵션 → 명세 적재 → 문서 수용(E66) → 인터페이스 읽기 → 입력 경로 검사 → **driver** → **예산 비교** →
**크기**(읽기 전) → **SHA-256**(파일 전체) → 런타임 생성·모듈 append(해시한 같은 바이트) → **entry**(문서의 entry가 모듈 export에 있는가)다.
가드 `e68/4`가 실행 줄에서 이 순서를 다시 읽는다.

- **entry 검사는 런타임 생성 뒤, 추론 전이다** — 모듈을 적재해야 export 목록을 알 수 있다. 셀은 없다(평가 문서의 entry는 전부 `infer`이고,
  불일치를 만들려면 문서를 손으로 고쳐야 한다 — `ASSUMPTIONS_AND_SCOPE.md`의 범위 밖).
- **입출력 인터페이스는 모듈과 따로 대조하지 않는다.** 문서의 인터페이스는 해시가 결속한 바로 그 아티팩트를 만든 컴파일 호출에서 추출됐다.
  file_replay 모드는 추론마다 샘플 형상을 문서 형상과 대조하고, telemetry 모드는 초기화 때 프레임 필드 수가 입력 원소 수 이상인지 본다.

## 4. 가드와 되돌림

`e68/1`(원자료에서 다시 유도한 요약 = 커밋 요약) · `e68/2`(대조 실행, 세 거부의 단계·런타임·추론·한 키 귀속) · `e68/3`(L1은 DeepAE 평가 아티팩트로
해석되고 크기가 다름, L2는 ResNet 평가 아티팩트의 한 바이트 반전이고 크기가 같음 — 평가 아티팩트에서 다시 만들어 대조, 게스트가 둘을 해시함) ·
`e68/4`(플러그인 실행 줄의 순서).
되돌림 실측: L1 원자료의 `runtime_created`를 `true`로 변조 → `e68/1`·`/2` FAIL; 플러그인에서 driver 검사와 예산 비교의 순서를 바꿈 → `e68/4` FAIL.
이 컨테이너 **1018/1018 + 2 SKIP → 1022/1022 + 2 SKIP**.

## 5. 주장하지 않는 것

- entry 불일치 거부의 관측(코드가 정한 시점만) · 입출력 인터페이스의 모듈 대조(하지 않는다).
- 악의적 변조 방어 — 해시는 식별·재현 수단이다(`ASSUMPTIONS_AND_SCOPE.md`).
- ResNet 외 모델의 거부 셀 · 지연.
