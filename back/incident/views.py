# incident/views.py
from rest_framework import status, viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema

from .permissions import IsOrgAdmin
from .models import Incident
from .serializers import IncidentSerializers



class IncidentCreate(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated, IsOrgAdmin]
    @extend_schema(
        responses={200},
        tags=["Incidents"],
    )
    def post(self):
        ...


class IncidentView(viewsets.ModelViewSet):

    def get_object(self):
        ...

    @extend_schema(
        responses={200},
        tags=["Incidents"],
    )
    def get(self):
        ...

    @extend_schema(
        responses={200},
        tags=["Incidents"],
    )
    def put(self):
        ...

    @extend_schema(
        responses={200},
        tags=["Incidents"],
    )
    def delete(self):
        ...