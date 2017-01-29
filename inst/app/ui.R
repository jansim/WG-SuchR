library(shiny)
library(shinydashboard)

# Load functions
source("../../init.R", chdir = T)

# Load Tab Contents
source("ui/uebersicht.R")
source("ui/meineWohnung.R")
source("ui/vergleich.R")
source("ui/download.R")


dashboardPage(
  dashboardHeader(title = "WG-SuchR", titleWidth = 230, disable = FALSE),
  dashboardSidebar(
    sidebarMenu(
      selectizeInput("stadt", "Stadt:", staedte.list),
      menuItem("Übersicht", tabName = "uebersicht", icon = icon("bar-chart")),
      menuItem("Meine Wohnung", tabName = "meineWohnung", icon = icon("home")),
      menuItem("Vergleich", tabName = "vergleich", icon = icon("balance-scale")),
      menuItem("Download", tabName = "download", icon = icon("download"))
    )
  ),
  dashboardBody(
    tabItems(
      uebersicht,
      meineWohnung,
      vergleich,
      download
    )
  )
)

