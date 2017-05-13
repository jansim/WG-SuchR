ber_qmpreis <- function(input){
  m <- input$mW_preis / input$mW_qm
  round(m, digits = 0)
}

shinyServer(function(input, output){
  #  ==== Laden der Daten ====
  last.cityid <- 1
  cityid <- reactive({
    if (!input$stadt == "") {
      last.cityid <<- input$stadt
    }
    last.cityid
  })
  wg <- reactive({
    # Progress Meldung anzeigen
    progress <- shiny::Progress$new()
    progress$set(message = "Lade Daten", value = 0)
    on.exit(progress$close()) # Progress schließen wenn reactive fertig
    updateProgress <- function(value) {
      progress$set(value = value)
    }
    # Daten laden
    wgInfo <- load.data(cityid(), rows = input$rows_to_load, onUpdate = updateProgress)
    if (nrow(wgInfo$Daten) == 0) {showNotification(ui = "Keine Anzeigen für diese Stadt gefunden", type = "error")}
    wgInfo
  })
  stadt <- reactive({
    filter(staedte, city_id == cityid())
  })
  #  ==== Übersicht ====
  output$ueb_scatter_groesse.miete <- renderPlot({
    scatter.groesse.miete(wg()$Daten)+
      labs(x= "Wohnungsgröße", y= "Mietpreis")
  })
  output$ueb_scatter_bewohner.mieteproqm <- renderPlot({
    scatter.bewohner.mieteqm(wg()$Daten)+
      labs(x= "Bewohnerzahl", y= "Preis pro Quadartmeter")
  })
  output$ueb_hist_count.bystadtteil <- renderPlot({
    hist.count.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)+
      labs(x= "Stadtteil", y="Anzahl der Wohnungen")
  })
  output$ueb_hist_mieteproqm.bystadtteil <- renderPlot({
    hist.mieteproqm.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)+
      labs(x= "Stadtteil", y="Durchschnittlicher Preis pro Quadratmeter")
  })
  output$ueb_hist_bewohner.bystadtteil <- renderPlot({
    hist.bewohner.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)+
      labs(x= "Stadtteil", y="Durchschnittliche Bewohnerzahl")
  })
  output$ueb_hist_geschlverh.bystadtteil <- renderPlot({
    hist.geschl.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)+
      labs(x= "Stadtteil", y="Geschlechterverhältnis (Anteil Männer)")
  })
  output$ueb_pie <- renderPlot({
    pie.bewohner(wg()$Daten) + labs(fill="Geschlecht")
  })
  output$ueb_pie_gesucht <- renderPlot({
    pie.bewohner.ges(wg()$Daten) + labs(fill="Geschlecht")
  })
  output$ueb_vbox_count <- renderValueBox({
    valueBox(nrow(wg()$Daten), "Anzahl Reihen",icon = shiny::icon("bars"), color = "blue")
  })
  output$ueb_vbox_active <- renderValueBox({
    Daten.active <- filter(wg()$Daten, active == TRUE)
    valueBox(nrow(Daten.active), "Anzahl aktive Reihen",icon = shiny::icon("check"), color = "green")
  })
  #  ==== Meine Wohnung ====
  output$qmmiete_box <- renderValueBox({
    WGgesucht <- wg()$Daten
    user_qmPreis <- ber_qmpreis(input)
    stabw <- sd(WGgesucht$miete.proqm)
    mw <- mean(WGgesucht$miete.proqm)
    boxColor <- "yellow"
    boxSymbol <- "hand-o-left"
    if (user_qmPreis > mw + stabw) {
      # zu teuer
      boxColor <- "red" 
      boxSymbol <- "thumbs-o-down"
    } else if (user_qmPreis < mw - stabw) {
      # zu billig
      boxColor <- "green"
      boxSymbol <- "thumbs-o-up"
    }
    valueBox(paste0(user_qmPreis, "€"), "pro Quadratmeter",icon = shiny::icon(boxSymbol), color = boxColor)
  })  
  output$mW_Hist <- renderPlot({
    histMieteQM(wg()$Daten, ber_qmpreis(input)) +
      labs(title=stadt()$city_and_state) +
      labs(x= "Preis pro Quadratmeter", y= "Häufigkeit") + theme_gray()
  })
  output$mW_Scatter <- renderPlot({
    scatterMieteGroeße(wg()$Daten, data.frame(miete = input$mW_preis, groesse = input$mW_qm)) +
      labs(title = stadt()$city_and_state) +
      labs(x= "Wohnungsgröße", y= "Mietpreis")
  })
  output$mW_Hist1 <- renderPlot({
    histMiete(wg()$Daten, input$mW_preis) +
      labs(title=stadt()$city_and_state) +
      labs(x= "Mietpreis", y= "Häufigkeit") + theme_gray()
  })
  output$mW_Hist2 <- renderPlot({
    histQM(wg()$Daten, input$mW_qm) +
      labs(title=stadt()$city_and_state) +
      labs(x= "Wohnungsgröße", y= "Häufigkeit") + theme_gray()
  })
  #  ==== Vergleich ====
  last.cityid.vergleich <- 1
  cityid.vergleich <- reactive({
    if (!input$vg_stadt == "") {
      last.cityid.vergleich <<- input$vg_stadt
    }
    last.cityid.vergleich
  })
  wg.vergleich <- reactive({
    load.data(cityid.vergleich(), rows = input$rows_to_load)
  })
  stadt.vergleich <- reactive({
    filter(staedte, city_id == cityid.vergleich())
  })
  output$vg_hist_mieteproqm <- renderPlot({
    histVergleich(wg()$Daten, wg.vergleich()$Daten)+
      labs(title="Vergleich") +
      labs(x= "Preis pro Quadrartmeter", y= "Anzahl")
  })
  output$mean_1 <- renderValueBox({
    list.Daten <- data.same.n(wg()$Daten, wg.vergleich()$Daten)
    Daten <- list.Daten$Daten1
    Daten.vergleich <- list.Daten$Daten2
    valueBox(paste0(round(mean(Daten$miete.proqm), digits = 2), "€"), subtitle = paste("pro Quadratmeter im Schnitt in", stadt()$city_name) ,icon = shiny::icon ("money"), color = "blue")
  })
  output$mean_2 <- renderValueBox({
    list.Daten <- data.same.n(wg()$Daten, wg.vergleich()$Daten)
    Daten <- list.Daten$Daten1
    Daten.vergleich <- list.Daten$Daten2
    valueBox(paste0(round(mean(Daten.vergleich$miete.proqm), digits = 2), "€"), subtitle =  paste("pro Quadratmeter im Schnitt in", stadt.vergleich()$city_name) ,icon = shiny::icon ("money"), color = "red")
  })
  #  ==== Download ====
  dl_data <- reactive({
    switch(input$dl_dataset,
      daten = wg()$Daten,
      cities = staedte
    )
  })
  output$dl_downloadButton <- downloadHandler(
    filename = function() {
      name <- switch(input$dl_dataset,
        daten = "data",
        cities = "staedte"
      )
      paste0("wg_", name, '.csv')
    },
    content = function(file) {
      write.csv(dl_data(), file)
    }
  )
  output$dl_table <- renderDataTable({
    dl_data()
  })
})