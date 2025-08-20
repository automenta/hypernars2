# The Reasoning Engine

The core of the reasoning process is the **MeTTa Interpreter**. This component replaces a traditional, static inference engine with a dynamic, programmable reasoning system that embodies the "Everything is an Atom" principle.

## Inference as Interpretation

In this paradigm, inference is not the application of hard-coded rules, but the **interpretation of atoms by other atoms**. The interpreter works by matching and rewriting expressions in the Memory.

Inference rules themselves are represented as atoms, typically using an equality `(=)` or "rewrite" pattern. For example, a classical deduction rule (Modus Ponens) can be expressed as:
`(= (deduce (Implication $a $b) $a) $b)`

When the control unit selects a task like `(deduce (Implication (human socrates) (mortal socrates)) (human socrates))`, the interpreter can match this against the rule above and evaluate it to produce a new atom: `(mortal socrates)`.

This approach provides immense flexibility. The system can learn, modify, or be given new inference rules at runtime simply by adding new atoms to the Memory. Different types of logic (probabilistic, temporal, deontic) can be implemented as sets of interpretation rules.

## The Reasoning Cycle: A Dual-Process Control Unit

To balance efficiency and thoroughness, the reasoning cycle is architected as a **dual-process system**. This allows the system to handle routine inferences rapidly while dedicating more resources to complex or novel situations. The **Cognitive Executive** manager is responsible for orchestrating the transition between these two modes.

### System 1: The Reflexive Reasoning Loop

This is the default, high-throughput operational mode. Below is a more detailed, language-agnostic pseudo-code representation of a single cycle:

```pseudo
function reflexive_reasoning_cycle(budgeting_strategy: BudgetingStrategy) {
    // 1. Select a Concept from Memory
    // Probabilistic selection, weighted by the concept's activation/importance.
    concept = select_concept_from_memory();
    if (!concept) { return; } // No active concepts

    // 2. Select a Task from the Concept
    // Deterministic selection of the highest-priority task.
    task = concept.select_task();
    if (!task) { return; } // No tasks in this concept

    // 3. Select a Belief from the Concept
    // Probabilistic selection, based on relevance to the task atom.
    belief = concept.select_belief_for_task(task);
    if (!belief) { return; } // No relevant beliefs in this concept

    // 4. Update Importance of Accessed Knowledge
    // The system reinforces the importance of items it has just "thought about."
    budgeting_strategy.update_item_importance(concept);
    budgeting_strategy.update_item_importance(task);
    budgeting_strategy.update_item_importance(belief);

    // 5. Formulate Inference Atom for the MeTTa Interpreter
    // The specific inference rule (e.g., deduce, induce, abduce) is chosen
    // based on the task and belief type.
    inference_atom = formulate_inference_atom(task, belief);

    // 6. Invoke MeTTa Interpreter
    // The interpreter evaluates the atom by finding matching rewrite rules (the laws of NAL)
    // in Memory. This may produce zero, one, or multiple derived atoms.
    // The start time is recorded to measure the cost of the inference.
    t_start = now();
    derived_atoms = metta_interpreter.evaluate(inference_atom);
    t_end = now();
    inference_cost = t_end - t_start;


    // 7. Process Derived Atoms into New Tasks
    for (derived_atom in derived_atoms) {
        // Calculate truth value for the new conclusion.
        new_truth = truth_function(task.truth, belief.truth, rule.confidence);

        // Delegate budget calculation to the pluggable strategy.
        new_budget = budgeting_strategy.calculate_derived_task_budget(task, belief);

        // Create and dispatch the new task to the appropriate concept(s).
        new_task = create_task(derived_atom, new_truth, new_budget, {task, belief});
        dispatch_task_to_concept(new_task);

        // Record the utility of the rule that produced this result.
        // This is a key part of the system's self-monitoring.
        record_rule_utility(rule, new_budget.quality, inference_cost);
    }

    // 8. System-level Housekeeping
    // The budgeting strategy handles decay and forgetting.
    budgeting_strategy.perform_housekeeping();
    system.emit_events(); // For cognitive managers
}
```

### System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the `CognitiveExecutive` when it detects situations requiring deeper analysis. Unlike the continuous, reflexive loop of System 1, this process is discrete and purposeful.

The process follows a more structured sequence:
1.  **Initiation**: Triggered by the `CognitiveExecutive` in response to a significant event, such as a high-priority goal, a major contradiction, or an explicit user command to "think about" a topic.
2.  **Context Scoping**: A temporary "working memory" context is created. This involves gathering a set of highly relevant concepts, beliefs, and goals related to the triggering event. This forms a temporary, high-activation subgraph of the main memory, isolating the reasoning process to the most relevant information.
3.  **Hypothesis Generation**: The system enters a goal-driven reasoning mode within the scoped context. It may generate multiple potential lines of reasoning or "hypotheses" to explore.
    -   For a **contradiction**, this might involve finding the weakest premises in the conflicting arguments.
    -   For a **goal**, this might involve finding multiple possible plans (sequences of operations).
