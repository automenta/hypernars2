# HyperNARS-on-Hyperon: An Integrated Architecture for General-Purpose AI

## 1. Overview

This document outlines the architecture for **HyperNARS-on-Hyperon**, a next-generation reasoning system that synergistically integrates the principles of the **Non-Axiomatic Reasoning System (NARS)** with the powerful, scalable framework of **OpenCog Hyperon**. The goal of this evolution is to create a robust, extensible, and highly performant platform for Artificial General Intelligence (AGI) research and development.

This integrated design preserves the core NARS philosophy, most notably the **Assumption of Insufficient Knowledge and Resources (AIKR)**, while leveraging Hyperon's advanced features to enhance the system's capabilities. By mapping NARS concepts to Hyperon's core components, we achieve a more elegant, powerful, and scalable architecture.

The key enhancements introduced by this integration include:

*   **Scalable Knowledge Representation:** NARS's conceptual hypergraph is replaced by Hyperon's **Atomspace**, a distributed metagraph that allows for more complex and scalable knowledge representation.
*   **Expressive and Self-Modifying Reasoning:** The NARS inference engine is implemented using **MeTTa (Meta Type Talk)**, a meta-programming language that allows for the definition of inference rules as rewritable programs within the Atomspace. This enables deep introspection and self-modification of the system's reasoning processes.
*   **Advanced Resource Management:** The NARS resource allocation mechanism is enhanced with Hyperon's **Economic Attention Allocation (ECAN)** model, providing a sophisticated, dynamics-based approach to managing attention and resources.
*   **Deep Neural-Symbolic Integration:** The architecture provides a native framework for integrating Machine Learning (ML) and Large Language Models (LLMs) as specialized "neural lobes" or "Spaces," controllable via MeTTa scripts.

This document serves as the primary conceptual specification for the HyperNARS-on-Hyperon system.

## 2. Guiding Principles

The architecture is guided by a combination of core NARS principles and new principles introduced from the OpenCog Hyperon framework.

### Core NARS Principles

*   **Assumption of Insufficient Knowledge and Resources (AIKR):** The system operates under the assumption that its knowledge is incomplete and its resources are finite. This remains the foundational principle of the integrated design.
*   **Modularity and Extensibility:** The system is composed of loosely-coupled modules, allowing for independent development and experimentation.
*   **Event-Driven Communication:** Components interact through asynchronous patterns, enabling complex emergent behaviors.
*   **Continuous Online Learning:** The system continuously learns from its experience, revises its beliefs, and adapts its behavior.
*   **Symbol Grounding:** The system includes a dedicated interface for connecting abstract symbols to external sensors, actuators, and computational models (including ML/LLMs).

### New Principles from Hyperon

*   **Metagraph-based Knowledge:** All knowledge, including declarative beliefs, procedural rules, and even the system's own cognitive processes, is represented in a unified **metagraph** (the Atomspace). This provides a highly uniform and expressive knowledge representation.
*   **Meta-programming and Self-Modification:** The system's cognitive processes are implemented as **MeTTa** programs that reside within the Atomspace. This makes the system's own logic introspectable and modifiable, enabling deep self-understanding and adaptation.
*   **Distributed and Decentralized by Design:** The architecture is designed for scalability across multiple machines and can be deployed in a decentralized manner, leveraging modern distributed computing and blockchain technologies.

## 3. System Architecture

The HyperNARS-on-Hyperon architecture is centered around two core components from OpenCog Hyperon: the **Atomspace** for knowledge representation and the **MeTTa Interpreter** for execution.

*   **The Atomspace (Central Knowledge Repository):** The Atomspace is a distributed **metagraph** that serves as the unified knowledge store for the entire system. Unlike a traditional hypergraph where edges connect nodes, the Atomspace's edges (Links) can connect to other Links, allowing for the representation of highly complex and nested relationships. All NARS data structures—`Terms`, `Statements`, `Beliefs`, and `Tasks`—are modeled as typed **Atoms** within this space.

