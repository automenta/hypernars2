# Core Data Structures

The core data structures are designed to be immutable where possible, combining the expressive power of MeTTa with the epistemic and attentional metadata of NARS. All data structures are represented as typed **Atoms** in Memory. An Atom is the fundamental unit of representation and can be a `Symbol`, `Variable`, `GroundedAtom` (wrapping external code or data), or an `Expression` (a tuple of other Atoms).

-   **Atom**: The fundamental unit of both knowledge and process, replacing the NARS `Term` and `Statement`. An atom is a symbolic expression in MeTTa. This allows for a unified representation of facts, rules, goals, and even executable code.
    -   **Declarative Knowledge**: `(Inheritance bird animal)`
    -   **Procedural Knowledge**: `(= (action-sequence (take-book) (read-book)) (knowledge-acquired))`
    -   **Logical Propositions**: `(Implication (And (human $x) (sentient $x)) (mortal $x))`

-   **TruthValue**: A NARS-style truth-value representing the epistemic value of a declarative atom, defined by `frequency` (evidence strength) and `confidence` (confidence in frequency). It is **metadata** attached to an atom in the Memory, not part of the atom itself. The architecture must define the full set of NARS inference functions for:
    -   **Revision**: Combining two truth values for the same atom.
    -   **Projection**: Deriving the truth value of a component from a compound atom.
    -   **Intersection (and)**: Calculating the truth value for a conjunction of two atoms.
    -   **Union (or)**: Calculating the truth value for a disjunction of two atoms.
    -   And all other logical connectives (negation, implication, etc.).

    ***Language-Agnostic Representation:***
    ```
    struct TruthValue {
        frequency: float,  // Range [0, 1]
        confidence: float // Range [0, 1]
    }
    ```

-   **Budget**: A NARS-style budget representing the allocation of computational resources to a `Task`. It is defined by `priority` (immediate importance), `durability` (long-term importance), and `quality` (epistemic quality of the derivation). It is **metadata** attached to a task atom. The architecture must define functions for:
    -   **Allocation**: Allocating a budget to a new task.
    -   **Merging**: Merging parent task budgets to derive a new task's budget.

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
        - `(Belief <atom> <punctuation>)` -> e.g., `(Belief <bird --> flyer> .)`
    - **Goal**: A state of affairs the system is motivated to achieve. The content of a Goal is an `Atom` that the system should make true.
        - `(Goal <atom> <punctuation>)` -> e.g., `(Goal <door-is-open> !)`
    - **Question**: A request for information. The system is motivated to find or derive a `Belief` that answers the question.
        - `(Question <atom> <punctuation>)` -> e.g., `(Question <what-is-a-bird> ?)`

-   **Stamp**: A mechanism attached to each `Task` to prevent infinite reasoning loops and redundant derivations. It records the ancestral history of the task. Before an inference is made, the stamps of the parent premises are checked for overlap. A stamp contains a unique identifier for the task itself, and a list of the identifiers of the parent tasks that generated it.

    ***Language-Agnostic Representation:***
    ```
    struct Stamp {
        task_id: unique_id,
        parent_task_ids: [unique_id]
    }
    ```

-   **Concept**: A concept is a mental construct identified by a specific `Atom` (typically a Symbol Atom). It serves as an index or node in the memory graph, containing all `Beliefs` and `Tasks` that are directly related to that atom. It is responsible for managing its local content, including adding new beliefs (and revising existing ones) and prioritizing tasks based on their budgets. From another perspective, a Concept is an emergent structure, implicitly defined by the collection of all `Belief` and `Task` atoms that share the same term.
