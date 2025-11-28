from .models import User
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class RegisterSerializer(serializers.ModelSerializer):
    # make password write only (security)
    password = serializers.CharField(write_only=True) 

    # Not required field
    profile_image = serializers.ImageField(required=False, allow_null=True)

    class Meta:
        # the serializer represents the class User
        model = User 
        # What we need in the post request
        fields = ['username', 'email', 'password', 'age', 'profile_image']
    # Register user
    def create(self, validated_data): 
        
        # enforce that only MEMBER can be registered from API (Security)
        validated_data['role'] = 'MEMBER'

        user = User.objects.create_user(**validated_data)
        return user
    

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        
        # Add vars inside the token 
        token['role'] = user.role
        token['username'] = user.username
        
        return token

    def validate(self, attrs):
        data = super().validate(attrs)

        # Also return user data in the response
        data["user"] = {
            "username": self.user.username,
            "email": self.user.email,
            "role": self.user.role,
        }

        return data   
