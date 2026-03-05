from django.db import models
from orgs.models import Organization


class AlertRule(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    metric = models.CharField(max_length=50)
    operator = models.CharField(max_length=10)
    threshold = models.FloatField()
    duration_sec = models.IntegerField()
    severity = models.CharField(max_length=20)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.metric} {self.operator} {self.threshold} {self.duration_sec} {self.severity}"