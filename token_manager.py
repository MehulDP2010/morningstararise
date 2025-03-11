import json
import os

TOKEN_FILE = "flattrade_token.json"

def save_token(token):
    """Save the access token to a JSON file."""
    with open(TOKEN_FILE, "w") as f:
        json.dump({"access_token": token}, f)
    print("✅ Access token saved successfully!")

def load_token():
    """Load the access token from the file."""
    if not os.path.exists(TOKEN_FILE):
        print("❌ Error: Token file not found. Please authenticate again.")
        return None

    with open(TOKEN_FILE, "r") as f:
        data = json.load(f)
        return data.get("access_token")
