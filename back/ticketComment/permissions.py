# ticketComment/permissions.py

from rest_framework.permissions import BasePermission


class IsOrgAdmin(BasePermission):

    def has_permission(self, request, view):
        return (
            request.user.is_authenticated and
            request.user.role == "OrgAdmin"
        )