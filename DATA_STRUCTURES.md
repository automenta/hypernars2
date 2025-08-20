# Core Data Structures

The core data structures are designed to be immutable where possible, combining the expressive power of MeTTa with the epistemic and attentional metadata of NARS. All data structures are represented as typed **Atoms** in Memory. An Atom is the fundamental unit of representation and can be a `Symbol`, `Variable`, `GroundedAtom` (wrapping external code or data), or an `Expression` (a tuple of other Atoms).

-   **Atom**: The fundamental unit of both knowledge and process, replacing the NARS `Term` and `Statement`. An atom is a symbolic expression in MeTTa. This allows for a unified representation of facts, rules, goals, and even executable code.
    -   **Declarative Knowledge**: `(Inheritance bird animal)`
    -   **Procedural Knowledge**: `(= (action-sequence (take-book) (read-book)) (knowledge-acquired))`
    -   **Logical Propositions**: `(Implication (And (human $x) (sentient $x)) (mortal $x))`

-   **TruthValue**: A NARS-style truth-value representing the epistemic value of a declarative atom, defined by `frequency` (evidence strength) and `confidence` (confidence in frequency). It is **metadata** attached to an atom in the Memory, not part of the atom itself.

    ***Language-Agnostic Representation:***
    ```
    struct TruthValue {
        frequency: float,  // Range [0, 1]
        confidence: float // Range [0, 1]
    }
    ```

    ***Language-Agnostic Operations:***
    The core NARS truth functions must be implemented. These functions are stateless and operate on `TruthValue` structs.
    ```
    function revision(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function projection(tv_compound: TruthValue, tv_component: TruthValue) -> TruthValue
    function deduction(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function abduction(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function induction(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function intersection(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function union(tv1: TruthValue, tv2: TruthValue) -> TruthValue
    function negation(tv: TruthValue) -> TruthValue
    // ... and other logical connectives.
    ```

-   **Budget**: A NARS-style budget representing the allocation of computational resources to a `Task`. It is defined by `priority` (immediate importance), `durability` (long-term importance), and `quality` (epistemic quality of the derivation). It is **metadata** attached to a task atom. The specific logic for allocating and merging budgets is defined by the active `BudgetingStrategy`. See `MEMORY.md` for details on the pluggable attention allocation model.

    ***Language-Agnostic Representation:***
    ```
    struct Budget {
        priority: float,   // Range [0, 1]
        durability: float, // Range [0, 1]
        quality: float     // Range [0, 1]
    }
    ```

-   **Belief**: An immutable pairing of an `Atom` and its `TruthValue`, with a timestamp to mark its creation time. Represents what the system "knows".

    ***Language-Agnostic Representation:***
    ```
    struct Belief {
        atom: Atom,
        truth: TruthValue,
        created_at: timestamp
    }
    ```

-   **Task**: A work unit for the system, containing an `Atom` to be processed. It includes a `Budget` and references to its parent beliefs for provenance. Represents what the system is "doing". A Task is a wrapper around a NARS-style sentence, which can be a `Belief`, a `Goal`, or a `Question`.

    ***Language-Agnostic Representation:***
    ```
    struct Task {
        sentence: (Belief | Goal | Question),
        budget: Budget,
        parent_premises: [Belief],
        stamp: Stamp
    }
    ```
    - **Belief Task**: A task containing a new piece of knowledge to be processed. The content of a Belief task is an `Atom` that is asserted to be true to some degree. This new information, once processed, will be used to create or update a stored `Belief` in Memory.
        - **MeTTa Representation**: `(Belief <atom> <truth_value>)`
        - **Example**: `(Belief <bird --> flyer> (TruthValue 0.9 0.9))`
    - **Goal Task**: A state of affairs the system is motivated to achieve. The content of a Goal is an `Atom` that the system should make true.
        - **MeTTa Representation**: `(Goal <atom>)`
        - **Example**: `(Goal <door-is-open>)`
    - **Question Task**: A request for information. The system is motivated to find or derive a `Belief` that answers the question.
        - **MeTTa Representation**: `(Question <atom>)`
        - **Example**: `(Question <what-is-a-bird>)`

-   **Stamp**: A mechanism attached to each `Task` to prevent infinite reasoning loops and redundant derivations. It records the ancestral history of the task. Before an inference is made, the stamps of the parent premises are checked for overlap. A stamp contains a unique identifier for the task itself, and a list of the identifiers of the parent tasks that generated it.

    ***Language-Agnostic Representation:***
    ```
    struct Stamp {
        task_id: unique_id,
        parent_task_ids: Set<unique_id>
    }
    ```
    ***Language-Agnostic Operations:***
    ```
    function create_stamp(parent_stamps: List<Stamp>) -> Stamp
    function have_overlap(stamp1: Stamp, stamp2: Stamp) -> bool
    ```

-   **Concept**: A concept is a mental construct identified by a specific `Atom` (typically a Symbol Atom). It serves as an index or node in the memory graph, containing all `Beliefs` and `Tasks` that are directly related to that atom. It is responsible for managing its local content, including adding new beliefs (and revising existing ones) and prioritizing tasks based on their budgets. From another perspective, a Concept is an emergent structure, implicitly defined by the collection of all `Belief` and `Task` atoms that share the same term.

## Self-Monitoring of Data Structures

To enable the system to reason about its own cognitive processes, the architecture should support the collection of metrics about its core data structures. This data should be periodically materialized as `Belief` atoms in Memory, making it accessible to the `CognitiveExecutive` and other cognitive managers.

This "cognitive telemetry" allows the system to answer questions about itself, such as:
- "Is my knowledge generally high-confidence or low-confidence?"
- "Are the tasks I'm working on generally high-priority?"
- "Am I getting stuck in reasoning loops?"

### Key Metrics to Track:

| Metric Name | Description | Data Structure | Example MeTTa Representation |
| :--- | :--- | :--- | :--- |
| `avg_belief_confidence` | The average confidence of all beliefs in Memory. | `Belief` | `(has-value (metric avg_belief_confidence) 0.78)` |
| `avg_task_priority` | The average priority of all tasks in the system. | `Task` | `(has-value (metric avg_task_priority) 0.65)` |
| `stamp_overlap_rate` | The percentage of potential inferences that are prevented by stamp overlaps. A high rate might indicate redundant reasoning pathways. | `Stamp` | `(has-value (metric stamp_overlap_rate) 0.02)` |
| `belief_count` | The total number of beliefs currently in Memory. | `Belief` | `(has-value (metric belief_count) 150000)` |
