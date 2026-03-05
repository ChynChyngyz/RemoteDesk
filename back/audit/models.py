from django.db import models
from authUser.models import CustomUser


class Notification(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='audit_notifications')
    type = models.CharField(max_length=50)
    payload_json = models.JSONField()
    read_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return (self.type,
                self.created_at)