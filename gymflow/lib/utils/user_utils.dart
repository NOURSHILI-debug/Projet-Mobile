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
  
  // Headers
  request.headers.addAll({
    'Authorization': 'Bearer $token',
  });

  // Text Fields
  request.fields['username'] = username;
  request.fields['password'] = password;
  if (email != null && email.isNotEmpty) request.fields['email'] = email;
  if (age != null && age.isNotEmpty) request.fields['age'] = age;

  // Image Field (Optional)
  if (profileImage != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'profile_image',
      profileImage.path,
    ));
  }

  var response = await request.send();
  return response.statusCode == 201;
}
  
}