import os
import requests
import hashlib
from flask import Flask, request, redirect, jsonify

# Replace with your actual API credentials
API_KEY = "030593bbaa3440548be24f9deb39f5ee"  # Your Flattrade API Key
API_SECRET = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"  # Your Flattrade Secret Key
CLIENT_ID = "FT050738"
REDIRECT_URI = "https://morningstararise.onrender.com/callback"
TOKEN_URL = "https://authapi.flattrade.in/oauth/token"
https://authapi.flattrade.in/oauth/authorize?api_key=030593bbaa3440548be24f9deb39f5ee&redirect_uri=https://morningstararise.onrender.com/callback

app = Flask(__name__)

@app.route("/")
def login():
    return redirect(auth_url)

@app.route("/callback")
def callback():
    """Handle OAuth redirect from Flattrade"""
    auth_code = request.args.get("code")

    if not auth_code:
        return "❌ Authorization failed. No code received."

    # Generate secure hash for authentication
    hash_input = API_KEY + auth_code + API_SECRET
    hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()

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
        return jsonify(token_data)
    else:
        return f"❌ Error getting access token: {response.text}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
   
