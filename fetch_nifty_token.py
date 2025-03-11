import requests
import json
from api_auth import load_token

ACCESS_TOKEN = load_token()
USER_ID = "FT050738"

def fetch_nifty_token():
    """Fetch the correct token for NIFTY 50 Index."""
    url = "https://piconnect.flattrade.in/PiConnectTP/SearchScrip"
    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    jData = {
        "uid": USER_ID,
        "stext": "INDEX",  # ✅ Only search for "NIFTY 50"
        "exch": "NSE"
    }

    payload = f"jData={json.dumps(jData)}&jKey={ACCESS_TOKEN}"

    response = requests.post(url, headers=headers, data=payload)

    if response.status_code == 200:
        data = response.json()
        if data.get("stat") == "Ok":
            print("✅ Available Tokens for NIFTY 50:")
            for item in data["values"]:
                print(f"{item['tsym']} - Token: {item['token']}")
            return data["values"]
        else:
            print(f"❌ API Error: {data.get('emsg', 'Unknown error')}")
    else:
        print("❌ Error fetching token list:", response.text)

if __name__ == "__main__":
    fetch_nifty_token()
