from django.db import models
from orgs.models import Organization
from devices.models import Device
from alert.models import AlertRule


class Incident(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    rule = models.ForeignKey(AlertRule, on_delete=models.CASCADE)
    opened_at = models.DateTimeField(auto_now_add=True)
    resolved_at = models.DateTimeField(null=True, blank=True)
    severity = models.CharField(max_length=20)
    status = models.CharField(max_length=20)
    last_event_at = models.DateTimeField()

    def __str__(self):
        return f"{self.device.hostname} {self.status}"