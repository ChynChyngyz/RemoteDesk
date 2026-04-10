import pytest
from rest_framework_simplejwt.tokens import RefreshToken
from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser

from remote.middleware import TokenAuthMiddleware, get_user_from_jwt, get_user_from_agent_key
from agent.utils import create_agent_key
from devices.models import Device

pytestmark = pytest.mark.django_db(transaction=True)

class MockApp:
    async def __call__(self, scope, receive, send):
        pass

@pytest.fixture
def device(db, test_org):
    return Device.objects.create(
        organization=test_org,
        hostname="test-machine",
        os="Windows",
        os_version="10",
        serial="SN123",
        ip="127.0.0.1",
        status="active",
        agent_version="1.0"
    )

@pytest.mark.asyncio
async def test_get_user_from_jwt(org_admin):
    @database_sync_to_async
    def get_token():
        refresh = RefreshToken.for_user(org_admin)
        return str(refresh.access_token)
    
    access_token = await get_token()
    user = await get_user_from_jwt(access_token)
    assert user == org_admin

@pytest.mark.asyncio
async def test_get_user_from_jwt_invalid():    
    user = await get_user_from_jwt("invalid_token")
    assert isinstance(user, AnonymousUser)

@pytest.mark.asyncio
async def test_get_user_from_agent_key(device, technician):
    # technician is in test_org, which device belongs to
    @database_sync_to_async
    def get_token():
        return create_agent_key(device)
        
    token = await get_token()
    user = await get_user_from_agent_key(token)
    assert user == technician

@pytest.mark.asyncio
async def test_token_auth_middleware_jwt(org_admin):
    @database_sync_to_async
    def get_token():
        refresh = RefreshToken.for_user(org_admin)
        return str(refresh.access_token)
    
    access_token = await get_token()
    
    scope = {"query_string": f"jwt={access_token}".encode()}
    middleware = TokenAuthMiddleware(MockApp())
    
    await middleware(scope, None, None)
    
    assert scope["user"] == org_admin

@pytest.mark.asyncio
async def test_token_auth_middleware_agent_key(device, technician):
    @database_sync_to_async
    def get_token():
        return create_agent_key(device)
        
    token = await get_token()
    
    scope = {"query_string": f"agent_key={token}".encode()}
    middleware = TokenAuthMiddleware(MockApp())
    
    await middleware(scope, None, None)
    
    assert scope["user"] == technician
