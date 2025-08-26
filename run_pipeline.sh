#!/bin/bash
#
# Partial Pipeline Orchestration Script for QuantaDorsa
# NOTE: Intentionally omits C++ compilation, simulation, and ffmpeg.
#
echo "🚀 Starting QuantaDorsa Analysis Pipeline..."

echo "📊 [Step 1/2] Running Python visualization script..."
(cd python_visualization && python3 plot_synapse.py)

echo "📈 [Step 2/2] Running R analysis script..."
(cd r_analysis && Rscript stat_plots.R)

echo "🎉 Analysis and visualization pipeline complete."