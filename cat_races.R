library(dplyr)

getwd()

setwd('C:\\Users\\ppacula24\\Desktop\\c_ag2')

blocks = read.csv('dane_atrybutowe\\blocks2010.csv')
blocks = blocks[blocks$COUNTY_CODE==26163,]

blocks$whites = blocks$H7Z003

blocks$blacks = blocks$H7Z004

blocks$asians = blocks$H7Z006 + blocks$H7Z007

blocks$native_americans = blocks$H7Z005

blocks$others = blocks$H7Z008 + blocks$H7Z009

blocks$latino = blocks$H7Z010

blocks <- blocks %>% select(-starts_with("H7Z"))

write.csv(blocks, 'dane_atrybutowe\\detroit2010.csv')