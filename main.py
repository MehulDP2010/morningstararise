# main.py
from fetch_data import fetch_price
from range_bar import update_range_bars, data
import time
import threading
import matplotlib.pyplot as plt
import matplotlib.animation as animation

def fetch_data_continuously():
    """Fetch data every second and update range bars."""
    while True:
        price = fetch_price()
        if price:
            update_range_bars(price)
        time.sleep(1)

# Start fetching data in a separate thread
threading.Thread(target=fetch_data_continuously, daemon=True).start()

# Live Chart
fig, ax = plt.subplots()
def animate(i):
    ax.clear()
    ax.plot(data, marker='o', linestyle='-')
    ax.set_title("Live Range Bar Chart (0.10 Range)")
    ax.set_xlabel("Bars")
    ax.set_ylabel("Price")
    ax.grid(True)

ani = animation.FuncAnimation(fig, animate, interval=1000)
plt.show()
