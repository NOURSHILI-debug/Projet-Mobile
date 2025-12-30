from rest_framework import permissions

class IsAppAdmin(permissions.BasePermission):
    """
    Allows access only to users with the 'ADMIN' role.
    """
    def has_permission(self, request, view):
        # Check if user is logged in and if their role is ADMIN
        return bool(request.user and request.user.is_authenticated and request.user.role == 'ADMIN')