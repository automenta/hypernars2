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

This is the default, high-throughput operational mode. The conceptual flow is as follows:
1.  **Select Task**: A concept and a high-priority task (an atom with a budget) are selected from memory based on a global attention mechanism.
2.  **Select Belief**: A relevant belief (an atom with a truth value) is selected from the chosen concept to interact with the task.
3.  **Interpret & Reason**: The MeTTa interpreter is invoked with the task and belief atoms. It attempts to match and evaluate them against other atoms in the Memory (which represent inference rules), generating new derived tasks (atoms).
4.  **Process Results**: The derived tasks are budgeted and added to the appropriate concepts in the Memory.

### System 2: The Deliberative Reasoning Process

This is a resource-intensive, goal-driven process initiated by the Cognitive Executive when it detects situations requiring deeper analysis, such as:
-   High-impact contradictions or paradoxes.
-   The pursuit of a complex, high-priority goal.
-   An explicit command to "think about" a topic.

The deliberative process involves steps like context scoping, hypothesis generation, evidence gathering, and committing to a resolution.

### Task and Belief Selection Algorithms

The functions for selecting tasks and beliefs are critical for guiding the system's attention.
-   **Task Selection**: This should be a two-level process. First, a `Concept` is selected from the entire memory, with selection probability proportional to the concept's activation level. Second, the highest-priority `Task` is selected from that concept's local task queue.
-   **Belief Selection**: Given a task, a relevant `Belief` must be selected from the concept. This selection should be based on a relevance score, which could factor in the belief's confidence and its structural similarity to the task.

## NAL on MeTTa: The Layered Implementation

The NARS architecture is defined by a hierarchy of Non-Axiomatic Logic (NAL) layers, each introducing more expressive forms of representation and reasoning. In this architecture, these layers are implemented as sets of MeTTa rules and programs. This provides a clear, incremental path for development.

-   **NAL 1-2 (Basic Inference):** The foundational layers, dealing with inheritance, similarity, and basic logical inference (deduction, induction, abduction), are implemented as a core set of MeTTa `match` expressions. The classic NARS syllogisms are expressed as simple rewrite rules.
    ```metta
    ;;; NAL-1 Deduction Example
    (= (deduce (Belief <A --> B> %t1) (Belief <B --> C> %t2))
       (new-belief <A --> C> (deduction-truth-fn %t1 %t2)))
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

-   **NAL 8-9 (Procedural and Self-Reasoning):** The highest levels of NARS involve goal-directed behavior and self-reasoning. These are implemented as specialized MeTTa scripts (Cognitive Functions) that reason about the system's own state and operations. For example, a goal-pursuit script can match a `(Goal ...)` Atom and search for procedural rules `(==> ...)` that would help achieve it. Self-reasoning involves MeTTa scripts that can inspect the very rules of inference themselves, modifying them to improve performance or resolve paradoxes.

## AIKR-Constrained Interpretation

While the interpreter provides the mechanism for reasoning, the **NARS-style control loop** provides the guidance. The control loop uses the `Budget` and `activation` levels to decide which atoms to feed to the interpreter. This ensures that the system's finite computational resources are always focused on the most promising and relevant lines of reasoning, in accordance with the **Assumption of Insufficient Knowledge and Resources (AIKR)**.

The dual-process model is also implemented here:
-   **System 1 (Reflexive)**: The interpreter performs a shallow, fast evaluation of the selected atoms.
-   **System 2 (Deliberative)**: The interpreter is instructed to perform a deeper, more exhaustive evaluation, potentially chaining multiple rewrite steps together in pursuit of a high-priority goal.
