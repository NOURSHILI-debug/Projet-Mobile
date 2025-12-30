from .models import User
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class UserListSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        # We don't include 'password' here for security!
        fields = ['username', 'email', 'age', 'role', 'profile_image']

class UserProfileUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        # Username and Role are read-only
        fields = ['email', 'age', 'profile_image']

class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, min_length=6)

    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("Old password is incorrect.")
        return value


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
