#!/bin/bash

# Get total memory and free memory with the free command
total=$(free -m | awk '/Mem:/ {print $2}')
free=$(free -m | awk '/Mem:/ {print $4}')
free_percent=$(awk "BEGIN {printf \"%.2f\", ($free / $total) * 100}")

echo "$free_percent"
