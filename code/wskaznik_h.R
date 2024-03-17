# races = read.csv("dane\\przyklad\\przyklad_b.csv")

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


