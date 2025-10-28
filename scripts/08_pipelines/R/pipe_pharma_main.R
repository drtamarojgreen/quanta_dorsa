# ---
# title: "Main R-Based Pharmaceutical Data Pipeline"
# author: "Jules"
# date: "2025-10-27"
# ---
#
# Description:
# This is the main orchestrator for the refactored R-based pharmaceutical pipeline.
# It sources and executes each step of the pipeline in the correct order, from
# data download to final analysis. This script serves as the single entry point
# for running the entire R workflow.
#
# Inputs:
# - None. The script calls other scripts which have their own inputs.
#
# Outputs:
# - Executes the entire data pipeline, resulting in raw data, processed RDF,
#   a populated Fuseki triple store, and CSV files with query results.
#
# Dependencies:
# - All required R packages for the sourced scripts (e.g., `future`, `rdflib`, etc.).
# ---

# 17_pharma_main_pipeline.R
#
# Objective:
# This is the main orchestrator for the refactored R-based pharmaceutical pipeline.
# It replaces `process_and_load.sh` by sourcing and executing each step of the
# pipeline in the correct order. It provides a single entry point to run the
# entire workflow from data download to final analysis.

# --- 1. Preamble: Check and Install Dependencies ---
# This section checks for all required packages and prompts the user to install
# them if they are missing. This is a user-friendly alternative to auto-installing.

message("--- Checking for required packages ---")
required_packages <- c(
  "future", "furrr",       # For parallel downloads
  "data.table",            # For data manipulation
  "rdflib",                # For RDF creation
  "xml2",                  # For XML parsing
  "httr",                  # For uploading to Fuseki
  "SPARQL"                 # For running queries
)

missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(missing_packages) > 0) {
  message("The following required packages are missing:")
  message(paste(missing_packages, collapse = ", "))
  stop("Please install the missing packages before running the pipeline. e.g., install.packages(c("..."))")
} else {
  message("All required packages are installed.")
}


# --- 2. Source All Pipeline Scripts ---
# This makes the functions from each script available in the current session.

message("--- Sourcing pipeline scripts ---")
tryCatch({
  source("scripts/01_acquisition/R/acq_pharma_download.R")
  source("scripts/02_processing/R/proc_drugsfda_convert.R")
  source("scripts/02_processing/R/proc_dailymed_convert.R")
  source("scripts/06_data_loading/R/load_pharma_fuseki.R")
  source("scripts/07_querying/R/query_pharma_fuseki.R")
}, error = function(e) {
  stop("One or more pipeline scripts could not be found. Please check the standardized directory structure. Error: ", e$message)
})


# --- 3. Define Shared Configuration ---
# A single configuration list is passed to each function.

message("--- Defining pipeline configuration ---")
pipeline_config <- list(
  # Directories
  DATA_DIR = "./raw_data",
  DAILYMED_XML_DIR = "./raw_data/dailymed_xml",
  DRUGSFDA_RAW_DIR = "./raw_data/drugsfda_raw",
  RDF_DIR = "./rdf_data",
  SPL_RDF_DIR = "./rdf_data/spl",
  RESULTS_DIR = "./results",
  QUERY_DIR = "./scripts/R/queries",

  # Files
  DRUGSFDA_RDF_FILE = "./rdf_data/drugsfda.rdf",

  # URLs
  BASE_DAILYMED_URL = "https://dailymed-data.nlm.nih.gov/public-release-files",
  DRUGSFDA_URL = "https://www.fda.gov/media/89850/download?attachment",
  FUSEKI_URL = "http://localhost:3030/spl/data", # Upload endpoint
  FUSEKI_ENDPOINT = "http://localhost:3030/spl/query", # Query endpoint

  # Settings
  CHUNK_SIZE = 500 # Number of SPL files to load at once
)


# --- 4. Main Execution Block ---

main <- function() {
  message("\n--- STARTING PHARMACEUTICAL DATA PIPELINE ---")

  # Step 1: Download all data
  message("\n>>> STEP 1 of 5: Downloading Data...")
  run_pharma_data_download(pipeline_config)

  # Step 2: Convert Drugs@FDA data to RDF
  message("\n>>> STEP 2 of 5: Converting Drugs@FDA to RDF...")
  run_drugsfda_to_rdf_conversion(pipeline_config)

  # Step 3: Convert DailyMed XML files to RDF
  message("\n>>> STEP 3 of 5: Converting DailyMed XML to RDF...")
  run_dailymed_to_rdf_conversion(pipeline_config)

  # Step 4: Load all RDF data into Fuseki
  message("\n>>> STEP 4 of 5: Loading all RDF data into Fuseki...")
  message("NOTE: This step requires a running Fuseki server with a dataset named 'spl'.")
  run_fuseki_load(pipeline_config)

  # Step 5: Run analytical SPARQL queries
  message("\n>>> STEP 5 of 5: Running SPARQL queries...")
  run_sparql_queries(pipeline_config)

  message("\n--- PIPELINE COMPLETED SUCCESSFULLY ---")
}

# --- Run the pipeline ---
# The `if (interactive())` check is removed to allow direct execution via Rscript.
main()
