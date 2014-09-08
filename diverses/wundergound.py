#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from datetime import datetime
import requests
#import wunderground_pwd # password und wu_id
wu_id=""
password=""


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
innentemp = 9.0/5.0 * Innentemp_c + 32
gertemp1 = 9.0/5.0 * gertemp1_c + 32
bodentemp = 9.0/5.0 * bodentemp_c + 32
gertemp2 = 9.0/5.0 * gertemp2_c + 32
lufttemp = 9.0/5.0 * lufttemp_c + 32
aussentemp = 9.0/5.0 * aussentemp_c + 32
processor = 9.0/5.0 * processor_c + 32
druck_hg = druck * 0.02961339710085
zeit=datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
pfad="http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?ID=" + wu_id + "&PASSWORD=" + password + "&dateutc=" + zeit + "&tempf=" + aussentemp + "&temp2f=" + bodentemp + "&temp2f=" + lufttemp + "&baromin=" + druck_hg + "&humidity=" + luftfeucht + "&indoortempf=" + innentemp + "&softwaretype=raspberry_pi&action=updateraw"
r = requests.get(pfad)


 #       conn = httplib.HTTPConnection("rtupdate.wunderground.com")
#        path = "/weatherstation/updateweatherstation.php?ID=" + stationid + "&PASSWORD=" + password + "&dateutc=" + str(datetime.utcnow()) + "&tempf=" + str(temp) + "&humidity=" + str(humidity) + "&softwaretype=RaspberryPi&action=updateraw"
#

#	echo "$uhrzeit_lang,${temp1_r},${temp2_r},${temp3_r},${temp4_r},${luft_temp_r},${luft_feucht_r},${temp_druck_r},${druck_r},${rasp},${qualitat}" >/home/pi/Temperaturmessung/text_ws.txt # Daten für
