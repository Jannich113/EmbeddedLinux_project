#!/usr/bin/env python3

# Embedded Linux (EMLI)
# University of Southern Denmark
# Raspberry Pico plant watering controller
# Copyright (c) Kjeld Jensen <kjen@sdu.dk> <kj@kjen.dk>
# 2023-04-19, KJ, First version

# Modified 
# by group 21
# 2023-04-24

from machine import Pin, ADC, UART
import utime
from sys import stdin
import uselect

pump_control = Pin(17, Pin.OUT)
pump_water_alarm = Pin(13, Pin.IN)
plant_water_alarm = Pin(9, Pin.IN)
moisture_sensor_pin = Pin(26, mode=Pin.IN)
moisture_sensor = ADC (moisture_sensor_pin)
photo_resistor_pin = Pin(27, mode=Pin.IN)
light_sensor = ADC(photo_resistor_pin)
led_builtin = machine.Pin(25, machine.Pin.OUT)
uart = machine.UART(0, 115200)

#defined values
Watering_time = 15 # sec
Allowed_watering = True
time_of_watering = 0
Hour = 3600 #sec
soil_threshold = 70 # range from 0-100 


def moisture():
    return moisture_sensor.read_u16()/655.36
def light():
    return light_sensor.read_u16()/655.36
def pump_request():
    result = False
    select_result = uselect.select([stdin], [], [], 0)
    while select_result[0]:
        ch = stdin.read(1)
        if ch == 'p':
            result = True
        select_result = uselect.select([stdin], [], [], 0)
    return result

# Own code
def Run_pump(time):
    if Water_alarm(): # run pump if alarm is not active
        pump_control.high() # activate
        utime.sleep(time)
        pump_control.low() # deactivare
        time_of_watering = utime.time()
        
# missing, haven't impl. that the schedule respects if watering is allowed
def Water_pump_run_schedule():
    current_time = utime.gmtime() #gets the UTC time
    if current_time.tm_hour == 12 or current_time.tm_hour == 0:   #water at time 12 and 24
        Run_pump(Watering_time)
        print("Scheduled Watering at:", current_time.tm_hour)
        
def Detection_of_watering_per_hour():
    current_time = utime.time()
    if current_time - time_of_watering >= Hour:
        Allowed_watering = True
        return Allowed_watering
    Allowed_watering = False
    return Allowed_watering
    
def Soil_moisturing():
    if moisture() < soil_threshold and Allowed_watering == True:
        Run_pump(5)
        
def Pump_water_alarm():
    if pump_water_alarm.value() == 1:
        return True
    return False

def Plant_water_alarm():
    if plant_water_alarm.value() == 1:
        return True
    return False

def Water_alarm():
    if Pump_water_alarm() == True and Plant_water_alarm() == True:
        return False
    return True

def Button_pressed_2_times():
    if pump_request():
        start_time = utime.time()
        current_time = start_time
        while current_time - start_time <= 2:
            if pump_request():
                return Run_pump(5)
            current_time = utime.time()

def Transmit_data(data):
    t_data = ','.join(data) # joining all information into one string, seperated by comma
    uart.write(t_data.encode())

while True:
    led_builtin.toggle()
    Water_pump_run_schedule()
    Detection_of_watering_per_hour()
    Soil_moisturing()
    Button_pressed_2_times()
    data = [plant_water_alarm.value(), pump_water_alarm.value(), moisture(), light()]
    Transmit_data(data)
    utime.sleep(1)
    print("%d,%d,%.0f,%.0f" % (plant_water_alarm.value(), pump_water_alarm.value(), moisture(),
light()))