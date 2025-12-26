from django.urls import path
from .views import get_message_history

urlpatterns = [
    path("history/<str:room_id>/", get_message_history, name="chat_history"),
]