# EVIDENCE v0.50 — E48: 공개 실입력의 AArch64 종단 실행

> **사전 고정 기준**: `docs/plans/E48_real_inputs_aarch64_cfs.md` (커밋 `4cd26f5`, **측정 이전**).
> 두 외부 검토가 독립적으로 최우선으로 지목한 항목이다
> (`RESEARCH_STATUS_REVIEW_v048.md` §12 P0-1 · `ONAIR_MLIR_RESEARCH_AND_EXPERIMENT_REVIEW_v048.md` §6 R1).
>
> **판정 기준은 E25에서 변경 없이 승계했다** — 원소별 `abs_err ≤ 1e-4` **OR** `rel_err ≤ 1e-5`,
> `rel = |a−b| / max(|a|,|b|,1e-30)`, 기준값은 **원본 `.tflite`를 LiteRT로 그대로 돌린 출력**.
> E48은 기준을 **고치지 않았다**.

---

## §0 한 문장

E45가 x86-64 pip `iree.runtime`에서만 밟았던 세 모델의 **공개 실입력**을 AArch64 native(qemu-user)와
AArch64 cFS 게스트에서 다시 밟았고, **판정이 세 모델 전부 x86-64와 같다**(ResNet PASS · SmartCam PASS ·
**DeepAE FAIL**) — 그리고 그 과정이 하네스의 양방향 결함 **D80**을 드러냈다.

---

## §1 무엇이 비어 있었나 (E47 인벤토리의 실측)

계획 §1이 적은 대로 갭은 실재했다: `grep -rl 'real_cifar10\|real_ad01' results/`가
`results/e45_real_inputs/` 바깥을 하나도 내놓지 않았다. 반대로 **환경은 막혀 있지 않았다** —
게스트 이미지·cFS AArch64 트리·크로스 툴체인·AArch64 vmfb·계약이 전부 디스크에 있었다.
그래서 이 실험은 신규 개발이 아니라 **재실행**이고, 새로 만든 것은 계획 §4가 특정한 다섯 가지뿐이다.

---

## §2 판정 (Q1~Q5)

### §2.1 Q1 — 실입력 판정이 AArch64에서도 같은가 → **PASS**

| 모델 | 실입력 | x86-64 (E45) | AArch64 native | AArch64 cFS |
|---|---|---|---|---|
| b2_resnet | 실 CIFAR-10 200장 | PASS 0/2,000 | **PASS 0/2,000** | **PASS 0/2,000** |
| smartcam | 실 비행 썸네일 19장 | PASS 0/57 | **PASS 0/57** | **PASS 0/57** |
| b3_deepae | 실 log-mel 34창 | **FAIL 94/21,760** | **FAIL 46/21,760** | **FAIL 46/21,760** |

argmax는 세 모델·세 경로 전부 실패 0이다. 최악 `abs`는 ResNet 2.6226e-06 · SmartCam 1.4305e-06 ·
DeepAE 3.6144e-04이고, **AArch64 native와 AArch64 cFS의 값이 모델마다 서로 같다** — 같은 vmfb를
같은 IREE C 런타임으로 돌린 두 배포이므로 예상되는 결과이되, 관측으로 확인한 것이다.

### §2.2 Q5 — DeepAE의 FAIL이 AArch64에서 어떻게 나오는가 (계획 §7이 **측정 전에** 고정한 서술)

**두 ISA가 정확히 같은 한 샘플에서 실패한다** — `normal_id_04_00000043_hist_librosa_w98`, 34창 중 하나.
argmax도 같다(517 == 517). 다른 것은 실패 **원소 수**뿐이다(AArch64 46 · x86 94)와 최악 `abs`
(3.6144e-04 vs 6.1893e-04).

계획 §7의 문장을 그대로 쓴다: **그 FAIL은 x86 전용 현상이 아니다.** 원인 귀속은 하지 않는다 —
그것은 R2/E49의 질문이고, 여기서 "AArch64가 더 낫다"고 쓰면 제3의 기준값이 없는 상태에서
어느 쪽이 옳은지 단정하는 것이 된다(E45 §2.4).

