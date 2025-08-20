# Cognitive Architecture: Functions as MeTTa Programs

Higher-level cognitive functions, often handled by specialized "Cognitive Managers" in other architectures, are implemented in HyperNARS as collections of MeTTa scripts that operate on Memory. Instead of being separate, event-driven modules, they are pattern-matching programs that run as part of the overall reasoning process.

Each cognitive function is a set of MeTTa rules that `match` for specific patterns in Memory and then execute a corresponding action by adding, removing, or modifying Atoms. This makes cognitive oversight a natural part of the reasoning flow, rather than an external process.

The Cognitive Managers are specialized, pluggable modules that handle complex, cross-cutting concerns. They operate by subscribing to events from the Reasoning Kernel and can inject new tasks back into the system to influence its behavior.

## 1. Goal Manager
Responsible for goal-oriented behavior, including planning, execution monitoring, and skill acquisition.
-   *Subscribes to*: `goal-event`, `belief-added`.
-   **Core Capabilities**: Implements a backward-chaining planner. When a `(Goal G)` is received, it queries memory for beliefs of the form `(Op ==> G)`, where `Op` is an operation. If `Op` has preconditions `P`, it injects a new subgoal `(Goal P)`. This process repeats until a sequence of executable operations is found.
    ```pseudo
    function process_goal(goal) {
        // Find operations that achieve the goal
        relevant_ops = memory.query( (?, op) ==> goal );

        for (op in relevant_ops) {
            if (op.has_preconditions()) {
                // If preconditions exist, create a subgoal to achieve them
                new_goal = create_goal(op.preconditions);
                inject_task(new_goal);
            } else {
                // If no preconditions, the operation is executable
                execute_operation(op);
            }
        }
    }
    ```
-   **Procedural Skill Acquisition**: Learns new procedural rules by observing the consequences of its operations, forming new beliefs of the form `(Op ==> Effect)`.
-   *Injects*: New sub-goals, operation execution tasks.
-   **Verification Scenarios**:
    -   **Input**: `(Goal (state door unlocked))` and `Belief ((operation unlock) ==> (state door unlocked))`.
    -   **Expected Output**: The system injects a task to execute the `unlock` operation.
    -   **Input**: `(Goal (state house secure))` and `Belief ((And (state door locked) (state window closed)) ==> (state house secure))`.
    -   **Expected Output**: The system injects two new subgoals: `(Goal (state door locked))` and `(Goal (state window closed))`.

