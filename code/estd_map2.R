library(dplyr)
library(sf)
library(ggplot2)
library(patchwork)

wayne_idx_1990 <- st_read("dane/wayne.gpkg", layer = 'wayne_idx_1990')
wayne_idx_2000 <- st_read("dane/wayne.gpkg", layer = 'wayne_idx_2000')
wayne_idx_2010 <- st_read("dane/wayne.gpkg", layer = 'wayne_idx_2010')
wayne_idx_2020 <- st_read("dane/wayne.gpkg", layer = 'wayne_idx_2020')

p1 <- ggplot(data = wayne_idx_1990) +
  geom_sf(aes(fill = Estd)) +
  scale_fill_gradient2(name = "Entropia Zestandaryzowana", low = "darkgreen",mid = "yellow", high = "red",midpoint = 0.5 ,limits = c(0, 1)) +  # Set legend title
  labs(title = "1990") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p2 <- ggplot(data = wayne_idx_2000) +
  geom_sf(aes(fill = Estd)) +
  scale_fill_gradient2(name = "Entropia Zestandaryzowana", low = "darkgreen",mid = "yellow", high = "red",midpoint = 0.5 ,limits = c(0, 1)) +  # Consistent legend title
  labs(title = "2000") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p3 <- ggplot(data = wayne_idx_2010) +
  geom_sf(aes(fill = Estd)) +
  scale_fill_gradient2(name = "Entropia Zestandaryzowana", low = "darkgreen",mid = "yellow", high = "red",midpoint = 0.5 ,limits = c(0, 1)) +  # Consistent legend title
  labs(title = "2010") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

p4 <- ggplot(data = wayne_idx_2020) +
  geom_sf(aes(fill = Estd)) +
  scale_fill_gradient2(name = "Entropia Zestandaryzowana", low = "darkgreen",mid = "yellow", high = "red",midpoint = 0.5 ,limits = c(0, 1)) +  # Consistent legend title
  labs(title = "2020") + 
  theme_bw() + theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  )

combined <- p1 + p2 + p3 + p4 + plot_layout(guides = "collect") & theme(legend.position = "right")

# Print the combined plot
print(combined)
