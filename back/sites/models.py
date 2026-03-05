from django.db import models
from orgs.models import Organization

class Site(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.name
