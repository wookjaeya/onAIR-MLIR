# Timing-Contract-Aware MLIR Compilation for AI Plugins in NASA OnAIR/cFS

## 0. 연구 주제

**영문 가제**

**Timing-Contract-Aware MLIR Compilation for AI Plugins in NASA OnAIR/cFS**

보다 논문의 문제의식을 강조한다면 다음 제목이 더 좋을 수 있다.

**From Rapid Prototyping to Timing-Aware Deployment: MLIR-Based Compilation of AI Plugins for NASA OnAIR/cFS**

### 한 문장 요약

> NASA OnAIR의 Python 기반 AI Learner plugin을 MLIR/LLVM을 통해 정적 native artifact로 컴파일하고, 모델의 실행시간·메모리·입출력·target 정보를 명시적인 timing contract로 생성하여, cFS와 공존하는 onboard AI가 주어진 deadline/resource budget을 만족하는지를 배포 전에 검증할 수 있는 compilation framework를 제안한다.

이 연구에서 중요한 것은 **AI를 더 빠르게 만드는 것 자체가 아니다.**

핵심 질문은 다음이다.

> **OnAIR의 rapid-prototyping 장점을 유지하면서 AI inference를 cFS와 함께 운용 가능한, 실행 특성이 명시된 software component로 변환할 수 있는가?**

---

# 1. 연구 배경

NASA OnAIR는 Python으로 작성된 AI 알고리즘을 NASA cFS와 연결하기 위한 open-source cognitive architecture이다. 현재 OnAIR는 CSV, Redis, cFS/SBN 등의 data adapter를 통해 데이터를 받고, Knowledge Representation → Learner → Planner → Complex Reasoner의 plugin pipeline으로 처리한다. NASA 공개 소스에서 `low_level_data`는 Python list, `high_level_data`는 nested dictionary이며, Learner plugin은 `update()`와 `render_reasoning()` 인터페이스를 통해 이 데이터에 접근한다.

OnAIR의 목적 자체도 전통적인 flight-software 개발 방식과 다르다. NASA는 OnAIR를 **Python 기반 AI algorithm support와 flexible plugin architecture를 이용한 rapid prototyping 환경**으로 정의한다. 따라서 본 연구에서 OnAIR 전체를 C/LLVM으로 재작성하는 것은 OnAIR의 장점을 없애는 접근이며 연구 목표로 적절하지 않다.

실제 NASA의 SCENIC flight experiment에서는 OnAIR와 cFS가 우주 환경에서 함께 실행되었다. 그러나 저자들은 100 MHz FPGA 기반 특수 ISA processor라는 제약 때문에 구현 가능한 알고리즘이 제한되었고, 결국 Kalman filter와 결과 기록 plugin 정도의 최소 실험을 구성했다고 보고했다. 또한 실제 작업에서 OnAIR plugin 작성보다 FPGA ISA와 SCENIC hardware 환경에 적응시키는 작업에 더 많은 시간이 소요됐다고 명시했다.

특히 SCENIC에서는 cFS Software Bus Network를 통해 40개 telemetry point가 포함된 packet을 0.25 Hz로 OnAIR에 전달했고, OnAIR는 cFS와 함께 4일간 오류 없이 동작했다. 즉 **cFS ↔ OnAIR integration의 실행 가능성은 이미 검증됐지만 복잡한 AI workload를 resource-constrained flight processor에서 predictable하게 운용하는 문제는 해결된 것으로 볼 수 없다.**

---

# 2. 선행연구와 정확한 Research Gap

본 연구가 성립하려면 단순히 “MLIR을 OnAIR에 넣어보겠다”가 아니라 기존 연구들이 해결하지 않은 교집합을 증명해야 한다.

| 연구 | 해결한 문제 | 본 연구와 남는 차이 |
|---|---|---|
| NASA OnAIR, Gizzi et al., 2025 | Python AI/cognitive architecture와 cFS를 포함한 다양한 환경의 통합 및 실제 배치 | AI plugin의 timing/resource contract를 다루지 않음 |
| NNEF, Polanco-Segovia et al., 2025 | PyTorch/TensorFlow NN을 cFS/F´에서 재사용 가능하게 실행 | 주 기여가 cross-platform NN deployment이며 cFS task와의 timing contract가 중심이 아님 |
| TinyIREE, Liu et al., 2022 | MLIR/LLVM 기반 ML workload의 embedded/bare-metal AOT deployment | cFS/OnAIR integration 및 flight-software timing constraint를 고려하지 않음 |
| Pearce et al., 2021 | NN을 static timing analysis에 적합한 단순 C로 변환하고 WCET 분석 가능성 입증 | OnAIR/cFS, heterogeneous MLIR compilation을 다루지 않음 |
| LaLaRAND, Kang et al., RTSS 2021 | CPU/GPU layer allocation을 통해 real-time DNN schedulability 향상 | cFS/OnAIR와 MLIR AOT compilation을 다루지 않음 |

NNEF의 명시적인 연구 목표는 framework에 종속되지 않는 NN inference와 cFS/F´ 등 flight-software platform 간 재사용성을 확보하는 것이다. 따라서 단순히 “PyTorch를 native code로 만들어 cFS에서 돌린다”는 연구는 NNEF와의 차별성이 약하다.

