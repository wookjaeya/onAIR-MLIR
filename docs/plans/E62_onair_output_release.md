# E62 계획 — OnAIR 플러그인 경로의 출력 버퍼 보유(D103) 수정과 그 검증

**사전 고정 문서다. 이 커밋에는 수정 코드(`plugins/compiled_learner/readback.py`와 플러그인 배선), 프로브
(`harness/e62_readback_probe.py`), 배포 설정(`configs/deployments/onair_deployments_e62_aarch64.json`)이 함께
들어간다 — 측정하는 것이 바로 이 커밋의 코드다. 이 커밋 전에 실행한 E62 셀은 없다.**

## 0. 왜

E57(v0.66)이 평가 타깃(AArch64 게스트)의 OnAIR 공식 로더 경로에서 **호출마다 출력 디바이스 버퍼 하나가 남는 것**을
관측했다(D103): live가 호출마다 정확히 `O`(40 / 2,560 / 12 / 602,112 B)씩 늘고 피크가 `P + (n−1)·O`이며, DeepAE는
450회 실행의 **417번째 호출에서 승인 예산을 넘었다**(E57c). E57b는 보유 위치를 **호스트 readback**으로 국한했다 —
결과를 읽지 않고 버리면 live 0, `np.array(out)`·`out.to_host()`는 둘 다 `O`씩 남기고 `gc.collect()`로도 풀리지 않는다.
E57b 계획 §3이 *"플러그인을 고친 뒤의 셀은 별도 실험으로 사전 등록한다"*고 정해 두었고, 이것이 그 실험이다.

## 1. 착수 전 조사 (실험 아님 — 소스 읽기)

평가한 휠(`iree-base-runtime 3.11.0`)이 잘려 나온 IREE 리비전 `e4a3b04`의 소스를 읽었다.

- `DeviceArray.__array__`/`to_host()` → `_map_to_host()` → `HalBufferView.map()`(`keep_alive<0, 1>`: 매핑이 뷰를
  살려 둔다) → `MappedMemory.asarray()`.
