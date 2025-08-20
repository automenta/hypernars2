# HyperNARS: A Specification for a Metaprogrammable AGI

## Overview

This project outlines the architecture for HyperNARS, a next-generation reasoning system that synergistically integrates the principles of the **Non-Axiomatic Reasoning System (NARS)** with the powerful, metaprogrammable framework of **OpenCog Hyperon** and its native language, **MeTTa (Meta Type Talk)**.

The goal is to specify a robust, transparent, and self-improving platform for Artificial General Intelligence (AGI) that is defined not by rigid code, but by the contents of its own knowledge base.

This repository contains a set of documents that serve as the primary architectural and conceptual specification for the HyperNARS system.

---

## How to Read These Documents

This specification is detailed and interconnected. Here are recommended reading paths for different perspectives:

-   **For the System Architect (The "What"):** To understand the high-level structure and design philosophy, read in this order:
    1.  `README.md` (this file)
    2.  `ARCHITECTURE.md`: The core philosophy and high-level component map.
    3.  `REASONING_AND_COGNITION.md`: How high-level cognitive functions are structured and orchestrated.

-   **For the AGI Researcher (The "Why"):** To understand the theoretical underpinnings and a cohesive model of cognition:
    1.  `README.md` (this file)
    2.  `REASONING_AND_COGNITION.md`: The unified dual-process (System 1/2) reasoning model and the layered cognitive architecture.
    3.  `DATA_STRUCTURES.md`: The NARS-inspired epistemic and attentional metadata.

-   **For the Software Engineer (The "How"):** To understand how to implement the system:
    1.  `README.md` (this file, especially the "Path to Implementation" section).
    2.  `DATA_STRUCTURES.md`: The precise, authoritative definition of all data types.
    3.  `REASONING_AND_COGNITION.md`: The pseudo-code for the core reasoning loops and the interfaces for all cognitive functions.
    4.  `ARCHITECTURE.md`: How configuration and events are handled as atoms.

---

## Table of Contents

1.  [**Getting Started: A Conceptual Walkthrough**](./TUTORIAL.md): A high-level tutorial to quickly understand the core concepts.
2.  [**Architecture**](./ARCHITECTURE.md): The high-level design philosophy, component diagrams, and the metaprogrammable approach.
3.  [**Data Structures**](./DATA_STRUCTURES.md): The single source of truth for all data types, including formal MeTTa schemas.
4.  [**Reasoning and Cognition**](./REASONING_AND_COGNITION.md): The unified model of the dual-process reasoning loops and the layered cognitive architecture.
5.  [**Memory & Attention**](./MEMORY.md): The structure of the knowledge base and the pluggable mechanisms for attention allocation and forgetting.
6.  [**Symbol Grounding**](./GROUNDING.md): The interface to the external world, including sensors, actuators, and integration with ML models.
7.  [**API & Integration**](./API_AND_INTEGRATION.md): Details on the public API, system configuration, and extension points.
8.  [**Safety & Resilience**](./SAFETY_AND_RESILIENCE.md): The approach to ethical alignment, safety, and robust error handling.
9.  [**Advanced Topics**](./ADVANCED_TOPICS.md): Forward-looking subjects like concurrency, self-evolution, and system bootstrapping.

---

## Path to Implementation

This specification is designed to be "obviously implementable." Here is a logical path a development team could take to build HyperNARS:

1.  **Phase 1: The Core Data Structures.**
    -   Implement the core Atom and metadata types (`Truth`, `Budget`, `Stamp`) as defined in `DATA_STRUCTURES.md`.
    -   Implement the unified `Sentence` structure, which combines content with all processing metadata.

2.  **Phase 2: The Reasoning Loop and Core Cognition.**
    -   Implement the `reflexive_reasoning_cycle` pseudo-code from `REASONING_AND_COGNITION.md`. This requires:
        -   A `Concept` structure for organizing knowledge.
        -   A basic, pluggable `BudgetingStrategy`.
        -   An interface to a MeTTa interpreter.
    -   Implement the foundational NAL inference rules (Deduction, Abduction, Induction) as MeTTa atoms, as shown in `REASONING_AND_COGNITION.md`.

3.  **Phase 3: The Executive Framework and Metacognition.**
    -   Implement the event-handling and configuration-loading mechanisms described in `ARCHITECTURE.md`.
    -   Implement the Layer 2 `Cognitive Executive` from `REASONING_AND_COGNITION.md`, which monitors KPIs and triggers the System 2 process.
    -   Implement the `deliberative_reasoning_process` pseudo-code.
    -   Begin implementing the Layer 3 metacognitive functions, such as `ContradictionManagement` and `Self-Optimization`.

5.  **Phase 5: Grounding and Application.**
    -   Implement the `GroundingInterface` and `Public API` to connect the system to the outside world.

---

## Guiding Principles

-   **Everything is an Atom:** All forms of knowledge—declarative facts, procedural rules, goals, and the system's own logic and configuration—are represented as MeTTa expressions in a unified knowledge store.
-   **Inference is Interpretation:** The system has no hard-coded inference rules. Reasoning is the process of the MeTTa interpreter evaluating expressions against other expressions that represent the laws of logic.
-   **Assumption of Insufficient Knowledge and Resources (AIKR):** The system must operate under the assumption that its knowledge is incomplete and its computational resources are finite. This guides the entire attention and resource allocation process.
-   **Continuous, Experience-Grounded Learning:** All knowledge is derived from the stream of `Sentences` the system processes, and its beliefs are constantly revised based on new evidence.
-   **Deep Introspection and Metaprogrammability:** The system's own structure and processes are represented as knowledge, enabling a unique capacity for self-understanding, self-regulation, and self-improvement.