*   **The MeTTa Interpreter (Execution Engine):** MeTTa is a powerful meta-programming language where programs are themselves expressions (Atoms) in the Atomspace. The MeTTa interpreter is responsible for executing all cognitive processes, from the core reasoning cycle to the high-level functions of the Cognitive Managers. It operates by matching patterns in the Atomspace and applying rewrite rules, which are also stored in the Atomspace.

### Component Diagram

```mermaid
graph TD
    subgraph AppLayer [Application Layer]
        direction TB
        API(Public API)
    end

    subgraph CogManagers [Cognitive Managers (MeTTa Scripts)]
        direction LR
        GoalManager(Goal Manager)
        TemporalReasoner(Temporal Reasoner)
        ContradictionManager(Contradiction Manager)
        MetaReasoner(Cognitive Executive)
    end

    subgraph Kernel [Reasoning Kernel]
        direction TB
        MeTTa(MeTTa Interpreter)
        Atomspace(Atomspace / Metagraph)
        ECAN(ECAN / Resource Management)
    end

    subgraph Grounding [Symbol Grounding & Neural-Symbolic Interface]
        direction TB
        NeuralLobes(Neural Lobes / LLMs)
        SensorsActuators(Sensors & Actuators)
    end

    API -- "Input/Queries (as Tasks)" --> MeTTa
    MeTTa -- "Executes Queries/Rules on" --> Atomspace
    Atomspace -- "Provides Knowledge to" --> MeTTa
    ECAN -- "Manages Budgets/Activation of Atoms in" --> Atomspace
    CogManagers -- "Query & Modify" --> Atomspace
    MeTTa -- "Orchestrates" --> Grounding
    Grounding -- "Injects Grounded Knowledge into" --> Atomspace

    classDef default fill:#fff,stroke:#333,stroke-width:1.5px;
    classDef layer fill:#f8f8f8,stroke:#666,stroke-width:2px,stroke-dasharray: 3 3;
    class AppLayer,CogManagers,Kernel,Grounding layer;
```

## 4. Core Data Structures in the Atomspace

All NARS data structures are represented as typed Atoms in the Atomspace. An **Atom** is the fundamental unit of representation and can be a `Symbol`, `Variable`, `GroundedAtom` (wrapping external code or data), or an `ExpressionAtom` (a tuple of other Atoms).

*   **TermAtoms:** Represent NARS terms. Simple terms are `Symbol` atoms (e.g., `(Term bird)`), while compound terms are `ExpressionAtom`s (e.g., `(CompoundTerm inheritance (Term bird) (Term animal))`).
*   **StatementAtoms:** Represent NARS statements as `ExpressionAtom`s, e.g., `(Statement inheritance (Term bird) (Term animal))`.
*   **TruthValueAtoms:** Represent NARS truth values as structured `ExpressionAtom`s, e.g., `(TruthValue (frequency 0.8) (confidence 0.9))`.
*   **BudgetAtoms:** Represent NARS budgets, e.g., `(Budget (priority 0.9) (durability 0.5))`.
*   **BeliefAtoms:** An `ExpressionAtom` that pairs a `StatementAtom` with a `TruthValueAtom`, e.g., `(Belief (Statement ...) (TruthValue ...))`.
*   **TaskAtoms:** An `ExpressionAtom` that pairs a `StatementAtom` with a `BudgetAtom`, e.g., `(Task (Statement ...) (Budget ...))`.

This uniform, atom-based representation allows all aspects of the system's knowledge to be queried and manipulated by MeTTa in a consistent manner.

## 5. The Reasoning Cycle in MeTTa

The NARS reasoning cycle is orchestrated by a main MeTTa script that continuously executes the following steps:

1.  **Select Task and Belief:** The system uses a `match` operation in MeTTa to query the Atomspace for a high-priority `TaskAtom` and a relevant `BeliefAtom`. The selection is guided by the `Budget` and `TruthValue` of the atoms.
2.  **Local Inference:** The MeTTa interpreter applies NAL inference rules to the selected task and belief. These rules are defined as MeTTa equality expressions that represent transformations on Atoms. For example, a deduction rule would look like:
    ```
    (= (NAL-deduction (Belief $premise1) (Belief $premise2)) (Task $conclusion))
    ```
    The interpreter finds applicable rules and generates new `TaskAtoms` representing the conclusions.
