# ==== Pie Charts / Tortendiagramme ====

# Theme für ggplot pie charts
pie_chart_theme <- theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    axis.text.x=element_blank()
  )

#' Piechart zu Geschlechtsverteilung vorhandener Bewohner
#'
#' @param Daten 
#'
#' @return
#' @export
#'
#' @examples
pie.bewohner <- function(Daten) {
  Verteilung <- data.frame(
    gender = c("Männlich", "Weiblich"),
    average = c(mean(Daten$m), mean(Daten$w))
  )
  colors <-  c("blue", "red")

  ggplot(Verteilung, aes(x = "", y = average, fill = gender)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    scale_fill_manual(values = colors) +
    pie_chart_theme
}

#' Piechart zur gesuchten Geschlechtsverteilung
#'
#' @param Daten 
#'
#' @return
#' @export
#'
#' @examples
pie.bewohner.ges <- function(Daten) {
  Verteilung.ges <- data.frame(
    gender = c("Egal", "Männlich", "Weiblich"),
    average = c(mean(Daten$g.e), mean(Daten$g.m), mean(Daten$g.w))
  )
  colors <- c("grey", "blue", "red")
  ggplot(Verteilung.ges, aes(x = "", y = average, fill = gender)) +
    geom_bar(stat = "identity", width = 1) +
    coord_polar("y", start = 0) +
    scale_fill_manual(values = colors) +
    pie_chart_theme
}