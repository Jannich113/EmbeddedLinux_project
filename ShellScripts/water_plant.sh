#!/bin/bash
PLANT_ID="$1"

mosquitto_pub -h 192.168.10.1 -t plant/$PLANT_ID/pump -m "start" -u pi -P burgerking