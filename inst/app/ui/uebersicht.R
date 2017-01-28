uebersicht <- tabItem(tabName = "uebersicht", 
  textOutput("test"),
  box(title = "Scatterplots", status = "primary", width = 12,
    splitLayout(cellWidths = c("50%", "50%"),
      plotOutput("ueb_scatter_groesse.miete"),
      plotOutput("ueb_scatter_bewohner.mieteproqm")       
    )
  ),
  tabBox(title = tagList(shiny::icon("bar-chart"), "Nach Stadtteil"), width = 12,
    tabPanel("Anzahl", plotOutput("ueb_hist_count.bystadtteil")),
    tabPanel("Bewohner", plotOutput("ueb_hist_bewohner.bystadtteil")),
    tabPanel("Miete/m²", plotOutput("ueb_hist_mieteproqm.bystadtteil")),
    "Test"
  ),
  box(title = "Pies", status = "warning", width = 12,
    splitLayout(cellWidths = c("50%", "50%"),
      plotOutput("ueb_pie"),
      plotOutput("ueb_pie_gesucht")
    )
  )
)
