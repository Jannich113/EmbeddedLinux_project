#!/bin/bash


current_hour=$(date +%H)

if [ "$current_hour" == "12:00" ] || [ "$current_hour" == "24:00" ]; then
    echo "scheduled watering at: $current_hour"
    exit true
else
    exit false
fi

   
