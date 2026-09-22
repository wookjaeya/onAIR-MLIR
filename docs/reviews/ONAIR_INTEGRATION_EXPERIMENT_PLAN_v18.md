# OnAIR 추가 통합 실험안 (JAIS 투고본 v18 보강)

**TOPIC** — OnAIR 플러그인 경로에 대해 논문이 주장하지만 증거가 없는 두 항목(판정 의미론 동치, 사전조건 A·보증 G의 성립)을 닫는 최소 실험.
**Problem** — v18은 OnAIR 경로를 기여 2(L.75)에 cFS와 나란히 세우지만, 증거는 x86-64·SmartCam 1모델·2셀·HAL 미계측(L.620)이며, L.644에서 "반복 실행 메모리는 별도 확인 필요"라고 자인한다.
**Solution** — x86-64 개발 호스트에서 (A) 4모델 × 경계 예산 판정 표를 cFS와 칸별 대조하고, (B) 다중 호출 HAL 피크를 관측해 A·G를 확인한다. AArch64 이식·브리지 통합은 하지 않는다.

행 번호는 `main.tex`(v18, 674행) 기준. 출처 없는 판단·추정은 **본인 분석·판단**.

---

## 0. 실험 범위와 원칙

| 항목 | 결정 |
|---|---|
| 실행 환경 | x86-64 개발 호스트. Python OnAIR(코어 수정 없음), 공식 드라이버를 서브프로세스로 구동하는 기존 하네스(L.620)를 그대로 사용 |
| 하지 않는 것 | AArch64/QEMU에서 OnAIR 구동, OnAIR–cFS 브리지, 4모델 실입력 전체 수치 비교 |
| 판정 기준 고정 | 논문 관행(L.396, L.542)대로 **측정 전에** 합격 기준을 아래에 고정하고 사후 완화하지 않음 |
| 결과 취급 | 불합격 셀도 보고. B의 피크 증가는 논문 논지("사전조건이 깨지면 바운드가 전이되지 않는다")를 강화하는 결과이므로 삭제 대상이 아님 |
| 분량 예산 | 본문 +120단어 이내, 표 1개. Table 7(참조 프로파일) 본문 흡수로 상쇄 |

## 1. 사전 준비 (측정 전 확인)

| # | 항목 | 확인 방법 | 상태 |
|---|---|---|---|
| P1 | 플러그인이 쓰는 IREE 런타임에서 HAL allocator 통계(피크)를 읽을 수 있는가 | IREE Python 바인딩의 allocator statistics API 존재 여부 확인. 없으면 C 런타임 + ctypes/cffi로 플러그인 실행 경로를 감싸 `iree_hal_allocator` 통계를 질의. 런타임이 통계 활성 빌드인지도 확인 | **미검증** — 리비전 3.11.0rc20260316(Table 2)에서 확인 필요 |
| P2 | 플러그인에 조건부 tier(admit_cond_map)가 구현되어 있는가 | 플러그인 소스 확인 | **미검증** → §4 분기 |
| P3 | OnAIR 플러그인 호출 규약(프레임마다 `update` / `render_reasoning` 호출) 및 출력 객체의 수명이 Python 쪽에 있는지 | OnAIR 저장소의 AI plugin 추상 클래스 확인(v11 각주 커밋 `e8af118…`) | 기억 기반, **미검증** |
| P4 | 아티팩트·명세 JSON·예산 주입 경로가 cFS 셀과 동일한 파일을 가리키는가 | 아티팩트 해시·명세 식별자(L.195 바인딩 식별자) 대조 | 실험 로그에 기록 |
| P5 | 참조 출력(원본 TFLite) 기록본이 4모델 모두 존재하는가 | Table 8(tab:outputs) 생성에 쓴 기록 재사용 | 확인 |

## 2. 실험 A — 판정 동치 (Verdict equivalence)

**목적:** "cFS 앱과 같은 판정 의미론"(L.75, L.351)을 단언이 아닌 대조 표로 입증.

