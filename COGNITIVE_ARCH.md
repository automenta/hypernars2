# A Layered Cognitive Architecture for HyperNARS

The cognitive architecture of HyperNARS is designed for modularity, extensibility, and cognitive dexterity. It organizes the system's higher-level capabilities into a three-tiered hierarchy that aligns with the dual-process reasoning model described in `REASONING.md`.

This layered approach moves beyond a flat "bag of managers" to a more structured and implementable model. Each "Cognitive Function" described below is not a separate, monolithic software module, but rather a **collection of MeTTa atoms** (rules and goals) that implement a specific capability. This adheres to the "everything is an atom" principle, ensuring the entire cognitive apparatus is inspectable, modifiable, and part of the same unified reasoning process.

## The Three Layers of Cognition

The architecture is divided into three layers, which roughly correspond to different levels of abstraction and control:

1.  **Layer 1: Core Cognitive Functions (System 1 Dominant):** This layer forms the "engine room" of the mind. These are the fundamental, continuously-operating functions that drive the reflexive, System 1 reasoning loop. They handle the moment-to-moment processing of goals, temporal information, and learning.

2.  **Layer 2: Executive Control & Awareness (System 2 Initiation):** This layer acts as the "foreman," monitoring the core functions and initiating deeper, more deliberate thought. It is responsible for self-monitoring, managing contradictions, and explaining the system's reasoning to the outside world. It serves as the bridge between reflexive and deliberative reasoning.

3.  **Layer 3: Specialized Metacognition (System 2 Dominant):** This layer is the "strategist," handling the most abstract, goal-driven, and resource-intensive cognitive tasks. These functions are typically invoked by the Executive Control layer during System 2 deliberation to handle complex challenges like ethical reasoning, self-improvement, and deep system validation.

---

## Layer 1: Core Cognitive Functions

These functions are the workhorses of the reflexive reasoning loop (System 1).

### 1.1 Goal & Planning Function
Responsible for goal-oriented behavior, including planning, execution monitoring, and skill acquisition.
-   **Core Capability**: Implements a backward-chaining planner. When a `(Goal G)` is received, it queries memory for beliefs of the form `(Op ==> G)`. If `Op` has preconditions `P`, it injects a new subgoal `(Goal P)`.
-   **Skill Acquisition**: Learns new procedural rules by observing the consequences of its operations, forming new beliefs of the form `(Op ==> Effect)`.
-   *Injects*: New sub-goals, operation execution tasks.

