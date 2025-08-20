# System Architecture

The HyperNARS architecture is a modular, dynamic system designed around a refined principle: **"The Content is an Atom, the Work is a Task."** While all knowledge and logic are ultimately represented as MeTTa atoms, the system organizes these atoms into a clear hierarchy (`Atom` -> `Sentence` -> `Task`) for conceptual clarity and implementability. This creates an exceptionally flexible, transparent, and self-modifiable system.

The architecture is centered on two core components: a **Memory** space, which holds all data, and a **MeTTa Interpreter**, which continuously evaluates atoms to drive the reasoning process. Higher-level cognitive capabilities are not implemented as separate software modules, but as collections of MeTTa atoms called **Cognitive Functions**.

---

## 1. Design Rationale: The Metaprogramming Approach

The choice to build the entire architecture on a programmable, symbolic foundation is deliberate and central to the project's goals.

-   **Ultimate Flexibility**: Traditional architectures have hard-coded components (e.g., event buses, configuration parsers, inference engines). In HyperNARS, these are all implemented as MeTTa programs and data. They can be modified at runtime simply by changing the atoms in Memory, without recompiling or restarting the system.

-   **Deep Introspection**: Because the system's own logic and configuration are represented as data, it can "reason about itself." A Cognitive Function can be written to analyze the performance of inference rules, inspect the event stream, or check its own configuration for inconsistencies.

-   **Simplicity and Elegance**: By using a single representation for content (Atoms) and a single processing mechanism (the MeTTa Interpreter), the overall complexity is dramatically reduced. The architecture is defined by the *content* of its Memory, not by a rigid, external structure.

---

## 2. Component Diagram

This diagram illustrates the flow of information and control. It is a conceptual map of the primary data structures and processes in the HyperNARS ecosystem.

```mermaid
graph TD
    subgraph AppLayer [Application & Grounding]
        direction LR
        API(Public API)
        GroundingInterface(Grounding Interface)
    end

    subgraph MettaSpace [Memory Space]
        direction TB
        subgraph Knowledge [Knowledge Base]
            Sentences("Knowledge (Sentences)")
            Workload("Workload (Tasks)")
            EventStream("Event Stream (Atoms)")
        end
        subgraph Logic [Logic & Configuration]
            InferenceRules("Inference Rules (Atoms)")
            CognitiveFunctions("Cognitive Functions (Atoms)")
            SystemConfig("System Configuration (Atoms)")
        end
    end

    subgraph ReasoningProcess [Reasoning Process]
        ControlLoop(Control Loop)
        MeTTaInterpreter(MeTTa Interpreter)
    end

    API -- "Injects new Tasks" --> Workload
    GroundingInterface -- "Provides Grounded Atoms" --> Knowledge

    ControlLoop -- "Selects Task & Sentence" --> MettaSpace
    ControlLoop -- "Passes to Interpreter" --> MeTTaInterpreter
    MeTTaInterpreter -- "Matches & Evaluates using Logic" --> Logic
    MeTTaInterpreter -- "Produces new Sentences" --> Knowledge

    Workload -- "Triggers" --> CognitiveFunctions
    CognitiveFunctions -- "Inject New Tasks" --> Workload
    Sentences -- "Emits Events" --> EventStream
    EventStream -- "Triggers" --> CognitiveFunctions

    classDef default fill:#fff,stroke:#333,stroke-width:1.5px;
    classDef layer fill:#f8f8f8,stroke:#666,stroke-width:2px,stroke-dasharray: 3 3;
    class AppLayer,MettaSpace,ReasoningProcess layer;
```

---

## 3. Event-Driven Communication via MeTTa

The system avoids a traditional, external event bus. Instead, eventing and messaging are handled directly within the Memory space, making the communication process itself introspectable and modifiable.

-   **Events as Atoms**: An "event" is simply the act of adding a specific `Event` atom to Memory. (See `DATA_STRUCTURES.md` for the formal schema).
    -   `sentence-added` -> `(Event sentence-added <sentence-1> (now))`
    -   `contradiction-detected` -> `(Event contradiction-detected <sentence-1> <sentence-2> (now))`

-   **Handlers as MeTTa Rules**: Cognitive Functions "handle" events by defining MeTTa rules that match on these `Event` atoms. They are, in effect, persistent queries over the event stream.
    ```metta
    ;; The ContradictionManager function is just a MeTTa rule.
    (= (handle (Event contradiction-detected $s1 $s2 $t))
       (Goal (resolve-contradiction $s1 $s2)))
    ```

---

## 4. Configurable Architecture via MeTTa

The system's entire configuration is defined by a set of `Config` atoms, typically loaded from a `.metta` file at startup. This allows the system's behavior, capabilities, and even its "personality" to be defined and modified using its own native language.

### Example: `minimalist-reasoner.metta`

This configuration file defines a simple reasoner with only the most basic cognitive functions enabled.

```metta
;; --- minimalist-reasoner.metta ---

;; Define the 'personality' of this instance
(Config personality "Minimalist Reasoner")

;; == Component Selection ==
;; Select the implementation for the core budgeting strategy.
(Config BudgetingStrategy (GroundedAtom "SimpleBudgetingStrategy"))

;; == Cognitive Function Activation ==
;; Define which cognitive functions are active for this run.
(Config (active-cognitive-function GoalManager) True)
(Config (active-cognitive-function ContradictionManager) True)
(Config (active-cognitive-function TemporalReasoner) False)       ; Disabled
(Config (active-cognitive-function SelfOptimizationManager) False) ; Disabled
(Config (active-cognitive-function Conscience) False)             ; Disabled

;; == System Parameter Tuning ==
;; Define the system's operational parameters.
;; All schemas are formally defined in DATA_STRUCTURES.md.

;; Default budget for new Beliefs asserted from outside (uses Budget schema)
(Config default-belief-budget (Budget 0.9 0.9 0.5))

;; Default budget for new Goals asserted from outside (uses Budget schema)
(Config default-goal-budget (Budget 0.99 0.9 0.9))

;; Threshold for the CognitiveExecutive to trigger contradiction management
(Config contradiction-rate-threshold 0.05)

;; == Initial Knowledge ==
;; The configuration can also include initial Sentences to seed the system's memory.

;; A foundational ethical principle, as a Belief Sentence.
(Belief <(Forbid (Goal (cause-harm-to-human)))> (TruthValue 1.0 0.99))
```
This approach makes the system's architecture transparent, dynamically reconfigurable, and deeply aligned with the metaprogramming philosophy.
