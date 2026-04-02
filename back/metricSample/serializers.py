from rest_framework import serializers
from .models import MetricSample

class AdminMetricSampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = MetricSample
        fields = '__all__'
