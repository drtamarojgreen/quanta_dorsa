# Phase I: Foundational Refactoring and Core Pipeline

This document outlines the first phase of implementation for the multi-region brain modeling pipeline. The focus of this phase is to refactor the existing codebase to support multiple brain regions.

### 1. Generalize the C++ Simulation Core

-   **Refactor `synapse_sim.cpp`:** Abstract the current simulation logic into a reusable function or class.
-   **Create a configuration system:** Implement a mechanism (e.g., JSON or YAML config files) to specify parameters for different brain regions (e.g., hippocampus, cerebellum, prefrontal cortex). Each configuration will define neuron properties, synapse dynamics, and stimuli.
-   **Develop new models:** Add new C++ modules for at least two additional brain regions, each with its own dynamics.
-   **Output data:** Ensure the simulation output includes a region identifier in the CSV file (e.g., `region`, `time`, `synaptic_weight`).

### 2. Enhance Python Visualization Scripts

-   **Adapt `plot_synapse.py`:** Modify the script to read the region-specific data.
-   **Generate plots per region:** The script should generate separate plots or a comparative plot for each brain region simulated.
-   **Dynamic titling:** Plot titles and filenames should reflect the brain region being visualized.
-   **Consolidate frames:** All generated frames should be stored in a structured way, perhaps in subdirectories named after the region.

### 3. Extend R Statistical Analysis

-   **Update `stat_plots.R`:** Modify the R script to handle the new data format with the region identifier.
-   **Comparative statistics:** Perform statistical analysis (e.g., ANOVA, t-tests) to compare synaptic dynamics across different regions.
-   **Generate region-specific and comparative plots:** Create plots like boxplots or violin plots to compare distributions of synaptic weights across regions.
