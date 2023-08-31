#' @title draw_barplot_simple
#' @description Draw a barplot with error bars.
#' @param data the data frame with the data to plot.
#' @param title the title of the plot.
#' @param x_var the variable to plot in the x axis.
#' @param y_var the variable to plot in the y axis.
#' @param error_var the variable to plot as error bars.
#' @param title_y the title of the y axis.
#' @param title_x the title of the x axis.
#' @param legend_title the title of the legend.
#' @param legend_position the position of the legend.
#' @param breaks the breaks of the x axis.
#' @param break_labels the labels of the breaks in the y axis.
#' @param colors the colors of the bars.



library(ggplot2)
draw_stacked <- function(data, facet, fill_var, title) {

  plot <- ggplot(
    data = data,
    aes(x = samples, y = relative_abundance, fill = .data[[fill_var]])
  ) +
    geom_bar(stat = "identity") +
    facet_grid(cols = vars(.data[[facet]]), space = "free", scales = "free") +

    theme_pubr() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, size = unit(9, "cm")),
      legend.position = "none"
    ) +
    ggtitle(title)

  return(plot)
}
