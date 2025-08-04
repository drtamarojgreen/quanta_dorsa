library(ggplot2)
data <- read.csv("synapse_data.csv")

# Correlation plot x vs y
p <- ggplot(data, aes(x=x, y=y)) +
  geom_point(color="blue", alpha=0.6) +
  geom_smooth(method="lm", se=FALSE, color="red") +
  ggtitle("Correlation between x and y") +
  theme_minimal()

ggsave("correlation_plot.png", plot=p, width=6, height=4)