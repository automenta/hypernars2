# API and Integration Guide

This document covers the practical, developer-facing aspects of using, configuring, and extending the system. It describes *what* capabilities are exposed to a developer.

For details on the underlying mechanisms that connect the system to the external world, see [**Symbol Grounding**](./GROUNDING.md). For details on system configuration, see [**System Architecture**](./ARCHITECTURE.md#4-system-configuration). All terminology is defined in the [**Glossary**](./DATA_STRUCTURES.md#1-glossary-of-core-terms).

---

## 1. Public API

The public API is designed to be clean, language-agnostic, and powerful. It is event-driven and asynchronous where appropriate.

### 1.1. Core I/O
Provides methods to:
-   Input a complete MeTTa `Sentence` (e.g., a belief, goal, or question).
-   Subscribe to system events like `answer-generated`, `contradiction-detected`, or `goal-achieved`.

### 1.2. Control & Configuration
Provides methods to:
-   Run, pause, and resume the reasoning loop.
-   Dynamically get and set system configuration parameters at runtime.

### 1.3. Inspection & Explainability
Provides methods to:
-   Retrieve the full state of a `Concept`.
-   Get detailed operational KPIs.
-   Request a structured explanation for a derived `Sentence`.

### 1.4. Semantic Layer
To improve usability, the system can provide a higher-level, intention-driven API that wraps the raw MeTTa input. This "semantic API" would allow developers to interact with the system more naturally (e.g., via methods like `createInheritanceBelief()` or `addGoal()`).

### 1.5. Hypothetical Reasoning
The API should provide a method for creating isolated "sandbox" instances of the reasoner. This allows for hypothetical or "what-if" reasoning without polluting the main knowledge base.

---

## 2. System Initialization

The system follows a well-defined sequence to ensure a stable startup. While the system's behavior is defined by the atoms in its memory, a practical implementation requires a procedural bootstrap process.

### 2.1. Bootstrap Sequence
1.  **Load Configuration**: Load all `Config` atoms from a file or environment. See [**System Architecture**](./ARCHITECTURE.md#4-system-configuration) for details.
2.  **Initialize Memory**: Initialize the Memory system and its indexes.
3.  **Initialize MeTTa Interpreter**: Start the interpreter.
4.  **Load Foundational Knowledge**: Load a base set of inference rules and ontological atoms.
5.  **Register Cognitive Functions**: Load the atoms for all configured Cognitive Functions.
6.  **Start Reasoning Loop**: Begin the main control unit's reasoning cycle.

### 2.2. Architectural Perspective
From a purely architectural standpoint, steps 1, 4, and 5 are all simply "loading atoms into Memory." This metaprogramming approach ensures that the system's capabilities are determined by its knowledge, not by its compiled code.

---

## 3. Extension Points

The architecture is designed to be extensible at multiple levels, allowing developers to add new capabilities without modifying the core kernel.

-   **Adding New Cognitive Functions**: A developer can create a new function by defining a new collection of MeTTa atoms (rules and goals) and loading them into Memory. This is the primary way to add new high-level behaviors.
-   **Adding New Inference Rules**: Since inference rules are just MeTTa atoms, new forms of reasoning can be introduced at runtime by simply adding new rule atoms to the Memory.
-   **Adding Grounded Atoms**: New capabilities for interacting with the external world (e.g., calling a new web API, controlling a new sensor) can be added by implementing new `GroundedAtom`s. This process is detailed in [**Symbol Grounding**](./GROUNDING.md).
-   **Swapping Core Components**: The pluggable module architecture allows for different implementations of components like the `BudgetingStrategy` to be swapped out at initialization.

---

## 4. State Serialization and Persistence

To support long-running operation and recovery from shutdowns, the system must be able to serialize its entire state to persistent storage. A complete snapshot should include:

-   **Memory Content**: All atoms, `Sentences`, `Concept`s, and their associated metadata (`Truth` values, `Budget` values, etc.). This should ideally be stored in a format that is both efficient and human-readable, such as a stream of MeTTa expressions.
-   **Cognitive Function State**: The internal state of all stateful cognitive functions (e.g., the Goal Manager's current goal stack).
-   **System Configuration**: The `Config` atoms the system is currently running with.
-   **Event Queues**: A snapshot of any pending events or `Sentences` to ensure a seamless restart.

This capability is also essential for debugging, as it allows developers to capture and replay the exact state of the system at a specific moment.
