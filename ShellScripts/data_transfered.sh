#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Check if network interface argument is provided
if [ -z "$1" ]; then
  echo "Please provide a network interface as an argument."
  exit 1
fi

interface="$1"

# Get the number of bytes transferred for the network interface
bytes_transferred=$(ifconfig $interface | grep RX | grep bytes | awk '{print $5}')
bytes_receive=$(ifconfig $interface | grep TX | grep bytes | awk '{print $5}')

echo "RX: $bytes_transferred TX: $bytes_receive"
