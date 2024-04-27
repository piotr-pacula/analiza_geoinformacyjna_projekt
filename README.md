# analiza_geoinformacyjna_projekt
Podział pracy:

Podstawowe informacje na temat rasowo-etnicznej struktury ludności - Maciej.Wi

Analiza zmian typów struktury rasowo-etnicznej ludności (klasyfikacja na 9 typów na podstawie procentowego udziału danej grupy rasowo-etnicznej) - Maciej.Wo

Przestrzenny rozkład segregacji oraz zróżnicowania rasowego w hrabstwie w latach 1990-2020 - Piotr

Wykorzystanie metod analizy krajobrazowej w analizie rasowo-etnicznej struktury ludnści + elementy dodatkowe - Adrian

https://dmowska-dydaktyka.web.amu.edu.pl/data/uploads/analiza_geoinformacyjna/raport_koncowy.html

2020 - Maciej.Wo

2010 - Piotr

2000 - Maciej.Wi

1990 - Adrian

1990-2000 ---> Adrian

2000-2010 ---> Maciej.Wi

2010-2020 ---> Piotr

1990-2020 ---> Maciej.Wo


code:

cat_races.R - kategoryzowanie ras wg kryterow na stronie https://dmowska-dydaktyka.web.amu.edu.pl/data/uploads/analiza_geoinformacyjna/cwiczenie_2.html oraz do agregacja danych (zajecia 2)

entropia.R - liczenie entropi

entropia_zestandaryzowana.R -liczenie entropii zestandaryzowanej

wskaznik_h.R - liczenie wskaznika teorii informacji H

wskaznik_niepodobienstwa_d.R - liczenie wskaznika niepodobienstwa D

blocks_vs_censustract.R - liczenie wkaznikow zroznicowania i segregacji DLA CALEGO HRABSTWA WAYNE na podstawie blokow i censustract w celu ich porowniania (patrz plik blct_compar_2010.csv)

blinx_each_ct.R - liczy wskazniki zroznicowania OSOBNO DLA KAZDEGO CENSUS TRACT na podstawie blokow, nastepnie je klasyfikuje (patrz wayne_aggr_idx_2010). Laczy dane z tabeli z danymi przestrzennymi i zapisuje je do geopackage wayne.gpkg

std_borders_and_class.R - sprowadza granice z lat 1990, 2000 i 2010 do tych z 2020. Dodaje kolumne z klasyfikacja obszaru wg dominujacej grupy rasowej

date_comparison.R - Laczy dane z dwoch roznych lat i tworzy dla nich wykresy porownawcze


race_pro_by_year.R - tworzy tabele z procentami populacji kazdej rasy w badanych latach


trans_matrix.R - tworzy macierz przejsc


estd_map.R - tworzy wykres mapy klasyfikacji entropi zestandaryzowanej


estd_map2.R - tworzy wykres mapy entropi zestandaryzowanej


hindex_map.R - tworzy wykres mapy indeksu H

hestd_map.R - tworzy wykres mapy typu struktury rasowo etnicznej na podstawie klasy entropi zestandaryzowanej i wskaznika H
