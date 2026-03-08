from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from django.conf.urls.static import static
from django.conf import settings

from . import views

urlpatterns = [
    path("login/", views.PhoneLoginView.as_view(), name="login"),
    path("logout/", views.LogoutView.as_view(), name="logout"),
    path("generate_agent_token/", views.GenerateAgentTokenView.as_view(), name="generate_agent_token"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("me/", views.CurrentUserView.as_view(), name="current_user"),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)