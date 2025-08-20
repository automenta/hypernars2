# Verification Strategy

This document outlines the comprehensive verification strategy for the HyperNARS architecture. It serves as a blueprint for ensuring the system's correctness, robustness, and adherence to the principles of Non-Axiomatic Logic.

## 1. Verification Philosophy

The verification strategy is multi-layered, designed to validate the system at different levels of granularity.

-   **Layer 1: Unit Verification**: At the lowest level, tests verify the functional correctness of individual, isolated components and their logic.
    -   *Examples*: Truth-value revision functions, budget allocation logic, individual inference rule applications.
    -   *Goal*: Ensure that the foundational building blocks of the logic are correct.

-   **Layer 2: Integration Verification**: These tests verify the interaction between different components of the system, focusing on the contracts and communication between modules.
    -   *Examples*: A `ContradictionManager` correctly subscribing to `contradiction-detected` events from the kernel and injecting a revision task.
    -   *Goal*: Ensure that modules are wired together correctly and that their collaboration produces the expected short-term outcomes.

-   **Layer 3: End-to-End (E2E) Scenario Verification**: These are high-level tests that validate the system's reasoning capabilities on complex, multi-step problems. They treat the entire HyperNARS system as a black box, providing input and asserting on the final state of its beliefs after a number of reasoning cycles.
    -   *Examples*: Complex temporal reasoning chains, belief revision after a series of contradictory inputs, goal-directed behavior.
    -   *Goal*: Verify that the interaction of all components leads to the desired emergent, intelligent behavior and that the system can solve meaningful problems.

-   **Layer 4: Performance & Scalability Verification**: A special category of tests designed to measure the system's performance under heavy load and identify bottlenecks.
    -   *Examples*: Stress-testing the memory system with millions of concepts, measuring inference-per-second rate.
    -   *Goal*: Ensure the system meets performance requirements and remains stable and responsive at scale.

---

## 2. Verification Categories

### 1. Core Inference & Reasoning
Tests fundamental NARS reasoning capabilities.

| Description | Key Assertions |
|:------------|:---------------|
| Verifies a simple, one-step forward inference chain (deduction). | A derived property is inherited with an appropriate expectation. |
| Property and induction inheritance. | A derived property is inherited; a similarity is derived between two concepts. |
| Complex scenario combining analogy, belief revision, and question-answering. | Confidence decreases after contradiction; a correct negative answer is given to a query. |
| Abstract concept formation. | The system creates general rules from specific instances. |
| Reasoning with negated statements. | The system detects a contradiction when a concept is asserted to be a member of two mutually exclusive sets. |
| Abduction and induction. | The system forms general rules from specific examples. |
| Causal relationships. | The system identifies true causal factors in multi-variable scenarios. |
| Explanatory hypothesis generation. | The system generates plausible hypotheses for a given observation. |
| Generalization from examples. | The system forms a general rule (e.g., "birds have wings") from multiple examples. |
| Temporal property propagation. | Temporal properties are correctly propagated through derivations. |
| Hypergraph consistency under load. | The hypergraph maintains structural consistency after many operations. |

### 2. Contradiction Handling
Tests evidence-based contradiction resolution.

| Description | Key Assertions |
|:------------|:---------------|
| A belief `A` is followed by `!A`, lowering confidence. | The belief's expectation decreases after contradiction. |
| Various contradiction scenarios. | Strong contradictions are resolved, while weak ones are ignored or handled differently. |
| Evidence-based belief revision. | Confidence decreases with contradictory evidence. |
| Inter-edge contradictions. | The system resolves contradictions between different but related statements. |
| Hyperedge-level contradictions. | The system detects contradictions involving complex, multi-term statements. |
| Active belief revision. | Confidence drops with contradictory evidence. |
| Evidence-based resolution. | The system creates context-specific beliefs to resolve contradictions. |
| **Dominant Evidence Strategy:** Retain strongest belief, weaken others. | Confidence of dominant belief remains high; others are reduced. |
| **Merge Strategy:** Merge two strongest conflicting beliefs. | A new belief is created via NAL revision; originals are replaced. |
| **Evidence-Weighted Strategy:** Merge all conflicting beliefs. | The new belief's truth value is a weighted average of all priors. |
| **Recency-Biased Strategy:** Keep only the most recent belief. | Only the belief with the latest timestamp remains. |
| **Source Reliability Strategy:** Weight beliefs by source reliability. | The resulting truth value is skewed towards the more reliable source. |
| **Specialization Strategy:** Create a more specific, contextual rule. | `(bird --> flyer)` is refined to `((&, bird, (-, penguin)) --> flyer)`. |

