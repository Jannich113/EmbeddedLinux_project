
This is the git repository for the Embedded linux project by group 21

pico_watering_controller.py 
    - main file for pico.
    - flash throug Thonny IDE for micropython.

esp8266_remote.ino
    - main file for esp8266.
    - flash throug Arduino IDE 
        - requirement: add esp8266 bib 

MQTT broker 
    - needs user name and passwd to allow for listeners
    - username: pi
    - passed: burgerking

    To run the MQTT broker in the background as a daemom
    - mosquitto -d

    To subscribe to a topic
    - mosquitto_sub -d -t "topic" -u "username -P "passwd"

    To publish to a topic
    - mosquitto_pub -d -t "topic" -m "message" -u "username -P "passwd"


RPI 
    - address: 10.0.0.10 or 192.168.10.1

McWifi
    - passwd: burgerking



links
    https://randomnerdtutorials.com/esp8266-and-node-red-with-mqtt/
    https://randomnerdtutorials.com/how-to-install-mosquitto-broker-on-raspberry-pi/
    


