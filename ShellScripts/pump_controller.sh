#!/bin/bash
if [ -z "$2" ]; then
  echo "Please provide both a plant_id and serial port."
  echo "pump_controller.sh <plant_id> <serial_port>"
  exit 1
fi

# Read input arguments
PLANT_ID="$1"
SERIAL_PORT="$2"

# MQTT prameters
MQTT_IP="192.168.10.1"
MQTT_USR=pi
MQTT_PSSWD=burgerking
MQTT_PUMP_TOPIC=plant/$PLANT_ID/pump
MQTT_PUMP_ALARM_TOPIC=plant/$PLANT_ID/pump_alarm
MQTT_PLANT_ALARM_TOPIC=plant/$PLANT_ID/plant_alarm
MSG_START="start"
PUMP_CMD="p"
ALARM="1"
NO_ALARM="0"

PUMP_ALARM=$ALARM
PLANT_ALARM=$ALARM


while true
do
    mosquitto_sub -h $MQTT_IP -t $MQTT_PUMP_TOPIC -t $MQTT_PLANT_ALARM_TOPIC -t $MQTT_PUMP_ALARM_TOPIC -u $MQTT_USR -P $MQTT_PSSWD -F "%t %p"| while read -r PAYLOAD
    do
        TOPIC=$(echo "$PAYLOAD" | cut -d ' ' -f 1)
        MSG=$(echo "$PAYLOAD" | cut -d ' ' -f 2-)

        # Store plant alarm status
        if [[ $TOPIC == $MQTT_PLANT_ALARM_TOPIC ]]
        then
            PLANT_ALARM=$MSG
        fi

        # Store pump alarm status
        if [[ $TOPIC == $MQTT_PUMP_ALARM_TOPIC ]]
        then
            PUMP_ALARM=$MSG
        fi

        # Send pump command to plant, if no ALARM
        if [[ $MSG == $MSG_START ]] 
        then
            if [[ $PUMP_ALARM == $NO_ALARM && $PLANT_ALARM == $NO_ALARM ]]
            then
                echo "$PUMP_CMD" > $SERIAL_PORT
            fi
        fi
    done
    sleep 1  # Wait 1 seconds until reconnection
done # &  # Discomment the & to run in background (but you should rather run THIS script in background)
