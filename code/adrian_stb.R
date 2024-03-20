library(sf)
library(areal)
library(dplyr)

dat2020 = st_read("wayne.gpkg", layer = 'wayne_2020')
dat1990 = st_read("wayne.gpkg", layer = 'wayne_1990')
list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

#target units to granice z 2020 roku
target_units <- dat2020[, c("GISJOIN")]

#source units to dane w granicach z 1990 roku
source_units <- dat1990[, c("GISJOIN", list_race, "tot")]
#Uwaga po zapisaniu do GPKG kolumna z geometrią nazywa się geom, a nie geometry. Zatem używając danych wczytanych z pliku gpkg, poniższa linijka powinna mieć zatem postać colnames(source_units) <- c("GJOIN", list_race, "POP", "geom")
colnames(source_units) <- c("GJOIN", list_race, "tot", "geom")

result90_20 <- aw_interpolate(target_units, #granice jednostek docelowych (target_units)
                              tid = GISJOIN, #id jednostek docelowych
                              source = source_units, #dane zrodlowe
                              sid = GJOIN, #id jednostek zrodlowych (source units)
                              weight = "sum", 
                              output = "tibble", #wynik w jako tabela, moze tez być obiekt sf
                              extensive = list_race) #lista zmiennych do przeliczenia

result90_20$tot <- apply(result90_20[, list_race], 1, sum, na.rm = TRUE)

#Obiekt bnd90_20 zawiera granice z 2020 roku z dołączonymi danymi atrybutowymi z 1990 roku przeliczonymi do granic obszarów spisowych z 2020 roku.
bnd90_20 <- merge(dat2020[, c("GISJOIN")], result90_20, by = "GISJOIN")

#zapis
st_write(bnd90_20, "E:/Studia/3 ROK/Analiza Geoinf - dmo/cwiczenie 4/stb/wayne.gpkg", layer = "wayne_stb_1990", append = TRUE)
st_write(dat2020, "E:/Studia/3 ROK/Analiza Geoinf - dmo/cwiczenie 4/stb/wayne.gpkg", layer = "wayne_2020", append = TRUE)


#--------------------------------------KLASYFIKACJA------------------------------------#

bnd90_20 = bnd90_20 %>%
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


#--------------------Analiza zmian typów struktury rasowo-etnicznej ludności.-----------------------#

dat2020_cls = dat2020 %>%
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


cls_df = data.frame(GISJOIN = bnd90_20$GISJOIN,
                   cls90 = bnd90_20$race_cls,
                   cls00 = bnd00_20$race_cls)

st_geometry(cls_df) = dat2020_cls$geom

st_write(cls_df, "E:/Studia/3 ROK/Analiza Geoinf - dmo/cwiczenie 4/stb/wayne1.gpkg", layer = "cls90_00", append = TRUE)

table(cls_df$cls90)

tab90 <- prop.table(table(cls_df$cls90))*100
round(tab90, 1)

(table(cls_df$cls90)/sum(table(cls_df$cls90)))*100

table(cls_df$cls00)

tab00 <- prop.table(table(cls_df$cls00))*100
round(tab00, 1)

tab <- table(cls_df$cls90, cls_df$cls00)
tab

rowSums(tab)
colSums(tab)

round(prop.table(table(cls_df$cls90, cls_df$cls00))*100, 1)

plot(cls_df["cls90"])
plot(cls_df["cls00"])

cls_color <- c("AL"= "#CD5555", "AM"= "#FF6A6A", "BL"= "#006400", "BM"= "#32CD32", "HD"= "#8F8F8F", "HL"= "#5D478B", "HM"= "#9370DB", "WL"= "#FF8C00", "WM"= "#FFD700")

col90 <- cls_color[names(cls_color)%in%unique(cls_df$cls90)]
col00 <- cls_color[names(cls_color)%in%unique(cls_df$cls00)]

library(ggplot2)
library(patchwork)
p1 <- ggplot(data = cls_df) +
  geom_sf(aes(fill = cls90)) +
  scale_fill_manual(values = col90) + 
  labs(title = "District of Wayne, 1990") + 
  theme_bw() +
  theme(legend.position="bottom")

p2 <- ggplot(data = cls_df) +
  geom_sf(aes(fill = cls00)) +
  scale_fill_manual(values = col00) + 
  labs(title = "District of Wayne, 2000") + 
  theme_bw() +
  theme(legend.position="bottom")


#wyswietlenie wykresow obok siebie
p1 + p2
