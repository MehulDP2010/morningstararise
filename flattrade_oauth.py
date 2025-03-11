import os
from flask import Flask, redirect, request, jsonify
import requests
import hashlib
import json

# Flattrade API Details
API_KEY = "030593bbaa3440548be24f9deb39f5ee"
API_SECRET = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"
REDIRECT_URI = "https://morningstararise.onrender.com/callback"
TOKEN_URL = "https://authapi.flattrade.in/trade/apitoken"

TOKEN_FILE = "flattrade_token.json"

app = Flask(__name__)

def save_token(token):
    """Save the access token to a JSON file."""
    with open(TOKEN_FILE, "w") as f:
        json.dump({"access_token": token}, f)

def load_token():
    """Load the access token from the file."""
    try:
        with open(TOKEN_FILE, "r") as f:
            data = json.load(f)
            return data.get("access_token")
    except FileNotFoundError:
        print("❌ Token file not found. Please authenticate again.")
        return None

@app.route("/")
def login():
    """Redirect user to Flattrade’s OAuth Login"""
    auth_url = f"https://auth.flattrade.in/?app_key={API_KEY}"
    return redirect(auth_url)

@app.route("/callback")
def callback():
    """Handle OAuth redirect from Flattrade"""
    auth_code = request.args.get("code")
    if not auth_code:
        return "<h3 style='color:red'>❌ Authorization failed. No request_code received.</h3>"

    # Generate hashed secret
    hash_input = API_KEY + auth_code + API_SECRET
    hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()

    # Exchange request_code for access token
    payload = {
        "api_key": API_KEY,
        "request_code": auth_code,
        "api_secret": hashed_secret
    }
    headers = {"Content-Type": "application/json"}

    response = requests.post(TOKEN_URL, json=payload, headers=headers)

    if response.status_code == 200:
        token_data = response.json()
        access_token = token_data.get("token")

        # Save token to file
        save_token(access_token)

        return f"<h3 style='color:green'>✅ Login successful! Access Token: {access_token}</h3>"
    else:
        return f"<h3 style='color:red'>❌ Token Exchange Failed: {response.text}</h3>"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))  # Ensure Flask binds to Render's provided PORT
    app.run(host="0.0.0.0", port=port)
