# agents/utils.py
import hashlib
import secrets
from .models import AgentKey

def create_agent_key(device):
    """
    Генерирует новый токен для устройства,
    сохраняет его хэш в AgentKey и возвращает plain-text токен.
    """
    token = secrets.token_hex(32)
    token_hash = hashlib.sha256(token.encode()).hexdigest()
    AgentKey.objects.create(device=device, token_hash=token_hash)
    return token

def verify_agent_key(token):
    """
    Проверяет токен агента, возвращает Device или None
    """
    token_hash = hashlib.sha256(token.encode()).hexdigest()
    try:
        agent_key = AgentKey.objects.get(token_hash=token_hash, revoked_at__isnull=True)
        return agent_key.device
    except AgentKey.DoesNotExist:
        return None