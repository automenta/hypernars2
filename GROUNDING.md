# Symbol Grounding

This document describes the **Grounded Atom Interface (GAI)**, the core mechanism responsible for connecting the system's internal symbolic logic to the external world. It details *how* the system interacts with sensors, actuators, and external models. For a guide to the developer-facing APIs that use this interface, see [**API and Integration Guide**](./API_AND_INTEGRATION.md).

The integrated architecture provides a powerful framework for neural-symbolic integration. The system's central Memory can interface with other specialized knowledge stores, called **Spaces**. While the main knowledge base resides in the primary Memory (a Metagraph Space), the system can connect to other specialized Spaces, such as **Neural Spaces** that host ML models or vector embeddings.

## The Sensorimotor Loop

The GAI facilitates a continuous **sensorimotor loop**:
1.  **Perception**: External sensors provide data to GAI handlers, which translate the data into sentences. For example, an image recognition handler might inject the sentence `(. (sees (shape square) (color red)) (Truth 1.0 1.0) (Budget ...))`.
2.  **Reasoning**: The MeTTa interpreter processes these sentences under the guidance of the AIKR-driven control loop.
3.  **Action**: The reasoning process may conclude that a goal can be achieved by executing an action. This results in a goal to execute a **Grounded Atom** representing that action, e.g., `(! (#move-forward))`.
4.  **Actuation**: GAI handlers translate the symbolic goal into a concrete action in the external world.
5.  **Feedback**: The consequences of the action are observed by sensors, generating new perception sentences and closing the loop.

## Machine Learning and LLM Integration

A key advantage of the Grounded Atom model is the deep and flexible integration of external computational models, which can be wrapped as `GroundedAtoms` or exposed as specialized Neural Spaces (often called "Neural Lobes"). This allows the system to seamlessly blend symbolic reasoning with sub-symbolic processing. MeTTa scripts can query these external Spaces to perform complex tasks.

-   **LLM as a Knowledge Source**: An atom like `(llm-query "What is the capital of France?")` can be grounded to an LLM API. The interpreter can evaluate this atom, and the LLM's response ("Paris") is inserted into the Memory as a new belief sentence, e.g., `(. (capital-of France Paris) (Truth 0.9 0.8) (Budget ...))`.
-   **Embeddings for Similarity**: An atom `(get-embedding "some text")` can be grounded to a text embedding model. The resulting vector can be stored in the Memory and used for powerful similarity and analogy calculations, e.g., `(= (similarity (get-embedding $a) (get-embedding $b)) (cosine-similarity ...))`
-   **Perception via Vision Models**: An atom like `(recognize-objects (image_data))` can be grounded to a computer vision model, producing sentences that describe the contents of an image.

This mechanism allows the symbolic reasoner to offload complex, pattern-based tasks to specialized ML models while still managing the high-level reasoning process.

### Grounded Atoms vs. Spaces

To clarify the relationship between the two main grounding mechanisms:
-   A **`GroundedAtom`** is best understood as a single, executable foreign function. It takes atoms as arguments and returns an atom as a result, potentially with side effects. Examples include `(#move-forward)`, `(llm-query "...")`, or a math function like `(+ 1 2)`.
-   A **`Space`** is a larger, more complex external knowledge source that has its own internal structure and query language. Examples include a vector embedding database, a SQL database, or another AI model's knowledge graph.

The two concepts are complementary. Interaction with a `Space` is typically mediated *through* a set of `GroundedAtoms`. For example, to interact with a vector database `Space`, a developer might define grounded atoms like `(query-vector-db $vec)` and `(add-to-vector-db $vec)`. This provides a clean, atom-based interface to the complex external resource.

## Natural Language Processing (NLP) Interface

The NLP interface is a specialized part of the GAI, responsible for bridging the gap between symbolic atoms and human language.
-   **Natural Language Understanding (NLU)**: Parsing human language into MeTTa sentences (e.g., "A bird is an animal" becomes `(. (Inheritance bird animal) (Truth 1.0 0.9) (Budget ...))`).
-   **Natural Language Generation (NLG)**: Generating human-readable language from atoms in the Memory.

## Grounded Atom Registry

The GAI maintains a central registry of all known grounded atoms. This allows other parts of the system to discover the actions and computations the system is capable of performing, which is crucial for planning and learning.
