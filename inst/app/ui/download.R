download <- tabItem(tabName = "download",
  "Download",
  tableOutput('table'),
  fluidRow(
    box(title = "Datensatz auswählen", status = "primary", width = 12,
      selectInput("dl_dataset", "Datensatz auswählen:", choices = list("Daten zur aktuellen Stadt" = "daten", "Städteliste" = "cities")),
      downloadButton('dl_downloadButton', 'Download')
    ),
    box(title = "Datensatz ansehen", status = "success", width = 12,
      tableOutput("dl_table")
    )
  )
)