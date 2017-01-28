library(shiny)
library(shinydashboard)

# Load Tab Contents
source("ui/uebersicht.R")
source("ui/meineWohnung.R")
source("ui/vergleich.R")


dashboardPage(
  dashboardHeader(title = "MeatvergleichR", titleWidth = 230, disable = FALSE),
  dashboardSidebar(
    sidebarMenu(
      selectizeInput("stadt", "Stadt:", list("Konstanz" = 1, "Waldstetten" = 2)),
      menuItem("Übersicht", tabName = "uebersicht", icon = icon("bar-chart")),
      menuItem("Meine Wohnung", tabName = "meineWohnung", icon = icon("home")),
      menuItem("Vergleich", tabName = "vergleich", icon = icon("balance-scale"))
    )
  ),
  dashboardBody(
    tabItems(
      uebersicht,
      meineWohnung,
      vergleich
    )
  )
)

