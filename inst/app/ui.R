library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "MeatvergleichR", titleWidth = 230, disable = FALSE),
  dashboardSidebar(
    sidebarMenu(
      selectizeInput("stadt", "Stadt:",list("Konstanz" = 1, "Waldstetten" = 2)),
      menuItem("Übersicht", tabName = "uebersicht", icon = icon("bar-chart")),
      menuItem("Meine Wohnung", tabName = "meineWohnung", icon = icon("home")),
      menuItem("Vergleich", tabName = "vergleich", icon = icon("balance-scale"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "uebersicht", plotOutput("Histogramm1")),
      tabItem(tabName = "meineWohnung",
              sliderInput("mW_qm",
                          "Quadratmeter:",
                          min = 0,
                          max = 40,
                          value = 0),
              sliderInput("mW_preis",
                          "Wohnungspreis:",
                          min = 0,
                          max = 600,
                          value = 0,
                          step = 5),
              textOutput("mW_qmpreis"),
              plotOutput("mW_Hist")),
      tabItem(tabName = "vergleich")
      )
        )
)

