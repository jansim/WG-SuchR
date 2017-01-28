library(shiny)


ber_qmpreis <- function(input){
  m <- input$mW_preis / input$mW_qm
  round(m, digits = 0)
}

shinyServer(function(input, output){
  wg <- reactive({
    load.data(input$stadt)
  })
  output$test <- renderText({
    nrow(wg()$Daten)
  })
  output$Histogramm1 <- renderPlot({
    hist(WGgesucht$PreisProQM, xlab = "Preis pro Quadratmeter", ylab = "Häufigkeit", main = "Konstanz")
  })  
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
})