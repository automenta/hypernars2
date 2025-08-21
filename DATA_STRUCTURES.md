# Core Data Structures

This document defines the fundamental data structures of the HyperNARS system. It is the authoritative source for the structure and representation of all knowledge. The data model is designed to be elegant, consistent, and "obviously implementable" by adhering to a strict conceptual hierarchy.

A core principle is the unification of the **content** of a thought (an Atom) and the **work** it generates into a single, processable unit: the **Sentence**.

---
## 1. Glossary of Core Terms

This glossary provides authoritative definitions for the core concepts used throughout the HyperNARS specification. It is the single source of truth for all terminology.

| Term | Definition |
| :--- | :--- |
| **AIKR** | **Assumption of Insufficient Knowledge and Resources**. The core NARS principle that the system must operate with finite computational resources and incomplete knowledge. This guides the entire attention and resource allocation process. |
| **Atom** | The fundamental, context-free unit of information, equivalent to a MeTTa atom (e.g., a Symbol, Variable, or Expression). It represents the raw content of thought before it is contextualized in a `Sentence`. |
| **Bag** | A probabilistic data structure with limited capacity used to hold items (like `Sentences` or `Concepts`) and sample from them based on priority. It is the primary mechanism for implementing forgetting under AIKR. |
| **Budget** | An attentional value attached to a `Sentence` or `Concept`, determining how much processing resources should be allocated to it. It is typically composed of `priority`, `durability`, and `quality`. In some attention allocation models, these correspond to **STI (Short-Term Importance)** and **LTI (Long-Term Importance)**. |
| **Cognitive Executive** | A Layer 2 cognitive function responsible for monitoring the system's overall performance via KPIs, detecting anomalies (like high contradiction rates), and initiating System 2 deliberative reasoning to address them. |
| **Cognitive Function** | A system capability (e.g., Goal Planning, Contradiction Management) implemented not as a rigid software module but as a collection of MeTTa atoms (rules and goals) that operate on the shared memory space. |
| **Concept** | An emergent organizational structure in memory, identified by a unique `Atom`, that serves as an index for all knowledge (`Sentences`) related to that `Atom`. |
| **ECAN** | **Economic Attention Allocation**. A specific model for attention allocation where `Budget` values (STI/LTI) are managed and distributed in a way that resembles an economy, rewarding useful knowledge. |
| **Grounded Atom** | A special `Atom` that is bound to external, non-symbolic code (e.g., a Python function, a call to a web API, or an ML model). This is the primary mechanism for connecting the system's symbolic logic to the outside world. |
| **Hypergraph / Metagraph** | The data structure of the main Memory space. It is a graph where an edge (an `Atom`) can connect any number of vertices (`Concept`s). The term **Metagraph** is used to emphasize that atoms can also connect to other atoms, allowing for nested, self-referential knowledge. |
| **LTI** | **Long-Term Importance**. A component of some `Budget` models (like ECAN) that represents the long-term value or usefulness of an item. It increases when an item is involved in successful, high-quality inferences and corresponds to NARS's `durability`. |
| **MeTTa** | **Meta Type Talk**. The core language of Hyperon used in HyperNARS. It is a metaprogrammable, symbolic language designed for representing and transforming knowledge atoms. |
| **NARS** | **Non-Axiomatic Reasoning System**. A reasoning system designed to work under AIKR. HyperNARS is a next-generation implementation of NARS principles using the MeTTa language. |
| **Punctuation** | A symbol (`.`, `!`, `?`, `@`) that defines the role and type of a `Sentence`: a Belief (`.`), Goal (`!`), Question (`?`), or Quest (`@`). |
| **Sentence** | The primary, self-contained unit of knowledge and work in the system. It consists of an `Atom` (the content), a `Punctuation` (the type), and all necessary processing metadata (`Truth`, `Budget`, `Stamp`). |
| **Space** | A knowledge store. The main memory is a MeTTa `Space`, but the system can interface with other specialized `Spaces`, such as vector databases or external knowledge graphs, typically via `Grounded Atoms`. |
| **Stamp** | A record of derivational history attached to a `Sentence`. It is used to prevent infinite inference loops by tracking which parent sentences were used to create it. |
| **STI** | **Short-Term Importance**. A component of some `Budget` models (like ECAN) that represents the immediate relevance of an item. It spikes when an item is accessed and decays over time, corresponding to NARS's `priority`. |
| **System 1 (Reflexive Reasoning)** | The default, high-throughput, and efficient mode of operation. It is a continuous cycle of selecting and processing sentences based on local context and relevance. It executes Layer 1 Cognitive Functions. |
| **System 2 (Deliberative Reasoning)** | A resource-intensive, goal-driven reasoning process initiated by the `Cognitive Executive` to handle complex situations like contradictions or strategic planning. It executes Layer 2 and 3 Cognitive Functions. |
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

