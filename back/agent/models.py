from django.db import models
from devices.models import Device


class AgentKey(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    token_hash = models.TextField()
    issued_at = models.DateTimeField(auto_now_add=True)
    revoked_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.device.hostname} token"