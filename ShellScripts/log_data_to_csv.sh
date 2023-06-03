#!/bin/bash
if [ -z "$2" ]
then
    echo "Please provide both a plant_id and remote_id."
    echo "pump_controller.sh <plant_id> <remote_id>"
    exit 1
fi

DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

PLANT_ID="$1"
REMOTE_ID="$2"


#plant_alarm, time of plant_alarm, pump_alarm, time of pump_alarm, soil moisture, light, pump activation, time of pump activation

log_file="sensor_log_file_$PLANT_ID.csv"
request_log_file="pump_request_log.csv"
plant_alarm_file="plant_alarm_file.csv"
pump_alarm_file="pump_alarm_file.csv"


touch $log_file
touch $request_log_file
touch $plant_alarm_file
touch $pump_alarm_file

PLANT_ALARM_TOPIC=plant/$PLANT_ID/plant_alarm
PUMP_ALARM_TOPIC=plant/$PLANT_ID/pump_alarm
MOISTURE_TOPIC=plant/$PLANT_ID/moisture
LIGHT_TOPIC=plant/$PLANT_ID/light
PUMP_REQUEST_TOPIC=plant/$PLANT_ID/watering_log

MQTT_IP="192.168.10.1"

last_plant_msg=1
last_pump_msg=1


while true
do
    mosquitto_sub -h $MQTT_IP -t $PLANT_ALARM_TOPIC -t $PUMP_ALARM_TOPIC -t $MOISTURE_TOPIC -t $LIGHT_TOPIC -t $PUMP_REQUEST_TOPIC -u pi -P burgerking -F "%t %p" | while read -r payload
    do
        
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)
        time_seconds=$(date)

        if [[ $topic == $PUMP_REQUEST_TOPIC ]]
        then
            echo "here"
            echo "$time_seconds,$PLANT_ID" >> $request_log_file
        fi


        if [[ $topic == $PLANT_ALARM_TOPIC ]]
        then
            plant_alarm_received=true
            plant_msg=$msg
        fi

        if [[ $topic == $PUMP_ALARM_TOPIC ]]
        then
            pump_alarm_received=true
            pump_msg=$msg
        fi

        if [[ $topic == $MOISTURE_TOPIC ]]
        then
            moisture_received=true
            moisture_msg=$msg
        fi

        if [[ $topic == $LIGHT_TOPIC ]]
        then
            light_received=true
            light_msg=$msg
        fi

        
        if [[ $plant_alarm_received == true && $pump_alarm_received == true && $moisture_received == true && $light_received == true ]]; then
            
            plant_alarm_received=false
            pump_alarm_received=false
            moisture_received=false
            light_received=false

            if [[ $last_plant_msg != $plant_msg && $plant_msg == 1 ]]
            then
                echo "$time_seconds,$PLANT_ID" >> $plant_alarm_file
            fi

            if [[ $last_pump_msg != $pump_msg && $pump_msg == 1 ]]
            then
                echo "$time_seconds,$PLANT_ID" >> $pump_alarm_file
            fi
            
            last_plant_msg=$plant_msg
            last_pump_msg=$pump_msg


            time_seconds=$(date)
            echo "$plant_msg,$pump_msg,$moisture_msg,$light_msg,$time_seconds" >> $log_file
        fi
    done

done