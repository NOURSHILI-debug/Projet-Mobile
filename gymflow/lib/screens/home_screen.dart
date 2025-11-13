import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../Widgets/backbutton.dart';

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
        return LogOutAlert();
      },
    );

    if (shouldLogout == true) {
      AuthService.logout();
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomBackButton(
            onPressed: () => _logout(context),
          ),
          GreetingUser(username: _username),
        ],
      ),
    );
  }
}

class GreetingUser extends StatelessWidget {
  const GreetingUser({
    super.key,
    required String? username,
  }) : _username = username;

  final String? _username;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 20, 
      child: _username == null
          ? Text(
              'Welcome, User!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(
              'Welcome, $_username!',
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
  const LogOutAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), 
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12))
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          color: Colors.white, 
          fontFamily: 'Alegreya SC',
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Alegreya SC',
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YesNoButton(text: 'No', pop: false),
            const SizedBox(width: 50),
            YesNoButton(text: 'Yes', pop: true)
        ],
        ),
      ],
    );
  }
}

class YesNoButton extends StatelessWidget {
  final String text;
  final bool pop;
  const YesNoButton({
    super.key,
    required this.text,
    required this.pop
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(pop); 
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.red, 
          fontSize: 17,
          fontFamily: 'Alegreya SC',
        ),
      ),
    );
  }
}
