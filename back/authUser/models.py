from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models


class CustomUserManager(BaseUserManager):

    def create_user(self, phone, password, **extra_fields):

        if not phone:
            raise ValueError("Phone is required")

        if not password:
            raise ValueError("Password is required")

        user = self.model(phone=phone, **extra_fields)

        user.set_password(password)

        user.save(using=self._db)

        return user

    def create_superuser(self, phone, password, **extra_fields):

        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('role', 'OrgAdmin')

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True')

        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True')

        return self.create_user(phone, password, **extra_fields)


class CustomUser(AbstractBaseUser, PermissionsMixin):

    class Role(models.TextChoices):
        ORG_ADMIN = 'OrgAdmin', 'OrgAdmin'
        TECHNICIAN = 'Technician', 'Technician'
        CLIENT_VIEWER = 'ClientViewer', 'ClientViewer'

    phone = models.CharField(
        max_length=20,
        unique=True,
        db_index=True
    )

    role = models.CharField(
        max_length=20,
        choices=Role.choices,
        default=Role.ORG_ADMIN
    )

    organization = models.ForeignKey(
        'orgs.Organization',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='users'
    )

    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'phone'
    REQUIRED_FIELDS = []

    def __str__(self):
        return f"{self.phone} ({self.role})"