# The Reasoning Engine

The core of the reasoning process is the **MeTTa Interpreter**. This component replaces a traditional, static inference engine with a dynamic, programmable reasoning system. Following the principle "The Content is an Atom, the Work is a Sentence," inference is the interpretation of `Sentence` atoms by other atoms (inference rules), orchestrated by a `Control Loop`.

This document details the **Control Loop**, which is architected as a **dual-process system** to balance efficiency with thoroughness.

---

## System 1: The Reflexive Reasoning Loop

This is the default, high-throughput operational mode. It is a continuous cycle of selecting a `Sentence` and a relevant belief from memory and feeding them to the MeTTa interpreter to potentially derive new knowledge.

Below is a more detailed, language-agnostic pseudo-code representation of a single cycle. All data structures are formally defined in `DATA_STRUCTURES.md`.

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

### Detailed Helper Function Descriptions

-   **`select_..._from_bag()`**: These functions query a `Bag` data structure. The selection is probabilistic, weighted by priority.
-   **`select_inference_rule()`**: Selects which type of inference to attempt.
-   **`interpreter.evaluate(expression)`**: The core call to the MeTTa interpreter. The matched rule is expected to return a "raw" sentence (e.g., without budget/stamp).
-   **`create_stamp_from_parents(parent_stamps)`**: Constructs a new `Stamp` by combining the stamps from the parent sentences to extend the derivational history.
-   **`append_metadata(sentence, budget, stamp)`**: Appends the budget and stamp to a raw sentence to make it a complete, processable sentence.
-   **`memory.dispatch_sentence(sentence)`**: Dispatches a sentence to be added to the appropriate concept bags in memory.

---

## System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive` when it detects a situation requiring deeper analysis (e.g., via a `Sentence` with a `(! (resolve-contradiction ...))` atom). It operates on a temporary, scoped workspace to conduct focused thought.

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

### Detailed Helper Function Descriptions

-   **`memory.create_workspace()`**: Instantiates a new, temporary memory object.
-   **`memory.find_relevant_knowledge(sentence)`**: A heuristic-based search function that gathers sentences from main memory.
-   **`workspace.has_solution(goal_sentence)`**: Checks if the workspace contains a `Sentence` (typically a belief) that satisfies the `goal_sentence`.
-   **`get_deliberation_budgeting_strategy()`**: A budgeting strategy tailored for deliberative thought.

---

## Reasoning about Reasoning: Performance Monitoring

The system's ability to reason about its own performance is critical for self-optimization. This is achieved by tracking the performance of its inference rules and materializing this data as `KPI` atoms in Memory, making it accessible to the `CognitiveExecutive`. The authoritative list of KPIs is defined in `DATA_STRUCTURES.md`.

---

## NAL on MeTTa: The Layered Implementation

The hierarchy of Non-Axiomatic Logic (NAL) is implemented as sets of MeTTa rewrite rules that operate on `Sentence` atoms. This provides a clear, incremental path for development. The examples below use the formal schemas defined in `DATA_STRUCTURES.md`.

Note that for brevity, `Budget` and `Stamp` are omitted from the rule patterns, as they are handled by the control loop, not the rules themselves.

-   **Deduction**: `(A --> B), (B --> C) ==> (A --> C)`
    ```metta
    ;; Matches two belief sentences and produces a third, raw sentence.
    (= (deduce (. ($a --> $b) $t1 . $any) (. ($b --> $c) $t2 . $any))
       (. ($a --> $c) (deduction-truth-fn $t1 $t2)))
    ```

-   **Abduction**: `(A --> B), (C --> B) ==> (C --> A)` (a possible explanation)
    ```metta
    ;; Matches two belief sentences and produces a third, raw sentence.
    (= (abduce (. ($a --> $b) $t1 . $any) (. ($c --> $b) $t2 . $any))
       (. ($c --> $a) (abduction-truth-fn $t1 $t2)))
    ```

-   **Induction**: `(A --> B), (A --> C) ==> (C --> B)`
    ```metta
    ;; Matches two belief sentences and produces a third, raw sentence.
    (= (induce (. ($a --> $b) $t1 . $any) (. ($a --> $c) $t2 . $any))
       (. ($c --> $b) (induction-truth-fn $t1 $t2)))
    ```

-   **NAL 5 (Statements as Terms)**: This is native to MeTTa. Any `Sentence` atom can be an argument in another expression.
    ```metta
    ;; "The belief that 'birds fly' implies the goal of 'checking the sky'."
    (Implication
      (. (bird --> flyer) (Truth 1.0 0.9))
      (! (check-the-sky)))
    ```

-   **NAL 7 (Temporal Reasoning)**: Implemented with temporal operators and corresponding rules.
    ```metta
    ;; If (A happens before B) and (B happens before C), then (A happens before C).
    (= (deduce-temporal (. ((A </> B)) $t1 . $any) (. ((B </> C)) $t2 . $any))
       (. ((A </> C)) (temporal-deduction-truth-fn $t1 $t2)))
    ```

-   **NAL 8-9 (Procedural and Goal-oriented Reasoning)**: These are not simple rewrite rules, but are implemented by the `Goal & Planning Function` described in `COGNITIVE_ARCH.md`, which performs backward chaining on procedural `==>` implications.
