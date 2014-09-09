#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
from datetime import datetime
import requests
from wunderground_pwd import * # password und wu_id

innentemp_c=float(sys.argv[1])
gertemp1_c=float(sys.argv[2])
bodentemp_c=float(sys.argv[3])
gertemp2_c=float(sys.argv[4])
lufttemp_c=float(sys.argv[5])
luftfeucht=float(sys.argv[6])
aussentemp_c=float(sys.argv[7])
druck=float(sys.argv[8])
processor_c=float(sys.argv[9])
qualitat=float(sys.argv[10])
innentemp = 9.0/5.0 * innentemp_c + 32
gertemp1 = 9.0/5.0 * gertemp1_c + 32
bodentemp = 9.0/5.0 * bodentemp_c + 32
gertemp2 = 9.0/5.0 * gertemp2_c + 32
lufttemp = 9.0/5.0 * lufttemp_c + 32
aussentemp = 9.0/5.0 * aussentemp_c + 32
processor = 9.0/5.0 * processor_c + 32
druck_hg = druck * 0.02956
zeit=datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
pfad="http://rtupdate.wunderground.com/weatherstation/updateweatherstation.php?ID=" + wu_id + "&PASSWORD=" + password + "&dateutc=" + zeit + "&tempf=" + str(aussentemp) + "&temp2f=" + str(bodentemp) + "&temp2f=" + str(lufttemp) + "&baromin=" + str(druck_hg) + "&humidity=" + str(luftfeucht) + "&indoortempf=" + str(innentemp) + "&softwaretype=raspberry_pi&action=updateraw&realtime=1&rtfreq=30"
r = requests.get(pfad)
if (r.text == "success\n") & (r.status_code == 200):
	print("ok")
else:
	print("Ein Fehler ist aufgetreten: " + r.text)