반면 Pearce et al.은 일반적인 neural-network framework 내부 구현이 static timing analysis에 부적합할 수 있다는 문제를 명시적으로 제기했으며, Keras NN을 제한된 C 코드로 변환하여 time-predictable processor에서 WCET를 도출하는 방법을 실증했다. 따라서 **dynamic ML runtime을 보다 정적인 representation으로 변환하는 것이 timing analyzability를 높일 수 있다는 근거는 이미 존재한다.**

또한 LaLaRAND는 heterogeneous CPU/GPU 환경에서 DNN layer의 resource allocation을 real-time requirement와 함께 결정함으로써 vanilla PyTorch 대비 schedulable task set을 크게 증가시킬 수 있음을 보였다. 이는 AI compilation/placement가 단순 throughput 문제뿐 아니라 schedulability 문제로 다뤄질 필요가 있음을 보여준다.

따라서 본 연구의 gap은 다음과 같이 정의한다.

> **기존 연구는 각각 OnAIR의 AI integration, NN deployment portability, MLIR 기반 embedded compilation, real-time NN analysis를 다루고 있지만, OnAIR AI plugin을 cFS 시스템의 timing/resource constraint를 명시적으로 고려하여 compile하고, 그 결과물의 실행 계약을 배포 과정에서 검증하는 체계는 확립되어 있지 않다.**

이 문장이 본 논문의 가장 중요한 research-gap statement가 된다.

---

# 3. 연구에서 말하는 “Timing Contract”의 정확한 정의

여기서 가장 조심해야 할 것은 **MLIR compilation과 WCET guarantee를 동일시하지 않는 것**이다.

본 연구에서는 우선 다음 contract를 정의한다.

\[
K_m =
\langle
T_m,\,
D_m,\,
C_m^{bound},\,
M_m^{bound},\,
I_m,\,
O_m,\,
H_m,\,
A_m
\rangle
\]

각 항목은 다음 의미를 갖는다.

| Symbol | 의미 |
|---|---|
| \(T_m\) | 해당 inference request의 최소/명목 arrival period |
| \(D_m\) | inference 결과가 완료되어야 하는 local deadline |
| \(C_m^{bound}\) | 지정 target에서 인정된 execution-time bound |
| \(M_m^{bound}\) | peak working-memory bound |
| \(I_m\) | input shape, dtype, ABI |
| \(O_m\) | output shape, dtype, ABI |
| \(H_m\) | model/compiler artifact identity(hash/version) |
| \(A_m\) | target architecture, compiler flags, runtime configuration |

여기에서 중요한 점은 \(T_m\)와 \(D_m\)은 compiler가 만들어내는 값이 아니라 **mission/system requirement가 제공하는 값**이라는 것이다.

반대로 MLIR compiler와 analysis infrastructure는 가능한 한 다음을 산출한다.

\[
I_m,\;O_m,\;M_m,\;A_m
\]

그리고 별도의 timing characterization 또는 WCET 분석 단계에서

\[
C_m^{bound}
\]

를 얻는다.

그 결과 compiler/deployment system은

\[
C_m^{bound} \leq D_m
\]

인지 검사할 수 있다.

다중 real-time task 환경에서는 더 나아가

\[
Sched(\tau_{cFS} \cup \tau_{AI}) = true
\]

인지 검사한다.

즉 논문의 주장은

> **“MLIR이 WCET를 계산한다.”**

가 아니다.

정확한 주장은

> **“MLIR을 이용해 AI inference의 동적 실행구조를 정적·분석 가능한 artifact로 변환하고, 외부 timing characterization 결과와 mission timing requirement를 동일한 deployment contract에 연결한다.”**

이다.

이 표현이 학술적으로 훨씬 안전하다.

---

# 4. 핵심 연구 질문(RQ)

### RQ1 — Compilation / Predictability

**MLIR/LLVM AOT compilation을 적용한 OnAIR Learner가 기존 Python ML runtime 대비 inference execution-time distribution을 더 좁히고 tail latency를 감소시키는가?**

여기서는 평균 성능보다 `p99`, `maximum observed latency`, `jitter`가 핵심이다.

### RQ2 — Contract-Aware Deployment

**AI model의 timing/resource contract를 compilation/deployment 단계에서 검사함으로써 deadline을 만족하지 못하는 모델 또는 lowering configuration을 실행 전에 식별할 수 있는가?**

이 질문이 단순 AI acceleration 연구와 본 연구를 구분한다.

### RQ3 — System-Level Schedulability

**AI inference의 contract를 cFS workload와 함께 고려해 lowering configuration을 선택할 경우, throughput-only 또는 default compiler optimization보다 시스템 수준 deadline miss를 줄일 수 있는가?**

이 질문이 성립해야 이 연구가 단순 “OnAIR + MLIR integration”을 넘어 real-time systems 연구가 된다.

### RQ4 — Portability

**동일 MLIR-level AI model을 서로 다른 ARM64/RISC-V target으로 lowering하면서 동일한 OnAIR plugin interface와 contract format을 유지할 수 있는가?**

