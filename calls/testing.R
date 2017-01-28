source("R/data.R")

library(dplyr)

DatenListe <- load.data(74, limit = 25)
Daten <- DatenListe$Daten
Daten %>% 
  select(stadtteil) %>% 
  distinct()

View(Daten)

staedte <- load.cities()
View(staedte)
staedte.list <- unstack(select(staedte, city_name, city_id.n))
View(staedte.list)
