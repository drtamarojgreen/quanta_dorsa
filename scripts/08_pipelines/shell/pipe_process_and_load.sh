#!/usr/bin/env bash

# ---
# title: "Process and Load Pharmaceutical Data Pipeline"
# author: "Jules"
# date: "2025-10-27"
# ---
#
# Description:
# This script orchestrates the entire pharmaceutical data pipeline:
# 1. Downloads all required data from FDA and DailyMed.
# 2. Converts the tabular Drugs@FDA data to RDF.
# 3. Converts all DailyMed SPL XML files to RDF.
# 4. Loads all generated RDF into a Fuseki triple store.
#
# Inputs:
# - None. It calls other scripts which have their own inputs defined.
#
# Outputs:
# - Populates a Fuseki triple store with the processed RDF data.
#
# Dependencies:
# - `bash`
# - `curl`
# - The R and Python scripts it calls, and their respective dependencies.
# ---

# This script orchestrates the entire data pipeline:
# 1. Downloads all required data from FDA and DailyMed.
# 2. Converts the tabular Drugs@FDA data to RDF.
# 3. Converts all DailyMed SPL XML files to RDF.
# 4. Loads all generated RDF into a Fuseki triple store.

set -e # Exit immediately if a command exits with a non-zero status.

# --- CONFIGURATION ---
RAW_DATA_DIR="./raw_data"
RDF_OUT_DIR="./rdf_data"
FUSEKI_URL="http://localhost:3030/spl/data"

# --- STAGE 1: Download Data ---
echo "--- STAGE 1: DOWNLOADING DATA ---"
Rscript -e "source('scripts/01_acquisition/R/acq_pharma_download.R'); run_pharma_data_download(config)"
echo "--- DOWNLOAD COMPLETE ---"

# --- STAGE 2: Convert Drugs@FDA (Tabular) to RDF ---
echo "--- STAGE 2: CONVERTING DRUGS@FDA TO RDF ---"
python3 scripts/02_processing/python/proc_drugsfda_convert_to_rdf.py
echo "--- DRUGS@FDA CONVERSION COMPLETE ---"

# --- STAGE 3: Convert DailyMed (XML) to RDF ---
echo "--- STAGE 3: CONVERTING DAILYMED XML TO RDF ---"
Rscript -e "source('scripts/02_processing/R/proc_dailymed_convert.R'); run_dailymed_to_rdf_conversion(config)"
echo "--- DAILYMED XML CONVERSION COMPLETE ---"

# --- STAGE 4: Load ALL RDF data into Fuseki ---
echo "--- STAGE 4: LOADING ALL RDF DATA INTO FUSEKI ---"
# Check if Fuseki is available
if ! curl -s --head "$FUSEKI_URL" | head -n 1 | grep "200 OK" > /dev/null; then
    echo "Error: Fuseki server is not responding at $FUSEKI_URL"
    echo "Please ensure your Fuseki server is running and the 'spl' dataset is created."
    exit 1
fi

# Load the single Drugs@FDA RDF file
echo "Loading Drugs@FDA RDF..."
curl -s -X POST \
     -H "Content-Type: application/rdf+xml" \
     --data-binary @"${RDF_OUT_DIR}/drugsfda.rdf" \
     "$FUSEKI_URL"

# Load all the SPL RDF files
echo "Loading DailyMed SPL RDF files..."
find "${RDF_OUT_DIR}/spl" -type f -name "*.rdf" | while read -r rdf_file; do
  echo "  - Loading $(basename "$rdf_file")"
  curl -s -X POST \
       -H "Content-Type: application/rdf+xml" \
       --data-binary @"$rdf_file" \
       "$FUSEKI_URL"
done
echo "--- DATA LOADING COMPLETE ---"

echo "PIPELINE EXECUTION FINISHED SUCCESSFULLY."
