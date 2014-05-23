# x-Achse enthält Zeitinformation
set xdata time
# Zeitformat zur Eingabe
set timefmt x "%Y/%m/%d\ %H:%M:%S"
# Zeitformat zur Beschriftung der x-Achse
set format x "%d.%m %H:%M"
set grid #Gitter anzeigen
set terminal svg size 1200,800


set title "Innentemperaturen"
set ylabel 'Temperatur (°C)'
set output "innen.svg"
plot "gnuplot.txt" using 1:3 title 'Innentemperatur' with lines , \
     "gnuplot.txt" using 1:4  title 'Gerätetemperatur 1' with lines , \
     "gnuplot.txt" using 1:6  title 'Gerätetemperatur 2' with lines

set title "Aussentemperaturen"
set ylabel 'Temperatur (°C)'
set output "aussen.svg"
plot "gnuplot.txt" using 1:5 title 'Bodentemperatur' with lines , \
     "gnuplot.txt" using 1:7  title 'Luftfeuchtesensor' with lines , \
     "gnuplot.txt" using 1:10  title 'Aussentemperatur' with lines 

set title "Luftdruck"
set ylabel 'hPa'
set nokey #keine Legende
set output "luftdruck.svg"
plot "gnuplot.txt" using 1:9 title 'Luftdruck' with lines

set title "Luftfeuchtigkeit"
set ylabel '% rel. Luftfeuchte'
set output "luftfeuchte.svg"
plot "gnuplot.txt" using 1:8 title 'Luftfeuchte' with lines

set title "Luftqualität"
set ylabel 'relativer Wert'
set output "luftqualität.svg"
plot "gnuplot.txt" using 1:12 title 'Luftqualität' with lines

set title "Prozessortemperatur"
set ylabel 'Temperatur (°C)'
set output "prozessor.svg"
plot "gnuplot.txt" using 1:11 title 'Prozessortemperatur' with lines
