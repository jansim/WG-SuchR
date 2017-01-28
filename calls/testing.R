source("R/data.R")

library(dplyr)

DatenListe <- load.data(74, limit = 25)
Daten <- DatenListe$Daten
Daten %>% 
  select(stadtteil) %>% 
  distinct()

View(Daten)