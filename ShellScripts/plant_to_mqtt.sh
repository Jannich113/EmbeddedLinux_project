#!/bin/bash


#PICO_DEVICE="/dev/ttyACM0"

if [ -z "$2" ]; then
  echo "Please provide both a plant_id and remote_id."
  echo "pump_controller.sh <plant_id> <remote_id>"
  exit 1
fi


PLANT_ID="$1"
REMOTE_ID="$2"
SERIAL_PORT="$3"

MQTT_IP="192.168.10.1"



KEYS=(plant/$PLANT_ID/plant_alarm plant/$PLANT_ID/pump_alarm plant/$PLANT_ID/moisture plant/$PLANT_ID/light _)
#START_INDEX=2
#END_INDEX=4

while true 
do
  
  while read -r line < $SERIAL_PORT
  do
    
    IFS=',' read -ra values <<< "$line"


    #echo "$line"
  
    for i in "${!values[@]}"; do
      
      MQTT_TOPIC="${KEYS[$i]}"
      
      
      # Publish the column value over MQTT
      mosquitto_pub -h $MQTT_IP -t $MQTT_TOPIC -m ${values[$i]} -u pi -P burgerking
    done
    done


done