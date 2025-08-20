# The Reasoning Engine

The core of the reasoning process is the **MeTTa Interpreter**. This component replaces a traditional, static inference engine with a dynamic, programmable reasoning system. Following the principle "The Content is an Atom, the Work is a Task," inference is the interpretation of `Sentence` atoms by other atoms (inference rules), orchestrated by a `Control Loop`.

This document details the **Control Loop**, which is architected as a **dual-process system** to balance efficiency with thoroughness.

---

## System 1: The Reflexive Reasoning Loop

This is the default, high-throughput operational mode. It is a continuous cycle of selecting a `Task` and a relevant `Sentence` from memory and feeding them to the MeTTa interpreter to potentially derive new knowledge.

Below is a more detailed, language-agnostic pseudo-code representation of a single cycle. All data structures are formally defined in `DATA_STRUCTURES.md`.

```pseudo
function reflexive_reasoning_cycle(memory: Memory, interpreter: MeTTa, budgeting_strategy: BudgetingStrategy) {
    // 1. Select a Concept from Memory's concept bag based on priority.
    concept = memory.select_concept_from_bag();
    if (!concept) { return; }

    // 2. Select a high-priority Task from the Concept's local task bag.
    task = concept.select_task_from_bag();
    if (!task) { return; }

    // 3. Select a relevant Belief from the same Concept's knowledge bag.
    // Relevance can be determined by shared atoms between the task and the belief.
    belief = concept.select_belief_from_bag(task);
    if (!belief) { return; }

    // 4. Formulate an Inference Expression.
    // This involves selecting an inference rule (e.g., deduce, abduce, induce)
    // and wrapping the task's sentence and the belief in it.
    inference_rule = select_inference_rule(); // e.g., returns 'deduce'
    inference_expression = (inference_rule task.sentence belief);

    // 5. Invoke MeTTa Interpreter.
    // The interpreter finds a matching rule in its knowledge base (see "NAL on MeTTa")
    // and executes it. The rule itself is responsible for calculating the new TruthValue
    // and returning one or more complete, new Sentences.
    derived_sentences = interpreter.evaluate(inference_expression);

    // 6. Process Derived Sentences into New Tasks.
    for (new_sentence in derived_sentences) {
        // The new sentence already contains the derived truth value.
        // Calculate the budget for the new task based on the parents' budgets.
        new_budget = budgeting_strategy.calculate_derived_budget(task.budget, belief.budget);

        // Create the new Task and dispatch it to the appropriate concept(s).
        new_task = create_task(new_sentence, new_budget, {task.stamp, belief.stamp});
        memory.dispatch_task(new_task);
    }

    // 7. System-level housekeeping.
    budgeting_strategy.perform_housekeeping(memory);
    memory.emit_event( (Event system-cycle-complete task.id) );
}
```

### Detailed Helper Function Descriptions

-   **`select_..._from_bag()`**: These functions query a `Bag` data structure. The selection is probabilistic, weighted by priority. The `select_belief_from_bag` variant would also include logic to favor beliefs that are structurally relevant to the input `Task`.
-   **`select_inference_rule()`**: Selects which type of inference to attempt. This could be a simple random choice from `(deduce, abduce, induce)`, or a more sophisticated choice based on the current system state or goals.
-   **`interpreter.evaluate(expression)`**: The core call to the MeTTa interpreter. It takes an expression and tries to find a matching rule in the knowledge base to rewrite it. Crucially, the matched rule (e.g., the `(= (deduce ...)` atom) is expected to handle the entire transformation, including calling the appropriate truth function and constructing the full resulting `Sentence` atom.
-   **`create_task(sentence, budget, parent_stamps)`**: Constructs a new `Task` wrapper. This involves generating a new unique `TaskID`, and creating a new `Stamp` by combining the `TaskID`s from the `parent_stamps` to extend the derivational history.

---

## System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive` when it detects a situation requiring deeper analysis (e.g., via a `Task` with a `(Goal (resolve-contradiction ...))` sentence). It operates on a temporary, scoped workspace to conduct focused thought.

```pseudo
function deliberative_reasoning_process(memory: Memory, interpreter: MeTTa, trigger_task: Task) {
    // 1. Initiation & Context Scoping
    // A workspace is a temporary, isolated memory space with its own bags.
    // It is used for focused reasoning without polluting the main memory space.
    workspace = memory.create_workspace(name="deliberation_space");

    // Gather highly relevant knowledge from main memory and copy it into the workspace.
    // Relevance can be determined by concept linkage, structural similarity, etc.
    relevant_knowledge = memory.find_relevant_knowledge(trigger_task.sentence);
    workspace.add_sentences(relevant_knowledge);
    workspace.add_task(trigger_task); // Add the main goal to the workspace

    // 2. Focused, Iterative Reasoning
    // Run a high-budget, iterative reasoning loop within the isolated workspace.
    // This loop is essentially the same as the reflexive_reasoning_cycle, but operates
    // on the workspace's private bags and uses a dedicated deliberation budget.
    deliberation_budget = get_high_budget();
    while (deliberation_budget > 0 && !workspace.has_solution(trigger_task.sentence)) {
        // A solution is typically a new, high-confidence Belief that directly
        // satisfies the initial Goal (e.g., a plan, or a revised belief).
        reflexive_reasoning_cycle(workspace, interpreter, get_deliberation_budgeting_strategy());
        deliberation_budget--;
    }

    // 3. Resolution and Integration
    // Extract the final solution from the workspace.
    solution_sentence = workspace.get_solution(trigger_task.sentence);

    if (solution_sentence) {
        // Inject the high-confidence solution back into main memory as a new Task
        // with a very high budget to ensure it gets processed immediately.
        solution_budget = get_very_high_budget();
        final_task = create_task(solution_sentence, solution_budget, {trigger_task.stamp});
        memory.dispatch_task(final_task);
    }

    // 4. Decommissioning
    // The temporary workspace is dissolved.
    memory.destroy_workspace(workspace);

    return solution_sentence;
}
```

### Detailed Helper Function Descriptions

-   **`memory.create_workspace()`**: Instantiates a new, temporary memory object, likely with its own `Concept` bags.
-   **`memory.find_relevant_knowledge(sentence)`**: A heuristic-based search function that gathers sentences from the main memory that are likely to be useful for reasoning about the given `sentence`.
-   **`workspace.has_solution(goal_sentence)`**: Checks if the workspace contains a `Sentence` (typically a `Belief`) that satisfies the `goal_sentence`.
-   **`get_deliberation_budgeting_strategy()`**: A budgeting strategy tailored for deliberative thought, which may be more aggressive or focused than the default one.

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
