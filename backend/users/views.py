from rest_framework import generics, parsers
from .models import User
from .serializers import RegisterSerializer

class Register(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    # Handle image uploads
    parser_classes = [parsers.MultiPartParser, parsers.FormParser, parsers.JSONParser] 
