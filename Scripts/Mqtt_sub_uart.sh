#!/bin/bash


# Set MQTT broker details
MQTT_BROKER="192.168.10.1"
MQTT_PORT="1883"
#MQTT_TOPIC="remote/button/pushed"
MQTT_TOPIC="start/pump"

DEVICE="/dev/ttyACM0"


uart_transmit() {
  local data="$1"
  echo "$data" > "$DEVICE"
}



start_pump_on_message() {
  local message=$1  

  if [[ "$message" == "start"]]; then
    uart_transmit "p"
  fi

}



request_data_after_delay() {
  local time_delay=$1
  sleep "$time_delay"
  uart_transmit "t"

}



mqtt_subs() {

  while read -r message; do
    start_pump_on_message "$message"
  done < <(mosquitto_sub -h "$MQTT_BROKER" -t "$MQTT_TOPIC" -u pi -P burgerking)

}

while true; do

  mqtt_subs &

  # request data with a sleep of 1 second
  request_data_after_delay 1 

done
