przyklad = read.csv("dane\\przyklad_b.csv")

entropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  return(entropy)}

# liczba ludnosci dla jednostek
zonepop = apply(select(przyklad, -1),1,sum)

# Entropia calkowita
total = apply(select(przyklad, -1),2,sum)
pi = total/sum(total)
allentropy = entropy(pi)

# entropia dla jednostek
pi2 = select(przyklad, -1)/zonepop
zoneentropy = apply(pi2, 2, entropy)

hindex = function(zonepop, allentropy, zoneentropy){
  h = sum((zonepop*(allentropy-zoneentropy))/(allentropy*sum(zonepop)),na.rm = TRUE)
  return(h)}


