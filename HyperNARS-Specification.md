# HyperNARS: A Blended Specification

## 1. Introduction: Vision and Goals

This document outlines the specification for **HyperNARS**, a next-generation Artificial General Intelligence (AGI) system design. HyperNARS represents a fusion of two powerful AGI paradigms:

1.  **Non-Axiomatic Reasoning System (NARS):** A formal theory of intelligence based on the principle of adaptation under insufficient knowledge and resources. It provides a robust, experience-grounded logic (NAL) for reasoning and learning.
2.  **OpenCog Hyperon:** A modern AGI framework designed for scalability, flexibility, and deep integration with other AI technologies. It uses a powerful knowledge representation substrate (the AtomSpace) and a dedicated programming language (**MeTTa**) for implementing cognitive algorithms.

### 1.1. Core Objective

The primary goal of this specification is to **blend the capabilities of Hyperon/MeTTa into the NARS architecture**. This fusion aims to create a system that is greater than the sum of its parts:

*   **Scalable Reasoning:** Leverage Hyperon's distributed AtomSpace to allow NARS to manage vast knowledge bases and scale its reasoning processes far beyond single-machine implementations.
*   **Expressive & Unified Representation:** Use MeTTa as a unified language to represent NARS's core components—Narsese, inference rules, and control logic—within the AtomSpace. This replaces the need for separate, ad-hoc data structures and allows the system to reason about its own workings.
*   **Deep ML/LLM Integration:** Provide a native, fine-grained mechanism for integrating modern Machine Learning (ML) and Large Language Model (LLM) technologies directly into the core reasoning loop.
*   **Elegance and Coherency:** Fold redundant concepts and align components to create a more elegant, coherent, and powerful AGI design, preferring NARS terminology where applicable to maintain conceptual integrity.

This document will specify how Narsese is mapped to MeTTa, how Non-Axiomatic Logic is implemented using MeTTa functions, how the NARS control loop operates within Hyperon, and how deep learning models can be seamlessly integrated as first-class citizens in the reasoning process.

## 2. Core Representation: Narsese in MeTTa

The foundation of HyperNARS is the representation of Narsese, the formal language of NARS, within MeTTa. This approach treats knowledge, rules, and goals as data, stored uniformly in the AtomSpace.

### 2.1. The AtomSpace as the Unified Knowledge Base

All components of the NARS cognitive architecture—concepts, beliefs, tasks, and even inference rules—are represented as atoms in the Hyperon AtomSpace. The AtomSpace's metagraph structure is a natural fit for the relational nature of NARS's knowledge. This eliminates the distinction between "code" and "data," allowing the system to introspect and modify its own logic.

### 2.2. Terms

Narsese terms are mapped to MeTTa symbols or expressions.

*   **Atomic Terms:** A simple Narsese term becomes a MeTTa Symbol.
    *   Narsese: `bird`
    *   MeTTa: `bird`

*   **Compound Terms (Intensional Set):** A set defined by its properties.
    *   Narsese: `{big, red}`
    *   MeTTa: `(IntensionalSet big red)`

*   **Compound Terms (Extensional Set):** A set defined by its instances.
    *   Narsese: `[tweety, woody]`
    *   MeTTa: `(ExtensionalSet tweety woody)`

*   **Compound Terms (Conjunction):** A composite concept.
    *   Narsese: `(&&, big, bird)`
    *   MeTTa: `(And big bird)`

### 2.3. Statements, Copulas, and Truth Values

A Narsese statement, which expresses a relationship between a subject and a predicate, is represented as a MeTTa expression.

*   **Structure:** `(Statement <copula> <subject> <predicate> <truth-value>)`
*   **Copulas:** NARS copulas are represented as MeTTa Symbols (e.g., `Inheritance`, `Similarity`, `Instance`, `Property`).
*   **Truth Value:** The NARS truth value `<f, c>` (frequency, confidence) is encapsulated in its own expression.
    *   Narsese: `bird --> animal <1.0, 0.9>`
    *   MeTTa: `(Statement Inheritance bird animal (TruthValue 1.0 0.9))`
    *   Narsese: `raven <-> crow <0.8, 0.95>`
    *   MeTTa: `(Statement Similarity raven crow (TruthValue 0.8 0.95))`

### 2.4. Tasks: Judgments, Questions, and Goals

The NARS punctuation, which indicates the type of task, is represented by a wrapping expression around a statement.

*   **Judgment:** A piece of knowledge to be absorbed. The truth value is required.
    *   Narsese: `bird --> animal. <1.0, 0.9>`
    *   MeTTa: `(Judgement (Statement Inheritance bird animal (TruthValue 1.0 0.9)))`

*   **Question:** A query about a relationship. The truth value is omitted.
    *   Narsese: `bird --> animal?`
    *   MeTTa: `(Question (Statement Inheritance bird animal))`

