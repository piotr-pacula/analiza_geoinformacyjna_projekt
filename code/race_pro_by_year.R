wayne_aggr_1990 =  read.csv('dane\\wayne_aggr_1990.csv')
wayne_aggr_2000 =  read.csv('dane\\wayne_aggr_2000.csv')
wayne_aggr_2010 =  read.csv('dane\\wayne_aggr_2010.csv')
wayne_aggr_2020 = read.csv('dane\\wayne_aggr_2020.csv')

list_race <- c("whites", "blacks", "asians", "native_americans", "others", "latino")
allpop_1990 = sum(wayne_aggr_1990$tot)
allpop_2000 = sum(wayne_aggr_2000$tot)
allpop_2010 = sum(wayne_aggr_2010$tot)
allpop_2020 = sum(wayne_aggr_2020$tot)


wayne_racepro = data.frame(race = list_race,
                           year_1990 = c(sum(wayne_aggr_1990$whites)/allpop_1990*100,
                                         sum(wayne_aggr_1990$blacks)/allpop_1990*100,
                                         sum(wayne_aggr_1990$asians)/allpop_1990*100,
                                         sum(wayne_aggr_1990$native_americans)/allpop_1990*100,
                                         others = sum(wayne_aggr_1990$others)/allpop_1990*100,
                                         latino = sum(wayne_aggr_1990$latino)/allpop_1990*100),
                           year_2000 = c(sum(wayne_aggr_2000$whites)/allpop_2000*100,
                                         sum(wayne_aggr_2000$blacks)/allpop_2000*100,
                                         sum(wayne_aggr_2000$asians)/allpop_2000*100,
                                         sum(wayne_aggr_2000$native_americans)/allpop_2000*100,
                                         others = sum(wayne_aggr_2000$others)/allpop_2000*100,
                                         latino = sum(wayne_aggr_2000$latino)/allpop_2000*100),
                           year_2010 = c(sum(wayne_aggr_2010$whites)/allpop_2010*100,
                                         sum(wayne_aggr_2010$blacks)/allpop_2010*100,
                                         sum(wayne_aggr_2010$asians)/allpop_2010*100,
                                         sum(wayne_aggr_2010$native_americans)/allpop_2010*100,
                                         others = sum(wayne_aggr_2010$others)/allpop_2010*100,
                                         latino = sum(wayne_aggr_2010$latino)/allpop_2010*100),
                           year_2020 = c(sum(wayne_aggr_2020$whites)/allpop_2020*100,
                                         sum(wayne_aggr_2020$blacks)/allpop_2020*100,
                                         sum(wayne_aggr_2020$asians)/allpop_2020*100,
                                         sum(wayne_aggr_2020$native_americans)/allpop_2020*100,
                                         others = sum(wayne_aggr_2020$others)/allpop_2020*100,
                                         latino = sum(wayne_aggr_2020$latino)/allpop_2020*100))

# write.csv(wayne_racepro, 'dane\\race_pro_year.csv')


