import pytest
from rest_framework import status
from django.utils import timezone
from devices.models import Device
from agent.utils import create_agent_key
from metricSample.models import MetricSample

pytestmark = pytest.mark.django_db(transaction=True)

@pytest.fixture
def admin_device(test_org, org_admin):
    return Device.objects.create(
        organization=test_org,
        hostname=f"{org_admin.phone}-admin",
        os="N/A",
        os_version="N/A",
        serial=f"ADMIN-{org_admin.id}",
        ip="0.0.0.0",
        status="active",
        agent_version="N/A"
    )

@pytest.fixture
def org_token(admin_device):
    return create_agent_key(admin_device)

@pytest.fixture
def device(test_org):
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

@pytest.fixture
def valid_agent_key(device):
    return create_agent_key(device)


def test_device_register_success(api_client, test_org, org_token):
    url = "/api/v1/agent/register/"
    data = {
        "org_token": org_token,
        "hostname": "new-machine",
        "os": "Linux",
        "os_version": "Ubuntu 22.04",
        "serial": "SN999",
        "ip": "192.168.1.10",
        "agent_version": "2.0"
    }
    response = api_client.post(url, data, format="json")
    
    assert response.status_code == status.HTTP_201_CREATED
    assert response.data["organization"] == test_org.name
    assert "agent_key" in response.data
    
    # Check if device created
    assert Device.objects.filter(serial="SN999").exists()

def test_device_register_invalid_token(api_client):
    url = "/api/v1/agent/register/"
    data = {
        "org_token": "random_invalid_token",
        "hostname": "new-machine",
        "os": "Linux",
        "os_version": "Ubuntu",
        "serial": "SN999",
        "ip": "1.1.1.1",
        "agent_version": "1.0"
    }
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_400_BAD_REQUEST

def test_agent_login_success(api_client, device, valid_agent_key, technician):
    # technician needs to exist in the same organization, we ensure it's evaluated
    assert technician.organization == device.organization
    
    url = "/api/v1/agent/login_agent/"
    data = {
        "agent_key": valid_agent_key
    }
    response = api_client.post(url, data, format="json")
    
    assert response.status_code == status.HTTP_200_OK
    assert response.data["device_id"] == device.id
    assert response.data["role"] == "Technician"

def test_device_heartbeat(api_client, device, valid_agent_key):
    url = "/api/v1/agent/heartbeat/"
    data = {"agent_key": valid_agent_key}
    response = api_client.post(url, data, format="json")
    
    assert response.status_code == status.HTTP_200_OK
    assert response.data["status"] == "ok"
    
    device.refresh_from_db()
    assert device.status == "ONLINE"
    assert device.last_seen_at is not None

def test_device_metrics_batch(api_client, device, valid_agent_key):
    url = "/api/v1/agent/metrics/batch/"
    
    data = {
        "agent_key": valid_agent_key,
        "metrics": [
            {"cpu_pct": 10, "ram_pct": 50, "disk_free_gb": 80, "uptime_sec": 3600, "ts": timezone.now().isoformat()},
            {"cpu_pct": 15, "ram_pct": 51, "disk_free_gb": 80, "uptime_sec": 3660, "ts": timezone.now().isoformat()}
        ]
    }
    
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_201_CREATED
    
    # check if saved
    assert MetricSample.objects.filter(device=device).count() == 2

def test_device_metrics_empty(api_client, device, valid_agent_key):
    url = "/api/v1/agent/metrics/batch/"
    
    data = {
        "agent_key": valid_agent_key,
        "metrics": []
    }
    
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_400_BAD_REQUEST


