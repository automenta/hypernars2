;;;
;;; HyperNARS Public API Definitions
;;;
;;; This file provides the formal definitions for the system's public API.
;;; This allows the system to reason about its own capabilities for interacting
;;; with the external world and with developers.
;;;

;;;
;;; 1. Core I/O
;;;
(define-api-method Input-Sentence
  (Purpose "Inputs a complete MeTTa Sentence (e.g., a belief, goal, or question) into the system."))

(define-api-method Subscribe-To-Event
  (Purpose "Subscribes a listener to a specific system event type (e.g., answer-generated, contradiction-detected)."))

;;;
;;; 2. Control & Configuration
;;;
(define-api-method Set-Reasoner-State
  (Purpose "Runs, pauses, or resumes the main reasoning loop."))

(define-api-method Get-Config-Parameter
  (Purpose "Retrieves the value of a system configuration parameter."))

(define-api-method Set-Config-Parameter
  (Purpose "Dynamically sets the value of a system configuration parameter at runtime."))

;;;
;;; 3. Inspection & Explainability
;;;
(define-api-method Get-Concept-State
  (Purpose "Retrieves the full state of a Concept, including its knowledge and sentence bags."))

(define-api-method Get-KPI-Value
  (Purpose "Retrieves the current value of a specific Key Performance Indicator."))

(define-api-method Request-Explanation
  (Purpose "Requests a structured, human-readable explanation for a derived Sentence."))

;;;
;;; 4. Semantic Layer
;;;
(define-api-method Add-Belief
  (Purpose "A high-level method to add a new belief to the knowledge base (e.g., by wrapping a raw Sentence)."))

(define-api-method Add-Goal
  (Purpose "A high-level method to add a new goal for the system to pursue."))

;;;
;;; 5. Hypothetical Reasoning
;;;
(define-api-method Create-Sandbox-Reasoner
  (Purpose "Creates an isolated 'sandbox' instance of the reasoner for hypothetical 'what-if' scenarios."))
