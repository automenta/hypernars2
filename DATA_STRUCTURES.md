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

-   **Budget**: A NARS-style budget representing the allocation of computational resources to a `Task`. It is defined by `priority` (immediate importance), `durability` (long-term importance), and `quality` (epistemic quality of the derivation). It is **metadata** attached to a task atom. The architecture must define functions for:
    -   **Allocation**: Allocating a budget to a new task.
    -   **Merging**: Merging parent task budgets to derive a new task's budget.

-   **Belief**: An immutable pairing of an `Atom` and its `TruthValue`, with a timestamp to mark its creation time. Represents what the system "knows".

-   **Task**: A work unit for the system, containing an `Atom` to be processed. It includes a `Budget` and references to its parent beliefs for provenance. Represents what the system is "doing".

-   **Stamp**: A mechanism attached to each `Task` to prevent infinite reasoning loops and redundant derivations. It records the ancestral history of the task. Before an inference is made, the stamps of the parent premises are checked for overlap.

-   **Concept**: A concept is a mental construct identified by a specific `Atom` (typically a Symbol Atom). It serves as an index or node in the memory graph, containing all `Beliefs` and `Tasks` that are directly related to that atom. It is responsible for managing its local content, including adding new beliefs (and revising existing ones) and prioritizing tasks based on their budgets. From another perspective, a Concept is an emergent structure, implicitly defined by the collection of all `Belief` and `Task` atoms that share the same term.
