# incident/serializers.py

from rest_framework import serializers
from .models import Incident

class IncidentSerializers(serializers.ModelSerializer):
    class Meta:
        model = Incident
        fields = [
            'id', 'organization', 'device', 'rule',
            'opened_at', 'resolved_at', 'severity',
            'status', 'last_event_at'
        ]
        read_only_fields = [
            'id', 'organization', 'device', 'rule',
            'opened_at', 'resolved_at', 'severity', 'last_event_at'
        ]