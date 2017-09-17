# Domotic Lab

Domotic Lab is a project whose purpose is:

  - remotely read, from a browser and/or an iOS app, the values of temperature and barometric pressure of the Adafruit BMP280 sensor connected to a Raspberry Pi 3 placed in a room

  - remotely turn on/off from a browser and/or an iOS app a LED (potentially any appliance) connected to the same Raspberry Pi 3 above

### How does it work?
The Raspberry Pi 3 is connected to an Adafruit BMP280 sensor and a LED.
The Adafruit BMP280 sensor can measure temperature and barometric pressure.

When the Raspberry boots up, the script [firebase.py] is launched from the script [startup.sh] that is executed from the file /etc/rc.local as follow:
```sh
$ nano /etc/rc.local

#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

/home/pi/DomoticLab/startup.sh

exit 0
```

Every 15 minutes the Raspberry sends sensor data to the Firebase Realtime Database where they are stored. To do this I edited the contrab file as below where the script [bmp280.py] is executed every 15 minutes.
 ```sh
$ crontab -e

# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

# measure temperature and barometric pressure every 15min and store data on Firebase Realtime Database
 0 * * * * python /home/pi/DomoticLab/bmp280.py
15 * * * * python /home/pi/DomoticLab/bmp280.py
30 * * * * python /home/pi/DomoticLab/bmp280.py
45 * * * * python /home/pi/DomoticLab/bmp280.py
 ```
 
We can read the sensor data and receive every update in real time from whether a browser or the iOS app. Data is synced across all clients (at the same time up to 100 clients for free) in real time thanks to the Firebase Realtime Database.

When the Raspberry boots up, I save the Raspberry's public ip and store it on the Firebase's database (see [firebase.py]). This might be useful if a decide to install a Web Server or other services on my Raspberry Pi.

### Components used
- Raspberry Pi 3 with the Raspbian Jessie
- Adafruit BMP280 sensor, wires, a breadboard and a LED
- An account with an active Project on Firebase Realtime Database
- I used iOS and WEB Firebase's SDKs but you are free to use also Android or JavaScript Firebase’s SDKs.

### Pinouts
The Adafruit BMP280 sensor talk to the Raspberry using I2C, so SCK pin is connected to GPIO.BCM pin 2 and SDI pin is connected to GPIO.BCM pin 3 of the Raspberry.
LED is connected on GPIO.BCM pin 4 of the Raspberry.

### Important!
Before run this project, be sure to add your Firebase’s project config data where needed ([firebase.py] and [DomoticLab.html]), and if you play with iOS then add your GoogleService-Info.plist in your Xcode Project otherwise it will not work.

Furthermore if you like me choose to use I2C, remind to add the 2 lines above on /boot/config.txt
```sh
dtparam=i2c_arm=on
dtparam=i2s=on
```

and the 2 lines above on /etc/modules
```sh
i2c-dev
i2c-bcm2708
```

otherwise the Raspberry may not find the Adafruit BMP280 sensor.

### Todos
I'm looking further for
 - add speak feature to the Raspberry
 - add more sensors

### License

Copyright (c) 2017 Riccardo Manoni

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [DomoticLab.html]: <https://github.com/RiccardoManoni/DomoticLab/blob/master/web/DomoticLab.html>
   [firebase.py]: <https://github.com/RiccardoManoni/DomoticLab/blob/master/RaspberryPi/firebase.py>
   [bmp280.py]: <https://github.com/RiccardoManoni/DomoticLab/blob/master/RaspberryPi/bmp280.py>
   [startup.sh]: <https://github.com/RiccardoManoni/DomoticLab/blob/master/RaspberryPi/startup.sh>