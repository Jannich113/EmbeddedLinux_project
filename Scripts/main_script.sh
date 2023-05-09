#!/bin/bash

# this is the main bash script that combines all the functionality contained in the subscripts.

# defines 
time_of_watering = 0 
isWateringAllowed=false
scheduled_watering=false

while true
do

    # function for detection of watering per hour.
    #   - calling a script and passing a value to it
    ./Detection_of_watering_per_hour.sh $time_of_watering
    isWateringAllowed=$?
    echo "watering allowed: $isWateringAllowed"



    # function for scheduled watering pump run
    ./water_pump_run_schedule.sh

    scheduled_watering=$?
    echo "scheduled watering at: $scheduled_watering"


    # function for 




done

echo "out of the loop"
