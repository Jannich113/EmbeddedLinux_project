#!/bin/bash


# Set MQTT broker details
MQTT_BROKER="localhost"
MQTT_PORT="1883"
MQTT_TOPIC="remote/button/pushed"

# subscribe to topic 

mosquitto_sub -"$MQTT_BROKER" -p "$MQTT_PORT" -u "pi" -P "burgerking" -t "$MQTT_TOPIC" | 
while read MESSAGE; do

    if echo "$MESSAGE" | grep -q "single"; then
    # Print the received message to the console
    echo "Single message received: $MESSAGE"
  fi
  
  # Check if the message contains "double"
  if echo "$MESSAGE" | grep -q "double"; then
    # Print the received message to the console
    echo "Double message received: $MESSAGE"
  fi
done


# insert -a between tee and log_file2.txt for append recieved data to log file
# instead of overwriting it 