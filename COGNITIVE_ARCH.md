# A Layered Cognitive Architecture

The cognitive architecture of HyperNARS is a three-tiered hierarchy designed for modularity, cognitive dexterity, and to align with the dual-process reasoning model described in `REASONING.md`.

Each "Cognitive Function" is not a separate software module, but a **collection of MeTTa atoms** (rules and goals) that implement a specific capability. This "everything is an atom" approach ensures the entire cognitive apparatus is inspectable, modifiable, and part of the same unified reasoning process.

## The Three Layers of Cognition

1.  **Layer 1: Core Cognitive Functions (System 1 Dominant):** The "engine room" of the mind. These fundamental, continuously-operating functions drive the reflexive, System 1 reasoning loop.
2.  **Layer 2: Executive Control & Awareness (System 2 Initiation):** The "foreman," monitoring the core functions and initiating deeper, more deliberate thought (System 2).
3.  **Layer 3: Specialized Metacognition (System 2 Dominant):** The "strategist," handling the most abstract, goal-driven, and resource-intensive cognitive tasks, such as ethical reasoning and self-improvement.

---

## Inter-Function Communication
Cognitive functions collaborate indirectly by reading and writing atoms to the shared **MeTTa Memory space**. This creates a loosely coupled, highly flexible architecture. The general flow is:
1.  **System 1 Loop (Intra-Layer 1):** Layer 1 functions continuously interact by injecting tasks and beliefs for each other.
2.  **Escalation (Layer 1 to 2):** The `Cognitive Executive` (Layer 2) monitors KPIs and events from Layer 1. An anomaly (e.g., a high contradiction rate) triggers System 2.
3.  **Delegation (Layer 2 to 3):** The `Cognitive Executive` injects a high-level `Goal` (e.g., `(Goal (resolve-contradictions))` to activate a specialized Layer 3 function.
4.  **Resolution (Layer 3 to 1):** The Layer 3 function performs its analysis and injects its conclusions (e.g., a revised belief) back into Memory for the Layer 1 functions to process, completing the loop.

---

## Layer 1: Core Cognitive Functions (System 1)

### 1.1 Goal & Planning Function
Responsible for goal-oriented behavior, planning, and skill acquisition.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Goal <desired-state>)` |
| **Reads** | Beliefs of the form `(<operation> ==> <desired-state>)` |
| **Writes** | `(Goal <precondition>)` (sub-goals), `(Task (execute <operation>))` |

-   **Core Capability**: Implements a backward-chaining planner. When a `(Goal G)` is processed, it queries memory for procedural beliefs of the form `(Op ==> G)`. If found, it injects a new sub-goal `(Goal P)` for the operation's preconditions.
-   **Example Implementation**:
    ```metta
    ;; Rule for backward chaining
    (= (handle (Goal $g))
       (match &self
              (<($op ==> $g)> %true)
              (match &self
                     (<(has-precondition $op $p)> %true)
                     (Goal $p)
                     (Task (execute $op)))))
    ```

### 1.2 Temporal Reasoning Function
Provides a framework for understanding and reasoning about time.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Belief <(A </> B)>)` (A is followed by B) |
| **Reads** | Beliefs about temporal sequences, e.g., `(<(B </> C)>)` |
| **Writes** | New inferred temporal beliefs, e.g., `(Belief <(A </> C)>)` |

### 1.3 Inductive & Conceptual Learning Function
Responsible for abstracting knowledge and forming new concepts.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | Co-occurring beliefs, e.g., `(Belief <A --> B>)` and `(Belief <A --> C>)` |
| **Reads** | Patterns of beliefs in memory |
| **Writes** | New, higher-level beliefs, e.g., `(Belief <C --> B>)` (Induction) |

---

## Layer 2: Executive Control & Awareness (System 2 Initiation)

### 2.1 Cognitive Executive
The system's master control program, responsible for self-monitoring and initiating deliberation.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event system-cycle-complete ...)` |
| **Reads** | `(has-value (metric $name) $value)` atoms (KPIs) |
| **Writes** | High-level `Goal` atoms for Layer 3 functions |

-   **Core Function**: Runs a continuous "sense-analyze-act" loop on the system's own performance KPIs (defined in `DATA_STRUCTURES.md`).
-   **Example Implementation**:
    ```metta
    ;; Rule to initiate contradiction management when rate is too high
    (= (handle (Event system-cycle-complete _ _ _))
       (match &self
              (has-value (metric contradiction_rate) $rate)
              (if (> $rate (Config contradiction-rate-threshold))
                  (Goal (resolve-contradictions))
                  ()) ))
    ```

### 2.2 Contradiction Management Function
Implements strategies for resolving contradictions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Goal (resolve-contradictions))`, or `(Event contradiction-detected ...)` |
| **Reads** | The two conflicting `Belief` atoms and their derivation histories. |
| **Writes** | `(Task (revise <belief-to-weaken>))` |

### 2.3 Explanation Function
Generates human-readable explanations for the system's conclusions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Goal (explain <belief>))` |
| **Reads** | The `Belief` atom and its derivation history. |
| **Writes** | A grounded atom containing the explanation text. |

---

## Layer 3: Specialized Metacognition (System 2)

These advanced functions are typically activated by a `Goal` from the `Cognitive Executive`.

### 3.1 Conscience Function
Enforces ethical constraints and safety protocols.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event goal-proposed $g)`, `(Event task-selected $t)` |
| **Reads** | A set of `(Constraint (Forbid <action-pattern>))` beliefs. |
| **Writes** | `(Task (veto $g))` or `(Task (modify $g))` |

-   **Core Capability**: Evaluates potential actions and goals against a set of inviolable ethical rules. If a proposed goal matches a forbidden pattern, this function injects a high-priority task to veto or alter it.

### 3.2 Self-Modification & Improvement Functions
A suite of functions for analyzing and improving the system's own knowledge and code.

-   **Self-Optimization Function**: Analyzes and refactors the system's own reasoning rules for better performance.
    -   **Triggers**: `(Goal (optimize-rule $rule_name))`
    -   **Action**: Reads `rule_cost` and `rule_utility` KPIs for the target rule. It then attempts to generate alternative versions of the rule. It uses the `Test Generation Function` to validate any proposed new rule before committing to the change.

-   **Test Generation Function**: Proactively generates tests to verify the system's reasoning and the correctness of proposed self-modifications.
    -   **Triggers**: `(Goal (test-rule $rule_name))`, `(Goal (test-concept $concept_name))`
    -   **Action**: Generates novel combinations of premises to trigger a specific rule or explore a concept, then monitors the outcome for correctness and utility.

-   **Codebase Integrity Function**: Reasons about the system's own design documents and source code to find inconsistencies, pushing metaprogramming to its limit.
    -   **Triggers**: `(Goal (validate self.design))`
    -   **Action**: Uses grounded functions to parse design documents (like this one) and source code, creating atoms that represent the specified and implemented architecture. It then looks for inconsistencies (e.g., a function specified but not implemented).
    -   **Enhanced Capability**: If an inconsistency is found, it can inject a `(Goal (fix-inconsistency <doc> <spec> <impl>))` task for itself or a human developer to address.

-   **Implementation Assistance Function**: Assists developers by automating parts of the implementation process.
    -   **Triggers**: `(Goal (implement-feature $F))`
    -   **Action**: Reads a specification for feature `$F` and generates boilerplate MeTTa code for the new functions.
    -   **Enhanced Capability**: After generating the boilerplate, it also injects a `(Goal (test-feature $F))` task, prompting the `Test Generation Function` to create a test suite for the new feature, encouraging a test-driven development cycle.
