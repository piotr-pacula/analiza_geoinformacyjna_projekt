# analiza_geoinformacyjna_projekt
Podział pracy:

2020 - Maciej.Wo

2010 - Piotr

2000 - Maciej.Wi

1990 - Adrian


code:

cat_races.R - kategoryzowanie ras wg kryterow na stronie https://dmowska-dydaktyka.web.amu.edu.pl/data/uploads/analiza_geoinformacyjna/cwiczenie_2.html oraz do agregacja danych (zajecia 2)

entropia.R - liczenie entropi

entropia_zestandaryzowana.R -liczenie entropii zestandaryzowanej

wskaznik_h.R - liczenie wskaznika teorii informacji H

wskaznik_niepodobienstwa_d.R - liczenie wskaznika niepodobienstwa D

blocks_vs_censustract.R - liczenie wkaznikow zroznicowania i segregacji DLA CALEGO HRABSTWA WAYNE na podstawie blokow i censustract w celu ich porowniania (patrz plik blct_compar_2010.csv)

blinx_each_ct.R - liczy wskazniki zroznicowania OSOBNO DLA KAZDEGO CENSUS TRACT na podstawie blokow, nastepnie je klasyfikuje (patrz wayne_aggr_idx_2010). Laczy dane z tabeli z danymi przestrzennymi i zapisuje je do geopackage wayne.gpkg
