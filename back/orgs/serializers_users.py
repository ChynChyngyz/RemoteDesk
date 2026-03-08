# orgs/serializers_users.py
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from .serializers import OrganizationSerializer

User = get_user_model()

class OrgUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    organization = OrganizationSerializer(read_only=True)

    class Meta:
        model = User
        fields = ["id", "phone", "password", "role", "organization"]

    def validate_password(self, value):
        validate_password(value)
        return value

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User.objects.create_user(
            password=password,
            **validated_data
        )
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop("password", None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if password:
            instance.set_password(password)
        instance.save()
        return instance