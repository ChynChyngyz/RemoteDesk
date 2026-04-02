# ticketComment/views.py

from rest_framework import status, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema_view, extend_schema

# from .permissions import IsOrgAdmin
from .models import TicketComment
from .serializers import TicketCommentSerializers
from tickets.models import Ticket


@extend_schema_view(
    list=extend_schema(tags=['Ticket Comments']),
    create=extend_schema(tags=['Ticket Comments']),
)
class TicketCommentsView(viewsets.ModelViewSet):
    serializer_class = TicketCommentSerializers
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if getattr(self, "swagger_fake_view", False) or not self.request.user.is_authenticated:
            return self.serializer_class.Meta.model.objects.none() if hasattr(self, 'serializer_class') and hasattr(self.serializer_class, 'Meta') else []

        ticket_id = self.kwargs["pk"]
        return TicketComment.objects.filter(
            ticket_id=ticket_id,
            ticket__organization=self.request.user.organization
        )

    def perform_create(self, serializer):
        ticket_id = self.kwargs["pk"]

        ticket = get_object_or_404(
            Ticket,
            id=ticket_id,
            organization=self.request.user.organization
        )

        serializer.save(
            author=self.request.user,
            ticket=ticket
        )