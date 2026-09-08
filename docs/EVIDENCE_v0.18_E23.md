# EVIDENCE v0.18 — E23: 외부 검토 F4·F8·F10·F11 + CI가 잡은 신규 크래시(D25)

## 0. 등급과 범위

**증거 등급: 결정론적**(바이트 단위 비교, 해시, 파싱 성공/실패, 시험 통과 수, IREE 런타임의
거부 메시지). 절대 지연값은 이 문서 어디에도 없다.

**범위**: `docs/reviews/REVIEW_v0_15_LATEST.md`가 남긴 4건(F4·F8·F10·F11 — F1·F2·F3·F5·F6·F7은
E21, F9는 E22에서 처리)과, **E22가 만든 CI가 실제 실행에서 잡아낸 신규 결함 1건(D25)**을 다룬다.

**범위 밖(명시)**: 게스트 cFS 안에서 이 A5b 생성기로 시나리오를 실제 재실행하는 것은 하지 않았다
(`~/onair-mlir-bench` 게스트 이미지가 이 컨테이너에 없다 — §5 참조). OnAIR 자체를 설치해
플러그인을 end-to-end로 돌리는 것도 하지 않았다(이 컨테이너에 `onair` 패키지가 없다 — §2의
바인딩 게이트는 OnAIR 없이 동작하는 stdlib 모듈로 분리해 단위 시험했다). OnAIR·native·cFS의
**출력 동치** end-to-end 시험은 F10의 나머지 절반으로, CLAUDE.md 우선순위 8번에 등록했다.

## 1. F8 — A5a/A5b 손상 방식의 코드화 (D26)

### 1.1 재현된 문제

`docs/EVIDENCE_v0.12_E17.md` §2.1은 A5b가 **`module.fb`의 FlatBuffer 길이 접두사를 구조적으로
손상**시킨 것이라고 서술한다. 그런데 저장소의 시나리오 생성기·설치기에는 **그 코드가 없었다**:

- `harness/e14_make_scenarios.py`의 A5a·A5b가 **똑같이** `{"corrupt_of": …, "flip_offset": 4096}`
  이었고, 두 방식을 구분하는 필드 자체가 없었다.
- `harness/e14_cfs_scenarios.py`는 그 dict를 받아 **무조건** `b[off] ^= 0xFF` 한 줄을 실행했다
  (`off = v.get("flip_offset", 4096)`) — A5b 시나리오에도 A5a의 임의 bit flip이 적용된다.

즉 E17이 보고한 결과 자체는 (수작업으로) 구조 손상을 만들어 얻은 것이지만, **저장소 코드로는
그 실험을 재현할 수 없었다.** 리뷰의 지적 그대로다.

수정 전 코드로 되돌려 확인(revert-and-confirm-fail): `corrupt_method`가 없는 A5b 항목을 주면
예외 없이 `b[4096]^=0xFF` 단계를 만들어 낸다 — 신규 시험이 옛 코드에서 실제로 실패함을 확인.

### 1.2 수정 — `harness/corrupt_vmfb.py` 신설

두 방식을 이름 있는 실제 코드로 만들었다.

| method | 동작 | 어느 게이트가 잡아야 하는가 |
|---|---|---|
| `flip` (A5a) | 원시 파일 오프셋 1바이트 XOR, 구조 무관 | 계약-아티팩트 **해시 게이트**(IREE 호출 전) |
| `flatbuffer_root_uoffset` (A5b) | `module.fb` 엔트리의 첫 4바이트(길이 접두사)만 `0xFFFFFFFF`로 | **IREE 자신의 FlatBuffer 검증기**(해시 게이트는 MATCH여야 함) |

A5b는 ZIP을 풀었다 다시 압축하지 않는다 — 로컬 파일 헤더와 중앙 디렉터리 레코드를 직접 파싱해
**해당 4바이트만 덮고 양쪽의 CRC32를 갱신하는 외과적 패치**다. 실물 `.vmfb`가 ZIP64 확장 필드를
쓴다는 사실(32비트 크기·오프셋 필드가 전부 `0xFFFFFFFF` 센티널, 실제 값은 id `0x0001` 레코드
안)을 구현 중 발견해 그에 맞춰 파싱한다.

