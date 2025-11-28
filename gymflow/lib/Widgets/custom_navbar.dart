import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final bool isAdmin;
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomNavbar({
    super.key,
    required this.isAdmin,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.calendar_month, index: 0), // schedule
      _NavItem(icon: Icons.trending_up, index: 1),    // progress
      _NavItem(icon: Icons.home, index: 2),           // home
      _NavItem(icon: Icons.chat, index: 3),           // chat
      _NavItem(icon: Icons.person, index: 4),         // profile
      if (isAdmin) _NavItem(icon: Icons.group, index: 5), // manage users
    ];

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
              blurRadius: 10, color: Colors.black26, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          // Left side
          _buildItem(items[0]),
          const SizedBox(width: 25),
          _buildItem(items[1]),
          const Spacer(),

          // Center (Home)
          _buildItem(items[2], size: 30),
          const Spacer(),

          // Right side
          _buildItem(items[3]),
          const SizedBox(width: 25),
          _buildItem(items[4]),
          if (isAdmin) ...[
            const SizedBox(width: 25),
            _buildItem(items[5]),
          ]
        ],
      ),
    );
  }

  Widget _buildItem(_NavItem item, {double size = 28}) {
    final isSelected = currentIndex == item.index;

    return GestureDetector(
      onTap: () => onTabSelected(item.index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          item.icon,
          size: size,
          color: isSelected ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final int index;

  const _NavItem({
    required this.icon,
    required this.index,
  });
}
