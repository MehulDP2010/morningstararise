import requests
import hashlib

# Replace with your actual credentials
FLATTRADE_API_KEY = "a45b50e88e664cb5a14fadc9e1afa06a"  # Replace with your API Key
FLATTRADE_SECRET = "2025.1b2864ac1e2a46bcb4f99d7ab49c9bcfdc5d1e8fdf8646f8"  # Replace with your API Secret
REQUEST_CODE = "978d695aa36927b2007c3e4abf80ab4917f65a35ffa732fd219363d7e0cd609e"  # From URL

# Generate SHA-256 hash
hash_input = FLATTRADE_API_KEY.strip() + REQUEST_CODE.strip() + FLATTRADE_SECRET.strip()
hashed_secret = hashlib.sha256(hash_input.encode()).hexdigest()

# Debugging print statements
print("Using API Key:", FLATTRADE_API_KEY)
print("Using Request Code:", REQUEST_CODE)
print("Using API Secret:", FLATTRADE_SECRET)
print("Generated Hash:", hashed_secret)

# API endpoint to get the access token
url = "https://authapi.flattrade.in/trade/apitoken"
payload = {
    "api_key": FLATTRADE_API_KEY,
    "request_code": REQUEST_CODE,
    "api_secret": hashed_secret
}

headers = {"Content-Type": "application/json"}
response = requests.post(url, json=payload, headers=headers)

# Print response
print("Response Status Code:", response.status_code)
print("Response Text:", response.text)
print("JSON Response:", response.json())