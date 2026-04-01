# incident/views.py

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Incident
from .serializers import IncidentSerializers

from drf_spectacular.utils import extend_schema, extend_schema_view


@extend_schema_view(
    list=extend_schema(tags=['Incident']),
    retrieve=extend_schema(tags=['Incident']),
    partial_update=extend_schema(tags=['Incident']),
)
class IncidentViewSet(viewsets.ModelViewSet):
    serializer_class = IncidentSerializers
    permission_classes = [IsAuthenticated]

    http_method_names = ['get', 'patch', 'head', 'options']

    def get_queryset(self):
        return Incident.objects.filter(organization=self.request.user.organization)
