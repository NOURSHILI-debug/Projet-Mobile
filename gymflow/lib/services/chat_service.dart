import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  WebSocketChannel? _channel;


  static String get _baseUrl {
    final rawUrl = dotenv.env['BACKEND_URL'] ?? "http://10.0.2.2:8000";
    final wsUrl = rawUrl.replaceFirst("http", "ws");
    return "$wsUrl/ws/chat";
  }
  void connect(String roomName) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$_baseUrl/$roomName/'),
      );
      print("Connected to room: $roomName");
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Stream get messagesStream {
    if (_channel != null) {
      return _channel!.stream;
    } else {
      throw Exception("WebSocket not connected. Call connect() first.");
    }
  }

  void sendMessage(String message, String username) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({
        'message': message,
        'username': username,
      }));
    }
  }

  void close() {
    _channel?.sink.close();
  }
}