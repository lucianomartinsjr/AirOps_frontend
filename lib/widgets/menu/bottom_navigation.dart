import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          BottomNavigationBar(
            items: _buildNavigationItems(),
            currentIndex: currentIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            backgroundColor: const Color(0xFF222222),
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 24,
            elevation: 0,
            enableFeedback: true,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment(
                -1 + (currentIndex * 1),
                1,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 2,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      _buildAnimatedNavItem(Icons.person, 'Perfil', 0),
      _buildAnimatedNavItem(Icons.home, 'Início', 1),
      _buildAnimatedNavItem(Icons.event, 'Eventos', 2),
    ];
  }

  BottomNavigationBarItem _buildAnimatedNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(currentIndex == index ? 8.0 : 0),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? Colors.red.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 1, end: currentIndex == index ? 1.2 : 1),
          duration: const Duration(milliseconds: 200),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Icon(icon),
            );
          },
        ),
      ),
      label: label,
    );
  }
}
