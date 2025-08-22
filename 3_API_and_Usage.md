# API and Usage Guide

This guide provides both a high-level conceptual walkthrough for getting started with HyperNARS and a detailed reference for its developer-facing API.

---

## 1. Getting Started: A Conceptual Walkthrough

This tutorial provides a high-level, conceptual walkthrough of how one might interact with a running HyperNARS system. The goal is to illustrate the flow of information and the roles of the core data types, without getting into implementation-specific details.

For formal definitions of any terms used here, please consult the [**Glossary** in the Data Model document](./2_Data_Model.md#1-glossary-of-core-terms).

### 1.1. The Goal: Teaching and Querying

Our goal is simple:
1.  Teach the system a few basic facts about the world.
2.  Ask the system a question based on those facts.
3.  Give the system a goal to achieve.

### 1.2. Step 1: Injecting Knowledge (Beliefs)

First, we need to provide the system with some knowledge. We do this by sending it **belief sentences**. A belief represents something the system should treat as a fact. Each sentence is a self-contained unit of work, including the core content, a truth value, and attentional information (its `Budget`).

Let's teach it two facts: "A cat is a type of mammal" and "Mammals have fur."

Conceptually, we would provide the following sentences to the system's API:

-   `(. (cat --> mammal) (Truth 1.0 0.99))`
-   `(. (mammal --> has-fur) (Truth 1.0 0.99))`

The system now absorbs these into its `Memory`, and the reasoning loop processes them based on their `Budget`.

### 1.3. Step 2: Asking a Question

Now that the system has some knowledge, we can ask it a question. A **question sentence** is a request for information. Let's ask it, "What properties does a cat have?"

We would provide the following question sentence to the API:

-   `(? (cat --> ?what))`

The `?what` is a variable that we want the system to fill in.

### 1.4. Step 3: How the System Reasons

Upon receiving the question sentence, the system's `Control Loop` gets to work. Here's a simplified, conceptual view of what happens:

1.  The system identifies the core concept in the question: `cat`.
2.  It looks at the knowledge it has associated with `cat`, including the belief `(cat --> mammal)`.
3.  It also knows about `mammal`, and remembers the belief `(mammal --> has-fur)`.
4.  The `MeTTa Interpreter` applies a reasoning rule (like NAL's **Deduction**) to these two beliefs:
    -   IF `(cat --> mammal)` AND `(mammal --> has-fur)`
    -   THEN `(cat --> has-fur)`
5.  This newly derived belief, `(cat --> has-fur)`, directly answers the question.
6.  The system would then present this answer back to the user, likely as a new belief sentence.

### 1.5. Step 4: Adding a Goal

Now, let's give the system a **goal sentence**. A goal is a state of the world the system should try to achieve. Let's say our goal is to have a pet cat.

We could express this with a goal sentence:

-   `(! (user-has-pet cat))`

### 1.6. Step 5: Grounding and Acting

When the system processes this goal sentence, its `Goal & Planning Function` will activate.

1.  The system searches its memory for beliefs about how to achieve the goal `(user-has-pet cat)`.
2.  It might find a procedural belief like: `(. ((execute adopt-cat-action) ==> (user-has-pet cat)) (Truth ...))`. This means, "Executing the 'adopt cat' action leads to the user having a pet cat."
3.  This belief tells the system it has a way to achieve the goal. The `execute-action` term is a special `GroundedAtom`.
4.  The system would then form the intention to execute this action. The `Grounded Atom Interface` would translate this symbolic action into a real-world effect (which, in a real application, might mean sending an email, controlling a robot, or displaying a button on a UI).

### 1.7. Conclusion

This walkthrough illustrates the basic interaction pattern with HyperNARS:

-   We provide it with **belief sentences (.)** to build its knowledge base.
-   We ask it **question sentences (?)** to retrieve information, triggering its reasoning process.
-   We give it **goal sentences (!)** to achieve, triggering its planning and action capabilities.

This entire process is mediated by the core data structures of `Atom` and `Sentence`, and driven by the continuous reasoning loop.

---

## 2. Public API

The public API is designed to be clean, language-agnostic, and powerful. It is event-driven and asynchronous where appropriate.

### 2.1. Core I/O
Provides methods to:
-   Input a complete MeTTa `Sentence` (e.g., a belief, goal, or question).
-   Subscribe to system events like `answer-generated`, `contradiction-detected`, or `goal-achieved`.

### 2.2. Control & Configuration
Provides methods to:
-   Run, pause, and resume the reasoning loop.
-   Dynamically get and set system configuration parameters at runtime.

### 2.3. Inspection & Explainability
Provides methods to:
-   Retrieve the full state of a `Concept`.
-   Get detailed operational KPIs.
-   Request a structured explanation for a derived `Sentence`.

### 2.4. Semantic Layer
To improve usability, the system can provide a higher-level, intention-driven API that wraps the raw MeTTa input. This "semantic API" would allow developers to interact with the system more naturally (e.g., via methods like `createInheritanceBelief()` or `addGoal()`).

### 2.5. Hypothetical Reasoning
The API should provide a method for creating isolated "sandbox" instances of the reasoner. This allows for hypothetical or "what-if" reasoning without polluting the main knowledge base.

The formal definitions for the public API methods can be found in [`spec/05_api.metta`](./spec/05_api.metta).

---

## 3. System Initialization

The system follows a well-defined sequence to ensure a stable startup. While the system's behavior is defined by the atoms in its memory, a practical implementation requires a procedural bootstrap process.

### 3.1. Bootstrap Sequence
1.  **Load Configuration**: Load all `Config` atoms from a file or environment.
2.  **Initialize Memory**: Initialize the Memory system and its indexes.
3.  **Initialize MeTTa Interpreter**: Start the interpreter.
4.  **Load Foundational Knowledge**: Load a base set of inference rules and ontological atoms.
5.  **Register Cognitive Functions**: Load the atoms for all configured Cognitive Functions.
6.  **Start Reasoning Loop**: Begin the main control unit's reasoning cycle.

The formal MeTTa definition for the bootstrap sequence can be found in [`spec/06_bootstrap.metta`](./spec/06_bootstrap.metta).

### 3.2. Architectural Perspective
From a purely architectural standpoint, steps 1, 4, and 5 are all simply "loading atoms into Memory." This metaprogramming approach ensures that the system's capabilities are determined by its knowledge, not by its compiled code.

---

## 4. Extension Points

The architecture is designed to be extensible at multiple levels, allowing developers to add new capabilities without modifying the core kernel.

-   **Adding New Cognitive Functions**: A developer can create a new function by defining a new collection of MeTTa atoms (rules and goals) and loading them into Memory. This is the primary way to add new high-level behaviors.
-   **Adding New Inference Rules**: Since inference rules are just MeTTa atoms, new forms of reasoning can be introduced at runtime by simply adding new rule atoms to the Memory.
-   **Adding Grounded Atoms**: New capabilities for interacting with the external world (e.g., calling a new web API, controlling a new sensor) can be added by implementing new `GroundedAtom`s.
-   **Swapping Core Components**: The pluggable module architecture allows for different implementations of components like the `BudgetingStrategy` to be swapped out at initialization.

---

## 5. State Serialization and Persistence

To support long-running operation and recovery from shutdowns, the system must be able to serialize its entire state to persistent storage. A complete snapshot should include:

-   **Memory Content**: All atoms, `Sentences`, `Concept`s, and their associated metadata (`Truth` values, `Budget` values, etc.). This should ideally be stored in a format that is both efficient and human-readable, such as a stream of MeTTa expressions.
-   **Cognitive Function State**: The internal state of all stateful cognitive functions (e.g., the Goal Manager's current goal stack).
-   **System Configuration**: The `Config` atoms the system is currently running with.
-   **Event Queues**: A snapshot of any pending events or `Sentences` to ensure a seamless restart.

This capability is also essential for debugging, as it allows developers to capture and replay the exact state of the system at a specific moment.

The formal MeTTa definition for the system state snapshot can be found in [`spec/07_system_state.metta`](./spec/07_system_state.metta).
