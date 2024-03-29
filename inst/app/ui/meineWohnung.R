meineWohnung <- tabItem(tabName = "meineWohnung",
              fluidRow(
                box(sliderInput("mW_qm",
                          "Quadratmeter:",
                          min = 5,
                          max = 40,
                          value = 0),
                    sliderInput("mW_preis",
                          "Wohnungspreis:",
                          min = 100,
                          max = 600,
                          value = 0,
                          step = 5)),
                valueBoxOutput("qmmiete_box", width = 6)),
              fluidRow(
                box(title = "Histogramm Preis pro Quadratmeter",
                    plotOutput("mW_Hist", height = 210),
                    width = 6, status = "primary",
                    solidHeader = TRUE, collapsible = TRUE),
                box(title = "Scatterplot",
                    plotOutput("mW_Scatter", height = 210),
                    width = 6, status = "primary",
                    solidHeader = TRUE, collapsible = TRUE)),
              fluidRow(
                box(title = "Histogramm Mietpreis",
                    plotOutput("mW_Hist1", height = 210),
                    width = 6, status = "primary",
                    solidHeader = TRUE, collapsible = TRUE),
                box(title = "Histogramm Größe",
                    plotOutput("mW_Hist2", height = 210),
                    width = 6, status = "primary",
                    solidHeader = TRUE, collapsible = TRUE))
      )