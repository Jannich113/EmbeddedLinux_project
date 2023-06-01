#!/bin/bash

# Get CPU temperature from the thermal file
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
cpu_temp=$(awk -v temp="$cpu_temp" 'BEGIN{ printf "%.2f", temp/1000 }')

echo "$cpu_temp"
