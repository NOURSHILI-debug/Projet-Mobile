from rest_framework import generics, parsers, status
from .models import User
from chat.models import Message
from .serializers import UserProfileUpdateSerializer, ChangePasswordSerializer, UserListSerializer, RegisterSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes, parser_classes
from .permissions import IsAppAdmin 

import hashlib

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
        user_to_delete = User.objects.get(username=username)
        
        other_usernames = User.objects.exclude(username=username).values_list('username', flat=True)
        
        hashes_to_wipe = []
        
        for other_name in other_usernames:
            participants = [username, other_name]
            participants.sort()
            combined = "_".join(participants)
            
            room_hash = hashlib.sha256(combined.encode()).hexdigest()[:15]
            hashes_to_wipe.append(room_hash)

        self_combined = f"{username}_{username}"
        self_hash = hashlib.sha256(self_combined.encode()).hexdigest()[:15]
        hashes_to_wipe.append(self_hash)

        Message.objects.filter(room_id__in=hashes_to_wipe).delete()
        
        user_to_delete.delete()
        
        return Response({"message": "User and chat history deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
    
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET', 'PATCH'])
@permission_classes([IsAuthenticated])
@parser_classes([parsers.MultiPartParser, parsers.FormParser, parsers.JSONParser])
def profile(request):
    user = request.user

    if request.method == 'GET':
        # Reuse UserListSerializer to get current data + full image URL
        serializer = UserListSerializer(user, context={'request': request})
        return Response(serializer.data)

    if request.method == 'PATCH':
        # partial=True allows updating only one field
        serializer = UserProfileUpdateSerializer(
            user, 
            data=request.data, 
            partial=True, 
            context={'request': request}
        )
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    serializer = ChangePasswordSerializer(data=request.data, context={'request': request})
    if serializer.is_valid():
        user = request.user
        user.set_password(serializer.validated_data['new_password'])
        user.save()
        return Response({"message": "Password updated successfully"}, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)    