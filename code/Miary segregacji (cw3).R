library(kableExtra)


#--------------NIEZAGREGOWANE---------------------#
#ENTROPIA

wayne_1990 = blocks[,8:13]

wayne_select2137 = blocks %>% select(list_race)

wayne_select = apply(wayne_select2137, 1, sum)

pi = wayne_select/sum(wayne_select)

entropy_fnc = function(pix){
  entropy = -sum(pix*log(pix), na.rm = TRUE)
  return(entropy)
}
entropy_fnc(pi)

sentropy = function(pix){
  entropy = -sum(pix*log(pix), na.rm = TRUE)
  max_entropy = log(length(pix))
  standard_entropy = entropy/max_entropy
  return(standard_entropy)}

sentropy(pi)

hindex <- function(races) {
  #races_all to liczba osob w calym obszarze w podziale na grupy rasowo-etniczne
  races_all = apply(races, 2, sum, na.rm=TRUE)
  
  #liczba osob w calym obszarze
  pop = sum(races_all, na.rm=TRUE)
  
  #liczba osob w kazdej jednostce spisowej
  pop_i = apply(races, 1, sum, na.rm=TRUE)
  
  #odsetek osob w danej grupy rasowo-etnicznej w kazdej jednostce spisowej
  proportions = races/pop_i
  
  #odsetek osob w danej grupy rasowo-etnicznej w calym obszarze
  proportions_all = races_all/sum(races_all, na.rm = TRUE)
  
  #entropia dla kazdej jednostki spisowej
  ent_i = apply(proportions, 1, entropy_fnc)
  
  #entropia dla calego obszaru
  ent = entropy_fnc(proportions_all) 
  
  #obliczenie H
  hind = sum(pop_i*(ent-ent_i)/(ent*pop), na.rm=TRUE)
  return(hind)
}

hindex(wayne_select2137)


# a - liczba osob grupy 1 w jednostce spisowej, b - liczba osob gruy 2 w jednostce spisowej
d_ind = function(a, b) {
  d = 0.5*sum(abs(a/sum(a, na.rm=TRUE) - b/sum(b, na.rm=TRUE)))
  return(d)
}

d_ind(wayne_select2137$whites, wayne_select2137$blacks)
d_ind(wayne_select2137$whites, wayne_select2137$asians)
d_ind(wayne_select2137$whites, wayne_select2137$latino)
d_ind(wayne_select2137$blacks, wayne_select2137$latino)
d_ind(wayne_select2137$asians, wayne_select2137$latino)
d_ind(wayne_select2137$asians, wayne_select2137$blacks)

#-----------------------ZAGREGOWANE--------------------#

#ENTROPIA

wayne_select_agg2077 = blocks2 %>% select(list_race)

wayne_select_agg = apply(wayne_select_agg2077, 1, sum)

pi_agg = wayne_select_agg/sum(wayne_select_agg)

entropy_fnc = function(pix){
  entropy = -sum(pix*log(pix), na.rm = TRUE)
  return(entropy)
}
entropy_fnc(pi_agg)

sentropy = function(pix){
  entropy = -sum(pix*log(pix), na.rm = TRUE)
  max_entropy = log(length(pix))
  standard_entropy = entropy/max_entropy
  return(standard_entropy)}

sentropy(pi_agg)

hindex <- function(races) {
  #races_all to liczba osob w calym obszarze w podziale na grupy rasowo-etniczne
  races_all = apply(races, 2, sum, na.rm=TRUE)
  
  #liczba osob w calym obszarze
  pop = sum(races_all, na.rm=TRUE)
  
  #liczba osob w kazdej jednostce spisowej
  pop_i = apply(races, 1, sum, na.rm=TRUE)
  
  #odsetek osob w danej grupy rasowo-etnicznej w kazdej jednostce spisowej
  proportions = races/pop_i
  
  #odsetek osob w danej grupy rasowo-etnicznej w calym obszarze
  proportions_all = races_all/sum(races_all, na.rm = TRUE)
  
  #entropia dla kazdej jednostki spisowej
  ent_i = apply(proportions, 1, entropy_fnc)
  
  #entropia dla calego obszaru
  ent = entropy_fnc(proportions_all) 
  
  #obliczenie H
  hind = sum(pop_i*(ent-ent_i)/(ent*pop), na.rm=TRUE)
  return(hind)
}

hindex(wayne_select_agg2077)


# a - liczba osob grupy 1 w jednostce spisowej, b - liczba osob gruy 2 w jednostce spisowej
d_ind = function(a, b) {
  d = 0.5*sum(abs(a/sum(a, na.rm=TRUE) - b/sum(b, na.rm=TRUE)))
  return(d)
}

d_ind(wayne_select_agg2077$whites, wayne_select_agg2077$blacks)
d_ind(wayne_select_agg2077$whites, wayne_select_agg2077$asians)
d_ind(wayne_select_agg2077$whites, wayne_select_agg2077$latino)
d_ind(wayne_select_agg2077$blacks, wayne_select_agg2077$latino)
d_ind(wayne_select_agg2077$asians, wayne_select_agg2077$latino)
d_ind(wayne_select_agg2077$asians, wayne_select_agg2077$blacks)

