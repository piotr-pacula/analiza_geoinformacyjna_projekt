przyklad = read.csv("dane\\przyklad_b.csv")

# wyliczenie calkowitej populacji dla kazdej grupy etnicznej
total = apply(select(przyklad, -1), 1, sum)

# udzial grup etnicznych
pi = total/sum(total)

# funkcja do liczenia entropi zestandaryzowanej
sentropy = function(pi){
  entropy = -sum(pi*log(pi), na.rm = TRUE)
  max_entropy = log(length(pi))
  standard_entropy = entropy/max_entropy
  return(standard_entropy)}