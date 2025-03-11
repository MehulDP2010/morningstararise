from flask import Flask, request, redirect, jsonify
import requests
import json

# Replace with your actual details
API_KEY = "your_api_key_here"
CLIENT_ID = "your_client_id_here"
REDIRECT_URI = "https://morningstararise.onrender.com/callback"
TOKEN_URL = "https://authapi.flattrade.in/oauth/token"

app = Flask(__name__)

@app.route("/")
def login():
    """Redirect user to Flattrade’s OAuth Login"""
    auth_url = f"https://authapi.flattrade.in/oauth/authorize?api_key={API_KEY}&redirect_uri={REDIRECT_URI}"
    return redirect(auth_url)

@app.route("/callback")
def callback():
    """Handle OAuth redirect from Flattrade"""
    auth_code = request.args.get("code")
    if not auth_code:
        return "❌ Authorization failed. No code received."

    # Exchange auth code for access token
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
        access_token = token_data.get("access_token")

        if access_token:
            with open("flattrade_token.json", "w") as f:
                json.dump({"access_token": access_token}, f)

            return f"✅ Login successful! Token saved. <br> Token: {access_token}"

    return "❌ Failed to retrieve access token."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
