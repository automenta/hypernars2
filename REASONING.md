# The Reasoning Engine

The core of the reasoning process is the **MeTTa Interpreter**. This component replaces a traditional, static inference engine with a dynamic, programmable reasoning system. Following the principle "The Content is an Atom, the Work is a Task," inference is the interpretation of `Sentence` atoms by other atoms (inference rules), orchestrated by a `Control Loop`.

This document details the **Control Loop**, which is architected as a **dual-process system** to balance efficiency with thoroughness.

---

## System 1: The Reflexive Reasoning Loop

This is the default, high-throughput operational mode. It is a continuous cycle of selecting a `Task` and a relevant `Sentence` from memory and feeding them to the MeTTa interpreter to potentially derive new knowledge.

Below is a language-agnostic pseudo-code representation of a single cycle. All data structures are formally defined in `DATA_STRUCTURES.md`.

```pseudo
function reflexive_reasoning_cycle(memory: Memory, interpreter: MeTTa, budgeting_strategy: BudgetingStrategy) {
    // 1. Select a Concept from the Memory's concept bag.
    // This is a probabilistic selection based on priority.
    concept = memory.select_concept_from_bag();
    if (!concept) { return; }

    // 2. Select a high-priority Task from the Concept's local task bag.
    task1 = concept.select_task_from_bag();
    if (!task1) { return; }

    // 3. Select a relevant Belief Sentence from the same Concept's knowledge bag.
    sentence2 = concept.select_sentence_from_bag(task1);
    if (!sentence2 || !is_belief(sentence2)) { return; }

    // 4. Formulate an inference expression for the MeTTa interpreter.
    // This combines the two sentences under a generic 'deduce' or specific NAL rule.
    sentence1 = task1.sentence;
    inference_expression = formulate_inference_expression(sentence1, sentence2);

    // 5. Invoke MeTTa Interpreter to perform the core reasoning step.
    // The interpreter finds matching inference rules (also atoms in Memory) and executes them.
    derived_sentences = interpreter.evaluate(inference_expression);

    // 6. Process Derived Sentences into New Tasks.
    for (derived_sentence in derived_sentences) {
        // Calculate the truth value and budget for the new sentence based on its parents.
        new_truth = truth_function(sentence1.truth, sentence2.truth);
        new_budget = budgeting_strategy.calculate_derived_budget(task1.budget);

        // Attach the calculated truth value to the derived atom to form the final sentence.
        final_sentence = (Belief derived_sentence new_truth);

        // Create and dispatch the new Task to the appropriate concept(s).
        new_task = create_task(final_sentence, new_budget, {task1.stamp, ...});
        memory.dispatch_task(new_task);
    }

    // 7. System-level housekeeping.
    budgeting_strategy.perform_housekeeping(memory);
    memory.emit_event( (Event system-cycle-complete) );
}
```

### Helper Function Definitions

-   **`select_..._from_bag()`**: These functions query a `Bag` data structure, which holds items and their priorities. The selection is probabilistic, weighted by priority, as described in `DATA_STRUCTURES.md`.
-   **`is_belief(sentence)`**: A simple type-check to ensure the sentence has a `Belief` punctuation, as only beliefs can serve as premises in this basic loop.
-   **`formulate_inference_expression(s1, s2)`**: This function wraps the two sentences in a generic inference atom, like `(deduce s1 s2)`. This allows MeTTa to find and apply any matching `(= (deduce ...)` rule defined in the knowledge base.
-   **`truth_function(t1, t2)`**: Calculates the `TruthValue` of a conclusion based on the truth values of its premises. The exact formula depends on the inference rule used (e.g., NARS deduction formula).
-   **`create_task(sentence, budget, parent_stamps)`**: Constructs a new `Task` wrapper around the given sentence, assigning it the calculated budget and a new `Stamp` derived from its parents.

---

## System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive` when it detects a situation requiring deeper analysis (e.g., via a `Task` with a `(Goal (resolve-contradiction ...))` sentence). It operates on a temporary, scoped workspace.

