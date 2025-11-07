import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isloading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the username and password")),
      );
      return;
    }

    setState(() => _isloading = true);

    final url = Uri.parse("http://10.0.0.2:8000/api/auth/token/");
    final response = await http.post(
      url,
      headers: {"Content-Type" : "application/json"},
      body: jsonEncode({
        "username" : username,
        "password" : password,
      }),
    );
    print('username: "$username", password: "$password"');

    setState(() => _isloading = false);

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];
      // Save tokens locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', accessToken);
      await prefs.setString('refresh', refreshToken);

      Navigator.pushReplacementNamed(context, '/home');
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
  canPop: false, // disables default pop behavior
  onPopInvokedWithResult: (didPop, result) {
    if (!didPop) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  },
  child: Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontFamily: 'StackSansText',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.black, Colors.white],
                    stops: [0.3, 0.99],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'StackSansText',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

  }
}
