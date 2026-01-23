# Pakiet tidyverse zawiera m.in. dplyr, readr i tidyr
# Pakiet readxl umożliwia wczytywanie plików Excel
library(tidyverse)
library(readxl)

# Celem skryptu jest identyfikacja minimalnych i maksymalnych stężeń
# żelaza i manganu w czwartorzędowych wodach podziemnych w Gdańsku,
# porównanie wyników dla lat 2023 i 2024 oraz zestawienie ich
# z dopuszczalnymi wartościami określonymi w "Rozporządzeniu Ministra Zdrowia 
# z dnia 7 grudnia 2017 r. w sprawie jakości wody przeznaczonej do spożycia przez ludzi"

# Wczytanie danych z pliku Excel
dane_2023 <- read_excel("2023_-_Wyniki_badań_wskaźników_fizykochemicznych_monitoringu_jakości_wód_podziemnych_-_monitoring_operacyjny.xlsx")

dane_2024 <- read_excel("2024_-_Wyniki_badań_wskaźników_fizykochemicznych_monitoringu_jakości_wód_podziemnych_-_monitoring_operacyjny_A9aCLHe.xlsx")

# Ujednolicenie nazw kolumn w zbiorach danych
# (uproszczenie nazw oraz usunięcie polskich znaków)
dane_2023 <- dplyr::rename(dane_2023,
Punkt_pomiarowy = `Numer punktu pomiarowego wg ID Monitoring`,
Miejscowosc = Miejscowość,
Rok = `Rok badań`,
Zelazo = `Żelazo [mgFe/l]`,
Mangan = `Mangan [mgMn/l]`)

dane_2024 <- dplyr::rename(dane_2024,
Punkt_pomiarowy = `Numer punktu pomiarowego wg ID Monitoring`,
Miejscowosc = Miejscowość,
Rok = `Rok badań`,
Zelazo = `Żelazo [mgFe/l]`,
Mangan = `Mangan [mgMn/l]`)

# Wybór tylko tych kolumn, które są niezbędne do dalszej analizy
dane_Gdansk_2023 <- dplyr::select(dane_2023, 
Punkt_pomiarowy,
Miejscowosc,
Stratygrafia,
Rok,
Zelazo,
Mangan)

dane_Gdansk_2024 <- dplyr::select(dane_2024, 
Punkt_pomiarowy,
Miejscowosc,
Stratygrafia,
Rok,
Zelazo,
Mangan)

# Odfiltrowanie danych wyłącznie dla:
# - miejscowości Gdańsk
# - utworów czwartorzędowych (Q)
dane_Gdansk_2023 <- dplyr::filter(dane_Gdansk_2023,
Miejscowosc == "Gdańsk",
Stratygrafia == "Q")

dane_Gdansk_2024 <- dplyr::filter(dane_Gdansk_2024,
Miejscowosc == "Gdańsk",
Stratygrafia == "Q")

# Dodanie pomocnicznej kolumny porządkowej (liczba porządkowa wiersza)
dane_Gdansk_2023 <- dplyr::mutate(dane_Gdansk_2023, L.p. = row_number())
dane_Gdansk_2024 <- dplyr::mutate(dane_Gdansk_2024, L.p. = row_number())

# Przeniesienie kolumny porządkowej na pierwszą pozycję
dane_Gdansk_2023 <- dplyr::select(dane_Gdansk_2023, L.p., everything())
dane_Gdansk_2024 <- dplyr::select(dane_Gdansk_2024, L.p., everything())

# Połączenie danych z lat 2023 i 2024 na podstawie kolumny porządkowej
dane_Gdansk_2023_2024 <- dplyr::left_join(dane_Gdansk_2023, dane_Gdansk_2024, by = dplyr::join_by(L.p.))

# Wybór oraz czytelne nazwanie kolumn pochodzących z obu lat
dane_Gdansk_2023_2024 <- dplyr::select(dane_Gdansk_2023_2024,
Punkt_pomiarowy = Punkt_pomiarowy.x,
Zelazo_2023 = Zelazo.x,
Mangan_2023 = Mangan.x,
Zelazo_2024 = Zelazo.y,
Mangan_2024 = Mangan.y)

# Obliczenie minimalnych i maksymalnych stężeń żelaza i manganu
# osobno dla lat 2023 i 2024
dane_Gdansk_2023_2024_wynik <- dplyr::summarise(dane_Gdansk_2023_2024,
min_Zelazo_2023 = min(Zelazo_2023, na.rm = TRUE),
maks_Zelazo_2023 = max(Zelazo_2023, na.rm = TRUE),
min_Mangan_2023 = min(Mangan_2023, na.rm = TRUE),
maks_Mangan_2023 = max(Mangan_2023, na.rm = TRUE),
min_Zelazo_2024 = min(Zelazo_2024, na.rm = TRUE),
maks_Zelazo_2024 = max(Zelazo_2024, na.rm = TRUE),
min_Mangan_2024 = min(Mangan_2024, na.rm = TRUE),
maks_Mangan_2024 = max(Mangan_2024, na.rm = TRUE))

# Wyniki z porównaniem do norm w [mg/L]
dane_Gdansk_2023_2024_Dz.U.2017poz.2294 <- mutate(dane_Gdansk_2023_2024_wynik,
min_Zelazo_2023 = paste(min_Zelazo_2023, "| 0.2"),
maks_Zelazo_2023 = paste(maks_Zelazo_2023, "| 0.2"),
min_Mangan_2023 = paste(min_Mangan_2023, "| 0.05"),
maks_Mangan_2023 = paste(maks_Mangan_2023, "| 0.05"),
min_Zelazo_2024 = paste(min_Zelazo_2024, "| 0.2"),
maks_Zelazo_2024 = paste(maks_Zelazo_2024, "| 0.2"),
min_Mangan_2024 = paste(min_Mangan_2024, "| 0.05"),
maks_Mangan_2024 = paste(maks_Mangan_2024, "| 0.05"))