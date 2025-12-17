# Paczki ------
library(tidyverse)

# Dane
ptaki <- penguins

# Podsumowania
# dplyr::summarise()

# Policz średnią długość dzioba (bill_len) dla gatunku Chinstrap

mean(ptaki[ptaki$species == "Chinstrap", "bill_len"], na.rm = TRUE)

# Policz średnią długość dzioba dla każdego gatunku

c(mean(ptaki[ptaki$species == "Chinstrap", "bill_len"], na.rm = TRUE),
mean(ptaki[ptaki$species == "Gentoo", "bill_len"], na.rm = TRUE),
mean(ptaki[ptaki$species == "Adelie", "bill_len"], na.rm = TRUE))

# Policz średnią masę (body_mass) dla samic (sex) na wyspie (island) Torgersen
mean(ptaki[ptaki$sex == "female" & ptaki$island == "Torgersen", "body_mass"], na.rm = TRUE)

# Podsumowanie z summarise ()
# Policz średnią długość dzioba (bill_len) w podziale na gatunki
dplyr::summarise(ptaki, bill_len_mean = mean(bill_len, na.rm = TRUE), .by = species)

# Policz średnią długość dzioba (bill_len) w podziale na gatunki i wyspy
dplyr::summarise(ptaki, bill_len_m = mean(bill_len, na.rm = TRUE), .by = c(species, island))

# Bez grupowania
dplyr::summarise(ptaki, bill_len_m = mean(bill_len, na.rm = TRUE))

# Ile jest "wystąpień" czyli liczba N
# Oraz ile jest unikatowych N
dplyr::summarise(ptaki, liczba = dplyr::n(), unikalne_wyspy = dplyr::n_distinct(island), .by = species)

# Policz średnią długość płetwy (filpper_len), medianę i kwantyl 0.5
dplyr::summarise(ptaki, flipper_len_mean = mean(flipper_len, na.rm = TRUE), 
flipper_len_median = median(flipper_len, na.rm = TRUE), 
flipper_len_quantile = quantile(flipper_len, 0.5, na.rm = TRUE), .by = sex)

# Policz średnią bill_dep, bill_len, flipper_len w podziale na rok
# Przyda się dplyr::across()

dplyr::summarise(ptaki, dplyr::across(c(bill_dep, bill_len, flipper_len), \ (kolumna) mean(kolumna, na.rm = TRUE)), .by = year)

# Policz średnią i medianę dla kilku kolumn
dplyr::summarise(ptaki, dplyr::across(starts_with("bill"), 
list(
    mean = \(x) mean(x, na.rm = TRUE), 
    median = \(x) median(x, na.rm = TRUE))))
