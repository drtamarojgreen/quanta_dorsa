# Phase II: Automation, Testing, and Documentation

This document outlines the second phase of implementation for the multi-region brain modeling pipeline. The focus of this phase is to automate the pipeline, add tests, and update the documentation.

### 1. Automate the Pipeline

-   **Create a master script (`run_pipeline.sh`):** Develop a shell script that orchestrates the entire pipeline:
    1.  Compiles the C++ code.
    2.  Runs the simulation for each configured brain region.
    3.  Generates visualizations for each region.
    4.  Performs statistical analysis.
    5.  Composes the final videos with FFmpeg.
-   **Parameterize the script:** Allow the user to specify which regions to model via command-line arguments.

### 2. Documentation and Testing

-   **Update `README.md`:** Revise the main `README.md` to reflect the new multi-region capabilities.
-   **Add unit tests:** Create tests for the C++ models and Python scripts to ensure correctness.
