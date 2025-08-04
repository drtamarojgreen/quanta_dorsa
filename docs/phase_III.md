# QuantaDorsa - Phase III Implementation Roadmap

This document outlines the major features and enhancements planned for future development phases of the QuantaDorsa project. These items aim to significantly expand the platform's capabilities in simulation, analysis, and visualization.

## 1. Advanced Simulation Core (C++)

- **Multi-Neuron Network Models:**
  - Implement a graph-based network structure to simulate small circuits of interconnected neurons.
  - Introduce different connectivity patterns (e.g., random, scale-free, small-world).

- **Advanced Neuron Models:**
  - Integrate more biologically realistic neuron models beyond simple firing rates, such as Leaky Integrate-and-Fire (LIF) or Izhikevich models.

- **Parameter Sweep & Batch Processing:**
  - Add functionality to run the simulation multiple times with varying parameters (e.g., a range of learning rates) to study the model's parameter space.
  - Output data in a format that facilitates comparison across runs.

- **CMake Build System:**
  - Replace the simple `g++` command with a `CMakeLists.txt` file to manage dependencies, build configurations (Debug/Release), and improve cross-platform compatibility.

## 2. Enhanced Visualization (Python)

- **Interactive Plots:**
  - Transition from static `matplotlib` plots to interactive visualizations using libraries like `Plotly` or `Bokeh`, allowing users to zoom, pan, and inspect data points.

- **Multi-dimensional Data Visualization:**
  - Develop plots for network activity, such as raster plots for spike times or animated graph visualizations showing network connectivity and activity flow.

- **Phase Space Plots:**
  - For more complex neuron models, generate phase space diagrams to visualize the system's dynamics (e.g., plotting membrane potential vs. a recovery variable).

## 3. Deeper Statistical Analysis (R)

- **Principal Component Analysis (PCA):**
  - Implement PCA to identify the primary drivers of variance in multi-neuron simulation data.

- **Time Series Analysis:**
  - Incorporate advanced time-series analysis techniques, such as autocorrelation, cross-correlation, and spectral analysis (e.g., using Fast Fourier Transform) to analyze firing patterns and network oscillations.

- **Comparative Statistics:**
  - Add scripts to perform statistical tests (e.g., t-tests, ANOVA) to compare results from different simulation batches (parameter sweeps).

## 4. Post-Processing & AI Integration

- **Dynamic Video Overlays:**
  - Enhance the `ffmpeg` pipeline to dynamically overlay statistical plots (e.g., the R-generated correlation plot) or key simulation parameters directly onto the video.

- **AI-Powered Video Smoothing (Frame Interpolation):**
  - Integrate tools like RIFE (Real-Time Intermediate Flow Estimation) or DAIN (Depth-Aware Video Frame Interpolation) to increase the frame rate and create ultra-smooth slow-motion videos from the simulation output. This can be managed via a Python wrapper or a VapourSynth script.