from rest_framework import generics, parsers
from .models import User
from .serializers import RegisterSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view

class Register(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    # Handle image uploads
    parser_classes = [parsers.MultiPartParser, parsers.FormParser, parsers.JSONParser] 


@api_view(['GET'])
def get_users(request):
    # Fetch all users except the current user
    users = User.objects.exclude(id=request.user.id)
    data = [{"username": u.username} for u in users]
    return Response(data)