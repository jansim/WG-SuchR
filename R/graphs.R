library(ggplot)
library(dplyr)
library(tidyverse)

# ==== Scatterplotts ====
g <- ggplot(Daten)

lm.miete.groesse <- lm(miete ~ groesse, data = Daten)
g + geom_point(aes(x = groesse, y = miete, alpha = .5)) + geom_abline(intercept = lm.miete.groesse$coefficients[1], slope = lm.miete.groesse$coefficients[2], colour="#E41A1C") + guides(alpha=FALSE)

lm.miete.bewohner <- lm(miete ~ bewohner, data = Daten)
g + geom_point(aes(x = bewohner, y = miete, alpha = .5)) + geom_abline(intercept = lm.miete.bewohner$coefficients[1], slope = lm.miete.bewohner$coefficients[2], colour="#E41A1C") + guides(alpha=FALSE)

lm.mieteqm.bewohner <- lm(miete.proqm ~ bewohner, data = Daten)
g + geom_point(aes(x = bewohner, y = miete.proqm, alpha = .5)) + geom_abline(intercept = lm.mieteqm.bewohner$coefficients[1], slope = lm.mieteqm.bewohner$coefficients[2], colour="#E41A1C") + guides(alpha=FALSE)

# ==== Nach Stadtteil ====
Daten.by.stadtteil <- Daten %>% 
  mutate(stadtteil.lower = tolower(stadtteil)) %>% 
  group_by(stadtteil.lower) %>%
  summarise(
    count = n(),
    miete.proqm = mean(miete.proqm),
    bewohner = mean(bewohner),
    stadtteil = stadtteil[1]
  ) %>% 
  filter(count > 2)
View(Daten.by.stadtteil)

# Histogramme
# Anzahl Wohnungen nach Stadtteil
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -count), y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
# Preis pro qm nach Stadtteil
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -miete.proqm), y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
# WG-Größe pro qm nach Stadtteil
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -bewohner), y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))


# ==== Pie Charts ====

Verteilung <- data.frame(
  gender = c("m", "w"),
  average = c(mean(Daten$m), mean(Daten$w))
)

# ggplot
pie_chart_theme <- blank_theme <- theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    axis.text.x=element_blank()
  )
g <- ggplot(Verteilung, aes(x = "", y = average, fill = gender))
g + geom_bar(stat="identity") + coord_polar("y", start=0) + pie_chart_theme

# pier
#devtools::install_github("mrjoh3/pier")
library(pier)
Verteilung.pier <- data.frame(
  label = c("Männlich", "Weiblich"),
  value = c(mean(Daten$m), mean(Daten$w)),
  color = c("blue", "red")
)
pier(Verteilung.pier) %>% pie.header('Verteilung der Geschlechter in WGs')

Verteilung.ges.pier <- data.frame(
  label = c("Männlich", "Weiblich", "Egal"),
  value = c(mean(Daten$g.m), mean(Daten$g.w), mean(Daten$g.e)),
  color = c("blue", "red", "grey")
)
pier(Verteilung.ges.pier) %>% pie.header('Verteilung der Gesuchten Geschlechter')
