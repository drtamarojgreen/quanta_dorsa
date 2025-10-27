# Cognitive Modeling Tools Implementation Plan

## Overview

This document outlines the plan to implement the cognitive modeling tools from the `greenhouse_org` repository within the `scripts/` directory of this repository. The implementation will be phased to ensure a modular and manageable approach.

## Phase 1: Data Acquisition and Preprocessing

This phase focuses on adapting the R scripts for data acquisition, cleaning, and preprocessing. The following scripts from the `greenhouse_org` repository will be adapted and integrated:

*   `01_data_access.R`: For general data access.
*   `02_data_cleaning.R`: For cleaning the accessed data.
*   `03_data_processing.R`: For processing the cleaned data.
*   `06_data_access_pubmed.R`: For accessing data from PubMed.
*   `07_data_access_reactome.R`: For accessing data from Reactome.
*   `08_data_access_kegg.R`: For accessing data from KEGG.
*   `10_data_access_clinicaltrials.R`: For accessing data from ClinicalTrials.gov.
*   `11_data_access_dailymed.R`: For accessing data from DailyMed.

These scripts will be placed in a `scripts/data_management` directory.

## Phase 2: Cognitive Modeling Implementation

This phase will focus on adapting the core cognitive modeling script.

*   `cognitive_modeling_demo.R`: This script will be the core of the cognitive modeling implementation. It will be adapted to work with the data processed in Phase 1.

This script will be placed in the `scripts/modeling` directory.

## Phase 3: Pharmaceutical Domain-Specific Implementation

This phase will adapt the scripts for the pharmaceutical domain.

*   `12_pharma_data_download.R`: For downloading pharmaceutical data.
*   `13_pharma_convert_drugsfda.R`: For converting Drugs@FDA data.
*   `14_pharma_convert_dailymed.R`: For converting DailyMed data.
*   `15_pharma_load_fuseki.R`: For loading data into Fuseki.
*   `16_pharma_run_queries.R`: For running queries on the data.
*   `17_pharma_main_pipeline.R`: The main pipeline for the pharmaceutical domain.
*   `18_spl_to_rdf.R`: For converting SPL to RDF.
*   `convert_drugsfda_to_rdf.py`: Python script for converting Drugs@FDA to RDF.
*   `download_data.sh`: Shell script for downloading data.
*   `extract_spl_to_csv.py`: Python script for extracting SPL to CSV.
*   `process_and_load.sh`: Shell script for processing and loading data.
*   `run_queries.sh`: Shell script for running queries.

These scripts will be placed in a `scripts/pharmaceutical` directory.

## Integration and Workflow

The adapted scripts will be integrated into a cohesive workflow. The `run_r.sh` and `run_r_python.sh` scripts will be adapted to execute the various phases of the implementation.
