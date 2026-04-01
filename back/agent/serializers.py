# agents/serializers.py

from rest_framework import serializers
from metricSample.models import MetricSample


class MetricSampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = MetricSample
        fields = ["ts", "cpu_pct", "ram_pct", "disk_free_gb", "uptime_sec"]


class MetricSampleBatchRequestSerializer(serializers.Serializer):
    agent_key = serializers.CharField(required=False)
    metrics = MetricSampleSerializer(many=True)


class MetricsResponseSerializer(serializers.Serializer):
    status = serializers.CharField()


class AgentLoginRequestSerializer(serializers.Serializer):
    agent_key = serializers.CharField()


class AgentLoginResponseSerializer(serializers.Serializer):
    device_id = serializers.IntegerField()
    hostname = serializers.CharField()
    organization = serializers.CharField()
    status = serializers.CharField()
    role = serializers.CharField()


class AgentRegisterRequestSerializer(serializers.Serializer):
    org_token = serializers.CharField()
    hostname = serializers.CharField()
    os = serializers.CharField()
    os_version = serializers.CharField()
    serial = serializers.CharField()
    ip = serializers.IPAddressField()
    agent_version = serializers.CharField(required=False, default="0.0.1")


class AgentRegisterResponseSerializer(serializers.Serializer):
    device_id = serializers.IntegerField()
    hostname = serializers.CharField()
    organization = serializers.CharField()
    agent_key = serializers.CharField()


class HeartbeatResponseSerializer(serializers.Serializer):
    status = serializers.CharField()