#!/bin/bash
if [ -z "$2" ]; then
  echo "Please provide both a plant_id and remote_id."
  echo "manual_water.sh <plant_id> <remote_id>"
  exit 1
fi

DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

PLANT_ID=$1
REMOTE_ID=$2


# MQTT prameters
MQTT_IP="192.168.10.1"
MQTT_USR=pi
MQTT_PSSWD=burgerking
MQTT_BUTTON_TOPIC=remote/$REMOTE_ID/button_pushed
MSG_BUTTON="pushed"
LAST_TIME=0

while true
do
    mosquitto_sub -h $MQTT_IP -t $MQTT_BUTTON_TOPIC -u $MQTT_USR -P $MQTT_PSSWD -F "%t %p"| while read -r PAYLOAD
    do
        TOPIC=$(echo "$PAYLOAD" | cut -d ' ' -f 1)
        MSG=$(echo "$PAYLOAD" | cut -d ' ' -f 2-)

        # Store plant alarm status
        if [[ $TOPIC == $MQTT_BUTTON_TOPIC ]]
        then
            if [[ $MSG == $MSG_BUTTON ]]
            then
                TIME=$(date +%s)
                TIME_DIFF=$(($TIME - $LAST_TIME))
                if [[ $TIME_DIFF -gt 2 ]]
                then
                    LAST_TIME=$TIME
                    sh ./water_plant.sh $PLANT_ID
                fi
            fi
        fi
    done
    sleep 1 
done 