This section provides the formal MeTTa-style type definitions for all primary data structures. This is the single, authoritative, machine-readable source of truth for data representation. The definitions below are expressed in MeTTa and are intended to be loaded directly into a HyperNARS system's memory.

> **Note:** The `Purpose` and `Plain English` descriptions are for human readability. A running system would primarly use the formal `Schema`.

```metta
;;;
;;; Authoritative Data Dictionary for HyperNARS
;;;
;;; This knowledge base defines the core data types of the system.
;;; It uses a `define-type` schema for clarity and consistency.
;;;
;;; Schema: (: define-type (-> Symbol Atom String String Atom define-type))
;;; Usage:  (define-type <TypeName>
;;;            (Schema <MeTTa-Type-Signature>)
;;;            (Purpose <String-Description>)
;;;            (Plain-English <String-Description>)
;;;            (Example <MeTTa-Example>))
;;;

;;;
;;; 4.1. Metadata Types
;;;
(define-type Truth
   (Schema (: Truth (-> Float Float Truth)))
   (Purpose "Represents epistemic value (frequency, confidence).")
   (Plain-English "How much the system believes something is true.")
   (Example (Truth 0.9 0.8)))

(define-type Budget
   (Schema (: Budget (-> Float Float Float Budget)))
   (Purpose "Represents attentional value (priority, durability, quality).")
   (Plain-English "How much attention the system should pay to something.")
   (Example (Budget 0.99 0.5 0.85)))

(define-type Stamp
   (Schema (: Stamp (-> TaskID (Set TaskID) Stamp)))
   (Purpose "Tracks derivational history to prevent loops. TaskID is a unique string identifier.")
   (Plain-English "A 'paper trail' to track where a piece of information came from.")
   (Example (Stamp "t_7f8a..." (Set "t_1c5b..." "t_9e2d..."))))

;;;
;;; 4.2. Sentence Types (with Punctuation)
;;;
(define-type .
   (Schema (: . (-> Atom Truth Budget Stamp .)))
   (Purpose "Represents a piece of knowledge to be processed or stored.")
   (Plain-English "A statement of fact, like 'the sky is blue'.")
   (Example (. (bird --> flyer) (Truth 0.9 0.9) (Budget 0.9 0.8 0.7) (Stamp ...))))

(define-type !
   (Schema (: ! (-> Atom Budget Stamp !)))
   (Purpose "Represents a state to be achieved.")
   (Plain-English "A desired state, like 'the light is on'.")
   (Example (! (door-is-open) (Budget 0.9 0.5 0.8) (Stamp ...))))

(define-type ?
   (Schema (: ? (-> Atom Budget Stamp ?)))
   (Purpose "Represents a request for information.")
   (Plain-English "A request for information, like 'what color is the sky?'.")
   (Example (? (what-is-a-bird) (Budget 0.9 0.1 0.2) (Stamp ...))))

(define-type @
   (Schema (: @ (-> Atom Budget Stamp @)))
   (Purpose "Represents a long-term, curiosity-driven exploration goal.")
   (Plain-English "An open-ended exploration task, like 'investigate the properties of birds'.")
   (Example (@ (explore-concept bird) (Budget 0.8 0.9 0.9) (Stamp ...))))

;;;
;;; 4.3. Architectural & Metacognitive Schemas
;;;
(define-type Event
   (Schema (: Event (-> Symbol Atom Atom TimePoint Event)))
   (Purpose "Used for the internal event bus.")
   (Plain-English "A notification that something has happened, like 'a contradiction was found'.")
   (Example (Event contradiction-detected (belief-1) (belief-2) (now))))

(define-type Config
   (Schema (: Config (-> Atom Atom Config)))
   (Purpose "Defines a configuration setting. The key is often a Symbol or an Expression.")
   (Plain-English "A setting that controls how the system behaves.")
   (Example (Config BudgetingStrategy (GroundedAtom "SimpleBudgetingStrategy"))))

(define-type has-value
   (Schema (: has-value (-> Atom Number has-value)))
   (Purpose "Represents a belief about a system Key Performance Indicator (KPI).")
   (Plain-English "A belief about the system's own performance.")
   (Example (has-value (kpi avg_belief_confidence) 0.78)))

(define-type define-cognitive-function
   (Schema (: define-cognitive-function (-> Symbol String Atom define-cognitive-function)))
   (Purpose "A schema for defining a cognitive function or inference rule.")
   (Plain-English "A formal definition of a piece of the system's reasoning logic.")
   (Example (define-cognitive-function Deduce
      "The core NAL deduction rule."
      (= (deduce (. ($a --> $b) $t1 . $any) (. ($b --> $c) $t2 . $any))
         (. ($a --> $c) (deduction-truth-fn $t1 $t2))))))

(define-type define-cognitive-layer
   (Schema (: define-cognitive-layer (-> Number Symbol Symbol (List Symbol) define-cognitive-layer)))
   (Purpose "A schema for defining a single layer of the cognitive architecture.")
   (Plain-English "A formal definition of a cognitive layer and the functions within it.")
   (Example (define-cognitive-layer 1
      "Core Cognitive Functions"
      "System 1"
      (NAL-Inference-Rules Goal-Planning Temporal-Reasoning))))

(define-type define-cognitive-architecture
   (Schema (: define-cognitive-architecture (-> Symbol (List define-cognitive-layer) define-cognitive-architecture)))
   (Purpose "A schema for defining the complete, layered cognitive architecture.")
   (Plain-English "A formal definition of the system's entire cognitive structure.")
   (Example (define-cognitive-architecture HyperNARS-Standard-Model
      ((define-cognitive-layer ...)
       (define-cognitive-layer ...)))))

(define-type define-sentence-distinction
   (Schema (: define-sentence-distinction (-> Symbol Symbol String Atom String define-sentence-distinction)))
   (Purpose "A schema for formally comparing the roles of different sentence types.")
   (Plain-English "A formal definition of what a sentence type means and how the system should react to it, for comparative purposes.")
   (Example (define-sentence-distinction . Belief
      "This is a fact."
      (. (sky-is-blue) ...)
      "Store this information; use it as a premise in future reasoning.")))

(define-type define-configuration
   (Schema (: define-configuration (-> Symbol String Atom define-configuration)))
   (Purpose "A schema for defining a configuration parameter, its purpose, and its default value.")
   (Plain-English "A formal definition of a system setting.")
   (Example (define-configuration contradiction-rate-threshold
      "The KPI threshold that triggers contradiction management."
      (Value 0.05))))

(define-type define-bootstrap-sequence
   (Schema (: define-bootstrap-sequence (-> Symbol (List (-> Number Symbol String)) define-bootstrap-sequence)))
   (Purpose "A schema for defining the ordered steps of the system bootstrap process.")
   (Plain-English "A formal definition of how the system starts up.")
   (Example (define-bootstrap-sequence System-Startup
      ((1 Load-Configuration "Load all `Config` atoms.")
       (2 Initialize-Memory "Initialize the Memory system and its indexes.")))))

(define-type define-reasoning-cycle
   (Schema (: define-reasoning-cycle (-> Symbol (List (-> Number Symbol String)) define-reasoning-cycle)))
   (Purpose "A schema for formally defining the ordered steps of a reasoning cycle or cognitive process.")
   (Plain-English "A formal definition of a multi-step thinking process.")
   (Example (define-reasoning-cycle Reflexive-Reasoning-Cycle
      ((1 Select-Concept "Select a Concept from Memory's concept bag based on priority.")
       (2 Select-Active-Sentence "Select a high-priority Sentence from the Concept's local sentence bag.")))))
```

