source("data.R", chdir = T)
source("pie_charts.R", chdir = T)
source("scatterplots.R", chdir = T)
source("hist.R", chdir = T)

staedte <- load.cities()
staedte.list <- cities.to.list(staedte)
