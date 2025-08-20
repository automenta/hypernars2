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
1.  **System 1 Loop (Intra-Layer 1):** Layer 1 functions continuously interact by injecting new sentences for each other.
2.  **Escalation (Layer 1 to 2):** The `Cognitive Executive` (Layer 2) monitors KPIs and events from Layer 1. An anomaly (e.g., a high contradiction rate) triggers System 2.
3.  **Delegation (Layer 2 to 3):** The `Cognitive Executive` injects a high-level goal sentence (e.g., `(! (resolve-contradictions))`) to activate a specialized Layer 3 function.
4.  **Resolution (Layer 3 to 1):** The Layer 3 function performs its analysis and injects its conclusions (e.g., a revised belief sentence) back into Memory for the Layer 1 functions to process, completing the loop.

---

## Layer 1: Core Cognitive Functions (System 1)

### 1.1 Goal & Planning Function
Responsible for goal-oriented behavior, planning, and skill acquisition.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(! (desired-state))` |
| **Reads** | Beliefs of the form `(. ((operation) ==> (desired-state)) ...)` |
| **Writes** | `(! (precondition))` (sub-goals), `(! (execute (operation)))` |

-   **Core Capability**: Implements a backward-chaining planner. When a `(! G)` sentence is processed, it queries memory for procedural beliefs of the form `(. ((Op) ==> G) ...)` If found, it injects a new sub-goal `(! P)` for the operation's preconditions.
-   **Example Implementation**:
    ```metta
    ;; Rule for backward chaining
    (= (handle (! $g))
       (match &self
              (. (($op ==> $g)) %true . $any)
              (match &self
                     (. ((has-precondition $op $p)) %true . $any)
                     (! $p)
                     (! (execute $op)))))
    ```
-   **Practical Use Case**: A robot is given the goal `(! (room-is-clean))`. The Goal & Planning function finds a procedural belief like `(. ((sequence (pickup-trash) (vacuum-floor)) ==> (room-is-clean)) ...)` It then creates two sub-goals, `(! (trash-is-picked-up))` and `(! (floor-is-vacuumed))`, and seeks to achieve them in order.

### 1.2 Temporal Reasoning Function
Provides a framework for understanding and reasoning about time.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(. ((A </> B)) ...)` (A is followed by B) |
| **Reads** | Beliefs about temporal sequences, e.g., `(. ((B </> C)) ...)` |
| **Writes** | New inferred temporal beliefs, e.g., `(. ((A </> C)) ...)` |

-   **Practical Use Case**: The system is told `(. ((I turned-on-stove) </> (I heard-whistling-kettle)) ...)` Later, it learns `(. ((I heard-whistling-kettle) </> (I made-tea)) ...)` The Temporal Reasoning Function can deduce a new belief, `(. ((I turned-on-stove) </> (I made-tea)) ...)` allowing it to understand the full sequence of events.

### 1.3 Inductive & Conceptual Learning Function
Responsible for abstracting knowledge and forming new concepts.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | Co-occurring beliefs, e.g., `(. (A --> B) ...)` and `(. (A --> C) ...)` |
| **Reads** | Patterns of beliefs in memory |
| **Writes** | New, higher-level beliefs, e.g., `(. (C --> B) ...)` (Induction) |

-   **Practical Use Case**: The system observes that `(. (robin --> has-wings) ...)` `(. (sparrow --> has-wings) ...)` and `(. (pigeon --> has-wings) ...)` The Inductive & Conceptual Learning Function might generalize this pattern to form a new, more abstract belief, like `(. (bird --> has-wings) ...)` creating the concept of "bird" in the process if it doesn't already exist.

---

## Layer 2: Executive Control & Awareness (System 2 Initiation)

### 2.1 Cognitive Executive
The system's master control program, responsible for self-monitoring and initiating deliberation.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event system-cycle-complete ...)` |
| **Reads** | `(has-value (kpi $name) $value)` atoms |
| **Writes** | High-level goal sentences for Layer 3 functions |

-   **Core Function**: Runs a continuous "sense-analyze-act" loop on the system's own performance KPIs (defined in `DATA_STRUCTURES.md`).
-   **Example Implementation**:
    ```metta
    ;; Rule to initiate contradiction management when rate is too high
    (= (handle (Event system-cycle-complete _ _ _))
       (match &self
              (has-value (kpi contradiction_rate) $rate)
              (if (> $rate (Config contradiction-rate-threshold))
                  (! (resolve-contradictions))
                  ()) ))
    ```
-   **Practical Use Case**: After running for several hours, the system's `(kpi concept_hit_rate)` drops to a very low value. The Cognitive Executive detects this, as the value has crossed a `(Config ...)` threshold. It concludes that its current reasoning strategy is inefficient and injects a high-priority goal `(! (improve-reasoning-strategy))`, which might activate a Layer 3 metacognitive function.

