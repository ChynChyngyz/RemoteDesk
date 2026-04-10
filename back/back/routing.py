# back/routing.py


# from channels.routing import ProtocolTypeRouter, URLRouter
# from django.core.asgi import get_asgi_application
# import remote.routing
# from remote.middleware import TokenAuthMiddleware
#
# application = ProtocolTypeRouter({
#     "http": get_asgi_application(),
#     "websocket": TokenAuthMiddleware(
#         URLRouter(remote.routing.websocket_urlpatterns)
#     ),
# })