import pyrebase
import urllib2
from json import load
from urllib2 import urlopen
import RPi.GPIO as GPIO
from time import sleep

config = {
  "apiKey": "your-apiKey",
  "authDomain": "your-authDomain.firebaseapp.com",
  "databaseURL": "https://your-databaseURL.firebaseio.com",
  "storageBucket": "your-storageBucket.appspot.com"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()
publicIp = load(urlopen('http://jsonip.com'))['ip']
db.update({"Ip": publicIp})

print "public ip: ", publicIp

# accende/spegne il Led collegato al pin 4
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(4, GPIO.OUT)

def stream_handler(message):
    led = db.child("Led").get()
    print "Led: ", led.val()
	
    if led.val() == 'On':
	GPIO.output(4, 1)
    else:
	GPIO.output(4, 0)

my_stream = db.child("Led").stream(stream_handler)
#my_stream.close()
