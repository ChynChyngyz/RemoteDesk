from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models


class CustomUserManager(BaseUserManager):
    def create_user(self, phone, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')

        email = self.normalize_email(email)
        user = self.model(phone=phone, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, phone, email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        superuser = self.create_user(phone, email, password, role='OrgAdmin', **extra_fields)

        return superuser


class CustomUser(AbstractBaseUser, PermissionsMixin):
    class Role(models.TextChoices):
        ORG_ADMIN = 'OrgAdmin', 'OrgAdmin'
        TECHNICIAN = 'Technician', 'Technician'
        CLIENT_VIEWER = 'ClientViewer', 'ClientViewer'

    email = models.EmailField(max_length=255, unique=True)
    phone = models.CharField(max_length=20, unique=True)
    role = models.CharField(
        max_length=20,
        choices=Role.choices,
        default=Role.ORG_ADMIN
    )
    # Связь с организацией (nullable для MSP) [cite: 913]
    organization = models.ForeignKey(
        'orgs.Organization',
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )

    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'phone'
    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return f"{self.phone} ({self.role})"

class Profile(models.Model):
    ...

