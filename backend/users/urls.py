from django.urls import path
from .views import Register, get_users
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenVerifyView
from .serializers import CustomTokenObtainPairSerializer

urlpatterns = [
    path('register/', Register.as_view(), name='register'),
    path('token/', TokenObtainPairView.as_view(serializer_class=CustomTokenObtainPairSerializer), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    path('users/', get_users, name="users"),
]
