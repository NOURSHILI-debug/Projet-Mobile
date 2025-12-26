from django.urls import re_path
from . import consumers

websocket_urlpatterns = [
    # This URL will be: ws://localhost:8000/ws/chat/ROOM_NAME/
    re_path(r'ws/chat/(?P<room_name>\w+)/$', consumers.ChatConsumer.as_asgi()),
]