;;;
;;; HyperNARS Core Types
;;;
;;; This file defines the fundamental, atomic data structures of the system.
;;; These types form the basis for all other knowledge representation.
;;;

;;;
;;; 1. Metadata Types
;;;
(define-type Truth
   (Schema (: Truth (-> Float Float Truth)))
   (Purpose "Represents epistemic value (frequency, confidence).")
   (Plain-English "How much the system believes something is true.")
   (Example (Truth 0.9 0.8)))

(define-type Budget
   (Schema (: Budget (-> Float Float Float Budget)))
   (Purpose "Represents attentional value (priority, durability, quality).")
   (Plain-English "How much attention the system should pay to something.")
   (Example (Budget 0.99 0.5 0.85)))

(define-type Stamp
   (Schema (: Stamp (-> TaskID (Set TaskID) Stamp)))
   (Purpose "Tracks derivational history to prevent loops. TaskID is a unique string identifier.")
   (Plain-English "A 'paper trail' to track where a piece of information came from.")
   (Example (Stamp "t_7f8a..." (Set "t_1c5b..." "t_9e2d..."))))

;;;
;;; 2. Sentence Types (with Punctuation)
;;;
(define-type .
   (Schema (: . (-> Atom Truth Budget Stamp .)))
   (Purpose "Represents a piece of knowledge to be processed or stored.")
   (Plain-English "A statement of fact, like 'the sky is blue'.")
   (Example (. (bird --> flyer) (Truth 0.9 0.9) (Budget 0.9 0.8 0.7) (Stamp ...))))

(define-type !
   (Schema (: ! (-> Atom Budget Stamp !)))
   (Purpose "Represents a state to be achieved.")
   (Plain-English "A desired state, like 'the light is on'.")
   (Example (! (door-is-open) (Budget 0.9 0.5 0.8) (Stamp ...))))

(define-type ?
   (Schema (: ? (-> Atom Budget Stamp ?)))
   (Purpose "Represents a request for information.")
   (Plain-English "A request for information, like 'what color is the sky?'.")
   (Example (? (what-is-a-bird) (Budget 0.9 0.1 0.2) (Stamp ...))))

(define-type @
   (Schema (: @ (-> Atom Budget Stamp @)))
   (Purpose "Represents a long-term, curiosity-driven exploration goal.")
   (Plain-English "An open-ended exploration task, like 'investigate the properties of birds'.")
   (Example (@ (explore-concept bird) (Budget 0.8 0.9 0.9) (Stamp ...))))

;;;
;;; 3. System-Level Types
;;;
(define-type Event
   (Schema (: Event (-> Symbol Atom Atom TimePoint Event)))
   (Purpose "Used for the internal event bus.")
   (Plain-English "A notification that something has happened, like 'a contradiction was found'.")
   (Example (Event contradiction-detected (belief-1) (belief-2) (now))))

(define-type Config
   (Schema (: Config (-> Atom Atom Config)))
   (Purpose "Defines a configuration setting. The key is often a Symbol or an Expression.")
   (Plain-English "A setting that controls how the system behaves.")
   (Example (Config BudgetingStrategy (GroundedAtom "SimpleBudgetingStrategy"))))

(define-type has-value
   (Schema (: has-value (-> Atom Number has-value)))
   (Purpose "Represents a belief about a system Key Performance Indicator (KPI).")
   (Plain-English "A belief about the system's own performance.")
   (Example (has-value (kpi avg_belief_confidence) 0.78)))
