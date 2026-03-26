# tickets/views.py

from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema

from .permissions import IsOrgAdmin
from .models import Ticket
from .serializers import TicketSerializers

from rest_framework import status

from django.shortcuts import get_object_or_404


class TicketsView(APIView):
    permission_classes = [IsAuthenticated]
    @extend_schema(
        responses={200: TicketSerializers},
        tags=['Tickets'],
    )
    def get(self, request):
        user = request.user

        # фильтр по организации
        tickets = Ticket.objects.filter(organization=user.organization)

        serializer = TicketSerializers(tickets, many=True)
        return Response(serializer.data)

    @extend_schema(
        responses={200: TicketSerializers},
        tags=['Tickets'],
    )
    def post(self, request):
        user = request.user

        data = request.data.copy()
        data["organization"] = user.organization.id

        serializer = TicketSerializers(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)

        return Response(serializer.errors, status=400)


class TicketDetailView(APIView):
    permission_classes = [IsAuthenticated]
    @extend_schema(
        responses={200: TicketSerializers},
        tags=['Tickets'],
    )
    def get(self, request, pk):
        ticket = get_object_or_404(
            Ticket,
            pk=pk,
            organization=request.user.organization
        )

        serializer = TicketSerializers(ticket)
        return Response(serializer.data)

    @extend_schema(
        responses={200: TicketSerializers},
        tags=['Tickets'],
    )
    def patch(self, request, pk):
        ticket = get_object_or_404(
            Ticket,
            pk=pk,
            organization=request.user.organization
        )

        serializer = TicketSerializers(ticket, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors, status=400)