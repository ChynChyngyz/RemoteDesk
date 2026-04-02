# notifications/views.py

from rest_framework import viewsets, mixins
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import Notification
from .serializers import NotificationSerializer


@extend_schema_view(
    list=extend_schema(tags=['Notifications']),
    partial_update=extend_schema(tags=['Notifications']),
)
class NotificationViewSet(
    mixins.ListModelMixin,
    mixins.UpdateModelMixin,
    viewsets.GenericViewSet
):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        if getattr(self, "swagger_fake_view", False) or not self.request.user.is_authenticated:
            return self.serializer_class.Meta.model.objects.none() if hasattr(self, 'serializer_class') and hasattr(self.serializer_class, 'Meta') else []

        return Notification.objects.filter(user=self.request.user).order_by('-created_at')