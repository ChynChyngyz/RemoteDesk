from django.db import models
from authUser.models import CustomUser

class Organization(models.Model):
    organization = models.TextField()
    name = models.CharField(max_length=255)
    status = models.BooleanField(default=False)
    last_seen_at = models.DateTimeField(auto_now_add=True)
    agents_key_hash = models.ManyToManyField(User)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name