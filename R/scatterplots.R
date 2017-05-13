

scatterMieteGroeße <- function(Daten,user_Punkt){
  ggplot(data = Daten) +
  geom_point(aes(groesse, miete, alpha = 0.5)) + guides(alpha = FALSE) +
  geom_point(data = user_Punkt, aes(groesse, miete), color = "red", size = 5) 
}

