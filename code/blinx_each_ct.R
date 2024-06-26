## Wczytanie pakietow
library(kableExtra)
library(dplyr)
library(sf)
library(pals)
library(ggplot2)

## Wczytanie danych
wayne_aggr =  read.csv('dane\\wayne_aggr_2020.csv')
wayne = read.csv('dane\\wayne_2020.csv')
list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")
bnd <- st_read("dane\\wayne.gpkg", layer = "wayne_2020")

wayne$tot = wayne$whites + wayne$blacks + wayne$asians + wayne$native_americans + wayne$others + wayne$latino

## Wczytanie funkcji
entropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  return(entropy)}

bivcol = function(pal){
  tit = substitute(pal)
  pal = pal()
  ncol = length(pal)
  image(matrix(seq_along(pal), nrow = sqrt(ncol)),
        axes = FALSE, 
        col = pal, 
        asp = 1)
  mtext(tit)
}


#utworzenie ramki danych zawierajacej identyfikator obszaru spisowego (GISJOINT) oraz ogólną liczbę ludności dla każdego obszaru spisowego. 
out_ct <- data.frame(GISJOIN_T = wayne_aggr$GISJOIN_T, pop = wayne_aggr$tot)

#obliczenie odsetka ras dla poszczegolnych obszarow spisowych (dane wejsciowe do obliczenia entropii)
perc_ct <- wayne_aggr[,list_race]/wayne_aggr$tot

#obliczenie entopii dla każdego obszaru spisowego oraz dodanie jej do obiektu out_ct
out_ct$ent <- apply(perc_ct, 1, entropy)

out_block <- data.frame(GISJOIN = wayne$GISJOIN, GISJOIN_T = wayne$GISJOIN_T, pop_i = wayne$tot)

#obliczenie odsetka wg ras dla każdego bloku (dane wejsciowe do obliczenia entropii dla bloku)
perc_block <- wayne[,list_race]/wayne$tot
perc_block[is.na(perc_block)] <- 0

# obliczenie entropii dla każdego bloku 
out_block$ent_i <- apply(perc_block, 1, entropy)

calc_df <- merge(out_ct, out_block, by="GISJOIN_T")
calc_df <- calc_df[, c("GISJOIN_T", "GISJOIN", "pop", "pop_i", "ent", "ent_i")]

calc_df$H <- calc_df$pop_i*(calc_df$ent-calc_df$ent_i)/(calc_df$ent*calc_df$pop)

h_index <- aggregate(H~GISJOIN_T, calc_df, sum)

out_ct <- merge(out_ct, h_index, by = "GISJOIN_T")
colnames(out_ct) <- c("GISJOIN_T", "tot", "E", "H")

#obliczenie entropii standaryzowanej 
out_ct$Estd <- out_ct$E/log(length(list_race))

out <- merge(wayne_aggr, out_ct[,-2], by="GISJOIN_T")

biv <-  expand.grid(ent = c("L", "M", "H"), h=c("L", "M", "H"))
biv$biv_cls <- paste(biv$ent,biv$h,  sep="")

out$Estd_cls <- cut(out$Estd, breaks = c(0, 0.33, 0.66, 1), labels = c("L", "M", "H"), include.lowest = TRUE, right = TRUE)
out$H_cls <- cut(out$H, breaks = c(0, 0.33, 0.66, 1), labels = c("L", "M", "H"), include.lowest = TRUE, right = TRUE)
out$biv_cls <- paste(out$Estd_cls, out$H_cls, sep="")

## Zapisanie wyniku

write.csv(out,"dane\\wayne_aggr_idx_2020.csv")

## Polaczenie wyliczonych danych z danymi przestrzennymi

bnd_attr <- merge(select(bnd,-any_of(c(list_race,'tot'))), out, by.x = "GISJOIN", by.y = "GISJOIN_T")

## Wizualizacja wkaznikow na mapach

# plot(bnd_attr["H"])
# 
# #legenda 
# biv_colors = stevens.bluered()
# names(biv_colors) = c("LL", "ML", "HL", "LM", "MM", "HM", "LH", "MH", "HH")
# 
# ggplot(bnd_attr) + 
#   geom_sf(aes(fill = biv_cls)) + 
#   scale_fill_manual(values = biv_colors) + 
#   theme_bw()

## Zapisanie do geopackage

st_write(bnd_attr, "dane\\wayne.gpkg",layer = "wayne_idx_2020", quiet=TRUE)
