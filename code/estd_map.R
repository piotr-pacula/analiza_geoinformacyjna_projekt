library(dplyr)
library(sf)
library(ggplot2)
library(patchwork)

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

wayne_idx_1990 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_1990')
wayne_idx_2000 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2000')
wayne_idx_2010 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2010')
wayne_idx_2020 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2020')

# plot(wayne_idx_1990["Estd_cls"])
# plot(wayne_idx_2000["Estd_cls"])

cls_color <- c("L"= "#008000", "M"= "#FFFF00", "H"= "#FF0000")

colpal <- cls_color[names(cls_color)%in%unique(wayne_idx_1990$Estd_cls)]

wayne_idx_1990$Estd_cls <- factor(wayne_idx_1990$Estd_cls, levels = c("H", "M", "L"))
wayne_idx_2000$Estd_cls <- factor(wayne_idx_2000$Estd_cls, levels = c("H", "M", "L"))
wayne_idx_2010$Estd_cls <- factor(wayne_idx_2010$Estd_cls, levels = c("H", "M", "L"))
wayne_idx_2020$Estd_cls <- factor(wayne_idx_2020$Estd_cls, levels = c("H", "M", "L"))

p1 <- ggplot(data = wayne_idx_1990) +
  geom_sf(aes(fill = Estd_cls)) +
  scale_fill_manual(values = colpal) + 
  labs(title = "1990", fill = "Entropia zestandaryzowana") + 
  theme_bw() + theme(
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  panel.grid = element_blank())

p2 <- ggplot(data = wayne_idx_2000) +
  geom_sf(aes(fill = Estd_cls)) +
  scale_fill_manual(values = colpal) + 
  labs(title = "2000", fill = "Entropia zestandaryzowana") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p3 <- ggplot(data = wayne_idx_2010) +
  geom_sf(aes(fill = Estd_cls)) +
  scale_fill_manual(values = colpal) + 
  labs(title = "2010", fill = "Entropia zestandaryzowana") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p4 <- ggplot(data = wayne_idx_2020) +
  geom_sf(aes(fill = Estd_cls)) +
  scale_fill_manual(values = colpal) + 
  labs(title = "2020", fill = "Entropia zestandaryzowana") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

combined <- p1 + p2 + p3 + p4 + plot_layout(guides = "collect") & theme(legend.position = "right")

combined



