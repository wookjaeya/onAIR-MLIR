# E26 계측 분리 — 동작 확인 (측정 아님)

이 디렉터리는 **E26 본 측정이 아니다.** 외부 검토(`docs/reviews/REVIEW_v0_22_E25.md` §6
"E26 측정 전 필수 사항")가 요구한 계측 분리가 실제로 동작하는지 확인한 실행 기록이다.
E26의 판정·수치는 사전 고정 기준을 커밋한 뒤 `results/e26_boundary_utility/` 아래 별도
디렉터리에 기록한다.

## 무엇을 확인했나

검토의 지적: `/cf/e25_inputs.bin`이 있으면 cFS 앱이 **초기화 중 64회 추론**을 먼저 돌리므로,
run 루프의 첫 `mem` 레코드는 이미 오염돼 있고 초기화·최초 추론·정상 실행의 메모리 통계가
섞인다. native 경로도 같다(E25 블록이 `st_warm`·최종 통계보다 앞).

추가한 것(게이트·판정 로직은 건드리지 않음):

| 신호 | 어디 | 왜 |
|---|---|---|
| `{"stage":"e25_mode","active":false}` | cFS, **항상** 기록 | 측정 실행이 "동치 모드가 꺼져 있었다"를 **증명**할 수 있어야 한다. 파일이 없었으리라 **가정**하는 것으로는 부족하다 |
| `{"stage":"mem_init",...}` | cFS, 모듈 로드+입력 버퍼 이후·추론 0회 시점 | 지금까지 HAL 통계는 run 루프에서만 나왔다 — "모듈을 적재하고 입력 버퍼를 잡는 것만으로 얼마가 드는가"가 아예 관측되지 않았다 |
| `rss_kb_after_session` | cFS | IREE 런타임 컨텍스트(instance+device+session)는 **계약 밖** 버킷이다. 모듈 로드와 분리해 귀속하기 위함 |
| `phase_hal.{after_init,after_first_call,steady_baseline}` | native | 같은 분해를 native 경로에서 |
| `e25_mode_active` | native JSON | 위와 같은 이유 |
| expect 키 `e25_mode_active`, `mem_init_present` | `harness/e14_cfs_scenarios.py` | **레코드 부재는 `false`가 아니다** — 그 레코드를 내지 않는 옛 앱은 "꺼져 있었다"를 증언할 수 없으므로 침묵으로 통과하지 않고 실패한다(D29의 교훈) |

## 실측 (이 컨테이너, x86-64, canonical_e25 모델)

두 경로가 같은 vmfb(`0e250c2f…`)와 같은 계약(`bounded=786476`, `per_call=65580`,
`constants=720896`)으로 실행됐고, **계약의 두 구성요소가 실행 단계별로 분리 관측**됐다.

| 단계 | native `phase_hal` peak | cFS `mem_init`/`mem` peak | 해석 |
|---|---|---|---|
| 초기화 직후(추론 0회) | **720,932** | **720,932** | `constants` 720,896 + **36 B** |
| 최초 추론 직후 | **786,476** | — | per-call transient slab이 여기서 나타남 |
| 정상 실행 | 786,476 | 786,476 | `bounded_bytes`와 정확히 일치 |

- 36 B = `CONTRACT_INPUT_ELEMS`(9) × 4 B — **입력 버퍼**다. 계약 영역이 아니라 wrapper 버킷이며,
  E26이 분리 귀속해야 하는 항목이 실제로 분리돼 나온다는 첫 확인이다.
- cFS RSS 분해: 런타임 이전 8,188 KB → 세션 생성 후 8,492 KB(**+304 KB**, IREE 런타임 컨텍스트)
  → 초기화 완료 9,356 KB(**+864 KB**, 모듈 로드). **이 값들은 증거 등급이 다르다** — RSS는
  결정론적이지 않으므로 E26에서 x86-64 반복 측정의 범위로만 다룬다(작업 규율 4).
- HAL 통계·계약 수치는 결정론적이므로 그대로 인용 가능하다.

## 파일

- `native_x86_64_canonical_e25mode_off.jsonl` — `native_learner` 20회 실행(`e25_mode_active=false`)
- `cfs_x86_64_canonical_e25mode_off.log` — 실제 `core-cpu1` 기동
  (`cf/e25_inputs.bin` 부재 확인 후 실행, `EXIT=124`는 timeout 종료로 기존 시나리오와 동일)

## 재현

```bash
python3 harness/gen_contract_header.py results/e25_equivalence/build/model_canonical.contract.json \
    native/cfs_app/fsw/src/contract_gen.h
MODEL_VMFB=$PWD/results/e25_equivalence/build/model_canonical.vmfb AI_LEARNER_BUDGET_BYTES=786477 \
    bash scripts/50_wire_cfs_ai_learner.sh
cd $HOME/onair-mlir-bench/ext/cFS/build-native_std/exe/cpu1 && rm -f cf/e25_inputs.bin && ./core-cpu1
git checkout native/cfs_app/fsw/src/contract_gen.h      # 저장소 기본 헤더 원복
```
