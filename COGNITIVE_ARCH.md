# Cognitive Architecture: Functions as MeTTa Programs

Higher-level cognitive functions, often handled by specialized "Cognitive Managers" in other architectures, are implemented in HyperNARS as collections of MeTTa scripts that operate on Memory. Instead of being separate, event-driven modules, they are pattern-matching programs that run as part of the overall reasoning process.

Each cognitive function is a set of MeTTa rules that `match` for specific patterns in Memory and then execute a corresponding action by adding, removing, or modifying Atoms. This makes cognitive oversight a natural part of the reasoning flow, rather than an external process.

The Cognitive Managers are specialized, pluggable modules that handle complex, cross-cutting concerns. They operate by subscribing to events from the Reasoning Kernel and can inject new tasks back into the system to influence its behavior.

## 1. Goal Manager
Responsible for goal-oriented behavior, including planning, execution monitoring, and skill acquisition.
-   *Subscribes to*: `belief-updated`, `belief-added`, `afterCycle`.
-   **Core Capabilities**: Manages a goal lifecycle (`active`, `waiting`, `achieved`, `abandoned`), prioritizes goals, and selects actions. It can search for known procedural rules (e.g., `(= (execute (Op Pre)) (Effect))`) where the `Effect` matches the current goal. If preconditions for an action are not met, it can generate sub-goals to satisfy them. It can also decompose conjunctive goals into sub-goals.
-   **Procedural Skill Acquisition**: Learns new procedural rules by observing the consequences of its operations, forming new beliefs of the form `(= (execute (Op Pre)) (Effect))`.
-   *Injects*: New sub-goals to decompose complex problems or satisfy preconditions.
-   **Verification Scenarios**:
    -   **Goal Decomposition**: A conjunctive goal like `(Achieve (And A B))` should be decomposed into two new active goals for `(Achieve A)` and `(Achieve B)`.
    -   **Procedural Skill Execution**: Given a goal `(Achieve (state door unlocked))` and a known procedural rule `(= (execute (#unlock_door (And (is_at SELF door) (state door locked)))) (state door unlocked))`, the system should execute the `#unlock_door` operation if the preconditions are met.

