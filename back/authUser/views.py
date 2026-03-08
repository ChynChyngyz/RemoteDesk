# authUser/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.permissions import IsAuthenticated

from drf_spectacular.utils import extend_schema

from .serializers import PhoneLoginSerializer, LogoutSerializer, UserSerializer
from .permissions import IsOrgAdmin

from devices.models import Device
from agent.utils import create_agent_key


class PhoneLoginView(TokenObtainPairView):
    serializer_class = PhoneLoginSerializer


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        request=LogoutSerializer,
        responses={200: None},
        tags=["Users"],
    )
    def post(self, request):

        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
        except Exception:
            pass

        return Response({"message": "Logged out"})


class CurrentUserView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        responses={200: UserSerializer},
        tags=["Users"],
    )
    def get(self, request):
        user = request.user
        serializer = UserSerializer(user)
        return Response(serializer.data)


class GenerateAgentTokenView(APIView):
    """
    Временный endpoint для генерации токена агента
    OrgAdmin создает токен для регистрации нового устройства.
    """
    permission_classes = [IsAuthenticated, IsOrgAdmin]

    @extend_schema(
        tags=["Users"],
    )
    def post(self, request):
        user = request.user

        if not user.organization:
            return Response(
                {"error": "User has no organization"},
                status=status.HTTP_400_BAD_REQUEST
            )

        admin_device, created = Device.objects.get_or_create(
            organization=user.organization,
            hostname=f"{user.phone}-admin",
            defaults={
                "os": "N/A",
                "os_version": "N/A",
                "serial": f"ADMIN-{user.id}",
                "ip": "0.0.0.0",
                "status": "active",
                "agent_version": "N/A"
            }
        )

        # Генерируем токен
        agent_token = create_agent_key(admin_device)

        return Response({"org_token": agent_token})