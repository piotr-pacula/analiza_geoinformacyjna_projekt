## Wczytanie potrzebnych pakietow
library(kableExtra)
library(dplyr)

## Wczytanie  i wstepne przygotowanie danych

#dane dla blokow
wayne = read.csv('dane\\wayne_2010.csv')
#dane zagregowane do census tract
wayne_aggr =  read.csv('dane\\wayne_aggr_2010.csv')
list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")
# Selekcja tylko kolumn z liczba ludniosci dla ras
wayne_select <- wayne %>% select(list_race)
wayne_aggr_select <- wayne_aggr %>% select(list_race)

## Wczytanie funkcji

entropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  return(entropy)}

sentropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  max_entropy = log(length(pi))
  standard_entropy = entropy/max_entropy
  return(standard_entropy)}

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
  ent_i = apply(proportions, 1, entropy)
  
  #entropia dla calego obszaru
  ent = entropy(proportions_all) 
  
  #obliczenie H
  hind = sum(pop_i*(ent-ent_i)/(ent*pop), na.rm=TRUE)
  return(hind)
}

segregation = function(race1,race2){
  1/2 * sum(abs(race1/sum(race1,na.rm = TRUE)-race2/sum(race2,na.rm = TRUE)))}

## Wyliczenie wskaznikow na podstawie blokow

# entropia
# calkowita populacja dla kazdej grupy etnicznej
total = apply(wayne_select, 1, sum)

# Udzial grup etnicznych
pi = total/sum(total)

bl_entropy_value = entropy(pi)

# entropia zestandaryzowana

bl_sentropy_value = sentropy(pi)

# Wskaznik H

bl_hindex_value = hindex(wayne_select)

# Dindex

bl_wb = segregation(wayne_select[,'whites'],wayne_select[,'blacks'])
bl_wa = segregation(wayne_select[,'whites'],wayne_select[,'asians'])
bl_wl = segregation(wayne_select[,'whites'],wayne_select[,'latino'])
bl_bl = segregation(wayne_select[,'blacks'],wayne_select[,'latino'])
bl_al = segregation(wayne_select[,'asians'],wayne_select[,'latino'])
bl_ab = segregation(wayne_select[,'asians'],wayne_select[,'blacks'])

## wyliczenie wskaznikow na podstawie census tract

# entropia
# calkowita populacja dla kazdej grupy etnicznej
total = apply(wayne_aggr_select, 1, sum)

# Udzial grup etnicznych
pi = total/sum(total)

ct_entropy_value = entropy(pi)

# entropia zestandaryzowana

ct_sentropy_value = sentropy(pi)

# Wskaznik H

ct_hindex_value = hindex(wayne_aggr_select)

# D

ct_wb = segregation(wayne_aggr_select[,'whites'],wayne_aggr_select[,'blacks'])
ct_wa = segregation(wayne_aggr_select[,'whites'],wayne_aggr_select[,'asians'])
ct_wl = segregation(wayne_aggr_select[,'whites'],wayne_aggr_select[,'latino'])
ct_bl = segregation(wayne_aggr_select[,'blacks'],wayne_aggr_select[,'latino'])
ct_al = segregation(wayne_aggr_select[,'asians'],wayne_aggr_select[,'latino'])
ct_ab = segregation(wayne_aggr_select[,'asians'],wayne_aggr_select[,'blacks'])

## Stworzenie tabeli porownujacej wskazniki segregacji i zroznicowania wyliczone dla blokow i dla census tract

compar = data.frame(index = c("Entropy","Sentropy","H", "D_WB", "D_WA", "D_WL", "D_BL", "D_AL", "D_AB"),
                    blocks = c(bl_entropy_value,bl_sentropy_value, bl_hindex_value, bl_wb, bl_wa, bl_wl, bl_bl, bl_al, bl_ab),
                    census_tract = c(ct_entropy_value,ct_sentropy_value, ct_hindex_value, ct_wb, ct_wa, ct_wl, ct_bl, ct_al, ct_ab))

## Export tabeli

# write.csv(compar, 'dane\\blct_compar_2010.csv')