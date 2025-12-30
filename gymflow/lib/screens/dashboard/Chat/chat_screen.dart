import 'package:flutter/material.dart';
import '../../../utils/user_utils.dart';
import 'chat_room_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final users = await UserUtils.fetchUsers();
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "MESSAGES",
          style: TextStyle(fontFamily: 'Alegreya SC', color: Colors.white, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.white)))
              : RefreshIndicator(
                  color: Colors.red,
                  onRefresh: _loadData, // Pull to refresh
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      final username = user['username'] ?? 'Unknown';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          backgroundImage: (user['profile_image'] != null && user['profile_image'].toString().isNotEmpty)
                              ? NetworkImage(UserUtils.getImageUrl(user['profile_image']))
                              : null,
                          child: (user['profile_image'] == null || user['profile_image'].toString().isEmpty)
                              ? Text(
                                  user['username'][0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        title: Text(
                          username,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "Tap to start chatting",
                          style: TextStyle(color: Colors.white54),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoomScreen(
                                roomName: username,
                                displayName: username,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}