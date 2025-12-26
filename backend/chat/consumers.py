import json
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from django.contrib.auth import get_user_model
from .models import Message  

User = get_user_model()

class ChatConsumer(AsyncWebsocketConsumer):
    # 1. Called when a user attempts to connect
    async def connect(self):
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'

        # Join the room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    # 2. Called when a user disconnects
    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    # 3. Called when the server receives a message from Flutter
    async def receive(self, text_data):
        data = json.loads(text_data)
        message_content = data['message']
        username = data['username']

        # Save message to DB asynchronously using the room_id (hashed string from Flutter)
        await self.save_message(username, self.room_name, message_content)

        # Broadcast the message to everyone in the room
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message_content,
                'username': username
            }
        )

    # 4. Receives the broadcast event and sends it to the specific Flutter client
    async def chat_message(self, event):
        await self.send(text_data=json.dumps({
            'message': event['message'],
            'username': event['username']
        }))

    # Updated Helper method to match your specific Message model
    @database_sync_to_async
    def save_message(self, username, room_id, message_content):
        try:
            user = User.objects.get(username=username)
            # We save room_id as the string passed from self.room_name
            return Message.objects.create(
                room_id=room_id,
                sender=user,
                content=message_content
            )
        except User.DoesNotExist:
            print(f"Error: User {username} does not exist.")