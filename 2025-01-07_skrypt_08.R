# Paczki
library(dplyr)
# Wczytywanie danych z excela
library(readxl)

# Ścieżka do pliku
plik <- "dane/data_msu.xlsx"

# Nazwy arkuszy w pliku excel
readxl::excel_sheets("dane/data_msu.xlsx")

readxl::excel_sheets(plik)

# Wczytanie danych z 3 arkuszy
data_loi <- readxl::read_excel(plik, sheet = "loi")
data_elem <- readxl::read_excel(plik, sheet = "elemental")
data_bsi <- readxl::read_excel(plik, sheet = "bsi")

# Dołącz dane elementarne do loi
dane_01 <- dplyr::left_join(data_loi, data_elem)

# Dołącz dane bsi do loi
dane_02 <- dplyr::left_join(data_loi, data_bsi)
# To dało półąćzenie wg dwóch kolumn - niekoniecznie właściwie

# Dołącz dane bsi do loi z kontrolą
dane_03 <- dplyr::left_join(data_loi, data_bsi, by = dplyr::join_by(sample_id))

# Zmień nazwę kolumny sample_id w ramce data_elem na  probka_id
data_elem <- dplyr::rename(data_elem, probka_id = sample_id)

# Połącz ramki danych data_bsi oraz data_elem na podstawie sample_id oraz probka_id
dplyr::left_join(data_elem, data_bsi, by = dplyr::join_by(probka_id == sample_id))

# Inner join - "restrykcyjne" łączenie, tylko część wspólna obecna w x i y
# data_bsi i data_loi
dane_04 <- dplyr::inner_join(data_bsi, data_loi, by = dplyr::join_by(sample_id))

# Full join - łączenie wszystkiego jak leci po kluczu
# data bsi data_elem
# potem do wyniku dołącz data_loi
dane_05 <- dplyr::full_join(data_bsi, data_elem, by = dplyr::join_by(sample_id == probka_id))
dane_05 <- dplyr::full_join(dane_05, data_loi, by = dplyr::join_by(sample_id))

# Łączenie filtrujące
# Semi join - zachowaj wiersze w X tam gdzie pasujące wiersze w Y
dane_06 <- dplyr::semi_join(data_bsi, data_loi, join_by(sample_id))

# Łączenie filtrujące
# Anti join - zachowanie wierszy X, które nie mają odpowiednika w Y
dane_07 <- dplyr::anti_join(data_elem, data_bsi, by = dplyr::join_by(probka_id == sample_id))