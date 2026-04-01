# orgs/urls.py

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
from notifications import views as views_notifications
from audit import views as views_audit


urlpatterns = [

    # Organization
    path("organizations/", views.OrgCreateView.as_view()),
    path("organizations/<int:pk>/", views.OrgDetailView.as_view()),

    # Organization users
    path("users/", views_users.OrgUsersView.as_view()),
    path("users/<int:pk>", views_users.OrgUserDetailView.as_view()),

    # Devices
    path("devices/", views_devices.DevicesViewSet.as_view({'get': 'list', 'post': 'create'})),

    # Alert
    path("alert-rules/", views_alert.AlertRulesView.as_view({'get': 'list', 'post': 'create'})),
    path("alert-rules/<int:pk>/", views_alert.AlertRulesView.as_view({
            'get': 'retrieve',
            'put': 'update',
            'patch': 'partial_update',
            'delete': 'destroy'
            })
        ),

    # Incident
    path("incidents/", views_incident.IncidentViewSet.as_view({'get': 'list'})),
    path("incidents/<int:pk>/", views_incident.IncidentViewSet.as_view({
            'get': 'retrieve',
            'patch': 'partial_update'
            })
        ),

    # Tickets
    path("tickets/", views_tickets.TicketViewSet.as_view({
              'get': 'list',
              'post': 'create'
            })
        ),
    path("tickets/<int:pk>/", views_tickets.TicketViewSet.as_view({
              'get': 'retrieve',
              'patch': 'partial_update',
              'delete': 'destroy'
            })
        ),

    # Ticket comment
    path("tickets/<int:pk>/comments/", views_ticketComment.TicketCommentsView.as_view({
                'get': 'list',
                'post': 'create'
            })
        ),

    # Remote session
    path("remote-session/request", views_remote.RemoteSessionRequestView.as_view()),

    # Notifications
    path("notifications/", views_notifications.NotificationViewSet.as_view({'get': 'list'})),
    path("notifications/<int:pk>/", views_notifications.NotificationViewSet.as_view({'patch': 'partial_update'})),

    # Audit
    path("audit/", views_audit.AuditEventViewSet.as_view({"get": "list"})),
    path("audit/<int:pk>/", views_audit.AuditEventViewSet.as_view({'get': 'retrieve'})),


] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)