# 현재 실험 결과에 대한 연구 방향 판단

## 1. 종합 판단

현재까지의 실험 결과는 초기 연구 가설이었던

> **“OnAIR Learner를 MLIR/IREE로 AOT 컴파일하면 Python 기반 Learner보다 더 빠르고 더 예측 가능한 실행 특성을 얻을 수 있다.”**

라는 주장을 그대로 유지하기 어렵게 만든다.

실제로 동일한 MLP 모델과 동일 입력을 사용한 비교에서 IREE compiled Learner는 NumPy/BLAS Learner보다 전 모델 크기에서 약 **6–9배 느렸으며**, hidden size를 16에서 65536까지 확대해도 성능 교차점이 나타나지 않았다.

또한 소형 모델에서는 compiled implementation의 상대적인 tail latency와 execution-time variability가 Python보다 오히려 나쁜 결과가 관측되었다. 대형 모델에서 compiled 쪽의 p99/median이 일부 개선되는 신호가 나타났지만, 그 차이는 현재 실행 플랫폼의 noise 범위보다 작기 때문에 아직 유의한 timing evidence로 사용할 수 없다.

따라서 기존 H1은 주가설에서 내려놓는 것이 타당하다.

그러나 이러한 결과는 **MLIR 기반 연구 자체의 실패를 의미하지 않는다.**

오히려 실험 E3와 E4를 통해 연구 문제를 보다 명확하게 좁힐 수 있는 근거가 확보되었다.

---

## 2. 핵심 연구 문제의 이동

초기 연구 질문은 다음과 같았다.

> **“MLIR AOT compilation이 Python inference보다 우수한가?”**

하지만 현재 결과에 따르면 이 질문 자체가 연구의 핵심이 되기 어렵다.

E3에서 연산이 없는 IREE identity artifact의 호출 비용은 median 약 **4.7 μs**에 불과한 반면, 대형 모델에서 compiled와 NumPy의 실행시간 차이는 수백 μs 수준이었다. 따라서 observed performance gap은 Python↔IREE marshaling overhead만으로 설명되지 않는다.

즉 핵심 원인은

> **AOT compilation 여부가 아니라 생성된 kernel과 lowering configuration의 품질**

에 있다.

따라서 연구 질문은 다음과 같이 변경하는 것이 적절하다.

> **동일한 AI 모델을 대상으로 여러 MLIR/IREE lowering configuration이 서로 다른 timing·tail·memory 특성을 보일 때, spacecraft mission의 timing/resource contract를 만족하도록 적절한 lowering을 자동 선택할 수 있는가?**

이 질문이 현재 실험 결과와 가장 직접적으로 연결된다.

---

# 3. E4가 현재 연구에서 가장 중요한 결과인 이유

동일 MLIR, 동일 weight, 동일 runtime을 사용하면서 compiler configuration만 변경한 E4에서 실행시간 median이 약 **82.3 μs에서 154.0 μs까지 변화하여 최대 1.87배 차이**가 나타났다. 이 차이는 현재 실험 플랫폼에서 측정된 noise ratio 1.67배보다 크다.

특히 세 가지 결과가 중요하다.

### 3.1 Lowering configuration은 실행 특성에 실질적인 영향을 준다

동일한 모델임에도 compiler option에 따라 성능 차이가 발생했다.

따라서 다음 mapping이 실제로 존재한다.

\[
l_i
\rightarrow
(C_{median}, C_{p99}, M_{peak}, \ldots)
\]

여기서 \(l_i\)는 특정 lowering configuration이다.

이것은 본 연구가 contract-aware compiler selection을 연구할 수 있는 최소 전제가 실제 실험에서 확인되었다는 의미다.

---

### 3.2 최적 configuration은 직관적으로 결정할 수 없다

`+avx2,+fma`를 명시한 configuration이 default보다 오히려 느렸다.

따라서

> ISA extension을 많이 사용하거나 aggressive optimization을 적용하면 항상 빠를 것이다.

라는 단순 규칙은 성립하지 않는다.

즉 lowering selection은 hand-crafted heuristic이 아니라 실제 target characterization 또는 분석에 기반해야 한다.

---

### 3.3 평균 성능과 predictability가 같은 방향으로 움직이지 않는다

E4에서 median이 가장 좋은 configuration은 `target-cpu=host`였지만, 상대적인 p99/median이 가장 작은 configuration은 `+avx2`였다.

이는 다음과 같은 trade-off가 존재할 가능성을 보여준다.

\[
\text{Best average latency}
\neq
\text{Best tail behavior}
\]

