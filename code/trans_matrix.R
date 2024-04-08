library(sf)
library(dplyr)

# Wczytanie danych dla roku 1990 i 2020
wayne_1990 <- st_read("dane/wayne.gpkg", layer = "wayne_stb_1990")
wayne_2020 <- st_read("dane/wayne.gpkg", layer = "wayne_stb_2020")


wayne_1990 = st_drop_geometry(wayne_1990)
wayne_1990 = select(wayne_1990, 1,'race_cls')
wayne_1990 = rename(wayne_1990, race_cls_1990 = race_cls) 

wayne_2020 = st_drop_geometry(wayne_2020)
wayne_2020 = select(wayne_2020, 1,'race_cls')
wayne_2020 = rename(wayne_2020, race_cls_2020 = race_cls) 

wayne_1990_2020 = merge(wayne_1990, wayne_2020, by = "GISJOIN")

# table(wayne_1990_2020$race_cls_1990)

# table(wayne_1990_2020$race_cls_2020)

trans_matrix = table(wayne_1990_2020$race_cls_1990, wayne_1990_2020$race_cls_2020)

# write.csv(trans_matrix, "dane\\transition_matrix.csv")


  