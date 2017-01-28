uebersicht <- tabItem(tabName = "uebersicht", 
  textOutput("test"),
  plotOutput("ueb_scatter_groesse.miete"),
  plotOutput("ueb_scatter_bewohner.mieteproqm"),
  plotOutput("ueb_hist_count.bystadtteil"),
  plotOutput("ueb_hist_bewohner.bystadtteil"),
  plotOutput("ueb_hist_mieteproqm.bystadtteil")
)
