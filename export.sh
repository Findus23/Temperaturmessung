#!/bin/bash
zufall=0
PFAD="/var/www/"
Anzahl=0
Summe=0
min=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) # Sowohl Minimum als auch Maximum auf die aktuelle Temperatur setzen
max=$min
r=0 # Backup-Zahl auf Null setzen
if [ $1 ]
then
	case "$1" in
		"-d") echo "" > rohdaten.csv
			rm dygraph.csv
			;;
		"-h") echo -e "-d 	csv-Datei leeren \nfür weitere Informationen siehe http://lukaswiki.onpw.de/rasp oder https://github.com/Findus23/Temperaturmessung"
			exit 1
			;;
		*) echo "unbekannter Parameter - Für Hilfe -h"
			exit
			;;
	esac
fi
while true
do
	#zufall=$(($zufall + $((RANDOM % 10)) - 5)) # a um eine zufällige Zahl zwischen -5 und 5 ändern
	##a=a+[Zufallszahl von 0-32767] modulo 10 (um eine Zahl von 0-10 zu bekommen) -5 (-> -5 bis 5)
	#zufall=$a
	#load=$(cut -c 1,2,3,4 /proc/loadavg) # Load messen
	rasp=$(/opt/vc/bin/vcgencmd measure_temp | cut -c 6,7,8,9) #Betriebstemberatur messen
	#cpu=$(sensors |grep Core\ 0 |cut -c 18,19,20,21) #CPU-Temperatur, lm-sensors muss installiert sein, bei jedem PC anders
	temp1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	temp2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	temp3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	luft_roh=$(sudo ./Fremddateien/Adafruit_DHT 2302 17 |grep Hum )	
	while [ -z "$luft_roh" ] 
	do
		luft_roh=$(sudo ./Fremddateien/Adafruit_DHT 2302 17 |grep Hum )
		echo "----$luft_roh"
	done
	luft_temp=$(echo $luft_roh | cut -c 8,9,10,11)
	luft_feucht=$(echo $luft_roh | cut -c 23,24,25,26)
	uhrzeit=$(date +%H:%M:%S) 
	uhrzeit_dy=$(date +%Y/%m/%d\ %H:%M:%S)
	if [ "$temp1" == "-1.250" ] # manchmal gibt der Sensor "-1.250" als Wert zurück -> diese sollen gelöscht werden 
		then
			temp1=""
	fi
	if [ "$temp2" == "-1.250" ]
		then
			temp2=""
	fi
	if [ "$temp3" == "-1.250" ]
		then
			temp3=""
	fi
#Mathematische Auswertung Anfang
	Summe=$(echo "$Summe + $temp1" | bc -l) # mithilfe von bc den aktuellen Wert zur Summe aller Werten dazuzählen ...
	Anzahl=$(($Anzahl +1)) # ... die Anzahl um 1 erhöhen ...
	MW=$(echo "scale=3;$Summe / $Anzahl" | bc -l) # ... und den Mittelwert berechnen
	if [ "$(echo "$temp1 < $min" | bc -l)" = "1" ] # Falls der aktuelle Wert kleiner als das Minimum ist ...
		then
			min=$temp1								#  ... soll er zum neuen Minimum werden
	fi
	if [ "$(echo "$temp1 > $max" | bc -l)" = "1" ] # Wie Minimum
		then
			max=$temp1
	fi
	
#Mathematische Auswertung Ende
	ausgabe=${uhrzeit}\,${temp1}\,${temp2}
	ausgabe_dy=${uhrzeit_dy}\,${temp1}\,${temp2}\,${temp3}\,${luft_temp}\,${luft_feucht},${rasp}
	echo $ausgabe >>rohdaten.csv
	echo $ausgabe_dy >>dygraph.csv
	echo "$uhrzeit_dy	,${temp1},${temp2},${temp3},${luft_temp},${luft_feucht},${rasp}	" #Ausgabe des aktuellen Wertes im Terminal
	sed "s/,/ /g" rohdaten.csv >daten_gnuplot.txt #für Gnuplot die Beistriche durch Leerzeichen ersetzen 
	echo "Uhrzeit:" >text.txt #Anzeige für Display
	echo "$uhrzeit" >>text.txt #Anzeige für Display
	echo "Geraetetemp 1" >>text.txt #Anzeige für Display
	echo "$temp1" >>text.txt #Anzeige für Display
	echo "Geraetetemp 2" >>text.txt #Anzeige für Display
	echo "$temp2" >>text.txt #Anzeige für Display
	echo "Aussentemperatur" >>text.txt #Anzeige für Display
	echo "$temp3" >>text.txt #Anzeige für Display
	echo "Temperatur/Luft" >>text.txt #Anzeige für Display
	echo "$luft_temp" >>text.txt #Anzeige für Display
	echo "Luftfeuchtigkeit" >>text.txt #Anzeige für Display
	echo "$luft_feucht" >>text.txt #Anzeige für Display
	echo "Prozessor" >>text.txt #Anzeige für Display
	echo "$rasp" >>text.txt #Anzeige für Display
#	./transpose.sh #anderes Skript starten, welches die Daten für Highchart vorbereitet
#	gnuplot Einstellungen # Gnuplot starten
#	sudo cp gnuplot.svg ${PFAD}gnuplot.svg # das generierte Bild ...
#	sudo cp daten_transformiert.txt ${PFAD}daten_transformiert.txt # ... und die Tabelle für Highchart in den Webordner kopieren
	sudo cp dygraph.csv ${PFAD}dygraph.csv
	sleep 8 # kurz warten
	r=$(($r +1))
	if [ "$r" == "1000" ]
	then
		cp rohdaten.csv dygraph.csv daten_gnuplot.txt text.txt backup/
		echo "Backup"
	fi
done