---

## 5. Self-Monitoring KPIs

To enable self-awareness, the system materializes its own state and performance as **Key Performance Indicator (KPI)** atoms in Memory. This "cognitive telemetry" is essential for the `CognitiveExecutive`. The definitions of these KPIs are specified below in MeTTa, making the system's knowledge of its own monitoring capabilities self-describing.

```metta
;;;
;;; Authoritative KPI Dictionary for HyperNARS
;;;
;;; This knowledge base defines the Key Performance Indicators (KPIs) used for system self-monitoring.
;;; It uses a `define-kpi` schema for clarity and consistency.
;;;
;;; Schema: (: define-kpi (-> Symbol Symbol String Symbol Atom define-kpi))
;;; Usage:  (define-kpi <Category> <KPIName>
;;;            (Description <String-Description>)
;;;            (SourceType <Symbol>)
;;;            (Example <MeTTa-Example>))
;;;

;;;
;;; 5.1. Reasoning KPIs
;;;
(define-kpi Reasoning avg_belief_confidence
   (Description "The average confidence of all belief sentences in Memory.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_belief_confidence) 0.78)))

(define-kpi Reasoning contradiction_rate
   (Description "The percentage of new beliefs that cause contradictions.")
   (SourceType Sentence)
   (Example (has-value (kpi contradiction_rate) 0.01)))

(define-kpi Reasoning rule_utility
   (Description "Average `quality` of conclusions produced by a specific inference rule.")
   (SourceType Sentence)
   (Example (has-value (kpi (rule_utility Deduce)) 0.82)))

(define-kpi Reasoning rule_cost
   (Description "Average execution time for a specific inference rule, in seconds.")
   (SourceType Sentence)
   (Example (has-value (kpi (rule_cost Abduce)) 0.000150)))

(define-kpi Reasoning stamp_overlap_rate
   (Description "The percentage of potential inferences that are prevented by stamp overlaps.")
   (SourceType Stamp)
   (Example (has-value (kpi stamp_overlap_rate) 0.02)))

;;;
;;; 5.2. Memory & Caching KPIs
;;;
(define-kpi Memory memory_utilization
   (Description "The percentage of total memory capacity currently being used.")
   (SourceType Bag)
   (Example (has-value (kpi memory_utilization) 0.6)))

(define-kpi Memory forgetting_rate
   (Description "The number of items being forgotten per second from `Bags`.")
   (SourceType Bag)
   (Example (has-value (kpi forgetting_rate) 12.5)))

(define-kpi Memory belief_count
   (Description "The total number of belief sentences currently in Memory.")
   (SourceType Sentence)
   (Example (has-value (kpi belief_count) 150000)))

(define-kpi Memory concept_hit_rate
   (Description "% of times a selected `Concept` contains a useful belief for the current `Sentence`.")
   (SourceType Concept)
   (Example (has-value (kpi concept_hit_rate) 0.35)))

(define-kpi Memory index_lookup_time
   (Description "The average time taken to retrieve an item from a memory index.")
   (SourceType Concept)
   (Example (has-value (kpi index_lookup_time) (2 milliseconds))))

(define-kpi Memory lti_distribution
   (Description "A histogram of the Long-Term Importance (LTI) values of all items in memory.")
   (SourceType Budget)
   (Example (has-value (kpi lti_distribution) (histogram ...))))

(define-kpi Memory avg_task_priority
   (Description "The average priority of all sentences in the system.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_task_priority) 0.65)))

;;;
;;; 5.3. Goal Management KPIs
;;;
(define-kpi GoalManagement goal_success_rate
   (Description "The percentage of goals that are successfully achieved.")
   (SourceType Sentence)
   (Example (has-value (kpi goal_success_rate) 0.95)))

(define-kpi GoalManagement goal_abandonment_rate
   (Description "The percentage of goals that are dropped due to low budget before being achieved.")
   (SourceType Sentence)
   (Example (has-value (kpi goal_abandonment_rate) 0.15)))

(define-kpi GoalManagement avg_goal_processing_time
   (Description "The average time from goal creation to achievement or abandonment.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_goal_processing_time) (12 seconds))))

;;;
;;; 5.4. Grounding & API KPIs
;;;
(define-kpi Grounding grounding_success_rate
   (Description "The percentage of `GroundedAtom` executions that complete successfully.")
   (SourceType GroundedAtom)
   (Example (has-value (kpi grounding_success_rate) 0.99)))

(define-kpi Grounding avg_grounding_latency
   (Description "The average time taken for a `GroundedAtom` to execute, in milliseconds.")
   (SourceType GroundedAtom)
   (Example (has-value (kpi avg_grounding_latency) (150 milliseconds))))

(define-kpi Grounding api_requests_per_second
   (Description "The number of incoming requests to the public API per second.")
   (SourceType Event)
   (Example (has-value (kpi api_requests_per_second) 25)))
```

---

## 6. Conceptual Distinctions

To clarify the roles of the primary sentence types, this section provides a formal, machine-readable comparison. While all are types of `Sentence` atoms, they represent fundamentally different intentions and drive different system behaviors. This formalization makes those distinctions queryable by the system itself.

```metta
;;;
;;; Formal Comparison of Sentence Types
;;;
;;; This knowledge base uses the `define-sentence-distinction` schema
;;; to formally capture the different roles and behaviors of the
;;; primary sentence types in HyperNARS.
;;;

(define-sentence-distinction . Belief
   "This is a fact."
   (. (sky-is-blue) ...)
   "Store this information; use it as a premise in future reasoning.")

(define-sentence-distinction ! Goal
   "I want this to be true."
   (! (light-is-on) ...)
   "Find a sequence of actions (a plan) to make the content true.")

(define-sentence-distinction ? Question
   "What is the answer to this?"
   (? (what-color-is sky) ...)
   "Search memory for relevant beliefs to derive a specific answer.")

(define-sentence-distinction @ Quest
   "How can a goal be achieved?"
   (@ (achieve-goal (light-is-on)) ...)
   "Search for procedural knowledge (rules, operations) that can satisfy the goal.")
```
