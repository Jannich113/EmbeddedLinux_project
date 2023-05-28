#!/bin/bash

#This script is for transmitten data to the esp module and storing the recieved 
# data into a log file

# Set log file path
#LOG_FILE="/path/to/log/file.log"

DEVICE = "/dev/ttyUSB0"

# Set MQTT topic and broker details
MQTT_BROKER="localhost"
MQTT_PORT="1883"

# log file for storing data
LOG_FILE="/var/www/html/plant_data/datalog.csv"

THRESHOLD_Moistore=60
THRESHOLD_Waterlevel=60

# Function for logging data
Data_logger() {
  local data="$1"
  # save dato to log file
  echo "$data" >> "$LOG_FILE"

}





#topic keys
KEYS=("remote/led/red" "remote/led/green" "remote/led/yellow")
#START_INDEX=2
#END_INDEX=4

while read -r line; do
  # read comma seperated values
  IFS=',' read -ra values <<< "$line"

  # saves the whole string into log file
  Data_logger "$line"

  # publish the state of all the leds to the esp 
  # for ((i = START_INDEX - 1; i < END_INDEX; i++)); do
  for i in "${!values[@]}"; do

    MQTT_TOPIC="${$KEYS[$i]}"
    # Publish the column value over MQTT
    mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -t "$MQTT_TOPIC" -m "$values[$i]" -u "pi" -P "burgerking"
  done
done < "$DEVICE"