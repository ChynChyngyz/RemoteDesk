# remote/middleware.py

import urllib.parse
from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from rest_framework_simplejwt.tokens import AccessToken

from authUser.models import CustomUser
from agent.utils import verify_agent_key


@database_sync_to_async
def get_user_from_jwt(token_string):
    try:
        access_token = AccessToken(token_string)
        user = CustomUser.objects.get(id=access_token['user_id'])
        return user
    except Exception:
        return AnonymousUser()


@database_sync_to_async
def get_user_from_agent_key(token_string):
    try:
        device = verify_agent_key(token_string)
        if device and device.organization:
            user = device.organization.users.filter(role='Technician').first()
            if user:
                return user
        return AnonymousUser()
    except Exception:
        return AnonymousUser()


class TokenAuthMiddleware:
    def __init__(self, inner):
        self.inner = inner

    async def __call__(self, scope, receive, send):
        query_string = scope.get("query_string", b"").decode()
        query_params = urllib.parse.parse_qs(query_string)

        scope["user"] = AnonymousUser()

        if "jwt" in query_params:
            token = query_params["jwt"][0]
            scope["user"] = await get_user_from_jwt(token)

        elif "agent_key" in query_params:
            token = query_params["agent_key"][0]
            scope["user"] = await get_user_from_agent_key(token)


        return await self.inner(scope, receive, send)