import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/user_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  String? _networkImageUrl;
  File? _localImageFile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await UserUtils.fetchProfile();
      setState(() {
        _emailController.text = data['email'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _networkImageUrl = data['profile_image'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text("Choose from Gallery", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              _pickImage();
            },
          ),
          
          if (_networkImageUrl != null || _localImageFile != null)
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Remove Current Photo", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _handleRemovePhoto();
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localImageFile = File(pickedFile.path);
        _networkImageUrl = null; 
      });
    }
  }

  Future<void> _handleRemovePhoto() async {
    setState(() => _isLoading = true);
    
    bool success = await UserUtils.removeProfilePicture(); 
    if (mounted) {
      setState(() {
        if (success) {
          _networkImageUrl = null;
          _localImageFile = null;
        }
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Photo Removed" : "Error removing photo")),
      );
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    bool success = await UserUtils.updateProfile(
      email: _emailController.text,
      age: _ageController.text,
      image: _localImageFile,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Profile Updated" : "Update Failed")),
      );
    }
  }

  void _showPasswordDialog() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("CHANGE PASSWORD", style: TextStyle(color: Colors.white, fontFamily: 'Alegreya SC')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(oldPass, "Current Password", Icons.lock_outline, obscure: true),
            const SizedBox(height: 15),
            _buildTextField(newPass, "New Password", Icons.lock_reset, obscure: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              bool ok = await UserUtils.changePassword(oldPass.text, newPass.text);
              if (mounted) Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? "Success!" : "Failed")));
            },
            child: const Text("UPDATE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("MY PROFILE", style: TextStyle(fontFamily: 'Alegreya SC', color: Colors.white, letterSpacing: 1.5)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.red,
                        backgroundImage: _localImageFile != null
                            ? FileImage(_localImageFile!)
                            : (_networkImageUrl != null ? NetworkImage(UserUtils.getImageUrl(_networkImageUrl)) : null) as ImageProvider?,
                        child: (_localImageFile == null && _networkImageUrl == null)
                            ? const Icon(Icons.person, size: 60, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageOptions,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, color: Colors.black, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(_emailController, "EMAIL ADDRESS", Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildTextField(_ageController, "AGE", Icons.cake_outlined, isNumber: true),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: _handleSave,
                      child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _showPasswordDialog,
                    child: const Text("CHANGE PASSWORD", style: TextStyle(color: Colors.redAccent, letterSpacing: 1.1)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false, bool isNumber = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.red, size: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .05),
      ),
    );
  }
}