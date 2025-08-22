;;;
;;; Formal Definition of the System State Snapshot Schema
;;;
(define-system-snapshot Complete-System-State
  (
    (Memory-Content "All atoms, Sentences, Concepts, and their associated metadata.")
    (Cognitive-Function-State "The internal state of all stateful cognitive functions.")
    (System-Configuration "The Config atoms the system is currently running with.")
    (Event-Queues "A snapshot of any pending events or Sentences to ensure a seamless restart.")
  )
)
