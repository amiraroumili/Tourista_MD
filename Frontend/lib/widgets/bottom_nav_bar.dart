import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/ev&opp');
        break;
      case 1:
        Navigator.pushNamed(context, '/favorite');
        break;
      case 2:
        Navigator.pushNamed(context, '/home');
        break;
      case 3:
        Navigator.pushNamed(context, '/notifications');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: [
        _buildBottomNavigationBarItem(
          icon: currentIndex == 0 ? Icons.explore : Icons.explore_outlined,
          isSelected: currentIndex == 0,
        ),
        _buildBottomNavigationBarItem(
          icon: currentIndex == 1 ? Icons.favorite : Icons.favorite_outline,
          isSelected: currentIndex == 1,
        ),
        _buildBottomNavigationBarItem(
          icon: currentIndex == 2 ? Icons.home : Icons.home_outlined,
          isSelected: currentIndex == 2,
        ),
        _buildBottomNavigationBarItem(
          icon: currentIndex == 3 ? Icons.notifications : Icons.notifications_outlined,
          isSelected: currentIndex == 3,
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF6D071A),
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(size: 25),
      unselectedIconTheme: const IconThemeData(size: 25),
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 2), 
          Container(
            height: 5, 
            width: 5,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6D071A) : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      label: '', 
    );
  }
}
