# -*- coding: utf-8 -*-
import csv
import math
from datetime import datetime # aus dem Modul datetime Datentyp datetime (Datum und Zeit) importieren
bis_roh = "2014/02/01 22:1:00"

namen = ["Innentemperatur", "Gerätetemperatur 1", "Außentemperatur", "Gerätetemperatur 2", "Temperatur (Luft)", "Luftfeuchtigkeit", "Luftdruck", "Temperatur (Druck)", "Prozessor"]
format = "%Y/%m/%d %H:%M:%S"
von_roh = "2014/02/01 18:12:42"


def offnen(datei):
	with open(datei) as filein:
		reader =csv.reader(filein, quoting=csv.QUOTE_NONNUMERIC)
		global liste # Liste außerhalb von Funtion nutzen
		liste = list(zip(*reader)) # = [temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp]

def mittelwert(spalte):
	summe = 0
	anzahl = 0 # Anzahl der Messwerte
	for wert in spalte:
		summe = summe + wert # zur bisherigen Summe addieren
		anzahl += 1
	mittelwert = summe / anzahl
	return mittelwert

def minmax(spalte):
	mini = spalte[0] #Minimum auf ersten Wert setzen
	maxi = spalte[0]
	for wert in spalte:
		if wert < mini:
			mini = wert
		if wert > maxi:
			maxi = wert
	return (mini,maxi)

def standardabweichung(spalte,mw):
	n = 0
	summe = 0
	for wert in spalte:
		term = wert - mw
		summe = summe + (term * term)
		n += 1
	stab = math.sqrt(summe / n)
	return stab

def datumsauswahl(von_roh,bis_roh):
	von = datetime.strptime(von_roh, format)
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
	return start,stop
offnen("vorbereitet.csv")
startstop = datumsauswahl(von_roh,bis_roh)
von = startstop[0]
bis = startstop[1]
liste_auswahl = []
for spalte in liste:
	spalte_neu = spalte[von:bis]
	liste_auswahl.append(spalte_neu)
liste = liste_auswahl
print("------Mittelwerte------")
mittelwerte = [] # leere Liste erstellen
for spalte in liste:
	mw = mittelwert(spalte) #jeden MW ausrechnen ...
	mittelwerte.append(mw) # ... und an die Liste anhängen
mittelausgabe = zip(namen,mittelwerte) # in Tupel umwandeln [(Innentemperatur, 25), (Außentemperatur,8)]
for name,mittelwert in mittelausgabe:
	print(name + ":\t%0.2f" % mittelwert) # jedes Tupel ausgeben

print("------Minimum-Maximum------")
minima = []
maxima = []
for spalte in liste:
	minumax = minmax(spalte)
	mini = minumax[0]
	maxi = minumax[1]
	minima.append(mini)
	maxima.append(maxi)
minmaxausgabe = zip(namen,minima,maxima)
for name,minimum,maximum in minmaxausgabe: 
	print(name + ":\t" + str(minimum) + "\t" + str(maximum))
print("------Standardabweichung------")
standardabweichungen=[]
for spalte in liste:
	abweichung = standardabweichung(spalte,mittelwerte[liste.index(spalte)]) #Mittelwert über Stelle in Liste herausfinden
	standardabweichungen.append(abweichung)
stabausgabe = zip(namen,standardabweichungen)
for name,abweichung in stabausgabe:
	print(name + ":\t%0.2f" % abweichung)