이것은 주 contribution이라기보다 portability에 대한 보조 실험이다.

---

# 5. 연구가설

## H1 — Compiled Learner Predictability Hypothesis

> 동일 모델과 동일 입력을 사용했을 때 MLIR/LLVM AOT-compiled Learner는 Python framework 기반 Learner보다 inference latency의 tail과 variability가 감소하며 functional equivalence를 유지한다.

근거는 두 방향에서 나온다. OnAIR/SCENIC에서는 resource-constrained processor가 적용 가능한 algorithm을 실제로 제한했다. 한편 real-time NN 연구에서는 일반 ML framework의 복잡한 runtime이 static timing analysis에 부적합할 수 있다는 문제가 보고되었다.

**단, 감소 여부는 연구 결과가 아니라 검증할 가설이다.**

---

## H2 — Contract-Aware Configuration Hypothesis

> timing/resource contract를 만족하도록 선택된 MLIR lowering configuration은 default performance-oriented lowering보다 cFS+AI workload 환경에서 더 낮은 deadline-miss ratio를 보인다.

이 가설은 LaLaRAND에서 DNN resource allocation을 timing requirement와 결합했을 때 schedulability 개선이 관찰됐다는 결과에 근거한다. 다만 해당 결과를 OnAIR/MLIR에 직접 일반화하지 않고 본 연구에서 재검증한다.

---

## H3 — Contract Feasibility Hypothesis

> compiler-generated memory/interface information과 target-specific timing characterization을 결합하면, 주어진 deadline/resource budget을 만족하지 못하는 OnAIR AI deployment를 실제 runtime 이전에 유의미한 정확도로 판별할 수 있다.

여기서 중요한 평가 항목은 “빠른가”가 아니라

\[
Predicted\;Feasible
\quad vs.\quad
Observed\;Feasible
\]

의 일치율이다.

특히 **실제로 infeasible한 configuration을 feasible하다고 잘못 판정하는 false-safe 결과**가 가장 치명적인 error가 된다.

---

# 6. 제안 Architecture

전체 구조는 다음과 같다.

```text
                  NASA cFS
                     │
               Software Bus
                     │
                     SBN
                     │
                     ▼
            OnAIR Data Adapter
                     │
                     ▼
          Knowledge Representation
                     │
                     ▼
       ┌──────────────────────────┐
       │   Compiled Learner      │
       │                          │
       │ Python plugin wrapper    │
       │          │               │
       │     stable C ABI         │
       │          │               │
       │   MLIR/LLVM artifact     │
       │                          │
       │ timing contract.json     │
       └──────────┬───────────────┘
                  │
                  ▼
               Planner
                  │
                  ▼
           Complex Reasoner
```

핵심 설계 원칙은 **OnAIR를 없애지 않는다**는 것이다.

OnAIR에서 AI plugin은 현재 `AIPlugin`을 상속하고 `update()` 및 `render_reasoning()`을 구현한다. 실제 Kalman plugin 역시 이 구조로 구현되어 있으며, LearnersInterface는 plugin들을 순차적으로 호출할 뿐 plugin 내부 구현을 제한하지 않는다. 따라서 새로운 native compiled Learner를 추가해도 OnAIR core architecture를 크게 변경할 필요가 없다.

이 점은 실제 NASA upstream contribution을 고려할 때도 매우 중요하다.

---

# 7. OnAIR에서 실제 수정할 위치

## 7.1 신규 `CompiledLearner` plugin

가장 먼저 구현할 것은 별도 plugin이다.

예상 구조:

```text
plugins/
  compiled_learner/
    __init__.py
    compiled_learner_plugin.py
    runtime/
       model.so
       model.h
       contract.json
```

`compiled_learner_plugin.py`는 현재 Kalman plugin과 동일하게 `AIPlugin`을 상속한다.

개념적으로:

```python
class Plugin(AIPlugin):

    def __init__(...):
        load_contract()
        validate_target()
        load_native_artifact()

    def update(self, low_level_data, high_level_data):
        pack_input()

    def render_reasoning(self):
        output = native_inference(...)
        return convert_to_onair_reasoning(output)
```

OnAIR의 `LearnersInterface`는 현재 모든 learner에 대해

```text
plugin.update(...)
plugin.render_reasoning()
```

을 호출하므로 core pipeline을 변경하지 않고 compiled implementation을 삽입할 수 있다.

이 접근은 연구 범위를 적절히 제한하면서도 실제 OnAIR codebase에 기여 가능한 형태다.

---

# 8. MLIR Compilation Pipeline

초기 연구에서는 custom dialect부터 만들지 않는다.

먼저 기존 MLIR ecosystem을 최대한 활용해야 한다.

```text
PyTorch / exported model

        ↓

ML frontend

        ↓

StableHLO / TOSA / Linalg
        ↓
   MLIR transforms
        │
        ├─ shape specialization
        ├─ canonicalization
        ├─ fusion / tiling
        ├─ vectorization
        ├─ bufferization
        └─ static-memory policy

        ↓
       memref

        ↓
      LLVM IR

        ↓
 ARM64 / RISC-V object

        ↓
 static/shared native artifact
```

