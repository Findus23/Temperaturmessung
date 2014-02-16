#!/usr/bin/python
# (c) by hakermania http://ubuntuforums.org/showthread.php?t=1472520&p=12104667#post12104667

import os, re
import sys
import smtplib
import passwort # eigene Passwoerter in getrennter Datei
 
#from email.mime.image import MIMEImage
from email import encoders
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.MIMEText import MIMEText

 
SMTP_SERVER = 'mail.gmx.net'
SMTP_PORT = 587

sender = passwort.sender
password = passwort.password
 
recipient = sys.argv[1]
subject = ''
message = sys.argv[3]
 
def main():
    msg = MIMEMultipart()
    msg['Subject'] = sys.argv[2]
    msg['To'] = recipient
    msg['From'] = "Raspberry Pi <" + sender + ">"
    
    
    part = MIMEText('text', "plain")
    part.set_payload(message)
    msg.attach(part)
    
    session = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
 
    session.ehlo()
    session.starttls()
    session.ehlo
    
    session.login(sender, password)

    fp = open(sys.argv[4], 'rb')
    msgq = MIMEBase('audio', 'audio')
    msgq.set_payload(fp.read())
    fp.close()
    # Encode the payload using Base64
    encoders.encode_base64(msgq)
    # Set the filename parameter
    filename=sys.argv[4]
    msgq.add_header('Content-Disposition', 'attachment', filename=filename)
    msg.attach(msgq)
    # Now send or store the message
    qwertyuiop = msg.as_string()



    session.sendmail(sender, recipient, qwertyuiop)
    
    session.quit()
 
if __name__ == '__main__':
    main()
