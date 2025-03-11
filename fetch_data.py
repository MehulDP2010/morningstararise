import requests
import json
import time
import keyboard
from api_auth import load_token
from nifty_database import store_nifty_price

ACCESS_TOKEN = load_token()
USER_ID = "FT050738"

SYMBOLS = {
    "NIFTY": "26000"  # ✅ Correct token for NIFTY 50 Index
}

def fetch_price(symbol="NIFTY", exchange="NSE"):
    """Fetch real-time NIFTY 50 Index data from Flattrade."""
    if not ACCESS_TOKEN:
        print("❌ No valid token.")
        return None

    if symbol not in SYMBOLS:
        print(f"❌ Symbol {symbol} not found.")
        return None

    token = SYMBOLS[symbol]
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    url = "https://piconnect.flattrade.in/PiConnectTP/GetQuotes"

    jData_json = json.dumps({"uid": USER_ID, "exch": exchange, "token": token})
    payload = f"jData={jData_json}&jKey={ACCESS_TOKEN}"

    response = requests.post(url, headers=headers, data=payload)
    if response.status_code == 200:
        price_data = response.json()
        if price_data.get("stat") == "Ok":
            nifty_price = float(price_data["lp"])  # Get last traded price
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            print(f"📊 NIFTY 50 Index Price: {nifty_price}")

            # ✅ Store in SQLite database
            store_nifty_price(timestamp, nifty_price)

            return nifty_price
        else:
            print(f"❌ API Error: {price_data.get('emsg', 'Unknown error')}")
            return None
    else:
        print("❌ Error fetching market data:", response.text)
        return None

if __name__ == "__main__":
    print("🚀 Fetching NIFTY 50 Index data every 5 seconds. Press 'q' to exit.")
    while True:
        if keyboard.is_pressed('q'):
            print("🛑 Exiting safely...")
            break

        fetch_price("NIFTY")
        time.sleep(5)
