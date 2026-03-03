from django.db import models

class Organization(models.Model):
    name = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    industry = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name