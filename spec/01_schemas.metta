;;;
;;; HyperNARS Metacognitive Schemas
;;;
;;; This file defines the "define-*" schemas used throughout the HyperNARS knowledge base.
;;; These atoms make the system's knowledge self-describing, allowing it to reason
;;; about its own structure, configuration, and capabilities. This file should be
;;; loaded early in the bootstrap process.
;;;

;; The schema for `define-type` itself, making the type system self-describing.
(: define-type (-> Symbol Atom String String Atom define-type))

;; A schema for defining a cognitive function or inference rule.
(define-type define-cognitive-function
   (Schema (: define-cognitive-function (-> Symbol String Atom define-cognitive-function)))
   (Purpose "A formal definition of a piece of the system's reasoning logic.")
   (Plain-English "A 'recipe' for a single piece of the system's thinking logic.")
   (Example (define-cognitive-function Deduce ...)))

;; A schema for defining the interface of a cognitive function.
(define-type define-function-interface
   (Schema (: define-function-interface (-> Symbol Atom define-function-interface)))
   (Purpose "A formal definition of a cognitive function's inputs, outputs, and triggers.")
   (Plain-English "The 'user manual' for a cognitive function, explaining what it needs and does.")
   (Example (define-function-interface Contradiction-Management ...)))

;; A schema for defining a single layer of the cognitive architecture.
(define-type define-cognitive-layer
   (Schema (: define-cognitive-layer (-> Number Symbol Symbol (List Symbol) define-cognitive-layer)))
   (Purpose "A formal definition of a cognitive layer and the functions within it.")
   (Plain-English "A 'department' in the system's mind, grouping related functions.")
   (Example (define-cognitive-layer 1 ...)))

;; A schema for defining the complete, layered cognitive architecture.
(define-type define-cognitive-architecture
   (Schema (: define-cognitive-architecture (-> Symbol (List define-cognitive-layer) define-cognitive-architecture)))
   (Purpose "A formal definition of the system's entire cognitive structure.")
   (Plain-English "The 'blueprint' for the system's entire mind.")
   (Example (define-cognitive-architecture HyperNARS-Standard-Model ...)))

;; A schema for formally defining the ordered steps of a reasoning cycle or cognitive process.
(define-type define-reasoning-cycle
   (Schema (: define-reasoning-cycle (-> Symbol (List (-> Number Symbol String)) define-reasoning-cycle)))
   (Purpose "A formal definition of a multi-step thinking process.")
   (Plain-English "A 'checklist' for a specific thinking process.")
   (Example (define-reasoning-cycle Reflexive-Reasoning-Cycle ...)))

;; A schema for defining a configuration parameter, its purpose, and its default value.
(define-type define-configuration
   (Schema (: define-configuration (-> Symbol String Atom define-configuration)))
   (Purpose "A formal definition of a system setting.")
   (Plain-English "A 'settings knob' that controls how the system behaves.")
   (Example (define-configuration contradiction-rate-threshold ...)))

;; A schema for defining the ordered steps of the system bootstrap process.
(define-type define-bootstrap-sequence
   (Schema (: define-bootstrap-sequence (-> Symbol (List (-> Number Symbol String)) define-bootstrap-sequence)))
   (Purpose "A formal definition of how the system starts up.")
   (Plain-English "The 'instruction manual' for starting the system.")
   (Example (define-bootstrap-sequence System-Startup ...)))

;; A schema for formally comparing the roles of different sentence types.
(define-type define-sentence-distinction
   (Schema (: define-sentence-distinction (-> Symbol Symbol String Atom String define-sentence-distinction)))
   (Purpose "A formal definition of what a sentence type means and how the system should react to it, for comparative purposes.")
   (Plain-English "A 'comparison chart' for different types of sentences.")
   (Example (define-sentence-distinction . Belief ...)))

;; A schema for defining a Key Performance Indicator (KPI) used for system self-monitoring.
(define-type define-kpi
   (Schema (: define-kpi (-> Symbol Symbol (List Atom) define-kpi)))
   (Purpose "A formal definition of a system Key Performance Indicator. Attributes include Description, SourceType, an optional Unit, and an Example.")
   (Plain-English "A 'dashboard gauge' for measuring the system's performance.")
   (Example (define-kpi Reasoning rule_cost (Unit seconds) ...)))

;; A schema for defining a method in the system's public API.
(define-type define-api-method
   (Schema (: define-api-method (-> Symbol (List Atom) define-api-method)))
   (Purpose "A formal definition of a public API method. Attributes include Purpose, Parameters, and Returns.")
   (Plain-English "A 'button' on the system's public control panel.")
   (Example (define-api-method Get-KPI-Value (Parameters (KPI-Name Symbol)) (Returns (KPI-Value Number)) ...)))

;; A schema for defining the structure of a system state snapshot.
(define-type define-system-snapshot
   (Schema (: define-system-snapshot (-> Symbol (List (-> Symbol String)) define-system-snapshot)))
   (Purpose "A formal definition of the components of a complete system state snapshot.")
   (Plain-English "A 'photograph' of the system's complete state at a moment in time.")
   (Example (define-system-snapshot Complete-System-State ...)))
