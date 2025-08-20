# Core Data Structures

This document defines the fundamental data structures of the HyperNARS system. It is the authoritative source for the structure and representation of all knowledge. The data model is designed to be elegant, consistent, and "obviously implementable" by adhering to a strict conceptual hierarchy.

A core principle is the unification of the **content** of a thought (an Atom) and the **work** it generates into a single, processable unit: the **Sentence**.

---
## 1. Glossary of Core Terms

This glossary provides concise definitions for the core concepts used throughout the HyperNARS specification.

| Term | Definition |
| :--- | :--- |
| **AIKR** | **Assumption of Insufficient Knowledge and Resources**. The core NARS principle that the system must operate with finite computational resources and incomplete knowledge. This guides the entire attention and resource allocation process. |
| **Atom** | The fundamental, context-free unit of information, equivalent to a MeTTa atom (Symbol, Variable, Expression). It represents the raw content of thought before it is contextualized in a `Sentence`. |
| **Bag** | A probabilistic data structure with limited capacity used to hold items (like `Sentences` or `Concepts`) and sample from them based on priority. It is the primary mechanism for implementing forgetting. |
| **Budget** | An attentional value attached to a `Sentence`, typically composed of `priority`, `durability`, and `quality`. It determines how much processing resources should be allocated to the sentence. |
| **Concept** | An emergent organizational structure in memory, identified by an `Atom`, that serves as an index for all knowledge (`Sentences`) related to that `Atom`. |
| **Cognitive Function** | A system capability, such as Goal Planning or Contradiction Management, implemented not as a rigid software module but as a collection of MeTTa atoms (rules and goals). |
| **Grounded Atom** | A special `Atom` that is bound to external, non-symbolic code (e.g., a Python function or a call to a web API). This is the primary mechanism for connecting the system's symbolic logic to the outside world. |
| **Punctuation** | A symbol (`.`, `!`, `?`, `@`) that defines the role of a `Sentence` (e.g., a Belief, Goal, Question, or Quest). |
| **Sentence** | The primary, self-contained unit of knowledge and work in the system. It consists of an `Atom`, a `Punctuation`, and all necessary processing metadata (`Truth`, `Budget`, `Stamp`). |
| **Stamp** | A record of derivational history attached to a `Sentence`. It is used to prevent infinite inference loops by tracking which parent sentences were used to create it. |
| **System 1** | **Reflexive Reasoning**. The default, high-throughput, and efficient mode of operation. It is a continuous cycle of selecting and processing sentences based on local context and relevance. |
| **System 2** | **Deliberative Reasoning**. A resource-intensive, goal-driven reasoning process initiated by the `Cognitive Executive` to handle complex situations like contradictions or strategic planning. |
| **Truth** | An epistemic value attached to a Belief `Sentence`, typically composed of `frequency` and `confidence`. It represents the system's degree of belief in the sentence's content. |

---

## 2. The Conceptual Hierarchy

The system's data is organized into two main levels of abstraction:

1.  **Atom**: The raw content of thought. A universal, context-free representation of a piece of information, directly corresponding to a MeTTa atom (`Symbol`, `Variable`, `Expression`, etc.).
    -   Example: `(bird --> flyer)`

2.  **Sentence**: An Atom placed in a specific context. It combines an Atom with **Punctuation** (e.g., `.`, `!`, `?`, `@`) to define its role, and includes all necessary processing metadata like `Truth`, `Budget`, and `Stamp`. This is the primary unit of knowledge and work.
    -   Example: A belief about `(bird --> flyer)`, represented as `(. (bird --> flyer) (Truth 0.9 0.9) (Budget 0.9 0.8 0.7) (Stamp ...))`.

This layered model ensures a clean, efficient representation where any piece of knowledge is immediately a processable unit.

---

## 3. Core Data Structures

### 3.1. Atom

The **Atom** is the fundamental, universal data type for representing any piece of information in the system. It is directly equivalent to a MeTTa atom.
-   **Declarative Knowledge**: `(Inheritance bird animal)`
-   **Procedural Knowledge**: `(= (action-sequence (take-book) (read-book)) (knowledge-acquired))`
-   **Logical Propositions**: `(Implication (And (human $x) (sentient $x)) (mortal $x))`

### 3.2. Sentence & Punctuation

A **Sentence** is the primary unit of knowledge and processing. It gives an Atom meaning by assigning it a **Punctuation** and attaching all relevant metadata. Punctuation specifies the type of information being conveyed using the NARS convention.

