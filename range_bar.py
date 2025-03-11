import time
import keyboard  # Install using `pip install keyboard`
from fetch_data import fetch_price

RANGE_SIZE = 0.10
data = []

def update_range_bars(latest_data):
    """Updates range bars based on price movement."""
    if not latest_data:
        return

    latest_price = float(latest_data.get("lp", 0))  # Ensure float
    if not data:
        data.append(latest_price)
        print("📈 New Range Bar Created:", latest_price)
        return

    last_price = data[-1]
    if abs(latest_price - last_price) >= RANGE_SIZE:
        data.append(latest_price)
        print("📈 New Range Bar Created:", latest_price)

if __name__ == "__main__":
    print("🚀 Press 'q' to quit the script safely.")
    while True:
        if keyboard.is_pressed('q'):  # Quit when 'q' is pressed
            print("🛑 Exiting safely...")
            break

        price_data = fetch_price("NIFTY")
        if price_data:
            update_range_bars(price_data)

        time.sleep(1)  # Wait 1 second before fetching again