**보관된 실물 vmfb 8개(2타깃×4모델) 전부에서 확인**:

| 확인 항목 | 결과 |
|---|---|
| 손상 후에도 유효한 ZIP (`testzip()` = CRC 검사) | 8/8 통과 |
| `module.fb` 첫 4바이트 = `ffffffff` | 8/8 |
| 나머지 엔트리(`_const.bin`, 임베디드 ELF) 바이트 불변 | 8/8 |
| 파일 전체 크기 불변 | 8/8 |
| 같은 입력 재실행 시 바이트 동일(결정적) | 확인 — 호스트에서 만든 `corruptsha` 계약의 해시가 게스트에서 만들어질 파일과 일치해야 하므로 **필수 성질** |

전제 자체도 실물로 검증했다: 8개 파일 모두 `module.fb`가 **비압축(ZIP_STORED)**이고, 그 첫
4바이트(LE uint32)가 **`len(module.fb)`와 정확히 일치**한다 — 임의의 비트 패턴이 아니라 실제
길이 접두사이므로 `0xFFFFFFFF`는 어떤 정상 vmfb에서도 확실히 범위 밖이다.

### 1.3 fail-closed 배선

`corrupt_method`가 **없거나 미인식이면 `ValueError`로 거부**한다(시나리오 설치 단계, ssh 세션을
열기 전). CLI도 `--method`에 기본값이 없어 미인식 값은 exit 2. 게스트에는 이 스크립트 자체를
scp해서 실행한다 — 한 줄짜리 인라인 코드로 재구현하지 않는다.

### 1.4 A5b를 Python 런타임 레벨에서도 실행

E17이 A5b를 세 레벨(native x86-64 / cFS x86-64 / cFS AArch64 게스트)에서 실행했다. 이번엔 이
생성기가 만든 파일을 **`iree.runtime`으로 실제 로드**해 네 번째 레벨을 추가했다:

```
원본 x86_64 mlp16k        : 정상 로드
root_uoffset 손상 mlp16k   : ValueError ... INVALID_ARGUMENT;
    FlatBuffer length prefix out of bounds (prefix is 4294967295 but only 733911 available)
conv2d / multibranch      : 동일 (16533 / 53118 available)
```

E17이 cFS에서 관측한 것과 **같은 오류 문자열**이다(`EVIDENCE_v0.12_E17.md` §2.2 표). 즉 이
생성기가 만드는 손상은 그때 수작업으로 만든 것과 같은 조건을 재현한다.

## 2. F10 — OnAIR 경로의 계약-아티팩트 바인딩 갭 (D27)

### 2.1 재현된 문제

`plugins/compiled_learner/compiled_learner_plugin.py`의 `_load_artifact()`는 계약이 지목한
`.vmfb`를 **아무 검사 없이** 곧장 열어 IREE에 넘겼다(수정 전 코드, 5줄):

```python
vmfb = os.path.join(self.artifact_dir, self.contract["artifact"]["file"])
ctx = rt.SystemContext(config=rt.Config(self.driver))
ctx.add_vm_module(rt.VmModule.copy_buffer(ctx.instance, open(vmfb, "rb").read()))
```

같은 저장소의 C 경로(`native/native_learner.c:167-187`, cFS 앱)는 **크기 선검사 → sha256 →
불일치 시 자원 획득 전 거부**를 이미 하고 있었다. 즉 A3(모델 교체)·A5a(손상) 시나리오에서
C 경로가 잡는 것을 OnAIR 경로는 그대로 통과시킨다.

### 2.2 수정

`plugins/compiled_learner/artifact_binding.py` 신설 — 의존성 없이(stdlib만) 동작해 OnAIR·IREE가
없는 환경에서도 단위 시험이 가능하다. 순서는 C 경로와 같다:

