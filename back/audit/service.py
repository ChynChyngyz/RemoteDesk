# audit/service.py

from .models import AuditEvent

def audit_log(org, type, actor_user=None, actor_device=None, metadata=None):
    """
    Централизованный хелпер для создания событий аудита (append-only).
    """
    if metadata is None:
        metadata = {}

    AuditEvent.objects.create(
        organization=org,
        actor_user=actor_user,
        actor_device=actor_device,
        type=type,
        metadata_json=metadata
    )