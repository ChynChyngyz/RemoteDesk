from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from drf_spectacular.utils import extend_schema

from .serializers import UserSerializer
from .models import CustomUser
from rest_framework.permissions import BasePermission


class IsOrgAdmin(BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and \
               request.user.role == CustomUser.Role.ORG_ADMIN


class RegisterView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(
        request=UserSerializer,
        responses={201: {"message": "User created successfully, please confirm registration"}},
        tags=["Register"],
    )
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        # user = serializer.save(role=CustomUser.Role.CLIENT_VIEWER)

        return Response(
            {"message": "User created successfully"},
            status=status.HTTP_201_CREATED
        )


class CurrentUserView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        responses={200: UserSerializer},
        tags=["Users"],
    )
    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)


class DeleteUser(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]

    @extend_schema(
        request=None,
        responses={200: {"message": "User deleted successfully"}},
        tags=["Users"],
    )
    def delete(self, request, pk):
        if request.user.id == int(pk):
            return Response({"error": "Your cannot delete yourself"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = CustomUser.objects.get(pk=pk)
        except CustomUser.DoesNotExist:
            return Response({"error": "User does not exist"}, status=status.HTTP_404_NOT_FOUND)

        user.delete()
        return Response({"message": "User deleted successfully"}, status=status.HTTP_200_OK)


class UpdateUser(APIView):
    permission_classes = [IsAuthenticated, IsOrgAdmin]

    @extend_schema(
        request=None,
        responses={200: {"message": "User updated successfully"}},
        tags=["Users"],
    )
    def put(self, request, pk):
        try:
            user = CustomUser.objects.get(pk=pk)
        except CustomUser.DoesNotExist:
            return Response({"error": "User does not exist"}, status=status.HTTP_404_NOT_FOUND)

        serializer = UserSerializer(user, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)

        password = serializer.validated_data.pop("password", None)

        updated_user = serializer.save()

        if password:
            updated_user.set_password(password)
            updated_user.save()

        return Response({"message": "User updated successfully"}, status=status.HTTP_200_OK)