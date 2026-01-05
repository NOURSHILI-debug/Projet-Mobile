import 'package:flutter/material.dart';

class HomeQuoteCard extends StatelessWidget {
  const HomeQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "Consistency builds champions 💪",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
