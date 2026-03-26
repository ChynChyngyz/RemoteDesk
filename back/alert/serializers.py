# orgs/serializers.py
from rest_framework import serializers
from .models import Organization


class AlertSerializers(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ["id", "name", "city", "industry", "is_active"]