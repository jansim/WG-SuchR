uebersicht <- tabItem(tabName = "uebersicht", 
  textOutput("test"),
  box(title = "Scatterplots", status = "primary", width = 12,
    splitLayout(cellWidths = c("50%", "50%"),
      plotOutput("ueb_scatter_groesse.miete"),
      plotOutput("ueb_scatter_bewohner.mieteproqm")       
    )
  ),
  tabBox(title = "Nach Stadtteil", width = 12,
    tabPanel("Anzahl", plotOutput("ueb_hist_count.bystadtteil")),
    tabPanel("Bewohner", plotOutput("ueb_hist_bewohner.bystadtteil")),
    tabPanel("Miete/m²", plotOutput("ueb_hist_mieteproqm.bystadtteil"))
  ),
  pierOutput("ueb_pie"),
  pierOutput("ueb_pie_gesucht")
)
