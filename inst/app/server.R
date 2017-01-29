library(shiny)


ber_qmpreis <- function(input){
  m <- input$mW_preis / input$mW_qm
  round(m, digits = 0)
}

shinyServer(function(input, output){
  #  ==== Laden der Daten ====
  last.cityid <- 1
  wg <- reactive({
    if (!input$stadt == "") {
      last.cityid <<- input$stadt
    }
    load.data(last.cityid)
  })
  #  ==== Übersicht ====
  output$ueb_scatter_groesse.miete <- renderPlot({
    scatter.groesse.miete(wg()$Daten)
  })
  output$ueb_scatter_bewohner.mieteproqm <- renderPlot({
    scatter.bewohner.mieteqm(wg()$Daten)
  })
  output$ueb_hist_count.bystadtteil <- renderPlot({
    hist.count.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)
  })
  output$ueb_hist_mieteproqm.bystadtteil <- renderPlot({
    hist.mieteproqm.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)
  })
  output$ueb_hist_bewohner.bystadtteil <- renderPlot({
    hist.bewohner.by.stadtteil(wg()$Daten, ordered = input$ueb_hist_order)
  })
  output$ueb_pie <- renderPlot({
    pie.bewohner(wg()$Daten)
  })
  output$ueb_pie_gesucht <- renderPlot({
    pie.bewohner.ges(wg()$Daten)
  })
  output$ueb_vbox_count <- renderValueBox({
    valueBox(nrow(wg()$Daten), "Anzahl Reihen",icon = shiny::icon("bars"), color = "blue")
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
    WGgesucht <- wg()$Daten
    ggplot(WGgesucht,aes(WGgesucht$miete.proqm)) +
      geom_histogram(breaks = seq(0, 50, by = 1),
                     fill = "black") +
      geom_vline(aes(xintercept = ber_qmpreis(input) + 0.5), color = "red") +
      labs(title="Konstanz") +
      labs(x= "Preis pro Quadratmeter", y= "Häufigkeit") + theme_gray()
  })
  output$mW_Scatter <- renderPlot({
    WGgesucht <- wg()$Daten
    user_Punkt <- data.frame(miete = input$mW_preis, groesse = input$mW_qm)
    ggplot(data = WGgesucht) +
      geom_point(aes(groesse, miete, alpha = 0.5)) + guides(alpha = FALSE) +
      geom_point(data = user_Punkt, aes(groesse, miete), color = "red", size = 5) +
      labs(title = "Konstanz") +
      labs(x= "Wohnungsgröße", y= "Mietpreis")
  })
  output$mW_Hist1 <- renderPlot({
    WGgesucht <- wg()$Daten
    ggplot(WGgesucht,aes(WGgesucht$miete)) +
      geom_histogram(breaks = seq(100, 600, by = 10),
                     fill = "black") +
      geom_vline(aes(xintercept = input$mW_preis + 5), color = "red") +
      labs(title="Konstanz") +
      labs(x= "Mietpreis", y= "Häufigkeit") + theme_gray()
  })
  output$mW_Hist2 <- renderPlot({
    WGgesucht <- wg()$Daten
    ggplot(WGgesucht,aes(WGgesucht$groesse)) +
      geom_histogram(breaks = seq(5, 40, by = 1),
                     fill = "black") +
      geom_vline(aes(xintercept = input$mW_qm + 0.5), color = "red") +
      labs(title="Konstanz") +
      labs(x= "Wohnungsgröße", y= "Häufigkeit") + theme_gray()
  })
  #  ==== Vergleich ====
  last.cityid.vergleich <- 1
  wg.vergleich <- reactive({
    if (!input$vg_stadt == "") {
      last.cityid.vergleich <<- input$vg_stadt
    }
    load.data(last.cityid.vergleich)
  })
  output$vg_hist_mieteproqm <- renderPlot({
    # Gleich große Anzahl Reihen
    list.Daten <- data.same.n(wg()$Daten, wg.vergleich()$Daten)
    Daten <- list.Daten$Daten1
    Daten.vergleich <- list.Daten$Daten2
    
    ggplot(Daten) +
      geom_histogram(aes(miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "black") +
      geom_vline(aes(xintercept = (round(mean(Daten$miete.proqm),digits = 0) +.5) + 1)) +
      geom_histogram(aes(Daten.vergleich$miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "red") +
      geom_vline(aes(xintercept = (round(mean(Daten.vergleich$miete.proqm), digits = 0)+ .5) + 1), color = "red") +
      theme_gray() +
      labs(title="Vergleich") +
      labs(x= "Preis pro Quadrartmeter", y= "Anzahl")
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