import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

# Generate a sequence of time values
t = np.linspace(0, 2*np.pi, 100)

# Get the x and y coordinates of the heart shape at each time value
x = 16 * np.sin(t)**3
y = 13 * np.cos(t) - 5 * np.cos(2*t) - 2 * np.cos(3*t) - np.cos(4*t)
z = np.sin(t)

# Use Matplotlib to create a figure and an axes
fig = plt.figure()
ax = Axes3D(fig)

# Use the axes to draw a scatter plot of the heart shape
ax.scatter(x, y, z)

# Show the figure
plt.show()
