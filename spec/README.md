# HyperNARS Seed Specification

This directory contains the complete, formal seed specification for the HyperNARS system, distilled into a set of structured MeTTa (`.metta`) files. This knowledge base provides the foundational axioms, schemas, and definitions required for the system to bootstrap and operate.

## File Structure and Loading Order

The files are numbered to indicate the recommended loading sequence. A system loader should process these files in order to ensure that foundational schemas are defined before they are used.

### 1. `00_core_types.metta`
- **Purpose**: Defines the most fundamental data structures of the system, including `Truth`, `Budget`, `Stamp`, and the four sentence punctuations (`.`, `!`, `?`, `@`). It also includes other basic system-level types.
- **Loads First.**

### 2. `01_schemas.metta`
- **Purpose**: Defines the metacognitive `define-*` schemas (e.g., `define-type`, `define-cognitive-function`). This file is critical as it provides the structure for interpreting the rest of the specification files.
- **Loads Second.**

### 3. `02_architecture.metta`
- **Purpose**: Defines the high-level cognitive architecture (`HyperNARS-Standard-Model`) and the formal steps of the core reasoning cycles (System 1 and System 2).
- **Loads Third.**

### 4. `03_cognitive_functions.metta`
- **Purpose**: Provides the definitions for all Layer 1, 2, and 3 cognitive functions, from core NAL inference rules to executive control and metacognitive stubs.
- **Loads Fourth.**

### 5. `04_kpis.metta`
- **Purpose**: Defines the Key Performance Indicators (KPIs) the system uses for self-monitoring. This is the foundation for the system's self-awareness.
- **Loads Fifth.**

### 6. `05_api.metta`
- **Purpose**: Defines the methods of the system's public-facing API, allowing it to reason about its own interaction points.
- **Loads Sixth.**

### 7. `06_bootstrap.metta`
- **Purpose**: Defines the final `System-Startup` sequence, which orchestrates the entire initialization process.
- **Loads Seventh.**

### 8. `07_system_state.metta`
- **Purpose**: Defines the schema for capturing a complete snapshot of the system's internal state.
- **Loads Last.**
