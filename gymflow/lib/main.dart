import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/root_shell.dart';
import 'services/auth_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  final data = await AuthService.getInitialRoute();
  
  runApp(GymApp(home: data["route"] == "/home" ? RootShell(role: data["role"]) : null));
}

class GymApp extends StatelessWidget {
  final Widget? home;

  const GymApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: home ?? const OnboardingScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
