# orgs/views_users.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth import get_user_model

from .serializers_users import OrgUserSerializer
from .permissions import IsOrgAdmin

from drf_spectacular.utils import extend_schema

User = get_user_model()


class OrgUsersView(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]
    serializer_class = OrgUserSerializer
    @extend_schema(
        responses={200: OrgUserSerializer(many=True)},
        tags=["Organization Users"],
    )
    def get(self, request):
        users = User.objects.filter(
            organization=request.user.organization
        )
        serializer = OrgUserSerializer(users, many=True)

        return Response(serializer.data)

    @extend_schema(
        responses={200: OrgUserSerializer},
        tags=["Organization Users"],
    )
    def post(self, request):
        serializer = OrgUserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(
            organization=request.user.organization
        )

        return Response(serializer.data, status=201)

class OrgUserDetailView(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]
    serializer_class = OrgUserSerializer
    @extend_schema(
        responses={200: OrgUserSerializer},
        tags=["Organization Users"],
    )
    def get(self, request):
        users = User.objects.filter(
            organization=request.user.organization
        )
        serializer = OrgUserSerializer(users, many=True)

        return Response(serializer.data)

    @extend_schema(
        responses={200: OrgUserSerializer},
        tags=["Organization Users"],
    )
    def put(self, request, pk):
        user = self.get_object(request, pk)

        serializer = OrgUserSerializer(
            user,
            data=request.data,
            partial=True
        )

        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data)

    @extend_schema(
        responses={204: None},
        tags=["Organization Users"],
    )
    def delete(self, request, pk):
        user = self.get_object(request, pk)
        user.delete()

        return Response(status=204)