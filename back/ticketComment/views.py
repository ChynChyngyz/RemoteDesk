# ticketComment/views.py

from rest_framework import status, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema

from .permissions import IsOrgAdmin
from .models import TicketComment
from .serializers import TicketCommentSerializers


class TicketCommentsView(viewsets.ModelViewSet):
    serializer_class = TicketCommentSerializers
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        ticket_id = self.kwargs["pk"]

        return TicketComment.objects.filter(
            ticket_id=ticket_id,
            ticket__organization=self.request.user.organization
        )

    def perform_create(self, serializer):
        serializer.save(
            author=self.request.user,
            ticket_id=self.kwargs["pk"]
        )