import requests
import json
import time
import datetime
from nifty_database import store_nifty_ohlc

# ✅ API Endpoint for Historical Data
API_URL = "https://piconnect.flattrade.in/PiConnectTP/TPSeries"

# ✅ Credentials (Replace with your actual details)
TOKEN = "26000"  # NIFTY 50 Token
USER_ID = "FT050738"  # Your Flattrade User ID
API_KEY = "e7a7ad4c42e248feb790d9b18b2ea354"  # Replace with your actual API Key
ACCESS_TOKEN = "f200568c6a0d6b25a3175533a67ed616f84da141041b843417f6a9cbda521d5b"  # Replace with your valid access token

# ✅ Headers
HEADERS = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json"
}

def fetch_historical_data():
    """Fetch 20 days of NIFTY 50 OHLC data at 1-second intervals."""
    print("🚀 Fetching 20 days of NIFTY 50 OHLC data...")

    end_time = int(time.time())  # Current UNIX timestamp
    start_time = end_time - (20 * 24 * 60 * 60)  # 20 days back

    payload = {
        "jData": {
            "uid": USER_ID,
            "exch": "NSE",
            "token": TOKEN,
            "st": start_time,  # Start time (20 days ago)
            "et": end_time,    # End time (now)
            "intrv": "1"            # 1-second interval
        },
        "jKey": API_KEY  # ✅ API Key included correctly
    }

    try:
        response = requests.post(API_URL, json=payload, headers=HEADERS)

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for entry in data:
                    if entry.get("stat") == "Ok":
                        timestamp = entry.get("time", "N/A")
                        open_price = float(entry.get("into", 0))
                        high_price = float(entry.get("inth", 0))
                        low_price = float(entry.get("intl", 0))
                        close_price = float(entry.get("intc", 0))
                        volume = int(entry.get("v", 0))
                        oi = int(entry.get("oi", 0))

                        # ✅ Store in Database
                        store_nifty_ohlc(timestamp, open_price, high_price, low_price, close_price, volume, oi)

                        print(f"📊 [{timestamp}] O: {open_price} H: {high_price} L: {low_price} C: {close_price} V: {volume} OI: {oi}")

        else:
            print(f"❌ HTTP Error {response.status_code}: {response.text}")

    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    fetch_historical_data()
