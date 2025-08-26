# Load necessary libraries
library(ggplot2)
library(GGally)

# --- Configuration ---
data_file <- "../data/synapse_data.csv"
output_dir <- "r_plots"
dir.create(output_dir, showWarnings = FALSE) # Create output directory

# --- Data Loading and Validation ---
if (!file.exists(data_file)) {
  stop(paste("Error: Data file not found at", data_file, ". Please run the C++ simulation first."))
}

cat("Reading simulation data...\n")
sim_data <- read.csv(data_file)

if (!"region" %in% names(sim_data)) {
  stop("Error: 'region' column not found in data. The data is not compatible with multi-region analysis.")
}

# Convert region to a factor for proper analysis
sim_data$region <- as.factor(sim_data$region)
regions <- unique(sim_data$region)
cat(paste("Found regions:", paste(regions, collapse=", "), "\n\n"))


# --- Cross-Region Analysis ---
cat("--- [1/2] Performing Cross-Region Analysis ---\n")

# 1. Comparative Boxplot
cat("Generating comparative boxplot for synaptic weights...\n")
comp_boxplot <- ggplot(sim_data, aes(x = region, y = synaptic_weight, fill = region)) +
  geom_boxplot() +
  labs(title = "Synaptic Weight Distribution Across Regions",
       x = "Brain Region",
       y = "Synaptic Weight") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

output_boxplot_path <- file.path(output_dir, "comparative_boxplot.png")
ggsave(output_boxplot_path, plot = comp_boxplot, width = 8, height = 6, dpi = 150)
cat(paste("Saved comparative boxplot to", output_boxplot_path, "\n"))

# 2. ANOVA Test
cat("\nPerforming ANOVA test on synaptic weights between regions...\n")
anova_result <- aov(synaptic_weight ~ region, data = sim_data)
print(summary(anova_result))
cat("-------------------------------------------------------\n\n")


# --- Per-Region Analysis ---
cat("--- [2/2] Performing Per-Region Analysis ---\n")

for (region_name in regions) {
  cat(paste("\nProcessing region:", region_name, "\n"))

  region_data <- subset(sim_data, region == region_name)

  # Create an interaction term for this region's data
  region_data$activity_product <- region_data$pre_activity * region_data$post_activity

  # --- Plot 1: Correlation Matrix ---
  cat(paste("  Generating correlation matrix for", region_name, "...\n"))

  corr_plot <- ggpairs(
    region_data[, c("synaptic_weight", "pre_activity", "post_activity", "activity_product")],
    title = paste("Correlation Matrix - Region:", region_name)
  )

  output_corr_path <- file.path(output_dir, paste0(region_name, "_correlation_matrix.png"))
  ggsave(output_corr_path, plot = corr_plot, width = 10, height = 10, dpi = 150)
  cat(paste("  Saved correlation matrix to", output_corr_path, "\n"))

  # --- Plot 2: Scatter plot of Activity vs. Weight ---
  cat(paste("  Generating activity vs. weight scatter plot for", region_name, "...\n"))

  scatter_plot <- ggplot(region_data, aes(x = time, y = synaptic_weight)) +
    geom_line(color = "steelblue", alpha = 0.8) +
    geom_point(data = subset(region_data, activity_product == 1),
               aes(x = time, y = synaptic_weight),
               color = "firebrick", size = 2.5, shape = 18) +
    labs(title = paste("Synaptic Weight Evolution - Region:", region_name),
         subtitle = "Red diamonds indicate simultaneous pre- and post-synaptic firing",
         x = "Time (s)", y = "Synaptic Weight") +
    theme_minimal(base_size = 14) + ylim(0, 1.1)

  output_scatter_path <- file.path(output_dir, paste0(region_name, "_activity_vs_weight.png"))
  ggsave(output_scatter_path, plot = scatter_plot, width = 12, height = 6, dpi = 150)
  cat(paste("  Saved scatter plot to", output_scatter_path, "\n"))
}

cat("\nMulti-region R analysis finished.\n")
cat(paste("All plots saved in '", output_dir, "/' directory.\n", sep=""))