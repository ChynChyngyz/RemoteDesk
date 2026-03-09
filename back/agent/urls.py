# agents/urls.py
from django.urls import path
from django.conf.urls.static import static
from django.conf import settings
from . import views

urlpatterns = [
    path("register/", views.DeviceRegisterView.as_view()),
    path("login_agent/", views.AgentLoginView.as_view()),
    # path("heartbeat/", views.DeviceHeartbeatView.as_view()),
    # path("metrics/batch/", views.DeviceMetricsView.as_view()),
    # path("diagnostics/run/", views.DeviceDiagnosticsView.as_view()),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)