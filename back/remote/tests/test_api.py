import pytest
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APIRequestFactory
from devices.models import Device
from remote.views import RemoteSessionRequestView, RemoteSessionApproveView, RemoteSessionEndView
from remote.models import RemoteSession

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

def test_remote_session_request(api_client, technician, device, test_org):
    url = "/api/v1/orgs/remote-session/request"
    api_client.force_authenticate(user=technician)
    
    data = {
        "organization": test_org.id,
        "device": device.id
    }
    
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_201_CREATED
    assert "session_id" in response.data
    assert "access_token" in response.data
    
    session = RemoteSession.objects.get(id=response.data["session_id"])
    assert session.status == "pending"
    assert session.requester_user == technician

def test_remote_session_approve_and_end(technician, device, test_org):
    # Setup session
    session = RemoteSession.objects.create(
        organization=test_org,
        device=device,
        requester_user=technician,
        status="pending",
        consent_method="manual",
        access_token="test_token_123"
    )
    
    factory = APIRequestFactory()
    
    # Approve
    approve_view = RemoteSessionApproveView.as_view()
    start_time = timezone.now().isoformat()
    request = factory.post(f"/dummy/{session.id}/approve/", {"started_at": start_time}, format="json")
    
    response = approve_view(request, id=session.id)
    assert response.status_code == status.HTTP_200_OK
    
    session.refresh_from_db()
    assert session.status == "approved"
    assert session.started_at is not None
    
    # End
    end_view = RemoteSessionEndView.as_view()
    end_time = timezone.now().isoformat()
    request = factory.post(f"/dummy/{session.id}/end/", {"ended_at": end_time}, format="json")
    
    response = end_view(request, id=session.id)
    assert response.status_code == status.HTTP_200_OK
    
    session.refresh_from_db()
    assert session.status == "ended"
    assert session.ended_at is not None
