# API and Integration Guide

This document covers the practical aspects of using, configuring, and extending the system.

## 1. I/O and Public API

The public API is designed to be clean, language-agnostic, and powerful. It is event-driven and asynchronous where appropriate.

-   **Core Input/Output API**: Provides methods to:
    -   Input a MeTTa atom as a task or belief.
    -   Ask a question by providing a query atom.
    -   Subscribe to system events like `answer-generated`, `contradiction-detected`, or `goal-achieved`.
-   **Control & Configuration API**: Provides methods to:
    -   Run the reasoning cycle.
    -   Pause and resume the reasoning loop.
    -   Dynamically change system configuration parameters.
-   **Inspection & Explainability API**: Provides methods to:
    -   Retrieve the full state of a concept.
    -   Get detailed operational metrics.
    -   Request a structured explanation for a belief.

### 1.1. The Semantic API Layer
To improve usability, the system can provide a higher-level, intention-driven API that wraps the raw MeTTa input. This "semantic API" would allow developers to interact with the system more naturally (e.g., via methods like `createInheritanceBelief()` or `addGoal()`).

### 1.2. Hypothetical Reasoning via Sandboxing
The API should provide a method for creating isolated "sandbox" instances of the reasoner. This allows for hypothetical or "what-if" reasoning without polluting the main knowledge base.

### 1.3. Real-time Data Protocols
For applications in robotics and real-time control systems, the architecture should be flexible enough to support low-latency, streaming data protocols in addition to a standard request-response API.

## 2. System Initialization and Configuration

The system's behavior is heavily influenced by a set of configurable parameters that reflect the assumptions of AIKR. The system is initialized with a configuration object that allows overriding these parameters.

### 2.1. Configuration Categories
Configuration is organized into logical groups. Examples include:

-   **Core Engine Parameters**: Control the fundamental reasoning process (e.g., maximum derivation depth, inference selectivity thresholds).
-   **Memory Management**: Control the size and behavior of memory (e.g., concept capacity, forgetting rates, pruning thresholds).
-   **Contradiction Handling**: Parameters for contradiction detection (e.g., confidence threshold).
-   **Temporal Reasoning**: Parameters for time-based reasoning (e.g., how far into the future to make predictions).
-   **Budget Allocation**: A structured configuration for the budget allocation function, allowing weights for different factors (novelty, urgency, etc.) to be tuned.
-   **Cognitive Executive**: Parameters for the self-monitoring loop (e.g., metric thresholds that trigger adaptation, adaptation learning rate).

### 2.2. Bootstrap Process
The system follows a well-defined sequence to ensure a stable startup:
1.  **Load Configuration**: Load configuration from a file or environment variables.
2.  **Initialize Event Bus**: Create the central asynchronous event bus.
3.  **Initialize Memory**: Initialize the Memory system and its indexes.
4.  **Initialize MeTTa Interpreter**: Start the interpreter and load foundational inference rules.
5.  **Register Cognitive Managers**: Instantiate all configured Cognitive Managers and subscribe them to events.
6.  **Load Foundational Knowledge**: Load a base set of declarative and procedural knowledge into Memory.
7.  **Start Reasoning Loop**: Begin the main control unit's reasoning cycle.

## 3. Extension Points

The architecture is designed to be extensible at multiple levels, allowing developers to add new capabilities without modifying the core kernel.

-   **Adding New Cognitive Managers**: A developer can create a new manager that subscribes to kernel events and injects tasks to implement novel high-level cognitive functions. This is the primary way to add new behaviors.
-   **Adding New Inference Rules**: Since inference rules are just MeTTa atoms, new forms of reasoning can be introduced at runtime by simply adding new rule atoms to the Memory.
-   **Adding Grounded Atoms**: New capabilities for interacting with the external world can be added by implementing new grounded atoms and registering them with the Grounded Atom Interface. This is how the system learns new "skills".
-   **Swapping Core Components**: The pluggable module architecture allows for different implementations of components like the Memory system or budget functions to be swapped out at initialization.

## 4. State Serialization and Persistence

To support long-running operation and recovery from shutdowns, the system must be able to serialize its entire state to persistent storage. A complete snapshot should include:

-   **Memory Content**: All atoms, beliefs, concepts, and their associated metadata (TruthValues, activation levels). This should ideally be stored in a format that is both efficient and human-readable, such as a stream of MeTTa expressions.
-   **Cognitive Manager State**: The internal state of all cognitive managers (e.g., the Goal Manager's current goal stack).
-   **System Configuration**: The configuration parameters the system is currently running with.
-   **Event Queues**: A snapshot of any pending events or tasks to ensure a seamless restart.

This capability is also essential for debugging, as it allows developers to capture and replay the exact state of the system at a specific moment.
