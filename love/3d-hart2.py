import time
import numpy as np
import matplotlib.pyplot as plt


class Guess:
    def __init__(self, bbox=(-1.5, 1.5), resolution=50, lines=20, scale=1.2) -> None:
        self.xmin, self.xmax, self.ymin, self.ymax, self.zmin, self.zmax = bbox*3
        plt.ion() 
        self.scale = scale
        self.time = time.time()
        A = np.linspace(self.xmin, self.xmax, resolution)
        self.B = np.linspace(self.xmin, self.xmax, lines)
        self.A1, self.A2 = np.meshgrid(A, A)
        

    def coordinate(self, x, y, z):
        return (x**2+(9/4)*y**2+z**2-1)**3-x**2*z**3-(9/80)*y**2*z**3

    def draw(self, ax, coef):
        for z in self.B:
            X, Y = self.A1, self.A2
            Z = self.coordinate(X, Y, z)+z
            cset = ax.contour(X * coef, Y * coef, Z * coef, [z * coef], zdir='z', colors=('pink',))

        for y in self.B:
            X, Z = self.A1, self.A2
            Y = self.coordinate(X, y, Z)+y
            cset = ax.contour(X * coef, Y * coef, Z * coef, [y * coef], zdir='y', colors=('pink',))

        for x in self.B:
            Y, Z = self.A1, self.A2
            X = self.coordinate(x, Y, Z) + x
            cset = ax.contour(X * coef, Y * coef, Z * coef, [x * coef], zdir='x', colors=('pink',))

    def run(self, count):
        fig = plt.figure()
        for i in range(count):
            plt.clf()
            ax = fig.add_subplot(projection='3d')
            ax.set_title("2LiuYu")
            ax.set_zlim3d(self.zmin, self.zmax)
            ax.set_xlim3d(self.xmin, self.xmax)
            ax.set_ylim3d(self.ymin, self.ymax)
            times = time.time()-self.time
            ax.view_init(10, 100+np.cos(times) * 10)
            coef = np.cos(times) * (self.scale-1) + 1
            self.draw(ax, coef)
            plt.pause(0.01)
            plt.show()


if __name__ == '__main__':
    demo = Guess()
    demo.run(1000)

