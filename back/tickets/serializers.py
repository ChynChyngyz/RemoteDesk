# tickets/serializers.py

from rest_framework import serializers
from .models import Ticket


class TicketSerializers(serializers.ModelSerializer):
    class Meta:
        model = Ticket
        fields = [
            'id', 'organization', 'device', 'incident', 'title',
            'description', 'status', 'priority', 'assignee_user',
            'created_at', 'closed_at'
        ]

        read_only_fields = [
            'id',
            'organization',
            'device',
            'incident',
            'assignee_user',
            'created_at',
            'closed_at'
        ]