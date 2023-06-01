#!/bin/bash
DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

log_file="monitoring_log.txt"

# Function to write output to log file
write_to_log() {
  echo -n "$1" >> "$log_file"
}

# Get current date and time
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
write_to_log "DATE: $current_datetime"

# Execute CPU load script
cpu_load_output=$(./cpu_load.sh)
write_to_log " CPU_LOAD: $cpu_load_output"

# Execute CPU temperature script
cpu_temp_output=$(./cpu_temp.sh)
write_to_log " CPU_TEMP: $cpu_temp_output"

# Execute free RAM script
free_ram_output=$(./available_mem.sh)
write_to_log " FREE_MEM: $free_ram_output"

# Execute free disk space script
free_disk_space_output=$(./disk_space.sh)
write_to_log " FREE_DISK: $free_disk_space_output"

# Execute network bytes transferred script
network_bytes_output=$(./data_transfered.sh eth0)
write_to_log " eth0: $network_bytes_output"

# Execute network bytes transferred script
network_bytes_output=$(./data_transfered.sh wlan0)
write_to_log " wlan0: $network_bytes_output"
  echo "" >> "$log_file"