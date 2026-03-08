# orgs/views_users.py
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from drf_spectacular.utils import extend_schema

from .permissions import IsOrgAdmin
from .models import Organization
from .serializers import OrganizationSerializer


class OrgCreateView(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]
    serializer_class = OrganizationSerializer

    def post(self, request):
        if request.user.organization:
            raise ValidationError(
                {"organization": "User already has an organization."}
            )

        serializer = OrganizationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        org = serializer.save()

        request.user.organization = org
        request.user.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)


class OrgDetailView(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]
    serializer_class = OrganizationSerializer

    def get_object(self, pk):
        return get_object_or_404(Organization, pk=pk)

    @extend_schema(
        responses={200: OrganizationSerializer},
        tags=["Organization"],
    )
    def get(self, request, pk):
        org = self.get_object(pk)
        serializer = OrganizationSerializer(org)
        return Response(serializer.data)

    @extend_schema(
        request=OrganizationSerializer,
        responses={200: OrganizationSerializer},
        tags=["Organization"],
    )
    def put(self, request, pk):
        org = self.get_object(pk)
        serializer = OrganizationSerializer(org, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    @extend_schema(
        responses={204: None},
        tags=["Organization"],
    )
    def delete(self, request, pk):
        org = self.get_object(pk)
        org.delete()
        return Response(status=204)