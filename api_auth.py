import requests
import hashlib
import json
import time

API_KEY = "e7a7ad4c42e248feb790d9b18b2ea354"
API_SECRET = "2025.8f8791a1a8744a5a99b9ea8f9dfb4243294888167c9b19fe"
TOKEN_FILE = "flattrade_token.json"

def save_token(token):
    """Save access token to a file."""
    with open(TOKEN_FILE, "w") as f:
        json.dump({"access_token": token, "timestamp": time.time()}, f)

def load_token():
    """Load token from file if available."""
    try:
        with open(TOKEN_FILE, "r") as f:
            data = json.load(f)
            return data.get("access_token")
    except FileNotFoundError:
        return None

def generate_token():
    """Generate Flattrade API access token."""
    request_code = input("🔑 Enter Request Code from Flattrade: ").strip()
    print(f"🔍 Entered Request Code: {request_code}")

    if not request_code:
        print("❌ Error: Request code cannot be empty.")
        return None

    # Correct hashing
    hash_input = API_KEY + request_code + API_SECRET
    hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()
    print(f"🔍 Hashed Secret: {hashed_secret}")

    payload = {
        "api_key": API_KEY,
        "request_code": request_code,
        "api_secret": hashed_secret
    }

    TOKEN_URL = "https://authapi.flattrade.in/trade/apitoken"
    print(f"🔍 Sending Request to: {TOKEN_URL}")
    print(f"🔍 Payload: {json.dumps(payload, indent=2)}")

    try:
        response = requests.post(TOKEN_URL, json=payload, timeout=10)
        response.raise_for_status()

        print(f"🔍 HTTP Status Code: {response.status_code}")
        print(f"🔍 API Raw Response: {response.text}")

        token_data = response.json()
        if token_data.get("stat") == "Ok":
            ACCESS_TOKEN = token_data["token"]
            save_token(ACCESS_TOKEN)
            print("✅ Token Generated and Saved:", ACCESS_TOKEN)
            return ACCESS_TOKEN
        else:
            print("❌ API Error:", token_data.get("emsg", "Unknown error"))
            return None
    except requests.exceptions.RequestException as e:
        print(f"❌ HTTP Request Error: {e}")
        return None

if __name__ == "__main__":
    token = generate_token()
    print("🔑 Final Access Token:", token)
