# Symbol Grounding

This document describes the **Grounded Atom Interface (GAI)**, the core mechanism responsible for connecting the system's internal symbolic logic to the external world. It details *how* the system interacts with sensors, actuators, and external models.

All terminology is formally defined in the [**Glossary**](./DATA_STRUCTURES.md#1-glossary-of-core-terms). For a guide to the developer-facing APIs that use this interface, see [**API and Integration Guide**](./API_AND_INTEGRATION.md).

---

## 1. The Sensorimotor Loop

The GAI facilitates a continuous **sensorimotor loop**:
1.  **Perception**: External sensors provide data to GAI handlers, which translate the data into `Sentence` atoms. For example, an image recognition handler might inject `(. (sees (shape square) (color red)) (Truth 1.0 1.0))`.
2.  **Reasoning**: The MeTTa interpreter processes these sentences.
3.  **Action**: The reasoning process may conclude that a goal can be achieved by executing an action. This results in a goal to execute a `GroundedAtom` representing that action, e.g., `(! (#move-forward))`.
4.  **Actuation**: GAI handlers translate the symbolic goal into a concrete action in the external world.
5.  **Feedback**: The consequences of the action are observed by sensors, generating new perception sentences and closing the loop.

---

## 2. Machine Learning and LLM Integration

A key advantage of the `GroundedAtom` model is the deep and flexible integration of external computational models. These can be wrapped as `GroundedAtom`s or exposed as specialized `Spaces` (e.g., "Neural Lobes") that the system can query. This allows the system to seamlessly blend symbolic reasoning with sub-symbolic processing.

-   **LLM as a Knowledge Source**: An atom like `(llm-query "What is the capital of France?")` can be grounded to an LLM API. The interpreter can evaluate this atom, and the LLM's response ("Paris") is inserted into Memory as a new belief.
-   **Embeddings for Similarity**: An atom `(get-embedding "some text")` can be grounded to a text embedding model. The resulting vector can be stored and used for powerful similarity and analogy calculations.
-   **Perception via Vision Models**: An atom like `(recognize-objects (image_data))` can be grounded to a computer vision model, producing sentences that describe the contents of an image.

This mechanism allows the symbolic reasoner to offload complex, pattern-based tasks to specialized ML models while still managing the high-level reasoning process.

---

## 3. Natural Language Processing (NLP) Interface

The NLP interface is a specialized part of the GAI, responsible for bridging the gap between symbolic atoms and human language.
-   **Natural Language Understanding (NLU)**: Parsing human language into MeTTa sentences (e.g., "A bird is an animal" becomes `(. (Inheritance bird animal) (Truth 1.0 0.9))`).
-   **Natural Language Generation (NLG)**: Generating human-readable language from atoms in the Memory.

---

## 4. Grounded Atom Registry

The GAI maintains a central registry of all known grounded atoms. This allows other parts of the system to discover the actions and computations the system is capable of performing, which is crucial for planning and self-discovery.
