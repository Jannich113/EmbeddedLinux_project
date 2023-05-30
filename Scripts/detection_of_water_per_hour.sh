#!/bin/bash

last_accept_time="0"


Detection_of_watering_per_hour() {
    local message=$1
    local current_time=$(date +%s)
    

    if (( current_time - last_accept_time >= 3600 )); then
    
        last_accept_time=$current_time
        mosquitto_pub -h localhost -t start/pump -m start -u pi -P burgerking
    fi
    
    ls -l
}

mqtt_subs() {

    local topic="request/start/pump"

    while -read messege; do
    Detection_of_watering_per_hour() "$message"
    done < <(mosquitto_sub -h <localhost> -t "$topic" -u pi -P burgerking)

}

