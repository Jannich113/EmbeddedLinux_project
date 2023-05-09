#!/bin/bash

soil_threshold=500 # set the soil threshold value
allowed_watering=$val # set the allowed watering flag to true

function soil_moisturing() {
    if [ $(moisture) -lt $soil_threshold ]; then
        if [ "$allowed_watering" = true ]; then
            exit true
        fi
    fi
}

function moisture() {
    # read the value from column 3 of log.csv
    value=$(awk -F',' '{print $3}' log.csv | tail -1)

    # return the value
    echo "$value"
}



soil_moisturing # call the soil_moisturing function