MLIR의 bufferization infrastructure는 tensor semantics를 실제 memory buffer를 나타내는 `memref`로 변환하며, One-Shot Bufferize는 SSA use-def 정보를 이용하여 copy 및 in-place buffer 사용을 분석한다. MLIR 문서도 bufferization의 주요 목표를 memory usage와 memory copy 최소화로 명시한다.

이는 본 연구에서 `M_bound`를 다루기 위한 중요한 기반이다.

---

# 9. 왜 IREE를 baseline/implementation substrate로 사용할 가치가 있는가

IREE는 MLIR을 기반으로 하고 LLVM CPU backend를 통해 embedded 및 bare-metal target에 ML workload를 배치할 수 있다. 공식 문서는 bare-metal platform에 대해 LLVM target backend를 사용하고, peak memory 최소화를 위한 compilation option과 static-library output도 제공한다.

TinyIREE 논문도 MLIR 기반 compiler/runtime stack이 제한된 memory/compute 환경과 bare-metal 환경으로 scale-down될 수 있음을 보여줬다.

따라서 본 연구에서 IREE를 사용하는 가장 적절한 방법은

> **“새로운 ML compiler를 전부 만드는 것”**

이 아니라

> **“기존 MLIR/IREE compiler stack에 timing-contract-aware analysis/selection layer를 추가하는 것”**

이다.

이렇게 해야 연구가 구현 가능한 범위에 남는다.

---

# 10. 본 논문의 진짜 Compiler Contribution

단순히

```text
model → MLIR → LLVM
```

만 하면 논문 contribution이 약하다.

반드시 MLIR compilation이 **contract에 영향을 받아야 한다.**

제안하는 compilation 문제는 다음과 같다.

모델 \(m\)에 대해 가능한 lowering configuration 집합을

\[
L_m = \{l_1,l_2,\dots,l_n\}
\]

이라고 하자.

각 lowering은

\[
C(l), M(l), E(l)
\]

를 갖는다.

여기서

\(C(l)\) = execution-time bound 또는 characterization,

\(M(l)\) = peak memory,

\(E(l)\) = 기타 cost/energy information이다.

compiler는 다음 조건을 만족하는 lowering을 찾는다.

\[
C(l) \le D_m
\]

\[
M(l) \le M_{budget}
\]

\[
Sched(\tau_{cFS}\cup\tau_{AI}(l)) = true
\]

가능한 lowering이 여러 개라면

\[
\min_l
\alpha C(l)+\beta M(l)
\]

같은 목적함수를 사용할 수 있다.

중요한 점은 **fastest configuration이 반드시 선택되는 것이 아니라는 것**이다.

---

# 11. Timing-aware lowering에서 실제 변경할 변수

처음부터 복잡한 neural architecture search를 할 필요는 없다.

초기 연구에서는 MLIR/IREE에서 명확하게 제어 가능한 compilation 변수만 대상으로 한다.

| 변수 | Timing에 미치는 영향 | Memory에 미치는 영향 |
|---|---:|---:|
| single-thread / multi-thread | 매우 큼 | 중간 |
| synchronous execution | predictability 증가 가능 | 낮음 |
| vector width | 큼 | 낮음 |
| tile size | 큼 | 중간 |
| operation fusion | 중~큼 | memory traffic 감소 가능 |
| buffer reuse | 간접 | 매우 큼 |
| static/dynamic allocation | timing variability에 영향 가능 | 큼 |
| quantization | 큼 | 큼 |
| CPU target features | 큼 | 낮음 |

IREE 공식 deployment documentation도 embedded platform에서 single-thread 또는 minimal runtime configuration을 구성할 수 있고, `min-peak-memory`를 우선하는 partitioning을 지원한다.

따라서 논문의 최초 version에서는

**execution determinism profile**

과

**throughput profile**

을 분리하는 것이 좋다.

예를 들어:

```text
PROFILE_FAST
    multithread
    aggressive vectorization
    throughput priority

PROFILE_PREDICTABLE
    single thread
    CPU affinity
    static buffers
    synchronous execution

PROFILE_MEMORY
    min-peak-memory
    reduced scratch memory
```

그리고 contract에 따라 profile을 선택한다.

이것만으로도 명확한 실험이 가능하다.

---

# 12. Contract File Prototype

초기에는 custom MLIR dialect보다 external manifest가 좋다.

예:

```text
model:
  name: telemetry_anomaly_cnn
  sha256: ...
  compiler: llvm-mlir-...
  model_version: 1

interface:
  input:
    shape: [1, 32]
    dtype: f32
  output:
    shape: [1, 2]
    dtype: f32

target:
  triple: aarch64-linux-gnu
  cpu: cortex-a72
  execution_mode: local-sync

resources:
  peak_memory_bytes: ...
  binary_size_bytes: ...

timing:
  period_us: 100000
  deadline_us: 50000
  execution_bound_us: ...
  bound_method: measured | static_wcet | other

analysis:
  schedulable: true

artifact:
  file: model.so
```

특히

```text
bound_method
```

를 반드시 넣는다.

