from rest_framework.permissions import BasePermission


class IsTechnician(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "Technician"

class IsClientViewer(BasePermission):
    def has_permission(self, request, view):
        return request.user.role == "ClientViewer"

class IsOrgAdmin(BasePermission):
    def has_permission(self, request, view):
        return (
            request.user.is_authenticated and
            request.user.role == "OrgAdmin"
        )