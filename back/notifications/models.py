# notifications/models.py

from django.db import models
from authUser.models import CustomUser

class Notification(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='notifications')
    type = models.CharField(max_length=100)  # Например: 'incident_opened', 'ticket_updated'
    payload_json = models.JSONField(default=dict)
    read_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.type} - {self.user.phone}"