## 2. Temporal Reasoner
Provides a framework for understanding and reasoning about time.
-   *Subscribes to*: `belief-added` (for temporal statements), `system-tick`.
-   **Core Capabilities**:
    -   **Constraint Propagation**: Maintains a graph of temporal relationships and infers new ones (e.g., using Allen's Interval Algebra).
    -   **Quantitative Time**: Supports reasoning about specific durations (e.g., `(event_A --> (before, event_B, 5s))`).
    -   **Time-Varying Truth**: Manages beliefs whose truth value is a function of time.
    -   **Predictive Reasoning**: Generates predictions about future events based on learned temporal patterns.
-   *Injects*: Inferred temporal relationships and predictive tasks about future events.
-   **Verification Scenarios**:
    -   **Transitivity**: Given `(event_A [/] event_B)` (A before B) and `(event_B [/] event_C)`, the system should derive `(event_A [/] event_C)`.

## 3. Learning Engine
Responsible for abstracting knowledge and forming new concepts and rules.
-   *Subscribes to*: `concept-created`, `belief-added`, `afterInference`.
-   *Action*: Detects patterns and correlations to form higher-level abstractions or new inference rules. It also provides performance statistics on existing rules to the `CognitiveExecutive`.
-   *Injects*: Tasks representing new concepts or learned rules.
-   **Verification Scenario**:
    -   **Rule Learning**: If the system repeatedly observes patterns like `({X} --> (relation, {Y}))` and `({Y} --> (relation, {Z}))` leading to `({X} --> (relation, {Z}))`, it should be able to form a new, general transitive inference rule.

## 4. Contradiction Manager
Implements strategies for resolving contradictions detected by the kernel.
-   *Subscribes to*: `contradiction-detected`.
-   *Injects*: Tasks that revise or remove beliefs to resolve contradictions.
-   **Resolution Strategies**: The choice of strategy can be determined by the `CognitiveExecutive`. The architecture should support multiple strategies, such as:
    -   **`DominantEvidence`**: Keep the belief with the highest evidence and weaken the others.
    -   **`Merge`**: Synthesize conflicting beliefs into a new, more nuanced belief.
    -   **`RecencyBiased`**: Keep the most recent belief.
    -   **`SourceReliability`**: Weight beliefs based on the historical reliability of their source.
    -   **`Specialization`**: Resolve a conflict by creating a more specific, contextual belief. For example, if `(Implication bird flyer)` contradicts `(Implication penguin (Not flyer))`, this strategy might generate `(Implication (And bird (Not penguin)) flyer)`.
-   **Verification Scenarios**:
    -   **Specialization**: Given a strong belief `(Implication bird flyer)` and contradictory evidence `(Inheritance penguin bird)` and `(Implication penguin (Not flyer))`, the system should lower the confidence of `(Implication bird flyer)` and create the new, more specific belief `(Implication (And bird (Not penguin)) flyer)`.

## 5. Cognitive Executive
The system's master control program, responsible for self-monitoring, strategic control, and adaptation. It orchestrates the dual-process reasoning modes.
-   *Subscribes to*: All major system events (`contradiction-detected`, `system-idle`, `goal-achieved`, etc.).
-   **Core Function**: It runs a continuous self-monitoring loop to maintain operational health and strategic focus:
    1.  **Calculate Metrics**: It computes Key Performance Indicators (KPIs) and represents them as beliefs in Memory.
    2.  **Detect Issues & Opportunities**: It compares these metrics against configurable thresholds to identify problems (e.g., high contradiction rate) or opportunities (e.g., system is idle).
    3.  **Adapt & Control**: It initiates strategic responses, which include:
        -   Switching between **System 1 (Reflexive)** and **System 2 (Deliberative)** reasoning.
        -   Adjusting system parameters (e.g., inference selectivity, budget allocation weights).
        -   Triggering other managers (e.g., tasking the `Test Generation Manager` to investigate a low-utility rule).
-   *Injects*: High-level control tasks, such as `(Achieve (reduce-contradictions))` or `(Analyze (rule 'AbductionRule'))`.

-   **Key Performance Indicators (KPIs)**: The executive monitors a variety of metrics to assess system health. Below are some examples:
| KPI Name | Description | Example MeTTa Representation |
| :--- | :--- | :--- |
| `inferenceRate` | The number of inferences performed per second. | `(has-value (kpi inferenceRate) 1500)` |
| `contradictionRate` | The percentage of new beliefs that cause contradictions. | `(has-value (kpi contradictionRate) 0.05)` |
| `goalSuccessRate` | The percentage of goals that are successfully achieved. | `(has-value (kpi goalSuccessRate) 0.8)` |
| `memoryUtilization`| The percentage of memory being used. | `(has-value (kpi memoryUtilization) 0.75)` |
| `ruleUtility` | A measure of how often an inference rule leads to useful (high-budget) conclusions. | `(has-utility (rule 'Deduction') 0.9)` |
| `conceptNovelty` | A measure of how many new concepts are being created, indicating active learning. | `(has-value (kpi conceptNovelty) 10)` |

-   **Verification Scenarios**:
    -   **Mode Switching**: If a high-priority goal is set, the `CognitiveExecutive` should switch the system to Deliberative (System 2) mode to focus resources on it.
    -   **Rule Pruning**: If an inference rule is observed to consistently produce low-quality results, the system should form a belief like `((rule, 'AbductionRule') --> (has_utility, 'low'))` and lower the budget allocated to tasks derived from it.

## 6. Explanation System
Generates human-readable explanations for the system's conclusions.
-   *Subscribes to*: `belief-updated`, `belief-added`.
-   *Action*: Maintains a trace of derivations. When the public API's `explain()` method is called, this manager is queried to construct the explanation graph.

## 7. Test Generation Manager
Aids development and ensures robustness by proactively generating tests to verify the system's reasoning. This manager embodies the principle of using the system's own reasoning as a development scaffold.
-   *Subscribes to*: `afterCycle`, `rule-utility-updated`.
-   *Action*: Periodically analyzes operational metrics to find under-utilized inference rules or concepts with low activity. It then formulates new premises that would specifically trigger these rules or components. It can also perform causal analysis on test failures, attempting to form hypotheses about which component or belief caused the unexpected result.
-   *Injects*: Goals to execute under-tested components. It logs the proposed test case and its results for developer review, effectively creating a self-auditing test suite.

## 8. Codebase Integrity Manager
A specialized manager for self-analysis, responsible for ingesting the system's own design documents and source code to reason about their consistency. This enhances development ergonomics by automating design validation.
-   *Subscribes to*: Triggered by a high-level goal, e.g., `(Achieve (validate self.design))`.
-   *Action*: Uses grounded functions to parse design documents (like this README), source code, and test specifications. It creates atoms representing the system's specified and implemented architecture. It then compares this knowledge against a set of baked-in consistency rules (e.g., "every Cognitive Manager in the diagram must have a corresponding section").
-   *Injects*: Goals to report or resolve detected inconsistencies between the design and the implementation.

## 9. Conscience Manager
Responsible for enforcing ethical constraints and safety protocols.
-   *Subscribes to*: `task-selected`, `goal-generated`.
-   *Action*: It evaluates potential actions and goals against a set of inviolable ethical rules.
-   *Injects*: High-priority tasks to veto or modify unethical goals, and can trigger alerts for human supervision.

## 10. Self-Optimization Manager
A highly advanced manager responsible for improving the system's own operational efficiency by analyzing and refactoring its own codebase (represented as MeTTa atoms).
-   *Subscribes to*: `rule-utility-updated`, `performance-bottleneck-detected`.
-   **Core Capabilities**:
    -   **Rule Performance Analysis**: It analyzes the computational cost of inference rules. For example, it might discover that a very general rule with many variables is slow to match.
    -   **Rule Refactoring**: It can autonomously rewrite rules to be more efficient. For example, it might reorder the clauses in a rule's premises to fail faster, or it might propose a more specialized, faster version of a general rule.
    -   **Automated Memoization**: It can identify "pure" MeTTa functions (those that always return the same output for the same input) and wrap them in a memoized form to cache results, trading memory for speed.
-   *Injects*: Goals to test the refactored rules in a sandbox environment and, if successful, high-priority tasks to replace the old rules with their more efficient versions.
-   **Verification Scenario**: The manager detects that a rule `(= (complex-calc $a $b $c) ...)` is frequently called with the same arguments and is flagged as a bottleneck. It hypothesizes a refactoring: `(= (complex-calc $a $b $c) (memoize (slow-complex-calc $a $b $c)))`. It then tests this new rule, and if it improves performance without changing results, proposes it as a replacement.

## 11. Implementation Manager
A manager designed to assist human developers by automating parts of the implementation process, embodying the principle of the system helping to build itself.
-   *Subscribes to*: Triggered by a high-level developer goal, e.g., `(Implement (feature "new-inference-rule"))`.
-   **Core Capabilities**:
    -   **Specification Ingestion**: It reads a developer-provided specification, written as a MeTTa atom. The spec would define the rule's name, its premises, and its conclusion.
    -   **Stub Generation**: It generates a "stub" MeTTa rule with the correct structure but with placeholders for the logic (e.g., the truth function), saving the developer from writing boilerplate code.
    -   **Test Case Generation**: It can automatically task the `Test Generation Manager` to create a basic unit test for the newly created rule stub.
-   *Injects*: The generated stub code and the new test goal into a development space in Memory for the developer to review, complete, and approve.
-   **Verification Scenario**: A developer adds the task: `(Implement (rule (name "new-deduction") (premises ((A --> B), (B --> C))) (conclusion (A --> C))))`. The `ImplementationManager` would generate the MeTTa atom: `(= (new-deduction (Belief <$a --> $b> %t1) (Belief <$b --> $c> %t2)) (new-belief <$a --> $c> (placeholder-truth-fn %t1 %t2)))` and a corresponding test goal.
