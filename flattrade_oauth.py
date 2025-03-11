from flask import Flask, redirect, request, jsonify
import requests
import json

# 🔑 Replace with your actual Flattrade API credentials
API_KEY = "030593bbaa3440548be24f9deb39f5ee"  # Your API Key
API_SECRET = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"  # Your Secret Key
CLIENT_ID = "FT050738"  # Your Flattrade Client ID
REDIRECT_URI = "https://morningstararise.onrender.com/callback"  # Your Render Redirect URL
TOKEN_URL = "https://authapi.flattrade.in/oauth/token"  # Token Exchange URL

TOKEN_FILE = "flattrade_token.json"  # File to save access token

app = Flask(__name__)

# 🔵 Step 1: Redirect user to Flattrade OAuth Login
@app.route("/")
def login():
    auth_url = f"https://authapi.flattrade.in/oauth/authorize?api_key={API_KEY}&redirect_uri={REDIRECT_URI}&response_type=code"
    return redirect(auth_url)

# 🔴 Step 2: Handle OAuth Callback from Flattrade
@app.route("/callback")
def callback():
    auth_code = request.args.get("code")
    
    if not auth_code:
        return "❌ Authorization failed. No code received.", 400
    
    # Exchange auth_code for access token
    payload = {
        "api_key": API_KEY,
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "code": auth_code,
        "grant_type": "authorization_code"
    }

    headers = {"Content-Type": "application/x-www-form-urlencoded"}

    response = requests.post(TOKEN_URL, data=payload, headers=headers)

    if response.status_code == 200:
        token_data = response.json()
        
        if "access_token" in token_data:
            save_token(token_data["access_token"])
            return jsonify({"message": "✅ Login Successful!", "access_token": token_data["access_token"]})
        else:
            return f"❌ Error: {token_data}", 400
    else:
        return f"❌ HTTP Error: {response.status_code}, {response.text}", 400

# 🔐 Function to save token locally
def save_token(token):
    with open(TOKEN_FILE, "w") as f:
        json.dump({"access_token": token}, f)

# 🔑 Function to load saved token
def load_token():
    try:
        with open(TOKEN_FILE, "r") as f:
            return json.load(f).get("access_token")
    except FileNotFoundError:
        return None

# Run the Flask app
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
