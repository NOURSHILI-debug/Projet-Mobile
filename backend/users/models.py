from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db.models import Q
from django.db.models.signals import post_delete, pre_save
from django.dispatch import receiver

import os
import hashlib
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
    


# Delete file from filesystem when User object is deleted
@receiver(post_delete, sender=User)
def delete_file_on_user_delete(sender, instance, **kwargs):
    if instance.profile_image:
        if os.path.isfile(instance.profile_image.path):
            os.remove(instance.profile_image.path)

# Delete old file from filesystem when profile_image is updated
@receiver(pre_save, sender=User)
def delete_old_file_on_update(sender, instance, **kwargs):
    if not instance.pk:
        return False

    try:
        old_file = User.objects.get(pk=instance.pk).profile_image
    except User.DoesNotExist:
        return False

    new_file = instance.profile_image
    if not old_file == new_file:
        if old_file and os.path.isfile(old_file.path):
            os.remove(old_file.path)
    
