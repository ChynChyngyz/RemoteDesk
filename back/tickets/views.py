# tickets/views.py

from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema_view, extend_schema

from .models import Ticket
from .serializers import TicketSerializers
#

@extend_schema_view(
    list=extend_schema(tags=['Tickets']),
    create=extend_schema(tags=['Tickets']),
    retrieve=extend_schema(tags=['Tickets']),
    partial_update=extend_schema(tags=['Tickets']),
    destroy=extend_schema(tags=['Tickets']),
)
class TicketViewSet(viewsets.ModelViewSet):
    serializer_class = TicketSerializers
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if getattr(self, "swagger_fake_view", False) or not self.request.user.is_authenticated:
            return self.serializer_class.Meta.model.objects.none() if hasattr(self, 'serializer_class') and hasattr(self.serializer_class, 'Meta') else []

        return Ticket.objects.filter(
            organization=self.request.user.organization
        )

    def perform_create(self, serializer):
        serializer.save(
            organization=self.request.user.organization
        )