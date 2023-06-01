#!/bin/bash

MQTT_IP="192.168.10.1"
MQTT_TOPIC_GREEN="remote/led/green"
MQTT_TOPIC_RED="remote/led/red"
MQTT_TOPIC_YELLOW="remote/led/yellow"

MQTT_MESSAGE_ON="on"
MQTT_MESSAGE_OFF="off"
MQTT_SLEEP=1
USER=pi
PASSWORD=burgerking

mosquitto_sub -h $MQTT_IP -t "remote/button/pushed" -u pi -P burgerking |
while IFS= read -r message
do
    mosquitto_sub -h $MQTT_IP -t "remote/button/pushed" -u pi -P burgerking | while read -r payload
    do
        
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        if [["$msg" == "single"]]; then
            echo "Rx in single MQTT: ${msg}"
            mosquitto_pub -h $MQTT_IP -u pi -P burgerking -t remote/led/green -m "off"

        else
            echo "Rx in double MQTT: ${msg}"
            mosquitto_pub -h $MQTT_IP -u pi -P burgerking -t remote/led/green -m "on"

        fi


        #echo "Rx MQTT: ${msg}"
        #p=$(echo "$msg" | jq '.property')
        echo "Extracted property: $p for $topic"
    done
done