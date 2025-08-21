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

```metta
;;;
;;; Formal Definition of the System's Core Reasoning Loop (System 1)
;;;
(define-reasoning-cycle Reflexive-Reasoning-Cycle
   (
      (1 Select-Concept "Select a Concept from Memory's concept bag based on priority.")
      (2 Select-Active-Sentence "Select a high-priority Sentence from the Concept's local sentence bag.")
      (3 Select-Relevant-Belief "Select a relevant belief from the same Concept's knowledge bag.")
      (4 Formulate-Inference-Expression "Formulate an Inference Expression by selecting a rule and wrapping the two sentences in it.")
      (5 Invoke-MeTTa-Interpreter "Invoke the MeTTa Interpreter to evaluate the expression against its knowledge base.")
      (6 Process-Derived-Sentences "Process the derived sentences by calculating budget, creating stamps, and dispatching them to memory.")
      (7 Perform-Housekeeping "Perform system-level housekeeping, such as budget updates and event emissions.")
   )
)
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

#### NAL 1-9: Formal MeTTa Rule Definitions
The core Layer 1 cognitive functions are implemented as a set of MeTTa rewrite rules. These rules correspond to the levels of Non-Axiomatic Logic (NAL) and are formally defined below using the `define-cognitive-function` schema.

```metta
;;;
;;; Authoritative Definitions for Layer 1 Cognitive Functions
;;;

;; NAL 1-4: Inductive & Conceptual Learning
(define-cognitive-function Deduction
  "The core NAL deduction rule: (A --> B), (B --> C) ==> (A --> C)"
  (= (deduce (. ($a --> $b) $t1 . $any) (. ($b --> $c) $t2 . $any))
     (. ($a --> $c) (deduction-truth-fn $t1 $t2))))

(define-cognitive-function Abduction
  "The core NAL abduction rule: (A --> B), (C --> B) ==> (C --> A) (a possible explanation)"
  (= (abduce (. ($a --> $b) $t1 . $any) (. ($c --> $b) $t2 . $any))
     (. ($c --> $a) (abduction-truth-fn $t1 $t2))))

(define-cognitive-function Induction
  "The core NAL induction rule: (A --> B), (A --> C) ==> (C --> B)"
  (= (induce (. ($a --> $b) $t1 . $any) (. ($a --> $c) $t2 . $any))
     (. ($c --> $b) (induction-truth-fn $t1 $t2))))

;; NAL 7: Temporal Reasoning
(define-cognitive-function Temporal-Deduction
  "The core temporal deduction rule: If (A happens before B) and (B happens before C), then (A happens before C)."
  (= (deduce-temporal (. ((A </> B)) $t1 . $any) (. ((B </> C)) $t2 . $any))
     (. ((A </> C)) (temporal-deduction-truth-fn $t1 $t2))))

;; NAL 8-9: Goal & Planning
(define-cognitive-function Backward-Chaining-Planner
  "The core backward-chaining planner rule. When a goal (! G) is processed, it looks for an operation (Op) that results in G, and then sets the preconditions (P) of that operation as a new subgoal."
  (= (handle (! $g))
     (match &self
            (. (($op ==> $g)) %true . $any)
            (match &self
                   (. ((has-precondition $op $p)) %true . $any)
                   (! $p)
                   (! (execute $op))))))
```

#### NAL 5: Statements as Terms
This capability is native to MeTTa. Any `Sentence` atom can be an argument in another expression, allowing for higher-order reasoning.
```metta
;; "The belief that 'birds fly' implies the goal of 'checking the sky'."
(Implication
  (. (bird --> flyer) (Truth 1.0 0.9))
  (! (check-the-sky)))
```

---

### Layer 2: Executive Control & Awareness (System 2 Initiation)

The "foreman," monitoring the core functions and initiating deeper, more deliberate thought (System 2).

#### Formal MeTTa Rule Definitions
The core Layer 2 cognitive functions are formally defined below using the `define-cognitive-function` schema. This makes the system's executive capabilities self-describing.

```metta
;;;
;;; Authoritative Definitions for Layer 2 Cognitive Functions
;;;

(define-cognitive-function Cognitive-Executive
  "The system's master control program, responsible for self-monitoring and initiating deliberation by tracking KPIs and triggering Layer 3 functions when thresholds are crossed."
  (Interface
    (Triggers (Event system-cycle-complete _))
    (Reads (has-value (kpi $name) $value))
    (Writes (! (Layer-3-Goal)))))

(define-cognitive-function Contradiction-Management
  "Implements strategies for resolving contradictions between beliefs."
  (Interface
    (Triggers (! (resolve-contradictions)) (Event contradiction-detected _ _))
    (Reads (Sentence-A) (Sentence-B) (Stamp-A) (Stamp-B))
    (Writes (! (revise (belief-to-weaken))))))

(define-cognitive-function Explanation
  "Generates human-readable explanations for the system's conclusions by tracing their derivational history."
  (Interface
    (Triggers (! (explain (. $atom ...))))
    (Reads (Sentence) (Stamp))
    (Writes (GroundedAtom (explanation-text)))))

;;;
;;; Example Implementations
;;;
;;; The following is an example of a specific rule that contributes
;;; to the overall Cognitive-Executive function.
;;;
(define-cognitive-function Cognitive-Executive-Contradiction-Monitor
  "A rule that monitors the contradiction rate and triggers a resolution goal if the rate exceeds a configured threshold."
  (= (handle (Event system-cycle-complete _ _ _))
     (match &self
            (has-value (kpi contradiction_rate) $rate)
            (if (> $rate (Config contradiction-rate-threshold))
                (! (resolve-contradictions))
                ()) )))
```

---

### Layer 3: Specialized Metacognition (System 2)

The "strategist," handling the most abstract, goal-driven, and resource-intensive cognitive tasks, such as ethical reasoning and self-improvement. These are typically activated by a `Goal` from the `Cognitive Executive`.

#### Conscience Function
This function enforces ethical constraints and safety protocols. It is not a source of emergent ethics, but an architect-defined safeguard that evaluates potential actions and goals against a set of inviolable rules. If a proposed goal matches a forbidden pattern, this function can inject a high-priority sentence to veto or alter it. Its interface is formally defined below. For a detailed worked example, see the [**Safety & Resilience**](./SAFETY_AND_RESILIENCE.md#1-ethical-alignment-and-safety) guide.

```metta
(define-cognitive-function Conscience
  "Enforces ethical constraints and safety protocols by evaluating potential actions and goals against a set of inviolable, architect-defined rules."
  (Interface
    (Triggers (Event goal-proposed $g) (Event sentence-selected $s))
    (Reads (. (Constraint (Forbid (action-pattern))) ...))
    (Writes (! (veto $g)) (! (modify $g)))))
```

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
