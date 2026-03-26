# orgs/serializers.py
from rest_framework import serializers
from .models import Organization


class IncidentSerializers(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = []