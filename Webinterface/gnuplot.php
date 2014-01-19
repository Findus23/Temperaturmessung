<?php
exec("sed 's/,/ /g' /home/pi/Temperaturmessung/dygraph.csv >/var/www/gnuplot/daten_gnuplot.txt");
exec("gnuplot /home/pi/Temperaturmessung/Einstellungen.plt");
header("Location: http://10.0.0.22/gnuplot.html");
?>
