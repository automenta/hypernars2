;;;
;;; HyperNARS Key Performance Indicators (KPIs)
;;;
;;; This knowledge base defines the Key Performance Indicators (KPIs) used for
;;; system self-monitoring. This "cognitive telemetry" is essential for the
;;; Cognitive Executive (Layer 2) to perform its function.
;;;

;;;
;;; 1. Reasoning KPIs
;;;
(define-kpi Reasoning avg_belief_confidence
   (Description "The average confidence of all belief sentences in Memory.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_belief_confidence) 0.78)))

(define-kpi Reasoning contradiction_rate
   (Description "The percentage of new beliefs that cause contradictions.")
   (SourceType Sentence)
   (Example (has-value (kpi contradiction_rate) 0.01)))

(define-kpi Reasoning rule_utility
   (Description "Average `quality` of conclusions produced by a specific inference rule.")
   (SourceType Sentence)
   (Example (has-value (kpi (rule_utility Deduce)) 0.82)))

(define-kpi Reasoning rule_cost
   (Description "Average execution time for a specific inference rule, in seconds.")
   (SourceType Sentence)
   (Example (has-value (kpi (rule_cost Abduce)) 0.000150)))

(define-kpi Reasoning stamp_overlap_rate
   (Description "The percentage of potential inferences that are prevented by stamp overlaps.")
   (SourceType Stamp)
   (Example (has-value (kpi stamp_overlap_rate) 0.02)))

;;;
;;; 2. Memory & Caching KPIs
;;;
(define-kpi Memory memory_utilization
   (Description "The percentage of total memory capacity currently being used.")
   (SourceType Bag)
   (Example (has-value (kpi memory_utilization) 0.6)))

(define-kpi Memory forgetting_rate
   (Description "The number of items being forgotten per second from `Bags`.")
   (SourceType Bag)
   (Example (has-value (kpi forgetting_rate) 12.5)))

(define-kpi Memory belief_count
   (Description "The total number of belief sentences currently in Memory.")
   (SourceType Sentence)
   (Example (has-value (kpi belief_count) 150000)))

(define-kpi Memory concept_hit_rate
   (Description "% of times a selected `Concept` contains a useful belief for the current `Sentence`.")
   (SourceType Concept)
   (Example (has-value (kpi concept_hit_rate) 0.35)))

(define-kpi Memory index_lookup_time
   (Description "The average time taken to retrieve an item from a memory index.")
   (SourceType Concept)
   (Example (has-value (kpi index_lookup_time) (2 milliseconds))))

(define-kpi Memory lti_distribution
   (Description "A histogram of the Long-Term Importance (LTI) values of all items in memory.")
   (SourceType Budget)
   (Example (has-value (kpi lti_distribution) (histogram ...))))

(define-kpi Memory avg_task_priority
   (Description "The average priority of all sentences in the system.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_task_priority) 0.65)))

;;;
;;; 3. Goal Management KPIs
;;;
(define-kpi GoalManagement goal_success_rate
   (Description "The percentage of goals that are successfully achieved.")
   (SourceType Sentence)
   (Example (has-value (kpi goal_success_rate) 0.95)))

(define-kpi GoalManagement goal_abandonment_rate
   (Description "The percentage of goals that are dropped due to low budget before being achieved.")
   (SourceType Sentence)
   (Example (has-value (kpi goal_abandonment_rate) 0.15)))

(define-kpi GoalManagement avg_goal_processing_time
   (Description "The average time from goal creation to achievement or abandonment.")
   (SourceType Sentence)
   (Example (has-value (kpi avg_goal_processing_time) (12 seconds))))

;;;
;;; 4. Grounding & API KPIs
;;;
(define-kpi Grounding grounding_success_rate
   (Description "The percentage of `GroundedAtom` executions that complete successfully.")
   (SourceType GroundedAtom)
   (Example (has-value (kpi grounding_success_rate) 0.99)))

(define-kpi Grounding avg_grounding_latency
   (Description "The average time taken for a `GroundedAtom` to execute, in milliseconds.")
   (SourceType GroundedAtom)
   (Example (has-value (kpi avg_grounding_latency) (150 milliseconds))))

(define-kpi Grounding api_requests_per_second
   (Description "The number of incoming requests to the public API per second.")
   (SourceType Event)
   (Example (has-value (kpi api_requests_per_second) 25)))
