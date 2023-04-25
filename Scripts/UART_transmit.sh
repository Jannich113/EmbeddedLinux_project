#!/bin/bash

# transmit data over uart
cat /path/to/log/file > /dev/ttyUSB0

# empty log file
echo "" > /path/to/log/file