**기준은 고치지 않았다**(D74 그대로). 계획 §2가 측정 전에 *"실입력에서 FAIL이 나오면 기준이 아니라
FAIL을 보고한다"*고 정해 뒀다.

### §2.3 Q2 — 계약·admission이 입력과 무관한가 → **PASS**

세 모델의 AArch64 계약 세 수치가 합성 셀(E36b·E32)과 실입력 셀에서 **같은 값**이고, 실입력 셀의
`budget`·`admitted_budget_bytes`가 그 `bounded`와 정확히 같다.

| 모델 | bounded | = per_call | + constants | kernel stack |
|---|---|---|---|---|
| b2_resnet | 618,856 | 309,416 | 309,440 | 1,232 |
| b3_deepae | 1,069,632 | 6,208 | 1,063,424 | 16 |
| smartcam | 18,222,796 | 9,382,092 | 8,840,704 | 1,856 |

### §2.4 Q3 — 예산 경계 → **PASS**

| 모델 | `B` (=bounded) | ADMIT peak | `B−1` | 거부 후 cFS가 계속 로드한 앱 |
|---|---:|---:|---:|---|
| b2_resnet | 618,856 | 309,416 (=per_call) | 618,855 → NOT_ADMITTED, 추론 0 | 9개 |
| b3_deepae | 1,069,632 | 6,208 (=per_call) | 1,069,631 → NOT_ADMITTED, 추론 0 | 8개 |
| smartcam | 18,222,796 | 9,382,092 (=per_call) | 18,222,795 → NOT_ADMITTED, 추론 0 | 9개 |

`budget_source`는 세 ADMIT 셀 전부 `override`다(E36의 런타임 오버라이드). 거부 셀은 셋 다
`CFE_ES_ExitApp` 이후 **같은 cFS가 남은 앱을 계속 로드**했고 크래시 0이다.

**세 모델 전부 peak가 `bounded`가 아니라 `per_call`이다** — E29b가 앱이 자기 blob을 64바이트
정렬하게 고쳤으므로 map 분기를 탄다. `admission_mode`는 전부 `unconditional`이다(계약이 실은 큰 쪽
`bounded`로 승인했고 실행은 작은 쪽을 썼다 — 이것은 조건부 계층이 **아니다**). `B−1`은 계획 §6 P3대로 **런타임 오버라이드**(`AI_LEARNER_BUDGET_OVERRIDE`, E36 신설)로만
주었다 — 컴파일 타임 매크로로 만들면 빌드 자체가 불가능하다(E32 §3.2가 겪은 것).

### §2.5 Q4 — 승인 근거 예산과 peak를 같은 범위에서 대조하는가 → **PASS**

셀마다 `admitted_budget_bytes`·`peak_within_admitted_budget`·`admission_mode`를 함께 기록한다
(D53/D59 이후 필드). 무조건 계층만 썼으므로 `admission_mode`는 전부 `unconditional`이다.

---

## §3 D80 — `runtime_created` 기대 키가 **양방향으로** 틀려 있었다

**이 실험이 찾은 저장소 결함이고, 검토 둘 다 지적하지 않았다.**

`harness/e14_cfs_scenarios.py`의 `check_expect`는 `runtime_created`를
`bool(last_run) or bool(stack)`으로 근사하고 있었다. 그런데 **E16(v0.11)이 스택 확인을
`Init()` 최선두, 즉 자원 획득 이전으로 옮겼다** — 거부가 할당 전에 일어나도록 만든 바로 그 수정이다.
그 뒤로 **거부되는 셀도 항상 `stack` 레코드를 남긴다.**

결과는 양방향이다:

- **유형 (B) 과잉 거부**: 정직한 `NOT_ADMITTED` 셀이 `runtime_created: False`를 **구조적으로 만족할 수
  없다**. 이 세션에서 ResNet `B−1` 셀이 실제로 그렇게 FAIL로 적혔다.
- **유형 (A) fail-open**: 반대로 `runtime_created: True`를 기대하는 셀은 **런타임이 만들어지지 않아도**
  스택 레코드 하나로 통과한다.