## 2. Temporal Reasoner
Provides a framework for understanding and reasoning about time.
-   *Subscribes to*: `belief-added` (for temporal statements), `system-tick`.
-   **Core Capabilities**:
    -   **Constraint Propagation**: Maintains a graph of temporal relationships (e.g., Allen's Interval Algebra) and infers new ones.
    -   **Predictive Reasoning**: Generates predictions about future events based on learned temporal patterns of the form `(A </> B)` (A is followed by B).
-   *Injects*: Inferred temporal relationships and predictive tasks.
-   **Verification Scenarios**:
    -   **Input**: `Belief (event_A [/] event_B)` (A before B) and `Belief (event_B [/] event_C)`.
    -   **Expected Output**: The system derives a new `Belief (event_A [/] event_C)`.

## 3. Learning Engine
Responsible for abstracting knowledge and forming new concepts and rules.
-   *Subscribes to*: `concept-created`, `belief-added`, `afterInference`.
-   *Action*: Detects patterns and correlations to form higher-level abstractions or new inference rules.
-   *Injects*: Tasks representing new concepts or learned rules.
-   **Verification Scenario**:
    -   **Input**: Repeated observations of `(cat --> mammal)`, `(dog --> mammal)`, `(human --> mammal)`.
    -   **Expected Output**: The system might form a new, more abstract concept like `(define warm_blooded_animal (Or cat dog human ...))` or learn a higher-order pattern about biological classification.

## 4. Contradiction Manager
Implements strategies for resolving contradictions detected by the kernel.
-   *Subscribes to*: `contradiction-detected(belief1, belief2)`.
-   *Injects*: Tasks that revise or remove beliefs to resolve contradictions.
-   **Resolution Algorithm**:
    1.  Receive the two conflicting beliefs, `b1` and `b2`.
    2.  Delegate to the `CognitiveExecutive` to choose a strategy (e.g., `Specialization`).
    3.  Execute the strategy. For `Specialization`, this involves finding the difference in the premises of `b1` and `b2` and creating a more specific, non-contradictory rule.
-   **Verification Scenarios**:
    -   **Input**: `Belief b1: <bird --> flyer>`, `Belief b2: <penguin --> (Not flyer)>`, and `Belief <penguin --> bird>`. A contradiction is detected between `b1` and `b2` when considering a penguin.
    -   **Expected Output**: Assuming `Specialization` strategy, the system generates a revised belief: `<(And bird (Not penguin)) --> flyer>`, resolving the conflict. The confidence of the original `<bird --> flyer>` belief is reduced.

## 5. Cognitive Executive
The system's master control program, responsible for self-monitoring, strategic control, and adaptation.
-   *Subscribes to*: All major system events (`contradiction-detected`, `system-idle`, `goal-achieved`, etc.).
-   **Core Function**: It runs a continuous "sense-analyze-act" loop:
    1.  **Sense**: Gathers KPI beliefs from Memory.
    2.  **Analyze**: Compares KPIs against configurable thresholds to identify issues (e.g., `contradictionRate > 0.1`) or opportunities (e.g., `system-idle-time > 10s`).
    3.  **Act**: Injects high-level goals to address the findings, e.g., `(Achieve (reduce-contradictions))` or `(Analyze (rule 'AbductionRule'))`.
-   *Injects*: High-level control tasks for other managers to handle.

-   **Comprehensive Key Performance Indicators (KPIs)**:
| KPI Name | Description | Source Document |
| :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all beliefs in Memory. | `DATA_STRUCTURES.md` |
| `avg_task_priority` | The average priority of all tasks in the system. | `DATA_STRUCTURES.md` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. | `DATA_STRUCTURES.md` |
| `memory_utilization`| The percentage of total memory capacity currently being used. | `MEMORY.md` |
| `concept_hit_rate` | The percentage of times a selected `Concept` contains a useful `Belief` for the current `Task`. | `MEMORY.md` |
| `forgetting_rate` | The number of items being forgotten per second. | `MEMORY.md` |
| `rule_utility` | The average `quality` of the conclusions produced by a specific inference rule. | `REASONING.md` |
| `rule_cost` | The average execution time for a specific inference rule. | `REASONING.md` |
| `goal_success_rate` | The percentage of goals that are successfully achieved. | `COGNITIVE_ARCH.md` |
| `contradiction_rate` | The percentage of new beliefs that cause contradictions. | `COGNITIVE_ARCH.md` |

-   **Verification Scenarios**:
    -   **Input**: The belief `(has-value (kpi contradictionRate) 0.15)` is added to memory, exceeding the executive's threshold of 0.1.
    -   **Expected Output**: The executive injects the task `(Goal (reduce-contradictions))`. This goal might then be picked up by the `ContradictionManager` or `Self-OptimizationManager`.
    -   **Input**: The belief `(has-utility (rule Abduce) 0.1)` is added, which is below the utility threshold.
    -   **Expected Output**: The executive injects the task `(Goal (analyze-rule Abduce))`, which could trigger the `Test Generation Manager` to investigate why the rule is performing poorly.

## 6. Explanation System
Generates human-readable explanations for the system's conclusions.
-   *Subscribes to*: `explain-request(belief)`.
-   *Action*: Traverses the derivation history of the given `belief` via its `parent_premises` metadata. It constructs a graph of the reasoning chain and formats it for output.

## 7. Test Generation Manager
Aids development by proactively generating tests to verify the system's reasoning.
-   *Subscribes to*: `(Goal (analyze-rule $X))`, `(Goal (test-concept $Y))`.
-   *Action*: When tasked to analyze a rule, it generates novel combinations of premises that are designed to trigger that specific rule. It then injects these premises as tasks and monitors the outcome.
-   *Injects*: Test-case tasks.

## 8. Codebase Integrity Manager
A specialized manager for reasoning about the system's own design documents and source code.
-   *Subscribes to*: `(Goal (validate self.design))`.
-   *Action*: Uses grounded functions to parse design documents and source code, creating atoms that represent the specified and implemented architecture. It then looks for inconsistencies.
-   *Injects*: `(Belief (inconsistency ...))` atoms.

## 9. Conscience Manager
Responsible for enforcing ethical constraints and safety protocols.
-   *Subscribes to*: `task-selected`, `goal-generated`.
-   *Action*: Evaluates potential actions and goals against a set of inviolable ethical rules represented as MeTTa atoms, e.g., `(Constraint (Forbid (Goal (cause-harm-to-human))))`.
-   *Injects*: High-priority tasks to veto or modify unethical goals.

## 10. Self-Optimization Manager
Improves the system's own operational efficiency by analyzing and refactoring its own codebase.
-   *Subscribes to*: `(Goal (optimize-rule $X))`, `(Belief (has-cost (rule $X) $Y))`.
-   **Core Capabilities**:
    -   **Rule Performance Analysis**: Analyzes the `rule_cost` and `rule_utility` KPIs.
    -   **Rule Refactoring**: Autonomously rewrites rules to be more efficient.
-   *Injects*: Goals to test refactored rules in a sandbox environment before proposing them as replacements.
-   **Verification Scenario**:
    -   **Input**: The `CognitiveExecutive` has injected `(Goal (optimize-rule 'complex-rule'))` because its cost is too high.
    -   **Expected Output**: The manager creates a new, more efficient version `complex-rule-v2`, tasks the `Test Generation Manager` to verify its correctness, and if it passes, proposes replacing the original rule.

## 11. Implementation Manager
A manager designed to assist human developers by automating parts of the implementation process.
-   *Subscribes to*: `(Goal (Implement (feature $F)))`.
-   **Core Capabilities**:
    -   **Specification Ingestion**: Reads a developer-provided specification for a new feature.
    -   **Stub Generation**: Generates boilerplate MeTTa code for the new feature.
    -   **Test Case Generation**: Tasks the `Test Generation Manager` to create a unit test for the new stub.
-   *Injects*: The generated stub code and test goal into a development space.

## Inter-Manager Communication and Collaboration

Cognitive Managers in HyperNARS do not call each other directly. Instead, they collaborate indirectly through Memory, adhering to the "everything is an atom" principle. This creates a loosely coupled, highly flexible architecture.

The primary mechanisms for collaboration are:

1.  **Goal Injection**: This is the most common method. One manager injects a `(Goal ...)` task into Memory. Another manager, which subscribes to that type of goal, will then pick it up and act on it.
    -   **Example**: The `CognitiveExecutive` detects a high contradiction rate and injects `(Goal (reduce-contradictions))`. The `ContradictionManager` is designed to match on this goal and will activate its resolution strategies.

2.  **Belief Observation**: Managers can react to `Beliefs` created by other managers or by the core reasoning engine.
    -   **Example**: The `Self-Optimization Manager` observes a `(Belief (has-cost (rule Abduce) high))` that was generated by the reasoning cycle's performance monitor. This belief might trigger it to initiate an optimization process for the `Abduce` rule.

3.  **Event-Driven Activation**: While most communication is via goals and beliefs, the system still uses a simple event system (as described in `ARCHITECTURE.md`) for broadcasting significant occurrences like `contradiction-detected` or `system-tick`. Managers subscribe to these events as entry points for their processing.

This indirect communication model allows for new managers to be added to the system without requiring changes to existing ones. As long as a new manager knows what kinds of goals and beliefs to subscribe to, it can seamlessly extend the system's cognitive capabilities.