1. `artifact.bytes` 없으면 **거부**(검사 생략이 아니라), 있으면 파일 크기와 비교 — 불일치면
   파일을 읽지 않고 거부.
2. `artifact.sha256` 없으면 **거부**, 있으면 파일 바이트의 sha256과 비교.
3. 통과 시 **해시한 바로 그 바이트**를 반환해 IREE에 넘긴다(다시 읽는 창을 만들지 않는다 —
   `native_learner.c`의 binding_rule과 같은 규칙).

기본값은 `verify_artifact_hash=True`. `False`로 명시하면 거부 대신 경고와 함께
`binding = {"verdict": "UNVERIFIED", …}`를 기록한다(조용한 무검사는 없다).

시험 6건 전부 통과: 정상 MATCH(sanity), A5a flip 거부, A5b root_uoffset 거부(크기는 같으므로
sha256이 잡는다), 잘림 파일 거부(크기 단계에서), `artifact.bytes` 누락 거부, `artifact.sha256`
누락 거부, 그리고 `corruptsha` 계약+손상 파일은 **MATCH**(A5b의 전제 — 해시 게이트는 통과하고
IREE만이 거부할 수 있어야 한다).

## 3. F4 — "정규 MLIR pass" 표현 정정

두 지점을 대조해 사실로 확인했다. `docs/EVIDENCE_v0.13_E18.md`에 **§7 정오표**를 추가하고
(본문은 작업 규율 5에 따라 고치지 않는다), `CLAUDE.md`의 해당 서술은 살아있는 현황 문단이므로
직접 정정했다.

1. **`Operation.walk()` 서술이 코드와 다름** — 실제로는 자체 구현 재귀 제너레이터
   `_walk()`(`harness/mlir_alloc_walk.py:98-103`)다. 순회 결과가 같으므로 §3의 14/14 일치
   판정에는 영향이 없다 — 틀린 것은 결과가 아니라 "무엇을 호출했는가"의 서술이다.
2. **명칭** — 컴파일러 파이프라인에 등록돼 in-memory module에서 도는 `Pass`가 아니라,
   `--mlir-print-ir-after` 텍스트 덤프를 다시 읽는 후처리 도구다(`grep -n
   "PassManager\|runOnOperation" harness/mlir_alloc_walk.py` → 결과 없음). 리뷰가 제안한
   **"MLIR API 기반 구조적 post-processing verifier"**를 채택하고, CLAUDE.md 우선순위 3번의
   "정규 MLIR/IREE pass"는 **여전히 미착수인 목표**를 가리키는 것으로 재해석한다.

## 4. F11 — 판정 유지(not-a-defect), 산출물에 범위 명시

E21의 병렬 검증이 F11을 "기존에 문서화된 한계의 재확인"으로 판정한 것을 유지한다(CLAUDE.md
우선순위 5가 이미 "다중 앱 전역 예약 없음"을 적고 있다). 다만 **판정 산출물 자체가 그 범위를
말하도록** `ai_learner.c`의 admission JSON에 `"scope":"per_app_local_budget"`을 추가했다 —
로그만 보는 제3자가 이 값을 "온보드 컴퓨터 전체 수용 판정"으로 오독할 여지를 줄인다.

리뷰가 지적한 항목 중 **allocator fragmentation**은 이 저장소 어디에도 명시적으로 다뤄진 적이
없어, CLAUDE.md 우선순위 5에 교차 참조로 남겼다.

## 5. D25 — CI가 잡은 신규 크래시 (E22의 시뮬레이션이 놓친 것)

이번 실험에서 **가장 중요한 방법론적 결과**다.

E22는 "의존성 없는 환경에서 크래시 없이 77/77+3 SKIP"을 주장하며, 그 확인을 `sys.meta_path`
훅으로 `iree.compiler.ir` **import를 차단**해 수행했다. 그런데 E22가 함께 만든 CI의
`without-deps` 레그(진짜로 `iree-base-compiler`를 설치하지 않은 러너)는 **실패**했다:

