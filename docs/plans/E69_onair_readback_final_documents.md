# E69 — OnAIR 판독 방식 셀을 최종 명세 문서로 다시 실행 (사전 고정 계획)

**이 계획은 E69의 어떤 셀보다 먼저 커밋한다.** 판정 기준과 예측은 측정 전에 여기서 고정한다.

## 0. 경위와 범위

- **근거**: v41 원고 독립 메타리뷰(`JAIS_META_REVIEW_V41_INDEPENDENT_20261002.md`, 저장소 밖) M4.
  - 검토의 지적: 원고가 OnAIR 경로에서 보고한 판독 방식 결과가 이전 문서로 얻은 것이다. 출력 보유, 450회 실행의 417번째 호출 초과, 호출별 검사가 여기에 속한다(E57·E57c·E62). 이 문서들은 생산자 검사가 없어, 현재 플러그인에서는 면제(`allow_unchecked_producer`)가 있어야 받아들여진다.
  - 검토의 권고: 최종 문서·같은 아티팩트·같은 플러그인으로 대조를 다시 하라.
- **연구 책임자 지시(2026-10-02)**: 논문에는 최종 경로를 이해하는 데 필요한 결과만 남긴다. 이전 문서와 면제의 경위는 넣지 않는다.
  - 따라서 OnAIR 판독 방식 결과도 최종 문서에서 얻어야 한다.
- **범위**
  - 문서: E66이 재발행한 네 모델의 문서만 쓴다(`results/e66_plugin_document_rules/docs/<model>`). 생산자 검사가 일치하고 오버라이드는 없다.
  - 플러그인: 현재 저장소의 플러그인을 쓴다. E66 이후 플러그인 코드 변경은 0이고, 게스트가 import한 파일의 sha256을 기록한다.
  - 면제 키 `allow_unchecked_producer`를 가진 배치는 하나도 없다.
- **실행 환경**: AArch64 QEMU 시스템 게스트(4 vCPU, 2 GiB, E62와 같은 구성), 같은 IREE 파이썬 휠(`~/e57/pylib`), 공식 OnAIR 로더. 개발 호스트에서는 아무것도 실행하지 않는다.
- **새 코드**
  - 배치 생성기 하나.
  - 요약 생성기 하나.
  - 플러그인과 앱 코드는 바꾸지 않는다.

## 1. 셀

모든 배치는 E62의 대응 배치에서 두 가지만 바꾼다.

- `artifact_dir`: E66 재발행 문서 디렉터리로 바꾼다. 링크로 같은 아티팩트를 가리킨다.
- `allow_unchecked_producer`: 키를 삭제한다.

텔레메트리·fixture·예산·호출 수는 같다.

| 셀 | 모델 | 판독 방식 | 호출별 검사 | 호출 수 | 대응 E62/E65 배치 |
|---|---|---|---|---:|---|
| `e69_<m>_Bu_ctl` (4) | 넷 | `asarray`(첫째) | off | 50 / 100 / 50 / 3 | `e62_<m>_Bu_ctl` |
| `e69_b2_resnet_Bu_default` | ResNet | 키 없음(기본값) | off | 50 | `e62_b2_resnet_Bu_default` |
| `e69_b3_deepae_Bu_long_ctl` | DeepAE | `asarray` | off | 450 | `e57_b3_deepae_Bu_long` |
| `e69_b3_deepae_Bu_long_fix` | DeepAE | `buffer_protocol` | off | 450 | `e62_b3_deepae_Bu_long_fix` |
| `e69_<m>_Bu_enf_ctl` (3) | ResNet·DeepAE·SmartCam | `asarray` | on | 계획 50/100/50 | `e62_<m>_Bu_enf_ctl` |
| `e69_<m>_Bu_enf_fix` (3) | 같은 셋 | `buffer_protocol` | on | 50/100/50 | `e62_<m>_Bu_enf_fix` |
| `e69_b2_resnet_cond_true` | ResNet | `buffer_protocol` | off | 50 | `e65_b2_resnet_conditional_requested` |
| `e69_b2_resnet_cond_false` | ResNet | `buffer_protocol` | off | 50 | `e65_b2_resnet_conditional_false_control` |

- **탐침(OnAIR 없이)**: `harness/e62_readback_probe.py`를 E62와 같은 네 모드로 돌린다(DeepAE, 20회). 차이는 계약 인자가 E66 재발행 문서라는 것뿐이다.
- **인용하는 최종 문서 셀**: 버퍼 프로토콜 판독의 네 모델 $B_u$ 셀과 $B_u-1$ 셀은 E66이 이미 최종 문서로 실행했다(`e66_<m>_Bu`, `e66_<m>_Bum1`). 다시 돌리지 않고 인용한다.

## 2. 판정 기준 (측정 전 고정)

