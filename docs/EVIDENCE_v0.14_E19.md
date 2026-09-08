# EVIDENCE v0.14 — E19: 정규 MLIR pass — 구조적 추출기를 make_contract.py에 결선 (2단계)

## 0. 등급과 범위

**증거 등급: 결정론적**(파싱 성공/실패, 계약 재생성 diff, 하드 실패 발생 여부). 이 실험도 E18과
마찬가지로 IR 텍스트 처리와 API 호출만 다룬다.

**범위**: `docs/EVIDENCE_v0.13_E18.md`가 범위 밖으로 명시한 항목 중 하나("`make_contract.py`로의
통합")를 이번 실험에서 다룬다. 다만 **교체가 아니라 결선**이다 — E18 §4가 적은 대로
`stream.resource.pack` 실사용 미시험, 다른 IREE 컴파일러 버전 미검증이 아직 남아 있어 구조적
추출기를 유일한 진실 공급원으로 승격시키는 것은 시기상조라고 판단했다. 대신 정규식 파서
(`static_mem_bound.parse_alloc_ir`, E15로 fail-closed화됨)와 구조적 추출기(E18)를 **둘 다** 돌려
서로 대조하고, **불일치하면 계약 자체를 거부**하는 방식으로 결합했다. **재컴파일 없음** — E18과
동일하게 보관된 v0.9의 `layout_ir` 파일만 사용해 one-invocation 규칙을 지켰다.

## 1. 배경

두 외부 검토와 제안서가 요구한 "정규 MLIR/IREE pass"의 목적은 텍스트 정규식에 의존하지 않는
할당 크기 추출이었다. E18이 그 추출기 자체(`harness/mlir_alloc_walk.py`)를 만들고 14/14 정확성을
확인했지만, **독립 도구로만 존재**했다 — 실제 계약을 생성하는 `make_contract.py`는 여전히
`static_mem_bound.parse_alloc_ir` 하나만 신뢰했다. 두 도구가 같은 입력에서 같은 답을 낸다는
사실이 검증됐다고 해서, 그 사실이 프로덕션 경로에 실제로 연결되지 않으면 계약의 건전성에
아무 영향도 주지 못한다.

## 2. 설계: 대체가 아니라 상호 검증

`harness/make_contract.py`의 `build_contract()`에 새 단계를 추가했다(모듈-상주 상수 계산 직후,
`iree-dump-module` 호출 이전):

1. `mlir_alloc_walk`가 임포트 가능하고 `iree.compiler.ir`가 사용 가능하면(`structural_available`),
   `maw.parse_alloc_ir_structural(ir, entry)`를 호출해 `structural`을 얻는다.
2. `structural`을 기존에 이미 계산돼 있던 `whole = smb.parse_alloc_ir(ir, entry)`(정규식 파서의
   전체-IR 파스 결과 — E18의 14/14 검증이 정확히 이 두 값을 비교한 것과 같은 대상)와
   `inputs`/`outputs`/`transient_slabs`(원소별), `constants`(합계 대 `dense_sum`),
   `entry_found`, `unresolved`(존재 여부) 다섯 항목으로 대조한다.
3. 불일치가 있거나(`structural_diffs`) 구조적 추출기가 아예 파싱에 실패하면
   (`structural_error`), 그 사실을 `hard_fail_errors`에 추가한다 — 이는 `make_contract.py`가
   D13(EVIDENCE_v0.9 §11.9)에서 이미 ABI 불일치·triple 불일치·ELF 분석 불일치에 쓰던 것과 **같은
   리스트, 같은 raise 지점**이다. `--allow-structural-mismatch`를 명시적으로 주지 않는 한 계약을
   쓰지 않는다.
4. `iree.compiler.ir`가 애초에 설치돼 있지 않으면(`structural_available=False`) — 이것은
   "불일치"가 아니라 "검증 불가"이므로 **하드 실패시키지 않는다**. `notes`에 기록하고 정규식
   파서 단독(E15 이전부터 있던 fail-closed 기준선)으로 계약을 쓴다. 구조적 추출기를 도입한
   것이 이 도구를 설치하지 않은 환경에서 계약 생성을 아예 막아버리면, 그 자체가 새로운 실패
   모드(불필요한 가용성 저하)이기 때문이다.

모든 결과는 `contract["provenance"]["structural_walker"]`에 `{available, parse_error,
agrees_with_regex_parser, diffs, dispatches, note}`로 기록된다 — `elf_analysis` provenance와
같은 자리, 같은 스타일이다. `contracts/contract.schema.json`의 `provenance`는
`additionalProperties`를 제한하지 않으므로 스키마 변경은 필요 없었다(기존 `elf_analysis` 필드도
스키마에 명시돼 있지 않다).

## 3. 검증

### 3.1 14개 보관 계약 재생성 — 실제 프로덕션 경로로

`harness/contract_negative_tests.py::regression_check()`는 이미 E15부터 있던 시험이다(각 모델의
저장된 `invocation.json`으로 `make_contract.py`를 **서브프로세스로 실제 재실행**해 값을 대조).
이번에 두 가지를 추가했다:

- 기존 diff 비교에서 `provenance.structural_walker` 서브트리를 제외(신규 필드이므로 "기존 값이
  안 바뀜"의 대상이 아님 — `IGNORE_PROVENANCE_SUBTREES`로 경로 단위 제외, 이름 충돌 방지를 위해
  기존의 leaf-이름 기반 `IGNORE_PROVENANCE_KEYS`와는 별도 메커니즘 사용).
- 재생성된 계약마다 `provenance.structural_walker.available`과 `.agrees_with_regex_parser`가
  둘 다 `True`인지 별도로 확인.

결과: **14/14 계약 수치 diff 0**(회귀 없음, E15와 동일 결론 재확인) + **14/14
`available=True, agrees_with_regex_parser=True`**(신규 크로스체크가 실제 `make_contract.py` CLI
경로를 통해 매번 정상 작동함을 증명 — E18의 검증은 `mlir_alloc_walk.py`를 직접 호출했을 뿐,
`make_contract.py`를 거치지 않았다).

### 3.2 하드 실패 배선 자체의 검증 (in-process monkeypatch)

정규식 파서와 구조적 추출기가 실제로 불일치하는 정상 형태의 layout IR은 존재하지 않는다(그것이
E18의 결론이다) — 즉 "진짜" 불일치 픽스처를 만들 수 없다. 대신 `make_contract`를 모듈로 임포트해
`mc.maw.parse_alloc_ir_structural`을 몽키패치하고 `build_contract()`를 직접 호출해, 새 코드
경로가 존재하는 두 조건(불일치, 파싱 예외)에서 실제로 `SystemExit`을 내는지 확인했다:

| 시험 | 결과 |
|---|---|
| 패치 없이 실제 conv2d 아티팩트 → 수락(정합성 확인) | PASS |
| 구조적 추출기가 `inputs`를 다르게 반환하도록 패치 → 거부 | PASS(`one-invocation / provenance check FAILED`) |
| 같은 불일치 + `--allow-structural-mismatch` → 수락 | PASS |
| 구조적 추출기가 예외를 던지도록 패치(컴파일러 버전 변경 시뮬레이션) → 거부 | PASS |
| 패치 원복 후 다시 정상 수락(오염 없음 확인) | PASS |

`harness/contract_negative_tests.py`가 51/51(E15) → 66/66(E18) → **85/85**(E19: 신규 14건
regression 크로스체크 + 5건 하드실패 배선)으로 확장됐다.

## 4. 환경 의존성 — 우아한 저하(graceful degradation) 확인

`mc.maw`를 `ir=None`인 가짜 모듈로 대체해 "`iree.compiler.ir`가 설치되지 않은 환경"을 시뮬레이션한
결과: `structural_walker.available=False`, `note`에 사유 기록, 그러나 `bounded_bytes`는 정규식
파서만으로 정상 계산됨을 확인(3528, conv2d 기준값과 동일). 즉 이 결선이 구조적 추출기가 없는
환경(예: `iree-base-compiler` Python 패키지 없이 `iree-compile` 바이너리만 있는 CI)에서 계약 생성
자체를 막지 않는다.

## 5. 이번 실험이 다루지 않는 것 (범위 밖)

- **구조적 추출기로의 완전 대체**: 여전히 정규식 파서가 `bounded_bytes` 등 실제 숫자의 공급원이다
  (`p`, `whole` 기반). 구조적 추출기는 검증만 한다 — 둘이 불일치하면 규칙에 따라 어느 쪽이 옳은지
  판정하지 않고 그냥 거부한다(의도된 설계: 자동으로 "이 쪽이 맞다"고 고르는 것 자체가 위험).
- **`stream.resource.pack` 실사용 시험**: E18 §4와 동일하게 여전히 미시험.
- **다른 IREE 컴파일러 버전 재확인**: §3.2의 "예외 시 거부"는 몽키패치로 그 조건을 시뮬레이션한
  것이지, 실제 다른 버전의 IREE를 설치해 재확인한 것이 아니다. 배선이 존재하고 작동한다는 것과
  실제 버전 변경에서 발동한다는 것은 다른 주장이다.
- **성능**: 계약 생성마다 `ir.Context()`를 새로 만들고 여러 (entry, initializer) 조합을 시도하는
  `parse_alloc_ir_structural`의 비용은 측정하지 않았다 — 이 프로젝트의 계약 생성은 배치 전
  1회성 작업이라 중요도가 낮다고 보고 있으나, 명시적으로 측정하지 않았다는 사실 자체는 기록한다.

## 6. 판정

CLAUDE.md 우선순위 3번의 남은 목표 중 "`make_contract.py`로의 통합"을 **상호 검증(mandatory
cross-check) 형태로** 완료했다 — E18이 스스로 범위 밖이라 적었던 항목이다. "컴파일러 버전 변경 시
명시적 실패" 평가지표는 이제 실제 강제 지점(구조적 추출기 파싱 실패 시 하드 실패)을 갖췄지만,
다른 버전으로의 실제 재확인은 여전히 하지 않았다(§5). 14/14 회귀 무손상 + 85/85 음성/단위/회귀
시험 전부 통과.

## 7. 재현

```bash
python3 harness/contract_negative_tests.py   # regression 14건 구조적 크로스체크 + hard-fail 5건 포함, 85/85
python3 harness/make_contract.py --mlir <M> --vmfb <V> --layout-ir <IR> --dump-dir <D> \
  --triple aarch64-unknown-linux-gnu --cpu cortex-a53 --model-name conv2d \
  --elf-analysis <ELF.json> --out /tmp/contract.json --no-validate \
  --extra-args --mlir-elide-elementsattrs-if-larger=16
# provenance.structural_walker 확인
python3 -c "import json; print(json.load(open('/tmp/contract.json'))['provenance']['structural_walker'])"
```

## 8. 정오표 (E20, `docs/EVIDENCE_v0.15_E20.md`가 정본 — 여기는 요약과 포인터만)

이 문서를 커밋한 직후, 같은 세션에서 이 diff에 대해 적대적 코드 리뷰(4개 관점 병렬 리뷰 + finding당
3인 반박 검증)를 돌렸다. §3의 "14/14 일치" 자체는 여전히 참이지만(14개 저장 모델 전부
`packed_sum == dense_sum`, 즉 padding=0이라 아래 두 결함이 지금까지 드러나지 않았을 뿐), 새 크로스체크
로직 자체에 **실제 재현 가능한 과잉 거부(over-rejection) 결함 2건**이 있었다:

- **버그 A**: 크로스체크가 계약이 실제로 서명하는 값 `p`(lowering_score로 고른, 파일 순서와 무관한
  값)가 아니라 `whole`(정규식 파서의 "파일 마지막 print = 가장 lowering됨" 가정에 의존하는 값,
  이 파일 자신의 최상단 docstring이 스레드 스케줄링에 좌우된다고 경고하는 바로 그 가정)과
  비교하고 있었다. 저장된 conv2d layout IR에서 entry 함수의 두 print 청크(내용은 그대로, 순서만
  교환)를 실제로 바꿔 재현: 구조적 추출기는 실제 계약값(`p`)과 완전히 일치했는데도 `whole`과
  달라 하드 거부됐다.
- **버그 B**: constants(sum) 비교가 계약이 실제로 채택하는 `const_b`(패킹된 크기, 정렬 패딩/중복
  제거 포함)가 아니라 `dense_sum`(패킹 이전 per-tensor 합)과 비교되고 있었다. 저장된 mlp16k
  layout IR의 패킹 버퍼 크기(모든 관련 SSA 참조)만 64B 늘려(정렬 패딩 시뮬레이션, per-tensor
  dense 선언은 그대로 둠) 재현: 정렬 패딩이 있는 완전히 정상적인 모델이 하드 거부됐다.

두 결함 모두 **`p`/`const_b` 기준으로 비교하도록 수정**했고(E20), 위 두 재현 시나리오를 실제
회귀 시험(`harness/contract_negative_tests.py::structural_bugfix_regression_cases`)으로 등록해
고정했다 — 수정 전 코드로 되돌리면 두 시험이 실제로 실패함을 확인(fix가 실제로 이 조건을 잡는지
검증, 우연히 통과하는 시험이 아님). 상세 재현·판정은 `docs/EVIDENCE_v0.15_E20.md` 참조. §3의
"14/14 일치" 수치와 §5의 범위 밖 항목은 이 정오표로 무효화되지 않는다 — 다만 §5가 암묵적으로
전제한 "크로스체크 로직 자체는 건전하다"는 가정은 이 정오표가 좁힌다.
