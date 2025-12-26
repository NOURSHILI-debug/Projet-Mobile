import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../services/chat_service.dart';
import '../../Widgets/Text_field.dart';
import '../../Widgets/backbutton.dart';


class ChatRoomScreen extends StatefulWidget {
  final String roomName; 
  final String displayName;

  const ChatRoomScreen({
    super.key, 
    required this.roomName, 
    required this.displayName
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access');

    if (accessToken != null) {
      final decoded = JwtDecoder.decode(accessToken);
      final String myUsername = decoded["username"];
      final String peerUsername = widget.roomName;
      final baseUrl = dotenv.env['BACKEND_URL'];
      

      // 1. GENERATE SHARED UNIQUE ROOM ID
      
      List<String> participants = [myUsername, peerUsername];
      participants.sort();
      String combined = participants.join("_");

      // 2. hash the string
      
      String hashedId = sha256.convert(utf8.encode(combined)).toString().substring(0, 15);

      setState(() {
        _currentUsername = myUsername;
      });

      // Get history 
      final response = await http.get(
        Uri.parse('$baseUrl/chat/history/$hashedId/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        List<dynamic> history = jsonDecode(response.body);
        setState(() {
          _messages.addAll(history.cast<Map<String, dynamic>>());
        });
      }

      // connect 
      _chatService.connect(hashedId);
      
      _chatService.messagesStream.listen((data) {
        if (mounted) {
          setState(() {
            _messages.add(jsonDecode(data));
          });
        }
      }, onError: (err) => debugPrint("Socket Error: $err"));
    }
  }

  void _send() {
    if (_messageController.text.trim().isNotEmpty && _currentUsername != null) {
      _chatService.sendMessage(
        _messageController.text.trim(),
        _currentUsername!,
      );
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _chatService.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          widget.displayName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Alegreya SC',
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['username'] == _currentUsername;

                return _buildChatBubble(
                  message: msg['message'],
                  sender: msg['username'],
                  isMe: isMe,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    hintText: 'Type a message...',
                    prefixIcon: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: .3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String message, required String sender, required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 4),
            child: Text(
              isMe ? "You" : sender,
              style: TextStyle(
                color: isMe ? Colors.red : Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? Colors.red : Colors.white10,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(isMe ? 15 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 15),
              ),
              border: isMe ? null : Border.all(color: Colors.white24),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}