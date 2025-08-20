# HyperNARS: An Integrated AGI Architecture

## Overview

This project outlines the architecture for HyperNARS, a next-generation reasoning system that synergistically integrates the principles of the **Non-Axiomatic Reasoning System (NARS)** with the powerful, scalable framework of **OpenCog Hyperon** and its native language, **MeTTa (Meta Type Talk)**.

The goal is to create a robust, modular, and extensible platform for Artificial General Intelligence (AGI) that preserves the core NARS philosophy—most notably the **Assumption of Insufficient Knowledge and Resources (AIKR)**—while leveraging Hyperon's advanced features for knowledge representation, reasoning, and resource management.

This repository contains a set of documents that serve as the primary architectural and conceptual specification for the HyperNARS system.

## Table of Contents

1.  [**System Architecture**](./ARCHITECTURE.md): The high-level design, component diagrams, and communication patterns.
2.  [**Core Data Structures**](./DATA_STRUCTURES.md): The fundamental units of knowledge and process, including Atoms, Beliefs, and Tasks.
3.  [**Reasoning Engine**](./REASONING.md): The core reasoning process, including the dual-process model and the layered implementation of Non-Axiomatic Logic (NAL) on MeTTa.
4.  [**Memory and Resource Management**](./MEMORY.md): The structure of the knowledge base and the mechanisms for attention and forgetting.
5.  [**Cognitive Architecture**](./COGNITIVE_ARCH.md): The high-level cognitive functions, such as goal management, learning, and contradiction resolution.
6.  [**Symbol Grounding**](./GROUNDING.md): The interface to the external world, including sensors, actuators, and integration with Machine Learning models.
7.  [**API and Integration**](./API_AND_INTEGRATION.md): Details on the public API, system configuration, and extension points.
8.  [**Advanced Topics**](./ADVANCED_TOPICS.md): Forward-looking and specialized subjects like concurrency, self-evolution, and system bootstrapping.
9.  [**Safety and Resilience**](./SAFETY_AND_RESILIENCE.md): The approach to ethical alignment, safety, and robust error handling.

## Guiding Principles

The architecture is founded on a set of core principles that fuse the NARS philosophy with the functional, scalable paradigm of Hyperon.

-   **Assumption of Insufficient Knowledge and Resources (AIKR):** This is the cornerstone. The system must operate under the assumption that its knowledge is incomplete and potentially contradictory, and that its computational resources are finite. This principle directly influences resource allocation, belief revision, and the system's ability to operate in real-time.

-   **Unified Knowledge Representation:** All forms of knowledge—declarative facts, procedural rules, goals, and even the system's own logic—are represented as symbolic expressions (Atoms) in a single, unified knowledge store (the Memory). This uniformity allows the system to reason about and modify its own logic.

-   **Continuous, Experience-Grounded Learning:** The system is designed to learn from its experience in real-time. All knowledge is ultimately derived from the stream of tasks it processes, and its beliefs are constantly revised based on new evidence.

-   **Modularity and Extensibility:** The system is built as a collection of loosely-coupled modules. The MeTTa-based design makes the system's reasoning capabilities themselves extensible at runtime by simply adding new atoms to the Memory.

-   **Grounded Symbolism:** The system's abstract knowledge is connected to the external world through a dedicated interface for grounding atoms to sensors, actuators, and external computational procedures, including Machine Learning and Large Language Models (LLMs).

-   **Deep Introspection and Self-Modification:** The system's own reasoning processes and internal structures are themselves represented as knowledge. This enables a unique capacity for self-understanding, self-improvement, and adaptive self-regulation.
