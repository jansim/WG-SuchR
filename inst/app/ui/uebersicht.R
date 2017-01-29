uebersicht <- tabItem(tabName = "uebersicht", 
  textOutput("test"),
  fluidRow(
    box(title = "Verteilung", status = "primary", width = 12, collapsible = T,
      splitLayout(cellWidths = c("50%", "50%"),
        plotOutput("ueb_scatter_groesse.miete", height = 210),
        plotOutput("ueb_scatter_bewohner.mieteproqm", height = 210)       
      )
    ),
    tabBox(title = tagList(shiny::icon("bar-chart"), "nach Stadtteilen"), width = 9,
      tabPanel("Anzahl", plotOutput("ueb_hist_count.bystadtteil")),
      tabPanel("Bewohner", plotOutput("ueb_hist_bewohner.bystadtteil")),
      tabPanel("Miete/m²", plotOutput("ueb_hist_mieteproqm.bystadtteil")),
      "Test"
    ),
    valueBoxOutput("ueb_vbox_count", width = 3),
    valueBoxOutput("ueb_vbox_active", width = 3),
    box(width = 3,
      checkboxInput("ueb_hist_order", "Histogramme ordnen")
    ),
    box(title = "Geschlechterverhältnis", status = "warning", width = 12, collapsible = T,
      splitLayout(cellWidths = c("50%", "50%"),
        plotOutput("ueb_pie", height = 200),
        plotOutput("ueb_pie_gesucht", height = 200)
      )
    ) 
  )
)