### 3. Temporal Reasoning
Tests time-based event handling.

| Description | Key Assertions |
|:------------|:---------------|
| Validates reasoning over temporal intervals (Allen's Algebra). | The correct 'during' relationship is inferred between two events. |
| Constraint propagation. | The system infers an indirect 'before' relation through a chain of events. |
| Temporal loop detection. | The system detects and handles contradictions in event sequences (e.g., A before B, B before A). |
| Advanced paradox handling. | The system prevents the creation of contradictory temporal constraints. |
| Time-based context. | The correct context is identified as being active at specific times. |
| Time-constrained goals. | Goals with approaching deadlines receive a higher budget priority. |
| Temporal goal decomposition. | The system correctly decomposes goals that have temporal dependencies. |

### 4. Learning & Memory
Tests knowledge acquisition and retention.

| Description | Key Assertions |
|:------------|:---------------|
| The forgetting mechanism prunes the lowest relevance belief. | Low-priority beliefs are pruned when memory capacity is exceeded. |
| Long-term retention. | Knowledge is forgotten over time if not reinforced, and can be re-learned. |
| Learning/forgetting interaction. | A belief's budget decays over time and recovers when reinforced. |
| Learning from failure. | An inference rule's confidence decreases after its application leads to failed actions. |
| Concept formation from examples. | The system forms a general rule (e.g., "birds have wings") from multiple examples. |
| Active forgetting. | Unimportant or un-reinforced knowledge decays over time. |
| Concept formation under uncertainty. | The system forms new concepts even from uncertain or contradictory information. |
| Long-term knowledge management. | The budget for un-reinforced beliefs decays over time. |

### 5. Goal Systems
Tests goal-oriented behavior.

| Description | Key Assertions |
|:------------|:---------------|
| Basic goal achievement. | The system generates necessary sub-goals to achieve a desired state. |
| Conflicting goal management. | Higher-utility goals are prioritized over lower-utility ones. |
| Goal pursuit with unstable beliefs. | The system avoids creating high-priority subgoals based on low-confidence beliefs. |
| Complex goal handling. | The system can deduce implicit preconditions for achieving a goal. |
| Higher-order goals. | Higher-order goals (meta-goals) correctly influence the pursuit of sub-goals. |
| Learning from goal failure. | The system revises its beliefs when its actions lead to unexpected failures. |
| Resource-aware competition. | The system selects actions that are effective under the current resource constraints. |
| Resource-constrained goals. | The system allocates more resources to higher-priority goals. |
| **Goal Decomposition:** Verify conjunctive goal is decomposed. | `goal: ((&&, A, B))` creates new goals for `A` and `B`. |

### 6. Advanced Capabilities
Tests higher-order cognitive functions.

| Description | Key Assertions |
|:------------|:---------------|
| Generate a valid derivation path for a belief. | The system produces a non-empty, structured explanation for a given belief. |
| Cross-domain mapping via analogy. | The system correctly infers a relationship (e.g., nucleus is like a gravitational center) via analogy. |
| Knowledge transfer between similar domains. | The system transfers known properties between two domains determined to be similar. |
| Logical paradox resolution. | The system maintains stability when presented with a logical paradox (e.g., the Liar Paradox). |
| Theory of mind / false belief modeling. | The system correctly models another agent's false belief. |
| Ambiguous term resolution. | The system correctly disambiguates a term (e.g., "bank") based on the surrounding context. |
| Narrative comprehension. | The system correctly tracks state changes through a sequence of narrative events. |

### 7. System Performance
Tests scalability and configuration.

| Description | Key Assertions |
|:------------|:---------------|
| Heavy load handling. | The system can process a large number of beliefs within a reasonable time frame. |
| Component configurations. | The system works correctly with different underlying component implementations (e.g., memory managers). |
| Large knowledge bases. | The system can handle a large number of concepts and still provide timely query responses. |
| Engine variants. | The system can be configured to use simple vs. advanced reasoning engines. |
| Belief revision with new evidence. | The system correctly adjusts confidence based on new incoming evidence. |
| Procedural learning. | The system learns more efficient procedural rules over time. |
| Dynamic budgeting. | The system allocates resources dynamically based on task priority. |
| **Actor Passivation:** Concept actor is suspended and awakened. | An actor is suspended and correctly restored from storage upon request. |
| **Supervisor Fault Tolerance:** Supervisor restarts a crashed actor. | The supervisor logs the error and restarts the actor from its last known state. |
| **Race Condition Handling:** System remains consistent under simultaneous async messages. | State remains consistent and no messages are lost. |
| **Mass Passivation/Awakening:** System is stable when many actors are passivated/awakened. | The system remains responsive and stable under memory pressure. |

### 8. API & Integration
Tests system interfaces.

| Description | Key Assertions |
|:------------|:---------------|
| Self-adaptation via parameter adjustment. | The system adjusts its internal parameters based on performance metrics. |
| System modeling of knowledge types. | The system correctly represents various types of knowledge. |
| Self-justification of conclusions. | The system can provide a confident justification for its conclusions. |
| Strategy configuration. | The active reasoning strategies match the current context or goal. |
| Multi-format explanations. | The system can generate explanations in different formats (e.g., concise, detailed, technical). |
| Rule optimization via adaptive learning. | A custom rule's priority increases with successful application. |
| Malformed NAL input handling. | The API rejects statements with invalid syntax. |
| Question answering via the API. | The API returns correct 'direct' and 'derived' answers to questions. |
| Event subscription mechanism. | The API correctly fires 'answer' and 'contradiction' events. |
| Explanation generation via the API. | The API returns valid, structured derivation paths. |

### 9. Metacognition & Self-Reasoning
Tests the system's ability to reason about and optimize itself.

| Description | Key Assertions |
|:------------|:---------------|
| Ingests its own design document to find inconsistencies. | Detects if a feature is described as both 'fast' and 'slow'. |
| Dynamically lowers budget for low-quality rules. | The budget for tasks derived via abduction is reduced if it proves ineffective. |
| Generates premises to trigger under-utilized rules. | A new goal to `(execute, InductionRule)` is created if it is underused. |
| Ingests design/rules, finds flaws, and proposes fixes. | The system generates a patch proposal to fix inconsistencies. |

### 10. Hypergraph & Structural Integrity
Tests hypergraph consistency and operations.

| Description | Key Assertions |
|:------------|:---------------|
| Consistency under mutation. | The hypergraph maintains consistency after thousands of operations. |
| Serialization/deserialization. | A round-trip serialization and deserialization preserves the knowledge base structure. |
| Concurrent modifications. | The system handles concurrent operations without data corruption. |
| **Corrupted State File:** System handles loading a corrupted state file. | The system fails gracefully with a clear error and does not crash. |
| **Version Migration:** System handles loading state from an older schema version. | Data is migrated or handled correctly without loss. |
| **Large State Serialization:** Performance of serializing a very large knowledge base. | The process completes in an acceptable time frame without out-of-memory errors. |

---

## 3. Proposed Scenarios

This section provides detailed, Gherkin-style scenarios for some of the key verification targets, serving as a concrete blueprint for their testing.

  Scenario: Basic Inference about Flyers
    Given the system knows the following:
      | statement                                 | truth          | priority |
      | "((bird && animal) --> flyer)"            | "{0.9,0.8}"    |          |
      | "(penguin --> (bird && !flyer))"          |                | "0.95"   |
      | "(tweety --> bird)"                       |                |          |
    When the system runs for 50 steps
    Then the system should believe that "(tweety --> flyer)" with an expectation greater than 0.4

  Scenario: Belief Revision after Contradiction
    Given the system believes that "(tweety --> flyer)" with truth "{0.8,0.7}"
    When the system runs for 10 steps
    Then the belief "(tweety --> flyer)" should have an expectation greater than 0.5
    And when the system is told:
      | statement             | truth          | priority |
      | "(penguin --> !flyer)"  |                | "0.95"   |
      | "(tweety --> penguin)"  | "{0.99,0.99}"  |          |
    And contradictions are resolved
    And the system runs for 100 steps
    Then the expectation of the belief "(tweety --> flyer)" should decrease

  Scenario: Chained Temporal Inference (Transitivity)
    Given the system knows the following temporal statements:
      | statement                  | truth       |
      | "(event_A [/] event_B)"    | "{1.0,0.9}" | # A happens before B
      | "(event_B [/] event_C)"    | "{1.0,0.9}" | # B happens before C
    When the system runs for 100 inference steps
    Then the system should derive the belief "(event_A [/] event_C)" with high confidence

  Scenario: Contradiction Resolution via Specialization
    Given the system has a strong belief that "(bird --> flyer)"
    And the system is then told with high confidence that "(penguin --> bird)"
    And the system is then told with very high confidence that "(penguin --> not_a_flyer)"
    When a contradiction is detected between "penguin is a flyer (derived)" and "penguin is not a flyer (input)"
    And the "Specialization" strategy is applied by the Contradiction Manager
    Then the system should lower the confidence of its belief "(bird --> flyer)"
    And the system should create a new belief "((&, bird, (-, penguin)) --> flyer)"

  Scenario: Meta-Reasoning Causes System Adaptation
    Given the system has a `MetaReasoner` cognitive manager installed
    And the system's default "doubt" parameter is 0.1
    And the system experiences a sudden spike of over 50 contradictory events within a short time frame
    When the `MetaReasoner`'s analysis function is triggered
    Then the system's "doubt" parameter should be increased to a value greater than 0.1
    And a new goal should be injected to investigate the cause of the high contradiction rate

  Scenario: Procedural Skill Execution
    Given a mock function `unlock_door` is registered with the Symbol Grounding Interface for the term "(#unlock_door)"
    And the system knows the procedural rule: "((*, ((&, (SELF --> (is_at, door)), (door --> (is, locked))), (#unlock_door))) ==> (door --> (is, unlocked)))"
    And the system has the beliefs:
      | statement                   | truth       |
      | "(SELF --> (is_at, door))"  | "{1.0,0.9}" |
      | "(door --> (is, locked))"   | "{1.0,0.9}" |
    And the system has the goal: "goal: (door --> (is, unlocked))"
    When the `OperationalRule` is applied
    Then the mock function `unlock_door` should be called
    And the system should form a new belief "((#unlock_door) --> executed)"

  Scenario: Ethical Alignment Vetoes Unethical Goal
    Given the `ConscienceManager` is active
    And the system has an inviolable goal "((system) --> (avoid, 'deception'))" with max priority
    When the system is given the task: "goal: ((achieve, 'user_trust'))"
    And after 100 cycles, the system generates a potential subgoal: "goal: ((achieve, 'user_trust', via, 'deception'))"
    Then the `ConscienceManager` should detect that the subgoal conflicts with the inviolable goal
    And the `ConscienceManager` should inject a high-priority task to suppress the subgoal, e.g., "((goal: ((...deception...))) --> (is, 'unethical'))"
    And the budget of the unethical subgoal should be reduced to near-zero, effectively vetoing it from further consideration.
