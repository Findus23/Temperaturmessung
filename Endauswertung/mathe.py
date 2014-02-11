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
			mini = wert
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
print("------Mittelwerte------")
mw_temp1 = mittelwert(temp1)
mw_temp2 = mittelwert(temp2)
mw_temp3 = mittelwert(temp3)
mw_temp4 = mittelwert(temp4)
mw_luft_temp = mittelwert(luft_temp)
mw_luft_feucht = mittelwert(luft_feucht)
mw_druck = mittelwert(druck)
mw_temp_druck = mittelwert(temp_druck)
mw_rasp = mittelwert(rasp)

print("Innentemperatur:\t%0.2f" % mw_temp1)
print("Gerätetemperatur 1:\t%0.2f" % mw_temp2)
print("Außentemperatur:\t%0.2f" % mw_temp3)
print("Gerätetemperatur 2:\t%0.2f" % mw_temp4)
print("Temperatur (Luft):\t%0.2f" % mw_luft_temp)
print("Luftfeuchtigkeit:\t%0.2f" % mw_luft_feucht)
print("Luftdruck:\t\t%0.2f" % mw_druck)
print("Temperatur (Druck):\t%0.2f" % mw_temp_druck)
print("Prozessor:\t\t%0.2f" % mw_rasp)

print("------Minimum-Maximum------")
min_temp1 = minmax(temp1)[0]
max_temp1 = minmax(temp1)[1]
min_temp2 = minmax(temp2)[0]
max_temp2 = minmax(temp2)[1]
min_temp3 = minmax(temp3)[0]
max_temp3 = minmax(temp3)[1]
min_temp4 = minmax(temp4)[0]
max_temp4 = minmax(temp4)[1]
min_luft_temp = minmax(luft_temp)[0]
max_luft_temp = minmax(luft_temp)[1]
min_luft_feucht = minmax(luft_feucht)[0]
max_luft_feucht = minmax(luft_feucht)[1]
min_druck = minmax(druck)[0]
max_druck = minmax(druck)[1]
min_temp_druck = minmax(temp_druck)[0]
max_temp_druck = minmax(temp_druck)[1]
min_rasp = minmax(rasp)[0]
max_rasp = minmax(rasp)[1]
print("Innentemperatur:\t" + str(min_temp1) + "\t" + str(max_temp1))
print("Gerätetemperatur 1:\t" + str(min_temp2) + "\t" + str(max_temp2))
print("Außentemperatur:\t" + str(min_temp3) + "\t" + str(max_temp3))
print("Gerätetemperatur 2:\t" + str(min_temp4) + "\t" + str(max_temp4))
print("Temperatur (Luft):\t" + str(min_luft_temp) + "\t" + str(max_luft_temp))
print("Luftfeuchtigkeit:\t" + str(min_luft_feucht) + "\t" + str(max_luft_feucht))
print("Luftdruck:\t\t" + str(min_druck) + "\t" + str(max_druck))
print("Temperatur (Druck):\t" + str(min_temp_druck) + "\t" + str(max_temp_druck))
print("Prozessor:\t\t" + str(min_rasp) + "\t" + str(max_rasp))

print("------Standardabweichung------")
stab_temp1 = standardabweichung(temp1,mw_temp1)
stab_temp2 = standardabweichung(temp2,mw_temp2)
stab_temp3 = standardabweichung(temp3,mw_temp3)
stab_temp4 = standardabweichung(temp4,mw_temp4)
stab_luft_temp = standardabweichung(luft_temp,mw_luft_temp)
stab_luft_feucht = standardabweichung(luft_feucht,mw_luft_feucht)
stab_druck = standardabweichung(druck,mw_druck)
stab_temp_druck = standardabweichung(temp_druck,mw_temp_druck)
stab_rasp = standardabweichung(rasp,mw_rasp)
print("Innentemperatur:\t%0.2f" % stab_temp1)
print("Gerätetemperatur 1:\t%0.2f" % stab_temp2)
print("Außentemperatur:\t%0.2f" % stab_temp3)
print("Gerätetemperatur 2:\t%0.2f" % stab_temp4)
print("Temperatur (Luft):\t%0.2f" % stab_luft_temp)
print("Luftfeuchtigkeit:\t%0.2f" % stab_luft_feucht)
print("Luftdruck:\t\t%0.2f" % stab_druck)
print("Temperatur (Druck):\t%0.2f" % stab_temp_druck)
print("Prozessor:\t\t%0.2f" % stab_rasp)