### 1.2 Temporal Reasoning Function
Provides a framework for understanding and reasoning about time.
-   **Core Capability**: Maintains a graph of temporal relationships (e.g., Allen's Interval Algebra) and generates predictions based on learned temporal patterns of the form `(A </> B)` (A is followed by B).
-   *Injects*: Inferred temporal relationships and predictive tasks.

### 1.3 Inductive & Conceptual Learning Function
Responsible for abstracting knowledge, forming new concepts, and learning new rules through induction.
-   **Core Capability**: Detects patterns and correlations in memory to form higher-level abstractions or new inference rules.
-   *Injects*: Tasks representing new concepts or learned inductive rules.

---

## Layer 2: Executive Control & Awareness

These functions monitor the system's performance and initiate deliberative (System 2) reasoning when necessary.

### 2.1 Cognitive Executive
The system's master control program, responsible for self-monitoring, strategic control, and adaptation. It is the core of System 2 initiation.
-   **Core Function**: Runs a continuous "sense-analyze-act" loop on the system's own performance.
    1.  **Sense**: Gathers KPI beliefs from Memory (see table below).
    2.  **Analyze**: Compares KPIs against thresholds to identify issues (e.g., `contradictionRate > 0.1`) or opportunities (e.g., `system-idle-time > 10s`).
    3.  **Act**: Injects high-level goals to trigger deliberative reasoning by Layer 3 functions, e.g., `(Achieve (reduce-contradictions))` or `(Goal (optimize-rule 'AbductionRule'))`.
-   *Injects*: High-level control tasks for other functions to handle.

### 2.2 Contradiction Management Function
Implements strategies for resolving contradictions detected by the kernel. This is a classic example of a deliberative process triggered by the Executive.
-   **Trigger**: A `(Goal (reduce-contradictions))` from the `Cognitive Executive`.
-   **Core Capability**: Analyzes the conflicting beliefs and their derivations to select a resolution strategy (e.g., reducing confidence, specializing a rule).
-   *Injects*: Tasks that revise or remove beliefs to resolve the detected contradiction.

### 2.3 Explanation Function
Generates human-readable explanations for the system's conclusions, providing transparency into both System 1 and System 2 reasoning chains.
-   **Trigger**: An external or internal `(Goal (explain <belief>))`.
-   **Core Capability**: Traverses the derivation history of the given `belief` via its `parent_premises` metadata. It constructs a graph of the reasoning chain and formats it for output.

---

## Layer 3: Specialized Metacognition

These advanced functions perform highly abstract, resource-intensive reasoning as part of a System 2 deliberative process. They are typically activated by a `Goal` from the `Cognitive Executive`.

### 3.1 Conscience Function
Responsible for enforcing ethical constraints and safety protocols. It acts as a high-priority filter on the system's intentions.
-   **Trigger**: `goal-generated`, `task-selected`.
-   **Core Capability**: Evaluates potential actions and goals against a set of inviolable ethical rules represented as MeTTa atoms, e.g., `(Constraint (Forbid (Goal (cause-harm-to-human))))`.
-   *Injects*: High-priority tasks to veto or modify unethical goals.

### 3.2 Self-Modification & Improvement Functions
This is a suite of related functions dedicated to analyzing and improving the system's own knowledge and codebase. They are the primary actors in long-term adaptation.

-   **Self-Optimization Function**: Improves the system's operational efficiency by analyzing and refactoring its own reasoning rules.
    -   **Trigger**: `(Goal (optimize-rule $X))`.
    -   **Action**: Analyzes `rule_cost` and `rule_utility` KPIs, then attempts to rewrite the rule to be more efficient.

-   **Test Generation Function**: Proactively generates tests to verify the system's reasoning and the correctness of proposed self-modifications.
    -   **Trigger**: `(Goal (analyze-rule $X))`, `(Goal (test-concept $Y))`.
    -   **Action**: Generates novel combinations of premises to trigger a specific rule or explore a concept, then monitors the outcome.

-   **Codebase Integrity Function**: Reasons about the system's own design documents and source code to find inconsistencies.
    -   **Trigger**: `(Goal (validate self.design))`.
    -   **Action**: Uses grounded functions to parse design documents and source code, creating atoms that represent the specified and implemented architecture, then looks for inconsistencies.

-   **Implementation Assistance Function**: Assists human developers by automating parts of the implementation process.
    -   **Trigger**: `(Goal (Implement (feature $F)))`.
    -   **Action**: Reads a specification and generates boilerplate MeTTa code and corresponding test stubs.

---

## Inter-Function Communication

Cognitive functions collaborate indirectly through Memory, adhering to the "everything is an atom" principle. This creates a loosely coupled, highly flexible architecture where control flows between layers.

1.  **System 1 Loop (Intra-Layer 1):** In the default reflexive state, the Layer 1 functions continuously interact by injecting tasks and beliefs for each other to process.

2.  **Escalation to System 2 (Layer 1 to 2):** The `Cognitive Executive` (Layer 2) constantly monitors the output and KPIs of the Layer 1 functions. When it detects an anomaly (like a contradiction) or a major opportunity, it initiates System 2 deliberation.

3.  **Delegation (Layer 2 to 3):** The Executive initiates deliberation by injecting a high-level `Goal` into Memory. This goal is specifically crafted to trigger one of the specialized Layer 3 functions. For example, `(Goal (reduce-contradictions))` activates the `Contradiction Management Function`, while `(Goal (optimize-rule ...))` activates the `Self-Optimization Function`.

4.  **Resolution (Layer 3 to 1):** After completing its resource-intensive analysis, the Layer 3 function injects its conclusions (e.g., a revised belief, a new rule) back into Memory, where they are picked up by the Layer 1 functions, thus completing the full cognitive loop.

This structured, layered model of communication provides a clear and elegant framework for complex cognitive control.

## Key Performance Indicators (KPIs) for Self-Monitoring
The `Cognitive Executive` relies on a comprehensive set of KPIs to monitor the system's health.
| KPI Name | Description | Source Document |
| :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all beliefs in Memory. | `DATA_STRUCTURES.md` |
| `avg_task_priority` | The average priority of all tasks in the system. | `DATA_STRUCTURES.md` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. | `DATA_STRUCTURES.md` |
| `memory_utilization`| The percentage of total memory capacity currently being used. | `MEMORY.md` |
| `concept_hit_rate` | The percentage of times a selected `Concept` contains a useful `Belief` for the current `Task`. | `MEMORY.md` |
| `forgetting_rate` | The number of items being forgotten per second. | `MEMORY.md` |
| `rule_utility` | The average `quality` of the conclusions produced by a specific inference rule. | `REASONING.md` |
| `rule_cost` | The average execution time for a specific inference rule. | `REASONING.md` |
| `goal_success_rate` | The percentage of goals that are successfully achieved. | `COGNITIVE_ARCH.md` |
| `contradiction_rate` | The percentage of new beliefs that cause contradictions. | `COGNITIVE_ARCH.md` |
