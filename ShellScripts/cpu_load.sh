#!/bin/bash

# Get the CPU load percentage from the top command
cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

echo "$cpu_load"