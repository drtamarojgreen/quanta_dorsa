#!/bin/bash

# ---
# title: "Run R Data Analysis Pipeline"
# author: "Jules"
# date: "2025-10-27"
# ---
#
# Description:
# This script executes the full R data analysis pipeline for the BRFSS data.
# It checks for R and required packages, and then runs the main analysis and
# visualization script.
#
# Inputs:
# - None. The R script it calls handles data loading.
#
# Outputs:
# - A PNG plot file: `depression_prevalence_by_age.png`.
#
# Dependencies:
# - `Rscript`
# - R packages: `data.table`, `ggplot2`, `scales`, `haven`
# ---

# This script executes the full R data analysis pipeline.
# It is designed to be run from the root of the repository.

# --- Preamble ---
# The 'set -e' command ensures that the script will exit immediately if any
# command fails. This is a safety measure to prevent unexpected behavior.
set -e

# --- R Pipeline Execution ---
echo "--- Starting R Pipeline Execution ---"

# Check if R is installed before attempting to run the scripts.
if ! command -v Rscript &> /dev/null
then
    echo "Rscript could not be found. Please install R to run this pipeline."
    # We exit with a non-zero status to indicate failure.
    exit 1
fi

# We need to install the required R packages if they are not already installed.
# We will create a small R script to handle this dependency check.
echo "Checking for and installing required R packages (data.table, ggplot2, scales, haven)..."
Rscript -e '
  packages <- c("data.table", "ggplot2", "scales", "haven");
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])];
  if(length(new_packages)) install.packages(new_packages, repos="http://cran.us.r-project.org");
'

# The R scripts are designed to be sourced in sequence. We will run the final
# script, which will trigger the entire pipeline.
echo "Running the R data analysis and visualization pipeline..."
Rscript scripts/05_visualization/R/vis_depression_prevalence.R

echo "--- R Pipeline Complete ---"
echo "Generated plot: depression_prevalence_by_age.png"
echo ""

echo "Pipeline completed successfully."