`measured maximum`과 `static WCET`를 같은 것으로 취급하지 않기 위해서다.

---

# 13. MLIR Custom Attribute/Dialect는 2단계

연구 초기에 다음을 바로 만들 필요는 없다.

```text
onair.deadline
onair.period
onair.memory_budget
```

대신 contract-aware lowering이 실제로 동작한다는 것을 검증한 뒤 다음과 같이 확장할 수 있다.

```text
module attributes {
  onair.contract = {
      period = 100000 : i64,
      deadline = 50000 : i64,
      memory_budget = 2097152 : i64
  }
}
```

최종적으로는

```text
#onair.timing_contract<
  period = 100ms,
  deadline = 50ms,
  memory = 2MB
>
```

같은 MLIR attribute/dialect로 발전시킬 수 있다.

그러나 **dialect 제작 자체가 논문의 목적이 되어서는 안 된다.**

dialect는 timing constraint가 실제 compiler transformation에 사용될 때만 의미가 있다.

---

# 14. System-Level Timing Model

OnAIR plugin 하나만 benchmark하면 본 연구는 단순 ML compiler 연구가 된다.

반드시 cFS workload와 함께 실행해야 한다.

시스템을 다음 sporadic/periodic task set으로 모델링한다.

\[
\tau =
\{\tau_1,\tau_2,\dots,\tau_n,\tau_{AI}\}
\]

각 task는

\[
\tau_i=(C_i,T_i,D_i,P_i)
\]

로 표현한다.

\(C_i\) = execution requirement,

\(T_i\) = period,

\(D_i\) = deadline,

\(P_i\) = priority.

AI inference는

\[
\tau_{AI} =
(C_{AI},T_{AI},D_{AI},P_{AI})
\]

가 된다.

고정 우선순위 single-core 실험이라면 classical response-time analysis를 사용할 수 있다.

\[
R_i =
C_i +
\sum_{j\in hp(i)}
\left\lceil
\frac{R_i}{T_j}
\right\rceil C_j
\]

그리고

\[
R_i \le D_i
\]

이면 해당 task가 schedulable한 것으로 판단한다.

이 수식 자체는 새로운 연구 기여가 아니다.

새로운 부분은

> **MLIR lowering에 따라 변화하는 \(C_{AI}(l)\)를 cFS system schedulability equation에 넣고 compiler configuration 선택으로 feedback하는 것**

이다.

즉

```text
MLIR lowering candidate
        ↓
C_AI(l)
M_AI(l)
        ↓
cFS schedulability test
        ↓
PASS / FAIL
        ↓
next lowering candidate
```

구조가 핵심이다.

---

# 15. cFS와의 연결

cFS는 OS와 hardware를 분리하는 platform-independent embedded framework이며 Linux, VxWorks, RTEMS 등을 지원한다. cFS Software Bus Network는 다른 process, processor, partition의 Software Bus를 연결하기 위한 publish/subscribe bridge 역할을 한다.

OnAIR는 바로 이 SBN을 이용하여 cFS telemetry를 받고 있으므로 본 연구가 cFS core를 직접 수정할 필요는 없다.

```text
cFS applications
       │
       SB
       │
       SBN
       │
       ▼
     OnAIR
       │
Compiled Learner
```

이 구조를 그대로 유지한다.

NASA의 현재 OnAIR flight experiment 역시 이 방식이었다.

---

# 16. 중요한 실험 원칙: sch_lab을 실시간성의 증거로 사용하지 않는다

현재 cFS bundle의 `sch_lab`은 NASA가 명시적으로 **non-flight scheduler**라고 설명하며, 기본적으로 1초 resolution의 간단한 packet scheduler이다. 따라서 본 논문의 high-resolution timing 결과를 `sch_lab` 자체에 의존시키는 것은 부적절하다.

functional integration에는 cFS/NOS3 등을 사용할 수 있지만, timing evidence를 얻으려면 별도 real-time execution setup이 필요하다.

권장 구조는:

```text
Stage 1
Linux + CPU affinity
functional validation

Stage 2
Linux PREEMPT_RT
controlled timing experiment

Stage 3
RTEMS or equivalent RT target
stronger real-time validation
```

이다.

NASA cFS 자체가 Linux, RTEMS, VxWorks를 지원하므로 이 연구 확장은 자연스럽다.

---

# 17. Baseline 설계

최소 세 가지 implementation을 반드시 비교해야 한다.

| ID | Implementation | 목적 |
|---|---|---|
| B0 | OnAIR + Python/PyTorch Learner | 현재 방식에 가까운 baseline |
| B1 | OnAIR + default MLIR/IREE AOT Learner | 단순 AOT compilation 효과 |
| P | OnAIR + Timing-Contract-Aware MLIR Learner | 제안 방법 |

B0와 P만 비교하면

> “그냥 PyTorch가 느려서 그런 것 아닌가?”

라는 비판을 받는다.

따라서 **B1이 반드시 필요하다.**

B1과 P의 차이가 바로 본 연구의 compiler contribution이다.

---

# 18. AI Workload 선택

초기 논문에서는 AI model accuracy 연구를 하지 않는다.

