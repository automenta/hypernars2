;;;
;;; HyperNARS Cognitive Architecture
;;;
;;; This file provides the formal, self-describing models of the system's
;;; high-level cognitive architecture and its core reasoning processes.
;;;

;;;
;;; 1. Cognitive Architecture Definition
;;;
(define-cognitive-architecture HyperNARS-Standard-Model
   (
      ;; Layer 1: The reflexive, high-speed reasoning core.
      (define-cognitive-layer 1
         "Core Cognitive Functions"
         "System 1"
         (NAL-Inference-Rules Goal-Planning Temporal-Reasoning))

      ;; Layer 2: Monitors the system and initiates deliberation.
      (define-cognitive-layer 2
         "Executive Control & Awareness"
         "System 2 Initiation"
         (Cognitive-Executive))

      ;; Layer 3: Handles abstract, strategic, and ethical reasoning.
      (define-cognitive-layer 3
         "Specialized Metacognition"
         "System 2"
         (Conscience-Function Self-Modification))
   )
)

;;;
;;; 2. Reasoning Cycle Definitions
;;;

;;; 2.1. System 1: Reflexive Reasoning
(define-reasoning-cycle Reflexive-Reasoning-Cycle
   (
      (1 Select-Concept "Select a Concept from Memory's concept bag based on priority.")
      (2 Select-Active-Sentence "Select a high-priority Sentence from the Concept's local sentence bag.")
      (3 Select-Relevant-Belief "Select a relevant belief from the same Concept's knowledge bag.")
      (4 Formulate-Inference-Expression "Formulate an Inference Expression by selecting a rule and wrapping the two sentences in it.")
      (5 Invoke-MeTTa-Interpreter "Invoke the MeTTa Interpreter to evaluate the expression against its knowledge base.")
      (6 Process-Derived-Sentences "Process the derived sentences by calculating budget, creating stamps, and dispatching them to memory.")
      (7 Perform-Housekeeping "Perform system-level housekeeping, such as budget updates and event emissions.")
   )
)

;;; 2.2. System 2: Deliberative Reasoning
(define-reasoning-cycle Deliberative-Reasoning-Process
   (
      (1 Initiation-and-Context-Scoping "Create a temporary workspace and populate it with knowledge relevant to the trigger sentence.")
      (2 Focused-Iterative-Reasoning "Run a high-budget reasoning loop within the workspace to find a solution.")
      (3 Resolution-and-Integration "Extract the solution from the workspace and inject it back into main memory.")
      (4 Decommissioning "Dissolve the temporary workspace.")
   )
)
