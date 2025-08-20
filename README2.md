# HyperNARS-on-Hyperon: An Integrated Architecture for General-Purpose AI

## 1. Overview

This document outlines the architecture for **HyperNARS-on-Hyperon**, a next-generation reasoning system that synergistically integrates the principles of the **Non-Axiomatic Reasoning System (NARS)** with the powerful, scalable framework of **OpenCog Hyperon**. The goal of this evolution is to create a robust, extensible, and highly performant platform for Artificial General Intelligence (AGI) research and development.

This integrated design preserves the core NARS philosophy, most notably the **Assumption of Insufficient Knowledge and Resources (AIKR)**, while leveraging Hyperon's advanced features to enhance the system's capabilities. By mapping NARS concepts to Hyperon's core components, we achieve a more elegant, powerful, and scalable architecture.

The key enhancements introduced by this integration include:

*   **Scalable Knowledge Representation:** NARS's conceptual memory is implemented using Hyperon's **Metagraph**, a distributed and scalable knowledge store. This replaces a traditional hypergraph with a more expressive and powerful structure.
*   **Expressive and Self-Modifying Reasoning:** The NARS inference engine is implemented using **MeTTa (Meta Type Talk)**, a meta-programming language that allows for the definition of inference rules as rewritable programs within the Metagraph itself. This enables deep introspection and self-modification of the system's reasoning processes.
*   **Advanced Resource Management:** The NARS resource allocation mechanism is enhanced with Hyperon's **Economic Attention Allocation (ECAN)** model, providing a sophisticated, dynamics-based approach to managing attention and resources.
*   **Deep Neural-Symbolic Integration:** The architecture provides a native framework for integrating Machine Learning (ML) and Large Language Models (LLMs) as specialized "neural lobes" or "Spaces," controllable via MeTTa scripts.

This document serves as the primary conceptual specification for the HyperNARS-on-Hyperon system.

## 2. Guiding Principles

The architecture is founded on the core design philosophy of the Non-Axiomatic Reasoning System (NARS), which is realized and extended using the powerful components of the OpenCog Hyperon framework. The design is not a simple merge of two systems, but a NARS-centric architecture that leverages Hyperon for a robust, scalable, and self-aware implementation.

### Foundational Principles

*   **The Assumption of Insufficient Knowledge and Resources (AIKR):** This is the single most critical principle. The system must assume its knowledge is incomplete and its resources are finite. It must operate in real-time, remain open to new and unexpected experiences, and learn continuously. All other principles are consequences of this core assumption.

*   **Relative Rationality:** Because of AIKR, the system cannot adhere to a standard of truth or optimality. Instead, it practices *relative rationality*—it makes the best decisions it can, based on its current knowledge and available resources. Its conclusions are summaries of its experience, not claims of objective fact, and are always open to revision.

