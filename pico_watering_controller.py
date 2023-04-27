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


class pico:
    
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
    init = True
    Twelve_hours = 43200 #sec
    schedule_time = 0
    
    def moisture(self):
        return self.moisture_sensor.read_u16()/655.36
    def light(self):
        return self.light_sensor.read_u16()/655.36
    def pump_request(self):
        result = False
        select_result = uselect.select([stdin], [], [], 0)
        while select_result[0]:
            ch = stdin.read(1)
            if ch == 'p':
                result = True
            select_result = uselect.select([stdin], [], [], 0)
        return result

    # Own code
    def Run_pump(self, time):
        if self.Water_alarm(): # run pump if alarm is not active
            self.pump_control.high() # activate
            utime.sleep(time)
            self.pump_control.low() # deactivare
            self.time_of_watering = utime.time()
            
    # missing, haven't impl. that the schedule respects if watering is allowed
    def Water_pump_run_schedule(self):
        #current_time = utime.gmtime() #gets the UTC time
        #if current_time.tm_hour == 12 or current_time.tm_hour == 0:   #water at time 12 and 24
        #    Run_pump(Watering_time)
        #    print("Scheduled Watering at:", current_time.tm_hour)
        # initial start of time monitoring
        
        if self.init:
            self.schedule_time = utime.time()
            self.init = False
        
        current_time = utime.time()
        if current_time - self.schedule_time >= self.Twelve_hours:
            self.Run_pump(self.Watering_time)
            print("Scheduled Watering at:", current_time.tm_hour)
            self.schedule_time = utime.time()
        
            
    def Detection_of_watering_per_hour(self):
        current_time = utime.time()
        if current_time - self.time_of_watering >= self.Hour:
            self.Allowed_watering = True
            print("allowed watering")
        else:
            self.Allowed_watering = False
            print("NOT allowed watering")
        
        
    def Soil_moisturing(self):
        if self.moisture() < self.soil_threshold:
            if self.Allowed_watering == True:
                self.Run_pump(5)
            
    def Pump_water_alarm(self):
        if self.pump_water_alarm.value() == 1:
            return True
        else:
            return False

    def Plant_water_alarm(self):
        if self.plant_water_alarm.value() == 1:
            return True
        else:
            return False

    def Water_alarm(self):
        if self.Pump_water_alarm() == True or self.Plant_water_alarm() == True:
            print("water alarm true")
            return False
        else:
            print("water alarm false")
            return True
        

    def Button_pressed_2_times(self):
        if self.pump_request():
            start_time = utime.time()
            current_time = start_time
            while current_time - start_time <= 2:
                if self.pump_request():
                    return self.Run_pump(5)
                current_time = utime.time()

    def Transmit_data(self, data):
        #s_data[data.len()]
        #for i in data:
        #    s_data[i] = str(i)
        t_data = ','.join(str(data)) # joining all information into one string, seperated by comma
        self.uart.write(t_data.encode())

while True:
    p = pico()
    #p.moisture()
    p.led_builtin.toggle()
    p.Water_pump_run_schedule()
    p.Detection_of_watering_per_hour()
    p.Soil_moisturing()
    p.Button_pressed_2_times()
    data = [p.plant_water_alarm.value(), p.pump_water_alarm.value(), p.moisture(), p.light(), p.]
    p.Transmit_data(data)
    utime.sleep(1)
    print("%d,%d,%.0f,%.0f,%d" % (p.plant_water_alarm.value(), p.pump_water_alarm.value(), p.moisture(),p.Allowed_watering,
p.light()))