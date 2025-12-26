from django.shortcuts import render
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Message
# Create your views here.


@api_view(['GET'])
def get_message_history(request, room_id):
    messages = Message.objects.filter(room_id=room_id)
    data = [{"username": m.sender.username, "message": m.content} for m in messages]
    return Response(data)