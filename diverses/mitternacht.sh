#!/bin/sh
pushbullet_api_key=$(cat /home/pi/Temperaturmessung/Fremddateien/pushbullet_settings.txt | head -n 1)
pushbullet_device=$(cat /home/pi/Temperaturmessung/Fremddateien/pushbullet_settings.txt | tail -n 1)
cd /home/pi/Temperaturmessung
sudo -H -u pi git pull origin master
# cp /home/pi/Temperaturmessung/Webinterface /var/www
sudo apt-get update
sudo apt-get dist-upgrade > /home/pi/log/mitternacht.log
/home/pi/Temperaturmessung/Fremddateien/pushbullet_cmd.py $pushbullet_api_key file $pushbullet_device /home/pi/log/mitternacht.log
/sbin/shutdown -r +5
