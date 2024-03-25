library(dplyr)
library(sf)
library(ggplot2)
library(patchwork)

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

wayne_stb_2010 = st_read("dane/wayne.gpkg", layer = 'wayne_stb_2010')
wayne_stb_2020 = st_read("dane/wayne.gpkg", layer = 'wayne_stb_2020')

cls_df = data.frame(GISJOIN = wayne_stb_2010$GISJOIN,
                    cls2010 = wayne_stb_2010$race_cls,
                    cls2020 = wayne_stb_2020$race_cls)

st_geometry(cls_df)<-wayne_stb_2020$geom

table(cls_df$cls2010)
table(cls_df$cls2020)

tab2010 <- prop.table(table(cls_df$cls2010))*100
round(tab2010, 1)

tab2020 <- prop.table(table(cls_df$cls2020))*100
round(tab2020, 1)

tab <- table(cls_df$cls2010, cls_df$cls2020)
tab

rowSums(tab)
colSums(tab)

round(prop.table(table(cls_df$cls2010, cls_df$cls2020))*100, 1)

plot(cls_df["cls2010"])
plot(cls_df["cls2020"])


cls_color <- c("AL"= "#CD5555", "AM"= "#FF6A6A", "BL"= "#006400", "BM"= "#32CD32", "HD"= "#8F8F8F", "HL"= "#5D478B", "HM"= "#9370DB", "WL"= "#FF8C00", "WM"= "#FFD700")

col2010 <- cls_color[names(cls_color)%in%unique(cls_df$cls2010)]
col2020 <- cls_color[names(cls_color)%in%unique(cls_df$cls2020)]


p1 <- ggplot(data = cls_df) +
  geom_sf(aes(fill = cls2010)) +
  scale_fill_manual(values = col2010) + 
  labs(title = "District of Wayne, 2010") + 
  theme_bw() +
  theme(legend.position="bottom")

p2 <- ggplot(data = cls_df) +
  geom_sf(aes(fill = cls2020)) +
  scale_fill_manual(values = col2020) + 
  labs(title = "District of Wayne, 2020") + 
  theme_bw() +
  theme(legend.position="bottom")


#wyswietlenie wykresow obok siebie
p1 + p2


# st_write(cls_df, "dane\\wayne.gpkg", layer = "wayne_2010_2020", append = TRUE)
