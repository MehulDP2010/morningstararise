from flask import Flask, request, redirect, jsonify
import requests
import hashlib

# ⚡ Replace with your actual credentials from Flattrade
API_KEY = "030593bbaa3440548be24f9deb39f5ee"
API_SECRET = "2025.934665b7748a4027a5925557d954af7faaa5742f96c8e623"
REDIRECT_URI = "https://morningstararise.onrender.com/callback"  # Must match your Flattrade settings
TOKEN_URL = "https://authapi.flattrade.in/trade/apitoken"

app = Flask(__name__)

# ✅ Step 1: Redirect user to Flattrade's OAuth login
@app.route("/")
def login():
    """Redirect user to Flattrade's OAuth Login."""
    auth_url = f"https://auth.flattrade.in/?app_key={API_KEY}"
    return redirect(auth_url)

# ✅ Step 2: Handle OAuth Redirect from Flattrade
@app.route("/callback")
def callback():
    """Handle OAuth redirect from Flattrade."""
    request_code = request.args.get("code")  # Flattrade sends "code", not "request_code"


    if not request_code:
        return "❌ Authorization failed. No request_code received.", 400

    # ✅ Step 3: Generate hashed secret
    hash_input = API_KEY + request_code + API_SECRET
    hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()

    # ✅ Step 4: Exchange request_code for access token
    payload = {
        "api_key": API_KEY,
        "request_code": request_code,
        "api_secret": hashed_secret
    }
    headers = {"Content-Type": "application/json"}

    response = requests.post(TOKEN_URL, json=payload, headers=headers)

    if response.status_code == 200:
        data = response.json()
        if data.get("status") == "Ok":
            access_token = data.get("token")
            return jsonify({"access_token": access_token, "message": "✅ Login Successful!"})
        else:
            return f"❌ API Error: {data.get('emsg')}", 400
    else:
        return f"❌ HTTP Error {response.status_code}: {response.text}", 400

# ✅ Step 5: Run the Flask App
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
