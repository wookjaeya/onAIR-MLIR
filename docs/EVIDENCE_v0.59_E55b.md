# EVIDENCE v0.59 — E55b: AArch64 cFS **복사(copy) 적재 경로** + map/copy 통합 + OnAIR 기여 연결

**사전 고정 계획**: `docs/plans/E55b_copy_path_aarch64.md`(커밋 `e58216b`, **측정 이전**).
**근거 지시**: `docs/reviews/COPY_MAP_ONAIR_RECOMMENDATION_v0.57.md`(원문 보존, sha256 `ba7f66d9…`,
기준 커밋 `f4b41dc`). 이 지시는 E55의 조건부 map 검증에 **AArch64 cFS copy 경로를 추가**하고
**OnAIR 신규 실험은 필수화하지 않는다**.

기호는 지시 §3.1 그대로다 — `P` = `static_per_call_bytes`, `C` = `module_resident_constant_bytes`,
`Bᵤ = P + C` = `bounded_bytes`, `M` = 부여 예산, `H` = 그 실행의 HAL 디바이스 할당 peak.
**모든 수치는 HAL 할당 회계 범위다**(D78) — 프로세스 RSS도 cFS 전체 RAM도 아니다.

---

## §1 공백의 정확한 이름

지시 §2.1이 이름 붙였고 저장소 대조로 확인했다: **E29의 정렬 스윕 64셀(map 32 · copy 32)은
x86-64 native이지 AArch64 게스트 cFS가 아니다.** 그리고 AArch64 cFS에서 실제로 관측된 실행은
**전부 map**이었다 — E48의 `*_admit_B_real` 세 셀, E53의 `cfs_B`, E55/P0-4의 조건부 네 셀이
모두 `arm: map` · `module_ptr_mod64: 0` · `hal_peak_after_append: 0`이다.

이유는 우연이 아니다. 두 C 실행기가 E29b 이후 **자기 blob을 `posix_memalign(…, 64, …)`으로
잡기 때문**이고, 그것이 E29가 규명한 map 분기의 전제조건이다. 즉 이 저장소가 출하하는 배포는
**구조적으로 copy 분기를 밟지 않는다** — 그래서 copy 셀은 그 정렬을 **의도적으로 제어**해야만
만들어진다.

## §2 변경 변수 하나 — 적재 주소의 정렬

`AI_LEARNER_BLOB_ALIGN_OFFSET`을 신설했다. 앱은 여전히 **base를 64바이트 정렬로 요청**하고
`base + offset`을 IREE에 넘기며 **해제는 base로 한다**. 즉 바뀌는 것은 모듈 이미지의 **정렬
클래스 하나**이고, 모델 바이트·계약·입력·컴파일 설정·판정 기준은 전부 고정이다(계획 §2).

**fail-closed 여섯 조건**(계획 §2.2):

| 조건 | 거부 사유 |
|---|---|
| 비정수 · 후행 쓰레기 · 빈 값 | 형식 |
| `[0, 4096]` 밖 | 범위 |
| 8의 배수가 아님 | E29가 x86-64에서 **모듈 검증 실패**를 관측했다 — 그 실패를 copy 실행과 혼동하지 않기 위해 애초에 만들지 않는다 |
| 0이 아닌 64의 배수 | 정렬 클래스를 바꾸지 못하므로 copy를 만들 수 없다. 받아들이면 **no-op이 대조로 보인다** |
| `AI_LEARNER_ALLOW_CONDITIONAL_MAP=1` 빌드 | 계획 §2.1 — 조건부 계층은 전제가 깨지면 **런타임 생성 전에 거부**한다(E29b/D54). 이 knob으로 그 거부를 우회하지 않는다 |

거부는 **초기화 거부**(`ALIGN_OFFSET_INVALID`)이고, `blob_align` 레코드는 **판정보다 먼저**
나온다(D69 — 판정에서 설정을 역추정하지 않는다). 오프셋 기본값은 **0**이므로 knob을 주지 않은
배포는 E29 이후의 배포와 바이트 단위로 같다(회귀 가드 `e29`가 그것을 pin한다).

**오프셋 값 8은 실측에서 왔다** — E29 `align_sweep.json`의 `delta = 8` 셀이 8모델 전부에서
`arm: copy` · `append_ok: true`였다(0/64/128/192는 map, 8/16/32/136은 copy).

