#!/bin/bash
if [ -z "$4" ]
then
    echo "Please provide both a plant_id, serial port and remote_id. Soil threshold is optional"
    echo "pump_controller.sh <plant_id> <serial port><remote_id> <soil_threshold>"
    exit 1
fi

PLANT_ID="$1"
SERIAL_PORT="$2"
SOIL_THRESHOLD="$3"
REMOTE_ID="$4"




(trap 'kill 0' SIGINT; ./remote_LED_controller.sh $PLANT_ID $REMOTE_ID $SOIL_THRESHOLD & ./request_plant_data.sh $SERIAL_PORT & ./moisture_monitor.sh $PLANT_ID $SOIL_THRESHOLD & ./pump_controller.sh $PLANT_ID $SERIAL_PORT & ./manual_water.sh $PLANT_ID $REMOTE_ID & ./plant_to_mqtt.sh $PLANT_ID $REMOTE_ID $SERIAL_PORT & ./log_data_to_csv.sh $PLANT_ID $REMOTE_ID)