4.  **Evidence Gathering & Evaluation**: The system dedicates a larger amount of resources (a "deliberation budget") to deeply explore the generated hypotheses by chaining multiple inference steps together. The goal is to find supporting or conflicting evidence for each hypothesis and evaluate their relative merit.
5.  **Resolution and Commitment**: Based on the evidence gathered, the system commits to a resolution. This could be:
    -   Revising the truth-value of one or more beliefs to resolve a contradiction.
    -   Selecting and committing to a specific plan to achieve a goal.
    -   Generating a detailed, multi-step answer to a complex question.
6.  **Decommissioning**: The working memory context is dissolved. The results of the deliberation (e.g., new high-confidence beliefs, a chosen plan) are integrated back into the main memory, and their effects are propagated.

### Task and Belief Selection Algorithms

The functions for selecting tasks and beliefs are critical for guiding the system's attention.
-   **Task Selection**: This is a two-level process. First, a `Concept` is selected from the entire memory, with selection probability proportional to its importance (e.g., STI). Second, the `Task` with the highest `priority` from that concept's local task queue is selected.
-   **Belief Selection**: Given a task, a relevant `Belief` must be selected from the same concept. This selection is probabilistic, weighted by a relevance score that considers the belief's `confidence` and its structural similarity to the task's atom.

## Reasoning about Reasoning: Performance Monitoring

A key feature of the HyperNARS architecture is its ability to reason about its own reasoning processes. This is crucial for self-optimization and adaptation. The system achieves this by tracking the performance of its own inference rules and storing this data as `Beliefs` in Memory, making it accessible to the `CognitiveExecutive` and `Self-Optimization Manager`.

Two primary metrics are tracked for each inference rule:

1.  **Utility**: How often does this rule produce useful results? "Usefulness" is measured by the `quality` of the budgets of the tasks it generates. A rule that consistently produces high-quality conclusions is considered more useful.
2.  **Computational Cost**: How much time does it take for the MeTTa interpreter to execute this rule? This is measured by timing the `metta_interpreter.evaluate()` call.

This data is collected during the reasoning cycle and periodically aggregated into `Beliefs`.

| KPI Name | Description | Example MeTTa Representation |
| :--- | :--- | :--- |
| `rule_utility` | The average `quality` of the conclusions produced by a specific inference rule. | `(has-utility (rule Deduce) 0.82)` |
| `rule_cost` | The average execution time for a specific inference rule in microseconds. | `(has-cost (rule Abduce) (150 microseconds))` |
| `rule_usage_frequency` | How often a rule is successfully applied. | `(has-frequency (rule Induce) 0.05)` |

This self-monitoring data enables the `Self-Optimization Manager` to perform actions like:
-   **Identifying Inefficient Rules**: A rule with high cost and low utility is a candidate for being refactored or disabled.
-   **Resource Allocation**: The system could learn to allocate more processing time to inference patterns that have proven to be highly effective.
-   **Detecting Reasoning Loops**: A rule that is used very frequently but produces low-utility results might be part of an unproductive reasoning loop.

## NAL on MeTTa: The Layered Implementation

The NARS architecture is defined by a hierarchy of Non-Axiomatic Logic (NAL) layers, each introducing more expressive forms of representation and reasoning. In this architecture, these layers are implemented as sets of MeTTa rules and programs. This provides a clear, incremental path for development and ensures that all essential NARS expressivity is retained.

-   **NAL 1-2 (Basic Syllogistic & Conditional Inference):** The foundational layers, dealing with inheritance (`-->`), similarity (`<->`), and basic logical inference. The classic NARS syllogisms are expressed as simple rewrite rules. Below are examples for the core inference types:
    -   **Deduction**: From `(A --> B)` and `(B --> C)`, infer `(A --> C)`.
        ```metta
        (= (deduce (Belief <$a --> $b> %t1) (Belief <$b --> $c> %t2))
           (new-belief <$a --> $c> (deduction-truth-fn %t1 %t2)))
        ```
    -   **Abduction**: From `(A --> B)` and `(C --> B)`, infer `(C --> A)` (a possible explanation).
        ```metta
        (= (abduce (Belief <$a --> $b> %t1) (Belief <$c --> $b> %t2))
           (new-belief <$c --> $a> (abduction-truth-fn %t1 %t2)))
        ```
    -   **Induction**: From `(A --> B)` and `(A --> C)`, infer `(C --> B)`.
        ```metta
        (= (induce (Belief <$a --> $b> %t1) (Belief <$a --> $c> %t2))
           (new-belief <$c --> $b> (induction-truth-fn %t1 %t2)))
        ```
    -   **Exemplification**: From `(A --> B)`, infer `(B --> A)` (with low confidence).
        ```metta
        (= (exemplify (Belief <$a --> $b> %t1))
           (new-belief <$b --> $a> (exemplification-truth-fn %t1)))
        ```
    -   **Comparison**: From `(A --> C)` and `(B --> C)`, infer `(A <-> B)`.
        ```metta
        (= (compare (Belief <$a --> $c> %t1) (Belief <$b --> $c> %t2))
           (new-belief <$a <-> $b> (comparison-truth-fn %t1 %t2)))
        ```

