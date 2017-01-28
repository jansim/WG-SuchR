#  ==== Constans ====
DATAIMPORT.ROOT <- paste0(getwd(), "/../data/")

WOHNTYP.WG <- 0
WOHNTYP.1ZIMMER <- 1
WOHNTYP.WOHNUNG <- 2
WOHNTYP.HAUS <- 3

# ==== Helpers ====
txt.to.num <- function(str) {
  regmatches(str, regexpr("[[:digit:]]+", str)) %>%
    as.numeric()
}
html.to.txt <- function(html) {
  html_text(html, trim = T)
}
html.to.num <- function(html) {
  html %>% html.to.txt() %>% txt.to.num()
}

# ==== Load Cities ====
library(jsonlite)

cities.to.list <- function(cities) {
  cities %>% 
    select(city_name, city_id.n) %>% 
    distinct(city_name, .keep_all = T) %>% 
    unstack(form = city_id.n ~ city_name)
}

fetch.cities.letter <- function(q) {
  fromJSON(paste0("http://www.wg-gesucht.de/ajax/api/Smp/api.php?action=city-list&language=de&query=", q))
}

load.cities <- function(forceUpdate = F) {
  datapath <- paste0(DATAIMPORT.ROOT, "wg_staedte.RData")
  # Load cached data if it exists
  if (file.exists(datapath) && !forceUpdate) {
    load(datapath)
  } else {
    for (l in LETTERS) {
      try({
        temp <- fetch.cities.letter(l)
        if (exists("Staedte.temp")) {
          Staedte.temp <- rbind(Staedte.temp, temp)
        } else {
          Staedte.temp <- temp
        }
      })
    }
    Staedte <- Staedte.temp
    Staedte$city_id.n <- as.numeric(Staedte$city_id)
    Staedte.timestamp <- date()
    save(Staedte, Staedte.timestamp, file = datapath)
  }
  # # List to return results
  # l <- list()
  # l$Staedte <- Staedte
  # l$timestamp <- Staedte.timestamp
  # l
  Staedte
}

# ==== Load actual WG-Gesucht Data ====
library(rvest)
fetch.page <- function(session) {
  skip_rows <- 4
  trs <- session %>%
    html_nodes("#table-compact-list tr")
  count <- length(trs) - skip_rows
  
  df.temp <- data.frame(
    id = numeric(count),
    active = logical(count),
    
    miete = numeric(count),
    groesse = numeric(count),
    stadtteil = character(count),
    
    eintrag = character(count),
    frei.ab = character(count),
    frei.bis = character(count),
    
    m = numeric(count),
    w = numeric(count),
    g.m = numeric(count),
    g.w = numeric(count),
    g.e = numeric(count),
    
    stringsAsFactors = F
  )
  
  for (i in 1:count) {
    tr <- trs[i + skip_rows]
    children <- html_children(tr)
    
    df.temp$active[i] <- !grepl("inactive", html_attr(tr, "class"))
    df.temp$id[i] <- txt.to.num(html_attr(tr, "adid"))
    
    # m[i] <- 0 # Männliche
    # w[i] <- 0 # Weibliche
    # g.m[i] <- 0 # Männliche gesucht
    # g.w[i] <- 0 # Weibliche gesucht
    # g.e[i] <- 0 # egal gesucht
    for (img in children[2] %>% html_nodes("img")) {
      p <- strsplit(strsplit(html_attr(img, "src"), "img/wg")[[1]][2], ".gif")[[1]][1]
      switch(p,
             w = {df.temp$w[i] <- df.temp$w[i] + 1},
             m = {df.temp$m[i] <- df.temp$m[i] + 1},
             wg = {df.temp$g.w[i] <- df.temp$g.w[i] + 1},
             mg = {df.temp$g.m[i] <- df.temp$g.m[i] + 1},
             eg = {df.temp$g.e[i] <- df.temp$g.e[i] + 1}
      )
    }
    df.temp$miete[i] <- html.to.num(children[4])
    df.temp$groesse[i] <- html.to.num(children[5])
    df.temp$stadtteil[i] <- html.to.txt(children[6])
    df.temp$eintrag[i] <- html.to.txt(children[3])
    df.temp$frei.ab[i] <- html.to.txt(children[7])
    df.temp$frei.bis[i] <- html.to.txt(children[8])
    # for (j in 1:length(children)) {
    #   print(html.to.txt(children[j]))
    # }
  }
  df.temp
}

fetch.dataframe <- function(city, limit, wohntyp) {
  sess <- html_session(paste0("http://www.wg-gesucht.de/wg-zimmer-in-Konstanz.", city ,".0.0.0.html"))
  session <- sess
  
  df <- fetch.page(sess)
  if (limit > 1) {
    for(i in 1:(limit - 1)) {
      sess <- follow_link(sess, "»")
      df <- rbind(df, fetch.page(sess))
    } 
  }
  df
}

load.data <- function(city = 74, wohntyp = WOHNTYP.WG, limit = 5, forceUpdate = F) {
  datapath <- paste0(DATAIMPORT.ROOT, "wg_data_", city, "_", wohntyp, ".RData")
  # Load cached data if it exists
  if (file.exists(datapath) && !forceUpdate) {
    load(datapath)
  } else {
    Daten <- fetch.dataframe(city = city, wohntyp = wohntyp, limit = limit)
    Daten.timestamp <- date()
    save(Daten, Daten.timestamp, file = datapath)
  }
  # List to return results
  l <- list()
  l$Daten <- data.process(Daten)
  l$timestamp <- Daten.timestamp
  l
}

# Verarbeitung der Daten / Vorbereiten von Werten
data.process <- function(data) {
  data$bewohner.ges <- data$g.m + data$g.w + data$g.e
  data$bewohner <- data$m + data$w + data$bewohner.ges
  
  data$miete.proqm <- round(data$miete / data$groesse, digits = 2)
  data
}

test <- function() {
  datapath <- paste0(DATAIMPORT.ROOT, "wg_data_", 74, "_", 0, ".RData") 
  print(datapath)
  print(file.exists(datapath))
  print(getwd())
}