# authUser/serializers.py
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth import get_user_model
from rest_framework import serializers

from orgs.serializers import OrganizationSerializer


class DevicesSerializer(serializers.ModelSerializer):
    ...