from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated

from .models import Device
from .serializers import DeviceSerializer


class ClientDevicesView(ListAPIView):

    serializer_class = DeviceSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):

        return Device.objects.filter(
            organization=self.request.user.organization
        )


class ClientIncidentsView(ListAPIView):

    serializer_class = IncidentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):

        return Incident.objects.filter(
            organization=self.request.user.organization
        )