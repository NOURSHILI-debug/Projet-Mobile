import 'package:flutter/material.dart';
import 'dashboard/home_screen.dart';
import 'dashboard/schedule_screen.dart';
import 'dashboard/progress_screen.dart';
import 'dashboard/chat_screen.dart';
import 'dashboard/profile_screen.dart';
import 'dashboard/manage_users_screen.dart';
import '../Widgets/custom_navbar.dart';

class RootShell extends StatefulWidget {
  final bool isAdmin = false; 
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 2; // Home
  late PageController _pageController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const ScheduleScreen(), 
      const ProgressScreen(), 
      const HomeScreen(),     
      const ChatScreen(),     
      const ProfileScreen(),  
      if (widget.isAdmin) const ManageUsersScreen(), 
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
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
    return Scaffold(
      backgroundColor: Colors.black,

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),

      bottomNavigationBar: CustomNavbar(
        isAdmin: widget.isAdmin,
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