- `asarray`는 `runtime/bindings/python/numpy_interop.cc::SimpleNewFromData`로 배열을 만든다. 이 함수는
  `PyBuffer_FillInfo(&pybuf, base_object, …)`로 Py_buffer를 채우는데 **이 호출이 `MappedMemory`를 INCREF**하고,
  이어서 `PyMemoryView_FromBuffer(&pybuf)`로 감싼다. CPython은 그 구조체의 `obj`를 **빌린 참조**로 취급해
  memoryview 쪽에서 버린다(`memoryobject.c`: *"info->obj is either NULL or a borrowed reference. This reference
  should not be decremented in PyBuffer_Release()"* — `master.obj = NULL`). `PyBuffer_Release(&pybuf)`를 부르는 곳은
  없다. **따라서 INCREF 하나가 영구히 남고**, `MappedMemory`가 살아 있는 한 버퍼는 retain되고 뷰도 `keep_alive`로
  산다. 소스 주석은 *"array.base -> memoryview -> base_object"*로 수명이 이어진다고 적지만, 위 CPython 규칙 때문에
  그 사슬은 성립하지 않는다.
- 보관 원자료가 이 기전과 **정합**한다: E57 `run.json`의 인터프리터 종료 경고가 N회 호출 셀마다
  `nanobind: leaked 2N instances`(HalBufferView N + MappedMemory N)·`N keep_alive records`다(ResNet 100/50,
  DeepAE 200/100, DeepAE-long 900/450, SmartCam 100/50, WGAN 6/3; 거부 셀은 0). 이것은 정합이지 측정이 아니다 —
  기전은 셀 M이 **잰다**(§3).
- 균형 잡힌 대안: `MappedMemory`는 버퍼 프로토콜 슬롯을 갖고(`binding.h::buffer_protocol_slots`), 그 getbuffer는
  `Py_INCREF(self); view->obj = self`, 해제는 `PyBuffer_Release`가 DECREF한다 — **짝이 맞는다**.

## 2. 수정 (이 커밋)

- `plugins/compiled_learner/readback.py` 신설 — `read_output(out, mode)`:
  - `buffer_protocol`(**새 기본값**): 결과의 버퍼 뷰를 매핑하고 `memoryview(mapped)`로 바이트를 **복사**한 뒤
    memoryview를 release하고 모든 참조를 놓는다. `asarray`를 부르지 않는다.
  - `asarray`: 이전 readback(`np.array(out, copy=True).reshape(-1)`) **그대로** — E62의 대조군이자 E57 재현용.
  - **조용한 대체 없음**: `_buffer_view` 부재(휠 API 변화)·호스트 매핑 불가·dtype 오버라이드·매핑 길이 부족은
    `ReadbackUnavailable`로 올리고, 플러그인은 그것을 **비활성 상태 + 사유**로 바꾼다(추론 중단). `asarray`로 되돌아가면
    보유를 말없이 재개하는 것이다(D29·D51 계열).
  - `_buffer_view`는 고정한 휠(3.11.0)의 **비공개 속성**이다 — 이름이 바뀌면 위 규칙대로 거부한다.
- 플러그인: 배포 설정 `output_readback`(기본 `buffer_protocol`), 모르는 값은 초기화 가드 안에서 거부, init 레코드와 매
  추론 레코드에 `output_readback`을 싣는다.
- **E57 재현성**: E57 배포 설정(`onair_deployments_e57_aarch64.json`)의 모든 항목에 `output_readback: "asarray"`를
  **고정**한다 — E57이 실제로 돈 readback이고, 기본값이 바뀐 뒤에도 그 파일로 E57이 재현되게 한다. 보관 셀
  (`results/e57_onair_aarch64/`)은 건드리지 않는다.
- **강제(enforcement) 노브 `enforce_output_release`**(기본 off — 기존 배포 무변경): 켜면 플러그인이 매 호출 뒤
  자기 할당자를 읽어 live가 append 직후 값으로 **돌아오지 않았으면** `precondition_violated`를 기록하고 **추론을
  멈춘다**(다음 호출이 출력을 하나 더 쌓기 전에). 통계를 볼 수 없으면 **위반으로 센다**(볼 수 없는 것을 통과시키지
  않는다), 켰는데 초기화 시점에 통계가 없으면 **초기화 거부**. cFS 앱은 호출 계수기로 전제를 강제하는데(E55/P0-3)
  이 경로에는 예산 비교만 있었다.
  **출처를 적는다**: 이 노브와 그 셀(O-enf-*)은 v19 원고 메타리뷰(M1, *"플러그인에 강제 단계 추가"*)를 읽고 이
  계획에 더했다 — **이 계획의 커밋 전이고 어떤 E62 셀도 실행하기 전**이다. 같은 검토의 다른 문서(R1)는 수정 없이
  전제 위반 사례로 두는 것도 타당하다고 본다. 둘은 양립한다: E62는 수정(readback)과 강제(검출·정지)를 **별개 노브**로
  시험한다.
- cFS·native C 경로는 무관하다(C 런타임, E55 `max_active_calls`=1·피크 불변) — 건드리지 않는다.

## 3. 셀 — 전부 AArch64 QEMU 게스트, E57과 같은 휠(cp312-abi3 aarch64)·같은 아티팩트·같은 fixture·같은 예산

재컴파일 0. 게스트 구성은 셀 기록에 싣는다(SMP·MEM — 판정량은 결정론적 HAL 통계라 영향이 없다).

**M — 기전 (OnAIR 없이, DeepAE, 모드마다 별도 프로세스)** — `harness/e62_readback_probe.py`

| 셀 | 내용 |
|---|---|
| M-asarray | 1회 호출 → 뷰 매핑 → `MappedMemory.asarray`(DeviceArray가 하는 그대로) → `sys.getrefcount(mapped)`를 전·배열 생존 중·배열 삭제 후에 기록 → 모든 참조를 놓고 할당자 live |
| M-bufproto | 같은 절차를 `memoryview(mapped)`로 |
| L-asarray | **생산 함수** `read_output(…, "asarray")`로 20회 — 호출마다 live·peak·출력 sha256 |
| L-bufproto | `read_output(…, "buffer_protocol")`로 20회 — 같음 |

**O — OnAIR 공식 로더 (E57과 같은 텔레메트리 → 같은 호출 수)** — `configs/deployments/onair_deployments_e62_aarch64.json`

| 셀 | readback | 모델·N |
|---|---|---|
| O-fix ×4 | `buffer_protocol`(명시) | ResNet 50 · DeepAE 100 · SmartCam 50 · WGAN 3 |
| O-long | `buffer_protocol`(명시) | DeepAE 450 (E57c가 417번째에 초과한 그 텔레메트리) |
| O-ctl ×4 | `asarray`(명시) — **같은 E62 빌드**의 대조군 | 네 모델, O-fix와 같은 N |
| O-default | 키 없음 | ResNet 50 |
| O-deny ×4 | 키 없음, 예산 `B_u − 1` | 네 모델 |
| O-enf-ctl ×3 | `asarray` + `enforce_output_release` | ResNet · DeepAE · SmartCam (텔레메트리는 50 / 100 / 50행) |
| O-enf-fix ×3 | `buffer_protocol` + `enforce_output_release` | 같음 |

fix·ctl 두 팔의 차이는 배포 키 **하나**다(E56의 같은 바이너리·노브 하나 설계; D97 대비). 강제 셀도 짝마다 readback
키 하나만 다르다. WGAN 강제 셀은 돌리지 않는다(한 호출이 게스트에서 수십 분 — 강제 로직은 모델과 무관한 코드지만
**모델 일반성은 주장하지 않고** 세 모델로 한정해 적는다).

## 4. 판정 기준 (측정 전 고정)

기호: `P`(per_call) = 309,416 / 6,208 / 9,382,092 / 131,382,784 B, `O` = 40 / 2,560 / 12 / 602,112 B
(ResNet / DeepAE / SmartCam / WGAN).

- **P1 (기전)**: M-asarray에서 배열 삭제 후 refcount가 전보다 **정확히 +1**이고, 모든 참조를 놓은 뒤 live가 **`O`**.
  M-bufproto에서 release 후 refcount 변화 **0**이고 live **0**. 두 셀의 출력 sha256 동일.
- **P2 (프로브 반복)**: L-bufproto의 20개 행 전부 live **0**·peak **= `P`**. L-asarray는 호출 k 후 live **= k·`O`**
  (E57b R1과 같은 기울기). 두 루프의 호출별 출력 sha256 **20/20 동일**.
- **P3 (수정 팔)**: O-fix 4셀과 O-long의 **모든 추론 레코드**에서 `device_bytes_live` = append 직후 값(0)이고
  `device_bytes_peak` **= `P`**. 추론 수 = 50 / 100 / 50 / 3 / 450. 레코드의 `output_readback` = `buffer_protocol`.
  따라서 O-long은 **어느 호출에서도 승인 예산을 넘지 않는다**(E57c의 F5가 이 readback에서는 일어나지 않는다).
- **P4 (값 불변)**: O-fix·O-long·O-ctl·O-default의 **모든 출력**이 같은 원천 배포의 E57 보관 레코드와 같은 `n`에서
  **비트 동일**(E57은 같은 휠·아티팩트·fixture·텔레메트리). readback이 값을 바꾸면 수정이 아니다.
- **P5 (대조 팔 = E57)**: O-ctl 4셀의 호출별 `device_bytes_peak`·`device_bytes_live`가 E57 보관 레코드와 **같은 `n`에서
  정확히 같다** — 대조 팔이 E57을 재현해야 수정 팔과의 차이를 노브 하나에 귀속할 수 있다.
- **P6 (종료 보고)**: 수정 팔 셀의 stderr에 `HalBufferView`·`MappedMemory` 타입의 nanobind 누수 인스턴스가 **0**,
  대조 팔은 E57처럼 **각 N**. 다른 타입의 누수 줄이 나오면 기록하되 판정에 쓰지 않는다.
- **P7 (기본값)**: O-default의 init 레코드 `output_readback` = `buffer_protocol`이고 P3의 조건을 만족한다.
- **P8 (판정 반쪽 불변)**: O-deny 4셀 전부 `NOT_ADMITTED`·`runtime_created` false·추론 0(E57 실험 A와 같다).
  OnAIR 코어 추적 파일 변경 0(전 셀).
- **P9 (강제)**: O-enf-ctl 3셀은 **정확히 1회** 추론하고 `precondition_violated`를 기록한다(그 레코드의 live = `O`,
  post-append = 0). 이후 추론 0 — 따라서 피크는 `P`를 넘지 않는다. OnAIR 실행은 rc 0으로 끝난다(비활성 상태로
  남을 뿐 프로세스를 죽이지 않는다). O-enf-fix 3셀은 위반 **0**, 추론 50 / 100 / 50, 전 레코드 live 0·peak = `P`
  (강제 검사가 정직한 실행을 막지 않는다 — 과잉 거부 0).

**판정**: P1–P9 전부 성립하면 **PASS**. P2–P9가 성립하고 P1만 어긋나면 **FIX_PASS_MECHANISM_UNCONFIRMED** —
수정은 효과가 있으나 §1이 이름 붙인 기전은 측정으로 확인되지 않았다(그러면 `readback.py` docstring의 기전 서술을
고친다). 그 밖은 **FAIL**이고 어느 조건이 어긋났는지 그대로 적는다.

## 5. 반증·주의 조건

- **F1**: 수정 팔 어느 레코드든 live > 0 또는 peak ≠ `P` → 수정이 불충분. **이 실험 안에서 고치지 않는다**(보고하고
  새 계획으로).
- **F2**: 출력 하나라도 E57과 다름 → readback이 다른 바이트를 읽는다 → FAIL.
- **F3**: 대조 팔이 E57과 다름 → E62 빌드가 readback 말고 다른 것을 바꿨다 → 노브 귀속 무효.
- **F4**: M-asarray의 refcount 변화가 0 → §1의 기전이 틀렸다.
- **F5**: 수정 팔에서 `readback_unavailable` 이벤트 → 이 휠에서 수정 경로가 적용되지 않는다.
- **F6**: O-enf-fix에서 위반이 기록됨 → 강제 검사가 정직한 실행을 거부한다(유형 B). O-enf-ctl에서 위반이 없거나 2회
  이상 추론 → 강제 검사가 작동하지 않는다(유형 A).

## 6. 보고 규칙

- PASS면 원고(§V.H·§VI.C·결론)는 **두 관측을 함께** 쓴다: 이전 readback은 호출마다 출력 버퍼를 남겨 DeepAE가
  417번째 호출에서 승인 예산을 넘었고(E57c — **지우지 않는다**), 버퍼 프로토콜 readback으로 바꾼 같은 빌드에서는
  모든 호출의 피크가 정확히 `P`였다. 보유 원인은 **이 리비전의 바인딩 readback**이라고 쓰되 상류에 보고했다거나
  상류 결함이 고쳐졌다고 쓰지 않는다.
- D103은 원장에 남기고 조치 칸에 E62를 적는다(철회가 아니라 조치 기록).

## 7. 주장하지 않는 것

- IREE 상류 결함의 확정·수정·보고 · 다른 휠·리비전·드라이버로의 일반화
- 호스트 매핑이 안 되는 결과(디바이스 복사 경로 — 그 경로도 `asarray`를 쓰므로 수정 경로는 **거부**한다)
- 지연·성능(게스트는 `FUNCTIONAL_ONLY`) · cFS 경로(무관) · 조건부 계층(전 셀 `allow_conditional_map=false`)
- 프로세스 RSS(D78) — 판정량은 HAL 할당자 통계다