따라서 compiler objective를 단순히

\[
\min C
\]

로 설정해서는 부족하다.

이 결과는 오히려 **Timing Contract 기반 lowering selection**의 필요성을 강화한다.

---

# 4. 연구 가설 재구성

## H1 — 보조 가설로 축소

기존:

> AOT-compiled Learner는 Python Learner보다 tail latency와 variability를 감소시킨다.

현재 결과로는 유지하기 어렵다.

따라서 다음과 같이 수정하는 것이 적절하다.

> **H1-R. AOT compilation의 timing predictability 효과는 모델 규모, runtime boundary, target architecture 및 lowering configuration에 의존한다.**

즉 AOT compilation 자체를 독립적인 개선 요인으로 주장하지 않는다.

H1-R은 이후 ARM64 PASS 플랫폼과 native integration 환경에서 다시 검증하는 보조 가설로 둔다.

---

## H2 — 주가설로 승격

> **H2. 동일 AI 모델에서도 MLIR lowering configuration에 따라 latency, tail behavior 및 resource usage가 비직관적으로 변화하며, mission timing/resource contract를 이용한 lowering selection은 고정된 default configuration보다 contract satisfaction을 개선할 수 있다.**

현재 E4는 H2의 앞부분을 직접 지지한다.

이미

\[
l_i \rightarrow C(l_i)
\]

가 유의하게 변화한다는 증거를 얻었다.

아직 검증하지 못한 부분은

\[
Contract
\rightarrow l^*
\rightarrow
\text{fewer deadline violations}
\]

이다.

따라서 이후 연구는 이 부분을 증명하는 방향으로 집중해야 한다.

---

## H3 — Deployment Feasibility Prediction

> **H3. target-specific timing/resource characterization과 cFS workload model을 결합한 contract analysis는 AI deployment가 주어진 deadline 및 resource budget을 만족할지를 runtime 이전에 판별할 수 있다.**

이 가설에서 가장 중요한 metric은 일반적인 classification accuracy가 아니다.

특히 다음 경우가 중요하다.

\[
Predicted\;Feasible
\land
Observed\;Deadline\;Miss
\]

즉 실제로 실패하는 configuration을 안전하다고 판정하는 **false-safe**를 최소화해야 한다.

현재 H3는 아직 실험되지 않았다.

---

# 5. 연구의 중심 Contribution도 수정해야 한다

초기 연구의 암묵적 contribution은

> MLIR을 이용해 OnAIR AI plugin을 compile한다.

에 가까웠다.

하지만 이것만으로는 기존 ML compiler/IREE/NNEF 연구와 차별성이 부족하다.

현재 실험 결과를 반영하면 contribution은 다음과 같이 재정의하는 것이 좋다.

### C1. Timing/Resource Contract

OnAIR AI workload에 대해 다음 정보를 갖는 deployment contract를 정의한다.

\[
K =
\langle
T,\,
D,\,
C^{bound},\,
M^{bound},\,
I,\,
O,\,
A
\rangle
\]

---

### C2. Compiled OnAIR Learner

기존 OnAIR plugin architecture를 변경하지 않고 MLIR/IREE native artifact를 Learner로 삽입한다.

E0에서 이미 OnAIR core modification 0줄로 해당 구조가 가능함을 확인했다.

---

### C3. Contract-Guided Lowering Selection

본 연구에서 가장 중요한 compiler contribution이다.

여러 lowering candidate

\[
L_m =
\{l_1,l_2,\dots,l_n\}
\]

를 생성하고 각각

\[
l_i
\rightarrow
(C_{median}, C_{p99}, M_{peak}, \ldots)
\]

를 characterization한다.

그 후 mission contract를 만족하는 configuration만 배치 후보로 인정한다.

---

### C4. cFS System-Level Validation

단독 inference benchmark가 아니라 cFS task workload와 AI inference를 동시에 실행한다.

최종적으로 평가해야 할 것은

\[
\Delta R_{cFS}
\]

와

\[
Deadline\ Miss\ Ratio
\]

이다.

즉 AI 자체의 latency뿐 아니라 기존 flight-software task에 미치는 interference까지 평가한다.

---

# 6. 목적함수도 수정 필요

기존 연구노트의

\[
\min_l
\alpha C(l)
+
\beta M(l)
\]

형태는 현재 결과를 충분히 표현하지 못한다.

E4에서 median과 tail behavior의 ranking이 서로 달랐기 때문이다.

따라서 단순 weighted objective보다 다음 형태의 constraint formulation을 우선 고려하는 것이 좋다.

