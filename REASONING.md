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
function reflexive_reasoning_cycle() {
    // 1. Select Concept and Task from Memory
    // Concept selection is probabilistic, weighted by activation level.
    concept = select_concept_from_memory();
    if (!concept) { return; } // No active concepts

    // Task selection is deterministic, based on highest priority.
    task = concept.select_task();
    if (!task) { return; } // No tasks in concept

    // 2. Select a relevant Belief from the same Concept
    // Belief selection is probabilistic, based on relevance to the task.
    belief = concept.select_belief(task);
    if (!belief) { return; } // No relevant beliefs in concept

    // 3. Formulate Inference Atom for the MeTTa Interpreter
    // The specific inference rule (e.g., deduce, induce, abduce) is chosen
    // based on the task and belief type, and then matched by the interpreter.
    // For example, two beliefs might trigger a deduction.
    inference_atom = (deduce task.sentence.atom belief.atom);

    // 4. Invoke MeTTa Interpreter
    // The interpreter evaluates the atom by finding matching rewrite rules
    // in Memory, which represent the laws of NAL.
    derived_atoms = metta_interpreter.evaluate(inference_atom);

    // 5. Process Derived Atoms into New Tasks
    for (derived_atom in derived_atoms) {
        // Calculate budget and truth for the new task based on parent evidence
        // and the confidence of the inference rule used.
        new_truth = truth_function(task.truth, belief.truth, rule.confidence);
        new_budget = budget_function(task.budget, belief.budget);

        // Create and dispatch the new task to the appropriate concept(s).
        new_task = create_task(derived_atom, new_truth, new_budget, {task, belief});
        dispatch_task_to_concept(new_task);
    }

    // 6. System-level Updates
    // Decay activation levels, forget low-budget items, etc.
    system.perform_housekeeping();
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
-   **Task Selection**: This should be a two-level process. First, a `Concept` is selected from the entire memory, with selection probability proportional to the concept's activation level. Second, the highest-priority `Task` is selected from that concept's local task queue.
-   **Belief Selection**: Given a task, a relevant `Belief` must be selected from the concept. This selection should be based on a relevance score, which could factor in the belief's confidence and its structural similarity to the task.

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
