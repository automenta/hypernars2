# Core Data Structures

This document defines the fundamental data structures of the HyperNARS system. It is the authoritative source for the structure and representation of all knowledge and processes. The data model is designed to be elegant, consistent, and "obviously implementable" by adhering to a strict conceptual hierarchy.

A core principle is the clear separation between the **content** of a thought (an Atom), its **meaning in context** (a Sentence), and the **work** it generates (a Task).

---

## 1. The Conceptual Hierarchy

The system's data is organized into three main levels of abstraction:

1.  **Atom**: The raw content of thought. A universal, context-free representation of a piece of information, directly corresponding to a MeTTa atom (`Symbol`, `Variable`, `Expression`, etc.).
    -   Example: `<bird --> flyer>`

2.  **Sentence**: An Atom placed in a specific context. It combines an Atom with **Punctuation** to define its role (e.g., as a Belief, a Goal, or a Question). This is the primary unit of knowledge.
    -   Example: A `Belief` about `<bird --> flyer>`, represented as `(Belief <bird --> flyer> (TruthValue 0.9 0.9))`.

3.  **Task**: The unit of work for the reasoning engine. It is a wrapper around a `Sentence` that provides the necessary metadata for processing, such as its attentional `Budget` and derivational `Stamp`.
    -   Example: `(Task (Belief <bird --> flyer> (TruthValue 0.9 0.9)) (Budget 0.9 0.8 0.7) (Stamp ...))`

This layered model ensures a clean separation of concerns: the Atom is the what, the Sentence is the how it's framed, and the Task is the how it's processed.

---

## 2. Core Data Structures

### 2.1. Atom

The **Atom** is the fundamental, universal data type for representing any piece of information in the system. It is directly equivalent to a MeTTa atom.
-   **Declarative Knowledge**: `(Inheritance bird animal)`
-   **Procedural Knowledge**: `(= (action-sequence (take-book) (read-book)) (knowledge-acquired))`
-   **Logical Propositions**: `(Implication (And (human $x) (sentient $x)) (mortal $x))`

### 2.2. Sentence & Punctuation

A **Sentence** gives an Atom meaning by assigning it a **Punctuation**. Punctuation specifies the type of information being conveyed.

-   **Belief**: A piece of knowledge the system holds to be true, to some degree. It is punctuated with a `TruthValue`.
-   **Goal**: A state the system desires to achieve.
-   **Question**: A request for information.
-   **Quest**: A request to explore a concept or fulfill a long-term curiosity.

### 2.3. Task

A **Task** represents a unit of work. It is a wrapper around a `Sentence` that includes all metadata required by the reasoning engine. When a new piece of information enters the system (e.g., from an API call or as the result of an inference), it is packaged into a Task and dispatched to be processed.

### 2.4. Concept

A **Concept** is an emergent structure in memory, identified by an Atom, that serves as an index for all knowledge related to that Atom. It typically stores `Sentences` (e.g., beliefs about the concept) and `Tasks` in special data structures called `Bags`.

### 2.5. Bag

A **Bag** is a probabilistic data structure used for attention management, implementing the NARS principle of Assumption of Insufficient Knowledge and Resources (AIKR). It holds a collection of items (like `Tasks` or `Concepts`) and allows for biased sampling, where items with higher priority are more likely to be selected.

Key properties include:
-   **Capacity**: A `Bag` has a maximum number of items it can hold.
-   **Eviction**: When a new item is added to a full `Bag`, an existing item with the lowest priority is removed.
-   **Priority-based Sampling**: Items are selected from the `Bag` probabilistically based on their priority.
-   **Sharpness**: A configurable parameter that controls how heavily the sampling favors high-priority items.

---

## 3. System Data Dictionary

This section provides the formal MeTTa-style type definitions and concrete examples for all primary data structures. This is the single source of truth for data representation.

### 3.1. Metadata & Wrapper Types

-   **TruthValue**: `(: TruthValue (-> Float Float TruthValue))`
    -   *Description*: Represents epistemic value (`frequency`, `confidence`).
    -   *Example*: `(TruthValue 0.9 0.8)`

-   **Budget**: `(: Budget (-> Float Float Float Budget))`
    -   *Description*: Represents attentional value (`priority`, `durability`, `quality`).
    -   *Example*: `(Budget 0.99 0.5 0.85)`

