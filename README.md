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