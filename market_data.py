import requests
import time

# Your Flattrade API Credentials (Replace with actual values)
API_KEY = "4e7b8d3512e045dfbef930e4bd241895"
ACCESS_TOKEN = "your_access_token"

# Flattrade API URLs
BASE_URL = "https://api.flattrade.in"
LIVE_MARKET_URL = f"{BASE_URL}/quote/marketwatch"

# Symbols to Fetch (NIFTY, BANKNIFTY)
SYMBOLS = ["NIFTY", "BANKNIFTY"]

def get_live_data():
    """
    Fetch live market data from Flattrade API.
    """
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {ACCESS_TOKEN}"
    }
    
    payload = {
        "exchange": "NSE",
        "token": SYMBOLS
    }

    try:
        response = requests.post(LIVE_MARKET_URL, json=payload, headers=headers)
        
        # If request fails, print error
        if response.status_code != 200:
            print(f"❌ Error {response.status_code}: {response.text}")
            return None

        data = response.json()
        return data

    except Exception as e:
        print(f"❌ Exception: {e}")
        return None

if __name__ == "__main__":
    while True:
        market_data = get_live_data()
        if market_data:
            print(f"📊 Live Market Data: {market_data}")
        time.sleep(1)  # Refresh every 1 second
