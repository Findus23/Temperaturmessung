# -*- coding: utf-8 -*-
import csv
import math

def offnen(datei):
	with open(datei) as filein:
		reader =csv.reader(filein, quoting=csv.QUOTE_NONNUMERIC)
		global temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp
		temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp = list(zip(*reader))

def mittelwert(spalte):
	summe = 0
	anzahl = 0
	for wert in spalte:
		summe = summe + wert
		anzahl += 1
	mittelwert = summe / anzahl
	return mittelwert

def minmax(spalte):
	mini = spalte[0]
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
	
offnen("vorbereitet.csv")
liste = [temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp]
namen = ["Innentemperatur", "Gerätetemperatur 1", "Außentemperatur", "Gerätetemperatur 2", "Temperatur (Luft)", "Luftfeuchtigkeit", "Luftdruck", "Temperatur (Druck)", "Prozessor"]
print("------Mittelwerte------")
mittelwerte = []
for spalte in liste:
	mw = mittelwert(spalte)
	mittelwerte.append(mw)
mittelausgabe = zip(namen,mittelwerte)
for name,mittelwert in mittelausgabe:
	print(name + ":\t%0.2f" % mittelwert)

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
	abweichung = standardabweichung(spalte,mittelwerte[liste.index(spalte)])
	standardabweichungen.append(abweichung)
stabausgabe = zip(namen,standardabweichungen)
for name,abweichung in stabausgabe:
	print(name + ":\t%0.2f" % abweichung)