```pseudo
function deliberative_reasoning_process(memory: Memory, interpreter: MeTTa, trigger_task: Task) {
    // 1. Initiation & Context Scoping
    // Create a temporary, high-priority "working memory" space.
    workspace = memory.create_workspace(name="deliberation_space");

    // Gather highly relevant knowledge (Sentences) related to the trigger task's goal
    // and copy it into the workspace.
    relevant_knowledge = memory.find_relevant_knowledge(trigger_task.sentence);
    workspace.add_sentences(relevant_knowledge);

    // 2. Focused, Iterative Reasoning
    // Run a high-budget, iterative reasoning loop within the isolated workspace.
    deliberation_budget = get_high_budget();
    while (deliberation_budget > 0 && !workspace.has_solution(trigger_task.sentence)) {

        // Select a sub-task and a relevant sentence *within the workspace*.
        sub_task = workspace.select_task_for_goal(trigger_task.sentence);
        sentence = workspace.select_sentence_for_task(sub_task);

        // Formulate and evaluate inference expression.
        inference_expression = formulate_inference_expression(sub_task.sentence, sentence);
        derived_sentences = interpreter.evaluate(inference_expression);

        // Add results back to the workspace, not main memory.
        process_and_add_new_tasks(derived_sentences, workspace);

        // Decrement the deliberation budget.
        deliberation_budget--;
    }

    // 3. Resolution and Integration
    // Extract the final solution (e.g., a plan, a revised Belief sentence) from the workspace.
    solution_sentence = workspace.get_solution(trigger_task.sentence);

    if (solution_sentence) {
        // Inject the high-confidence solution back into main memory as a new Task.
        final_task = create_task_from_solution(solution_sentence);
        memory.dispatch_task(final_task);
    }

    // 4. Decommissioning
    // The temporary workspace is dissolved.
    memory.destroy_workspace(workspace);

    return solution_sentence;
}
```

---

## Reasoning about Reasoning: Performance Monitoring

The system's ability to reason about its own performance is critical for self-optimization. This is achieved by tracking the performance of its inference rules and materializing this data as `KPI` atoms in Memory, making it accessible to the `CognitiveExecutive`. The authoritative list of KPIs is defined in `DATA_STRUCTURES.md`.

---

## NAL on MeTTa: The Layered Implementation

The hierarchy of Non-Axiomatic Logic (NAL) is implemented as sets of MeTTa rewrite rules that operate on `Sentence` atoms. This provides a clear, incremental path for development. The examples below use the formal schemas defined in `DATA_STRUCTURES.md`.

-   **Deduction**: `(A --> B), (B --> C) ==> (A --> C)`
    ```metta
    ;; Matches two Belief Sentences and produces a third.
    (= (deduce (Belief <$a --> $b> $t1) (Belief <$b --> $c> $t2))
       (Belief <$a --> $c> (deduction-truth-fn $t1 $t2)))
    ```

-   **Abduction**: `(A --> B), (C --> B) ==> (C --> A)` (a possible explanation)
    ```metta
    ;; Matches two Belief Sentences and produces a third.
    (= (abduce (Belief <$a --> $b> $t1) (Belief <$c --> $b> $t2))
       (Belief <$c --> $a> (abduction-truth-fn $t1 $t2)))
    ```

-   **Induction**: `(A --> B), (A --> C) ==> (C --> B)`
    ```metta
    ;; Matches two Belief Sentences and produces a third.
    (= (induce (Belief <$a --> $b> $t1) (Belief <$a --> $c> $t2))
       (Belief <$c --> $b> (induction-truth-fn $t1 $t2)))
    ```

-   **NAL 5 (Statements as Terms)**: This is native to MeTTa. Any `Sentence` atom can be an argument in another expression.
    ```metta
    ;; "The belief that 'birds fly' implies the goal of 'checking the sky'."
    (Implication
      (Belief <bird --> flyer> (TruthValue 1.0 0.9))
      (Goal <check-the-sky>))
    ```

-   **NAL 7 (Temporal Reasoning)**: Implemented with temporal operators and corresponding rules.
    ```metta
    ;; If (A happens before B) and (B happens before C), then (A happens before C).
    (= (deduce-temporal (Belief <(A </> B)> $t1) (Belief <(B </> C)> $t2))
       (Belief <(A </> C)> (temporal-deduction-truth-fn $t1 $t2)))
    ```

-   **NAL 8-9 (Procedural and Goal-oriented Reasoning)**: These are not simple rewrite rules, but are implemented by the `Goal & Planning Function` described in `COGNITIVE_ARCH.md`, which performs backward chaining on procedural `==>` implications.
