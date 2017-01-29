vergleich <- tabItem(tabName = "vergleich",
  fluidRow(
    box(title = "Auswahl", width = 12, collapsible = TRUE,
      selectizeInput("vg_stadt", "Stadt zum Vergleichen:", staedte.list)
    ),
    box(title = "Miete/m²", width = 12, status = "primary",
      plotOutput("vg_hist_mieteproqm"),
      valueBoxOutput("mean_1", width = 6),
      valueBoxOutput("mean_2", width = 6)
    )
   )
)