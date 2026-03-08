# agents/serializers.py
from rest_framework import serializers
from metricSample.models import MetricSample

class MetricSampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = MetricSample
        fields = ["ts", "cpu_pct", "ram_pct", "disk_free_gb", "uptime_sec"]

class MetricSampleBatchSerializer(serializers.Serializer):
    agent_key = serializers.CharField()
    metrics = MetricSampleSerializer(many=True)