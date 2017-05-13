source("R/data.R", chdir = T)
source("R/pie_charts.R", chdir = T)
source("R/scatterplots.R", chdir = T)
source("R/hist.R", chdir = T)

staedte <- load.cities()
staedte.list <- cities.to.list(staedte)

# staedte.list <- list(Konstanz = 74, Aachen = 1)