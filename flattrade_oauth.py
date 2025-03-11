from flask import Flask, request, redirect, jsonify
import requests
import hashlib

# Flattrade API Credentials
API_KEY = "030593bbaa3440548be24f9deb39f5ee"  # Your API Key
API_SECRET = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"  # Your Secret Key
CLIENT_ID = "FT050738"  # Your Flattrade Client ID
REDIRECT_URI = "https://morningstararise.onrender.com/callback"
AUTH_URL = "https://authapi.flattrade.in/oauth/authorize"
TOKEN_URL = "https://authapi.flattrade.in/oauth/token"

app = Flask(__name__)

@app.route("/")
def login():
    """Redirect user to Flattrade OAuth Login"""
    auth_url = f"{AUTH_URL}?api_key={API_KEY}&redirect_uri={REDIRECT_URI}"
    return redirect(auth_url)

@app.route("/callback")
def callback():
    """Handle OAuth Callback from Flattrade"""
    auth_code = request.args.get("code")
    
    if not auth_code:
        return "❌ Authorization failed. No code received."

    # Generate hashed secret
    hash_input = API_SECRET + auth_code
    hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()

    # Exchange auth code for access token
    payload = {
        "api_key": API_KEY,
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "code": auth_code,
        "grant_type": "authorization_code",
        "api_secret": hashed_secret
    }
    
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(TOKEN_URL, data=payload, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return jsonify(data)
    else:
        return f"❌ Error: {response.text}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
