# QuantaDorsa

**QuantaDorsa** is an end-to-end simulation, visualization, and statistical analysis pipeline designed for neuroscientific modeling of brain regions and synaptic plasticity.

It seamlessly integrates a high-performance C++ simulation core with multi-region Python visualizations and R-powered comparative statistical analyses.

---

## 🚀 Features

- **C++ simulation:** Fast and customizable neural/synaptic dynamic modeling.
- **Multi-region analysis:** The entire pipeline is now built to handle data from multiple brain regions simultaneously.
- **Python visualization:** Dynamic, per-region visualization of simulation data using `matplotlib`.
- **R statistical analysis:** Comparative analysis across regions (Boxplots, ANOVA) and per-region deep dives with `ggplot2` and `GGally`.
- **Modular design:** Easily extensible for new models, plots, and statistical tests.

---

## 📦 Project Structure

```
QuantaDorsa/
├── cpp_simulation/
│   └── synapse_sim.cpp          # C++ simulation source
├── python_visualization/
│   └── plot_synapse.py          # Python plotting script (multi-region)
├── r_analysis/
│   ├── stat_plots.R             # R statistical plots (multi-region)
│   └── r_plots/                 # Generated R plots
├── frames/
│   ├── <region_one_name>/       # Image frames for region one
│   └── <region_two_name>/       # Image frames for region two
├── data/                        # Simulation output CSV (must contain a 'region' column)
├── docs/                        # Project planning and documentation
├── README.md
└── run_pipeline.sh              # Partial orchestration script (no compile or video)
```

---

## 🛠️ Installation & Requirements

### System dependencies

- **C++ compiler** (e.g., `g++`)
- **Python 3.7+** with packages: `pandas`, `matplotlib`
- **R (>= 4.0)** with packages: `ggplot2`, `GGally`
- **FFmpeg** (Optional, for manual video composition)

### Install Python packages

```bash
pip install pandas matplotlib
```

### Install R packages

Start R and run:

```r
install.packages(c("ggplot2", "GGally"))
```

---

## 🎯 Usage Guide

The `run_pipeline.sh` script is provided to run the analysis and visualization steps automatically. For manual execution, follow the steps below.

### Data Format Prerequisite

The C++ simulation must produce a `synapse_data.csv` file in the `data/` directory that includes a `region` column.

Example `synapse_data.csv` header:
`time,synaptic_weight,pre_activity,post_activity,region`

### 1. Run C++ simulation

```bash
cd cpp_simulation
g++ synapse_sim.cpp -o synapse_sim
# Ensure your simulation code writes the 'region' column
./synapse_sim
```

### 2. Generate Python visualization frames

This script reads `data/synapse_data.csv` and generates image frames for each region found in the file.

```bash
cd ../python_visualization
python3 plot_synapse.py
```

Frames will be saved in region-specific subdirectories, e.g., `frames/hippocampus/` and `frames/cortex/`.

### 3. Generate R statistical plots

This script generates a comparative boxplot, an ANOVA test summary, and per-region correlation and scatter plots.

```bash
cd ../r_analysis
Rscript stat_plots.R
```

All plots are saved in the `r_analysis/r_plots/` directory.

### 4. (Optional) Compose video for a single region

To compile the frames for a specific region into a video, use FFmpeg.

```bash
# Example for a region named 'hippocampus'
ffmpeg -framerate 30 -i ../frames/hippocampus/frame_%04d.png \
  -c:v libx264 -pix_fmt yuv420p videos/hippocampus_simulation.mp4
```

---

## 🧩 Extensibility

- **Multi-region modeling:** The pipeline now fully supports multi-region data, generating per-region visualizations and comparative statistical analyses. This fulfills the initial goal outlined in the project documentation.
- Add new C++ models for different brain regions or neurotransmitter dynamics.
- Enhance Python plots with animations, region overlays, or panning effects.
- Extend R scripts for deeper statistical tests and network visualizations.

---

## 🤝 Contributing

Feel free to submit issues or pull requests to extend QuantaDorsa's capabilities.

Whether it's new brain models, better visualizations, or advanced analytics — contributions are welcome!

---

## 📜 License

MIT License

---

## 💡 Acknowledgements

Inspired by integrative neuroscience workflows combining high-performance simulation with modern data visualization and statistics.

---

# Cognitive Modeling Scripts

This repository contains a collection of scripts for cognitive modeling, data analysis, and visualization. The scripts are organized into a standardized, modular pipeline to facilitate reproducibility and maintainability.

## Directory Structure

The scripts are organized into a series of directories based on their function in the data analysis pipeline. Each directory is prefixed with a number to indicate the order of execution.

```
scripts/
├── 01_acquisition/
│   ├── R/
│   ├── python/
│   └── shell/
├── 02_processing/
│   ├── R/
│   └── python/
├── 03_modeling/
│   ├── R/
│   └── python/
├── 04_analysis/
│   ├── R/
│   └── python/
├── 05_visualization/
│   └── R/
├── 06_data_loading/
│   └── R/
├── 07_querying/
│   ├── R/
│   └── shell/
└── 08_pipelines/
    ├── R/
    └── shell/
```

## Naming Convention

All scripts follow a consistent naming convention to clearly indicate their function and the primary data source or entity they operate on. The format is `<stage_prefix>_<data_source>_<action>.<language_extension>`.

*   **`<stage_prefix>`:** A short prefix to indicate the pipeline stage (e.g., `acq` for acquisition, `proc` for processing, `mod` for modeling).
*   **`<data_source>`:** The primary data source (e.g., `pubmed`, `clinicaltrials`, `drugsfda`).
*   **`<action>`:** A verb describing the script's function (e.g., `download`, `clean`, `convert_to_rdf`, `run_model`).

**Example:**
*   `scripts/01_acquisition/R/acq_pubmed_fetch.R`
*   `scripts/02_processing/python/proc_drugsfda_convert_to_rdf.py`

## Standard Script Header

Every script file begins with a standardized header block that provides essential metadata about the script, including its title, author, date, description, inputs, outputs, and dependencies.

## Pipelines

The `scripts/08_pipelines` directory contains the main orchestration scripts for running the various data analysis pipelines. These scripts are designed to be run from the root of the repository and will execute the individual scripts in the correct order.

To run the main R-based pharmaceutical data pipeline, execute the following command:

```bash
Rscript scripts/08_pipelines/R/pipe_pharma_main.R
```

To run the R and Python BRFSS data analysis pipelines, execute:

```bash
bash scripts/08_pipelines/shell/pipe_run_r_python.sh
```
