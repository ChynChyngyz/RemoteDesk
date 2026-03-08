# agents/urls.py
from django.urls import path
from django.conf.urls.static import static
from django.conf import settings
from . import views

urlpatterns = [
    path("register/", views.DeviceRegisterView.as_view()),
    # path("agent/heartbeat", views.DeviceHeartbeatView.as_view()),
    # path("agent/metrics/batch", views.DeviceMetricsView.as_view()),
    # path("agent/diagnostics/run", views.DeviceDiagnosticsView.as_view()),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)