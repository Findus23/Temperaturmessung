# -*- coding: utf-8 -*-
import csv
def offnen(datei):
	with open(datei) as filein:
		reader =csv.reader(filein, quoting=csv.QUOTE_NONNUMERIC)
		global temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp
		temp1,temp2,temp3,temp4,luft_temp,luft_feucht,druck,temp_druck,rasp = zip(*reader)

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


offnen("vorbereitet.csv")
print "------Mittelwerte------"
print "Innentemperatur:\t%0.2f" % mittelwert(temp1)
print "Gerätetemperatur 1:\t%0.2f" % mittelwert(temp2)
print "Außentemperatur:\t%0.2f" % mittelwert(temp3)
print "Gerätetemperatur 2:\t%0.2f" % mittelwert(temp4)
print "Temperatur (Luft):\t%0.2f" % mittelwert(luft_temp)
print "Luftfeuchtigkeit:\t%0.2f" % mittelwert(luft_feucht)
print "Luftdruck:\t\t%0.2f" % mittelwert(druck)
print "Temperatur (Druck):\t%0.2f" % mittelwert(temp_druck)
print "Prozessor:\t\t%0.2f" % mittelwert(rasp)
print "------Minimum-Maximum------"
print "Innentemperatur:\t" + str(minmax(temp1)[0]) + "\t" + str(minmax(temp1)[1])
print "Gerätetemperatur 1:\t" + str(minmax(temp2)[0]) + "\t" + str(minmax(temp2)[1])
print "Außentemperatur:\t" + str(minmax(temp3)[0]) + "\t" + str(minmax(temp3)[1])
print "Gerätetemperatur 2:\t" + str(minmax(temp4)[0]) + "\t" + str(minmax(temp4)[1])
print "Temperatur (Luft):\t" + str(minmax(luft_temp)[0]) + "\t" + str(minmax(luft_temp)[1])
print "Luftfeuchtigkeit:\t" + str(minmax(luft_feucht)[0]) + "\t" + str(minmax(luft_feucht)[1])
print "Luftdruck:\t\t" + str(minmax(druck)[0]) + "\t" + str(minmax(druck)[1])
print "Temperatur (Druck):\t" + str(minmax(temp_druck)[0]) + "\t" + str(minmax(temp_druck)[1])
print "Prozessor:\t\t" + str(minmax(rasp)[0]) + "\t" + str(minmax(rasp)[1])
