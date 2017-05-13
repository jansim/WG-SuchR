# ==== Scatterplotts ====

#' Scatterplot Miete nach Größe
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#'
#' @return
#' @export
#'
#' @examples
scatter.groesse.miete <- function(Daten) {
  lm.miete.groesse <- lm(miete ~ groesse, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = groesse, y = miete, alpha = .5)) +
    geom_abline(intercept = lm.miete.groesse$coefficients[1], slope = lm.miete.groesse$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

#' Scatterplot Miete nach Bewohnerzahl
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#'
#' @return
#' @export
#'
#' @examples
scatter.bewohner.miete <- function(Daten) {
  lm.miete.bewohner <- lm(miete ~ bewohner, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = bewohner, y = miete, alpha = .5)) +
    geom_abline(intercept = lm.miete.bewohner$coefficients[1], slope = lm.miete.bewohner$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

#' Scatterplot Miete pro Quadratmeter nach Bewohnerzahl
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#'
#' @return
#' @export
#'
#' @examples
scatter.bewohner.mieteqm <- function(Daten) {
  lm.mieteqm.bewohner <- lm(miete.proqm ~ bewohner, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = bewohner, y = miete.proqm, alpha = .5)) +
    geom_abline(intercept = lm.mieteqm.bewohner$coefficients[1], slope = lm.mieteqm.bewohner$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

#' Scatterplot Miete pro Quadratmeter nch Geschlecht
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#'
#' @return
#' @export
#'
#' @examples
scatter.geschl.mieteqm <- function(Daten) {
  lm.mieteqm.geschl <- lm(miete.proqm ~ geschl.verh, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = geschl.verh, y = miete.proqm, alpha = .5)) +
    geom_abline(intercept = lm.mieteqm.geschl$coefficients[1], slope = lm.mieteqm.geschl$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

scatterMieteGroeße <- function(Daten,user_Punkt){
  ggplot(data = Daten) +
  geom_point(aes(groesse, miete, alpha = 0.5)) + guides(alpha = FALSE) +
  geom_point(data = user_Punkt, aes(groesse, miete), color = "red", size = 5)
}
