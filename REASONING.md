# The Reasoning Engine

The core of the reasoning process is the **MeTTa Interpreter**. This component replaces a traditional, static inference engine with a dynamic, programmable reasoning system that embodies the "Everything is an Atom" principle. Inference is the interpretation of atoms by other atoms (inference rules), which are themselves atoms in Memory.

This document details the **Control Loop** that orchestrates the interpreter, which is architected as a **dual-process system** to balance efficiency with thoroughness.

---

## System 1: The Reflexive Reasoning Loop

This is the default, high-throughput operational mode. It is a continuous cycle of selecting a `Task` and a relevant `Belief` from memory and feeding them to the MeTTa interpreter to potentially derive new knowledge.

Below is a language-agnostic pseudo-code representation of a single cycle. All data structures like `Task`, `Belief`, `Budget`, etc., are defined in `DATA_STRUCTURES.md`.

```pseudo
function reflexive_reasoning_cycle(memory: Memory, interpreter: MeTTa, budgeting_strategy: BudgetingStrategy) {
    // 1. Select a Concept from Memory, weighted by importance (e.g., activation).
    concept = memory.select_concept();
    if (!concept) { return; }

    // 2. Select the highest-priority Task from the Concept's local queue.
    // A Task is a wrapper around a sentence (Belief, Goal, or Question) with a Budget.
    task = concept.select_task();
    if (!task) { return; }

    // 3. Select a relevant Belief from the same Concept.
    // A Belief pairs an Atom with a TruthValue.
    belief = concept.select_belief_for_task(task);
    if (!belief) { return; }

    // 4. Formulate an inference expression for the MeTTa interpreter.
    // This combines the task's sentence and the belief's atom under a specific inference rule.
    inference_atom = formulate_inference_atom(task.sentence, belief.atom);

    // 5. Invoke MeTTa Interpreter to perform the core reasoning step.
    // The interpreter finds matching inference rules (also atoms in Memory) and executes them.
    derived_atoms = interpreter.evaluate(inference_atom);

    // 6. Process Derived Atoms into New Tasks.
    for (derived_atom in derived_atoms) {
        // A derived atom is a new sentence (e.g., a conclusion).
        // Calculate its truth value and budget based on its parents.
        new_truth = truth_function(task.sentence.truth, belief.truth);
        new_budget = budgeting_strategy.calculate_derived_budget(task.budget, belief.budget);

        // Create a new Belief atom from the derived sentence and its truth value.
        new_belief_atom = (Belief derived_atom new_truth);

        // Create and dispatch the new Task to the appropriate concept(s).
        new_task = create_task(new_belief_atom, new_budget, {task, belief});
        memory.dispatch_task(new_task);
    }

    // 7. System-level housekeeping, including forgetting and emitting events.
    budgeting_strategy.perform_housekeeping(memory);
    memory.emit_event( (Event system-cycle-complete) );
}
```

---

## System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive` when it detects a situation requiring deeper, focused analysis (e.g., via a `(Goal (resolve-contradiction ...))` task). Unlike the continuous System 1 loop, this process is discrete, purposeful, and operates on a temporary, scoped workspace.

```pseudo
function deliberative_reasoning_process(memory: Memory, interpreter: MeTTa, trigger_goal: Goal) {
    // 1. Initiation & Context Scoping
    // Create a temporary, high-priority "working memory" space.
    workspace = memory.create_workspace(name="deliberation_space");

    // Gather a set of highly relevant knowledge (Beliefs, procedural rules)
    // related to the trigger_goal and copy it into the workspace.
    relevant_knowledge = memory.find_relevant_knowledge(trigger_goal);
    workspace.add_atoms(relevant_knowledge);

    // 2. Focused, Iterative Reasoning
    // Run a high-budget, iterative reasoning loop within the isolated workspace.
    // This is like a super-charged System 1 loop, but goal-directed and contained.
    deliberation_budget = get_high_budget();
    while (deliberation_budget > 0 && !workspace.has_solution(trigger_goal)) {

        // Select a sub-task and belief *within the workspace* that are most relevant to the trigger_goal.
        sub_task = workspace.select_task_for_goal(trigger_goal);
        belief = workspace.select_belief_for_task(sub_task);

        // Formulate and evaluate inference atom.
        inference_atom = formulate_inference_atom(sub_task.sentence, belief.atom);
        derived_atoms = interpreter.evaluate(inference_atom);

        // Add results back to the workspace, not main memory.
        process_and_add_new_tasks(derived_atoms, workspace);

        // Decrement the deliberation budget.
        deliberation_budget--;
    }

    // 3. Resolution and Integration
    // Extract the final result (e.g., a plan, a revised belief) from the workspace.
    solution = workspace.get_solution(trigger_goal);

    if (solution) {
        // Inject the high-confidence solution back into the main memory.
        // The budgeting strategy will assign it a high-quality budget, reflecting the work done.
        final_task = create_final_task_from_solution(solution);
        memory.dispatch_task(final_task);
    }

    // 4. Decommissioning
    // The temporary workspace is dissolved.
    memory.destroy_workspace(workspace);

    return solution;
}
```

---

## Reasoning about Reasoning: Performance Monitoring

The system's ability to reason about its own performance is critical for self-optimization. This is achieved by tracking the performance of its inference rules and materializing this data as `KPI` atoms in Memory, making it accessible to the `CognitiveExecutive`. The authoritative list of KPIs is defined in `DATA_STRUCTURES.md`.

---

## NAL on MeTTa: The Layered Implementation

The hierarchy of Non-Axiomatic Logic (NAL) is implemented as sets of MeTTa rewrite rules. This provides a clear, incremental path for development. The examples below use the formal `(Belief <atom> <truth>)` schema defined in `DATA_STRUCTURES.md`.

-   **Deduction**: `(A --> B), (B --> C) ==> (A --> C)`
    ```metta
    (= (deduce (Belief <$a --> $b> $t1) (Belief <$b --> $c> $t2))
       (Belief <$a --> $c> (deduction-truth-fn $t1 $t2)))
    ```

-   **Abduction**: `(A --> B), (C --> B) ==> (C --> A)` (a possible explanation)
    ```metta
    (= (abduce (Belief <$a --> $b> $t1) (Belief <$c --> $b> $t2))
       (Belief <$c --> $a> (abduction-truth-fn $t1 $t2)))
    ```

-   **Induction**: `(A --> B), (A --> C) ==> (C --> B)`
    ```metta
    (= (induce (Belief <$a --> $b> $t1) (Belief <$a --> $c> $t2))
       (Belief <$c --> $b> (induction-truth-fn $t1 $t2)))
    ```

-   **NAL 5 (Statements as Terms)**: This is native to MeTTa. Any atom, including a `Belief` or `Goal`, can be an argument in another expression.
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
