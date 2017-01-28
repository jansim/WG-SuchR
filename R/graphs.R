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