-   **NAL 3-4 (Compound Terms):** These layers introduce term-level operators (intersection, union, etc.). These are implemented in MeTTa by defining how expressions with these operators interact with inference rules, allowing the system to form and reason about compound concepts.

-   **NAL 5 (Statements as Terms):** This critical layer allows the system to reason about statements themselves. In MeTTa, this is native behavior. Any expression, including a `(Belief ...)` or `(Task ...)` Atom, can be treated as an argument in another expression, enabling higher-order reasoning.
    ```metta
    ;;; NAL-5 Implication Example
    ;;; "If a belief in (A-->B) causes a belief in (C-->D),
    ;;;  then we can form a new belief about that implication."
    (= (causal-inference (Belief <A --> B>) (Belief <C --> D>))
       (new-belief <(<A --> B>) ==> (<C --> D>)> ...))
    ```

-   **NAL 6 (Variable Terms):** The introduction of variables is also native to MeTTa. MeTTa's `$`-prefixed variables can be used to define general inference rules that apply to any term, allowing for abstract and hypothetical reasoning. The NARS inference rules are written as general MeTTa programs using variables.

-   **NAL 7 (Temporal Reasoning):** Temporal reasoning is implemented by adding temporal predicates to statements and defining MeTTa rules that operate on them. For example, rules for temporal succession (`</>`) can be defined to allow for predictions and explanations.
    ```metta
    ;;; NAL-7 Temporal Inference Example
    (= (deduce-temporal (Belief <(A </> B)> %t1) (Belief <(B </> C)> %t2))
       (new-belief <(A </> C)> (temporal-deduction-truth-fn %t1 %t2)))
    ```

-   **NAL 8-9 (Procedural and Self-Reasoning):** The highest levels of NARS involve goal-directed behavior and self-reasoning. These are implemented as specialized MeTTa scripts (Cognitive Functions) that reason about the system's own state and operations. See the section below on Question Answering and Goal Pursuit.

## Question Answering and Goal Pursuit

The reasoning engine must not only process new knowledge, but also actively use its knowledge to answer questions and achieve goals. This is a core part of the NARS model and is handled by treating `Question` and `Goal` tasks as triggers for specialized reasoning patterns.

### Processing Questions

When a `Question` task is selected by the reasoning cycle, the system's immediate objective is to find or derive a `Belief` that provides an answer.

-   **Direct Answer**: For a question like `(bird --> ?what)`, the system first checks the `bird` concept for an existing belief that matches this pattern, such as `(bird --> animal)`. If found, a new `Belief` task is generated for the answer.
-   **Inferred Answer**: If no direct answer is available, the question triggers inference. The system will attempt to apply inference rules to derive an answer. For example, it might combine `(bird --> vertebrate)` and `(vertebrate --> animal)` to answer `(bird --> ?what)`.
-   **Best-Answer Selection**: If multiple potential answers are found, the system will select the one with the highest confidence as the best current answer.
-   **Grounded Questions**: If a question involves a grounded symbol, the system may invoke the corresponding external function to get an answer (e.g., querying a database or web API).

### Processing Goals

When a `Goal` task is selected, the system initiates a backward-chaining inference process to find a sequence of operations (a plan) to achieve the desired state.

-   **Find Relevant Operations**: For a goal like `(Achieve <door-is open>)`, the system searches for procedural beliefs (implications of type `==>`) where the goal is the effect, such as `((execute #unlock-door) ==> <door-is open>)`.
-   **Sub-goaling**: If a relevant operation is found, its preconditions become new sub-goals. For the example above, if the `#unlock-door` operation has a precondition `(is-at SELF door)`, the system will generate a new `Goal` task: `(Achieve <is-at SELF door>)`.
-   **Plan Execution**: This process continues until a sequence of achievable operations is found. The `GoalManager` cognitive module is responsible for managing this process, monitoring execution, and handling failures.

## AIKR-Constrained Interpretation

While the interpreter provides the mechanism for reasoning, the **NARS-style control loop** provides the guidance. The control loop uses the `Budget` and `activation` levels to decide which atoms to feed to the interpreter. This ensures that the system's finite computational resources are always focused on the most promising and relevant lines of reasoning, in accordance with the **Assumption of Insufficient Knowledge and Resources (AIKR)**.

The dual-process model is also implemented here:
-   **System 1 (Reflexive)**: The interpreter performs a shallow, fast evaluation of the selected atoms.
-   **System 2 (Deliberative)**: The interpreter is instructed to perform a deeper, more exhaustive evaluation, potentially chaining multiple rewrite steps together in pursuit of a high-priority goal.
