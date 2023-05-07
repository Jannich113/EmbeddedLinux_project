#!/bin/bash

# Set log file path
LOG_FILE="/path/to/log/file.log"

# Set MQTT topic and broker details
MQTT_BROKER="localhost"
MQTT_PORT="1883"



# Set the column key-value map
declare -A COLUMN_MAP=(
  ["red"]=3
  ["green"]=4
  ["yellow"]=5
)


# publish the state of all the leds to the esp 
for KEY in "${!COLUMN_MAP[@]}"; do
    MQTT_TOPIC="remote/led/$KEY"

    # Read the last row from the log file and extract the specified column value
    LOG_LINE=$(tail -n 1 "$LOG_FILE")
    COLUMN_NUMBER="${COLUMN_MAP[$KEY]}"
    COLUMN_VALUE=$(echo "$LOG_LINE" | awk -v col="$COLUMN_NUMBER" '{print $col}')

    # Publish the column value over MQTT
    mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -t "$MQTT_TOPIC" -m "$COLUMN_VALUE" -u "pi" -P "burgerking"
done