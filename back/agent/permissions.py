from rest_framework.permissions import BasePermission
from .utils import verify_agent_key


def get_agent_key_from_request(request):
    auth_header = request.META.get('HTTP_AUTHORIZATION', '')
    if auth_header.startswith('Bearer '):
        return auth_header.split(' ')[1]

    if hasattr(request, 'data') and isinstance(request.data, dict):
        return request.data.get("agent_key")
    return None


class IsAuthenticatedAgent(BasePermission):
    message = "Invalid, missing, or revoked agent key"

    def has_permission(self, request, view):
        agent_key = get_agent_key_from_request(request)

        if not agent_key:
            return False

        device = verify_agent_key(agent_key)
        if not device:
            return False

        request.device = device
        return True