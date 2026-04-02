from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema_view, extend_schema

from .models import MetricSample
from .serializers import AdminMetricSampleSerializer


@extend_schema_view(
    list=extend_schema(tags=['Metric sample'], description='List all metric samples'),\
    retrieve=extend_schema(tags=['Metric sample'],)
)
class MetricSampleViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint that allows MetricSamples to be viewed by Admins.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = AdminMetricSampleSerializer

    def get_queryset(self):
        if getattr(self, "swagger_fake_view", False) or not self.request.user.is_authenticated:
            return self.serializer_class.Meta.model.objects.none() if hasattr(self, 'serializer_class') and hasattr(self.serializer_class, 'Meta') else []

        org_id = self.request.query_params.get('organization')
        if org_id:
            return MetricSample.objects.filter(device__organization_id=org_id).order_by('-ts')
        else:
            # If no org specified, optionally return none or user's orgs
            return MetricSample.objects.none()
