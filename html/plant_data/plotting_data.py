#!/usr/bin/env python
import os
import matplotlib.pyplot as plt
import numpy as np
path='/home/jannich/Documents/SDU/EmbeddedLinux_project/html/plant_data'
#path = '/var/www/html/plant_data/'

# stores path to all csv files
arrays = []


# looking through a folder to find all csv files. 
for file in os.listdir(path):
    if file.endswith('.csv'):
        file_path = os.path.join(path, file)
        array = np.loadtxt(file_path, delimiter=',')
        arrays.append(array)
   


# colomn index 
Soil_col_index = 2 
Light_col_index = 3


def plot_soil():
    # generating plots 
    for i, array in enumerate(arrays):
        soil_data = array[:, Soil_col_index]
        plt.plot(soil_data, label=f'Pico {i+1}')
    
    plt.title('Soil moisture over time')
    plt.xlabel('Time')
    plt.ylabel('Moisture level')
    # add a horizontal line at y=50
    plt.axhline(y=50, color='r', linestyle='--')
    # add a text label for the line
    plt.text(0.05, 51.1, 'Threshold', color='r', ha='left',va='top',backgroundcolor='w')
    # save plot
    plt.savefig('soil.png')
    plt.clf()


def plot_light():
    # generating plots 
    for i, array in enumerate(arrays):
        light_data = array[:, Light_col_index]
        plt.plot(light_data, label=f'Pico {i+1}')
    plt.title('Light exposure over time')
    plt.xlabel('Time')
    plt.ylabel('Light level')
    # save plot
    plt.savefig('light.png')
    plt.clf()


plot_soil()
plot_light()