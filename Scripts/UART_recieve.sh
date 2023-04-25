#!/bin/bash


# read uart comm and separate data string by comma

stty -F /dev/ttyUSB0 raw
stty -F /dev/ttyUSB0 echo

while read -rs -n 1 c && [ [ $c != 'q' ]]
do 
    if [ $c == ',' ]
    then 
        echo "comma detected"
    fi

done < /dev/ttyUSB0 > log_file.txt 2>$1
