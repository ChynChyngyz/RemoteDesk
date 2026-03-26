from django.urls import path
from django.conf.urls.static import static
from django.conf import settings

from . import views_users
from . import views
from devices import views as views_devices
from alert import views as views_alert
from incident import views as views_incident
from tickets import views as views_tickets
from ticketComment import views as views_ticketComment
from remote import views as views_remote


urlpatterns = [

    # Organization
    path("organizations/", views.OrgCreateView.as_view()),
    path("organizations/<int:pk>/", views.OrgDetailView.as_view()),

    # Organization users
    path("users/", views_users.OrgUsersView.as_view()),
    path("users/<int:pk>", views_users.OrgUserDetailView.as_view()),

    # Devices
    path("devices/", views_devices.DevicesView.as_view()),

    # Alert
    path("alert-rules/", views_alert.AlertRulesView.as_view({'get': 'list', 'post': 'create'})),

    # Incident
    path("incidents/", views_incident.IncidentView.as_view({'get': 'list', 'post': 'create'})),
    path("incidents/<int:pk>/", views_incident.IncidentCreate.as_view({'get': 'list', 'post': 'create'})),

    # Tickets
    path("tickets/", views_tickets.TicketsView.as_view()),
    path("tickets/<int:pk>/", views_tickets.TicketDetailView.as_view()),

    # Ticket comment
    path(
        "tickets/<int:pk>/comments/",
        views_ticketComment.TicketCommentsView.as_view({
            'get': 'list',
            'post': 'create'
        })
    ),

    # Remote session
    path("remote-session/request", views_remote.RemoteSessionRequestView.as_view()),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)