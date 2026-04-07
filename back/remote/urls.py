from django.urls import path
from .views import TurnCredentialsView

urlpatterns = [
    path("turn-credentials/", TurnCredentialsView.as_view()),
]