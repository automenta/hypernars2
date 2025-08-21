;;;
;;; HyperNARS Cognitive Functions
;;;
;;; This file provides the formal definitions for the system's cognitive functions,
;;; organized by the three-layer cognitive architecture.
;;;

;;; ============================================================================
;;; Layer 1: Core Cognitive Functions (System 1)
;;; ============================================================================
;;; The "engine room" of the mind. These fundamental, continuously-operating
;;; functions drive the reflexive, System 1 reasoning loop.

;; NAL 1-4: Inductive & Conceptual Learning
(define-cognitive-function Deduction
  "The core NAL deduction rule: (A --> B), (B --> C) ==> (A --> C)"
  (= (deduce (. ($a --> $b) $t1 . $any) (. ($b --> $c) $t2 . $any))
     (. ($a --> $c) (deduction-truth-fn $t1 $t2))))

(define-cognitive-function Abduction
  "The core NAL abduction rule: (A --> B), (C --> B) ==> (C --> A) (a possible explanation)"
  (= (abduce (. ($a --> $b) $t1 . $any) (. ($c --> $b) $t2 . $any))
     (. ($c --> $a) (abduction-truth-fn $t1 $t2))))

(define-cognitive-function Induction
  "The core NAL induction rule: (A --> B), (A --> C) ==> (C --> B)"
  (= (induce (. ($a --> $b) $t1 . $any) (. ($a --> $c) $t2 . $any))
     (. ($c --> $b) (induction-truth-fn $t1 $t2))))

;; NAL 7: Temporal Reasoning
(define-cognitive-function Temporal-Deduction
  "The core temporal deduction rule: If (A happens before B) and (B happens before C), then (A happens before C)."
  (= (deduce-temporal (. ((A </> B)) $t1 . $any) (. ((B </> C)) $t2 . $any))
     (. ((A </> C)) (temporal-deduction-truth-fn $t1 $t2))))

;; NAL 8-9: Goal & Planning
(define-cognitive-function Backward-Chaining-Planner
  "The core backward-chaining planner rule. When a goal (! G) is processed, it looks for an operation (Op) that results in G, and then sets the preconditions (P) of that operation as a new subgoal."
  (= (handle (! $g))
     (match &self
            (. (($op ==> $g)) %true . $any)
            (match &self
                   (. ((has-precondition $op $p)) %true . $any)
                   (! $p)
                   (! (execute $op))))))

;;; ============================================================================
;;; Layer 2: Executive Control & Awareness (System 2 Initiation)
;;; ============================================================================
;;; The "foreman," monitoring the core functions and initiating deeper,
;;; more deliberate thought (System 2).

(define-cognitive-function Cognitive-Executive
  "The system's master control program, responsible for self-monitoring and initiating deliberation by tracking KPIs and triggering Layer 3 functions when thresholds are crossed.")

(define-function-interface Cognitive-Executive
  (Interface
    (Triggers (Event system-cycle-complete _))
    (Reads (has-value (kpi $name) $value))
    (Writes (! (Layer-3-Goal)))))

(define-cognitive-function Cognitive-Executive-Contradiction-Monitor
  "A rule that monitors the contradiction rate and triggers a resolution goal if the rate exceeds a configured threshold."
  (= (handle (Event system-cycle-complete _ _ _))
     (match &self
            (has-value (kpi contradiction_rate) $rate)
            (if (> $rate (Config contradiction-rate-threshold))
                (! (resolve-contradictions))
                ()) )))

(define-cognitive-function Contradiction-Management
  "Implements strategies for resolving contradictions between beliefs.")

(define-function-interface Contradiction-Management
  (Interface
    (Triggers (! (resolve-contradictions)) (Event contradiction-detected _ _))
    (Reads (Sentence-A) (Sentence-B) (Stamp-A) (Stamp-B))
    (Writes (! (revise (belief-to-weaken))))))

(define-cognitive-function Explanation
  "Generates human-readable explanations for the system's conclusions by tracing their derivational history.")

(define-function-interface Explanation
  (Interface
    (Triggers (! (explain (. $atom ...))))
    (Reads (Sentence) (Stamp))
    (Writes (GroundedAtom (explanation-text)))))


;;; ============================================================================
;;; Layer 3: Specialized Metacognition (System 2)
;;; ============================================================================
;;; The "strategist," handling the most abstract, goal-driven, and
;;; resource-intensive cognitive tasks, such as ethical reasoning and self-improvement.

(define-cognitive-function Conscience
  "Enforces ethical constraints and safety protocols by evaluating potential actions and goals against a set of inviolable, architect-defined rules.")

(define-function-interface Conscience
  (Interface
    (Triggers (Event goal-proposed $g) (Event sentence-selected $s))
    (Reads (. (Constraint (Forbid (action-pattern))) ...))
    (Writes (! (veto $g)) (! (modify $g)))))

;;;
;;; Layer 3 Self-Modification Function Stubs
;;;
(define-cognitive-function Self-Optimization-Function
  "Analyzes and refactors the system's own reasoning rules for better performance.")

(define-cognitive-function Test-Generation-Function
  "Proactively generates tests to verify the system's reasoning and the correctness of proposed self-modifications.")

(define-cognitive-function Codebase-Integrity-Function
  "Reasons about the system's own design documents and source code to find inconsistencies.")

(define-cognitive-function Implementation-Assistance-Function
  "Assists developers by automating parts of the implementation process.")
