# Reasoning Processes and Cognitive Functions

This document provides the detailed, pseudo-code-level specification for the core reasoning processes and **Cognitive Functions** of HyperNARS. It builds upon the high-level concepts introduced in the [**System Architecture**](./ARCHITECTURE.md) document.

The reasoning processes are divided into two main modes, corresponding to the **Dual-Process Reasoning Model**:
1.  The `reflexive_reasoning_cycle` (System 1)
2.  The `deliberative_reasoning_process` (System 2)

This document specifies the logic for these loops and provides a detailed breakdown of the cognitive functions that operate within them, organized by the **Layered Cognitive Architecture**.

All terminology is formally defined in the [**Glossary**](./DATA_STRUCTURES.md#1-glossary-of-core-terms).

---

## 1. The Reasoning Loops

This section provides the language-agnostic pseudo-code for the two main reasoning processes.

### 1.1. The Reflexive Reasoning Cycle (System 1)

This is the default, high-throughput operational mode. It is a continuous cycle that drives the Layer 1 Cognitive Functions. The pseudo-code below describes a single iteration.

```pseudo
function reflexive_reasoning_cycle(memory: Memory, interpreter: MeTTa, budgeting_strategy: BudgetingStrategy) {
    // 1. Select a Concept from Memory's concept bag based on priority.
    concept = memory.select_concept_from_bag();
    if (!concept) { return; }

    // 2. Select a high-priority Sentence from the Concept's local sentence bag.
    active_sentence = concept.select_sentence_from_bag();
    if (!active_sentence) { return; }

    // 3. Select a relevant belief from the same Concept's knowledge bag.
    // Relevance can be determined by shared atoms between the active_sentence and the belief.
    belief_sentence = concept.select_belief_from_bag(active_sentence);
    if (!belief_sentence) { return; }

    // 4. Formulate an Inference Expression.
    // This involves selecting an inference rule (e.g., deduce, abduce, induce)
    // and wrapping the two sentences in it.
    inference_rule = select_inference_rule(); // e.g., returns 'deduce'
    inference_expression = (inference_rule active_sentence belief_sentence);

    // 5. Invoke MeTTa Interpreter.
    // The interpreter finds a matching rule in its knowledge base (see "NAL on MeTTa")
    // and executes it. The rule itself is responsible for calculating the new Truth
    // and returning one or more complete, new Sentences.
    derived_raw_sentences = interpreter.evaluate(inference_expression);

    // 6. Process Derived Sentences.
    for (new_raw_sentence in derived_raw_sentences) {
        // The new sentence from the rule already contains the derived truth value.
        // We now calculate the budget and stamp for the new sentence.
        new_budget = budgeting_strategy.calculate_derived_budget(active_sentence.budget, belief_sentence.budget);
        new_stamp = create_stamp_from_parents({active_sentence.stamp, belief_sentence.stamp});

        // Assemble the final, complete sentence and dispatch it to the appropriate concept(s).
        final_sentence = append_metadata(new_raw_sentence, new_budget, new_stamp);
        memory.dispatch_sentence(final_sentence);
    }

    // 7. System-level housekeeping.
    budgeting_strategy.perform_housekeeping(memory);
    memory.emit_event( (Event system-cycle-complete active_sentence.id) );
}
```

### 1.2. The Deliberative Reasoning Process (System 2)

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive`. It operates on a temporary, scoped workspace to conduct focused thought and is the primary mode for Layer 2 and 3 Cognitive Functions.

```pseudo
function deliberative_reasoning_process(memory: Memory, interpreter: MeTTa, trigger_sentence: Sentence) {
    // 1. Initiation & Context Scoping
    // A workspace is a temporary, isolated memory space with its own bags.
    workspace = memory.create_workspace(name="deliberation_space");

    // Gather highly relevant knowledge from main memory and copy it into the workspace.
    relevant_knowledge = memory.find_relevant_knowledge(trigger_sentence);
    workspace.add_sentences(relevant_knowledge);
    workspace.add_sentence(trigger_sentence); // Add the main goal to the workspace

    // 2. Focused, Iterative Reasoning
    // Run a high-budget, iterative reasoning loop within the isolated workspace.
    deliberation_budget = get_high_budget();
    while (deliberation_budget > 0 && !workspace.has_solution(trigger_sentence)) {
        // A solution is typically a new, high-confidence belief that directly
        // satisfies the initial goal (e.g., a plan, or a revised belief).
        reflexive_reasoning_cycle(workspace, interpreter, get_deliberation_budgeting_strategy());
        deliberation_budget--;
    }

    // 3. Resolution and Integration
    // Extract the final solution from the workspace.
    solution_sentence = workspace.get_solution(trigger_sentence);

    if (solution_sentence) {
        // Inject the high-confidence solution back into main memory
        // with a very high budget to ensure it gets processed immediately.
        solution_sentence.budget = get_very_high_budget();
        memory.dispatch_sentence(solution_sentence);
    }

    // 4. Decommissioning
    // The temporary workspace is dissolved.
    memory.destroy_workspace(workspace);

    return solution_sentence;
}
```

---

## 2. Cognitive Function Specifications

This section provides the detailed specifications for the **Cognitive Functions**, organized by their operational layer as defined in the [**System Architecture**](./ARCHITECTURE.md) document.

### 2.1. Layer 1: Core Cognitive Functions (System 1)

The "engine room" of the mind. These fundamental, continuously-operating functions drive the reflexive, System 1 reasoning loop. They are implemented as MeTTa rewrite rules that correspond to the levels of Non-Axiomatic Logic (NAL).

#### NAL 1-4: Inductive & Conceptual Learning Function
Responsible for abstracting knowledge and forming new concepts through basic inference.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | Co-occurring beliefs, e.g., `(. (A --> B) ...)` and `(. (A --> C) ...)` |
| **Reads** | Patterns of beliefs in memory |
| **Writes** | New, higher-level beliefs, e.g., `(. (C --> B) ...)` (Induction) |

-   **Implementation as MeTTa Rules**: The hierarchy of Non-Axiomatic Logic (NAL) is implemented as sets of MeTTa rewrite rules that operate on `Sentence` atoms.
    -   **Deduction**: `(A --> B), (B --> C) ==> (A --> C)`
        ```metta
        (= (deduce (. ($a --> $b) $t1 . $any) (. ($b --> $c) $t2 . $any))
           (. ($a --> $c) (deduction-truth-fn $t1 $t2)))
        ```
    -   **Abduction**: `(A --> B), (C --> B) ==> (C --> A)` (a possible explanation)
        ```metta
        (= (abduce (. ($a --> $b) $t1 . $any) (. ($c --> $b) $t2 . $any))
           (. ($c --> $a) (abduction-truth-fn $t1 $t2)))
        ```
    -   **Induction**: `(A --> B), (A --> C) ==> (C --> B)`
        ```metta
        (= (induce (. ($a --> $b) $t1 . $any) (. ($a --> $c) $t2 . $any))
           (. ($c --> $b) (induction-truth-fn $t1 $t2)))
        ```

#### NAL 5: Statements as Terms
This capability is native to MeTTa. Any `Sentence` atom can be an argument in another expression, allowing for higher-order reasoning.
```metta
;; "The belief that 'birds fly' implies the goal of 'checking the sky'."
(Implication
  (. (bird --> flyer) (Truth 1.0 0.9))
  (! (check-the-sky)))
```

#### NAL 7: Temporal Reasoning Function
Provides a framework for understanding and reasoning about time.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(. ((A </> B)) ...)` (A is followed by B) |
| **Reads** | Beliefs about temporal sequences, e.g., `(. ((B </> C)) ...)` |
| **Writes** | New inferred temporal beliefs, e.g., `(. ((A </> C)) ...)` |

-   **Implementation as MeTTa Rules**:
    ```metta
    ;; If (A happens before B) and (B happens before C), then (A happens before C).
    (= (deduce-temporal (. ((A </> B)) $t1 . $any) (. ((B </> C)) $t2 . $any))
       (. ((A </> C)) (temporal-deduction-truth-fn $t1 $t2)))
    ```

#### NAL 8-9: Goal & Planning Function
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

---

### Layer 2: Executive Control & Awareness (System 2 Initiation)

The "foreman," monitoring the core functions and initiating deeper, more deliberate thought (System 2).

#### Cognitive Executive
The system's master control program, responsible for self-monitoring and initiating deliberation.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event system-cycle-complete ...)` |
| **Reads** | `(has-value (kpi $name) $value)` atoms (defined in `DATA_STRUCTURES.md`) |
| **Writes** | High-level goal sentences for Layer 3 functions |

-   **Core Function**: Runs a continuous "sense-analyze-act" loop on the system's own performance KPIs. If a KPI crosses a configurable threshold, it triggers a Layer 3 function by injecting a goal.
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

#### Contradiction Management Function
Implements strategies for resolving contradictions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(! (resolve-contradictions))`, or `(Event contradiction-detected ...)` |
| **Reads** | The two conflicting belief sentences and their derivation histories. |
| **Writes** | `(! (revise (belief-to-weaken)))` |

#### Explanation Function
Generates human-readable explanations for the system's conclusions.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(! (explain (. ...)))` |
| **Reads** | The belief sentence and its derivation history. |
| **Writes** | A grounded atom containing the explanation text. |

---

### Layer 3: Specialized Metacognition (System 2)

The "strategist," handling the most abstract, goal-driven, and resource-intensive cognitive tasks, such as ethical reasoning and self-improvement. These are typically activated by a `Goal` from the `Cognitive Executive`.

#### Conscience Function
Enforces ethical constraints and safety protocols. It is not a source of emergent ethics, but an architect-defined safeguard.

| Interface | Atom Schema / Description |
| :--- | :--- |
| **Triggers** | `(Event goal-proposed $g)`, `(Event sentence-selected $s)` |
| **Reads** | A set of `(. (Constraint (Forbid (action-pattern))) ...)` beliefs. |
| **Writes** | `(! (veto $g))` or `(! (modify $g))` |

-   **Core Capability**: Evaluates potential actions and goals against a set of inviolable ethical rules. If a proposed goal matches a forbidden pattern, this function injects a high-priority sentence to veto or alter it. For a detailed worked example, see the [**Safety & Resilience**](./SAFETY_AND_RESILIENCE.md#1-ethical-alignment-and-safety) guide.

#### Self-Modification & Improvement Functions
A suite of functions for analyzing and improving the system's own knowledge and code.

-   **Self-Optimization Function**: Analyzes and refactors the system's own reasoning rules for better performance.
-   **Test Generation Function**: Proactively generates tests to verify the system's reasoning and the correctness of proposed self-modifications.
-   **Codebase Integrity Function**: Reasons about the system's own design documents and source code to find inconsistencies.
-   **Implementation Assistance Function**: Assists developers by automating parts of the implementation process.

---

## 3. Reasoning about Reasoning: Performance Monitoring

The system's ability to reason about its own performance is critical for self-optimization. This is achieved by tracking the performance of its inference rules and materializing this data as `KPI` atoms in Memory, making it accessible to the `CognitiveExecutive`.

The authoritative list of all Key Performance Indicators (KPIs) and their formal schemas is defined in `DATA_STRUCTURES.md`.
