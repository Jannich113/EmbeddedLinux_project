#!/bin/bash
if [ -z "$2" ]; then
  echo "Please provide a plant_id soil_threshold."
  echo "moisture_monitor.sh <plant_id> <soild_threshold>"
  exit 1
fi

DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

PLANT_ID=$1
SOIL_THRESHOLD=$2


# MQTT prameters
MQTT_IP="192.168.10.1"
MQTT_USR=pi
MQTT_PSSWD=burgerking
MQTT_BUTTON_TOPIC=plant/$PLANT_ID/moisture
LAST_TIME=0

while true
do
    mosquitto_sub -h $MQTT_IP -t $MQTT_BUTTON_TOPIC -u $MQTT_USR -P $MQTT_PSSWD -F "%t %p"| while read -r PAYLOAD
    do
        TOPIC=$(echo "$PAYLOAD" | cut -d ' ' -f 1)
        MSG=$(echo "$PAYLOAD" | cut -d ' ' -f 2-)
        if [[ $MSG -lt $SOIL_THRESHOLD ]]
        then
            TIME=$(date +%s)
            TIME_DIFF=$(($TIME - $LAST_TIME))
            if [[ $TIME_DIFF -gt 3600 ]]
            then
               
                LAST_TIME=$TIME
                
                sh ./water_plant.sh $PLANT_ID
            fi
        fi
    done
    sleep 1
done 
