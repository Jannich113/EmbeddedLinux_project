#!/bin/bash

# publish message to topic "remote_controller" and reads the last row of a log file

line=$(tail -n 1 log_file.txt)
mosquitto_pub -h 
"hostname/ip address" -t remote_controller -m "$line"
