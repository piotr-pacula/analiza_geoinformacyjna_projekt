library(sf)
library(dplyr)
library(tidyverse)
library(fasterize)
library(kableExtra)

cls_df <- st_read("cwiczenie 5/wayne.gpkg", layer = "wayne_stb_1990")

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

cls_df$cls90 = recode(cls_df$race_cls, "WL"= 1, "WM" = 2, "BL" = 3, "BM" = 4, "AL" = 5, "AM" = 6, "HL" = 7, "HM" = 8, "HD" = 9)

rast <- raster(cls_df, res = 100)
rast

cls = fasterize(cls_df, rast, field = "cls90", fun="sum")

cls_color <- c("#FF8C00", "#FFD700", "#006400", "#32CD32", "#CD5555", "#FF6A6A", "#5D478B", "#9370DB", "#8F8F8F")

plot(cls, col = cls_color)

#------------------METRYKI------------------------------#

library(landscapemetrics)

class_metr = list_lsm(level = "class")

lm = calculate_lsm(cls, level = ("class"), what = c("lsm_c_np", "lsm_c_lpi",  "lsm_c_pland", "lsm_c_ai"))

lm_df = pivot_wider(lm[, c("class", "metric", "value")], names_from = metric, values_from = value)

lm_df

cls_code = data.frame(cls = c("WL", "WM", "BL", "BM", "AL", "AM", "HL", "HM", "HD"), class = 1:9)
results = merge(cls_code, lm_df, by = "class", all.x = TRUE)


write.csv(results, "cwiczenie 5/landscape_metrics_1990.csv", row.names = FALSE)


np = lsm_l_np(cls)
np

lpi = lsm_l_lpi(cls)
lpi

plot(cls, col = cls_color, main = "1990")

results %>%
  kbl() %>%
  kable_classic_2(full_width = F) %>%
  column_spec(1, background = cls_color)
