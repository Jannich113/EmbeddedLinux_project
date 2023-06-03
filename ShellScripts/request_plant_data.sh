#!/bin/bash

SERIAL_PORT="$1"

while true
do

    echo "t" > "$SERIAL_PORT"

    sleep 1

done