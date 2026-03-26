# alert/views.py

from rest_framework import status, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema

from .permissions import *
from .models import *
from .serializers import *


class AlertRulesView(viewsets.ModelViewSet):
    ...


class UserViewSet(viewsets.ModelViewSet):
    ...