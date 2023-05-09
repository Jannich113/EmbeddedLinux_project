#!/bin/bash


time_of_watering=$value1 
Hour=3600 



Detection_of_watering_per_hour() {
    current_time=$(date +%s)
    if [[ $((current_time - time_of_watering)) -ge Hour ]]; then
            echo "allowed watering"
            exit true
    else
        echo "NOT allowed watering"
        exit false
    fi
}