**셀 설계:** 4모델 × 2예산 = 8셀 (조건부 tier가 있으면 §4 추가 8셀)

| 모델 | 예산 M | 기대 판정 | cFS 대조 출처 |
|---|---|---|---|
| ResNet | 618,855 / 618,856 | not_admitted / admit | Table 6 (tab:boundary) |
| DeepAE | 1,069,631 / 1,069,632 | not_admitted / admit | Table 6 |
| SmartCam | 18,222,795 / 18,222,796 | not_admitted / admit | Table 6, 기존 V.H 셀과 동일 |
| WGAN | 135,666,431 / 135,666,432 | not_admitted / admit | Table 6 |

**고정 조건:** OnAIR 코어 무수정, 공식 로더 경유, 같은 명세 JSON, x86-64 컴파일 아티팩트(성분 수치는 AArch64와 동일, L.397), admit 셀은 5회 추론(기존 V.H와 동일), refuse 셀은 IREE 세션 미생성 확인.

**기록 항목:** 판정, 판정에 사용된 예산, 세션 생성 여부, 추론 횟수, admit 셀의 출력이 Eq. (tolerance) 기준 통과 여부, 아티팩트·명세 식별자.

**합격 기준(고정):** 8셀 판정이 Table 6과 칸별 일치. 1칸이라도 불일치 → 원인 분석 전까지 논문 반영 보류.

**예상 소요:** 2–3시간 (본인 추정).

## 3. 실험 B — 다중 호출 HAL 피크 (사전조건 A, 보증 G)

**목적:** OnAIR 경로에서 (i) 호출 사이 출력이 해제되어 동시 호출 1개·출력 해제 조건(Table 1의 A)이 성립하고, (ii) 피크가 admitted 예산 이내에 머무는지(보증 G, Eq. obligation) 관측. cFS는 카운터로 계측했으나(L.239) OnAIR는 출력 수명이 Python에 있어 유일하게 A가 깨질 수 있는 경로.

**셀 설계:** 필수 1셀 + 선택 3셀

| 셀 | 모델 | 예산 | 호출 수 N | 비고 |
|---|---|---|---|---|
| B-1 (필수) | SmartCam | B_u = 18,222,796 | ≥ 50 (cFS 조건부 셀 35회보다 큼) | 기존 V.H와 같은 셀의 연장 |
| B-2 (선택) | DeepAE | B_u = 1,069,632 | ≥ 100 | 저비용, P가 작아 누수 검출 감도 높음 |
| B-3 (선택) | ResNet | B_u | ≥ 50 | |
| B-4 (선택) | WGAN | B_u | ≥ 5 | 시간 허용 시 |

**측정 시점:** 모듈 append 직후, 1회 호출 직후, 이후 매 호출 직후(또는 10회마다), N회 종료 후. 각 시점의 HAL 피크와 현재 live 바이트를 기록.

**기대값:**
- append 직후: 0 (map arm) 또는 C (copy arm). 모듈 버퍼 정렬 여부를 함께 기록해 arm을 확정.
- 1회 호출 후 피크: P (map) 또는 P + C (copy).
- N회 후 피크: 1회 후 피크와 **동일**. 증가 없음.
- 모든 시점 피크 ≤ 판정에 사용된 예산.

**합격 기준(고정):** peak(N) == peak(1) ∧ peak(N) ≤ M. 셀 B-1 필수 합격.

**불합격 시 처리:** 피크가 호출 수에 따라 증가하면 Python 측이 출력 버퍼를 보유하는 것. 플러그인에서 명시적 해제(버퍼 뷰 해제, 참조 삭제) 후 재실행. **두 셀 모두 보고** — 불합격 셀은 "A를 플러그인 쪽에서 강제해야 하는 경로"의 증거로 Sec. VI.C에 기술.

**copy-arm 변형:** Python 바인딩에서 모듈 버퍼 정렬을 직접 제어할 수 없으면 생략하고 그 사실을 기록. (C 런타임 경로에서만 가능했던 것과 동일 사정, L.446)

