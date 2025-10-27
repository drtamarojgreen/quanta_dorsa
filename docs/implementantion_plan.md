# Cognitive Modeling Tools Implementation Plan

## 1. Guiding Principles

This document outlines a standardized and organized approach for integrating the cognitive modeling scripts from the `greenhouse_org` repository. The primary goals of this integration are:

*   **Consistency:** All scripts will adhere to a uniform naming convention and internal structure.
*   **Clarity:** The purpose of each script and its place in the overall workflow will be immediately obvious.
*   **Maintainability:** The organized structure will make it easier to update, debug, and extend the scripts in the future.
*   **Modularity:** Scripts will be organized into discrete stages of the data analysis pipeline.

## 2. Directory Structure

All integrated scripts will be located under the `scripts/` directory. The structure is organized by the stage of the data analysis pipeline, with subdirectories for each language (R, Python, shell).

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

## 3. Naming Convention

Files will be named to clearly indicate their function and the primary data source or entity they operate on. The format is `<stage_prefix>_<data_source>_<action>.<language_extension>`.

*   **`<stage_prefix>`:** A short prefix to indicate the pipeline stage (e.g., `acq` for acquisition, `proc` for processing, `mod` for modeling).
*   **`<data_source>`:** The primary data source (e.g., `pubmed`, `clinicaltrials`, `drugsfda`).
*   **`<action>`:** A verb describing the script's function (e.g., `download`, `clean`, `convert_to_rdf`, `run_model`).

**Example:**
*   `06_data_access_pubmed.R` will become `scripts/01_acquisition/R/acq_pubmed_fetch.R`.
*   `convert_drugsfda_to_rdf.py` will become `scripts/02_processing/python/proc_drugsfda_convert_to_rdf.py`.

## 4. Standard Script Header

Every script file will begin with a standardized header block. This header will provide essential metadata about the script.

**R Script Header Example:**
```R
# ---
# title: "Fetch PubMed Data"
# author: "Jules"
# date: "2025-10-27"
# ---
#
# Description:
# This script fetches data from PubMed based on a set of search criteria.
#
# Inputs:
# - `data/search_terms.csv`: A CSV file containing search terms.
#
# Outputs:
# - `data/raw/pubmed_articles.csv`: A CSV file of fetched articles.
#
# Dependencies:
# - `rentrez`
# ---
```

**Python Script Header Example:**
```python
# ---
# title: "Convert Drugs@FDA Data to RDF"
# author: "Jules"
# date: "2025-10-27"
# ---
#
# Description:
# This script converts the Drugs@FDA dataset from its original format to RDF.
#
# Inputs:
# - `data/raw/drugsfda.zip`: The raw data from Drugs@FDA.
#
# Outputs:
# - `data/processed/drugsfda.ttl`: The data in Turtle RDF format.
#
# Dependencies:
# - `pandas`
# - `rdflib`
# ---
```

## 5. Script Migration Plan

The following table maps the original scripts from the `greenhouse_org` repository to their new, standardized locations and names.

| Original Script | New Location & Name |
|---|---|
| `01_data_access.R` | `scripts/01_acquisition/R/acq_generic_access.R` |
| `06_data_access_pubmed.R` | `scripts/01_acquisition/R/acq_pubmed_fetch.R` |
| `07_data_access_reactome.R` | `scripts/01_acquisition/R/acq_reactome_fetch.R` |
| `08_data_access_kegg.R` | `scripts/01_acquisition/R/acq_kegg_fetch.R` |
| `10_data_access_clinicaltrials.R` | `scripts/01_acquisition/R/acq_clinicaltrials_fetch.R` |
| `11_data_access_dailymed.R` | `scripts/01_acquisition/R/acq_dailymed_fetch.R` |
| `12_pharma_data_download.R` | `scripts/01_acquisition/R/acq_pharma_download.R` |
| `download_data.sh` | `scripts/01_acquisition/shell/acq_pharma_download.sh` |
| `02_data_cleaning.R` | `scripts/02_processing/R/proc_generic_clean.R` |
| `03_data_processing.R` | `scripts/02_processing/R/proc_generic_process.R` |
| `13_pharma_convert_drugsfda.R` | `scripts/02_processing/R/proc_drugsfda_convert.R` |
| `14_pharma_convert_dailymed.R` | `scripts/02_processing/R/proc_dailymed_convert.R` |
| `18_spl_to_rdf.R` | `scripts/02_processing/R/proc_spl_convert_to_rdf.R` |
| `convert_drugsfda_to_rdf.py` | `scripts/02_processing/python/proc_drugsfda_convert_to_rdf.py`|
| `extract_spl_to_csv.py` | `scripts/02_processing/python/proc_spl_extract_to_csv.py` |
| `process_and_load.sh` | `scripts/08_pipelines/shell/pipe_process_and_load.sh` |
| `cognitive_modeling_demo.R` | `scripts/03_modeling/R/mod_cognitive_demo.R` |
| `09_mental_health_modeling.R` | `scripts/03_modeling/R/mod_mental_health.R` |
| `04_data_analysis.R` | `scripts/04_analysis/R/anl_generic_analysis.R` |
| `mapping_project.r` | `scripts/04_analysis/R/anl_mapping_project.R` |
| `mapping_project_model.R` | `scripts/04_analysis/R/anl_mapping_project_model.R` |
| `mapping_project_trials.r` | `scripts/04_analysis/R/anl_mapping_project_trials.R` |
| `mapping_project_who.R` | `scripts/04_analysis/R/anl_mapping_project_who.R` |
| `15_pharma_load_fuseki.R` | `scripts/06_data_loading/R/load_pharma_fuseki.R` |
| `16_pharma_run_queries.R` | `scripts/07_querying/R/query_pharma_fuseki.R` |
| `run_queries.sh` | `scripts/07_querying/shell/query_pharma_fuseki.sh` |
| `17_pharma_main_pipeline.R` | `scripts/08_pipelines/R/pipe_pharma_main.R` |
| `run_r.sh` | `scripts/08_pipelines/shell/pipe_run_r.sh` |
| `run_r_python.sh` | `scripts/08_pipelines/shell/pipe_run_r_python.sh` |
