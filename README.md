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
    3.  `COGNITIVE_ARCH.md`: How high-level cognitive functions are structured.

-   **For the AGI Researcher (The "Why"):** To understand the theoretical underpinnings and cognitive model:
    1.  `README.md` (this file)
    2.  `REASONING.md`: The dual-process (System 1/2) reasoning model.
    3.  `COGNITIVE_ARCH.md`: The layered model of cognition and metacognition.
    4.  `DATA_STRUCTURES.md`: The NARS-inspired epistemic and attentional metadata.

-   **For the Software Engineer (The "How"):** To understand how to implement the system:
    1.  `README.md` (this file, especially the "Path to Implementation" section).
    2.  `DATA_STRUCTURES.md`: The precise, authoritative definition of all data types.
    3.  `REASONING.md`: The pseudo-code for the core reasoning loops.
    4.  `ARCHITECTURE.md`: How configuration and events are handled as atoms.
    5.  `COGNITIVE_ARCH.md`: The interface definitions for each cognitive function to be implemented.

---

## Table of Contents

1.  [**Architecture**](./ARCHITECTURE.md): The high-level design philosophy, component diagrams, and the metaprogrammable approach to configuration and event handling.
2.  [**Data Structures**](./DATA_STRUCTURES.md): The single source of truth for all data types, including formal MeTTa schemas for Beliefs, Tasks, KPIs, and more.
3.  [**Reasoning Engine**](./REASONING.md): The core dual-process (System 1 & 2) reasoning loops, with detailed pseudo-code and the layered implementation of Non-Axiomatic Logic (NAL) on MeTTa.
4.  [**Cognitive Architecture**](./COGNITIVE_ARCH.md): The layered model of high-level cognitive functions, their interfaces, and their roles in the system's overall behavior.
5.  [**Memory & Attention**](./MEMORY.md): The structure of the knowledge base and the pluggable mechanisms for attention allocation and forgetting.
6.  [**Symbol Grounding**](./GROUNDING.md): The interface to the external world, including sensors, actuators, and integration with ML models.
7.  [**API & Integration**](./API_AND_INTEGRATION.md): Details on the public API, system configuration, and extension points.
8.  [**Safety & Resilience**](./SAFETY_AND_RESILIENCE.md): The approach to ethical alignment, safety, and robust error handling.
9.  [**Advanced Topics**](./ADVANCED_TOPICS.md): Forward-looking subjects like concurrency, self-evolution, and system bootstrapping.

---

## Path to Implementation

This specification is designed to be "obviously implementable." Here is a logical path a development team could take to build HyperNARS:

1.  **Phase 1: The Core Data Structures.**
    -   Implement the core Atom and metadata types (`TruthValue`, `Budget`, `Stamp`) as defined in `DATA_STRUCTURES.md`.
    -   Create the basic data wrappers for `Belief` and `Task`.

2.  **Phase 2: The System 1 Reasoning Loop.**
    -   Implement the `reflexive_reasoning_cycle` pseudo-code from `REASONING.md`. This requires:
        -   A `Concept` structure for organizing knowledge.
        -   A basic, pluggable `BudgetingStrategy`.
        -   An interface to a MeTTa interpreter.
    -   Implement the foundational NAL inference rules (Deduction, Abduction, Induction) as MeTTa atoms, as shown in `REASONING.md`.

3.  **Phase 3: The Cognitive Framework.**
    -   Implement the event-handling and configuration-loading mechanisms described in `ARCHITECTURE.md`.
    -   Implement the Layer 1 Cognitive Functions from `COGNITIVE_ARCH.md`, starting with the `Goal & Planning Function`.

4.  **Phase 4: System 2 and Metacognition.**
    -   Implement the `deliberative_reasoning_process` pseudo-code from `REASONING.md`.
    -   Implement the Layer 2 `Cognitive Executive`, which monitors KPIs and triggers the System 2 process.
    -   Begin implementing the Layer 3 metacognitive functions, such as `ContradictionManagement` and `Self-Optimization`.

5.  **Phase 5: Grounding and Application.**
    -   Implement the `GroundingInterface` and `Public API` to connect the system to the outside world.

---

## Guiding Principles

-   **Everything is an Atom:** All forms of knowledge—declarative facts, procedural rules, goals, and the system's own logic and configuration—are represented as MeTTa expressions in a unified knowledge store.
-   **Inference is Interpretation:** The system has no hard-coded inference rules. Reasoning is the process of the MeTTa interpreter evaluating expressions against other expressions that represent the laws of logic.
-   **Assumption of Insufficient Knowledge and Resources (AIKR):** The system must operate under the assumption that its knowledge is incomplete and its computational resources are finite. This guides the entire attention and resource allocation process.
-   **Continuous, Experience-Grounded Learning:** All knowledge is derived from the stream of tasks the system processes, and its beliefs are constantly revised based on new evidence.
-   **Deep Introspection and Metaprogrammability:** The system's own structure and processes are represented as knowledge, enabling a unique capacity for self-understanding, self-regulation, and self-improvement.
