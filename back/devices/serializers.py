# devices/serializers.py

from rest_framework import serializers
from .models import Device


class DevicesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = [
            'id', 'organization', 'hostname', 'os',
            'os_version', 'serial', 'ip', 'last_seen_at',
            'status', 'agent_version'
        ]
        read_only_fields = ['id', 'organization', 'last_seen_at']