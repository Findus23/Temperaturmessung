#!/bin/sh
date > /home/pi/log/mitternacht.log
pushbullet_api_key=$(cat /home/pi/Temperaturmessung/Fremddateien/pushbullet_settings.txt | head -n 1)
pushbullet_device=$(cat /home/pi/Temperaturmessung/Fremddateien/pushbullet_settings.txt | tail -n 1)
cd /home/pi/Temperaturmessung
sudo -H -u pi git pull origin master >> /home/pi/log/mitternacht.log 2>&1
cp -r /home/pi/Temperaturmessung/Webinterface /var/www
echo "\n\n\n" >> /home/pi/log/mitternacht.log
sudo apt-get update >> /home/pi/log/mitternacht.log
echo "\n\n\n" >> /home/pi/log/mitternacht.log
sudo apt-get dist-upgrade -y >> /home/pi/log/mitternacht.log
echo "\n\n\n" >> /home/pi/log/mitternacht.log
sudo apt-get autoremove -y >> /home/pi/log/mitternacht.log
echo "\n\n\n" >> /home/pi/log/mitternacht.log
sudo apt-get clean >> /home/pi/log/mitternacht.log

date >> /home/pi/log/mitternacht.log
/home/pi/Temperaturmessung/Fremddateien/pushbullet_cmd.py $pushbullet_api_key file $pushbullet_device /home/pi/log/mitternacht.log
sudo /sbin/shutdown -r +5
