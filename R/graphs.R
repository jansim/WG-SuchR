library(ggplot2)
library(dplyr)
library(tidyverse)

# ==== Scatterplotts ====
scatter.groesse.miete <- function(Daten) {
  lm.miete.groesse <- lm(miete ~ groesse, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = groesse, y = miete, alpha = .5)) +
    geom_abline(intercept = lm.miete.groesse$coefficients[1], slope = lm.miete.groesse$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

scatter.bewohner.miete <- function(Daten) {
  lm.miete.bewohner <- lm(miete ~ bewohner, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = bewohner, y = miete, alpha = .5)) +
    geom_abline(intercept = lm.miete.bewohner$coefficients[1], slope = lm.miete.bewohner$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)
}

scatter.bewohner.mieteqm <- function(Daten) {
  lm.mieteqm.bewohner <- lm(miete.proqm ~ bewohner, data = Daten)
  ggplot(Daten) +
    geom_point(aes(x = bewohner, y = miete.proqm, alpha = .5)) +
    geom_abline(intercept = lm.mieteqm.bewohner$coefficients[1], slope = lm.mieteqm.bewohner$coefficients[2], colour="#E41A1C") +
    guides(alpha=FALSE)  
}


# ==== Nach Stadtteil ====
# Anzahl Wohnungen nach Stadtteil
hist.count.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten) # aus data.R
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -count), y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}

# Preis pro qm nach Stadtteil
hist.mieteproqm.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten)
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -miete.proqm), y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}

# WG-Größe pro qm nach Stadtteil
hist.bewohner.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten)
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -bewohner), y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}


# ==== Pie Charts / Tortendiagramme ====
library(pier) # devtools::install_github("mrjoh3/pier")

pie.bewohner <- function(Daten, header = 'Verteilung der Geschlechter in WGs') {
  Verteilung.pier <- data.frame(
    label = c("Männlich", "Weiblich"),
    value = c(mean(Daten$m), mean(Daten$w)),
    color = c("blue", "red")
  )
  bewohner.pie <- pier(Verteilung.pier) %>% pie.header(header)
  bewohner.pie
}

pie.bewohner.ges <- function(Daten, header = 'Verteilung der Gesuchten Geschlechter') {
  Verteilung.ges.pier <- data.frame(
    label = c("Männlich", "Weiblich", "Egal"),
    value = c(mean(Daten$g.m), mean(Daten$g.w), mean(Daten$g.e)),
    color = c("blue", "red", "grey")
  )
  bewohner.ges.pie <- pier(Verteilung.ges.pier) %>% pie.header(header) 
  bewohner.ges.pie
}

# piechart.ggplot <- function(Daten) {
#   Verteilung <- data.frame(
#     gender = c("m", "w"),
#     average = c(mean(Daten$m), mean(Daten$w))
#   )
#   
#   pie_chart_theme <- blank_theme <- theme_minimal() +
#     theme(
#       axis.title.x = element_blank(),
#       axis.title.y = element_blank(),
#       panel.border = element_blank(),
#       panel.grid=element_blank(),
#       axis.ticks = element_blank(),
#       axis.text.x=element_blank()
#     )
#   g <- ggplot(Verteilung, aes(x = "", y = average, fill = gender))
#   g + geom_bar(stat="identity") + coord_polar("y", start=0) + pie_chart_theme
# }