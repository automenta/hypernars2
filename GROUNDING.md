# Symbol Grounding

The **Grounded Atom Interface (GAI)** is the component responsible for connecting the system's internal symbolic logic to the external world. This includes sensors, actuators, and external computational resources like Machine Learning (ML) and Large Language Model (LLM) models.

The integrated architecture provides a powerful framework for neural-symbolic integration. The system's central Memory can interface with other specialized knowledge stores, called **Spaces**. While the main knowledge base resides in the primary Memory (a Metagraph Space), the system can connect to other specialized Spaces, such as **Neural Spaces** that host ML models or vector embeddings.

## The Sensorimotor Loop

The GAI facilitates a continuous **sensorimotor loop**:
1.  **Perception**: External sensors provide data to GAI handlers, which translate the data into atoms. For example, an image recognition handler might inject the atom `(sees (shape square) (color red))`.
2.  **Reasoning**: The MeTTa interpreter processes these atoms under the guidance of the AIKR-driven control loop.
3.  **Action**: The reasoning process may conclude that a goal can be achieved by executing an action. This results in the evaluation of a **Grounded Atom** representing that action (e.g., `(#move-forward)`).
4.  **Actuation**: GAI handlers translate the symbolic grounded atom into a concrete action in the external world.
5.  **Feedback**: The consequences of the action are observed by sensors, generating new perception atoms and closing the loop.

## Machine Learning and LLM Integration

A key advantage of the Grounded Atom model is the deep and flexible integration of external computational models, which can be wrapped as `GroundedAtoms` or exposed as specialized Neural Spaces (often called "Neural Lobes"). This allows the system to seamlessly blend symbolic reasoning with sub-symbolic processing. MeTTa scripts can query these external Spaces to perform complex tasks.

-   **LLM as a Knowledge Source**: An atom like `(llm-query "What is the capital of France?")` can be grounded to an LLM API. The interpreter can evaluate this atom, and the LLM's response ("Paris") is inserted into the Memory as a new atom, e.g., `(capital-of France Paris)`.
-   **Embeddings for Similarity**: An atom `(get-embedding "some text")` can be grounded to a text embedding model. The resulting vector can be stored in the Memory and used for powerful similarity and analogy calculations, e.g., `(= (similarity (get-embedding $a) (get-embedding $b)) (cosine-similarity ...))`
-   **Perception via Vision Models**: An atom like `(recognize-objects <image_data>)` can be grounded to a computer vision model, producing atoms that describe the contents of an image.

This mechanism allows the symbolic reasoner to offload complex, pattern-based tasks to specialized ML models while still managing the high-level reasoning process.

## Natural Language Processing (NLP) Interface

The NLP interface is a specialized part of the GAI, responsible for bridging the gap between symbolic atoms and human language.
-   **Natural Language Understanding (NLU)**: Parsing human language into MeTTa atoms (e.g., "A bird is an animal" becomes `(Inheritance bird animal)`).
-   **Natural Language Generation (NLG)**: Generating human-readable language from atoms in the Memory.

## Grounded Atom Registry

The GAI maintains a central registry of all known grounded atoms. This allows other parts of the system to discover the actions and computations the system is capable of performing, which is crucial for planning and learning.
