#!/usr/bin/env python
import matplotlib.pyplot as plt
import numpy as np

#with open('datalog.csv', 'r') as f:
#    lines = f.readlines()

#x_values = []
#y_values = []
#for line in lines:
#    parts = line.split(',')
#    x_values.append(float(parts[0]))
#    y_values.append(float(parts[1]))

#plt.line(y=60, color='r', linestyle='--')
#plt.plot(x_values, y_values)
#plt.xlabel('Time2')
#plt.ylabel('Water level')
#plt.title('Water level over time')
#plt.savefig('graph.png')

data = np.genfromtxt('datalog.csv', delimiter=',')

# extract x and y values from data
x = data[:, 0]
y = data[:, 1]

# create a new figure and axis
fig, ax = plt.subplots()

# plot the data
ax.plot(x, y)

# add a horizontal line at y=5
ax.axhline(y=5, color='r', linestyle='--')

# add a text label for the line
ax.text(0.05, 5.1, 'Threshold', color='r', ha='left',va='top',backgroundcolor='w')

# set the axis labels
ax.set_xlabel('Time')
ax.set_ylabel('Water level')

# save the plot to a file
plt.savefig('graph.png')
