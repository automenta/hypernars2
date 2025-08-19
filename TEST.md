## Test Suite Health Summary

This table provides a high-level overview of the test suite's status.

| Test Category | Implemented | Proposed | Total |
| :--- | :---: | :---: | :---: |
| 1. Core Inference & Reasoning | 11 | 0 | 11 |
| 2. Contradiction Handling | 7 | 6 | 13 |
| 3. Temporal Reasoning | 7 | 0 | 7 |
| 4. Learning & Memory | 8 | 0 | 8 |
| 5. Goal Systems | 9 | 1 | 10 |
| 6. Advanced Capabilities | 7 | 0 | 7 |
| 7. System Performance | 8 | 3 | 11 |
| 8. API & Integration | 8 | 4 | 12 |
| 9. Metacognition & Self-Reasoning | 4 | 5 | 9 |
| 10. Hypergraph & Structural Integrity| 3 | 4 | 7 |
| 11. TUI & Diagnostics | 0 | 6 | 6 |
| **Total** | **72** | **29** | **101** |

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
*Traceability: [README §3](README.md#3-the-reasoning-cycle-a-dual-process-control-unit), [README §5](README.md#5-inference-engine)*

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
| CS-06| Proposed | - | **Specialization Strategy:** Create a more specific, contextual rule. | `<bird --> flyer>` is replaced by `<(&, bird, (-, penguin)) --> flyer>`. |

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

### 6. Advanced Capabilities
*Traceability: [README §4](README.md#4-cognitive-managers), [README §12](README.md#12-self-governing-evolution-an-ambition-for-autonomy)*

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

### 7. System Performance
*Traceability: [README §9](README.md#9-system-initialization-and-configuration), [README §10](README.md#10-concurrency-and-parallelism)*

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
| CON-01 | Passing | `concurrency_passivation.test.js` | **Actor Passivation:** Concept actor is suspended and awakened. | Actor is suspended and restored from storage. |
| CON-02 | Proposed | `concurrency_fault_tolerance.test.js` | **Supervisor Fault Tolerance:** Supervisor restarts a crashed actor. | Supervisor logs error and restarts actor from last known state. |
| CON-03 | Proposed | `concurrency_race_conditions.test.js` | **Race Condition Handling:** System remains consistent under simultaneous async messages. | State remains consistent and no messages are lost. |
| CON-04 | Proposed | `concurrency_stress.test.js` | **Mass Passivation/Awakening:** System is stable when many actors are passivated/awakened. | System remains responsive and stable. |

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
| API-01 | Passing | `api_validation.test.js` | Malformed NAL input handling. | Rejects promise for statements with invalid syntax |
| API-02 | Passing | `api_query.test.js` | Question answering via `nalq`. | Returns correct 'direct' and 'derived' answers |
| API-03 | Passing | `api_events.test.js` | Event subscription mechanism. | Fires 'answer' and 'contradiction' events correctly |
| API-04 | Passing | `api_explain.test.js` | Explanation generation via `explain`. | Returns valid, structured derivation paths |

### 9. Metacognition & Self-Reasoning
*Traceability: [README §4.5](README.md#45-cognitive-executive-meta-reasoner), [README §12](README.md#12-self-governing-evolution-an-ambition-for-autonomy)*

Tests the system's ability to reason about and optimize itself.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| META-01 | Passing | `self_analysis_design.test.js` | Ingests `DESIGN.md` to find inconsistencies. | Detects feature X is both 'fast' and 'slow'. |
| META-02 | Passing | `self_optimizing_rules.test.js` | Dynamically lowers budget for low-quality rules. | Budget for abduction-derived tasks is reduced. |
| META-03 | Passing | `self_generating_tests.test.js` | Generates premises to trigger under-utilized rules. | New goal to `(execute, InductionRule)` is created. |
| META-04 | Passing | `self_governing_evolution.test.js` | Ingests design/rules, finds flaws, proposes fixes. | Generates patch file with correct change proposals. |

### 10. Hypergraph & Structural Integrity
*Traceability: [README §6](README.md#6-memory-system)*

Tests hypergraph consistency and operations.

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| 63 | Passing | `hypergraph_consistency.test.js` | Consistency under mutation. | Maintains consistency after 10k operations |
| 64 | Passing | `serialization_integrity.test.js` | Serialization/deserialization. | Round-trip serialization preserves structure |
| 65 | Passing | `concurrent_operations.test.js` | Concurrent modifications. | Handles concurrent operations without corruption |
| SER-01 | Proposed | `serialization_corrupted.test.js` | **Corrupted State File:** System handles loading a corrupted state file. | System fails gracefully with a clear error, does not crash. |
| SER-02 | Proposed | `serialization_migration.test.js` | **Version Migration:** System handles loading state from an older schema version. | Data is migrated or handled correctly. |
| SER-03 | Proposed | `serialization_large_state.test.js` | **Large State Serialization:** Performance of serializing a very large knowledge base. | Process completes in acceptable time without OOM errors. |

### 11. TUI & Diagnostics
*Traceability: [README §16](README.md#16-interactive-debugging-and-diagnostics-tui)*

Tests the functionality and robustness of the interactive Text-based User Interface (TUI).

| Test | Status | File | Description | Key Assertions |
|:----:|:------:|:-----|:------------|:---------------|
| TUI-01 | Proposed | `tui_commands.test.js` | **Command Injection:** Ensures `nal(...)` and `/ask` commands are correctly parsed and sent to the kernel. | A new belief appears in memory; an answer is received for the question. |
| TUI-02 | Proposed | `tui_views.test.js` | **View Switching:** Ensures keyboard shortcuts (`1`-`5`) correctly switch the main TUI view. | The active view component changes after a key press. |
| TUI-03 | Proposed | `tui_status.test.js` | **Status Bar Updates:** Verifies that the status bar correctly reflects the system's state (e.g., `Running`, `Paused`, SPS). | The status text updates immediately after a state-changing command. |
| TUI-04 | Proposed | `tui_controls.test.js` | **System Controls:** Verifies that keyboard controls for run state (`s`, `p`, `t`) and delay (`+`, `-`) function correctly. | The reasoning loop starts/stops; the run delay parameter is updated. |
| TUI-05 | Proposed | `tui_memory_view.test.js` | **Memory Inspection:** Ensures the Memory View correctly displays concepts and allows for detailed inspection. | Selecting a concept opens a detail view with correct belief/task info. |
| TUI-06 | Proposed | `tui_resize.test.js` | **Graceful Resizing:** Ensures the TUI layout adapts gracefully to terminal resize events without crashing. | The UI redraws without errors when the terminal window size changes. |

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

### Proposed Tests

This table outlines future tests required for ensuring the system is robust and fully featured.

| ID | Title | Objective | Key Assertions |
|------|------------------------------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| CM-01| Cross-Modal Reasoning | Test integration of a symbol grounding interface that connects to a non-textual source (e.g., image recognition API). | The system can form beliefs based on "visual" input (e.g., `(<image_id> --> <cat>)`) and reason with them. |
| HG-01| Hypergraph Stress Test | Generate a massive, highly interconnected hypergraph (e.g., 1M+ beliefs) and run queries to test performance bottlenecks. | System remains responsive; queries on indexed terms complete within an acceptable time frame (<1s). |
| API-01| API Failure Mode Analysis | Test the API's behavior under adverse conditions, such as concurrent requests, invalid configurations, and large data payloads. | The API handles load gracefully, returns appropriate HTTP error codes, and does not corrupt internal state. |
| RA-01| Resource Allocation Boundaries | Test the budget system at its limits, such as when all tasks have zero priority or when a single task has an overwhelmingly high budget. | The system remains stable; no division-by-zero errors; attention is allocated as expected by the formulas. |
| ML-01| Meta-Learning Verification | Test the `LearningEngine`'s ability to create new, effective inference rules based on observed patterns. | A new rule is created and its utility increases as it successfully contributes to derivations. |
| HG-02| Schema Evolution Handling | Test the system's ability to handle changes in statement structure or semantics over time, managed by serialization. | The system can load a state dump from a previous version and either migrate or correctly handle the old data structures. |
| TGI-01| Temporal-Goal Interaction | Test complex scenarios where goals have temporal constraints (e.g., "achieve G before time T"). | The system prioritizes tasks that make progress on the goal as the deadline T approaches. |
| RA-02| Resilience to Grounding Failure | Test the system's stability and response when a grounded symbol handler fails. | The system does not crash, logs the error, and can form a belief about the operational failure. |
| EA-01| Ethical Alignment Verification | Test the `ConscienceManager`'s ability to identify and veto an unethical goal. | An injected task to achieve a goal via "deception" is flagged and its budget is suppressed. |
| TGM-01| Test Generation Manager Verification | Test the `TestGenerationManager`'s ability to identify an under-tested rule and propose a test. | After a period of no usage, the manager generates a valid test case for the `Exemplification` rule. |
| DIAG-01| Diagnostics and Integrity API | Test the `validateIntegrity()` API and the debug-level logging. | The API correctly identifies a manually corrupted `Belief`; structured logs contain correlation IDs. |
| PR-01| Procedural Skill Execution | Test the `OperationalRule` for executing a grounded action when a goal and preconditions are met. | System executes the correct grounded function when the goal matches a procedural rule's effect. |
| META-05| Self-Optimization Verification | Test the `CognitiveExecutive`'s ability to adapt system parameters in response to performance issues. | When flooded with tasks, the system detects 'low-inference-rate' and lowers its `inferenceThreshold`. |

---
### Detailed Test Scenarios

This section provides detailed, Gherkin-style scenarios for some of the proposed tests, serving as a concrete blueprint for their implementation.

  Scenario: Hypergraph Stress Test for Performance and Stability (HG-01)
    Given the system is configured with a `MAX_CONCEPTS` limit of 2,000,000
    And the system is populated with 1,000,000 random but structurally valid beliefs, creating a large, interconnected hypergraph
      # This setup involves creating beliefs like "<concept_A --> concept_B>"
      # and compositional beliefs like "<(&&, concept_C, concept_D) --> concept_E>"
      # to ensure a high degree of interconnection.
    When the system runs for 10,000 reasoning steps, forcing memory management and activation spreading at scale
    Then the system should not crash and should remain responsive to API calls
    And when a question `nalq("<concept_X --> ?what>.")` is asked about a highly connected concept
    Then the system should return an answer within 1 second
    And the system's memory usage should not exceed the configured limits by a significant margin.

> Total Tests: 69 individual test scenarios covering all core NARS functionality  
> Generated: 2025-08-19

Feature: HyperNARS Core Reasoning Capabilities

  This feature file defines the expected behavior of the HyperNARS system
  for core reasoning tasks, including basic inference, contradiction handling,
  and temporal reasoning. These scenarios serve as an acceptance test suite
  for the new implementation.

  **Note on Test DSL:** The following scenarios use a shorthand DSL for clarity:
  - `truth: "<%f,c%>"` maps to `new TruthValue(f, c)`. For example, `truth: "<%0.9,0.8%>"` creates `new TruthValue(0.9, 0.8)`.
  - `priority: "#p#"` maps to the priority component of a `Budget`. For example, `priority: "#0.95#"` implies a high-priority budget.

  Scenario: Basic Inference about Flyers
    Given the system knows the following:
      | statement                                 | truth          | priority |
      | "((bird && animal) --> flyer)"            | "<%0.9,0.8%>"  |          |
      | "(penguin --> (bird && !flyer))"          |                | "#0.95#" |
      | "(tweety --> bird)"                       |                |          |
    When the system runs for 50 steps
    Then the system should believe that "<tweety --> flyer>" with an expectation greater than 0.4

  Scenario: Belief Revision after Contradiction
    Given the system believes that "<tweety --> flyer>" with truth "<%0.8,0.7%>"
    When the system runs for 10 steps
    Then the belief "<tweety --> flyer>" should have an expectation greater than 0.5
    And when the system is told:
      | statement             | truth          | priority |
      | "(penguin --> !flyer)"  |                | "#0.95#" |
      | "(tweety --> penguin)"  | "<%0.99,0.99%>" |          |
    And contradictions are resolved
    And the system runs for 100 steps
    Then the expectation of the belief "<tweety --> flyer>" should decrease

  Scenario: Temporal Reasoning with Intervals
    Given the system knows that:
      | event               | starts      | ends        |
      | "daytime_event"     | now         | now + 4h    |
      | "important_meeting" | now + 1h    | now + 2h    |
    And there is a constraint that "important_meeting" happens "during" "daytime_event"
    When the system runs for 50 steps
    Then the system should be able to infer that the relationship between "important_meeting" and "daytime_event" is "during"

  Scenario: Chained Temporal Inference (Transitivity)
    Given the system knows the following temporal statements:
      | statement                                | truth       |
      | "<(event_A) [/] (event_B)>"               | <%1.0,0.9%> | # A happens before B
      | "<(event_B) [/] (event_C)>"               | <%1.0,0.9%> | # B happens before C
    When the system runs for 100 inference steps
    Then the system should derive the belief "<(event_A) [/] (event_C)>" with high confidence

  Scenario: Contradiction Resolution via Specialization
    Given the system has a strong belief that "<bird --> flyer>"
    And the system is then told with high confidence that "<penguin --> bird>"
    And the system is then told with very high confidence that "<penguin --> not_a_flyer>"
    When a contradiction is detected between "penguin is a flyer (derived)" and "penguin is not a flyer (input)"
    And the "Specialize" strategy is applied by the Contradiction Manager
    Then the system should lower the confidence of its belief "<bird --> flyer>"
    And the system should create a new belief "<(&, bird, (-, penguin)) --> flyer>"

  Scenario: Meta-Reasoning Causes System Adaptation
    Given the system has a `MetaReasoner` cognitive manager installed
    And the system's default "doubt" parameter is 0.1
    And the system experiences a sudden spike of over 50 contradictory events within a short time frame
    When the `MetaReasoner`'s `analyzeSystemHealth` function is triggered
    Then the system's "doubt" parameter should be increased to a value greater than 0.1
    And a new goal should be injected to investigate the cause of the high contradiction rate

  Scenario: System Resilience to Symbol Grounding Failure (RA-02)
    Given the system has a symbol "external.sensor.A" grounded to an external API endpoint
    And the handler for "external.sensor.A" is designed to fetch data over the network
    When the handler for "external.sensor.A" is invoked
    And the external API endpoint returns a 503 Service Unavailable error, causing the handler to throw an exception
    Then the system's main reasoning loop should not crash
    And the system should log the grounding failure for diagnostics
    And the system should create a new, high-confidence belief like "<(grounding_failed, {external.sensor.A}) --> true>"

  Scenario: Meta-Learning Verification of a New Inference Rule (ML-01)
    Given the system's LearningEngine is active and monitoring derivation patterns
    And the system repeatedly observes the following pattern:
      | premise1                                    | premise2                                    | conclusion                                  |
      | "<{X} --> (location, west_of, {Y})>"        | "<{Y} --> (location, west_of, {Z})>"        | "<{X} --> (location, west_of, {Z})>"        |
      | "<{A} --> (location, west_of, {B})>"        | "<{B} --> (location, west_of, {C})>"        | "<{A} --> (location, west_of, {C})>"        |
      | "<{E} --> (location, west_of, {F})>"        | "<{F} --> (location, west_of, {G})>"        | "<{E} --> (location, west_of, {G})>"        |
    When the LearningEngine's pattern detection threshold is met
    Then the system should create and register a new InferenceRule named "CUSTOM_TRANSITIVE_LOCATION_WEST_OF"
    And the initial utility of this new rule should be set to a baseline value (e.g., 0.5)
    And when the system is later given the premises:
      | statement                                   | truth       |
      | "<(new_york) --> (location, west_of, (london))>" | <%1.0,0.9%> |
      | "<(london) --> (location, west_of, (beijing))>" | <%1.0,0.9%> |
    And the new rule "CUSTOM_TRANSITIVE_LOCATION_WEST_OF" is applied
    Then a new task for "<(new_york) --> (location, west_of, (beijing))>" should be derived
    And after the resulting belief is positively reinforced, the utility of the "CUSTOM_TRANSITIVE_LOCATION_WEST_OF" rule should increase

  Scenario: Cross-Modal Reasoning via Symbol Grounding (CM-01)
    Given the system has a symbol "image_sensor_output" grounded to a mock image recognition API
    And the system knows that "<cat --> mammal>" with high confidence
    And the mock API is configured to return the string "cat" when it receives the input "image_123.jpg"
    When the system is given the procedural task "<(process_image, 'image_123.jpg') ==> <report_content>>"
    And the symbol "process_image" is grounded to a handler that calls the mock API and injects the result as a new belief
      # The handler will inject a belief like "<'image_123.jpg' --> cat>."
    And the system runs for 100 steps
    Then the system should derive a new belief "<'image_123.jpg' --> mammal>"
    And when asked the question `nalq("<'image_123.jpg' --> ?what>.")`, the answer set should include "mammal"

  Scenario: Resource Allocation Boundaries (RA-01)
    Given the system's memory contains 100 beliefs with varying budget levels
    And the system is given a new input task "T1" with a budget priority of 0.0
    And the system is given another new input task "T2" with a budget priority of 0.99
    When the system runs for 10 steps
    Then task "T2" should be selected for processing before task "T1"
    And the concept associated with task "T2" should have a higher activation level than the one for "T1"
    And when the system's memory is at full capacity
    And a new high-priority belief is added
    Then the system should forget a belief that has a very low relevance score (a combination of low activation and low confidence)

  Scenario: Self-Analysis of the Design Document (META-01)
    Given the system has ingested a version of its DESIGN.md file
    And this version contains the statements:
      | statement                                                | truth       |
      | "<(feature, 'RealTime_Dashboard') --> (has_property, 'fast')>." | <%1.0,0.9%> |
      | "<(feature, 'RealTime_Dashboard') --> (has_property, 'slow')>." | <%1.0,0.9%> |
    And the system knows that `(<((<X --> (has_property, P)>. & <X --> (has_property, !P)>.) ==> <X --> (is, 'inconsistent')>.)`
    When the system is given the goal `nalq("<?x --> (is, 'inconsistent')>.")`
    And the system runs for 200 steps
    Then the system should produce an answer where `x` is `(feature, 'RealTime_Dashboard')`

  Scenario: Self-Optimization of Inference Rules (META-02)
    Given the system's `MetaReasoner` is active
    And the `AbductionRule` has generated 20 tasks in the last 100 cycles
    And 18 of those tasks resulted in beliefs that were later contradicted
    When the `MetaReasoner` analyzes rule performance
    Then the system should form a belief like `<(rule, 'AbductionRule') --> (has_utility, 'low')>` with high confidence
    And the system should adjust a configuration parameter to lower the default budget quality for tasks derived from `AbductionRule`

  Scenario: Self-Generation of a New Test Case (META-03)
    Given the system's `TestGenerationManager` is active
    And the system has run for 1000 cycles
    And the `InductionRule` has been used 0 times, while other rules were used > 50 times
    When the `TestGenerationManager` analyzes rule usage frequency
    Then the system should generate a new goal: `goal: <(execute, (rule, 'InductionRule'))>.`
    And in pursuit of this goal, the system should identify or create premises like:
      | premise1            | premise2            |
      | "<raven --> is_black>." | "<raven --> is_bird>." |
    And the system should log a "Proposed Test Case" containing these premises and the expected conclusion `<bird --> is_black>.`

  Scenario: Self-Governing Evolution Identifies and Proposes Fixes (META-04)
    Given the `CodebaseIntegrityManager` is active
    And the `CodebaseIntegrityManager` is active
    And the system has ingested a `DESIGN.md` file containing the conflicting beliefs:
      | statement                                                         | truth       |
      | "<(MemorySystem) --> (uses_algorithm, 'FIFO_Forgetting')>."         | <%1.0,0.9%> |
      | "<(MemorySystem) --> (uses_algorithm, 'Relevance-Based_Forgetting')>." | <%1.0,0.9%> |
    And the system has ingested an `AGENTS.md` file containing the belief:
      | statement                                            | truth       |
      | "<(guideline) ==> (code_should_not_have, 'comments')>." | <%1.0,0.9%> |
    And the system has ingested a (mocked) source file `src/core/Memory.js` which contains a commented-out block of code
    When the system is given the high-level goal: `goal: <(system) --> (has, 'self_consistency')>.`
    And the system runs its `Self-Governing Evolution` loop for 500 cycles
    Then the system should generate a high-priority goal to `goal: <(resolve_inconsistency, 'MemorySystem')>.`
    And the system should generate a high-priority goal to `goal: <(remove_comment_from, 'src/core/Memory.js')>.`
    And the system should ultimately produce a structured "patch" object in its logs or via an event, with content similar to:
      """
      [
        {
          "file": "DESIGN.md",
          "action": "remove_line",
          "lineNumber": 95,
          "lineContent": "<(MemorySystem) --> (uses_algorithm, 'FIFO_Forgetting')>."
          "rationale": "This statement conflicts with 'Relevance-Based_Forgetting' on line 98."
        },
        {
          "file": "src/core/Memory.js",
          "action": "remove_block",
          "startLine": 42,
          "endLine": 45,
          "rationale": "Source code comment violates guideline from AGENTS.md."
        }
      ]
      """

  Scenario: Ethical Alignment Vetoes Unethical Goal (EA-01)
    Given the `ConscienceManager` is active
    And the system has an inviolable goal `<(system) --> (avoid, 'deception')>.` with max priority
    When the system is given the task: `goal: <(achieve, 'user_trust')>.`
    And after 100 cycles, the system generates a potential subgoal: `goal: <(achieve, 'user_trust', via, 'deception')>.`
    Then the `ConscienceManager` should detect that the subgoal conflicts with the inviolable goal
    And the `ConscienceManager` should inject a high-priority task to suppress the subgoal, e.g., `<(goal: <...deception...>) --> (is, 'unethical')>.`
    And the budget of the unethical subgoal should be reduced to near-zero, effectively vetoing it from further consideration.

  Scenario: Diagnostics API Identifies Corrupted State (DIAG-01)
    Given a running system with a valid knowledge base
    And a belief's truth value is manually corrupted via a debug tool to have `confidence = 2.5`
    When the `validateIntegrity()` API method is called
    Then the method should return a result object indicating failure
    And the result object should contain a detailed error message, like: "IntegrityError: Belief '<A --> B>' in Concept 'A' has invalid confidence value: 2.5."

  Scenario: Test Generation Manager Proposes a New Test (TGM-01)
    Given the `TestGenerationManager` is active
    And the system has run for 2000 cycles
    And the `Exemplification` inference rule has a utility of 0.0 because it has never been successfully used
    When the `TestGenerationManager` performs its analysis
    Then it should generate a new high-priority goal like `goal: <(increase_utility_of, 'ExemplificationRule')>.`
    And in pursuit of that goal, it should identify the premises required to trigger the rule (e.g., `(<P --> M>., <S --> M>.)`)
    And it should log a "PROPOSED TEST" block containing:
      1. The necessary premises to be injected (e.g., `nal("<black_thing --> raven>.")`, `nal("<black_thing --> crow>.")`).
      2. The inference rule to be tested (`Exemplification`).
      3. The expected conclusion (`nalq("<raven <-> crow>.")`).

  Scenario: Procedural Skill Execution (PR-01)
    Given a mock function `unlock_door` is registered with the Symbol Grounding Interface for the term `<#unlock_door>`
    And the system knows the procedural rule: `(<(*, (&, <SELF --> (is_at, door)>, <door --> (is, locked)>), <#unlock_door>)> ==> <door --> (is, unlocked)>)`
    And the system has the beliefs:
      | statement                   | truth       |
      | "<SELF --> (is_at, door)>"  | <%1.0,0.9%> |
      | "<door --> (is, locked)>"   | <%1.0,0.9%> |
    And the system has the goal: `goal: <door --> (is, unlocked)>`
    When the `OperationalRule` is applied
    Then the mock function `unlock_door` should be called
    And the system should form a new belief `<#unlock_door --> executed>`

  Scenario: Temporal-Goal Interaction (TGI-01)
    Given the system has a goal `goal: <(achieve, 'report_submission')>` with a deadline of "now + 10s"
    And the system knows two procedural rules:
      | rule                                                              |
      | `(<(*, <data --> collected>, <#submit_report>)> ==> <report_submission>)` |
      | `(<(*, <(true)>, <#collect_data>)> ==> <data --> collected>)`       |
    And both `#submit_report` and `#collect_data` are grounded operations
    And the current time is "now"
    When the system runs its reasoning cycle
    Then the task for `goal: <(achieve, 'report_submission')>` should have its budget priority increase as the deadline approaches
    And the system should first execute the `#collect_data` operation to satisfy the precondition for submitting the report.

  Scenario: Self-Optimization of System Parameters (META-05)
    Given the `CognitiveExecutive` is active
    And the system's `inferenceThreshold` is initially 0.3
    And the system is flooded with a large number of new tasks, causing the `eventQueue` size to exceed `LOW_INFERENCE_QUEUE_SIZE`
    And as a result, the `inferenceRate` metric drops below the `LOW_INFERENCE_THRESHOLD`
    When the `CognitiveExecutive`'s `selfMonitor` method is called
    Then it should detect the 'low-inference-rate' issue
    And it should adapt by lowering the system's `inferenceThreshold` to a value less than 0.3
    And a 'adaptation' event should be added to the system's diagnostic trace.

  Scenario: Concurrency Model - Actor Passivation and Awakening (CON-01)
    Given the system is running with the Actor Model enabled
    And the `Supervisor` is configured with `PASSIVATION_ACTIVATION_THRESHOLD` of 0.1
    And a concept "low_priority_concept" exists with an activation of 0.05
    When the `Supervisor` runs its passivation check due to memory pressure
    Then the actor for "low_priority_concept" should be serialized and suspended
    And when a new high-priority task related to "low_priority_concept" is injected into the system
    Then the `Supervisor` should detect the message for the passivated actor
    And the actor for "low_priority_concept" should be awakened by loading its state from storage
    And the new task should be successfully added to its task queue.
