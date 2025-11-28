import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../Widgets/backbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _username = username;
    });
  }

  Future<void> _logout(BuildContext context) async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LogOutAlert();
      },
    );

    if (shouldLogout == true) {
      AuthService.logout();
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackButton(
          onPressed: () => _logout(context),
        ),
        GreetingUser(username: _username),
      ],
    );
  }
}

class GreetingUser extends StatelessWidget {
  const GreetingUser({super.key, required this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 20,
      child: Text(
        username == null ? 'Welcome, User!' : 'Welcome, $username!',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LogOutAlert extends StatelessWidget {
  const LogOutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white.withValues(alpha: .12)),
      ),
      title: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Alegreya SC',
        ),
      ),
      content: const Text(
        'Are you sure you want to log out?',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Alegreya SC',
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            YesNoButton(text: 'No', pop: false),
            SizedBox(width: 50),
            YesNoButton(text: 'Yes', pop: true),
          ],
        ),
      ],
    );
  }
}

class YesNoButton extends StatelessWidget {
  final String text;
  final bool pop;
  const YesNoButton({super.key, required this.text, required this.pop});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(pop);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 17,
          fontFamily: 'Alegreya SC',
        ),
      ),
    );
  }
}
