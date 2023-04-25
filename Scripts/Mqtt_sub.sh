#!/bin/bash

# subscribe to topic "remote_controller"

mosquitto_sub -h 
"hostname/ip address" -t remote_controller | tee log_file2.txt

# insert -a between tee and log_file2.txt for append recieved data to log file
# instead of overwriting it 