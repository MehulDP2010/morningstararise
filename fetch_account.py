from token_manager import load_token
import requests

ACCESS_TOKEN = load_token()  # ✅ Load stored token

if not ACCESS_TOKEN:
    print("❌ No access token found. Please authenticate again.")
    exit()

def get_account_details():
    API_URL = "https://piconnect.flattrade.in/PiConnectTP/account"
    headers = {"Authorization": f"Bearer {ACCESS_TOKEN}"}

    response = requests.get(API_URL, headers=headers)
    
    if response.status_code == 200:
        print("✅ Account Details:", response.json())
    else:
        print("❌ Error:", response.text)

if __name__ == "__main__":
    get_account_details()
