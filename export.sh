#!/bin/bash
zufall=0
PFAD="/var/www/" #Pfad zum Web-Verzeichnis
Anzahl=0 #statistische Auswertung
Summe=0 #statistische Auswertung
min=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) # Sowohl Minimum als auch Maximum auf die aktuelle Temperatur setzen
max=$min
r=0 # Backup-Zahl auf Null setzen
IFS="; " #Spezial-Variable, enthält Trennzeichen zum Trennen von Luftdruck und -temperatur
if [ $1 ] # if- und case- Abfrage für Startparameter
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
	temp1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b53835/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Temperatursensor auf Steckbrett
	while [ "$temp1" == "-1.250" ]
	do
		echo "----Temp1: $temp1"
		temp1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	done
	temp2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Temperatursensor auf Steckbrett
	while [ "$temp2" == "-1.250" ]
	do
		echo "----Temp2: $temp2"
		temp2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	done
	temp3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Außensensor
	while [ "$temp3" == "-1.250" ]
	do
		echo "----Temp3: $temp3"
		temp3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) 
	done
	temp4=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Außensensor
	while [ "$temp3" == "-1.250" ]
	do
		echo "----Temp4: $temp4"
		temp4=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) 
	done
	luft_roh=$(sudo ./Fremddateien/Adafruit_DHT 2302 17 |grep Hum )	# Rohdaten des Luftfeuchtigkeits-Sensors
	while [ -z "$luft_roh" ] 
	do
		echo "----Luft: $luft_roh"
		luft_roh=$(sudo ./Fremddateien/Adafruit_DHT 2302 17 |grep Hum )
	done
	luft_temp=$(echo $luft_roh | cut -c 8,9,10,11) # Luftfeuchtigkeit-Sensor auftrennen
	luft_feucht=$(echo $luft_roh | cut -c 23,24,25,26)
	druck_roh=$(sudo python Fremddateien/Adafruit_BMP085_auswertung.py) # Rohdaten des Luftdruck-Sensors
	set -- $druck_roh #Zerlegen mithilfe von IFS (siehe ganz oben)
	temp_druck=$1
	druck=$2
	uhrzeit=$(date +%Y/%m/%d\ %H:%M:%S)

#Mathematische Auswertung Anfang
#	Summe=$(echo "$Summe + $temp1" | bc -l) # mithilfe von bc den aktuellen Wert zur Summe aller Werten dazuzählen ...
#	Anzahl=$(($Anzahl +1)) # ... die Anzahl um 1 erhöhen ...
#	MW=$(echo "scale=3;$Summe / $Anzahl" | bc -l) # ... und den Mittelwert berechnen
#	if [ "$(echo "$temp1 < $min" | bc -l)" = "1" ] # Falls der aktuelle Wert kleiner als das Minimum ist ...
#		then
#			min=$temp1								#  ... soll er zum neuen Minimum werden
#	fi
#	if [ "$(echo "$temp1 > $max" | bc -l)" = "1" ] # Wie Minimum
#		then
#			max=$temp1
#	fi
#	
#Mathematische Auswertung Ende
	ausgabe=${uhrzeit}\,${temp1}\,${temp2}\,${temp3}\,${temp4}\,${luft_temp}\,${luft_feucht}\,${druck}\,${temp_druck}\,${rasp}
	echo $ausgabe >>dygraph.csv
	echo "$uhrzeit	${temp1},${temp2},${temp3},${temp4},${luft_temp},${luft_feucht},${druck},${temp_druck},${rasp}" #Ausgabe des aktuellen Wertes im Terminal
	echo "Uhrzeit:" >text.txt #Anzeigen für Display 
	echo "$uhrzeit" >>text.txt
	echo "Innentemperatur" >>text.txt
	echo "$temp1" >>text.txt
	echo "Geraetetemp 1" >>text.txt
	echo "$temp2" >>text.txt
	echo "Aussentemperatur" >>text.txt
	echo "$temp3" >>text.txt
	echo "Geraetetemp 2" >>text.txt
	echo "$temp4" >>text.txt
	echo "Temperatur/Luft" >>text.txt
	echo "$luft_temp" >>text.txt
	echo "Luftfeuchte" >>text.txt
	echo "$luft_feucht" >>text.txt
	echo "Temp./Druck" >>text.txt
	echo "$temp_druck" >>text.txt
	echo "Luftdruck" >>text.txt
	echo "$druck" >>text.txt
	echo "Prozessor" >>text.txt
	echo "$rasp" >>text.txt
	sudo cp dygraph.csv ${PFAD}dygraph.csv
	sleep 8 # kurz warten
	r=$(($r +1)) # Anzahl der Durchläufe zählen
	if [ "$r" == "1000" ] # und alle 1000 Durchgänge Sicherung anfertigen
	then
		cp dygraph.csv dygraph.csv.bak
		echo "Backup"
		r=0
	fi
done
