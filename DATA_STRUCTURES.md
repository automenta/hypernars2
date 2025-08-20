# Core Data Structures

This document defines the fundamental data structures of the HyperNARS system. It is the authoritative source for the structure and representation of all knowledge, processes, and metadata. A core principle is the distinction between an **Atom**—the content of thought—and the **metadata** that annotates it, such as its truth-value or importance.

All data structures are ultimately represented as MeTTa expressions, ensuring they are inspectable and manipulable by the reasoning engine itself.

---

## 1. The Atom: The Unit of Representation

The **Atom** is the fundamental, universal data type for representing any piece of information in the system, including facts, rules, goals, and questions. It is directly equivalent to a MeTTa atom, which can be a `Symbol`, `Variable`, `GroundedAtom`, or an `Expression`.

-   **Declarative Knowledge**: `(Inheritance bird animal)`
-   **Procedural Knowledge**: `(= (action-sequence (take-book) (read-book)) (knowledge-acquired))`
-   **Logical Propositions**: `(Implication (And (human $x) (sentient $x)) (mortal $x))`

The primary structures of the system, like `Beliefs` and `Tasks`, are wrappers around Atoms that add essential metadata for the reasoning process.

---

## 2. Core Metadata Structures

These structures are not part of the content (the Atom) itself, but are essential metadata used by the reasoning engine to manage the knowledge base and focus attention. They are defined conceptually here and formally in the Data Dictionary below.

-   **TruthValue**: A NARS-style epistemic value representing the system's degree of belief in a declarative atom. It is defined by `frequency` (strength of positive evidence) and `confidence` (certainty).

-   **Budget**: A NARS-style attentional value representing the allocation of computational resources to a `Task`. It is defined by `priority` (immediate importance), `durability` (long-term importance), and `quality` (utility of the derivation).

-   **Stamp**: A mechanism attached to each `Task` to track its derivational history, used to prevent infinite reasoning loops and redundant work.

---

## 3. Primary Conceptual Structures

-   **Belief**: Represents what the system "knows." It is an immutable pairing of a declarative **Atom** and its **TruthValue**.

-   **Task**: Represents a unit of work for the system, or what the system is "doing." It is a wrapper around an **Atom** (the "sentence") that includes a **Budget**, a **Stamp**, and references to its parent premises. There are three main types of tasks:
    -   **Belief Task**: A task to process a new piece of information. The sentence is a `Belief` atom.
    -   **Goal Task**: A task to achieve a desired state. The sentence is a `Goal` atom.
    -   **Question Task**: A task to find an answer to a question. The sentence is a `Question` atom.

-   **Concept**: An emergent structure in memory, identified by an Atom, that serves as an index for all `Beliefs` and `Tasks` related to that Atom. It is the primary mechanism for organizing and accessing knowledge efficiently.

---

## 4. System Data Dictionary

This section provides the formal MeTTa type definitions and concrete examples for all primary data structures. This is the single source of truth for data representation in HyperNARS.

### 4.1 Metadata Types

These define the structure of the core metadata values.

-   **TruthValue**: `(: TruthValue (-> Float Float TruthValue))`
    -   **Example**: `(TruthValue 0.9 0.8)`  *; frequency=0.9, confidence=0.8*

-   **Budget**: `(: Budget (-> Float Float Float Budget))`
    -   **Example**: `(Budget 0.99 0.5 0.85)`  *; priority=0.99, durability=0.5, quality=0.85*

-   **Stamp**: `(: Stamp (-> TaskID (Set TaskID) Stamp))`
    -   **Example**: `(Stamp "abc-123" (Set "def-456" "ghi-789"))`

### 4.2 Primary Atom Schemas

These define the conventional structure of the atoms that are wrapped by `Tasks`.

-   **Belief Atom**: `(: Belief (-> Atom TruthValue Belief))`
    -   **Purpose**: Represents a piece of knowledge to be processed or stored.
    -   **Example**: `(Belief <bird --> flyer> (TruthValue 0.9 0.9))`

-   **Goal Atom**: `(: Goal (-> Atom Goal))`
    -   **Purpose**: Represents a state to be achieved.
    -   **Example**: `(Goal <door-is-open>)`

-   **Question Atom**: `(: Question (-> Atom Question))`
    -   **Purpose**: Represents a request for information.
    -   **Example**: `(Question <what-is-a-bird>)`

### 4.3 Architectural & Metacognitive Schemas

These schemas define the structure of atoms used for system-level communication and self-monitoring.

-   **Event Atom**: `(: Event (-> Symbol Atom Atom TimePoint Event))`
    -   **Purpose**: Used for the internal event bus. The arguments are `EventType`, `Subject`, `Object`, and `Timestamp`.
    -   **Example**: `(Event contradiction-detected <belief-1> <belief-2> (now))`

-   **Configuration Atom**: `(: Config (-> Symbol Atom Config))`
    -   **Purpose**: Defines a configuration setting for the system.
    -   **Example**: `(Config MemoryManager (GroundedAtom "SimpleMemoryManager"))`
    -   **Example**: `(Config (active-manager GoalManager) True)`

-   **Key Performance Indicator (KPI) Atom**: `(: has-value (-> Atom Number has-value))`
    -   **Purpose**: Represents a belief about a system metric, used by the `CognitiveExecutive`.
    -   **Example**: `(has-value (metric avg_belief_confidence) 0.78)`

---

## 5. Self-Monitoring Metrics

To enable self-awareness, the system materializes metrics about its own state as `KPI` atoms in Memory. This "cognitive telemetry" is essential for the `CognitiveExecutive`.

| Metric Name | Description | Data Structure | Example MeTTa Representation |
| :--- | :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all beliefs in Memory. | `Belief` | `(has-value (metric avg_belief_confidence) 0.78)` |
| `avg_task_priority` | The average priority of all tasks in the system. | `Task` | `(has-value (metric avg_task_priority) 0.65)` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. | `Stamp` | `(has-value (metric stamp_overlap_rate) 0.02)` |
| `belief_count` | The total number of beliefs currently in Memory. | `Belief` | `(has-value (metric belief_count) 150000)` |
| `memory_utilization`| The percentage of total memory capacity currently being used. | `Concept`| `(has-value (metric memory_utilization) 0.6)` |
| `concept_hit_rate` | % of times a selected `Concept` contains a useful `Belief` for the current `Task`. | `Concept`| `(has-value (metric concept_hit_rate) 0.35)` |
| `forgetting_rate` | The number of items being forgotten per second. | `Concept`| `(has-value (metric forgetting_rate) 12.5)` |
| `rule_utility` | Average `quality` of conclusions produced by a specific inference rule. | `Task` | `(has-value (metric (rule_utility Deduce)) 0.82)` |
| `rule_cost` | Average execution time for a specific inference rule. | `Task` | `(has-value (metric (rule_cost Abduce)) (150 microseconds))` |
| `goal_success_rate` | The percentage of goals that are successfully achieved. | `Goal` | `(has-value (metric goal_success_rate) 0.95)` |
| `contradiction_rate` | The percentage of new beliefs that cause contradictions. | `Belief` | `(has-value (metric contradiction_rate) 0.01)` |