3.  **Process Results:** The newly derived `TaskAtoms` are assigned budgets and added to the Atomspace, making them available for future reasoning cycles.

A key feature of this model is **self-modification**. Since the inference rules are just equality expressions (Atoms) in the Atomspace, the system can learn new rules by simply adding new equality expressions. This allows for a deeply adaptive and self-improving reasoning system.

## 6. Resource Management: AIKR via ECAN and Atomspace

The AIKR principle is implemented through a sophisticated resource management system based on Hyperon's **Economic Attention Allocation (ECAN)** model.

*   **ECAN Integration:** The NARS `Budget` system is implemented using ECAN. The `priority` and `durability` of a NARS budget are mapped to the **Short-Term Importance (STI)** and **Long-Term Importance (LTI)** values of the corresponding `TaskAtom` and `BeliefAtom`.
*   **Activation Spreading:** The activation of concepts (represented by `TermAtoms`) is managed by the spreading of STI values through the Atomspace. When an Atom is accessed, its STI increases, and this importance spreads to related Atoms, bringing relevant knowledge into the system's focus.
*   **Forgetting:** Forgetting is handled by a continuous process that removes Atoms with low LTI and STI from the Atomspace, ensuring that the system's finite resources are focused on the most relevant knowledge.

## 7. Symbol Grounding and Neural-Symbolic Synergy

The integrated architecture provides a powerful framework for neural-symbolic integration, significantly enhancing the symbol grounding capabilities of the system.

*   **Specialized Spaces:** The system can interface with multiple **Spaces**. While the main knowledge base resides in the primary Atomspace, the system can connect to other specialized Spaces, such as **Neural Spaces** that host ML models.
*   **Neural Lobes:** LLMs and other ML models can be wrapped as `GroundedAtoms` or exposed as specialized Neural Spaces. This allows them to be treated as first-class components of the cognitive architecture.
*   **MeTTa for Orchestration:** MeTTa scripts can seamlessly query these neural spaces to perform tasks. This provides a powerful mechanism for implementing the sensorimotor loop and NLP interface.
    *   **NLP Example:** A MeTTa script can take a natural language string, pass it to an LLM Space to get a parsed Narsese `StatementAtom`, and then add that Atom to the main Atomspace as a new `Task`.
    *   **Grounding Example:** An operational command like `(#move_forward)` can be a `GroundedAtom` in MeTTa that, when executed, calls a Python function to control a robot's motors. The feedback from the robot's sensors can then be injected back into the Atomspace as new `BeliefAtoms`.

## 8. Cognitive Managers in a MeTTa-driven Architecture

The Cognitive Managers from HyperNARS are implemented as collections of MeTTa scripts that operate on the Atomspace. Instead of subscribing to a discrete set of events, they continuously query the Atomspace for relevant patterns.

*   **Pattern-Driven Execution:** Each manager is essentially a set of MeTTa rules that `match` for specific patterns in the Atomspace and then execute a corresponding cognitive function by adding, removing, or modifying Atoms.
*   **Example (Contradiction Manager):** A MeTTa script for the Contradiction Manager would periodically query the Atomspace for patterns like `(Contradiction (Belief $b1) (Belief $b2))`. When a match is found, the script would execute a resolution strategy, such as revising the `TruthValue` of the conflicting beliefs or generating a new, more specific belief that resolves the conflict.
*   **Example (Goal Manager):** The Goal Manager would be a set of MeTTa scripts that query for active `GoalAtoms` and search for procedural knowledge (e.g., `(Implication (Precondition $p) (Operation $o) (Effect $e))`) where the `Effect` matches the goal.

## Conclusion

The integration of HyperNARS and OpenCog Hyperon represents a significant evolution in the pursuit of AGI. By combining the non-axiomatic reasoning principles of NARS with the formal, scalable, and self-modifying framework of Hyperon, this new architecture provides a powerful and coherent foundation for building general-purpose AI systems. The use of the Atomspace for knowledge representation and MeTTa for execution creates a deeply integrated and adaptive system that is well-positioned to tackle the key challenges in AGI research, including scalable reasoning, continuous learning, and seamless neural-symbolic integration.
