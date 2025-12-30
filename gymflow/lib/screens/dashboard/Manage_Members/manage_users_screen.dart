import 'package:flutter/material.dart';
import '../../../utils/user_utils.dart';
import 'add_member_screen.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }
  

  void _confirmDelete(String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Remove Member", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to delete $username? This cannot be undone.", 
          style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _handleDelete(username);
            }, 
            child: const Text("DELETE", style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(String username) async {
    setState(() => _isLoading = true);
    try {
      bool success = await UserUtils.deleteUser(username);
      if (success) {
        await _loadUsers(); // Refresh the list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User deleted successfully")),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete user")),
        );
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
          "MANAGE MEMBERS",
          style: TextStyle(fontFamily: 'Alegreya SC', color: Colors.white, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : RefreshIndicator(
              onRefresh: _loadUsers,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _users.isEmpty 
                  ? const Center(child: Text("No members found", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        bool hasMembership = user['has_membership'] ?? true; 

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              user['username'],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: hasMembership ? Colors.green.withValues(alpha: .1) : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      hasMembership ? "ACTIVE" : "EXPIRED",
                                      style: TextStyle(
                                        color: hasMembership ? Colors.green : Colors.red, 
                                        fontSize: 10, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _confirmDelete(user['username']),
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          // Wait for the result from the add screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMemberScreen()),
          );
          // If a user was added, refresh the list
          if (result == true) {
            _loadUsers();
          }
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}