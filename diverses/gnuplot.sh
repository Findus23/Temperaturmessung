if [ -f /var/www/gnuplot_erstellen ]
then
	sed 's/,/ /g' /home/pi/Temperaturmessung/dygraph.csv >  /home/pi/Temperaturmessung/gnuplot.txt
	gnuplot /home/pi/Temperaturmessung/diverses/Einstellungen.plt
	sudo rm /var/www/gnuplot_erstellen
fi
