# authUser/serializers.py
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth import get_user_model
from rest_framework import serializers

from orgs.serializers import OrganizationSerializer

CustomUser = get_user_model()


class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()


class PhoneLoginSerializer(TokenObtainPairSerializer):
    username_field = "phone"


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    organization = OrganizationSerializer(read_only=True)

    class Meta:
        model = CustomUser
        fields = ["id", "phone", "password", "role", "organization"]
