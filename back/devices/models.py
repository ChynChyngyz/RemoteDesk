# devices/models.py

from django.db import models
from orgs.models import Organization


class Device(models.Model):

    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='devices')
    # site = models.ForeignKey(Site, on_delete=models.SET_NULL, null=True, blank=True)
    hostname = models.CharField(max_length=255)
    os = models.CharField(max_length=100)
    os_version = models.CharField(max_length=100)
    serial = models.CharField(max_length=255)
    ip = models.GenericIPAddressField()
    last_seen_at = models.DateTimeField(null=True, blank=True, db_index=True)
    status = models.CharField(max_length=20, db_index=True)
    agent_version = models.CharField(max_length=50)

    def __str__(self):
        return self.hostname