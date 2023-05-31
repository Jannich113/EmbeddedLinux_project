
# Embedded Linux mini project - Group 21
This is the git repository for the Embedded linux project by group 21


## Repository Overview
main.py 
    - main file for pico.
    - flash throug Thonny IDE for micropython.


esp8266_remote_v2.ino
    - main file for esp8266.
    - flash throug Arduino IDE 
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

The sudo password for user pi is
* Password: Sunset

MQTT broker
* User: pi
* Password: brugerking

## First time setup of new pi

Add health and network status monitor to Cron for logging every minute. Add periodic watering of each plant eg. plant 1 every 12 hours
```bash
    crontab -e
    # Add line to end of file
    * * * * * /home/pi/ShellScripts/health_monitor.sh
    # Add every that should be watered peroidicly, eg plant 1 ever 12 hours
    0 */12 * * * /home/pi/ShellScripts/water_plant.sh <plant_id>
```


