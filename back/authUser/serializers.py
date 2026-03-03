from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError

# from django.core.validators import MinLengthValidator, MaxLengthValidator

from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = get_user_model()
        fields = ('id', 'email', 'password', 'phone', 'role', 'organization')

    def validate_password(self, value):
        try:
            validate_password(value)
        except ValidationError as e:
            raise serializers.ValidationError(str(e))
        return value

    def create(self, validated_data):
        password = validated_data.pop('password')
        validate_password(password)
        user = get_user_model().objects.create_user(
            password=password,
            **validated_data
        )
        return user




