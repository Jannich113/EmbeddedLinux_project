#!/bin/bash
PLANT_ID="$1"
MQTT_PLANT_WATERING_LOG=plant/$PLANT_ID/watering_log

mosquitto_pub -h 192.168.10.1 -t plant/$PLANT_ID/pump -m "start" -u pi -P burgerking
