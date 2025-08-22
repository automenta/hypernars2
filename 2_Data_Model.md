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
-   **Eviction**: When a new item is added to a full `Bag`, an existing item with the lowest priority is automatically evicted.
-   **Priority-based Sampling**: Items are selected from the `Bag` probabilistically based on their priority.
-   **Sharpness**: A configurable parameter that controls how heavily the sampling favors high-priority items.

---

## 4. Formal System Definitions

The formal, machine-readable definitions for all core data structures, cognitive functions, system configurations, APIs, and state schemas are specified as MeTTa atoms. These files constitute the system's "bootstrap knowledge" and are intended to be loaded directly by the HyperNARS interpreter.

**The authoritative source for all formal definitions is located in the [`spec/`](./spec/) directory.**

Please refer to [`spec/README.md`](./spec/README.md) for a detailed breakdown of the file structure and the correct loading order.