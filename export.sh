#!/bin/bash
PFAD="/var/www/"
a=0
Anzahl=0
Summe=0
min=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) # Sowohl Minimum als auch Maximum auf die aktuelle Temperatur setzen
max=$min
if [ $1 ]
then
	case "$1" in
		"-d") echo "" > rohdaten.csv
			rm dygraph.csv
			;;
		"-h") echo -e "-d 	csv-Datei leeren \nfür weitere Informationen siehe http://lukaswiki.onpw.de/rasp"
			exit 1
			;;
		*) echo "unbekannter Parameter - Für Hilfe -h"
			exit
			;;
	esac
fi
while true
do
	#a=$(($a + $((RANDOM % 10)) - 5)) # a um eine zufällige Zahl zwischen -5 und 5 ändern
	##a=a+[Zufallszahl von 0-32767] modulo 10 (um eine Zahl von 0-10 zu bekommen) -5 (-> -5 bis 5)
	#wert2=$a
	#wert2=$(cut -c 1,2,3,4 /proc/loadavg) # Load messen
	#wert=$(/opt/vc/bin/vcgencmd measure_temp | cut -c 6,7,8,9) #Betriebstemberatur messen
	#wert2=$(sensors |grep Core\ 0 |cut -c 18,19,20,21) #CPU-Temperatur, lm-sensors muss installiert sein, bei jedem PC anders
	wert1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	wert2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	wert3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	uhrzeit=$(date +%H:%M:%S) 
	uhrzeit_dy=$(date +%Y/%m/%d\ %H:%M:%S)
	if [ "$wert1" == "-1.250" ] # manchmal gibt der Sensor "-1.250" als Wert zurück -> diese sollen gelöscht werden 
		then
			wert1=""
	fi
	if [ "$wert2" == "-1.250" ]
		then
			wert2=""
	fi
	if [ "$wert3" == "-1.250" ]
		then
			wert3=""
	fi
#Mathematische Auswertung Anfang
	Summe=$(echo "$Summe + $wert1" | bc -l) # mithilfe von bc den aktuellen Wert zur Summe aller Werten dazuzählen ...
	Anzahl=$(($Anzahl +1)) # ... die Anzahl um 1 erhöhen ...
	MW=$(echo "scale=3;$Summe / $Anzahl" | bc -l) # ... und den Mittelwert berechnen
	if [ "$(echo "$wert1 < $min" | bc -l)" = "1" ] # Falls der aktuelle Wert kleiner als das Minimum ist ...
		then
			min=$wert1								#  ... soll er zum neuen Minimum werden
	fi
	if [ "$(echo "$wert1 > $max" | bc -l)" = "1" ] # Wie Minimum
		then
			max=$wert1
	fi
	

#Mathematische Auswertung Ende
	ausgabe=${uhrzeit}\,${wert1}\,${wert2}
	ausgabe_dy=${uhrzeit_dy}\,${wert1}\,${wert2}\,${wert3}
	echo $ausgabe >>rohdaten.csv
	echo $ausgabe_dy >>dygraph.csv
	echo "$uhrzeit_dy				$wert1		$MW	$min	$max" #Ausgabe des aktuellen Wertes im Terminal
	sed "s/,/ /g" rohdaten.csv >daten_gnuplot.txt #für Gnuplot die Beistriche durch Leerzeichen ersetzen 
	echo "Uhrzeit:" >text.txt #Anzeige für Display
	echo "$uhrzeit" >>text.txt #Anzeige für Display
	echo "Temperatur 1" >>text.txt #Anzeige für Display
	echo "$wert1" >>text.txt #Anzeige für Display
	echo "Temperatur 2" >>text.txt #Anzeige für Display
	echo "$wert2" >>text.txt #Anzeige für Display
	echo "Aussentemperatur" >>text.txt #Anzeige für Display
	echo "$wert3" >>text.txt #Anzeige für Display
#	./transpose.sh #anderes Skript starten, welches die Daten für Highchart vorbereitet
#	gnuplot Einstellungen # Gnuplot starten
#	sudo cp gnuplot.svg ${PFAD}gnuplot.svg # das generierte Bild ...
	sudo cp daten_transformiert.txt ${PFAD}daten_transformiert.txt # ... und die Tabelle für Highchart in den Webordner kopieren
	sudo cp dygraph.csv ${PFAD}dygraph.csv
	sleep 8 # kurz warten
done