## §3 왜 이 셀들은 e25 배치 모드로 도는가

계획 §4의 마지막 행이 **"출력 보존 | 같은 타깃·같은 모델의 기존 출력 기준 충족"**이다. 이 행은
copy 셀이 **보관된 map-arm 셀과 같은 입력을 재생해야만** 답할 수 있다 — E55/P0-4의 셀들은
Software Bus 텔레메트리 바이트를 feature로 쓰므로 같은 이유로 그 행이 `null`이었다.

따라서 네 copy 셀은 **보관 AArch64 cFS map-arm 셀이 쓴 바로 그 fixture**를 재생한다:

| 모델 | fixture | 샘플 | 보관 map-arm 기준값 |
|---|---|---:|---|
| b2_resnet | `results/e34_two_models/b2_resnet/fixture` (E34 합성) | 34 | `results/e36b_aarch64_models/b2_resnet/e25_outputs.bin` |
| b3_deepae | `results/e34_two_models/b3_deepae/fixture` (E34 합성) | 34 | `results/e36b_aarch64_models/b3_deepae/e25_outputs.bin` |
| smartcam | `results/e31_smartcam_equivalence/fixture` (실이미지 3 + 경계 2) | 5 | `results/e37_evidence_consolidation/s_cfs_post_d61/e25_outputs.bin` |
| wgan | `results/e53_wgan_aarch64/e25_inputs_1sample.bin` (in-tree) | 1 | `results/e53_wgan_aarch64/cfs/logs/cfs_B.e25_outputs.bin` |

앞의 세 입력 세트는 **바이트를 저장하지 않는다** — `mk_e25_inputs.py`가 in-tree fixture에서
바이트 단위로 재생성하고 **샘플마다 E45/E31 매니페스트 해시와 대조**하기 때문이고, 그것이
E31·E26d·E45가 세운 규칙이다(결정적 재생성은 바이트가 아니라 **레시피와 해시**로 보관한다).
재생성한 replay order가 보관 기준값 셀의 것과 **3/3 동일**함을 확인했고, 회귀 가드 `e55b/7`이
선언한 sha256으로 매번 재생성해 대조한다.

**E26 위생은 유지된다** — 이 셀들의 기대 키는 `e25_mode_active: **true**`다. 모드가 켜졌다는
사실을 앱이 **증언**하고, 하네스가 그 레코드의 **부재를 false로 읽지 않는다**(D29).

## §4 분기 이름만으로 copy를 확정하지 않는다

지시 §3.3의 마지막 줄이 이것이고, 구조로 지켰다. 앱은 `arm` 문자열을 **자기 자신이
`hal_peak_after_append`에서 유도한다**(`ai_learner.c`) — 그러므로 `arm == "copy"`를 근거로 쓰면
**앱의 결론을 관측으로 되읽는 것**이다. `harness/mk_e55b_summary.py`는 지시가 이름 댄 세 사실을
따로 대조한다:

1. **적재 설정** — `module_ptr_mod64`가 요청한 오프셋과 같은가(`posix_memalign`이 실패해
   `malloc`으로 떨어지면 정렬은 할당자가 정하므로, 이것은 **가정이 아니라 측정**이다)
2. **append 직후 상수 할당** — `hal_peak_after_append == C`인가
3. **실행 결과** — 추론이 실제로 완주했는가

`arm_label_agrees`는 그 셋 **옆에** 적히고 대신 쓰이지 않는다. 회귀 가드 `e55b/3`이
*"라벨은 copy인데 append 직후 할당이 `C`가 아닌"* 합성 셀을 copy로 세지 않음을 고정하고,
`e55b/4`가 *"오프셋을 줬는데 `mod64 == 0`"*인 셀(계획 §5-1)을 배제한다. 판정 로직을 라벨로
되돌리면 두 가드가 실제로 FAIL한다.

**soundness와 tightness는 별도 필드다** — 지시 §3.4가 *"`H < P+C`는 상한이 틀렸다는 뜻이
아니다"*라고 못박았다. 그리고 `H > P+C`는 FAIL이 아니라 **WITHHELD**다: 원자료를 보존하고
그 구성의 상한 준수 주장을 보류한다(가드 `e55b/5`).

## §6 OnAIR — 기존 결과 연결, 신규 실험 0건 (지시 §5)

