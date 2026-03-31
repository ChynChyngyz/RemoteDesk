# alert/serializers.py

from rest_framework import serializers
from .models import AlertRule

class AlertSerializers(serializers.ModelSerializer):
    class Meta:
        model = AlertRule
        fields = [
            'id', 'organization', 'metric', 'operator',
            'threshold', 'duration_sec', 'severity', 'is_active'
        ]
        read_only_fields = ['id', 'organization']