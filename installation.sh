#!/bin/bash
SKRIPTPFAD=$(pwd)
if [[ -f $(which gnuplot 2>/dev/null) ]]
    then
		echo "Gnuplot ist installiert" >installation.log
    else
		dialog --title "Gnuplot" --msgbox "Gnuplot wird im nächsten Schritt installiert. Abbrechen mit STRG+C" 80 80
		sudo apt-get install gnuplot-nox >>installation.log
fi
wget http://lukaswiki.onpw.de/rasp/skripte/export.sh 2>>installation.log
wget http://lukaswiki.onpw.de/rasp/skripte/transpose.sh 2>>installation.log
wget http://lukaswiki.onpw.de/rasp/skripte/Einstellungen 2>>installation.log
chmod 755 export.sh transpose.sh
chmod 644 Einstellungen
dialog --yesno "Sollen die Dateien automatisch in ein Web-verzeichis kopiert werden?" 80 80
if [ $? == "1" ]
then
	sed -i "s/sudo cp/#sudo cp/g" export.sh
else
	dialog --title "Verzeichnis" --msgbox "Wo liegt das Web-verzeichis?" 80 80
	dialog --dselect / 10 10 2> temp.tmp
	PFAD=$(cat temp.tmp)
	ZEILE="PFAD=\"$PFAD\""
	sed -i 2c"$ZEILE" export.sh #2. Zeile
	rm temp.tmp
	cd $PFAD
	sudo wget http://lukaswiki.onpw.de/rasp/javascript/highcharts.js 2>>$SKRIPTPFAD/installation.log
	sudo wget http://lukaswiki.onpw.de/rasp/beispiele/highcharts.html 2>>$SKRIPTPFAD/installation.log
	dialog --title "Highchart" --msgbox "Die Highchart-Dateien wurden nach $PFAD kopiert. Das Diagramm kann unter localhost/highcharts.html gefunden werden." 80 80
fi
dialog --title "Abgeschlossen" --msgbox "Die Installation ist abgeschlossen." 80 80
