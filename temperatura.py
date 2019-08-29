import serial
import datetime
import numpy
import smtplib
import time
import re
# Open serial port
ser = serial.Serial('/dev/ttyACM0', 9600)
time.sleep(1)
ser.flush()

# Trash the first data
for i in range(2):
	ser.readline()



# Email Body
username = 'user'
password = 'pass'
fromaddr = 'fromuser@domain'
toaddr = ['user@domain']
msg = """From: Arduino Temp Sensor <admin@domain>
To: Admins	<admins@domain>
Subject: ALERTA

Temperatura del site alta: """


# Main loop
while(True):
	
	# Read data and convert to temperature 
	num = re.search( r'([0-9]{2}\.[0-9]{2})', ser.readline())
	temp = (float(num.group(1)))
	today=datetime.datetime.now().strftime('%Y-%m-%d-%H:%M:%S')
	if  temp > 23:
		try:
			msg1 = msg + str(temp) + "   " + str(today)
			server = smtplib.SMTP('smtp.gmail.com:587')
			server.ehlo()
			server.starttls()
			server.ehlo()
			server.login(username,password)
			server.sendmail(fromaddr, toaddr, msg1)
			server.quit()
			time.sleep(5)
		except smtplib.SMTPException as e:
			print e
	else:
		try:
			file = "Temp: " + str(temp) + " Ok - " + str(today) + "\n"
			f = open("/root/temperatura.log","a")
			f.write(file)
			f.close()
			time.sleep(5)
		except Exception as e:
			print e
