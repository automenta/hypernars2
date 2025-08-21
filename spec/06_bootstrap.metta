;;;
;;; HyperNARS System Bootstrap Sequence
;;;
;;; This file defines the formal sequence of steps for system initialization.
;;; A system loader would use this definition to ensure a correct startup.
;;;

(define-bootstrap-sequence System-Startup
   (
      (1 Load-Configuration "Load all `Config` atoms from a file or environment.")
      (2 Initialize-Memory "Initialize the Memory system and its indexes.")
      (3 Initialize-MeTTa-Interpreter "Start the interpreter.")
      (4 Load-Foundational-Knowledge "Load a base set of inference rules and ontological atoms.")
      (5 Register-Cognitive-Functions "Load the atoms for all configured Cognitive Functions.")
      (6 Start-Reasoning-Loop "Begin the main control unit's reasoning cycle.")
   )
)
