# QuantaDorsa

**QuantaDorsa** is an end-to-end simulation, visualization, and statistical analysis pipeline designed for neuroscientific modeling of brain regions and synaptic plasticity.

It seamlessly integrates a high-performance C++ simulation core, Python-based dynamic plotting, R-powered statistical analysis, and video composition via FFmpeg.

---

## 🚀 Features

- **C++ simulation:** Fast and customizable neural/synaptic dynamic modeling
- **Python visualization:** Time-series and differential equation plotting with `matplotlib`
- **R statistical analysis:** Advanced data exploration including correlations and PCA via `ggplot2`
- **Video creation:** Compile image frames into high-quality videos with `ffmpeg`
- Modular design to incorporate new brain regions, modeling approaches, and analysis techniques

---

## 📦 Project Structure

```
QuantaDorsa/
├── cpp_simulation/
│   └── synapse_sim.cpp          # C++ simulation source
├── python_visualization/
│   └── plot_synapse.py          # Python plotting script
├── r_analysis/
│   └── stat_plots.R             # R statistical plots
├── frames/                      # Generated image frames
├── videos/                      # Final composed videos
├── data/                        # Simulation output CSVs
├── README.md
└── run_pipeline.sh              # Optional orchestration shell script
```

---

## 🛠️ Installation & Requirements

### System dependencies

- **C++ compiler** (e.g., `g++`)
- **Python 3.7+** with packages: `pandas`, `matplotlib`
- **R (>= 4.0)** with package: `ggplot2`
- **FFmpeg** for video composition

### Install Python packages

```bash
pip install pandas matplotlib
```

### Install R package ggplot2

Start R and run:

```r
install.packages("ggplot2")
```

---

## 🎯 Usage Guide

### 1. Run C++ simulation

```bash
cd cpp_simulation
g++ synapse_sim.cpp -o synapse_sim
./synapse_sim
```

This generates `data/synapse_data.csv`.

### 2. Generate Python visualization frames

```bash
cd ../python_visualization
python3 plot_synapse.py
```

Frames saved in `python_visualization/python_frames/`.

### 3. Generate R statistical plots

```bash
cd ../r_analysis
Rscript stat_plots.R
```

Plots saved as PNG images (e.g., `correlation_plot.png`).

### 4. Compose video with FFmpeg

```bash
ffmpeg -framerate 30 -i ../python_visualization/python_frames/frame_%04d.png \
  -c:v libx264 -pix_fmt yuv420p videos/synapse_weight.mp4
```

You can optionally combine R plots as overlays or intro/outro sequences.

---

## 🧩 Extensibility

- Add new C++ models for different brain regions or neurotransmitter dynamics
- Enhance Python plots with animations, region overlays, or panning effects
- Extend R scripts for deeper statistical tests and network visualizations
- Integrate AI-based interpolation with VapourSynth or RIFE to smooth videos

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