*   **Unified Knowledge and Reasoning:** The system uses a single, unified approach to represent all forms of knowledge—declarative beliefs, procedural skills, goals, and even its own internal cognitive processes. This is achieved by representing all information within a single **Metagraph** (the system's conceptual Memory). This uniformity allows a single reasoning engine (the MeTTa interpreter) to operate over the entire knowledge base, enabling powerful, cross-domain analogies and insights.

*   **Continuous, Experience-Grounded Learning:** The system learns by continuously processing a stream of experience (Tasks). All knowledge, including abstract concepts and complex rules, is ultimately derived from this experience. Beliefs are constantly adjusted based on new evidence and contradictions, and the system adapts its behavior over time.

*   **Layered, Incremental Intelligence:** The system's capabilities are not monolithic but are organized into a hierarchy of reasoning layers (based on the levels of NAL). Simpler, foundational skills (like basic inference) are established first, and more complex capabilities (like temporal and causal reasoning) are built upon them. This layered approach provides a clear roadmap for development and implementation.

*   **Deep Introspection and Self-Modification:** The system's own reasoning processes and internal structures are themselves represented as knowledge within its own Memory. Cognitive functions are implemented as **MeTTa** programs that can be inspected, analyzed, and rewritten by the system itself. This enables a unique capacity for self-understanding, self-improvement, and adaptive self-regulation, forming the basis for NAL-9 (self-awareness and control).

*   **Grounded Symbolism:** The system's abstract symbols and concepts must be connected to the external world. This is accomplished through a dedicated grounding interface that links symbolic knowledge to sensors, actuators, and specialized computational models, including neural networks and Large Language Models (LLMs). This allows the system to interact with its environment and ground its understanding in real-world phenomena.

## 3. System Architecture: Memory and Reasoning

The HyperNARS-on-Hyperon architecture is centered around two core components: a **Memory** for knowledge representation and the **MeTTa Interpreter** for reasoning and execution.

*   **Memory (The Metagraph):** The system's knowledge is stored in a distributed **metagraph**, which serves as its central Memory. This structure (a Hyperon Atomspace) is highly flexible. Unlike a traditional hypergraph where edges only connect nodes, the metagraph's edges (Links) can connect to other Links, allowing for the representation of complex, nested, and self-referential knowledge. All NARS data structures—`Concepts`, `Beliefs`, and `Tasks`—are modeled as typed **Atoms** within this Memory.

*   **The MeTTa Interpreter (Execution Engine):** MeTTa is a powerful meta-programming language where programs are themselves expressions (Atoms) in Memory. The MeTTa interpreter is responsible for executing all cognitive processes, from the core reasoning cycle to high-level cognitive functions. It operates by matching patterns in Memory and applying rewrite rules, which are also stored as Atoms in Memory.

### Component Diagram

```mermaid
graph TD
    subgraph AppLayer [Application Layer]
        direction TB
        API(Public API)
    end

    subgraph CognitiveFunctions [Cognitive Functions (MeTTa Scripts)]
        direction LR
        GoalManager(Goal Pursuit)
        TemporalReasoner(Temporal Reasoner)
        ContradictionManager(Contradiction Handling)
        MetaReasoner(Cognitive Executive)
    end

    subgraph Kernel [Reasoning Kernel]
        direction TB
        MeTTa(MeTTa Interpreter)
        Memory(Memory / Metagraph)
        ECAN(ECAN / Resource Management)
    end

    subgraph Grounding [Symbol Grounding & Neural-Symbolic Interface]
        direction TB
        NeuralLobes(Neural Lobes / LLMs)
        SensorsActuators(Sensors & Actuators)
    end

    API -- "Input/Queries (as Tasks)" --> MeTTa
    MeTTa -- "Executes Queries/Rules on" --> Memory
    Memory -- "Provides Knowledge to" --> MeTTa
    ECAN -- "Manages Budgets/Activation of Atoms in" --> Memory
    CognitiveFunctions -- "Query & Modify" --> Memory
    MeTTa -- "Orchestrates" --> Grounding
    Grounding -- "Injects Grounded Knowledge into" --> Memory

    classDef default fill:#fff,stroke:#333,stroke-width:1.5px;
    classDef layer fill:#f8f8f8,stroke:#666,stroke-width:2px,stroke-dasharray: 3 3;
    class AppLayer,CogManagers,Kernel,Grounding layer;
```

## 4. Core Data Structures in Memory

All NARS data structures are represented as typed **Atoms** in Memory. An Atom is the fundamental unit of representation and can be a `Symbol`, `Variable`, `GroundedAtom` (wrapping external code or data), or an `ExpressionAtom` (a tuple of other Atoms).

*   **Concepts and Terms:** In NARS, a Concept is a mental construct identified by a term. In this architecture, a **Term** is represented by a `Symbol` or `ExpressionAtom` (e.g., `(Term bird)` or `(CompoundTerm ...)`). The **Concept** itself is an emergent structure, implicitly defined by the collection of all `Belief` and `Task` atoms that share the same Term.
*   **Statements:** A NARS statement, which expresses a relationship between terms, is represented by a `StatementAtom`, e.g., `(Statement inheritance (Term bird) (Term animal))`.
*   **Beliefs:** A Belief is a `StatementAtom` paired with a `TruthValueAtom`, representing the system's confidence in that statement (e.g., `(Belief (Statement ...) (TruthValue (frequency 0.8) (confidence 0.9)))`).
*   **Goals and Tasks:** A Goal is a `StatementAtom` the system wants to bring about. A Task is a piece of work for the system, and can be a `Belief` to be processed or a `Goal` to be pursued. Both are represented as `TaskAtoms`, which pair a statement with a `BudgetAtom` that manages its priority (e.g., `(Task (Goal ...) (Budget ...))`).

This uniform, atom-based representation allows all aspects of the system's knowledge to be queried and manipulated by MeTTa in a consistent manner.

## 5. The Reasoning Cycle: A MeTTa-driven Process

The NARS reasoning cycle is orchestrated by a main MeTTa script that continuously executes the following steps:

1.  **Select Task and Belief:** The system uses a `match` operation in MeTTa to query Memory for a high-priority `TaskAtom` and a relevant `BeliefAtom`. The selection is guided by the `Budget` and `TruthValue` of the atoms.
2.  **Local Inference:** The MeTTa interpreter applies NAL inference rules to the selected task and belief. These rules are defined as MeTTa equality expressions that represent transformations on Atoms. For example, a deduction rule would look like:
    ```
    (= (NAL-deduction (Belief $premise1) (Belief $premise2)) (Task $conclusion))
    ```
    The interpreter finds applicable rules and generates new `TaskAtoms` representing the conclusions.
3.  **Process Results:** The newly derived `TaskAtoms` are assigned budgets and added to Memory, making them available for future reasoning cycles.

A key feature of this model is **self-modification**. Since the inference rules are just equality expressions (Atoms) in Memory, the system can learn new rules by simply adding new equality expressions. This allows for a deeply adaptive and self-improving reasoning system.

### NAL on MeTTa: The Layered Implementation

The NARS architecture is defined by a hierarchy of Non-Axiomatic Logic (NAL) layers, each introducing more expressive forms of representation and reasoning. In this architecture, these layers are implemented as sets of MeTTa rules and programs. This provides a clear, incremental path for development.

*   **NAL 1-2 (Basic Inference):** The foundational layers, dealing with inheritance, similarity, and basic logical inference (deduction, induction, abduction), are implemented as a core set of MeTTa `match` expressions. The classic NARS syllogisms are expressed as simple rewrite rules.
    ```metta
    ;;; NAL-1 Deduction Example
    (= (deduce (Belief <A --> B> %t1) (Belief <B --> C> %t2))
       (new-belief <A --> C> (deduction-truth-fn %t1 %t2)))
    ```

*   **NAL 3-4 (Compound Terms):** These layers introduce term-level operators (intersection, union, etc.). These are implemented in MeTTa by defining how expressions with these operators interact with inference rules, allowing the system to form and reason about compound concepts.

*   **NAL 5 (Statements as Terms):** This critical layer allows the system to reason about statements themselves. In MeTTa, this is native behavior. Any expression, including a `(Belief ...)` or `(Task ...)` Atom, can be treated as an argument in another expression, enabling higher-order reasoning.
    ```metta
    ;;; NAL-5 Implication Example
    ;;; "If a belief in (A-->B) causes a belief in (C-->D),
    ;;;  then we can form a new belief about that implication."
    (= (causal-inference (Belief <A --> B>) (Belief <C --> D>))
       (new-belief <(<A --> B>) ==> (<C --> D>)> ...))
    ```

*   **NAL 6 (Variable Terms):** The introduction of variables is also native to MeTTa. MeTTa's `$`-prefixed variables can be used to define general inference rules that apply to any term, allowing for abstract and hypothetical reasoning. The NARS inference rules are written as general MeTTa programs using variables.

*   **NAL 7 (Temporal Reasoning):** Temporal reasoning is implemented by adding temporal predicates to statements and defining MeTTa rules that operate on them. For example, rules for temporal succession (`</>`) can be defined to allow for predictions and explanations.
    ```metta
    ;;; NAL-7 Temporal Inference Example
    (= (deduce-temporal (Belief <(A </> B)> %t1) (Belief <(B </> C)> %t2))
       (new-belief <(A </> C)> (temporal-deduction-truth-fn %t1 %t2)))
    ```

*   **NAL 8-9 (Procedural and Self-Reasoning):** The highest levels of NARS involve goal-directed behavior and self-reasoning. These are implemented as specialized MeTTa scripts (Cognitive Functions) that reason about the system's own state and operations. For example, a goal-pursuit script can match a `(Goal ...)` Atom and search for procedural rules `(==> ...)` that would help achieve it. Self-reasoning involves MeTTa scripts that can inspect the very rules of inference themselves, modifying them to improve performance or resolve paradoxes.

## 6. Resource Management: AIKR in Memory

The AIKR principle is implemented through a sophisticated resource management system that combines NARS budgeting with Hyperon's **Economic Attention Allocation (ECAN)** model.

*   **ECAN Integration:** The NARS `Budget` system is mapped to ECAN concepts. The `priority` and `durability` of a NARS budget correspond to the **Short-Term Importance (STI)** and **Long-Term Importance (LTI)** values of an Atom in Memory.
*   **Activation Spreading:** The activation of concepts is managed by the spreading of STI values through the Memory metagraph. When an Atom is accessed, its STI increases, and this importance spreads to related Atoms, bringing relevant knowledge into the system's focus.
*   **Forgetting:** Forgetting is a natural outcome of resource management. A continuous process removes Atoms with low LTI and STI from Memory, ensuring that the system's finite resources are focused on the most relevant and important knowledge.

## 7. Grounding: Connecting Memory to the World

The integrated architecture provides a powerful framework for neural-symbolic integration, significantly enhancing the symbol grounding capabilities of the system. The system's central Memory can interface with other specialized knowledge stores, called **Spaces**.

*   **Specialized Spaces:** While the main knowledge base resides in the primary Memory (a Metagraph Space), the system can connect to other specialized Spaces, such as **Neural Spaces** that host ML models or vector embeddings.
*   **Neural Lobes:** LLMs and other ML models can be wrapped as `GroundedAtoms` or exposed as specialized Neural Spaces. This allows them to be treated as first-class components of the cognitive architecture, accessible from MeTTa.
*   **MeTTa for Orchestration:** MeTTa scripts can seamlessly query these external Spaces to perform tasks. This provides a powerful mechanism for implementing the sensorimotor loop and NLP interface.
    *   **NLP Example:** A MeTTa script can take a natural language string, pass it to an LLM Space to get a parsed Narsese `StatementAtom`, and then add that Atom to the main Memory as a new `Task`.
    *   **Grounding Example:** An operational command like `(#move_forward)` can be a `GroundedAtom` in MeTTa that, when executed, calls a Python function to control a robot's motors. The feedback from the robot's sensors can then be injected back into Memory as new `BeliefAtoms`.

## 8. Cognitive Functions as MeTTa Programs

Higher-level cognitive functions, often handled by specialized "Cognitive Managers" in other architectures, are implemented in HyperNARS as collections of MeTTa scripts that operate on Memory. Instead of being separate, event-driven modules, they are simply pattern-matching programs that run as part of the overall reasoning process.

*   **Pattern-Driven Execution:** Each cognitive function is a set of MeTTa rules that `match` for specific patterns in Memory and then execute a corresponding action by adding, removing, or modifying Atoms. This makes cognitive oversight a natural part of the reasoning flow, rather than an external process.
*   **Example (Contradiction Handling):** A MeTTa script for contradiction handling periodically queries Memory for `(Contradiction (Belief $b1) (Belief $b2))` patterns. When found, it executes a resolution strategy, such as revising the beliefs' truth-values or generating a more specific, contextual belief to resolve the conflict.
*   **Example (Goal Pursuit):** The goal-pursuit function is a set of MeTTa scripts that query for active `(Goal ...)` atoms and search for procedural knowledge (e.g., `(Implication (Precondition $p) (Operation $o) (Effect $e))`) where the `Effect` matches the goal.
*   **Example (Ethical Alignment):** A "conscience" can be implemented as a MeTTa script that inspects newly generated goals before they are pursued. It can match a potential `(Goal ...)` and check it against a set of inviolable ethical principles. If a conflict is detected, the script can veto the goal by drastically lowering its budget or injecting a high-priority counter-goal.

## 9. Self-Awareness and Bootstrapped Development

A key consequence of representing the system's own logic within its own Memory is the capacity for deep introspection and self-directed growth, corresponding to NAL-9. Because inference rules and cognitive functions are just Atoms in the Metagraph, they can be reasoned about, evaluated, and even rewritten by the system itself. This opens the door to powerful self-regulatory and developmental capabilities.

### Self-Regulation and Healing

The system can be designed to monitor its own cognitive behaviors and identify problematic patterns. For example, if it detects a high rate of contradictions, it can form a belief about this "meta-problem" and initiate a goal to investigate the cause. This might lead it to revise the truth-values of the responsible beliefs or even adjust the confidence of the inference rules that produced them. This creates a feedback loop for automated self-healing and performance tuning.

### Bootstrapped Development and Testing

This self-reasoning capability can be leveraged as a powerful tool for the system's own development and verification. The system can effectively become a partner in its own coding and testing process.

*   **Specification Analysis:** The system can ingest its own design documents (such as this `README.md`) and formal test specifications (`TEST.md`) as knowledge. It can then reason about this knowledge to detect inconsistencies. For example, it could identify a contradiction between a stated principle and a specific inference rule's implementation.

*   **Causal Analysis of Tests:** When a unit test fails, the system can be tasked with finding the cause. By analyzing the derivation path that led to the failure and correlating it with the test conditions, it can generate hypotheses about the specific faulty rule or belief, dramatically accelerating debugging.

*   **Automated Test Generation:** The system can analyze its own codebase (the MeTTa inference rules) to identify under-utilized rules or logical pathways. It can then autonomously generate new beliefs and tasks specifically designed to trigger these pathways, effectively creating new unit tests to improve its own test coverage.

This "bootstrapping" capability, where the system uses its own reasoning to enhance its own development, is a primary goal of this architecture, promising to significantly improve development ergonomics and accelerate the path to more robust and capable AGI.

## Conclusion

The integration of NARS principles with the Hyperon framework represents a significant evolution in the pursuit of AGI. By implementing a non-axiomatic reasoning system on a formal, scalable, and self-modifying foundation, this architecture provides a powerful and coherent path toward general-purpose AI. The use of a unified Metagraph Memory for knowledge representation and MeTTa for execution creates a deeply integrated and adaptive system that is well-positioned to tackle the key challenges in AGI research, including scalable reasoning, continuous learning, and seamless neural-symbolic integration.
