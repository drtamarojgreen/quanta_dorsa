#!/bin/bash

# QuantaDorsa - End-to-End Test Pipeline
# Tailored for Fedora/Linux systems.
# This script automates the full workflow:
# 1. Compiles and runs the C++ simulation.
# 2. Generates visualization frames with Python.
# 3. Creates statistical plots with R.
# 4. Compiles the frames into an MP4 video using FFmpeg.

# --- Configuration ---
set -e # Exit immediately if a command exits with a non-zero status.

CPP_SRC_DIR="cpp_simulation"
CPP_SRC_FILE="synapse_sim.cpp"
CPP_EXEC="synapse_sim"

PYTHON_DIR="python_visualization"
PYTHON_SCRIPT="plot_synapse.py"

R_DIR="r_analysis"
R_SCRIPT="stat_plots.R"

DATA_DIR="data"
FRAMES_DIR="frames"
VIDEO_DIR="videos"
OUTPUT_VIDEO_NAME="synapse_simulation.mp4"

# --- Dependency Check (Informational) ---
echo "--- QuantaDorsa Pipeline Started ---"
echo "Checking for required dependencies..."
command -v g++ >/dev/null 2>&1 || { echo >&2 "g++ not found. On Fedora, run: sudo dnf install gcc-c++"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo >&2 "python3 not found. On Fedora, run: sudo dnf install python3 python3-pip"; exit 1; }
command -v Rscript >/dev/null 2>&1 || { echo >&2 "Rscript not found. On Fedora, run: sudo dnf install R"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo >&2 "ffmpeg not found. On Fedora, first enable RPM Fusion, then run: sudo dnf install ffmpeg"; exit 1; }
echo "Dependencies found."
echo

# --- Step 0: Setup Directories ---
echo "--- [0/4] Setting up directories ---"
mkdir -p ${DATA_DIR}
mkdir -p ${VIDEO_DIR}
mkdir -p ${FRAMES_DIR}
echo "Directories ensured."
echo

# --- Step 1: C++ Simulation ---
echo "--- [1/4] Running C++ Simulation ---"

# Simulation parameters (can be easily changed here)
SIM_LEARNING_RATE="0.5"
SIM_DECAY_RATE="0.1"
SIM_DURATION="10.0"

cd ${CPP_SRC_DIR}
echo "Compiling ${CPP_SRC_FILE}..."
g++ -std=c++17 -O2 -o ${CPP_EXEC} ${CPP_SRC_FILE}
echo "Running simulation with LR=${SIM_LEARNING_RATE}, Decay=${SIM_DECAY_RATE}, Duration=${SIM_DURATION}s..."
./${CPP_EXEC} ${SIM_LEARNING_RATE} ${SIM_DECAY_RATE} ${SIM_DURATION}
cd ..
echo "C++ simulation complete."
echo

# --- Step 2: Python Visualization ---
echo "--- [2/4] Generating Python Visualization Frames ---"
cd ${PYTHON_DIR}
python3 ${PYTHON_SCRIPT}
cd ..
echo "Python frame generation complete."
echo

# --- Step 3: R Statistical Analysis ---
echo "--- [3/4] Generating R Statistical Plots ---"
cd ${R_DIR}
Rscript ${R_SCRIPT}
cd ..
echo "R analysis complete."
echo

# --- Step 4: Video Composition ---
echo "--- [4/4] Composing Video with FFmpeg ---"
FRAMES_PATH="${FRAMES_DIR}/frame_%04d.png"
VIDEO_PATH="${VIDEO_DIR}/${OUTPUT_VIDEO_NAME}"

ffmpeg -y -framerate 30 -i ${FRAMES_PATH} \
  -c:v libx264 -pix_fmt yuv420p -profile:v high -level 4.0 \
  ${VIDEO_PATH}

echo "Video composition complete."
echo "Output video saved to: ${VIDEO_PATH}"
echo
echo "--- QuantaDorsa Pipeline Finished Successfully! ---"