**왜 오늘까지 안 드러났나**: 이 키를 쓰는 시나리오는 `e14_make_scenarios.py`가 만드는 A2/A3/A5a/A8뿐이고,
그 셀들이 마지막으로 실행된 것이 **E14(v0.9), 즉 E16의 이동 이전**이다. 저장소 전수 조사로 확인했다 —
`runtime_created`를 기대한 보관 셀은 정확히 3개(`A3_mlp16k_swap`·`A4_mlp16k_missing`·`A8_dynamic_unknown`)이고
**셋 다 `stack` 레코드가 없다**.

**수정**: 근사에서 `stack`을 빼고 `mem_init`을 넣었다. `mem_init`은 IREE 세션과 입력 버퍼가 생긴 뒤,
추론 이전에 찍히는 레코드(E26 계측)라 정확히 "런타임이 만들어졌다"의 증인이다.

**보관 3셀의 판정은 불변**이다 — 그 로그엔 `stack`도 `mem_init`도 없어 수정 전후 모두 `False`다.
**revert-and-confirm-fail**: 옛 근사로 되돌리면 신규 시험 5건 중 **3건이 FAIL**하고, 고치면 0건이다.

**교훈**: ***한 실험이 신호가 찍히는 시점을 바꾸면, 그 신호를 옛 의미로 읽던 기대 키를 함께 고쳐야
한다 — 그리고 그 키를 쓰는 셀이 그 뒤로 한 번도 실행되지 않았다면, 틀렸다는 사실조차 기록되지 않는다.***

---

## §4 실제로 만든 것 — 계획 §4의 다섯 가지

### §4.1 fixture 재생성의 해시 대조 (계획 §4-1)

E45 fixture 디렉터리에는 `manifest.json`만 있고 `.npy`가 없었다. 이 세션에서 재생성한 뒤
`harness/mk_e25_inputs.py`가 **샘플마다** manifest의 sha256과 대조한다 — ResNet 200/200 ·
DeepAE 34/34 · SmartCam 19/19, 불일치 0.

**이 도구의 첫 판이 세 fixture를 전부 거부했다** — manifest는 `.npy` **파일**이 아니라 **배열 바이트**를
해시하는데(`model_fixture.py:251`) 파일을 해시했기 때문이다. 유형 (B) 과잉 거부이고, 하필 *잘못된 입력으로
채점하지 않으려고* 넣은 검사에서 났다. 판정에 닿기 전에 잡았고, 방향 때문에 기록한다 —
**틀린 해시 규칙이 여기서 fail-closed로 보이는 것은 전부에 대해 실패하기 때문이지 옳기 때문이 아니다.**

### §4.2 AArch64 cFS 앱 재빌드 (계획 §4-2)

게스트 트리의 `ai_learner.c`가 HEAD와 달랐다 — **D75의 `static yv` 수정이 들어간 적이 없었다**(차이는
정확히 그 12줄). 세 모델의 exe 트리를 HEAD 소스로 재빌드하고, `optin_witness.py`가 산출물에서
`AI_LEARNER_ALLOW_CONDITIONAL_MAP=0`을 되읽어 확인했다(E38 규율). 빌드 knob은 기본값을 **명시 전달**했다
(D61(b)의 공유 CMake 캐시).

### §4.3 러너가 실입력을 게스트로 나르게 (계획 §4-3)

`e14_cfs_scenarios.py`에 `stage`·`fetch`·`env` 세 키를 신설했다. E32/E36/E36b는 `/cf/e25_inputs.bin`
스테이징과 `AI_LEARNER_BUDGET_OVERRIDE`를 **러너 바깥에서 손으로** 했고, 그래서 시나리오 파일 —
요약이 인용하는 바로 그 파일 — 이 *어떤 입력을 재생했고 어떤 예산으로 판정했는지*를 말하지 못했다.
이제 말한다. 무엇이 스테이징됐고 무엇이 export됐는지는 결과에 `staged`/`env`로 실린다(E38/D69 규율).

