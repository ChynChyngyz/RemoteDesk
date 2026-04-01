# metricSample/models.py

from django.db import models
from devices.models import Device


class MetricSample(models.Model):
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    ts = models.DateTimeField()
    cpu_pct = models.IntegerField()
    ram_pct = models.IntegerField()
    disk_free_gb = models.IntegerField()
    uptime_sec = models.IntegerField()

    def __str__(self):
        return f"{self.device.hostname} metrics"
