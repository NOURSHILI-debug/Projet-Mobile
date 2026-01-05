import 'package:flutter/material.dart';

class GreetingUser extends StatelessWidget {
  final String? username;

  const GreetingUser({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      username == null ? 'Welcome!' : 'Welcome, $username!',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
