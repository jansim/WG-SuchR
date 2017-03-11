source("init.R")

progressFunc <- function(progress) {
  print(progress)
}

DatenListe <- load.data(74, onUpdate = progressFunc)
Daten <- DatenListe$Daten

Daten %>% 
  select(stadtteil) %>% 
  distinct()

View(Daten)

staedte <- load.cities()
View(staedte)
staedte.list <- unstack(select(staedte, city_name, city_id.n))
View(staedte.list)
