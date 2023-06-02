
# Embedded Linux mini project - Group 21
This is the git repository for the Embedded linux project by group 21

## Authors
- [@Jannich113 ](https://github.com/Jannich113), Jannich H. Nielsen, janni18@student.sdu.dk
- [@philipmarschner](https://github.com/philipmarschner), Philip S. Marschner, phmar19@student.sdu.dk
- [@JacobBraendstrup](https://github.com/JacobBraendstrup), Jacob Brændstrup, jabra19@student.sdu.dk

## Repository Overview
The highlighted part is the main parts of the project: 

**ShellScript:** bash scripts used on the RPI for functional requirement with MQTT embedded  .

**html:** files for the apache2 server using php scripts and  logged data files.
- copy to /var/www/html  

***main.py*** - pico main file. 
- Flash throug Thonny IDE for micropython.

***esp8266_remote_v2.ino*** - esp8266 main file.
- Flash throug Arduino IDE
- requirement: add esp8266 bib
 
 


MQTT broker 
    - needs user name and passwd to allow for listeners
    - username: pi
    - passed: burgerking

    To run the MQTT broker in the background as a daemom
    - mosquitto -d

    To subscribe to a topicww
    - mosquitto_sub -d -t "topic" -u "username -P "passwd"

    To publish to a topic
    - mosquitto_pub -d -t "topic" -m "message" -u "username -P "passwd"

RPI 
    - address: 10.42.0.10 or 192.168.10.1

McWifi
    - passwd: burgerking

path to the web page data folder
 /var/www/html/plant_data


To run bash script in daemom without terminal session
    nohup ./script.sh &


links
    https://randomnerdtutorials.com/esp8266-and-node-red-with-mqtt/
    https://randomnerdtutorials.com/how-to-install-mosquitto-broker-on-raspberry-pi/
    
    https://thepi.io/how-to-use-your-raspberry-pi-as-a-wireless-access-point/

## Connections, usernames and passwords
The wired network connection is setup with a static IP address of 10.0.0.10
The wireless network connection is
* SSID: McWifi
* Password: burgerking

SSH connection
* User: waterio@<10.0.0.10 or 192.168.10.1>
* Password: Sunset

The sudo password for default user waterioip is
* Password: Sunset

The root user has been disabled, but password is
* Password: Napoli

MQTT broker
* User: pi
* Password: brugerking

## Usefull commands
Manually start pump controller
```bash
    /home/pi/ShellScripts/pump_controller.sh <plant_id> <serial_port>
```
Manually request pump start
```bash
    /home/pi/ShellScripts/water_plant.sh <plant_id>
```
Start manual water controll monitor
```bash
    /home/pi/ShellScripts/manual_water.sh <plant_id> <remote_id>
```
Start moinsture moniture
```bash
    /home/pi/ShellScripts/moisture_monitor.sh <plant_id> <soild_threshold>
```

## First time setup of new pi

Add health and network status monitor to Cron for logging every minute. Add periodic watering of each plant eg. plant 1 every 12 hours
```bash
    crontab -e
    # Add line to end of file
    * * * * * /home/pi/ShellScripts/health_monitor.sh
    # Add every that should be watered peroidicly, eg plant 1 ever 12 hours
    0 */12 * * * /home/pi/ShellScripts/water_plant.sh <plant_id>
```

Make sure that every script in /home/pi/ShellScripts are executable
```bash
    chmod 755 /home/pi/ShellScripts/<script>.sh
```

Add scripts for setting up system after reboot
```bash
    sudo nano /etc/rc.local
    # Add the following lines befoe the exit line
    sudo sh /home/pi/bin/boot.sh
    sh /home/pi/ShellScripts/waterio_launch.sh
```

## Add new plant to system
Add relationship between plant_id and serial port in /home/pi/ShellScripts/plant_id_to_serialport.sh
```bash
    nano /home/pi/ShellScripts/plant_id_to_serialport.sh
    # Add new translation of plant_id to serial port before last line containing "fi"
    elif [ $plant_id == <id>]
    then
        echo /dev/<serial port>
```


## Add new remote to system

To add a new remote to the system the file "esp8266_remote_v2.ino" has to be opened in the arduino IDE. The remote published directly to MQTT topic for button push and subscribes to MQTT topics for which LED should be turned on.

The topic naming is for example "remote/ID/green_led", where the id has to be replaced with a new id for the remote. This has to be done fore every topic in the file.

To turn on the LED from other bash script from the raspberry pi one could run run the command "mosquitto_pub -h <mqtt-host> -t remote/1/green_led -m "on" -u <mqtt-username> -P <mqtt-password". This will turn on the green led on remote with id 1. To turn it off one only has to replace the "on" message with "off".

The remote publishes to a mqtt topic everytime the button is pushed, for example to "remote/1/button_pushed". One can subscribe to this topic on the raspberry pi using "mosquitto_sub -h <mqtt-host> -t remote/1/button_pushed -u <mqtt-username> -P <mqtt-password>"

## Setting up Apache2 WebServer and Adding more plants webpages

Insure that Apache2 is installed, if not:

```bash
  sudo apt intall apache2
```
Next is to install php scripting 
```bash
  sudo apt intall php
```

Copy the **html** folder from this git repository, and replace the current html directory at the location: 
/var/www/ with this one.

Making the webserver user 'www-data' the owner of those files and granting the 'waterio' user write access to the files.
 ```bash
 cd /var/www
 sudo chown -R www-data.www-data html
 sudo chmod -R g+w html
 sudo usermod -a -G www-data waterio
```

Restart the RPI for the changes to take effect.

Now you should be able to goto the webpage:
```bash
  http://192.168.10.1/plant1.php
```
If more plants are added, you will have to clone the ***plant1.php*** and rename it accordingly to the current plant number x.
Ex: plantx.php, and make sure to update the csv file it reads from
```bash
  sudo cp /var/www/html/plant1.php /var/www/html/plantx.php 
  sudo nano /var/www/html/plantx.php
```
Find the line with ***csvFile = 'plantdatalog_1.csv'*** and change it to the plant number as well. Ex: $csvFile = 'plantdatalog_x.csv';

Now you should have access to Both plants, 1 and x
```bash
  http://192.168.10.1/plant1.php
  http://192.168.10.1/plantx.php
```
