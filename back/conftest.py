import pytest
from rest_framework.test import APIClient
from authUser.models import CustomUser
from orgs.models import Organization

@pytest.fixture
def api_client():
    return APIClient()

@pytest.fixture
def test_org(db):
    return Organization.objects.create(name="Test Org")

@pytest.fixture
def other_org(db):
    return Organization.objects.create(name="Other Org")

@pytest.fixture
def org_admin(db, test_org):
    user = CustomUser.objects.create_user(
        phone="+1234567890",
        password="password123",
        role=CustomUser.Role.ORG_ADMIN,
        organization=test_org
    )
    return user

@pytest.fixture
def technician(db, test_org):
    user = CustomUser.objects.create_user(
        phone="+1987654321",
        password="password123",
        role=CustomUser.Role.TECHNICIAN,
        organization=test_org
    )
    return user

@pytest.fixture
def client_viewer(db, test_org):
    user = CustomUser.objects.create_user(
        phone="+1112223333",
        password="password123",
        role=CustomUser.Role.CLIENT_VIEWER,
        organization=test_org
    )
    return user

@pytest.fixture
def other_technician(db, other_org):
    user = CustomUser.objects.create_user(
        phone="+1987654322",
        password="password123",
        role=CustomUser.Role.TECHNICIAN,
        organization=other_org
    )
    return user