-   **Stamp**: `(: Stamp (-> TaskID (Set TaskID) Stamp))`
    -   *Description*: Tracks derivational history to prevent loops. `TaskID` is a unique string identifier.
    -   *Example*: `(Stamp "t_7f8a..." (Set "t_1c5b..." "t_9e2d..."))`

-   **Task**: `(: Task (-> Sentence Budget Stamp Task))`
    -   *Description*: The wrapper for a `Sentence` that makes it a processable unit of work.
    -   *Example*: `(Task <Sentence> <Budget> <Stamp>)`

### 3.2. Sentence Types (with Punctuation)

These define the structure of the `Sentence` atoms that are wrapped by `Tasks`.

-   **Belief Sentence**: `(: Belief (-> Atom TruthValue Belief))`
    -   *Purpose*: Represents a piece of knowledge to be processed or stored.
    -   *Example*: `(Belief <bird --> flyer> (TruthValue 0.9 0.9))`

-   **Goal Sentence**: `(: Goal (-> Atom Goal))`
    -   *Purpose*: Represents a state to be achieved.
    -   *Example*: `(Goal <door-is-open>)`

-   **Question Sentence**: `(: Question (-> Atom Question))`
    -   *Purpose*: Represents a request for information.
    -   *Example*: `(Question <what-is-a-bird>)`

-   **Quest Sentence**: `(: Quest (-> Atom Quest))`
    -   *Purpose*: Represents a long-term, curiosity-driven exploration goal.
    -   *Example*: `(Quest <discover-meaning-of-life>)`

### 3.3. Architectural & Metacognitive Schemas

-   **Event Atom**: `(: Event (-> Symbol Atom Atom TimePoint Event))`
    -   *Purpose*: Used for the internal event bus.
    -   *Example*: `(Event contradiction-detected <belief-1> <belief-2> (now))`

-   **Configuration Atom**: `(: Config (-> Atom Atom Config))`
    -   *Purpose*: Defines a configuration setting. The key is often a Symbol or an Expression.
    -   *Example*: `(Config BudgetingStrategy (GroundedAtom "SimpleBudgetingStrategy"))`
    -   *Example*: `(Config (active-cognitive-function GoalManager) True)`

-   **Key Performance Indicator (KPI) Atom**: `(: has-value (-> Atom Number has-value))`
    -   *Purpose*: Represents a belief about a system metric.
    -   *Example*: `(has-value (metric avg_belief_confidence) 0.78)`
    -   *Example*: `(has-value (metric (rule_cost Abduce)) 0.000150)`  *; in seconds*

---

## 4. Self-Monitoring Metrics

To enable self-awareness, the system materializes metrics about its own state as `KPI` atoms in Memory. This "cognitive telemetry" is essential for the `CognitiveExecutive`.

| Metric Name | Description | Data Structure | Example MeTTa Representation |
| :--- | :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all Belief sentences in Memory. | `Sentence` | `(has-value (metric avg_belief_confidence) 0.78)` |
| `avg_task_priority` | The average priority of all tasks in the system. | `Task` | `(has-value (metric avg_task_priority) 0.65)` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. | `Stamp` | `(has-value (metric stamp_overlap_rate) 0.02)` |
| `belief_count` | The total number of Belief sentences currently in Memory. | `Sentence` | `(has-value (metric belief_count) 150000)` |
| `memory_utilization`| The percentage of total memory capacity currently being used. | `Bag` | `(has-value (metric memory_utilization) 0.6)` |
| `concept_hit_rate` | % of times a selected `Concept` contains a useful `Belief` for the current `Task`. | `Concept`| `(has-value (metric concept_hit_rate) 0.35)` |
| `forgetting_rate` | The number of items being forgotten per second from `Bags`. | `Bag` | `(has-value (metric forgetting_rate) 12.5)` |
| `rule_utility` | Average `quality` of conclusions produced by a specific inference rule. | `Task` | `(has-value (metric (rule_utility Deduce)) 0.82)` |
| `rule_cost` | Average execution time for a specific inference rule, in seconds. | `Task` | `(has-value (metric (rule_cost Abduce)) 0.000150)` |
| `goal_success_rate` | The percentage of goals that are successfully achieved. | `Sentence` | `(has-value (metric goal_success_rate) 0.95)` |
| `contradiction_rate` | The percentage of new Beliefs that cause contradictions. | `Sentence` | `(has-value (metric contradiction_rate) 0.01)` |
