library(tidyverse)
swars <- dplyr::starwars

#kontynuacja filtrowania wierszy
#filtrowanie z negacja wzrost >200 i masa <100
dplyr::filter(swars, !height>200 & !mass<100)

#Flitrowanie pomiedzy
#Wzrost pomiedzy 80 i 120
dplyr::filter(swars, height > 80 & height < 120)

#to samo ale z haczykiem
dplyr::filter(swars, dplyr::between(height,80,120))

#filtrowanie wartości tekstowych
#kolor postaci brown i white
dplyr::filter(swars, skin_color =="brown")
dplyr::filter(swars, skin_color ==c("brown", "white"))
dplyr::filter(swars, skin_color %in% c("brown", "white"))

#Zdeninuj wektor na początku przez kolory
kolory <- c("brown", "white")
dplyr::filter(swars, skin_color %in% kolory)

#zmiana nazwy i przenoszenie kolumny----
##nagłówek2----
#dplyr::relocate()
#nowy dataset pingwiny
pingwiny <- penguins

#zmiana nazwy
pingwiny <- dplyr::rename(pingwiny, gatunek = species)

# Zmiana więcej niż jednej kolumny, po polsku: wyspa oraz długość dzioba
pingwiny <- dplyr::rename(pingwiny,
wyspa = island,
dlugosc_dzioba = bill_len)

# Zmiana za pomocą funkcji
# dplyr::rename_with()
# Zmiana wszystkich kolumn na pi
pingwiny <- dplyr::rename_with(pingwiny, \(x) toupper(x))

# Zmiana za pomocą funkcji wybrane kolumny
# Zamień gatunek, wyspa i dlugosc_dzioba na pisanie małą literą
# Zmiana na małą - tolower
pingwiny <- dplyr::rename_with(pingwiny, \(x) tolower(x), c(GATUNEK, WYSPA, DLUGOSC_DZIOBA))

# Zmiana za pomocą funkcji, wybrane kolumny
# Wybierz według typu - kolumny numeryczne
# Jeszcze raz tolower()
pingwiny <- dplyr::rename_with(pingwiny, \(x) tolower(x), dplyr::where(\(kolumna) is.numeric(kolumna)))

## Przenoszenie kolumny -----
# dplyr::relocate()
# Przenieś dlugosc dzioba na początek
pingwiny <- dplyr::relocate(pingwiny, dlugosc_dzioba, .before = wyspa)

# Przenieś wszystkie kolumny zawierające w nazwie "e" po kolumnie gatunek
pingwiny <- dplyr::relocate(pingwiny, dplyr::contains("e"), .after = gatunek)

# Nazwy kolumn w pingwinach
nazwy <- colnames(pingwiny)

# Nazwy kolumn alfabetycznie
nazwy_ord <- order(nazwy)

dplyr::select(pingwiny, order(colnames(pingwiny)))
