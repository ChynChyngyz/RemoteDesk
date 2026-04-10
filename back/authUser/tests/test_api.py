import pytest
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient

pytestmark = pytest.mark.django_db

def test_login_success(api_client, org_admin):
    url = "/api/v1/auth/login/"
    data = {
        "phone": org_admin.phone,
        "password": "password123"
    }
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_200_OK
    assert "access" in response.data
    assert "refresh" in response.data

def test_login_failure(api_client, org_admin):
    url = "/api/v1/auth/login/"
    data = {
        "phone": org_admin.phone,
        "password": "wrongpassword"
    }
    response = api_client.post(url, data, format="json")
    assert response.status_code == status.HTTP_401_UNAUTHORIZED

def test_current_user_me(api_client, org_admin):
    # Login first to get token
    login_url = "/api/v1/auth/login/"
    resp = api_client.post(login_url, {"phone": org_admin.phone, "password": "password123"}, format="json")
    token = resp.data["access"]
    
    api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {token}')
    
    me_url = "/api/v1/auth/me/"
    response = api_client.get(me_url)
    assert response.status_code == status.HTTP_200_OK
    assert response.data["phone"] == org_admin.phone
    assert response.data["role"] == "OrgAdmin"

def test_generate_agent_token_as_org_admin(api_client, org_admin):
    api_client.force_authenticate(user=org_admin)
    url = "/api/v1/auth/generate_agent_token/"
    
    response = api_client.post(url)
    assert response.status_code == status.HTTP_200_OK
    assert "org_token" in response.data

def test_generate_agent_token_as_technician(api_client, technician):
    api_client.force_authenticate(user=technician)
    url = "/api/v1/auth/generate_agent_token/"
    
    response = api_client.post(url)
    assert response.status_code == status.HTTP_403_FORBIDDEN
    
def test_generate_agent_token_as_client_viewer(api_client, client_viewer):
    api_client.force_authenticate(user=client_viewer)
    url = "/api/v1/auth/generate_agent_token/"
    
    response = api_client.post(url)
    assert response.status_code == status.HTTP_403_FORBIDDEN
