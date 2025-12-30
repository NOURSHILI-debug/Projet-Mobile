from rest_framework import generics, parsers, status
from .models import User
from .serializers import RegisterSerializer, UserListSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from .permissions import IsAppAdmin

class Register(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    # Handle image uploads
    parser_classes = [parsers.MultiPartParser, parsers.FormParser, parsers.JSONParser] 


@api_view(['GET'])
def get_users(request):
    # Now request.user will be populated correctly
    users = User.objects.exclude(id=request.user.id)
    serializer = UserListSerializer(users, many=True, context={'request': request})
    return Response(serializer.data)


@api_view(['DELETE'])
@permission_classes([IsAppAdmin]) # Only Admin can delete users
def delete_user(request, username):
    try:
        user = User.objects.get(username=username)    
        user.delete()
        return Response({"message": "User deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
    
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)