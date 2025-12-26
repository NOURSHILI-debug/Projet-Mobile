from django.db import models
from django.contrib.auth import get_user_model

# Create your models here.

User = get_user_model()

# for further improvements
# class ChatRoom(models.Model):
#     name = models.CharField(max_length=255, unique=True)
#     def __str__(self):
#         return f"chat: {self.name}"

class Message(models.Model):
    room_id = models.CharField(max_length=255, default="") 
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    class Meta:
        ordering = ['timestamp']
    def __str__(self):
        return f"message: {self.sender} --> {self.room_id}"    