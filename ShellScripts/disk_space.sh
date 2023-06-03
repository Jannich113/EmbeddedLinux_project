#!/bin/bash

# Get free disk space percentage
# Use df with human readable parameter to get percentage of usage of root (/)
# Use awk to extract value
# Remove leading space with sed
free_space_percent=$(df -h --output=pcent / | awk 'NR==2{print substr($0, 1, length($0)-1)}'| sed 's/ //')
used_space_percent=$((100 - free_space_percent))


echo "$used_space_percent"
