przyklad = read.csv("dane\\przyklad\\przyklad_b.csv")

# Ilosc grupy etnicznej wg jednostki
race1 = przyklad[,'W']
race2 = przyklad[,'B']

segregation = function(race1,race2){
  1/2 * sum(abs(race1/sum(race1)-race2/sum(race2)))
}