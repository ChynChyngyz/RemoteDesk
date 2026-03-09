# remote/routing.py

from django.urls import re_path
from .consumers import SignalConsumer

websocket_urlpatterns = [
    re_path(r'ws/signal/(?P<room>\w+)/$', SignalConsumer.as_asgi()),
]