추천 workload는 두 종류다.

### Workload A — Telemetry Anomaly Detection

입력:

\[
x_t \in \mathbb{R}^{N}
\]

모델:

small MLP / 1D-CNN / small autoencoder

장점은 OnAIR의 telemetry 기반 architecture와 자연스럽고 execution time이 비교적 작아 반복 실험을 대량 수행할 수 있다는 것이다.

### Workload B — Image CNN

작은 CNN을 이용해 compute-intensive workload를 만든다.

OnAIR 논문에서도 2025년 예정 satellite experiment에 CNN/TNN 기반 star-tracker anomaly classification을 명시하고 있으므로 CNN workload 자체는 OnAIR의 실제 응용 방향과 부합한다.

단, 해당 mission의 proprietary/미공개 dataset이나 deadline을 임의로 가정해서는 안 된다.

따라서 논문에서는

> “representative OnAIR-compatible workload”

라고 부르고 실제 mission requirement라고 주장하지 않는다.

---

# 19. Hardware

최소 연구 범위:

| Level | Target |
|---|---|
| Development | x86-64 Linux |
| Main experiment | ARM64 SBC |
| Portability experiment | RISC-V optional |

ARM64는 초기 실험에 적절하다.

IREE는 LLVM CPU backend를 통해 x86, ARM/AArch64, RISC-V target deployment를 지원하며 bare-metal static library도 생성할 수 있다.

두 architecture까지 실험하면 H4 portability를 검증할 수 있다.

하지만 **논문의 1차 목표는 architecture portability가 아니다.**

ARM64 한 플랫폼에서 timing methodology가 완성된 뒤 RISC-V를 추가하는 것이 맞다.

---

# 20. 실험 변수

## 독립변수

가장 중요한 independent variables는 다음이다.

| 변수 | 수준 예 |
|---|---|
| execution implementation | Python / AOT default / contract-aware |
| system CPU load | low / medium / high |
| AI period | 느림 → 빠름 |
| deadline tightness | loose → tight |
| model size | small / medium |
| compiler profile | fast / predictable / memory |

---

# 21. 측정 Metric

평균 inference latency만 보고서는 안 된다.

### Plugin-level

\[
C_{median}, C_{95}, C_{99}, C_{99.9}, C_{max}
\]

그리고

\[
Jitter = C_{99}-C_{median}
\]

또는 standard deviation/CV를 기록한다.

### System-level

가장 중요한 metric은

\[
Deadline\ Miss\ Ratio
=
\frac{N_{miss}}
{N_{jobs}}
\]

이다.

추가로 기존 cFS task의 response time 변화도 측정한다.

\[
\Delta R_{cFS}
=
R_{cFS+AI}-R_{cFS-only}
\]

즉 **AI가 빨라지는지뿐 아니라 기존 flight workload에 얼마나 간섭하는지**를 본다.

### Resource

peak RSS, allocator activity, stack/scratch requirement, binary size, CPU utilization, context switches, optionally cache miss/cycles 등을 측정한다.

---

# 22. Functional Equivalence

compiler 연구에서는 반드시 기능 보존을 확인해야 한다.

FP32:

\[
|y_{python}-y_{compiled}| < \epsilon
\]

quantization을 적용한다면 inference accuracy 변화도 별도로 기록한다.

중요한 것은 timing improvement를 얻기 위해 model semantics가 변했다면 그 tradeoff를 숨기지 않는 것이다.

---

# 23. 실험 Matrix 예시

| Experiment | 질문 |
|---|---|
| E1 Python vs AOT | AOT 자체가 latency/jitter를 개선하는가? |
| E2 Default AOT vs Contract AOT | timing-aware lowering 자체의 효과가 있는가? |
| E3 Isolated vs cFS load | cFS interference 상황에서도 효과가 유지되는가? |
| E4 Deadline sweep | 어느 tightness에서 deadline miss 차이가 나타나는가? |
| E5 CPU load sweep | system utilization이 증가할 때 robustness는 어떠한가? |
| E6 Memory-budget sweep | low-memory profile이 contract를 만족시키는가? |
| E7 ARM vs RISC-V | contract abstraction이 target 간 유지되는가? |
| E8 Model replacement | 새로운 모델이 contract를 위반할 경우 사전에 reject할 수 있는가? |

E8은 논문 extension으로 돌려도 된다.

---

# 24. Timing Characterization 방법

이 부분이 연구에서 가장 민감하다.

최초 논문에서는 세 레벨을 구분해서 보고한다.

### Level A — Measurement

많은 반복 실행에서

\[
C_{max}^{obs}
\]

를 구한다.

이는 **observed maximum이지 WCET가 아니다.**

### Level B — Conservative Deployment Bound

측정값에 사전에 정의된 methodology를 적용하여 deployment characterization을 생성할 수 있다.

그러나 이것 역시 “formal WCET”라고 표현하지 않는다.

### Level C — Static WCET

지원되는 hardware와 WCET analyzer를 사용할 수 있다면 compiled binary에 별도 static analysis를 적용한다.

그때에만

\[
C^{WCET}
\]

라는 용어를 사용한다.

