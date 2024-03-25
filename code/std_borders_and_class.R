library(sf)
library(areal)
library(dplyr)

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

dat90 = st_read("dane/wayne.gpkg", layer = 'wayne_1990')
dat20 = st_read("dane/wayne.gpkg", layer = 'wayne_2020')

## Standaryzacja granic do tych z roku 2020

#target units to granice z 2020 roku
target_units <- dat20[, c("GISJOIN")]

#source units to dane w granicach z 1990 roku
source_units <- dat90[, c("GISJOIN", list_race, "tot")]
#Uwaga po zapisaniu do GPKG kolumna z geometrią nazywa się geom, a nie geometry. Zatem używając danych wczytanych z pliku gpkg, poniższa linijka powinna mieć zatem postać colnames(source_units) <- c("GJOIN", list_race, "POP", "geom")
colnames(source_units) <- c("GJOIN", list_race, "tot", "geom")


result90_20 <- aw_interpolate(target_units, #granice jednostek docelowych (target_units)
                              tid = GISJOIN, #id jednostek docelowych
                              source = source_units, #dane zrodlowe
                              sid = GJOIN, #id jednostek zrodlowych (source units)
                              weight = "sum", 
                              output = "tibble", #wynik w jako tabela, moze tez być obiekt sf
                              extensive = list_race) #lista zmiennych do przeliczenia

result90_20$tot = apply(result90_20[,list_race], 1, sum, na.rm=TRUE)

bnd90_20 <- merge(dat20[, c("GISJOIN")], result90_20, by = "GISJOIN")

## Klasyfikacja zroznicowania rasowego

bnd90_20 <- bnd90_20 %>%
  mutate(race_cls = case_when(
    whites/tot > 0.8 ~ "WL",
    blacks/tot > 0.8 ~ "BL",
    asians/tot > 0.8 ~ "AL",
    latino/tot > 0.8 ~ "HL",
    whites/tot > 0.5 ~ "WM",
    blacks/tot > 0.5 ~ "BM",
    asians/tot > 0.5 ~ "AM",
    latino/tot > 0.5 ~ "HM",
    TRUE ~ "HD"
  ))

# st_write(bnd90_20, "dane\\wayne.gpkg", layer = "wayne_stb_1990", append = TRUE)

