# -*- coding: utf-8 -*-
from datetime import datetime # aus dem Modul datetime Datentyp datetime (Datum und Zeit) importieren

format = "%Y/%m/%d %H:%M:%S"

von_roh = "2014/02/01 18:12:42"
von = datetime.strptime(von_roh, format)
bis_roh = "2014/02/01 22:1:00"
bis = datetime.strptime(bis_roh, format)
datei = open("datum.csv", "r")
inhalt = datei.readlines()
datei.close()
start_gefunden = False
stop_gefunden = False
for datum in inhalt:
	datum_py = datetime.strptime(datum.rstrip(), format)
	if (datum_py > von) and (start_gefunden == False):
		start = inhalt.index(datum)
		start_gefunden = True
	if (start_gefunden == True) and (datum_py > bis) and (stop_gefunden == False):
		stop = inhalt.index(datum) - 1
		stop_gefunden = True
		break
print("Der Messwert geht von Zeile " + str(start) + " bis Zeile " + str(stop) + " und über folgenden Zeitraum: " + str(bis - von))