#--------------------cenSUS_tract--------------------------------#


dat <- read.csv("dane_atrybutowe/wayne_aggr_1990.csv")
dat_block <- read.csv("dane_atrybutowe/wayne_1990.csv")

dat_block$tot <- apply(dat_block[, list_race], 1, sum)

dat_ct <- aggregate(.~GISJOIN_T, dat[, c("GISJOIN_T", list_race, "tot")], FUN=sum) 

#utworzenie ramki danych zawierajacej identyfikator obszaru spisowego (GISJOINT) oraz ogólną liczbę ludności dla każdego obszaru spisowego. 
out_ct <- data.frame(GISJOIN_T = dat_ct$GISJOIN_T, pop = dat_ct$tot)

#obliczenie odsetka ras dla poszczegolnych obszarow spisowych (dane wejsciowe do obliczenia entropii)
perc_ct <- dat_ct[,list_race]/dat_ct$tot


#obliczenie entopii dla każdego obszaru spisowego oraz dodanie jej do obiektu out_ct
out_ct$ent <- apply(perc_ct, 1, entropy_fnc)

#obiekt out_ct zawiera identyfikator obszaru spisowego, liczbę ludności w obszarze spisowym (pop) oraz entropię obszaru spisowego (ent)
out_ct

out_block <- data.frame(GISJOIN = dat_block$GISJOIN, GISJOIN_T = dat_block$GISJOIN_T, pop_i = dat_block$tot)
head(out_block)

#obliczenie odsetka wg ras dla każdego bloku (dane wejsciowe do obliczenia entropii dla bloku)
perc_block <- dat_block[,list_race]/dat_block$tot
perc_block[is.na(perc_block)] <- 0

# obliczenie entropii dla każdego bloku 
out_block$ent_i <- apply(perc_block, 1, entropy_fnc)
head(out_block)

calc_df <- merge(out_ct, out_block, by="GISJOIN_T")
calc_df <- calc_df[, c("GISJOIN_T", "GISJOIN", "pop", "pop_i", "ent", "ent_i")]
head(calc_df)

calc_df$H <- calc_df$pop_i*(calc_df$ent-calc_df$ent_i)/(calc_df$ent*calc_df$pop)

h_index <- aggregate(H~GISJOIN_T, calc_df, FUN = sum)

out_ct <- merge(out_ct, h_index, by = "GISJOIN_T")
colnames(out_ct) <- c("GISJOIN_T", "POP", "E", "H")

#obliczenie entropii standaryzowanej 
out_ct$Estd <- out_ct$E/log(length(list_race))

out <- merge(dat_ct, out_ct[,-2], by="GISJOIN_T")


#-----------------------------KLASYFIKACJA------------------------------------------------#

biv <-  expand.grid(ent = c("L", "M", "H"), h=c("L", "M", "H"))
biv$biv_cls <- paste(biv$ent,biv$h,  sep="")
biv

library(dplyr)
biv$biv_classes <- recode(biv$biv_cls, 
                          "LL" = "low diversity and low segregation", "ML" = " medium diversity diversity and low segregation", 
                          "HL" = "high diversity and low segregation", 
                          "LM" = "low diversity and medium segregation", "MM" = "medium diversity and medium segregation", 
                          "HM" = "high diversity and medium segregation",
                          "LH" = "low diversity and high segregation", "MH" = "medium diversity and high segregation", 
                          "HH" = "high diversity and high segregation")

out$Estd_cls <- cut(out$Estd, breaks = c(0, 0.33, 0.66, 1), labels = c("L", "M", "H"), include.lowest = TRUE, right = TRUE)
out$H_cls <- cut(out$H, breaks = c(0, 0.33, 0.66, 1), labels = c("L", "M", "H"), include.lowest = TRUE, right = TRUE)
out$biv_cls <- paste(out$Estd_cls, out$H_cls, sep="")

library(sf)

bnd <- st_read("dane_atrybutowe/wayne_1990.gpkg")

plot(bnd[1:3])

bnd_attr <- merge(bnd, out, by.x = "GISJOIN", by.y = "GISJOIN_T")
plot(bnd_attr["H"])

library(pals)

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

par(mfrow = c(3, 4), mar = c(1, 1, 2, 1))
bivcol(arc.bluepink)
bivcol(brewer.divdiv)
bivcol(brewer.divseq)
bivcol(brewer.qualseq)
bivcol(brewer.seqseq1)
bivcol(brewer.seqseq2)
bivcol(census.blueyellow)
bivcol(stevens.bluered)
bivcol(stevens.greenblue)
bivcol(stevens.pinkblue)
bivcol(stevens.pinkgreen)
bivcol(stevens.purplegold)

bivcol(stevens.bluered)
stevens.bluered()

#legenda 
biv_colors = stevens.bluered()
names(biv_colors) = c("LL", "ML", "HL", "LM", "MM", "HM", "LH", "MH", "HH")

library(ggplot2)

ggplot(bnd_attr) + 
  geom_sf(aes(fill = biv_cls)) + 
  scale_fill_manual(values = biv_colors) + 
  theme_bw()

st_write(bnd_attr, "bnd_attr.gpkg", delete_dsn=TRUE, quiet=TRUE)