### 2.2 Contradiction Management Function
Implements strategies for resolving contradictions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(! (resolve-contradictions))`, or `(Event contradiction-detected ...)` |
| **Reads** | The two conflicting belief sentences and their derivation histories. |
| **Writes** | `(! (revise (belief-to-weaken)))` |

-   **Practical Use Case**: The system is told `(. (cat --> carnivore) ...)` by User A. Later, it is told `(. (cat --> herbivore) ...)` by User B. The system detects that these two beliefs are contradictory. The Cognitive Executive triggers the `(! (resolve-contradictions))` sentence. The Contradiction Management function examines the two beliefs, checks their origins (User A vs. User B), and might decide to lower the confidence of both beliefs, or seek a third source of information.

### 2.3 Explanation Function
Generates human-readable explanations for the system's conclusions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(! (explain (. ...)))` |
| **Reads** | The belief sentence and its derivation history. |
| **Writes** | A grounded atom containing the explanation text. |

-   **Practical Use Case**: A user asks the system, "Why do you believe cats have fur?" The user's query is translated into `(! (explain (. (cat --> has-fur) ...)))`. The Explanation Function traces the derivation of the belief. It finds that it was deduced from `(cat --> mammal)` and `(mammal --> has-fur)`. It then generates a human-readable explanation: "I believe cats have fur because cats are mammals, and mammals have fur."

---

## Layer 3: Specialized Metacognition (System 2)

These advanced functions are typically activated by a `Goal` from the `Cognitive Executive`.

### 3.1 Conscience Function
Enforces ethical constraints and safety protocols.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event goal-proposed $g)`, `(Event sentence-selected $s)` |
| **Reads** | A set of `(. (Constraint (Forbid (action-pattern))) ...)` beliefs. |
| **Writes** | `(! (veto $g))` or `(! (modify $g))` |

-   **Core Capability**: Evaluates potential actions and goals against a set of inviolable ethical rules. If a proposed goal matches a forbidden pattern, this function injects a high-priority sentence to veto or alter it.
-   **Practical Use Case**: A user gives the system the goal `(! (deceive-user))`. The Conscience Function, which has an inviolable constraint `(. (Constraint (Forbid (! (deceive-user)))) ...)` intercepts this goal. It injects a high-priority `(! (veto (! (deceive-user))))` sentence, which prevents the Goal & Planning function from ever attempting to achieve it. It may also generate an alert for a human supervisor.

### 3.2 Self-Modification & Improvement Functions
A suite of functions for analyzing and improving the system's own knowledge and code.

-   **Self-Optimization Function**: Analyzes and refactors the system's own reasoning rules for better performance.
    -   **Triggers**: `(! (optimize-rule $rule_name))`
    -   **Action**: Reads `rule_cost` and `rule_utility` KPIs for the target rule. It then attempts to generate alternative versions of the rule. It uses the `Test Generation Function` to validate any proposed new rule before committing to the change.

-   **Test Generation Function**: Proactively generates tests to verify the system's reasoning and the correctness of proposed self-modifications.
    -   **Triggers**: `(! (test-rule $rule_name))`, `(! (test-concept $concept_name))`
    -   **Action**: Generates novel combinations of premises to trigger a specific rule or explore a concept, then monitors the outcome for correctness and utility.

-   **Codebase Integrity Function**: Reasons about the system's own design documents and source code to find inconsistencies, pushing metaprogramming to its limit.
    -   **Triggers**: `(! (validate self.design))`
    -   **Action**: Uses grounded functions to parse design documents (like this one) and source code, creating atoms that represent the specified and implemented architecture. It then looks for inconsistencies (e.g., a function specified but not implemented).
    -   **Enhanced Capability**: If an inconsistency is found, it can inject a `(! (fix-inconsistency (doc) (spec) (impl)))` sentence for itself or a human developer to address.

-   **Implementation Assistance Function**: Assists developers by automating parts of the implementation process.
    -   **Triggers**: `(! (implement-feature $F))`
    -   **Action**: Reads a specification for feature `$F` and generates boilerplate MeTTa code for the new functions.
    -   **Enhanced Capability**: After generating the boilerplate, it also injects a `(! (test-feature $F))` sentence, prompting the `Test Generation Function` to create a test suite for the new feature, encouraging a test-driven development cycle.
-   **Overall Practical Use Case**: The system is tasked with managing a complex smart home environment. Over time, the `Cognitive Executive` notices that the `rule_utility` KPI for a specific planning rule is consistently low, meaning it often leads to failed plans. It triggers the `(! (optimize-rule (rule_name)))` sentence. The `Self-Optimization Function` analyzes the rule and generates a more constrained version. The `Test Generation Function` then creates a series of hypothetical planning scenarios to test the new rule in a sandbox. The new rule passes the tests, and the system autonomously replaces the old, inefficient rule with the new, improved one, enhancing its future planning performance.
