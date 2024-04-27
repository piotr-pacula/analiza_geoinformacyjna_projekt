library(dplyr)
library(sf)
library(ggplot2)
library(patchwork)
library(pals)

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

wayne_idx_1990 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_1990')
wayne_idx_2000 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2000')
wayne_idx_2010 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2010')
wayne_idx_2020 = st_read("dane/wayne.gpkg", layer = 'wayne_idx_2020')

unique_cls = unique(c(unique(wayne_idx_1990$biv_cls),unique(wayne_idx_2000$biv_cls),unique(wayne_idx_2010$biv_cls),unique(wayne_idx_2020$biv_cls)))

biv_colors = stevens.bluered()
names(biv_colors) = c("LL", "ML", "HL", "LM", "MM", "HM", "LH", "MH", "HH")
biv_colors = biv_colors[names(biv_colors) %in% unique_cls]

p1 <- ggplot(data = wayne_idx_1990) +
  geom_sf(aes(fill = biv_cls)) +
  scale_fill_manual(values = biv_colors, drop = FALSE, limits = names(biv_colors)) +
  labs(title = "1990", fill = "Struktura rasowo-etniczna") +
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank())


p2 <- ggplot(data = wayne_idx_2000) +
  geom_sf(aes(fill = biv_cls)) +
  scale_fill_manual(values = biv_colors, drop = FALSE, limits = names(biv_colors)) +
  labs(title = "2000", fill = "Struktura rasowo-etniczna") +
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p3 <- ggplot(data = wayne_idx_2010) +
  geom_sf(aes(fill = biv_cls)) +
  scale_fill_manual(values = biv_colors,drop = FALSE, limits = names(biv_colors)) +
  labs(title = "2010", fill = "Struktura rasowo-etniczna") +
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p4 <- ggplot(data = wayne_idx_2020) +
  geom_sf(aes(fill = biv_cls)) +
  scale_fill_manual(values = biv_colors, drop = FALSE, limits = names(biv_colors)) +
  labs(title = "2020", fill = "Struktura rasowo-etniczna") +
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

combined <- p1 + p2 + p3 + p4 + plot_layout(guides = "collect") & theme(legend.position = "right")

combined
