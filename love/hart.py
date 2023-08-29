import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np

def heart(t):
    x = 16 * np.sin(t)**3
    y = 13 * np.cos(t) - 5 * np.cos(2*t) - 2 * np.cos(3*t) - np.cos(4*t)
    return x, y

def heart2(t):
    x = 15 * np.sin(t)**3
    y = 14 * np.cos(t) - 5 * np.cos(2*t) - 2 * np.cos(3*t) - np.cos(4*t)
    return x, y

# Generate a sequence of time values
t = np.linspace(0, 2*np.pi, 100)

# Get the x and y coordinates of the heart shape at each time value
x, y = heart(t)

# Use Matplotlib to create a figure and an axes
fig, ax = plt.subplots()

# Use the axes to draw a scatter plot of the heart shape
ax.scatter(x, y)

# Create a function that will be called at each time step
def update(t):
    # Get the x and y coordinates of the heart shape at the current time
    x, y = heart(t)

    # Update the scatter plot with the new x and y values
    ax.scatter(x, y)

    if (t == 2*np.pi):
        ax.clear()
    

# Create an animation using the update function and the sequence of time values
ani = animation.FuncAnimation(fig, update, t, interval=1)

# Show the animation
plt.show()
