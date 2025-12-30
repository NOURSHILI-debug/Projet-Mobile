from django.urls import path
from .views import Register, get_users, delete_user, profile, change_password
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenVerifyView
from .serializers import CustomTokenObtainPairSerializer

from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('register/', Register.as_view(), name='register'),
    path('token/', TokenObtainPairView.as_view(serializer_class=CustomTokenObtainPairSerializer), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    path('users/', get_users, name="users"),
    path('delete_user/<str:username>/',delete_user, name="delete_user"),
    path('profile/', profile, name='profile'),
    path('change-password/', change_password, name='change-password'),
] 
