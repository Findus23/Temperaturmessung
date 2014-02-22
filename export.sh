#!/bin/bash
zufall=0
PFAD="/var/www/" #Pfad zum Web-Verzeichnis
r=0 # Backup-Zahl auf Null setzen
IFS="; " #Spezial-Variable, enthält Trennzeichen zum Trennen von Luftdruck und -temperatur
gpio mode 13 out # gelb
gpio mode 12 out # rot
gpio mode 3 out #grün
gpio write 13 0 # alle ausschalten
gpio write 12 0
gpio write 3 0
if [ $1 ] # if- und case- Abfrage für Startparameter
then
	case "$1" in
		"-d")rm /home/pi/Temperaturmessung/dygraph.csv
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
			gpio write 3 1
	uhrzeit=$(date +%Y/%m/%d\ %H:%M:%S)
	#zufall=$(($zufall + $((RANDOM % 10)) - 5)) # a um eine zufällige Zahl zwischen -5 und 5 ändern
	##a=a+[Zufallszahl von 0-32767] modulo 10 (um eine Zahl von 0-10 zu bekommen) -5 (-> -5 bis 5)
	#zufall=$a
	#load=$(cut -c 1,2,3,4 /proc/loadavg) # Load messen
	rasp=$(/opt/vc/bin/vcgencmd measure_temp | cut -c 6,7,8,9) #Betriebstemberatur messen
	#cpu=$(sensors |grep Core\ 0 |cut -c 18,19,20,21) #CPU-Temperatur, lm-sensors muss installiert sein, bei jedem PC anders
	temp1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b53835/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Innentemperatur
	while [ "$temp1" == "-1.250" ] || [ "$temp1" == "85.000" ] || [ "$temp1" == "85.000" ]
	do
		echo "----Temp1: $temp1"
		temp1=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277abe1/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	done
	temp2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Gerätesensor 1
	while [ "$temp2" == "-1.250" ] || [ "$temp2" == "85.000" ] || [ "$temp2" == "85.000" ]
	do
		echo "----Temp2: $temp2"
		temp2=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l)
	done
	temp3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Außensensor
	while [ "$temp3" == "-1.250" ] || [ "$temp3" == "85.000" ] || [ "$temp3" == "85.000" ]
	do
		echo "----Temp3: $temp3"
		temp3=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-000802b4635f/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) 
	done
	temp4=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) #Gerätesensor 2
	while [ "$temp3" == "-1.250" ] || [ "$temp4" == "85.000" ] || [ "$temp4" == "85.000" ]
	do
		echo "----Temp4: $temp4"
		temp4=$(echo "scale=3; $(grep 't=' /sys/bus/w1/devices/w1_bus_master1/10-00080277a5db/w1_slave | awk -F 't=' '{print $2}') / 1000" | bc -l) 
	done

	luft_roh=$(sudo /home/pi/Temperaturmessung/Fremddateien/Adafruit_DHT 2302 17 |grep Hum )	# Rohdaten des Luftfeuchtigkeits-Sensors
	luft_temp=$(echo $luft_roh | cut -c 8,9,10,11) # Luftfeuchtigkeit-Sensor auftrennen
	luft_feucht=$(echo $luft_roh | cut -c 23,24,25,26)
	while [ -z "$luft_roh" ] || [ "$(echo $luft_temp '>' 40 | bc -l)" -eq 1 ] || [ "$(echo $luft_temp '<' -20 | bc -l)" -eq 1 ]
	do
		echo "----Luft: $luft_roh"
		luft_roh=$(sudo /home/pi/Temperaturmessung/Fremddateien/Adafruit_DHT 2302 17 |grep Hum )
		luft_temp=$(echo $luft_roh | cut -c 8,9,10,11) # Luftfeuchtigkeit-Sensor auftrennen
		luft_feucht=$(echo $luft_roh | cut -c 23,24,25,26)
	done
	druck_roh=$(sudo python /home/pi/Temperaturmessung/Fremddateien/Adafruit_BMP085_auswertung.py) # Rohdaten des Luftdruck-Sensors
	set -- $druck_roh #Zerlegen mithilfe von IFS (siehe ganz oben)
	temp_druck=$1
	druck=$2
			gpio write 12 1
	qualitat=$(sudo /home/pi/Temperaturmessung/Fremddateien/airsensor -v -o)
			gpio write 12 0
			gpio write 3 0
			gpio write 13 1
	ausgabe=${uhrzeit}\,${temp1}\,${temp2}\,${temp3}\,${temp4}\,${luft_temp}\,${luft_feucht}\,${druck}\,${temp_druck}\,${rasp},${qualitat}
	echo $ausgabe >>/home/pi/Temperaturmessung/dygraph.csv
	echo "$uhrzeit	${temp1},${temp2},${temp3},${temp4},${luft_temp},${luft_feucht},${druck},${temp_druck},${rasp},${qualitat}" #Ausgabe des aktuellen Wertes im Terminal
	echo "Uhrzeit:" >/home/pi/Temperaturmessung/text.txt.temp #Anzeigen für Display 
	echo "$uhrzeit" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Innentemperatur" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$temp1 (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Geraetetemp 1" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$temp2 (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Aussentemperatur" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$temp3 (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Geraetetemp 2" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$temp4 (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Temperatur/Luft" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$luft_temp (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Luftfeuchte" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$luft_feucht (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Temp./Druck" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$temp_druck (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Luftdruck" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$druck (hPa)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Prozessor" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$rasp (C)" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "Luftqualitat" >>/home/pi/Temperaturmessung/text.txt.temp
	echo "$qualitat" >>/home/pi/Temperaturmessung/text.txt.temp
	mv /home/pi/Temperaturmessung/text.txt.temp /home/pi/Temperaturmessung/text.txt
	sudo cp /home/pi/Temperaturmessung/dygraph.csv ${PFAD}dygraph.csv
			gpio write 13 0
	sleep 8 # kurz warten
	r=$(($r +1)) # Anzahl der Durchläufe zählen
	if [ "$r" == "1000" ] # und alle 1000 Durchgänge Sicherung anfertigen
	then
		cp /home/pi/Temperaturmessung/dygraph.csv /home/pi/Temperaturmessung/dygraph.csv.bak
		python /home/pi/Temperaturmessung/Fremddateien/send.py "l.winkler23@me.com" "Backup" "" "/home/pi/Temperaturmessung/dygraph.csv" &
		echo "Backup"
		r=0
	fi
done
