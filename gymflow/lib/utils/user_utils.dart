import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
  static String? get baseUrl => dotenv.env['BACKEND_URL'];

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith('http')) return path;
    
    return "${dotenv.env['BACKEND_URL']}$path";
  }

  static Future<List<dynamic>> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/users/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  static Future<bool> deleteUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/auth/delete_user/$username/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }
  static Future<bool> registerMember({
  required String username,
  required String password,
  String? email,
  String? age,
  File? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/auth/register/'));
    
    
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    
    request.fields['username'] = username;
    request.fields['password'] = password;
    if (email != null && email.isNotEmpty) request.fields['email'] = email;
    if (age != null && age.isNotEmpty) request.fields['age'] = age;

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        profileImage.path,
      ));
    }

    var response = await request.send();
    return response.statusCode == 201;
  }

  // Profile
  static Future<Map<String, dynamic>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to load profile');
  }

  static Future<bool> updateProfile({String? email, String? age, File? image}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    var request = http.MultipartRequest('PATCH', Uri.parse('$baseUrl/api/auth/profile/'));
    request.headers['Authorization'] = 'Bearer $token';

    if (email != null) request.fields['email'] = email;
    if (age != null) request.fields['age'] = age;
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', image.path));
    }
    var response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/change-password/'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> removeProfilePicture() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access');

  // We send a PATCH request with an empty string for the image field
  
  final response = await http.patch(
    Uri.parse('$baseUrl/api/auth/profile/'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'profile_image': null, 
    }),
  );

  return response.statusCode == 200;
}

  
}