import sqlite3

def create_database():
    conn = sqlite3.connect('market_data.db')
    cursor = conn.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS market_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        symbol TEXT,
        datetime DATETIME,
        open REAL,
        high REAL,
        low REAL,
        close REAL
    );
    """)
    conn.commit()
    conn.close()

# Ensure database/table creation on startup
create_database()