$P$, $O$, $B_u$는 문서 값이다.

| 모델 | $P$ | $O$ | $B_u$ |
|---|---:|---:|---:|
| ResNet | 309,416 | 40 | 618,856 |
| DeepAE | 6,208 | 2,560 | 1,069,632 |
| SmartCam | 9,382,092 | 12 | 18,222,796 |
| WGAN | 131,382,784 | 602,112 | 135,666,432 |

- **Q0 최종 문서만 썼다**: 모든 셀에 대해 아래가 성립한다.
  - init 레코드의 `document_acceptance.verdict == "accepted"`이고 `waived == []`다.
  - `allow_unchecked_producer_requested`는 null 또는 false다.
  - OnAIR 코어는 변경되지 않았다.
  - 게스트가 import한 플러그인 파일 sha256이 E66 `guest_env.txt`의 값과 같다.
- **Q1 첫째 판독의 보유**: `e69_<m>_Bu_ctl` 네 셀과 `long_ctl`에서 아래가 성립한다.
  - 모듈 추가 뒤 live는 0이다.
  - k번째 호출 뒤 live는 정확히 $kO$다.
  - n번째 호출 뒤 피크는 정확히 $P + (n-1)O$다.
  - 계획한 호출 수 안에서는 모든 피크가 $B_u$ 이하다.
- **Q2 예측**: `long_ctl`에서 승인 예산을 처음 넘는 호출은 **417번째**다.
  - 근거: $P + (n-1)O > B_u$ ⇔ $n - 1 > 1{,}063{,}424 / 2{,}560 = 415.4$.
  - 416번째 피크는 1,068,608이고, 417번째 피크는 1,071,168이다.
- **Q3 둘째 판독**: `long_fix`의 450회 모든 호출에서 피크는 $P$이고 live는 0이다.
  - 인용하는 E66 $B_u$ 네 셀에서도 같은 조건을 다시 확인한다.
- **Q4 출력**: 같은 모델·같은 샘플에서 `ctl`과 `fix`의 호출별 출력이 비트 동일하다. 비교 짝은 아래와 같다.
  - `e69_<m>_Bu_ctl` ↔ `e66_<m>_Bu`
  - `long_ctl` ↔ `long_fix`
- **Q5 호출별 검사**
  - `enf_ctl` 세 셀은 첫 호출 뒤 위반 1건(live = $O$, 모듈 추가 뒤 수준 0)으로 정지하고, 추론은 1회다.
  - `enf_fix` 세 셀은 계획한 호출을 모두 수행하고 위반은 0이다.
- **Q6 기본값**: `e69_b2_resnet_Bu_default`의 init `output_readback == "buffer_protocol"`이고, 50회 모두 피크 $P$·live 0이다.
- **Q7 조건부 옵션**
  - `cond_true`: 구성 오류로 비활성이다. 런타임은 생성되지 않고(`runtime_created == false`) 추론은 0이며, 명세를 읽기 전에 거부된다.
    - 마지막 조건은 init 레코드에 문서 수용 판정이 없는 것으로 확인한다.
  - `cond_false`: `ADMIT`이고 50회 수행한다.
- **Q8 기전 탐침**: `asarray`는 참조 증가 1이고, 모든 참조를 놓은 뒤 live가 $O$다. 버퍼 프로토콜은 참조 증가 0이고 live가 0이며, 두 출력은 같다.

## 3. 반증 조건

- **F1**: 어느 셀에서든 문서가 면제로 수용됐다. 그러면 Q0 실패이고, 이 실험의 목적 자체가 무너진다.
- **F2**: `ctl` 계열의 live 증가가 $O$가 아니거나, `long_ctl`의 첫 초과가 417이 아니다. 그러면 보유 기전이 문서 또는 실행 회차에 의존한다는 뜻이므로 결과로 보고한다.
- **F3**: `fix`에서 피크가 $P$를 넘는다.
- **F4**: `ctl`과 `fix`의 출력이 다르다.
- **F5**: `cond_true`가 런타임을 만들었거나 추론했다.

반증이 나와도 기준을 고치지 않는다. 결과로 보고한다.

## 4. 부수 비교 (판정 아님)

- E62·E57 대응 셀의 시계열과 출력 비교: 문서 외에 같은 조건이므로 같을 것으로 본다. 저장소 기록용이다.
- 같은 아티팩트를 같은 입력으로 재생한 비행 응용 출력과의 비트 동일 수: E57 요약 생성기와 같은 방식으로 센다.

## 5. 주장하지 않음

- IREE 상류 결함의 확정·보고·수정.
- 다른 휠·리비전·드라이버.
- 지연(게스트는 `FUNCTIONAL_ONLY`).
- 프로세스 RSS(D78).
- WGAN 호출별 검사(실행하지 않음, E62와 같음).