-   **Belief (.)**: A piece of knowledge the system holds to be true, to some degree. It is punctuated with a `Truth` value.
-   **Goal (!)**: A state the system desires to achieve.
-   **Question (?)**: A request for information.
-   **Quest (@)**: A long-term, curiosity-driven goal that prompts open-ended exploration rather than seeking a specific answer.

All sentences include a `Budget` (attentional value) and a `Stamp` (derivational history) to manage their processing.

### 3.3. Concept

A **Concept** is an emergent structure in memory, identified by an Atom, that serves as an index for all knowledge related to that Atom. It typically stores `Sentences` in special data structures called `Bags`.

### 3.4. Bag

A **Bag** is a probabilistic data structure used for attention management, implementing the NARS principle of Assumption of Insufficient Knowledge and Resources (AIKR). It holds a collection of items (like `Sentences` or `Concepts`) and allows for biased sampling, where items with higher priority are more likely to be selected.

Key properties include:
-   **Capacity**: A `Bag` has a maximum number of items it can hold.
-   **Eviction**: When a new item is added to a full `Bag`, an existing item with the lowest priority is removed.
-   **Priority-based Sampling**: Items are selected from the `Bag` probabilistically based on their priority.
-   **Sharpness**: A configurable parameter that controls how heavily the sampling favors high-priority items.

---

## 4. System Data Dictionary

This section provides the formal MeTTa-style type definitions and concrete examples for all primary data structures. This is the single source of truth for data representation.

> **Note on Examples:** For clarity and brevity, the `Budget` and `Stamp` metadata are often omitted from the examples in this and other documents unless they are directly relevant to the point being illustrated.

### 4.1. Metadata Types

-   **Truth**: `(: Truth (-> Float Float Truth))`
    -   *Description*: Represents epistemic value (`frequency`, `confidence`).
    -   *Plain English*: "How much the system believes something is true."
    -   *Example*: `(Truth 0.9 0.8)`

-   **Budget**: `(: Budget (-> Float Float Float Budget))`
    -   *Description*: Represents attentional value (`priority`, `durability`, `quality`).
    -   *Plain English*: "How much attention the system should pay to something."
    -   *Example*: `(Budget 0.99 0.5 0.85)`

-   **Stamp**: `(: Stamp (-> TaskID (Set TaskID) Stamp))`
    -   *Description*: Tracks derivational history to prevent loops. `TaskID` is a unique string identifier.
    -   *Plain English*: "A 'paper trail' to track where a piece of information came from."
    -   *Example*: `(Stamp "t_7f8a..." (Set "t_1c5b..." "t_9e2d..."))`

### 4.2. Sentence Types (with Punctuation)

These define the structure of the `Sentence` atoms. Note that `Budget` and `Stamp` are optional for question/quest types, but are shown for completeness.

-   **Belief Sentence (.)**: `(: . (-> Atom Truth Budget Stamp .))`
    -   *Purpose*: Represents a piece of knowledge to be processed or stored.
    -   *Plain English*: "A statement of fact, like 'the sky is blue'."
    -   *Example*: `(. (bird --> flyer) (Truth 0.9 0.9) (Budget 0.9 0.8 0.7) (Stamp ...))`

-   **Goal Sentence (!)**: `(: ! (-> Atom Budget Stamp !))`
    -   *Purpose*: Represents a state to be achieved.
    -   *Plain English*: "A desired state, like 'the light is on'."
    -   *Example*: `(! (door-is-open) (Budget 0.9 0.5 0.8) (Stamp ...))`

-   **Question Sentence (?)**: `(: ? (-> Atom Budget Stamp ?))`
    -   *Purpose*: Represents a request for information.
    -   *Plain English*: "A request for information, like 'what color is the sky?'."
    -   *Example*: `(? (what-is-a-bird) (Budget 0.9 0.1 0.2) (Stamp ...))`

-   **Quest Sentence (@)**: `(: @ (-> Atom Budget Stamp @))`
    -   *Purpose*: Represents a long-term, curiosity-driven exploration goal.
    -   *Plain English*: "An open-ended exploration task, like 'investigate the properties of birds'."
    -   *Example*: `(@ (explore-concept bird) (Budget 0.8 0.9 0.9) (Stamp ...))`

### 4.3. Architectural & Metacognitive Schemas

