import 'package:flutter/material.dart';
import 'package:gymflow/screens/root_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/auth_service.dart';
import '../utils/token_storage.dart';
import '../Widgets/Text_field.dart';
import '../Widgets/button.dart';
import '../Widgets/backbutton.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your username and password")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.login(username, password);
    setState(() => _isLoading = false);

    if (result != null) {
      await TokenStorage.saveTokens(result['access'], result['refresh']);


      final decoded = JwtDecoder.decode(result['access']);
      final role = decoded["role"];     
      final usernameFromToken = decoded["username"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', usernameFromToken);
      await prefs.setString('role', role);


      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => RootShell(role: role)),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials")),
      );
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
      children: [
        const CustomBackButton(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Icon(Icons.fitness_center_rounded, color: Colors.red, size: 100),
                const SizedBox(height: 15),

                const Text(
                  "GYMFLOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Alegreya SC',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 100),

                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person, color: Colors.white70),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    }),
                  ),
                ),
                const SizedBox(height: 15),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                CustomButton(
                  text: "Login",
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 30),

                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or continue with",
                        style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(Icons.g_mobiledata_sharp, "Gmail"),
                    const SizedBox(width: 20),
                    _socialButton(Icons.facebook, "Facebook"),
                  ],
                ),
              ],
            ),
          ),
        ), 
      ],
    ),
  );
}


  Widget _socialButton(IconData icon, String label) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
