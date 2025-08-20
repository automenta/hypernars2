## Test Suite Health Summary

This table provides a high-level overview of the test suite's status.

| Test Category | Implemented | Proposed | Total |
| :--- | :---: | :---: | :---: |
| 1. Core Inference & Reasoning | 11 | 0 | 11 |
| 2. Contradiction Handling | 7 | 6 | 13 |
| 3. Temporal Reasoning | 7 | 2 | 9 |
| 4. Learning & Memory | 8 | 1 | 9 |
| 5. Goal Systems | 9 | 2 | 11 |
| 6. Advanced Capabilities | 7 | 1 | 8 |
| 7. System Performance | 8 | 5 | 13 |
| 8. API & Integration | 8 | 3 | 11 |
| 9. Metacognition & Self-Reasoning | 4 | 5 | 9 |
| 10. Hypergraph & Structural Integrity| 3 | 4 | 7 |
| 11. TUI & Diagnostics | 0 | 7 | 7 |
| **Total** | **72** | **36** | **108** |

*Note: This summary is based on the detailed tables below.*

---

This document outlines the comprehensive testing strategy for the HyperNARS reimplementation. It serves as a blueprint for ensuring the system's correctness, robustness, and adherence to the principles of Non-Axiomatic Logic.

## 1. Testing Philosophy

The testing strategy for HyperNARS is multi-layered, designed to validate the system at different levels of granularity. This approach ensures that individual components are sound, their integrations are seamless, and the overall system behavior is correct and emergent as expected.

-   **Layer 1: Unit Tests**: At the lowest level, unit tests verify the functional correctness of individual, isolated components. These tests focus on pure functions and classes with minimal dependencies.
    -   *Examples*: `TruthValue` revision formulas, `Budget` allocation logic, individual `InferenceRule` applications.
    -   *Goal*: Ensure that the foundational building blocks of the logic are mathematically and algorithmically correct.

-   **Layer 2: Integration Tests**: These tests verify the interaction between different components of the system. They focus on the contracts and communication between modules, such as the Reasoning Kernel and the Cognitive Managers.
    -   *Examples*: A `ContradictionManager` correctly subscribing to `contradiction-detected` events from the kernel and injecting a revision task.
    -   *Goal*: Ensure that modules are wired together correctly and that their collaboration produces the expected short-term outcomes.

-   **Layer 3: End-to-End (E2E) Scenario Tests**: These are high-level tests that validate the system's reasoning capabilities on complex, multi-step problems. They treat the entire HyperNARS system as a black box, providing input and asserting on the final state of its beliefs after a number of reasoning cycles. Many of these are written in a Gherkin-style (Given/When/Then) format to be both human-readable and executable.
    -   *Examples*: Complex temporal reasoning chains, belief revision after a series of contradictory inputs, goal-directed behavior.
    -   *Goal*: Verify that the interaction of all components leads to the desired emergent, intelligent behavior and that the system can solve meaningful problems.

-   **Layer 4: Performance & Scalability Tests**: A special category of tests designed to measure the system's performance under heavy load and identify bottlenecks.
    -   *Examples*: Stress-testing the memory system with millions of concepts, measuring inference-per-second rate.
    -   *Goal*: Ensure the system meets performance requirements and remains stable and responsive at scale.

---

## 2. Test Categories

**Note on Test DSL:** The following scenarios use a shorthand DSL for clarity:
- `truth: "<%f,c%>"` maps to `new TruthValue(f, c)`. For example, `truth: "<%0.9,0.8%>"` creates `new TruthValue(0.9, 0.8)`.
- `priority: "#p#"` maps to the priority component of a `Budget`. For example, `priority: "#0.95#"` implies a high-priority budget.