Pearce et al.의 연구도 NN을 분석 가능한 C representation으로 만든 뒤 time-predictable platform과 static timing analysis를 결합했다는 점이 중요하다.

따라서 이 논문은 **WCET analyzer 자체를 새로 만드는 논문이 아니다.**

---

# 25. Compiler Analysis-in-the-Loop

가장 강한 architecture는 다음 형태다.

```text
                 Model
                   │
                   ▼
               MLIR IR
                   │
              candidate l1
                   │
                   ▼
                LLVM
                   │
             timing analysis
                   │
            C_bound(l1)
                   │
        ┌──────────┴───────────┐
        │                      │
 C <= deadline?        M <= budget?
        │                      │
        └──────────┬───────────┘
                   │
             schedulable?
              /          \
           yes            no
            │              │
          emit        candidate l2
            │
       contract.json
```

즉 compiler와 timing analyzer를 분리하되 **compilation loop 안에 timing result를 feedback**한다.

이 구조가 논문의 가장 강한 기술적 contribution 후보다.

---

# 26. 예상되는 논문 Contribution

최종 논문에서는 contribution을 네 가지로 주장할 수 있다.

**C1. OnAIR용 timing-contract model.** OnAIR AI plugin에 period, deadline, timing bound, memory bound, model/target identity를 결합한 deployable contract를 정의한다.

**C2. MLIR-based compiled Learner.** 기존 OnAIR plugin API를 보존하면서 Python orchestration과 native ML inference를 분리하는 reusable compiled Learner backend를 구현한다.

**C3. Contract-aware lowering/selection.** MLIR lowering configuration을 단순 throughput이 아니라 deadline·memory·system schedulability constraint를 만족하도록 선택한다.

**C4. cFS-integrated empirical evaluation.** Python baseline, 일반 MLIR AOT baseline, proposed contract-aware compiler를 실제 cFS+OnAIR workload에서 비교한다.

이 네 가지 중 **C3가 반드시 살아 있어야 compiler 논문으로 강해진다.**

---

# 27. 연구가 실패할 수 있는 조건도 미리 정의해야 한다

이 주제를 살리기 위해 결과를 억지로 긍정적으로 해석해서는 안 된다.

### H1 기각 조건

Compiled Learner가 Python runtime보다 평균 속도는 개선하지만 tail latency/jitter가 유의하게 개선되지 않는다면:

> AOT compilation improves performance but not timing predictability.

라고 결론내야 한다.

### H2 기각 조건

contract-aware lowering이 default AOT 대비 deadline miss나 schedulability에서 차이를 만들지 못한다면:

> compiler-level timing awareness provides no measurable system-level benefit under the tested workload.

가 된다.

### H3 기각 조건

사전 contract prediction과 실제 실행 결과가 자주 불일치한다면 contract model 자체가 불충분한 것이다.

특히

```text
Predicted = schedulable
Observed  = deadline miss
```

는 가장 심각한 failure다.

이 경우 interference model, cache/memory behavior 또는 OS scheduling을 contract에 추가해야 한다.

---

# 28. 연구에서 하지 말아야 할 주장

다음 문구는 사용하지 않는다.

> “MLIR guarantees real-time execution.”

틀린 주장이다.

> “LLVM provides WCET.”

틀린 주장이다.

> “OnAIR currently cannot support real-time AI.”

공개 자료만으로 증명되지 않았다.

> “Python is unsuitable for space systems.”

OnAIR 자체가 실제 우주에서 4일간 cFS와 정상 동작했으므로 과도한 주장이다.

대신 다음처럼 써야 한다.

> “OnAIR prioritizes rapid AI integration and has demonstrated successful flight operation; however, its current public architecture does not expose explicit timing/resource contracts for AI plugins.”

이 표현이 훨씬 객관적이다.

---

# 29. 최소 구현 MVP

논문 가능성을 가장 빨리 판단하려면 다음까지만 먼저 구현한다.

```text
OnAIR
  │
  ├─ Python MLP Learner
  │
  └─ MLIR/AOT MLP Learner
           │
       contract.json
```

Target은 ARM64 하나.

cFS에서 주기적 telemetry를 SBN으로 보낸다.

비교:

```text
Python
vs
default MLIR AOT
vs
predictable MLIR profile
```

측정:

```text
median
p99
max
jitter
memory
deadline miss
```

이 결과에서 의미 있는 tail/deadline 차이가 나오지 않는다면 복잡한 custom dialect 개발을 시작하지 않는다.

이것이 가장 중요한 초기 go/no-go experiment다.

---

# 30. Phase 2에서 본격적인 Compiler 연구

MVP에서 가능성이 확인되면 그다음에 다음과 같이 확장한다.

1. MLIR module에 timing/resource metadata를 부여한다.
2. 여러 lowering candidate를 생성한다.
3. target profiling/analysis를 수행한다.
4. cFS task model과 schedulability analysis를 수행한다.
5. constraint를 만족하는 lowering을 자동 선택한다.
6. native artifact와 `contract.json`을 동시에 출력한다.

최종 compiler interface는 개념적으로 다음과 같다.

