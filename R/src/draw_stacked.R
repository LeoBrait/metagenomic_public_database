library(ggplot2)
draw_stacked <- function(data, fill_var) {
  plot <- ggplot(
    data = data,
    aes(x = samples, y = relative_abundance, fill = fill_var)
  ) +
    geom_bar(stat = "identity") +
    facet_grid(cols = vars(habitat), space = "free", scales = "free") +
    theme_pubr() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, size = unit(9, "cm")),
      legend.position = "none"
    )
}