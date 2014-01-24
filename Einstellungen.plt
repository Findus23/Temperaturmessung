# x-Achse enthält Zeitinformation
set xdata time
# Zeitformat zur Eingabe
set timefmt x "%Y/%m/%d\ %H:%M:%S"
# Zeitformat zur Beschriftung der x-Achse
set format x "%d.%m %H:%M"
# set nokey #keine Legende
set grid #Gitter anzeigen
set title "Raspberry Pi" #Überschrift
set ylabel 'Temperatur (°C)'
set y2label 'relative Luftfeuchtigkeit (%)'
#set xlabel 'Zeit'
set y2tics # Zahlen auch auf 2. y-Achse

plot "/var/www/gnuplot/daten_gnuplot.txt" using 1:3  title 'Innentemperatur 1' with lines axes x1y1, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:4  title 'Innentemperatur 2' with lines axes x1y1, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:5  title 'Außentemperatur' with lines axes x1y1, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:6  title 'Temperatur Luft' with lines axes x1y1, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:7  title 'Luftfeuchtigkeit' with lines axes x1y2, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:9  title 'Temperatur (Druck)' with lines axes x1y1
set terminal svg size 1200,800
set output "/var/www/gnuplot/gnuplot.svg"
replot
set terminal png size 1200,800
set output "/var/www/gnuplot/gnuplot.png"
replot

set ylabel 'Luftdruck (hPa)'
set y2label 'Temperatur (°C)'
plot "/var/www/gnuplot/daten_gnuplot.txt" using 1:8  title 'Luftdruck' with lines axes x1y1, \
     "/var/www/gnuplot/daten_gnuplot.txt" using 1:10  title 'Prozessor' with lines axes x1y2
set terminal svg size 1200,800
set output "/var/www/gnuplot/druck.svg"
replot
set terminal png size 1200,800
set output "/var/www/gnuplot/druck.png"
replot
