uebersicht <- tabItem(tabName = "uebersicht", 
  textOutput("test"),
  fluidRow(
    box(title = "Scatterplots", status = "primary", width = 12,
      splitLayout(cellWidths = c("50%", "50%"),
        plotOutput("ueb_scatter_groesse.miete", height = 210),
        plotOutput("ueb_scatter_bewohner.mieteproqm", height = 210)       
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
        plotOutput("ueb_pie", height = 200),
        plotOutput("ueb_pie_gesucht", height = 200)
      )
    ) 
  )
)
