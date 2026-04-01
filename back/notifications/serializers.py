# notifications/serializers.py

from rest_framework import serializers
from .models import Notification


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id', 'user', 'type', 'payload_json', 'read_at', 'created_at']

        # Разрешаем изменять ТОЛЬКО поле read_at (для отметки "прочитано")
        read_only_fields = ['id', 'user', 'type', 'payload_json', 'created_at']