**예상 소요:** 계측 준비 포함 3–4시간 (본인 추정). P1이 불가하면 +반나절.

## 4. 분기 — 조건부 tier

| P2 결과 | 조치 |
|---|---|
| 플러그인에 조건부 tier 있음 | 실험 A에 SmartCam(최소) M = P = 9,382,092, 조건부 off/on 2셀 추가. 기대: off → not_admitted, on → admit_cond_map, 피크 = P. cFS Table 7(tab:conditional)과 대조 |
| 없음 | 실험 없이 L.351에 한 문장: 플러그인은 무조건 tier만 구현하며 조건부 tier의 정렬 확인은 cFS 앱에만 있음 |

## 5. 논문 반영 위치

| 위치 | 변경 | 분량 |
|---|---|---|
| Sec. V.H (L.620) | 기존 2셀 서술을 실험 A 표로 대체하고, 실험 B 결과 2문장 추가. "HAL allocation was not instrumented on this path" 문장 삭제 | +80단어, 표 1개 |
| Sec. VI.C (L.644) | "repeated-execution memory on that path must be confirmed independently…" → B 결과를 긍정문으로 서술 (합격이면 "peak unchanged over N calls"; 불합격+수정이면 A 강제의 필요성) | ±0 |
| Sec. IV.C (L.351) | 조건부 tier 유무 한 문장(§4) | +20단어 |
| Sec. VI.C 셀 집계 (L.648 부근) | OnAIR 셀 수를 flight-software 32셀과 **분리해** 별도 문장으로 집계 | +20단어 |
| 초록·기여 2 | 변경 없음 (증거가 주장 수준에 도달) | 0 |
| Table 7 (tab:profiles) | 본문 흡수로 분량 상쇄 | −표 1개 |

**V.H 삽입 문안 초안 (영문, 결과 대입용):**

> Across the four models, the plugin's verdicts at B_u − 1 and B_u matched the cFS verdicts of Table 6 cell for cell (Table X). Over N sequential calls of SmartCam at budget B_u, the HAL peak read after the first call was P and did not change through the N-th, so the output-release condition of Table 1 held on this path and the peak stayed within the admitted budget.

## 6. 로그·산출물 규격

- 셀당 1개 JSON: `{model, budget, policy, verdict, session_created, n_calls, hal_peak_after_load, hal_peak_after_call[1], hal_peak_after_call[N], module_buffer_aligned64, artifact_sha256, spec_id, onair_commit, iree_version}`
- 표 생성 스크립트는 JSON에서만 읽음(수기 전사 금지).
- 저장 경로와 명명 규칙은 기존 cFS 셀 아카이브와 동일하게.

## 7. 리스크

| 리스크 | 영향 | 대응 |
|---|---|---|
| P1 불가(Python 바인딩에 통계 API 없음) | 실험 B 지연 | C 런타임 + ctypes 경로, 또는 통계 활성 빌드 재생성 |
| B-1 피크 증가 | 논문 서술 변경 필요 | §3 불합격 처리. 논지에 불리하지 않음 |
| 실험 A 불일치 | 기여 2 주장 수정 필요 | 원인(예산 파싱, 정수 경계, 명세 식별자) 분리 후 재실행. 해결 전 반영 보류 |
| 분량 초과 | 편집자 축약 요구 | Table 7 흡수, Sec. V.F 민감도 문단 압축 |

## 8. 요약 체크리스트

- [ ] P1–P5 사전 확인
- [ ] 실험 A 8셀 (조건부 있으면 +2셀 이상)
- [ ] 실험 B-1 필수, B-2 권장
- [ ] 합격 기준 대비 판정, 불합격 셀 포함 기록
- [ ] Sec. V.H / VI.C / IV.C 반영, Table 7 흡수
- [ ] 셀 집계 문장에서 OnAIR 셀을 flight-software 셀과 분리