지시 §5는 **기여를 확대하지 말고 연결하라**고 했다. `harness/mk_e55b_onair_link.py`가 E33의
`run.json` 세 셀을 읽어 표를 만든다 — 값은 전부 원자료에서 오고 산문에서 옮기지 않으며,
**아무것도 재실행하지 않았다**.

기여 문장은 지시 §5.1이 준 것을 **그대로** 쓴다:

> 계약 기반 실행 전 판정을 공식 OnAIR 플러그인 인터페이스에 연결하고, 허용 및 거절 시의 실행
> 동작을 실증했다.

| 셀 | 조건 | admission | **거부 지점** | 플러그인 활성 | 추론 |
|---|---|---|---|---|---:|
| `p_admit` | 예산 = 무조건 상한 | ADMIT | — | true | 5 |
| `p_deny` | 예산 = 무조건 상한 − 1 B | NOT_ADMITTED | **admission** | false | 0 |
| `p_mismatch` | 계약↔아티팩트 불일치 | **ADMIT** | **binding** | false | 0 |

**`refused_at`을 값으로 싣는 이유**: `p_mismatch`는 메모리 게이트에서 **ADMIT**이고(예산이
상한을 덮는다) 아티팩트 게이트에서 크기 선검사로 거부된다 — 파일을 읽기 전이다. *"admission
ADMIT, 추론 0"*이라는 행은 요약하다가 뒤집히기 쉬워서 어느 게이트가 거부했는지를 기록한다.

**E33이 재지 않은 둘은 사유를 붙인 `null`이다**:
- **HAL peak** — 이 경로에 계측이 없다. 레코드에 **없는** 것이지 0이 아니다.
- **출력 객체 해제** — D60이 *"해제"* 서술을 철회했다(원자료가 종료 시점 미해제 nanobind
  인스턴스를 보고한다). 상태는 **양방향으로 미검증**이며 *"누수"*도 쓸 수 없다.

**§5.2의 선택적 4모델 8조건 표는 만들지 않았다** — 그 표가 필요한 주장(모델 전반의 판정 재사용)을
이번에 하지 않기 때문이고, 지시 자신이 *"같은 함수를 두 번 호출한 결과의 일치는 공유 구현의
일관성 확인이지 독립 검증이 아니다"*라고 적었다. `p_legacy`는 E33의 네 번째 셀이지만 §5.1이
인용한 셋이 아니므로(구식 계약 → `NOT_EVALUATED`, 추론 4) **따로** 싣는다 — 인라인하면 세 조건
표가 네 행 표로 읽힌다.

가드 `e55b/8`(세 행이 원자료와 일치, 거부 지점 포함)·`e55b/9`(재지 않은 둘이 사유를 붙인
`null`로 남고, 신규 실험 없음, 선택적 표 미생성)가 이것을 고정한다.

## §7 주장하지 않는 것 (계획 §6 — 측정 전 고정)

- **모든 지원 입력·실행에 대한 건전성** → 네 모델의 한 번씩은 **경로별 실행 대응 증거**다.
- **반복 호출의 장기 수명** → 이 네 번으로 검증됐다고 하지 않는다.
- **실제 배포가 copy 분기를 탄다** → 반대다. 이 저장소의 두 C 실행기는 E29b 이후 자기 blob을
  64바이트 정렬로 잡으므로 **구조적으로 map**이고, copy 셀은 그 정렬을 **일부러 제어**해 만든
  것이다. 관측된 배포 거동의 보고가 아니다.
- **DeepAE의 TFLite 대비 수치 동치 FAIL의 변경** → 유지한다(D74). 같은 AArch64 실행의
  map/copy 출력 일치와 **원본 TFLite 대비 동치는 별개 비교**다(지시 §4 말미).
- **프로세스 RSS·시스템 RAM** → 전부 HAL 디바이스 할당 회계 범위다(D78).
- **AArch64 OnAIR · OnAIR 메모리 상한 준수** → E33은 x86-64이고 HAL peak를 재지 않았다.
  서로 다른 ISA의 계약과 vmfb를 섞어 통합 실행 성공으로 보고하지 않는다(지시 §5.2 말미).
- **지연·성능** → 이 게스트는 `platform_check.py`가 `FUNCTIONAL_ONLY`를 반환한다. 이 문서의
  시간 수치는 **창 산정용**이며 성능 증거가 아니다(작업 규율 4).
