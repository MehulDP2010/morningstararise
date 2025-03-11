import sqlite3
import pandas as pd
import matplotlib.pyplot as plt

DB_FILE = "nifty_data.db"

def fetch_data():
    """Retrieve OHLC data from the database."""
    conn = sqlite3.connect(DB_FILE)
    query = "SELECT timestamp, open, high, low, close FROM nifty_ohlc ORDER BY timestamp ASC"
    df = pd.read_sql(query, conn)
    conn.close()
    return df

def generate_range_bars(df, range_percent=0.10):
    """Generate range bars with 0.10% movement."""
    range_size = df['close'].iloc[0] * (range_percent / 100)
    bars = []
    bar_open = df['close'].iloc[0]

    for index, row in df.iterrows():
        bar_high = max(row['high'], bar_open + range_size)
        bar_low = min(row['low'], bar_open - range_size)
        bar_close = row['close']

        bars.append((bar_open, bar_high, bar_low, bar_close))
        bar_open = bar_close

    return bars

def plot_chart(bars):
    """Plot the range bars."""
    plt.figure(figsize=(10, 5))
    plt.plot(range(len(bars)), [bar[3] for bar in bars], marker='o', label="Range Bars")
    plt.xlabel("Bars")
    plt.ylabel("Price")
    plt.title("NIFTY 50 Range Bar Chart (0.10%)")
    plt.legend()
    plt.show()

df = fetch_data()
bars = generate_range_bars(df)
plot_chart(bars)
