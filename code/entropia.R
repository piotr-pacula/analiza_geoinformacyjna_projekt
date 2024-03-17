przyklad = read.csv("dane\\przyklad\\przyklad_b.csv")

# calkowita populacja dla kazdej grupy etnicznej
total = apply(select(przyklad, -1), 1, sum)

# Udzial grup etnicznych
pi = total/sum(total)

entropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  return(entropy)}