```text
onair-compile model.mlir \
   --target=aarch64 \
   --period=100ms \
   --deadline=40ms \
   --memory-budget=4MB \
   --cfs-taskset=taskset.json
```

출력:

```text
model.o
model.h
contract.json
analysis_report.json
```

이 수준까지 가면 꽤 분명한 compiler artifact가 된다.

---

# 31. 예상 논문의 Figure 1

논문의 핵심 그림은 다음 구조가 좋다.

```text
                       Mission Contract
                    period / deadline / RAM
                              │
                              ▼
AI Model ────────► MLIR Timing-Aware Compiler
                              │
                       ┌──────┴──────┐
                       │             │
                  LLVM Artifact   Contract
                       │             │
                       └──────┬──────┘
                              │
                              ▼
                        OnAIR Learner
                              │
                        NASA cFS / SBN
```

한 장만 봐도

> “AI compiler + OnAIR + real-time constraint”

라는 논문의 정체성이 보인다.

---

# 32. 논문의 Research Claim

논문 최종 claim은 처음부터 다음 정도로 제한하는 것이 좋다.

> **We do not claim that MLIR itself guarantees worst-case execution time. Instead, we use MLIR to transform dynamic AI workloads into target-specific compiled artifacts whose timing and memory characteristics can be explicitly characterized and checked against deployment contracts before integration with OnAIR/cFS.**

이 문장이 상당히 중요하다.

---

# 33. 학술적 가치 평가

현재 판단으로는 연구가치는 다음 정도다.

| 평가항목 | 판단 |
|---|---:|
| 문제 타당성 | 매우 높음 |
| OnAIR와의 직접 연관성 | 매우 높음 |
| MLIR 사용 필연성 | 중상~높음 |
| 단순 engineering 위험 | 중간 |
| compiler contribution 잠재력 | 높음 |
| real-time systems contribution | 높음 |
| 구현 난도 | 높음 |
| 연구 실패 가능성 | 중간 |
| 성공 시 novelty | 높음 |

가장 큰 위험은 **MLIR을 단순 deployment tool로 사용하고 끝나는 것**이다.

그 경우 novelty는 낮아진다.

반대로

\[
Mission\ Timing\ Constraint
\rightarrow
MLIR\ Lowering
\rightarrow
C_{AI}
\rightarrow
cFS\ Schedulability
\rightarrow
Lowering\ Selection
\]

이라는 feedback loop까지 구현하면 상당히 명확한 연구 contribution이 된다.

---

# 34. 예상 투고 방향

결과가 **compiler optimization + formal/strong schedulability analysis**까지 간다면 RTSS, RTAS, ECRTS, EMSOFT 계열 문제의식과 잘 맞는다.

반대로 NASA OnAIR/cFS implementation과 flight-software integration 실증이 중심이라면 IEEE Aerospace Conference나 IEEE Aerospace and Electronic Systems 계열이 보다 현실적이다.

처음부터 venue에 맞춰 억지로 설계하기보다 **MVP 결과가 timing theory 쪽으로 강한지, aerospace integration 쪽으로 강한지​**를 본 뒤 결정하는 것이 낫다.

---

# 35. 현재 시점의 연구 Thesis

현재 가장 방어력이 높은 thesis statement는 다음과 같다.

> **NASA OnAIR provides a flexible Python-based architecture for rapid integration of onboard AI with cFS, but its public plugin model does not explicitly represent the timing and resource requirements of deployed AI workloads. This research investigates whether MLIR-based ahead-of-time compilation can transform OnAIR Learner plugins into analyzable native components and whether incorporating mission timing and resource constraints into the compilation process can improve deployment feasibility and system-level schedulability in cFS-based environments.**

핵심은 `investigates whether`다.

결과를 미리 가정하지 않는다.

---

# 36. 최종 판단

이 연구를 **“OnAIR 가속”으로 잡으면 약하다.**

**“AI 모델을 cFS에서 실행”으로 잡아도 약하다.**

**“MLIR을 우주 SW에 적용”이라고 해도 너무 추상적이다.**

반면 다음 질문으로 고정하면 충분히 연구할 가치가 있다.

> **OnAIR가 제공하는 AI 연구의 유연성을 유지하면서, AI Learner를 cFS 시스템의 시간·메모리 제약을 만족하는 분석 가능한 deployment artifact로 어떻게 변환할 것인가?**

이 문제는 OnAIR의 실제 SCENIC deployment에서 확인된 constrained-compute/hardware-integration 문제, real-time neural inference의 timing-analyzability 연구, MLIR/IREE의 embedded AOT compilation 능력을 연결해서 도출된 것이다.

따라서 현 단계에서의 우선순위는 **custom MLIR dialect 개발이 아니라 `CompiledLearner` MVP를 만들고 B0/B1/P의 timing distribution을 실제 cFS workload에서 측정하는 것**이다.

그 실험에서 H1의 가능성이 확인되면 그다음 단계에서 `TimingContract`와 schedulability-aware lowering을 compiler contribution으로 확장한다.

이 순서가 이 연구를 “흥미로운 아이디어”에서 “반증 가능한 시스템/컴파일러 연구”로 만드는 가장 중요한 조건이다.