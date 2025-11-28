import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/token_storage.dart';

class AuthService {
  static String get _baseUrl => "${dotenv.env['BACKEND_URL']}/api/auth";

  static Future<Map<String, dynamic>> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access');
    final refreshToken = prefs.getString('refresh');
    final role = prefs.getString("role") ?? "MEMBER";

    if (accessToken == null || refreshToken == null) {
      return {"route" : "/onboarding"};
    }

    final isValid = await validateToken(accessToken);
    if (isValid) return {"route" : "/home", "role": role};

    final newAccess = await refreshAccessToken(refreshToken);
    if (newAccess != null) {
      await prefs.setString('access', newAccess);
      return {"route" : "/home", "role": role};
    }

    await TokenStorage.clearTokens();
    return {"route" : "/onboarding"};
  }

  static Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/token/verify/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/token/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access'];
      }
    } catch (_) {}
    return null;
  }

  static Future<Map<String, dynamic>?> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$_baseUrl/token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "access": data["access"],
        "refresh": data["refresh"],
      };
    }
  } catch (_) {}
  return null;
  }
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
    
  }

}
