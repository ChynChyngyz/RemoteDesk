from django.db import models
from orgs.models import Organization
from devices.models import Device
from authUser.models import CustomUser


class RemoteSession(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    device = models.ForeignKey(Device, on_delete=models.CASCADE)
    requester_user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    status = models.CharField(max_length=30)
    started_at = models.DateTimeField(null=True, blank=True)
    ended_at = models.DateTimeField(null=True, blank=True)
    consent_method = models.CharField(max_length=100)
    audit_blob = models.TextField()

    def __str__(self):
        return f"{self.organization} | {self.device} | {self.requester_user} | {self.status}"