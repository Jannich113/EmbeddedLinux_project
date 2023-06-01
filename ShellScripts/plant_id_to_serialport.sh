#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide a plant_id as an argument."
  echo "plant_id_to_serialport.sh <plant_id>"
  exit 1
fi

# Load plant_id
plant_id="$1"

# Define plant id to serial port relationship
if [ $plant_id == 1 ]
then
    echo /dev/ttyACM0
#elif [ $plant_id == <id>]
#then
#   echo /dev/<serial port>
fi