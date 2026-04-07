import uuid

from rest_framework.views import APIView
from rest_framework.response import Response

from drf_spectacular.utils import extend_schema

from .models import RemoteSession
from .turn import generate_turn_credentials

from devices.models import Device
from agent.models import AgentKey
from orgs.models import Organization
from authUser.models import CustomUser
from notifications.models import Notification


class TurnCredentialsView(APIView):
    def get(self, request):
        return Response(generate_turn_credentials())


class RemoteSessionRequestView(APIView):

    @extend_schema(
        request=None,
        responses={201: {"message": "Remote session requested"}},
        tags=["Remote Assist"],
    )
    def post(self, request):

        session = RemoteSession.objects.create(
            organization_id=request.data.get("organization"),
            device_id=request.data.get("device"),
            requester_user=request.user,
            status="pending",
            consent_method="manual",
            access_token=str(uuid.uuid4())
        )

        return Response({
            "session_id": session.id,
            "access_token": session.access_token
        }, status=201)


class RemoteSessionApproveView(APIView):

    @extend_schema(
        request=None,
        responses={200: {"message": "Remote session approved"}},
        tags=["Remote Assist"],
    )
    def post(self, request, id):

        session = RemoteSession.objects.get(id=id)
        session.status = "approved"
        session.started_at = request.data.get("started_at")
        session.save()

        return Response({"message": "Remote session approved"})


class RemoteSessionEndView(APIView):

    @extend_schema(
        request=None,
        responses={200: {"message": "Remote session ended"}},
        tags=["Remote Assist"],
    )
    def post(self, request, id):

        session = RemoteSession.objects.get(id=id)
        session.status = "ended"
        session.ended_at = request.data.get("ended_at")
        session.save()

        return Response({"message": "Remote session ended"})