\[
C^{bound}(l) \le D_{AI}
\]

\[
M_{peak}(l) \le M_{budget}
\]

\[
Sched(\tau_{cFS}\cup\tau_{AI}(l))
=
true
\]

이를 만족하는 configuration 집합

\[
L_{valid}
\]

중 필요에 따라

\[
\min_{l\in L_{valid}}
C_{median}(l)
\]

또는

\[
\min_{l\in L_{valid}}
M_{peak}(l)
\]

을 선택한다.

이 구조가 “가장 빠른 compiler configuration 선택”과 본 연구를 구분한다.

---

# 7. Python/NumPy baseline에 대한 판단

현재 NumPy/BLAS baseline은 제거하거나 약화해서는 안 된다.

실험 결과 compiled implementation보다 훨씬 높은 성능을 보였기 때문이다.

따라서 논문의 목표를

> MLIR이 Python보다 빠르다.

로 설정하면 불필요한 경쟁이 된다.

오히려 다음처럼 정직하게 두는 것이 좋다.

**NumPy/BLAS가 제공하는 장점**

- 높은 평균 throughput
- 잘 최적화된 GEMV/GEMM
- 개발 편의성

**제안 framework가 목표로 하는 추가적인 축**

- explicit timing contract
- peak memory/resource constraint
- static/native deployment
- target-specific lowering exploration
- cFS schedulability integration
- 여러 hardware target에 대한 동일 compiler abstraction

즉 성능 하나가 아닌 **deployment feasibility**가 연구 대상이다.

---

# 8. Native cFS Variant의 필요성

현재 OnAIR compiled Learner는 여전히 Python wrapper를 거친다.

E3에서 약 4.7 μs의 fixed call overhead가 확인됐고, L2b end-to-end 측정에서도 compiled implementation의 상대적 손해가 커졌다. 
따라서 최종 실험에서는 반드시 다음 형태가 추가되어야 한다.

```text
cFS C Application
       │
       ▼
MLIR/LLVM Native Artifact
       │
       ▼
Inference Result
       │
       ▼
Software Bus Publish
```

최종 비교는 최소 다음 세 층으로 나누는 것이 좋다.

| 구현 | 의미 |
|---|---|
| Python-OnAIR | 현재 rapid-prototyping baseline |
| Compiled-OnAIR | MLIR backend 효과 |
| Native-cFS | Python orchestration 제거 후 flight-oriented deployment |

이를 통해 inference backend 비용과 framework/interface 비용을 분리할 수 있다.

---

# 9. TFLite Micro Baseline은 추가하는 것이 타당함

현재 연구에서 reviewer가 제기할 수 있는 가장 강한 반론 중 하나는 다음이다.

> 정적 memory와 embedded inference가 필요하다면 왜 MLIR/IREE여야 하는가?

따라서 TFLite Micro와 같은 conventional embedded inference runtime을 baseline으로 추가할 필요가 있다. 해당 필요성은 현재 실험 문서에서도 이미 확인되었다.

최종 baseline은 다음 구조가 좋다.

| ID | 구현 |
|---|---|
| B0 | NumPy/BLAS |
| B1 | Default MLIR/IREE |
| B2 | TFLite Micro |
| P | Contract-Guided MLIR |

이때 P가 반드시 absolute fastest일 필요는 없다.

P의 목표는

> **주어진 deadline + memory + cFS schedulability 조건을 만족하는 implementation을 선택할 수 있는가**

이다.

---

# 10. 현재 결과의 가장 큰 한계

현재 timing_grade가 `FUNCTIONAL_ONLY`이다.

실행 플랫폼의 p99 noise ratio가 **1.67**, maximum ratio가 **2.26​**이므로 작은 timing 차이는 신뢰성 있는 real-time evidence로 사용할 수 없다.

따라서 현재 실험으로 주장할 수 있는 것은 제한적이다.

### 현재 말할 수 있는 것

> Lowering configuration에 따라 execution behavior가 크게 달라질 수 있다.

E4의 1.87배 차이가 현재 noise threshold를 넘기 때문이다.

### 현재 말할 수 없는 것

> 특정 lowering이 다른 lowering보다 timing-predictable하다.

작은 p99/median 차이는 현재 플랫폼 noise 내부일 가능성이 있다.

따라서 현재 결과는

**real-time guarantee evidence**

가 아니라

**compiler design-space motivation evidence**

로 사용하는 것이 적절하다.

---

# 11. 이후 실험 우선순위

## Priority 1 — PASS 등급 ARM64 플랫폼

가장 먼저 실험 환경을 바꾸는 것이 좋다.

