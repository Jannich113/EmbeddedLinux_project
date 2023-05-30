#!/bin/bash


current_hour=$(date +%H)

if [ "$current_hour" == "12:00" ] || [ "$current_hour" == "24:00" ]; then
    echo "scheduled watering at: $current_hour"
    mosquitto_pub -h localhost -t remote/button/pushed -m "p" -u pi -P burgerking
fi

   
