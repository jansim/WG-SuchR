#==== Histogramme ====

histMieteQM <- function(Daten, QMPreis){
  ggplot(Daten,aes(miete.proqm)) +
    geom_histogram(breaks = seq(0, 50, by = 1),
                   fill = "black") +
    geom_vline(aes(xintercept = QMPreis + 0.5), color = "red") 
}

histMiete <- function(Daten, TotPreis){
  ggplot(Daten,aes(miete)) +
  geom_histogram(breaks = seq(100, 600, by = 10),
                 fill = "black") +
  geom_vline(aes(xintercept = TotPreis + 5), color = "red") 
}

histQM <- function(Daten, TotQM){
  ggplot(Daten,aes(groesse)) +
  geom_histogram(breaks = seq(5, 40, by = 1),
                 fill = "black") +
  geom_vline(aes(xintercept = TotQM + 0.5), color = "red") 
}

histVergleich <- function(Daten, Daten.vergleich){
  ggplot(Daten) +
    geom_histogram(aes(miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "blue") +
    geom_vline(aes(xintercept = (round(mean(Daten$miete.proqm),digits = 0) +.5) + 1), color = "blue") +
    geom_histogram(aes(Daten.vergleich$miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "red") +
    geom_vline(aes(xintercept = (round(mean(Daten.vergleich$miete.proqm), digits = 0)+ .5) + 1), color = "red") +
    theme_gray() 
}
  