*   **Goal:** A state of affairs the system should try to realize. This is a special type of judgment to be achieved.
    *   Narsese: `eat! <0.9, 0.9>`
    *   MeTTa: `(Goal (Statement Inheritance <self> eat (TruthValue 0.9 0.9)))`

## 3. Inference: Non-Axiomatic Logic in MeTTa

The NARS inference process is reimagined as MeTTa's native expression reduction mechanism. Inference rules are not just theoretical constructs but are themselves atoms in the AtomSpace, allowing the system to learn and reason about its own reasoning processes.

### 3.1. Inference as Expression Reduction

At its core, a NARS inference step takes one or two existing beliefs (premises) and derives a new belief (conclusion). In HyperNARS, this is modeled as the reduction of a MeTTa expression. The `match` function, a core feature of MeTTa's interpreter, is used to find premises in the AtomSpace that fit the pattern of a given inference rule.

### 3.2. Representing NAL Rules in MeTTa

Each of NAL's syllogistic and structural rules is defined as a MeTTa reduction rule. This is typically done using the `=` (equality) operator, which defines a rewrite rule. Variables are denoted with a `$` prefix.

**Example: The NAL Deduction Rule**

The classic NAL deduction rule states that from `S --> M` and `M --> P`, we can deduce `S --> P`.

*   **NARS Logic:** `{(S --> M), (M --> P)} |- (S --> P)`

*   **MeTTa Representation:** This rule is formulated as a MeTTa expression that matches two `Judgement` atoms and reduces them to a new, derived `Judgement`.

    ```metta
    (= (Deduction
          (Judgement (Statement Inheritance $S $M (TruthValue $f1 $c1)))
          (Judgement (Statement Inheritance $M $P (TruthValue $f2 $c2))))
       (Judgement (Statement Inheritance $S $P (TruthValue (deduction-f $f1 $f2)
                                                             (deduction-c $f1 $c2)))))
    ```

In this structure:
*   `Deduction` is a MeTTa operation representing the inference act.
*   `$S`, `$M`, and `$P` are variables that will be bound to the subject, middle, and predicate terms during matching.
*   `deduction-f` and `deduction-c` are grounded MeTTa functions that calculate the frequency and confidence of the conclusion based on the premises, according to NAL's truth functions.

Other NAL rules (abduction, induction, analogy, etc.) are defined similarly, each with its own MeTTa signature and corresponding truth function.

### 3.3. Leveraging Non-Determinism for Inference Control

NARS operates by continually selecting a concept and a task, then trying to apply relevant inference rules. MeTTa's non-deterministic computation primitives (`superpose` and `collapse`) provide a powerful and elegant way to manage this process.

When the system focuses on a task, it can query the AtomSpace for all possible inference steps that could be taken. Instead of executing just one, it can create a `superpose` atom representing the set of all possible conclusions.

*   **Example:**
    ```metta
    (superpose [
      (Deduction premiseA premiseB),
      (Analogy premiseC premiseD),
      (Induction premiseE premiseF)
    ])
    ```
This allows the system to hold multiple competing hypotheses simultaneously. The NARS control mechanism can then use the priority values of the involved premises and the estimated truth values of the potential conclusions to intelligently allocate resources, eventually choosing to `collapse` the most promising path and add the resulting conclusion to the AtomSpace.

## 4. Control Loop and Learning

HyperNARS retains the core principles of NARS's resource-bounded reasoning but implements them on top of the Hyperon framework. Learning is not a separate module but an emergent property of the continuous inference and resource allocation cycle.

### 4.1. Attention, Concepts, and the Control Cycle

The NARS control loop is driven by an attention allocation mechanism that determines which atoms are most important for processing at any given moment.

*   **Attention Values:** Every atom in the AtomSpace, particularly Tasks and Judgements, is associated with an `AttentionValue` atom. This value encapsulates NARS concepts like *priority*, *durability*, and *quality*.
*   **Concepts:** A NARS "concept" is implicitly represented by the set of all atoms that contain a specific term (e.g., all atoms containing the `bird` symbol). The "activation" of a concept is the aggregate attention of its constituent atoms.

The HyperNARS working cycle proceeds as follows:

1.  **Select Task:** The system selects a Task atom (a `Question` or `Goal`) from the AtomSpace with a high `AttentionValue`.
2.  **Select Belief:** Based on the terms within the selected Task, the system queries the AtomSpace for a relevant Belief atom (`Judgement`) that also has a high `AttentionValue`.
3.  **Trigger Inference:** The selected Task and Belief are fed into the MeTTa interpreter. The interpreter matches them against the library of defined NAL inference rules (see Section 3.2).
4.  **Generate Conclusions:** The execution of an inference rule produces a new atom (a derived Judgement or a new sub-task). This new atom is added to the AtomSpace.
5.  **Update Attention:** The `AttentionValue`s of all involved atoms (premises, conclusions, concepts) are updated. Premises that lead to useful conclusions are reinforced, while the attention of unused atoms decays over time.

