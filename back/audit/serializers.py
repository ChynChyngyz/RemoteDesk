# audit/serializers.py

from rest_framework import serializers
from .models import AuditEvent

class AuditEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = AuditEvent
        fields = [
            'id', 'organization', 'actor_user', 'actor_device',
            'type', 'metadata_json', 'created_at'
        ]
        read_only_fields = fields # Абсолютно все поля read-only