from django.urls import path
from django.conf.urls.static import static
from django.conf import settings

from . import views_users
from . import views

urlpatterns = [
    path("organizations/", views.OrgCreateView.as_view()),
    path("organizations/<int:pk>/", views.OrgDetailView.as_view()),
    path("users/", views_users.OrgUsersView.as_view()),
    path("users/<int:pk>", views_users.OrgUserDetailView.as_view()),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)