```
FileNotFoundError: [Errno 2] No such file or directory: 'iree-dump-module'
  harness/make_contract.py:229 in iree_dump_module
```

원인: import 차단은 **Python 모듈만** 숨기고 `iree-compile`·`iree-dump-module` **콘솔
스크립트는 PATH에 그대로 남긴다.** 진짜 의존성 없는 체크아웃에는 둘 다 없다. D24와 같은
부류(요약 출력 전 uncaught 예외로 전체 사망)의 **두 번째 지점**이며, 시뮬레이션으로는 원리적으로
재현할 수 없었던 조건이다 — **실제 CI가 아니었으면 계속 놓쳤을 것이다.**

이 조건을 이번엔 충실히 재현했다: `env -i PATH=/usr/bin:/bin`(iree 바이너리 없음) +
import 차단(모듈 없음). 수정 전 코드에서 같은 `FileNotFoundError`를 확인했고, 수정 후:

| 환경 | 측정 위치 | 결과 |
|---|---|---|
| 전체 환경(모듈·도구 모두 있음) | 이 컨테이너 + **CI `with-deps`** | **125/125 PASS** |
| 모듈만 부재(E22가 시험한 조건) | 이 컨테이너(import 차단) | 95/95 PASS + 3 SKIP |
| 도구·모듈 부재, `iree.runtime`은 있음 | 이 컨테이너(`env -i PATH=/usr/bin:/bin` + import 차단) | 50/50 PASS + 5 SKIP |
| **진짜 의존성 없는 체크아웃** | **CI `without-deps` 레그(실측)** | **48/48 PASS + 6 SKIP, 크래시 없음** |

로컬 시뮬레이션(50/50+5)과 CI 실측(48/48+6)이 다른 이유도 같은 계열이다 — 이 컨테이너에는
`iree-base-runtime`이 설치돼 있어 §1.4의 A5b 런타임 거부 시험 2건이 실제로 **실행**되지만, CI
러너에는 그것도 없어 SKIP 1건으로 합쳐진다. **본 문서는 두 수치를 모두, 각각의 조건과 함께
적는다** — 어느 하나를 "그 환경의 수치"로 일반화하지 않는다(D25가 준 교훈 그대로).

### 5.1 수정 내용

- `make_contract.iree_dump_module()` / `static_mem_bound.artifact_rodata_segments()`가 `OSError`를
  잡는다. 후자는 `([], [])`가 **아니라 `(None, None)`**을 반환한다 — "관측했고 세그먼트가 없었다"와
  "관측 자체를 못 했다"는 다른 주장이기 때문이다.
