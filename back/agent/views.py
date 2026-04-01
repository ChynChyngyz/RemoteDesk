# agents/views.py

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from rest_framework import status

from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.utils import timezone
from drf_spectacular.utils import extend_schema

from .utils import verify_agent_key, create_agent_key
from .permissions import IsAuthenticatedAgent
from .serializers import (
    MetricSampleBatchRequestSerializer,
    MetricsResponseSerializer,
    AgentLoginRequestSerializer,
    AgentLoginResponseSerializer,
    AgentRegisterRequestSerializer,
    AgentRegisterResponseSerializer,
    HeartbeatResponseSerializer,
)

from authUser.serializers import UserSerializer
from devices.models import Device
from metricSample.models import MetricSample


@method_decorator(csrf_exempt, name='dispatch')
class AgentLoginView(APIView):
    @extend_schema(
        request=AgentLoginRequestSerializer,
        responses={200: AgentLoginResponseSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        serializer = AgentLoginRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        agent_key = serializer.validated_data['agent_key']
        device = verify_agent_key(agent_key)

        if not device:
            raise ValidationError({"agent_key": "Invalid or revoked agent key"})

        user = device.organization.users.filter(role='Technician').first()
        if not user:
            raise ValidationError({"detail": "User not found"})

        return Response({
            "device_id": device.id,
            "hostname": device.hostname,
            "organization": device.organization.name,
            "status": "authenticated",
            "role": user.role,
        }, status=status.HTTP_200_OK)


@method_decorator(csrf_exempt, name='dispatch')
class DeviceRegisterView(APIView):
    @extend_schema(
        request=AgentRegisterRequestSerializer,
        responses={201: AgentRegisterResponseSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        serializer = AgentRegisterRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        admin_device = verify_agent_key(data['org_token'])
        if not admin_device:
            raise ValidationError({"org_token": "Invalid or revoked OrgAdmin token"})

        organization = admin_device.organization
        if not organization:
            raise ValidationError({"organization": "OrgAdmin has no organization"})

        device, created = Device.objects.get_or_create(
            serial=data['serial'],
            defaults={
                "hostname": data['hostname'],
                "os": data['os'],
                "os_version": data['os_version'],
                "ip": data['ip'],
                "organization": organization,
                "status": "registered",
                "agent_version": data['agent_version'],
            },
        )

        token = create_agent_key(device)

        return Response({
            "device_id": device.id,
            "hostname": device.hostname,
            "organization": organization.name,
            "agent_key": token,
        }, status=status.HTTP_201_CREATED)


@method_decorator(csrf_exempt, name='dispatch')
class DeviceHeartbeatView(APIView):
    permission_classes = [IsAuthenticatedAgent]

    @extend_schema(
        responses={200: HeartbeatResponseSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        device = request.device

        device.last_seen_at = timezone.now()
        device.status = "ONLINE"
        device.save(update_fields=['last_seen_at', 'status'])

        return Response({"status": "ok"}, status=status.HTTP_200_OK)


@method_decorator(csrf_exempt, name='dispatch')
class DeviceMetricsView(APIView):
    permission_classes = [IsAuthenticatedAgent]

    @extend_schema(
        request=MetricSampleBatchRequestSerializer,
        responses={201: MetricsResponseSerializer},
        tags=["Agent"],
    )
    def post(self, request):
        serializer = MetricSampleBatchRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        metrics_data = serializer.validated_data.get("metrics", [])
        if not metrics_data:
            raise ValidationError({"detail": "No metrics provided"})

        # используем bulk_create для массива метрик
        metric_instances = [
            MetricSample(device=request.device, **metric)
            for metric in metrics_data
        ]
        MetricSample.objects.bulk_create(metric_instances)

        return Response({"status": "batch saved"}, status=status.HTTP_201_CREATED)