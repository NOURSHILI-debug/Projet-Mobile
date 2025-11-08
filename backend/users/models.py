from django.contrib.auth.models import AbstractUser
from django.db import models

# Create your models here.

class User(AbstractUser):
    ADMIN = ("ADMIN", "Admin")
    MEMBER = ("MEMBER", "Member")
    ROLES = [ADMIN, MEMBER]
    age = models.PositiveIntegerField(blank=True, null=True)
    profile_image = models.ImageField(upload_to='profiles/', blank=True, null=True)
    role = models.CharField(
        max_length=20,
        choices=ROLES,
        default="MEMBER"
    )

    def __str__(self):
        return self.username
    
    