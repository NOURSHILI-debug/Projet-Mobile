import 'package:flutter/material.dart';
import 'dashboard/home_screen.dart';
import 'dashboard/schedule_screen.dart';
import 'dashboard/progress_screen.dart';
import 'dashboard/Chat/chat_screen.dart';
import 'dashboard/profile_screen.dart';
import 'dashboard/Manage_Members/manage_users_screen.dart';
import '../Widgets/custom_navbar.dart';

class RootShell extends StatefulWidget {
  final String role;

  const RootShell({super.key, required this.role});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 2;
  late PageController _pageController;
  late List<Widget> _screens;

  bool _isAdmin(String role) => role == "ADMIN";

  @override
  void initState() {
    super.initState();

    _screens = [
      const ScheduleScreen(),
      const ProgressScreen(),
      const HomeScreen(),
      const ChatScreen(),
      const ProfileScreen(),
      if (_isAdmin(widget.role)) const ManageUsersScreen(),
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false, // Prevent from closing immediately when clicking back button
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;

      if (_currentIndex != 2) {
        _onTabSelected(2);
      }
    },
    child: Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: CustomNavbar(
        role: widget.role,     
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    ),
  );
}

}

  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
