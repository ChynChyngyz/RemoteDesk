import django_filters

from .models import CustomUser

class UserFilter(django_filters.rest_framework.FilterSet):
    user = django_filters.ModelChoiceFilter(queryset=CustomUser.objects.filter(is_active=True))
    admin = django_filters.ModelChoiceFilter(queryset=CustomUser.objects.filter(is_superuser=True))
    technician = django_filters.ModelChoiceFilter(queryset=CustomUser.objects.filter(is_staff=True))

    class Meta:
        model = CustomUser