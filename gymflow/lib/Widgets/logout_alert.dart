import 'package:flutter/material.dart';

class LogOutAlert extends StatelessWidget {
  const LogOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white.withOpacity(.12)),
      ),
      title: const Text('Logout', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Are you sure you want to log out?',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _YesNoButton(text: 'No', pop: false),
            SizedBox(width: 50),
            _YesNoButton(text: 'Yes', pop: true),
          ],
        ),
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String text;
  final bool pop;

  const _YesNoButton({required this.text, required this.pop});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(pop),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontSize: 17),
      ),
    );
  }
}
