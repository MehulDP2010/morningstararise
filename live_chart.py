# live_chart.py
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from range_bar import data

fig, ax = plt.subplots()

def animate(i):
    ax.clear()
    ax.plot(data, marker='o', linestyle='-')
    ax.set_title("Live Range Bar Chart (0.10 Range)")
    ax.set_xlabel("Bars")
    ax.set_ylabel("Price")
    ax.grid(True)

if __name__ == "__main__":
    ani = animation.FuncAnimation(fig, animate, interval=1000)
    plt.show()
