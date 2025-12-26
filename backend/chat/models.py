from django.db import models
from django.contrib.auth import get_user_model

# Create your models here.

User = get_user_model()

class ChatRoom(models.Model):
    name = models.CharField(max_length=255, unique=True)
    def __str__(self):
        return f"chat: {self.name}"

class Message(models.Model):
    room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['timestamp']
    def __str__(self):
        return f"message: {self.sender} --> {self.room}"    