### 4.2. Learning as Continuous Adaptation

In HyperNARS, learning is a continuous process of evidence accumulation and structural adaptation.

*   **Belief Revision:** The NAL Revision rule is the primary mechanism for learning from new evidence. When a new `Judgement` is derived that pertains to the same statement as an existing `Judgement`, the `Revise` rule is triggered. This is defined as a standard MeTTa reduction:

    ```metta
    (= (Revise
          (Judgement (Statement $copula $S $P (TruthValue $f1 $c1)))
          (Judgement (Statement $copula $S $P (TruthValue $f2 $c2))))
       (Judgement (Statement $copula $S $P (TruthValue (revision-f $f1 $c1 $f2 $c2)
                                                         (revision-c $f1 $c1 $f2 $c2)))))
    ```
    This rule merges the two pieces of evidence, producing a new, more informed belief.

*   **Structural Learning:** By representing inference rules as atoms themselves, a sufficiently advanced HyperNARS could learn new inference patterns (structural rules) or modify existing ones, achieving a form of meta-learning.

## 5. Deep Integration with Machine Learning

A primary advantage of the HyperNARS architecture is its capacity for deep, fine-grained integration with Machine Learning (ML) and Large Language Model (LLM) technologies. This is achieved through "grounded atoms," which bridge the symbolic space of MeTTa with external computational processes.

### 5.1. Grounded Atoms as a Neural-Symbolic Bridge

A grounded atom is a special type of atom in the AtomSpace that is associated with an executable procedure (e.g., a Python function). When the MeTTa interpreter evaluates an expression containing a grounded atom, it executes the associated procedure. This allows HyperNARS to treat ML models as first-class functions within its own language.

### 5.2. Use Cases for ML/LLM Integration

ML models can be integrated to perform various functions within the cognitive cycle, acting as powerful, specialized sub-routines for the main reasoning engine.

**Example 1: Perceptual Grounding via Embedding Models**

A sentence-embedding model can be wrapped in a grounded atom to provide perceptual grounding for language.

*   **Grounded Atom:** `embed`
*   **MeTTa Expression:** `(embed "A black bird")`
*   **Execution:** The interpreter calls the associated Python function, which runs a transformer model on the input string and returns a vector `[0.12, -0.45, ..., 0.88]`.
*   **Result:** The resulting vector can be stored in the AtomSpace and used to calculate the similarity between concepts, providing a continuous, data-driven complement to NARS's discrete symbolic similarity (`<->`).

**Example 2: Hypothesis Generation via LLMs**

An LLM can be used as a creative "brainstorming" partner for the reasoning engine, proposing new beliefs and goals.

*   **Grounded Atom:** `GenerateHypothesis`
*   **MeTTa Expression:** `(GenerateHypothesis (Statement Inheritance bird $X))`
*   **Execution:** This calls the LLM with a carefully crafted prompt, such as "Based on common knowledge, complete the following statement: A bird is a type of...". The LLM might return the token "animal".
*   **Result:** The grounded atom then wraps this output into a proper NARS judgment but assigns it a very low confidence value.
    *   ` (Judgement (Statement Inheritance bird animal (TruthValue 1.0 0.1)))`
This new, low-confidence belief is injected into the AtomSpace. It is not blindly trusted; it is merely a hypothesis that the NARS reasoning process will now test against its existing knowledge base. It may be strengthened if it's consistent with other beliefs or rejected if it leads to contradictions.

### 5.3. The Neural-Symbolic Cycle

This integration creates a powerful, bidirectional feedback loop:

1.  **Symbolic-to-Neural:** The NARS reasoning engine uses its logic to determine when it has a knowledge gap. It can then formulate a precise query or prompt and dispatch it to the appropriate grounded ML model. This ensures that the powerful but computationally expensive models are used strategically.
2.  **Neural-to-Symbolic:** The output from the ML models (classifications, text, etc.) is not taken as ground truth. It is converted into the formal language of Narsese, with appropriate truth values reflecting its uncertain origin. This symbolic knowledge is then subjected to the rigorous, evidence-based scrutiny of the NAL inference rules.

This cycle allows HyperNARS to combine the pattern-recognition strengths of neural networks with the logical rigor and transparency of a symbolic reasoning system, creating a more robust and versatile form of intelligence.

## 6. Conclusion

This specification outlines a path toward HyperNARS, a system that integrates the principled reasoning of NARS with the scalable, flexible, and modern infrastructure of OpenCog Hyperon. By representing Narsese in MeTTa and running the NARS control loop on the AtomSpace, HyperNARS is designed to be a highly scalable and introspective reasoning system. The deep, native integration of machine learning models via grounded atoms provides a clear strategy for creating a synergistic neural-symbolic architecture. The result is a coherent AGI design that is well-suited for tackling complex real-world problems.
