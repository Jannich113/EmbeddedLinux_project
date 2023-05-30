#!bin/bash


# function that checks if soil moistre is above treshol

soil_threshold=50


Transmit_to_esp() {

    local waterAlarm=$1
    local pumpAlarm=$2
    local soil_level=$3

    # send a red led, turn off green
    if [[ "$waterAlarm" == "1" || "$pumpAlarm" == "1" ]]; then
        mosquitto_pub -h localhost -t remote/led/red -m "on" -u pi -P burgerking
        mosquitto_pub -h localhost -t remote/led/green -m "off" -u pi -P burgerking
    fi
    # send a green value, turn off red and yellow
    if [[ "$waterAlarm" == "0" && "$pumpAlarm" == "0" && "soil_level" >= "$soil_threshold"]]; then
        mosquitto_pub -h localhost -t remote/led/red -m "off" -u pi -P burgerking
        mosquitto_pub -h localhost -t remote/led/green -m "on" -u pi -P burgerking
        mosquitto_pub -h localhost -t remote/led/yellow -m "off" -u pi -P burgerking
        
    # send yellow and turn off green    
    else
        mosquitto_pub -h localhost -t remote/led/green -m "off" -u pi -P burgerking
        mosquitto_pub -h localhost -t remote/led/yellow -m "on" -u pi -P burgerking
    fi

}



mqtt_sub() {

    local topic1="pico/1/plant_alarm"
    local topic2="pico/1/pump_alarm"
    local topic3="pico/1/moisture"


    while read -r waterAlarm && -r pumpAlarm && -r soil_level; do
        Transmit_to_esp() "$waterAlarm" "$pumpAlarm" "soil_level"
    done < <(mosquitto_sub -h <localhost> -t "$topic1" -t "$topic2" -t "$topic3" -u pi -P burgerking -C 3)
}


mqtt_sub