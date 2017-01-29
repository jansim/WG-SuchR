vergleich <- tabItem(tabName = "vergleich",
  selectizeInput("vg_stadt", "Stadt zum Vergleichen:", staedte.list),
  plotOutput("vg_hist_mieteproqm")
)