#!/bin/bash
if [ -z "$3" ]; then
  echo "Please provide both a plant_id, remote_id and soil_level threshold."
  echo "Comm_with_esp.sh <plant_id> <remote_id> <soil_threshold>"
  exit 1
fi

PLANT_ID="$1"
REMOTE_ID="$2"
SOIL_THRESHOLD="$3"

MQTT_IP="192.168.10.1"
topic1=plant/$PLANT_ID/plant_alarm
topic2=plant/$PLANT_ID/pump_alarm
topic3=plant/$PLANT_ID/moisture

waterAlarm=0
pumpAlarm=0
soil_level=100

while true
do
    mosquitto_sub -h $MQTT_IP -t $topic1 -t $topic2 -t $topic3 -u pi -P burgerking -F "%t %p" | while read -r payload
    do
        
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        if [[ $topic == $topic1 ]]
        then
            waterAlarm=$msg
        fi

        if [[ $topic == $topic2 ]]
        then
            pumpAlarm=$msg
        fi

        if [[ $topic == $topic3 ]]
        then
            soil_level=$msg
        fi
        
        # send a red led, turn off green
        if [[ $waterAlarm == 1 || $pumpAlarm == 1 ]]
        then
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/red_led -m "on" -u pi -P burgerking
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/green_led -m "off" -u pi -P burgerking
            
            
        else
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/red_led -m "off" -u pi -P burgerking
        fi


         # send yellow and turn off green    
        if [[ $soil_level -lt $SOIL_THRESHOLD ]]
        then    
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/yellow_led -m "on" -u pi -P burgerking
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/green_led -m "off" -u pi -P burgerking
            
        else
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/yellow_led -m "off" -u pi -P burgerking

        fi

        # send a green value, turn off red and yellow
        if [[ $waterAlarm == 0 && $pumpAlarm == 0 && $soil_level -gt $SOIL_THRESHOLD ]] 
        then
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/red_led -m "off" -u pi -P burgerking
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/green_led -m "on" -u pi -P burgerking
            mosquitto_pub -h $MQTT_IP -t remote/$REMOTE_ID/yellow_led -m "off" -u pi -P burgerking
            
        fi
       

    done
    sleep 1  
done 
