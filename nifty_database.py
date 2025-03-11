import sqlite3

DB_FILE = "nifty_data.db"

def create_database():
    """Create the SQLite database and tables."""
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS nifty_ohlc (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT,
            open REAL,
            high REAL,
            low REAL,
            close REAL,
            volume INTEGER,
            oi INTEGER
        )
    """)

    conn.commit()
    conn.close()
    print("✅ OHLC Database Ready!")

def store_nifty_ohlc(timestamp, open_price, high_price, low_price, close_price, volume, oi):
    """Store NIFTY OHLC data in the database."""
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO nifty_ohlc (timestamp, open, high, low, close, volume, oi) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (timestamp, open_price, high_price, low_price, close_price, volume, oi))

    conn.commit()
    conn.close()

    print(f"📊 Data Stored: {timestamp} | O:{open_price} H:{high_price} L:{low_price} C:{close_price} V:{volume} OI:{oi}")

if __name__ == "__main__":
    create_database()