- 상수 총량의 **독립 확인**(IR 값이 아닌 아티팩트 쪽 `.rodata` 관측)을 못 하면
  `constants_independently_confirmed_in_artifact`를 `false`가 아니라 **`null`**로 기록하고,
  **기본적으로 계약 생성을 거부**한다(`--allow-unverified-invocation`으로만 우회 — F1이 "평가
  불가"에 부여한 것과 같은 처리). `constants_check_note`도 3-상태가 됐다: 이전 코드라면 "확인
  못 함"이 **"NOT matched"(확인했고 모순)**로 인쇄됐을 것이다.
- 시험 하네스에 `iree_tools_available()`(콘솔 스크립트 존재 여부, `structural_available()`의
  모듈 존재 여부와 **별개의 질문**)을 신설. 실제 도구가 필요한 시험은 FAIL이 아니라 SKIP.
  F1 음성 시험은 이 환경에서 `--allow-unverified-invocation`이 **시험 대상이자 환경이 요구하는
  플래그**가 되어 두 조건을 분리할 수 없으므로, 틀린 이유로 통과하지 않도록 SKIP한다.

## 6. 정오표 — `docs/EVIDENCE_v0.17_E22.md` §1에 대한 정정

E22 §1의 "`iree.compiler.ir`을 … `sys.meta_path` 훅으로 차단해 **'패키지가 아예 없는 환경'을
가역적으로 시뮬레이션**"이라는 서술은 **과장이었다**. 그 훅은 Python 모듈만 숨기고 콘솔
스크립트는 남기므로, 실제로 시뮬레이션한 것은 "패키지가 없는 환경"이 아니라 **"모듈만 없는
환경"**이다. 같은 §의 "77/77 + 3 SKIP"이라는 수치 자체는 그 조건에서 참이지만, **진짜 의존성
없는 체크아웃의 수치는 아니다**(그 환경에서는 §5가 보인 대로 크래시했다). E22의 §4 판정
("README의 '환경 구축 불필요'는 이제 정확한 주장이다")은 D25 수정 **이후에** 참이 된다.

`docs/EVIDENCE_v0.17_E22.md`에도 같은 취지의 §6 정오표를 덧붙였다(철회 아님, 정정).

## 7. 판정

- F8·F10은 **실제 코드 결함**으로 확인돼 수정했다(D26·D27). 둘 다 수정 전 코드로 되돌려 신규
  시험이 실제로 실패함을 확인했다.
- F4는 **표현 정정**으로 처리했다(수치·판정 불변).
- F11은 **not-a-defect(기존 한계)** 판정을 유지하되 산출물에 범위를 명시했다.
- D25는 **E22의 검증 방법 자체의 한계**가 드러난 사례다 — 시뮬레이션은 실제 환경의 부분집합만
  재현한다는 이 프로젝트의 반복된 교훈(D2·D3·D5–D7과 같은 계열)이 또 한 번 확인됐다. 이번엔
  사람이 아니라 **CI가** 그 역할을 했다.
- `harness/contract_negative_tests.py` 107/107 → **125/125**(전체 환경, CI `with-deps` 포함).
  진짜 의존성 없는 체크아웃은 CI 실측 **48/48 + 6 SKIP**(크래시 없음). 14개 보관 계약 diff 0 유지.
- 요약 줄이 모든 SKIP을 "iree.compiler.ir 미설치"로 뭉뚱그리던 것도 실제 사유별로 나열하도록
  고쳤다 — CI의 without-deps 레그는 세 가지(모듈·콘솔 스크립트·`iree.runtime`)가 모두 없다.

## 8. 재현

```bash
# F8: 손상 생성기 (재컴파일 없음, 보관된 vmfb만 사용)
python3 harness/corrupt_vmfb.py --method flatbuffer_root_uoffset \
  --in results/e14_aarch64_qemu/x86_64/vmfb/mlp16k.vmfb --out /tmp/corrupt.vmfb \
  --contract results/e14_aarch64_qemu/x86_64/contracts/contract.mlp16k.x86_64.json \
  --contract-out /tmp/contract.corruptsha.json
python3 -c "import iree.runtime as rt; c=rt.SystemContext(config=rt.Config('local-sync')); \
  c.add_vm_module(rt.VmModule.copy_buffer(c.instance, open('/tmp/corrupt.vmfb','rb').read()))"
  # -> INVALID_ARGUMENT; FlatBuffer length prefix out of bounds (prefix is 4294967295 ...)

# 전체 시험 (세 환경)
python3 harness/contract_negative_tests.py                      # 125/125
PYTHONPATH=<module-block> python3 harness/contract_negative_tests.py   # 95/95 + 3 SKIP
env -i HOME=$HOME PATH=/usr/bin:/bin PYTHONPATH=<module-block> \
  /usr/bin/python3 harness/contract_negative_tests.py           # 50/50 + 5 SKIP (iree.runtime는 있는 조건)
# 진짜 의존성 없는 체크아웃의 수치(48/48 + 6 SKIP)는 CI without-deps 레그가 매 푸시마다 실측한다
```

`<module-block>`은 `sitecustomize.py`에서 `sys.meta_path`에 `iree.compiler` import를 막는
finder를 넣은 디렉터리다(패키지를 실제로 지우지 않는 가역적 방법).