권장:

- ARM64 SBC
- CPU frequency governor 고정
- isolated core
- 불필요 daemon 최소화
- CPU affinity
- 가능하면 PREEMPT_RT
- `SCHED_FIFO` 실험

새 플랫폼에서 먼저 `platform_check`를 수행한 후 timing experiment를 진행한다.

---

## Priority 2 — Lowering Design Space 확대

단순 target ISA flag만 비교하지 않고 실제 compiler transformation을 다양화한다.

예:

- tile size
- vectorization
- fusion
- thread count
- static allocation
- bufferization strategy
- target CPU
- link/static runtime configuration

각 configuration에 대해

\[
l_i
\rightarrow
(C_{median},C_{p95},C_{p99},M_{peak},S_{binary})
\]

를 구축한다.

이 데이터가 contract-aware selector의 실제 입력이 된다.

---

## Priority 3 — Native cFS Variant

Python boundary를 제거하고 실제 cFS C application에 MLIR-generated artifact를 링크한다.

이를 통해 flight-oriented contract의 의미를 검증한다.

---

## Priority 4 — Deadline / Load Sweep

AI deadline과 cFS load를 인위적으로 변화시킨다.

예:

\[
D_{AI}
=
\{10,20,30,40,\dots\}\text{ms}
\]

\[
U_{cFS}
=
\{20\%,40\%,60\%,80\%\}
\]

그리고 각 lowering에서

\[
Deadline\ Miss\ Ratio
\]

를 측정한다.

이 실험이 H2의 핵심 본검증이 된다.

---

## Priority 5 — H3 Contract Prediction

offline characterization을 이용해 configuration을

```text
Feasible
Infeasible
```

로 사전 분류한 뒤 실제 execution 결과와 비교한다.

특히 false-safe를 중심으로 평가한다.

---

# 12. 연구 제목 수정 의견

기존 제목:

> **Timing-Contract-Aware MLIR Compilation for AI Plugins in NASA OnAIR/cFS**

도 사용할 수 있다.

하지만 현재 결과를 반영하면 다음 두 제목이 더 정확하다.

### 추천 1

**Contract-Guided MLIR Lowering for Predictable AI Deployment in NASA OnAIR/cFS**

### 추천 2

**Timing-Contract-Aware MLIR Lowering Selection for AI Workloads in NASA OnAIR/cFS**

개인적으로는 첫 번째가 가장 좋다.

이유는 연구의 본질이

> compilation 자체

가 아니라

> **contract → lowering choice → deployment**

이기 때문이다.

---

# 13. 현재 연구의 새로운 핵심 Thesis

현재 evidence를 반영한 thesis statement는 다음과 같이 수정하는 것이 가장 적절하다.

> **The primary challenge in deploying compiled AI workloads in NASA OnAIR/cFS is not whether ahead-of-time compilation universally outperforms Python-based execution, but how target-specific lowering choices affect timing and resource behavior and whether those choices can be systematically selected from mission deployment contracts.**

그리고 solution statement는:

> **This research proposes a contract-guided MLIR compilation framework that characterizes candidate lowering configurations and selects deployment artifacts based on timing, memory, and cFS schedulability constraints.**

---

# 14. 최종 평가

이번 실험은 초기 H1에는 부정적인 결과다.

그러나 연구 전체에는 오히려 긍정적이다.

초기에는

```text
Python
   vs.
MLIR AOT
```

라는 비교적 단순한 연구 구조였다.

현재는 실험을 통해 다음 문제가 실제로 드러났다.

```text
                    Same Model
                       │
                Different Lowerings
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      fast median   better tail   low memory
          │            │            │
          └────────────┼────────────┘
                       │
                Which one is valid?
                       │
                       ▼
                Mission Contract
```

즉 연구 질문이

> **“MLIR이 빠른가?”**

에서

> **“어떤 MLIR lowering이 이 mission에 적합한가?”**

로 바뀌었다.

후자의 질문이 훨씬 더 명확한 compiler/system research problem이다.

특히 E4에서 확인된 **1.87배 configuration-dependent performance difference, 비직관적인 configuration ranking, median과 tail metric의 불일치​**는 이러한 문제 설정을 뒷받침하는 최초의 empirical evidence로 사용할 수 있다.

따라서 현재 단계에서는 **H1을 방어하려고 추가 최적화를 시도하는 것보다, H2를 연구의 중심 가설로 승격하고 `Contract → Lowering Selection → cFS System Behavior`의 인과관계를 검증하는 방향으로 연구를 재구성하는 것이 가장 타당하다.**