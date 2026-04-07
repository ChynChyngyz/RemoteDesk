"""
ASGI config for back project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/6.0/howto/deployment/asgi/
"""

# back/asgi.py

import os
from .routing import application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")