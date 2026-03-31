# alert/models.py

from django.db import models
from orgs.models import Organization

class AlertRule(models.Model):
    METRIC_CHOICES = [
        ('cpu_pct', 'CPU Usage (%)'),
        ('ram_pct', 'RAM Usage (%)'),
        ('disk_free_gb', 'Disk Free (GB)'),
        ('uptime_sec', 'Uptime (Seconds)'),
    ]

    OPERATOR_CHOICES = [
        ('>', 'Greater than'),
        ('<', 'Less than'),
        ('>=', 'Greater or equal'),
        ('<=', 'Less or equal'),
        ('==', 'Equal'),
    ]

    SEVERITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]

    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    metric = models.CharField(max_length=50, choices=METRIC_CHOICES)
    operator = models.CharField(max_length=10, choices=OPERATOR_CHOICES)
    threshold = models.FloatField()
    duration_sec = models.IntegerField()
    severity = models.CharField(max_length=20, choices=SEVERITY_CHOICES)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.metric} {self.operator} {self.threshold} (Dur: {self.duration_sec}s) - {self.severity}"