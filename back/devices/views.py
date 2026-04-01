# devices/views.py

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import Device
from .serializers import DevicesSerializer


@extend_schema_view(
    list=extend_schema(tags=['Devices']),
    create=extend_schema(tags=['Devices']),
)
class DevicesViewSet(viewsets.ModelViewSet):
    serializer_class = DevicesSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['status', 'last_seen_at']

    def get_queryset(self):
        return Device.objects.filter(organization=self.request.user.organization)

    def perform_create(self, serializer):
        serializer.save(organization=self.request.user.organization)