import pytest
from channels.testing import WebsocketCommunicator
from django.contrib.auth.models import AnonymousUser
from channels.routing import URLRouter
from django.urls import path
from remote.models import RemoteSession
from devices.models import Device
from remote.consumers import SignalConsumer

application = URLRouter([
    path("ws/signal/<room>/", SignalConsumer.as_asgi()),
])

pytestmark = pytest.mark.django_db(transaction=True)

@pytest.fixture
def device(test_org):
    return Device.objects.create(
        organization=test_org,
        hostname="test-machine",
        os="Windows",
        os_version="10",
        serial="SN123",
        ip="127.0.0.1",
        status="active"
    )

@pytest.fixture
def session(technician, device):
    return RemoteSession.objects.create(
        organization=device.organization,
        requester_user=technician,
        device=device,
        access_token="test_token_123",
        status="approved"
    )

@pytest.mark.asyncio
async def test_connect_invalid_session(technician):
    communicator = WebsocketCommunicator(application, "/ws/signal/99999/?token=invalid")
    communicator.scope["user"] = technician
    
    connected, subprotocol = await communicator.connect()
    assert not connected

@pytest.mark.asyncio
async def test_connect_valid_session_wrong_token(session, technician):
    communicator = WebsocketCommunicator(application, f"/ws/signal/{session.id}/?token=wrong_token")
    communicator.scope["user"] = technician
    
    connected, subprotocol = await communicator.connect()
    assert not connected

@pytest.mark.asyncio
async def test_connect_valid_session_correct_token(session, technician):
    communicator = WebsocketCommunicator(application, f"/ws/signal/{session.id}/?token={session.access_token}")
    communicator.scope["user"] = technician
    
    connected, subprotocol = await communicator.connect()
    assert connected
    await communicator.disconnect()

@pytest.mark.asyncio
async def test_echo_protection(session, technician):
    # Two communicators connecting to the same room
    communicator1 = WebsocketCommunicator(application, f"/ws/signal/{session.id}/?token={session.access_token}")
    communicator1.scope["user"] = technician
    
    communicator2 = WebsocketCommunicator(application, f"/ws/signal/{session.id}/?token={session.access_token}")
    communicator2.scope["user"] = technician
    
    connected1, _ = await communicator1.connect()
    connected2, _ = await communicator2.connect()
    assert connected1 and connected2

    # Client 1 sends a message
    test_message = '{"payload": "test"}'
    await communicator1.send_to(text_data=test_message)
    
    # Client 2 should receive it
    response2 = await communicator2.receive_from()
    assert response2 == test_message
    
    # Client 1 should NOT receive it (echo protection)
    # receive_nothing will return True if no message is received within the timeout
    assert await communicator1.receive_nothing(timeout=0.2) is True
    
    await communicator1.disconnect()
    await communicator2.disconnect()
