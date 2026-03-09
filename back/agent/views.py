# agents/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from rest_framework import status

from .utils import verify_agent_key, create_agent_key
from .serializers import MetricSampleSerializer
from authUser.serializers import UserSerializer
from devices.models import Device
from orgs.models import Organization

from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.contrib.auth import get_user_model
from drf_spectacular.utils import extend_schema


User = get_user_model()


@method_decorator(csrf_exempt, name='dispatch')
class AgentLoginView(APIView):
    """
    Логин агента по токену.
    """
    @extend_schema(
        responses={200: MetricSampleSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        agent_key = request.data.get("agent_key")

        if not agent_key:
            raise ValidationError({"detail": "Missing 'agent_key'"})

        device = verify_agent_key(agent_key)

        if not device:
            raise ValidationError({"agent_key": "Invalid or revoked agent key"})

        user = device.organization.users.filter(role='Technician').first()

        if not user:
            raise ValidationError({"detail": "User not found"})

        user_serializer = UserSerializer(user)

        return Response(
            {
                "device_id": device.id,
                "hostname": device.hostname,
                "organization": device.organization.name,
                "status": "authenticated",
                "role": user_serializer.data['role'],
            },
            status=status.HTTP_200_OK,
        )


@method_decorator(csrf_exempt, name='dispatch')
class DeviceRegisterView(APIView):
    """
    Регистрация нового устройства (агента) через токен, выданный OrgAdmin.
    """
    @extend_schema(
        responses={200: MetricSampleSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        data = request.data
        org_token = data.get("org_token")
        hostname = data.get("hostname")
        os_name = data.get("os")
        os_version = data.get("os_version")
        serial = data.get("serial")
        ip = data.get("ip")
        agent_version = data.get("agent_version", "0.0.1")

        if not all([org_token, hostname, os_name, os_version, serial, ip]):
            raise ValidationError({"detail": "Missing required fields"})

        admin_device = verify_agent_key(org_token)
        if not admin_device:
            raise ValidationError({"org_token": "Invalid or revoked OrgAdmin token"})

        organization = admin_device.organization
        if not organization:
            raise ValidationError({"organization": "OrgAdmin has no organization"})

        device, created = Device.objects.get_or_create(
            serial=serial,
            defaults={
                "hostname": hostname,
                "os": os_name,
                "os_version": os_version,
                "ip": ip,
                "organization": organization,
                "status": "registered",
                "agent_version": agent_version,
            },
        )

        token = create_agent_key(device)

        return Response(
            {
                "device_id": device.id,
                "hostname": device.hostname,
                "organization": organization.name,
                "agent_key": token,
            },
            status=status.HTTP_201_CREATED,
        )