# Load necessary libraries, installing them if they are not present.
if (!require("ggplot2")) {
  install.packages("ggplot2", repos = "http://cran.us.r-project.org")
}
if (!require("GGally")) {
  install.packages("GGally", repos = "http://cran.us.r-project.org")
}
library(ggplot2)
library(GGally)

# Configuration
data_file <- "../data/synapse_data.csv"
output_corr_plot <- "correlation_matrix_plot.png"
output_scatter_plot <- "activity_vs_weight_plot.png"

# Check if data file exists
if (!file.exists(data_file)) {
  stop(paste("Error: Data file not found at", data_file, ". Please run the C++ simulation first."))
}

# Read the data
cat("Reading simulation data...\n")
sim_data <- read.csv(data_file)

# Create an interaction term for pre*post activity to better visualize Hebbian learning
sim_data$activity_product <- sim_data$pre_activity * sim_data$post_activity

# --- Plot 1: Correlation Matrix ---
cat("Generating correlation matrix plot...\n")

correlation_plot <- ggpairs(
  sim_data[, c("synaptic_weight", "pre_activity", "post_activity", "activity_product")],
  title = "Correlation Matrix of Simulation Variables"
)

ggsave(output_corr_plot, plot = correlation_plot, width = 10, height = 10, dpi = 150)
cat(paste("Saved correlation matrix to", output_corr_plot, "\n"))

# --- Plot 2: Scatter plot of Activity vs. Weight ---
cat("Generating activity vs. weight scatter plot...\n")

scatter_plot <- ggplot