# ==== Histogramme ====

# ==== Nach Stadtteil ====
#' Anzahl Wohnungen nach Stadtteil
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#' @param ordered
#'
#' @return
#' @export
#'
#' @examples
hist.count.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten) # aus data.R
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -count), y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = count), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}

#' Preis pro qm nach Stadtteil
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#' @param ordered
#'
#' @return
#' @export
#'
#' @examples
hist.mieteproqm.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten)
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -miete.proqm), y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = miete.proqm), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}

#' WG-Größe pro qm nach Stadtteil
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#' @param ordered
#'
#' @return
#' @export
#'
#' @examples
hist.bewohner.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten)
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -bewohner), y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = bewohner), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p
}

#' Geschlechterverhältnisse nach Stadtteil
#'
#' @param Daten WG-Gesucht Datensatz für eine Stadt
#' @param ordered
#'
#' @return
#' @export
#'
#' @examples
hist.geschl.by.stadtteil <- function(Daten, ordered = F) {
  Daten.by.stadtteil <- data.by.stadtteil(Daten)
  if (ordered) {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = reorder(stadtteil, -geschl.verh), y = geschl.verh), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  } else {
    p <- ggplot(Daten.by.stadtteil) + geom_bar(aes(x = stadtteil, y = geschl.verh), stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = .5))
  }
  p <- p + geom_hline(yintercept = 0.5, alpha = .5)
  p
}

# Meine Wohnung
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

# Vergleich
histVergleich <- function(Daten, Daten.vergleich){
  ggplot(Daten) +
    geom_histogram(aes(miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "blue") +
    geom_vline(aes(xintercept = (round(mean(Daten$miete.proqm),digits = 0) +.5) + 1), color = "blue") +
    geom_histogram(aes(Daten.vergleich$miete.proqm), binwidth = .5, position = "dodge", alpha = .5, breaks = seq(0,50, by = 1), fill = "red") +
    geom_vline(aes(xintercept = (round(mean(Daten.vergleich$miete.proqm), digits = 0)+ .5) + 1), color = "red") +
    theme_gray()
}
