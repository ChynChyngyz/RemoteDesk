# alert/views.py

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .permissions import IsOrgAdmin
from .serializers import *

from drf_spectacular.utils import extend_schema_view, extend_schema


@extend_schema_view(
    list=extend_schema(tags=['Alert']),
    create=extend_schema(tags=['Alert']),
    retrieve=extend_schema(tags=['Alert']),
    update=extend_schema(tags=['Alert']),
    partial_update=extend_schema(tags=['Alert']),
    destroy=extend_schema(tags=['Alert']),
)
class AlertRulesView(viewsets.ModelViewSet):
    serializer_class = AlertSerializers
    permission_classes = [IsAuthenticated, IsOrgAdmin]

    def get_queryset(self):
        return AlertRule.objects.filter(organization=self.request.user.organization)

    def perform_create(self, serializer):
        serializer.save(organization=self.request.user.organization)