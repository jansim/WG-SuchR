library(shiny)


ber_qmpreis <- function(input){
  m <- input$mW_preis / input$mW_qm
  round(m, digits = 0)
}

shinyServer(function(input, output){
  #  ==== Laden der Daten ====
  wg <- reactive({
    load.data(input$stadt)
  })
  #  ==== Übersicht ====
  output$test <- renderText({
    nrow(wg()$Daten)
  })
  output$ueb_scatter_groesse.miete <- renderPlot({
    scatter.groesse.miete(wg()$Daten)
  })
  output$ueb_scatter_bewohner.mieteproqm <- renderPlot({
    scatter.bewohner.mieteqm(wg()$Daten)
  })
  output$ueb_hist_count.bystadtteil <- renderPlot({
    hist.count.by.stadtteil(wg()$Daten)
  })
  output$ueb_hist_mieteproqm.bystadtteil <- renderPlot({
    hist.mieteproqm.by.stadtteil(wg()$Daten)
  })
  output$ueb_hist_bewohner.bystadtteil <- renderPlot({
    hist.bewohner.by.stadtteil(wg()$Daten)
  })
  output$ueb_pie <- renderpier({
    pie.bewohner(wg()$Daten)
  })
  output$ueb_pie_gesucht <- renderpier({
    pie.bewohner.ges(wg()$Daten)
  })
  #  ==== Meine Wohnung ====
  output$mW_qmpreis <- renderText({
    ber_qmpreis(input)
  })    
  output$mW_Hist <- renderPlot({
    user_qmPreis <- floor(ber_qmpreis(input))
    filtered <- filter(WGgesucht, PreisProQM > user_qmPreis, PreisProQM < (user_qmPreis + 1))
    ggplot(WGgesucht,aes(WGgesucht$PreisProQM)) +
      geom_histogram(breaks = seq(0, 50, by = 1),
                     fill = "black") +
      geom_histogram(data =filtered, aes(PreisProQM), breaks = seq(0, 50, by = 1),
                     fill = "red") +
      labs(title="Konstanz") +
      labs(x= "Preis pro Quadratmeter", y= "Anzahl") + theme_gray()
    
  })
  #  ==== Vergleich ====
})