**그리고 이 배선의 첫 판이 자기가 방금 올린 파일을 지웠다.** `e25_inputs.bin`/`e25_outputs.bin`의
`rm`을 실행 체인 안에 두는 바람에 scp 뒤에 돌았고, 그 셀은 **e25 모드가 꺼진 채** ADMIT과 올바른
`hal_peak`을 보고했다 — admission은 입력에 의존하지 않으므로 아무것도 이상해 보이지 않는다.
**잡아낸 것은 시험이 아니라 앱이 무조건 남기는 E26 위생 레코드**(`{"stage":"e25_mode","active":false}`)다.
**모드가 꺼졌음을 *증명*하려고 만든 계측이 잘못 꺼졌음을 증명했다.** 지금은 wipe가 스테이징 **이전**
별도 ssh 호출로 돌고, 올린 파일을 게스트에서 **되읽어** 크기를 대조한다.

### §4.4 요약 생성기의 일반화 (계획 §4-4)

`mk_e36b_summary.py`의 판독기(`stages`·`record_count`·`cfs_cell`·`semantics`)가 모듈 상수 대신
**경로를 인자로** 받는다. `mk_e48_summary.py`는 그것을 **import**한다 — 복사하지 않는다.
E36b 요약을 재생성해 **diff 0**을 확인했다.

### §4.5 DeepAE 입력 조달 (계획 §4-5)

EEMBC가 재배포를 문서로 거부하므로 바이트는 in-tree가 아니다. 네트워크로 다시 받아
**248/248 파일 해시 일치**를 확인했다.

---

## §5 하지 않은 것 (계획 §5 그대로)

- **WGAN의 AArch64** — 재실행이 아니라 **신규 반입**이다(계약이 x86-64 전용). 별도 실험.
- **OnAIR AArch64** — 이 저장소에 AArch64 OnAIR 환경이 없다.
- **정확도·지연·전력** — 범위 밖(변함없음). 세 모델의 정확도는 E45 §5의 사유가 모델마다 다르다.
- **조건부 계층** — 이번엔 무조건 계층만. SmartCam 조건부 셀은 E38의 것을 **인용**한다.
- **DeepAE FAIL의 원인 귀속** — R2/E49의 질문이다.

---

## §6 원자료

```
results/e48_real_inputs_aarch64/
  summary.json                      ← harness/mk_e48_summary.py (손조립 0, D64)
  {b2_resnet,b3_deepae,smartcam}/
    staged_inputs.json              ← 재생된 입력의 해시·개수·대조한 manifest
    replay_order.json               ← 게스트가 재생한 순서 (바이너리 추측이 아니라 그것을 쓴 목록)
    native_real.json                ← AArch64 qemu-user 전체 출력
    comparison_native_aarch64.json  ← 원본 TFLite oracle 대비 판정
    iree_cfs_aarch64.json           ← 게스트 e25_outputs.bin → 러너 JSON
    comparison_cfs_aarch64.json     ← 같은 기준, 같은 comparator
  cfs/logs/*.log                    ← 게스트 raw log (셀마다 build_config·stack·admission 포함)
  cfs/summary.json                  ← 러너가 쓴 셀별 기대·판정·staged·env
```

---

## §6.1 시험

이 컨테이너 **721/721 → 745/745**(FAIL 0 · SKIP 0). 신규 24건 중 D80 5건은
**revert 시 3건이 실제로 FAIL**한다. 보관 14개 계약 diff 0.

부수로 **셀 수를 리터럴로 들고 있던 자리 둘**을 데이터에서 읽도록 고쳤다 —
`mk_evidence_linkage.py`의 출력 문구(항목 8을 더하자 *"21셀 중 present 24"*라는 자기모순을
인쇄했다)와, 그 표를 검사하는 회귀 시험(이름이 *"all 21 cells (3 models x 7 items)"*인 채
FAIL 했다). 시험 쪽은 **불변식**(모든 모델이 모든 항목을 덮고 미해결 0)을 고정하되,
표가 조용히 **줄어드는** 것도 잡도록 최소 크기를 따로 단언한다.

## §7 교훈

1. ***한 실험이 신호가 찍히는 시점을 바꾸면 그 신호를 읽는 기대 키도 함께 고쳐야 한다*** (D80).
2. ***계측은 자기가 감시하는 조건이 잘못 성립했을 때도 증언한다*** — §4.3의 스테이징 결함을 잡은 것은
   시험이 아니라 E26 위생 레코드였다.
3. ***해시 규칙이 전부에 대해 실패하면 그것은 fail-closed가 아니라 그냥 틀린 것이다*** (§4.1).
