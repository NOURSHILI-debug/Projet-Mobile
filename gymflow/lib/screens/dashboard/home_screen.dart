import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';
import '../../Widgets/backbutton.dart';
import '../../Widgets/home_greeting.dart';
import '../../Widgets/home_info_card.dart';
import '../../Widgets/logout_alert.dart';

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
    if (!mounted) return;
    setState(() {
      _username = prefs.getString('username');
    });
  }

  Future<void> _logout(BuildContext context) async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogOutAlert(),
    );

    if (shouldLogout == true) {
      AuthService.logout();
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  // ================= SMART INTERACTION =================
  void _showSmartInsights(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF0F0F0F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Center(
                child: SizedBox(
                  width: 40,
                  child: Divider(color: Colors.grey, thickness: 3),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Smart Training Insight",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _InsightRow(
                icon: Icons.access_time,
                title: "Best time to train",
                description: "Now until 11:30 — low crowd density",
              ),
              SizedBox(height: 14),
              _InsightRow(
                icon: Icons.person,
                title: "Coach availability",
                description: "Alex (Strength) is currently available",
              ),
              SizedBox(height: 14),
              _InsightRow(
                icon: Icons.trending_up,
                title: "Recommendation",
                description: "Ideal moment for focused or coached sessions",
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomBackButton(onPressed: () => _logout(context)),

          Positioned.fill(
            top: 90,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingUser(username: _username),
                  const SizedBox(height: 6),
                  const Text(
                    "Here’s a live overview of your gym",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 26),

                  Row(
                    children: const [
                      Expanded(
                        child: HomeInfoCard(
                          title: "Occupancy",
                          value: "42%",
                          subtitle: "Low traffic",
                          icon: Icons.people,
                          accent: Colors.green,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: HomeInfoCard(
                          title: "Offer",
                          value: "-20%",
                          subtitle: "Summer Pack",
                          icon: Icons.local_fire_department,
                          accent: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ---------- GYM INTELLIGENCE ----------
                  const Text(
                    "Gym Intelligence",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1C1C1C), Color(0xFF121212)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: const [
                        _InsightRow(
                          icon: Icons.show_chart,
                          title: "Progress analytics",
                          description:
                              "Track evolution, consistency and workload",
                        ),
                        SizedBox(height: 16),
                        _InsightRow(
                          icon: Icons.people_alt,
                          title: "Live environment",
                          description: "Occupancy, coaches and peak hours",
                        ),
                        SizedBox(height: 16),
                        _InsightRow(
                          icon: Icons.local_fire_department,
                          title: "Personalized offers",
                          description: "Dynamic packs based on attendance",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ---------- COACHES ON DUTY ----------
                  const Text(
                    "Coaches on duty",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      _CoachStatus(
                        name: "Alex",
                        role: "Strength",
                        available: true,
                      ),
                      SizedBox(width: 12),
                      _CoachStatus(
                        name: "Sara",
                        role: "Cardio",
                        available: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ---------- QUOTE ----------
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A1A1A), Color(0xFF101010)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: Colors.redAccent,
                          size: 26,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Discipline is choosing between what you want now and what you want most.",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------- SMART CARD ----------
                  GestureDetector(
                    onTap: () => _showSmartInsights(context),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.amber,
                            size: 26,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Low occupancy detected. Tap for smart training insights.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HELPERS =================

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InsightRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.redAccent, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoachStatus extends StatelessWidget {
  final String name;
  final String role;
  final bool available;

  const _CoachStatus({
    required this.name,
    required this.role,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.red),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(color: Colors.white)),
                const Spacer(),
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: available ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(role, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              available ? "Available" : "Busy",
              style: TextStyle(
                color: available ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
