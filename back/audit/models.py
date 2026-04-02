# audit/models.py

from django.db import models
from orgs.models import Organization
from authUser.models import CustomUser
from devices.models import Device

class AuditEvent(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='audit_events')
    actor_user = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, blank=True)
    actor_device = models.ForeignKey(Device, on_delete=models.SET_NULL, null=True, blank=True)
    type = models.CharField(max_length=255) # Например: 'agent_token_issued', 'remote_session_started'
    metadata_json = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    def __str__(self):
        return f"{self.type} - Org: {self.organization.name}"