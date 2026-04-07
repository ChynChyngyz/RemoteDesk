import time
import hmac
import hashlib
import base64

SECRET = "SUPER_SECRET_KEY"

def generate_turn_credentials():
    expiry = int(time.time()) + 3600
    username = str(expiry)

    digest = hmac.new(
        SECRET.encode(),
        username.encode(),
        hashlib.sha1
    ).digest()

    password = base64.b64encode(digest).decode()

    return {
        "username": username,
        "credential": password,
        "urls": [
            "turn:YOUR_DOMAIN:3478",
            "turn:YOUR_DOMAIN:3478?transport=tcp"
        ]
    }