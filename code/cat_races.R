library(dplyr)

# otworzyc plik z surowymi danymi

blocks = read.csv('dane_atrybutowe\\blocks2010.csv')
blocks = blocks[blocks$COUNTY_CODE==26163,]

## kategoryzacja

# odpowiednio dopasować kategore wg tego co na stronie dmowska-dydaktyka

blocks$whites = blocks$H7Z003

blocks$blacks = blocks$H7Z004

blocks$asians = blocks$H7Z006 + blocks$H7Z007

blocks$native_americans = blocks$H7Z005

blocks$others = blocks$H7Z008 + blocks$H7Z009

blocks$latino = blocks$H7Z010

# zmienic H7Z na poczatek nazwy kolumny dla odpowieniej daty

blocks <- blocks %>% select(-starts_with("H7Z"))

# ustawic miejsce zapisania pliku

write.csv(blocks, 'dane_atrybutowe\\wayne_2010.csv')

## agregacja

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")

blocks2 = blocks

blocks2$tot = rowSums(blocks2 %>% select(one_of(list_race)))

blocks2 <- aggregate(.~GISJOIN_T, blocks2[, c("GISJOIN_T", list_race, "tot")], FUN=sum)

# ustawic miejsce zapisania pliku

write.csv(blocks2, 'dane_atrybutowe\\wayne_aggr_2010.csv')