# audit/views.py

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import AuditEvent
from .serializers import AuditEventSerializer

@extend_schema_view(
    list=extend_schema(tags=['Audit']),
    retrieve=extend_schema(tags=['Audit']),
)
class AuditEventViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = AuditEventSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return AuditEvent.objects.filter(
            organization=self.request.user.organization
        ).order_by('-created_at')