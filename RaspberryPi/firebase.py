import pyrebase
import urllib2
from json import load
from urllib2 import urlopen
import RPi.GPIO as GPIO
from time import sleep

# Initialize Firebase
config = {
  "apiKey": "your-api-key",
  "authDomain": "your-authDomain.firebaseapp.com",
  "databaseURL": "https://your-databaseURL.firebaseio.com",
  "storageBucket": "your-storageBucket.appspot.com"
}
firebase = pyrebase.initialize_app(config)

db = firebase.database()

# send the Raspberry's public ip to Firebase
publicIp = load(urlopen('http://jsonip.com'))['ip']
db.update({"Ip": publicIp})

# listen for turn on/off the LED
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(4, GPIO.OUT)

while True:
	led = db.child("Led").get()
	
	if led.val() == 'On':
		GPIO.output(4, 1)
	else:
		GPIO.output(4, 0)
		
	sleep(1)
