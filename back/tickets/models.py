from django.db import models
from orgs.models import Organization
from devices.models import Device
from authUser.models import CustomUser
from incident.models import Incident


class Ticket(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    device = models.ForeignKey(Device, on_delete=models.SET_NULL, null=True)
    incident = models.ForeignKey(Incident, on_delete=models.SET_NULL, null=True)
    title = models.CharField(max_length=255)
    description = models.TextField()
    priority = models.CharField(max_length=20)
    assignee_user = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True)
    status = models.CharField(max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)
    closed_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.title