-   **Event Atom**: `(: Event (-> Symbol Atom Atom TimePoint Event))`
    -   *Purpose*: Used for the internal event bus.
    -   *Plain English*: "A notification that something has happened, like 'a contradiction was found'."
    -   *Example*: `(Event contradiction-detected (belief-1) (belief-2) (now))`

-   **Configuration Atom**: `(: Config (-> Atom Atom Config))`
    -   *Purpose*: Defines a configuration setting. The key is often a Symbol or an Expression.
    -   *Plain English*: "A setting that controls how the system behaves."
    -   *Example*: `(Config BudgetingStrategy (GroundedAtom "SimpleBudgetingStrategy"))`
    -   *Example*: `(Config (active-cognitive-function GoalManager) True)`

-   **Key Performance Indicator (KPI) Atom**: `(: has-value (-> Atom Number has-value))`
    -   *Purpose*: Represents a belief about a system Key Performance Indicator (KPI).
    -   *Plain English*: "A belief about the system's own performance."
    -   *Example*: `(has-value (kpi avg_belief_confidence) 0.78)`
    -   *Example*: `(has-value (kpi (rule_cost Abduce)) 0.000150)`  *; in seconds*

---

## 5. Self-Monitoring KPIs

To enable self-awareness, the system materializes its own state and performance as **Key Performance Indicator (KPI)** atoms in Memory. This "cognitive telemetry" is essential for the `CognitiveExecutive`.

| KPI Name | Description | Data Structure | Example MeTTa Representation |
| :--- | :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all belief sentences in Memory. | `Sentence` | `(has-value (kpi avg_belief_confidence) 0.78)` |
| `avg_task_priority` | The average priority of all sentences in the system. | `Sentence` | `(has-value (kpi avg_task_priority) 0.65)` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. | `Stamp` | `(has-value (kpi stamp_overlap_rate) 0.02)` |
| `belief_count` | The total number of belief sentences currently in Memory. | `Sentence` | `(has-value (kpi belief_count) 150000)` |
| `memory_utilization`| The percentage of total memory capacity currently being used. | `Bag` | `(has-value (kpi memory_utilization) 0.6)` |
| `concept_hit_rate` | % of times a selected `Concept` contains a useful belief for the current `Sentence`. | `Concept`| `(has-value (kpi concept_hit_rate) 0.35)` |
| `forgetting_rate` | The number of items being forgotten per second from `Bags`. | `Bag` | `(has-value (kpi forgetting_rate) 12.5)` |
| `rule_utility` | Average `quality` of conclusions produced by a specific inference rule. | `Sentence` | `(has-value (kpi (rule_utility Deduce)) 0.82)` |
| `rule_cost` | Average execution time for a specific inference rule, in seconds. | `Sentence` | `(has-value (kpi (rule_cost Abduce)) 0.000150)` |
| `goal_success_rate` | The percentage of goals that are successfully achieved. | `Sentence` | `(has-value (kpi goal__success_rate) 0.95)` |
| `contradiction_rate` | The percentage of new beliefs that cause contradictions. | `Sentence` | `(has-value (kpi contradiction_rate) 0.01)` |
| `index_lookup_time` | The average time taken to retrieve an item from a memory index. | `Concept` | `(has-value (kpi index_lookup_time) (2 milliseconds))` |
| `lti_distribution` | A histogram of the Long-Term Importance (LTI) values of all items in memory. | `Budget` | `(has-value (kpi lti_distribution) (histogram ...))` |

---

## 6. Conceptual Distinctions

To clarify the roles of the primary sentence types, this section provides a direct comparison.

### 6.1. Belief vs. Goal vs. Question vs. Quest

While all are types of `Sentence` atoms, they represent fundamentally different intentions and drive different system behaviors.

| Sentence Type | System's Stance | Example | Typical System Response |
| :--- |:---|:---|:---|
| **Belief (.)** | "This is a fact." | `(. (sky-is-blue) ...)` | Store this information; use it as a premise in future reasoning. |
| **Goal (!)** | "I want this to be true." | `(! (light-is-on) ...)` | Find a sequence of actions (a plan) to make the content true. |
| **Question (?)** | "What is the answer to this?" | `(? (what-color-is sky) ...)` | Search memory for relevant beliefs to derive a specific answer. |
| **Quest (@)** | "Explore this concept." | `(@ (explore-concept bird) ...)` | Initiate open-ended reasoning about the concept to discover new knowledge and connections, without a single correct answer. |
