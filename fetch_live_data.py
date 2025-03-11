import requests
import json
import time
import keyboard
from api_auth import load_token, generate_token
from nifty_database import store_nifty_ohlc

USER_ID = "FT050738"
SYMBOLS = {"NIFTY": "26000"}  # ✅ Correct token for NIFTY 50 Index

def fetch_price(symbol="NIFTY", exchange="NSE"):
    """Fetch real-time NIFTY 50 Index data and refresh token if expired."""
    global ACCESS_TOKEN
    ACCESS_TOKEN = load_token()

    if not ACCESS_TOKEN:
        print("❌ No valid token found. Generating new token...")
        ACCESS_TOKEN = generate_token()
        if not ACCESS_TOKEN:
            print("❌ Token generation failed. Exiting...")
            return None

    token = SYMBOLS.get(symbol)
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    url = "https://piconnect.flattrade.in/PiConnectTP/GetQuotes"

    jData_json = json.dumps({"uid": USER_ID, "exch": exchange, "token": token})
    payload = f"jData={jData_json}&jKey={ACCESS_TOKEN}"

    response = requests.post(url, headers=headers, data=payload)
    
    if response.status_code == 200:
        price_data = response.json()
        
        if price_data.get("stat") == "Ok":
            open_price = float(price_data["into"])
            high_price = float(price_data["inth"])
            low_price = float(price_data["intl"])
            close_price = float(price_data["intc"])
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")

            print(f"📊 NIFTY 50 OHLC - Open: {open_price}, High: {high_price}, Low: {low_price}, Close: {close_price}")

            # ✅ Store OHLC data in database
            store_nifty_ohlc(timestamp, open_price, high_price, low_price, close_price)

        elif "Session Expired" in price_data.get("emsg", ""):
            print("🔄 Session expired. Refreshing token...")
            ACCESS_TOKEN = generate_token()
            return fetch_price(symbol, exchange)  # Retry fetching after token update

        else:
            print(f"❌ API Error: {price_data.get('emsg', 'Unknown error')}")
    else:
        print("❌ HTTP Error:", response.text)

if __name__ == "__main__":
    print("🚀 Fetching NIFTY 50 Index data every 5 seconds. Press 'q' to exit.")
    
    while True:
        if keyboard.is_pressed('q'):
            print("🛑 Exiting safely...")
            break
        fetch_price("NIFTY")
        time.sleep(5)
