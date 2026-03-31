from django.db import models
from orgs.models import Organization
from devices.models import Device
from alert.models import AlertRule

class Incident(models.Model):
    STATUS_CHOICES = [
        ('OPEN', 'Open'),
        ('ACKNOWLEDGED', 'Acknowledged'),
        ('RESOLVED', 'Resolved'),
    ]

    SEVERITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]

    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    rule = models.ForeignKey(AlertRule, on_delete=models.CASCADE)
    opened_at = models.DateTimeField(auto_now_add=True)
    resolved_at = models.DateTimeField(null=True, blank=True)
    severity = models.CharField(max_length=20, choices=SEVERITY_CHOICES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='OPEN')
    last_event_at = models.DateTimeField(auto_now=True) # Обновляется автоматически при событиях

    def __str__(self):
        return f"{self.device.hostname} - {self.status} ({self.severity})"