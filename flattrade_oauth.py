from flask import Flask, redirect, request, jsonify
import requests
import json
import os

# Flask app
app = Flask(__name__)

# Replace these with actual Flattrade credentials
API_KEY = "030593bbaa3440548be24f9deb39f5ee"  # Your API Key from Flattrade
CLIENT_ID = "FT050738"  # Your Flattrade Client ID
SECRET_KEY = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"  # Your Secret Key from Flattrade

# OAuth endpoints
REDIRECT_URI = "https://morningstararise.onrender.com/callback"  # Your Render Callback URL
AUTH_URL = f"https://authapi.flattrade.in/oauth/authorize?api_key={API_KEY}&redirect_uri={REDIRECT_URI}"
TOKEN_URL = "https://authapi.flattrade.in/oauth/token"

# Store token in a file
TOKEN_FILE = "flattrade_token.json"

# Route to start authentication
@app.route("/")
def login():
    return redirect(AUTH_URL)

# Callback URL after Flattrade Login
@app.route("/callback")
def callback():
    auth_code = request.args.get("code")

    if not auth_code:
        return "❌ Authorization failed. No code received.", 400

    payload = {
        "api_key": API_KEY,
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "code": auth_code,
        "grant_type": "authorization_code",
    }

    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    
    response = requests.post(TOKEN_URL, data=payload, headers=headers)

    if response.status_code == 200:
        token_data = response.json()
        access_token = token_data.get("token")
        client_id = token_data.get("client")

        # Save token
        with open(TOKEN_FILE, "w") as f:
            json.dump(token_data, f)

        return f"✅ OAuth Successful! Access Token: {access_token}, Client ID: {client_id}"
    else:
        return f"❌ OAuth Failed! Response: {response.text}", 400

# API to get stored token
@app.route("/get_token")
def get_token():
    try:
        with open(TOKEN_FILE, "r") as f:
            return jsonify(json.load(f))
    except FileNotFoundError:
        return jsonify({"error": "No token found"}), 404

# Main entry point
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
