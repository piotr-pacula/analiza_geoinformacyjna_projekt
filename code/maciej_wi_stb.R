library(sf)
library(areal)
library(dplyr)

dat2020 = st_read("wayne.gpkg", layer = 'wayne_2020')
dat2000 = st_read("wayne.gpkg", layer = 'wayne_2000')
list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

#target units to granice z 2020 roku
target_units <- dat2020[, c("GISJOIN")]

#source units to dane w granicach z 2000 roku
source_units <- dat2000[, c("GISJOIN", list_race, "tot")]
#Uwaga po zapisaniu do GPKG kolumna z geometrią nazywa się geom, a nie geometry. Zatem używając danych wczytanych z pliku gpkg, poniższa linijka powinna mieć zatem postać colnames(source_units) <- c("GJOIN", list_race, "POP", "geom")
colnames(source_units) <- c("GJOIN", list_race, "tot", "geom")

result00_20 <- aw_interpolate(target_units, #granice jednostek docelowych (target_units)
                              tid = GISJOIN, #id jednostek docelowych
                              source = source_units, #dane zrodlowe
                              sid = GJOIN, #id jednostek zrodlowych (source units)
                              weight = "sum", 
                              output = "tibble", #wynik w jako tabela, moze tez być obiekt sf
                              extensive = list_race) #lista zmiennych do przeliczenia

result00_20$tot <- apply(result00_20[, list_race], 1, sum, na.rm = TRUE)

#Obiekt bnd90_20 zawiera granice z 2020 roku z dołączonymi danymi atrybutowymi z 1990 roku przeliczonymi do granic obszarów spisowych z 2020 roku.
bnd00_20 <- merge(dat2020[, c("GISJOIN")], result00_20, by = "GISJOIN")

#zapis
st_write(bnd00_20, "E:/Studia/3 ROK/Analiza Geoinf - dmo/cwiczenie 4/stb/wayne.gpkg", layer = "wayne_stb_2000", append = TRUE)
st_write(dat2020, "E:/Studia/3 ROK/Analiza Geoinf - dmo/cwiczenie 4/stb/wayne.gpkg", layer = "wayne_2020", append = TRUE)


#--------------------------------------KLASYFIKACJA------------------------------------#

bnd00_20 = bnd00_20 %>%
  mutate(race_cls = case_when(
    whites/tot>0.8 ~ "WL",
    blacks/tot>0.8 ~ "BL",
    asians/tot>0.8 ~ "AL",
    latino/tot>0.8 ~ "HL",
    whites/tot>0.5 ~ "WM",
    blacks/tot>0.5 ~ "BM",
    asians/tot>0.5 ~ "AM",
    latino/tot>0.5 ~ "HM",
    TRUE ~ "HD"
  ))
