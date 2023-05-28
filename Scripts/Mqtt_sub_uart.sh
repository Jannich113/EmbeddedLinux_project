#!/bin/bash


# Set MQTT broker details
MQTT_BROKER="localhost"
MQTT_PORT="1883"
MQTT_TOPIC="remote/button/pushed"

DEVICE="/dev/ttyUSB0"


# function to transmit data over uart

uart_transmit() {
  local data="$1"
  echo "$data" > "$DEVICE"
}

# subscribe to topic 
mosquitto_sub -"$MQTT_BROKER" -p "$MQTT_PORT" -u "pi" -P "burgerking" -t "$MQTT_TOPIC" | 
while read MESSAGE; do

  if echo "$MESSAGE" | grep -q "single"; then
    #uart_transmit "s"
    echo "Single message received: $MESSAGE"
  fi
  
  # Check if the message contains "double"
  if echo "$MESSAGE" | grep -q "double"; then
    uart_transmit "p"
    echo "Double message received: $MESSAGE"
  fi
done


# insert -a between tee and log_file2.txt for append recieved data to log file
# instead of overwriting it 