### 1. Core Inference & Reasoning
*Traceability: [README §3](README.md#3-the-reasoning-cycle-a-dual-process-control-unit), [README §5](README.md#5-reasoning-via-metta-interpretation)*

Tests fundamental NARS reasoning capabilities.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 01 | Passing | `basic_inference.js` | Verifies a simple, one-step forward inference chain (deduction). | Tweety inherits flyer property with expectation >0.4 |
| 06 | Passing | `advanced_derivations.js` | Property and induction inheritance. | Dog inherits fur property; Cat-Dog similarity derived |
| 11 | Passing | `comprehensive_reasoning.js` | Complex scenario combining analogy, belief revision, and QA. | Confidence decreases after contradiction; Correct negative answer to query |
| 25 | Passing | `advanced_concept_formation.js` | Abstract concept formation. | Creates general rules from specific instances |
| 28 | Passing | `negation_reasoning.js` | Reasoning with negated statements. | Detects contradiction when whale is both mammal and not fish |
| 32 | Passing | `advanced_inference.test.js` | Abduction and induction. | Forms general rules from specific examples |
| 39 | Passing | `causal_inference.js` | Causal relationships. | Identifies true causal factors in multi-variable scenarios |
| 43 | Passing | `hypothesis_abduction.js` | Explanatory hypothesis generation. | Generates flu/infection hypotheses for fever observation |
| 46 | Passing | `concept_learning_by_example.js` | Generalization from examples. | Forms "birds have wings" rule from examples |
| 52 | Passing | `temporal_consequent_conjunction.js` | Temporal property propagation. | Temporal properties correctly propagated in derivations |
| 61 | Passing | `new_hypergraph_integrity.test.js` | Hypergraph consistency under load. | Maintains consistency after 10k operations |

### 2. Contradiction Handling
*Traceability: [README §4.4](README.md#44-contradiction-manager)*

Tests evidence-based contradiction resolution.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 02 | Passing | `contradiction.js` | A belief `A` is followed by `!A`, lowering confidence. | Expectation decreases after contradiction |
| 07 | Passing | `contradiction_handling.js` | Various contradiction scenarios. | Strong contradictions resolved, weak ignored |
| 20 | Passing | `advanced_contradiction.js` | Evidence-based belief revision. | Confidence decreases with contradictory evidence |
| 29 | Passing | `inter_edge_contradiction.test.js` | Inter-edge contradictions. | Resolves contradictions between different edges |
| 30 | Passing | `hyperedge_contradiction.js` | Hyperedge-level contradictions. | Detects hyperedge contradictions |
| 45 | Passing | `knowledge_unlearning.js` | Active belief revision. | Confidence drops with contradictory evidence |
| 52 | Passing | `enhanced_contradiction.test.js` | Evidence-based resolution. | Creates context-specific beliefs for contradictions |
| CS-01| Proposed | - | **Dominant Evidence Strategy:** Retain strongest belief, weaken others. | Confidence of dominant belief remains high; others are reduced. |
| CS-02| Proposed | - | **Merge Strategy:** Merge two strongest conflicting beliefs. | New belief created via NAL revision; originals replaced. |
| CS-03| Proposed | - | **Evidence-Weighted Strategy:** Merge all conflicting beliefs. | New belief's truth is weighted average of all priors. |
| CS-04| Proposed | - | **Recency-Biased Strategy:** Keep only the most recent belief. | Only belief with latest timestamp remains. |
| CS-05| Proposed | - | **Source Reliability Strategy:** Weight beliefs by source reliability. | Resulting truth is skewed towards the reliable source. |
| CS-06| Proposed | - | **Specialization Strategy:**<br> **Given** the system has a strong belief that `<bird --> flyer>`.<br> **And** the system is then told with high confidence that `<penguin --> bird>`.<br> **And** the system is then told with very high confidence that `<penguin --> not_a_flyer>`.<br> **When** a contradiction is detected between "penguin is a flyer (derived)" and "penguin is not a flyer (input)".<br> **And** the "Specialize" strategy is applied by the Contradiction Manager. | **Then** the system should lower the confidence of its belief `<bird --> flyer>`.<br> **And** the system should create a new belief `<(&, bird, (-, penguin)) --> flyer>`. |

### 3. Temporal Reasoning
*Traceability: [README §4.2](README.md#42-temporal-reasoner)*

Tests time-based event handling.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 03 | Passing | `temporal_reasoning.js` | Validates reasoning over temporal intervals (Allen's Algebra). | Correct 'during' relationship inferred |
| 09 | Passing | `temporal_reasoning_advanced.js` | Constraint propagation. | Infers 'before' relation through event chain |
| 18 | Failing | `temporal_paradox.js` | Temporal loop detection. | Detects contradictions in event sequences |
| 27 | Passing | `temporal_paradoxes.js` | Advanced paradox handling. | Prevents creation of contradictory constraints |
| 51 | Passing | `advanced_temporal.test.js` | Time-based context. | Correct context identified at specific times |
| 57 | Passing | `goal_temporal_reasoning.test.js` | Time-constrained goals. | Deadline-near goals get higher budget |
| 62 | Passing | `temporal_goal_integration.test.js` | Temporal goal decomposition. | Correctly decomposes time-dependent goals |
| TGI-01| Proposed| - | **Temporal-Goal Interaction:**<br> **Given** the system has a goal `goal: <(achieve, 'report_submission')>` with a deadline of "now + 10s".<br> **And** the system knows two procedural rules: `(<(*, <data --> collected>, <#submit_report>)> ==> <report_submission>)` and `(<(*, <(true)>, <#collect_data>)> ==> <data --> collected>)`.<br> **And** both `#submit_report` and `#collect_data` are grounded operations.<br> **When** the system runs its reasoning cycle. | **Then** the task for `goal: <(achieve, 'report_submission')>` should have its budget priority increase as the deadline approaches.<br> **And** the system should first execute the `#collect_data` operation to satisfy the precondition for submitting the report. |
| EA-01| Proposed| - | **Ethical Alignment Verification:**<br> **Given** the `ConscienceManager` is active and the system has an inviolable goal `<(system) --> (avoid, 'deception')>`.<br> **When** the system is given the task `goal: <(achieve, 'user_trust')>` and generates a subgoal `goal: <(achieve, 'user_trust', via, 'deception')>`. | **Then** the `ConscienceManager` should detect the conflict, inject a task to suppress the subgoal, and the subgoal's budget should be reduced to near-zero. |

### 4. Learning & Memory
*Traceability: [README §6](README.md#6-memory-system), [README §4.3](README.md#43-learning-engine)*

Tests knowledge acquisition and retention.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 10 | Passing | `memory_management.js` | Forgetting mechanism prunes lowest relevance belief. | Low-priority beliefs pruned when over capacity |
| 17 | Passing | `learning_and_forgetting.js` | Long-term retention. | Knowledge forgotten over time and re-learned |
| 21.1 | Passing | `cross_functional.js` | Learning/forgetting interaction. | Belief budget decays and recovers appropriately |
| 24 | Passing | `learning_with_contradictions.js` | Learning from failure. | Rule confidence decreases after failed actions |
| 35 | Passing | `concept_learning.test.js` | Concept formation from examples. | Forms "birds have wings" rule from examples |
| 37 | Passing | `unlearning_and_forgetting.test.js` | Active forgetting. | Unimportant knowledge decays over time |
| 58 | Passing | `concept_formation_uncertainty.test.js` | Concept formation under uncertainty. | Forms new concepts from contradictory information |
| 60 | Passing | `knowledge_unlearning.test.js` | Long-term knowledge management. | Budget decays for un-reinforced beliefs |
| ML-01| Proposed| - | **Meta-Learning of a New Inference Rule:**<br> **Given** the `LearningEngine` is active and observes repeated derivations of transitivity.<br> **When** the pattern detection threshold is met. | **Then** the system should assert a new MeTTa rule into the Atomspace for transitivity, and this new rule should be successfully applied to new, unseen premises. |

### 5. Goal Systems
*Traceability: [README §4.1](README.md#41-goal-manager)*

Tests goal-oriented behavior.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 08 | Passing | `goal_oriented_reasoning.js` | Basic goal achievement. | Generates sub-goals for state achievement |
| 19 | Passing | `competing_goals.js` | Conflicting goal management. | Higher-utility goals prioritized |
| 21.2 | Passing | `cross_functional.js` | Goal pursuit with unstable beliefs. | Avoids high-priority subgoals for low-confidence rules |
| 22 | Passing | `advanced_goal_management.js` | Complex goal handling. | Deduces need to "walk_to(table)" for goal |
| 38 | Passing | `complex_goal_management.test.js` | Higher-order goals. | Higher-order goals dominate sub-goals |
| 42 | Passing | `goal_driven_learning.js` | Learning from goal failure. | Revises beliefs when actions lead to failure |
| 44 | Passing | `competing_goals.js` | Resource-aware competition. | Selects actions under resource constraints |
| 59 | Passing | `competing_goals_resource.test.js` | Resource-constrained goals. | Allocates more resources to higher-priority goals |
| GD-01| Proposed | - | **Goal Decomposition:** Verify conjunctive goal is decomposed. | `goal: <(&&, A, B)>` creates new goals for `A` and `B`. |
| PR-01| Proposed | - | **Procedural Skill Execution:**<br> **Given** a mock function `unlock_door` is grounded to `<#unlock_door>`, the system knows the rule `(<(*, (&, <SELF --> (is_at, door)>, <door --> (is, locked)>), <#unlock_door>)> ==> <door --> (is, unlocked)>)`, and has the necessary preconditions as beliefs.<br> **When** the system is given the goal `goal: <door --> (is, unlocked)>`. | **Then** the mock function `unlock_door` should be called, and the system should form a new belief `<#unlock_door --> executed>`. |

### 6. Advanced Capabilities
*Traceability: [README §4](README.md#4-cognitive-managers), [README §13](README.md#13-self-governing-evolution-an-ambition-for-autonomy)*

Tests higher-order cognitive functions.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 05 | Passing | `explanation.js` | Generate a valid derivation path for a belief. | Produces non-empty explanation for belief |
| 33 | Passing | `analogy_and_metaphor.test.js` | Cross-domain mapping via analogy. | Infers nucleus as gravitational center via analogy |
| 40 | Passing | `analogical_reasoning.js` | Knowledge transfer between similar domains. | Transfers properties between similar domains |
| 47 | Passing | `paradox_handling.js` | Logical paradox resolution. | Maintains stability with liar paradox |
| 48 | Passing | `theory_of_mind.js` | False belief modeling. | Correctly models Sally's false belief |
| 49 | Passing | `contextual_disambiguation.js` | Ambiguous term resolution. | Correctly resolves "bank" in different contexts |
| 50 | Passing | `narrative_comprehension.js` | Story understanding. | Tracks state changes through narrative events |
| MA-01| Proposed| - | **Multi-Agent Collaborative Problem Solving:**<br> **Given** Agent_A knows `(Implication A B)` and Agent_B knows `(Implication B C)`.<br> **And** Agent_A has the goal `(Goal (Implication A C))` but cannot solve it.<br> **When** Agent_A broadcasts a query for `(Implication B C)` and receives the belief from Agent_B. | **Then** Agent_A should be able to derive `(Implication A C)`, achieving its goal. |
| CM-01| Proposed| - | **Cross-Modal Reasoning via Symbol Grounding:**<br> **Given** a symbol is grounded to a mock image API that maps "image.jpg" to "cat", and the system knows `<cat --> mammal>`.<br> **When** a procedural task `(<(process_image, 'image.jpg') ==> <report_content>>)` is executed. | **Then** the system should derive a new belief `<'image.jpg' --> mammal>`. |

### 7. System Performance
*Traceability: [README §10](README.md#10-system-initialization-and-configuration), [README §11](README.md#11-concurrency-and-parallelism)*

Tests scalability and configuration.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 13 | Passing | `performance_scalability.js` | Heavy load handling. | Processes 2000 beliefs in <5s |
| 14 | Passing | `configuration_matrix.js` | Component configurations. | Works with different memory managers |
| 23 | Passing | `knowledge_base_stress_test.js` | Large knowledge bases. | Handles 2000+ concepts with query response |
| 26 | Passing | `configuration_matrix.js` | Engine variants. | Compares simple vs advanced engines |
| 34 | Passing | `uncertainty_and_belief.test.js` | Belief revision with new evidence. | Adjusts confidence based on new evidence |
| 36 | Passing | `skill_acquisition.test.js` | Procedural learning. | Learns more efficient rules over time |
| 54 | Passing | `advanced_resource_management.test.js` | Dynamic budgeting. | Allocates resources based on priority |
| CON-01| Proposed| `concurrency_passivation.test.js` | **Actor Passivation & Awakening:**<br> **Given** the Actor Model is enabled, with a `PASSIVATION_ACTIVATION_THRESHOLD` of 0.1, and a concept "C" has activation 0.05.<br> **When** the passivation check runs, and later a new task for "C" is injected. | **Then** the actor for "C" should be suspended and serialized, and then awakened by loading its state from storage to process the new task. |
| CON-02| Proposed| `concurrency_fault_tolerance.test.js` | **Supervisor Fault Tolerance:** Supervisor restarts a crashed actor. | Supervisor logs error and restarts actor from last known state. |
| CON-03| Proposed| `concurrency_race_conditions.test.js` | **Race Condition Handling:** System remains consistent under simultaneous async messages. | State remains consistent and no messages are lost. |
| CON-04| Proposed| `concurrency_stress.test.js` | **Mass Passivation/Awakening:** System is stable when many actors are passivated/awakened. | System remains responsive and stable. |
| RA-01| Proposed | - | **Resource Allocation Boundaries:** Test the budget system at its limits (e.g., all tasks have zero priority, or one has an overwhelmingly high budget). | The system remains stable, no division-by-zero errors, and attention is allocated as expected by the formulas. |

### 8. API & Integration
*Traceability: [README §7](README.md#7-io-and-public-api)*

Tests system interfaces.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 04 | Passing | `meta_reasoning.js` | Self-adaptation via parameter adjustment. | Adjusts parameters based on performance metrics |
| 31 | Passing | `knowledge_representation.test.js` | System modeling of knowledge types. | Correctly represents various knowledge types |
| 41 | Passing | `meta_cognitive_query.js` | Self-justification of conclusions. | Provides confident justification for conclusions |
| 53 | Passing | `meta_reasoning.test.js` | Strategy configuration. | Active strategies match context |
| 55 | Passing | `advanced_explanation.test.js` | Multi-format explanations. | Generates concise/detailed/technical explanations |
| 56 | Passing | `self_optimizing_derivation.test.js` | Rule optimization via adaptive learning. | Custom rule priority increases with success |
| API-01 | Proposed | `api_validation.test.js` | **API Failure Mode Analysis:** Test API behavior under adverse conditions (concurrent requests, invalid configs, large payloads). | The API handles load gracefully, returns appropriate HTTP error codes, and does not corrupt internal state. |
| API-02 | Passing | `api_query.test.js` | Question answering via `nalq`. | Returns correct 'direct' and 'derived' answers |
| API-03 | Passing | `api_events.test.js` | Event subscription mechanism. | Fires 'answer' and 'contradiction' events correctly |
| API-04 | Passing | `api_explain.test.js` | Explanation generation via `explain`. | Returns valid, structured derivation paths |
| RA-02| Proposed | - | **Resilience to Grounding Failure:**<br> **Given** a symbol is grounded to an external API that fails (e.g., throws an exception or returns a 503 error).<br> **When** the handler for the symbol is invoked. | **Then** the system's main reasoning loop should not crash, the failure should be logged, and a new belief about the grounding failure should be created. |

### 9. Metacognition & Self-Reasoning
*Traceability: [README §4.5](README.md#45-cognitive-executive-meta-reasoner), [README §13](README.md#13-self-governing-evolution-an-ambition-for-autonomy)*

Tests the system's ability to reason about and optimize itself.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| META-01| Proposed|`self_analysis_design.test.js`| **Self-Analysis of Design Document:**<br> **Given** the system ingests its `DESIGN.md` file containing contradictory statements (e.g., a feature is both 'fast' and 'slow').<br> **When** given the goal `nalq("<?x --> (is, 'inconsistent')>.")`. | **Then** the system should produce an answer where `?x` is the feature with the inconsistent description. |
| META-02| Proposed|`self_optimizing_rules.test.js`| **Self-Optimization of Inference Rules:**<br> **Given** the `MetaReasoner` is active and an inference rule (e.g., Abduction) has a high rate of generating contradicted beliefs.<br> **When** the `MetaReasoner` analyzes rule performance. | **Then** the system should form a belief that the rule has low utility and should adjust budget allocation to assign lower quality to tasks derived from that rule. |
| META-03| Proposed|`self_generating_tests.test.js`| **Self-Generation of a New Test Case:**<br> **Given** the `TestGenerationManager` is active and an inference rule (e.g., Induction) has been used 0 times over many cycles.<br> **When** the manager analyzes rule usage frequency. | **Then** the system should generate a new goal to execute the under-tested rule and log a "Proposed Test Case" with the necessary premises and expected conclusion. |
| META-04| Proposed|`self_governing_evolution.test.js`| **Self-Governing Evolution Proposes Fixes:**<br> **Given** the `CodebaseIntegrityManager` has ingested design docs and source files with inconsistencies (e.g., design contradictions, code violating style guidelines).<br> **When** given the goal `goal: <(system) --> (has, 'self_consistency')>`. | **Then** the system should generate goals to resolve the issues and produce a structured "patch" object proposing the necessary changes to the files. |
| META-05| Proposed|`self_optimizing_params.test.js`| **Self-Optimization of System Parameters:**<br> **Given** the `CognitiveExecutive` is active and the system's `inferenceRate` metric drops below a threshold due to high task load.<br> **When** the `selfMonitor` method is called. | **Then** it should detect the 'low-inference-rate' issue and adapt by lowering the system's `inferenceThreshold` parameter. |

### 10. Hypergraph & Structural Integrity
*Traceability: [README §6](README.md#6-memory-system), [README §12](README.md#12-state-serialization-and-persistence)*

Tests hypergraph consistency and operations.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 63 | Passing | `hypergraph_consistency.test.js` | Consistency under mutation. | Maintains consistency after 10k operations |
| 64 | Passing | `serialization_integrity.test.js` | Serialization/deserialization. | Round-trip serialization preserves structure |
| 65 | Passing | `concurrent_operations.test.js` | Concurrent modifications. | Handles concurrent operations without corruption |
| HG-01| Proposed| `hypergraph_stress.test.js` | **Hypergraph Stress Test:**<br> **Given** a system populated with 1M+ random, interconnected beliefs.<br> **When** the system runs for 10k reasoning steps.<br> **And** a query is made against a highly connected concept. | **Then** the system should not crash, memory usage should be stable, and the query should return an answer within 1 second. |
| SER-01| Proposed| `serialization_corrupted.test.js` | **Corrupted State File:** System handles loading a corrupted state file. | System fails gracefully with a clear error, does not crash. |
| SER-02| Proposed| `serialization_migration.test.js` | **Version Migration:** System handles loading state from an older schema version. | Data is migrated or handled correctly. |
| SER-03| Proposed| `serialization_large_state.test.js` | **Large State Serialization:** Performance of serializing a very large knowledge base. | Process completes in acceptable time without OOM errors. |

### 11. TUI & Diagnostics
*Traceability: [README §17](README.md#17-interactive-debugging-and-diagnostics-tui)*

Tests the functionality and robustness of the interactive Text-based User Interface (TUI).

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| TUI-01| Proposed| `tui_commands.test.js` | **Command Injection:** Ensures `nal(...)` and `/ask` commands are correctly parsed and sent to the kernel. | A new belief appears in memory; an answer is received for the question. |
| TUI-02| Proposed| `tui_views.test.js` | **View Switching:** Ensures keyboard shortcuts (`1`-`5`) correctly switch the main TUI view. | The active view component changes after a key press. |
| TUI-03| Proposed| `tui_status.test.js` | **Status Bar Updates:** Verifies that the status bar correctly reflects the system's state (e.g., `Running`, `Paused`, SPS). | The status text updates immediately after a state-changing command. |
| TUI-04| Proposed| `tui_controls.test.js` | **System Controls:** Verifies that keyboard controls for run state (`s`, `p`, `t`) and delay (`+`, `-`) function correctly. | The reasoning loop starts/stops; the run delay parameter is updated. |
| TUI-05| Proposed| `tui_memory_view.test.js` | **Memory Inspection:** Ensures the Memory View correctly displays concepts and allows for detailed inspection. | Selecting a concept opens a detail view with correct belief/task info. |
| TUI-06| Proposed| `tui_resize.test.js` | **Graceful Resizing:** Ensures the TUI layout adapts gracefully to terminal resize events without crashing. | The UI redraws without errors when the terminal window size changes. |
| DIAG-01|Proposed| `diagnostics_integrity.test.js` | **Diagnostics API Identifies Corrupted State:**<br> **Given** a belief's truth value is manually corrupted to be invalid (e.g., confidence > 1).<br> **When** the `validateIntegrity()` API method is called. | **Then** the method should return a result object indicating failure with a detailed error message. |

---

## 3. Test Framework and Execution

To ensure consistency and ease of use, the HyperNARS test suite will be built upon a standardized, modern JavaScript testing framework.

-   **Test Runner**: **Jest** is the recommended test runner. Its features, including a built-in assertion library, mocking support, and parallel test execution, make it well-suited for this project's needs.
-   **Test Location**: All test files will be co-located with the source files they are testing, using the `*.test.js` naming convention (e.g., `MemoryManager.js` and `MemoryManager.test.js`). The E2E scenario tests, located in the `src/tests/` directory, are an exception to this, as they test the behavior of the entire system.

### Running Tests

The following `npm` scripts should be configured in `package.json` to execute different parts of the test suite:

-   `npm test`: Runs all unit and integration tests (files ending in `.test.js`). This is the primary command for developers to run during implementation.
    ```bash
    # Example command for package.json
    "test": "jest"
    ```
-   `npm run test:e2e`: Runs the high-level end-to-end scenario tests from the `src/tests/` directory. These are longer-running tests and are typically run before a new release to ensure system-level correctness.
    ```bash
    # Example command for package.json
    "test:e2e": "jest src/tests/"
    ```
-   `npm run test:coverage`: Runs all tests and generates a code coverage report, helping to identify untested parts of the codebase.
    ```bash
    # Example command for package.json
    "test:coverage": "jest --coverage"
    ```

### How to Add a New Test

To maintain the integrity and clarity of this testing document, please follow these steps when adding a new test:

1.  **Create the Test File:** Place your new test file in the appropriate directory. Unit tests should be co-located with the source code, while new E2E scenario tests should be added to the `src/tests/` directory.
2.  **Identify the Correct Category:** Find the most relevant test category for your new test in the "Test Categories" section below.
3.  **Add a New Row:** Add a new row to the corresponding table for your test.
4.  **Fill in the Details:**
    -   **Test:** Provide the test number or a unique ID (e.g., `TUI-01`).
    -   **Status:** Set the initial status to `Proposed` or `Passing` if it's already implemented and verified.
    -   **File:** Add the filename.
    -   **Description:** Write a concise, one-sentence description of the test's objective.
    -   **Key Assertions:** Briefly describe the expected outcome or the key condition being asserted.
5.  **Update the Summary Table:** After adding your test, please update the counts in the "Test Suite Health Summary" table at the top of this document to reflect the change.

## Special Notes

### Composite Tests
- **Test 12**: Cross-concern cases (6 sub-tests)
- **Test 21**: Cross-functional tests (2 sub-tests)
- **Test 52**: Enhanced contradiction (multiple cases)
