host=$(cat /home/pi/Temperaturmessung/diverses/ftp_settings.txt | head -n 1)
benutzername=$(cat /home/pi/Temperaturmessung/diverses/ftp_settings.txt | head -n 2 | tail -n 1)
passwort=$(cat /home/pi/Temperaturmessung/diverses/ftp_settings.txt | tail -n 1)
cd /home/pi/Temperaturmessung/
ncftpput -V -m -u $benutzername -p $passwort $host / dygraphs.csv text_ws.txt
