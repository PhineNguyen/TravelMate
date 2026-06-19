import 'package:flutter/material.dart';
import 'package:frontend/features/ai_assistant/chat/presentation/pages/AiChatPage.dart';
import 'package:frontend/features/trip_planning/home/presentation/pages/HomePage.dart';
import 'package:frontend/features/trip_planning/templates/presentation/pages/TemplatesPage.dart';
import 'package:frontend/features/user_profile/analytics/presentation/pages/AnalyticsPage.dart';
import 'package:frontend/features/user_profile/profile/presentation/pages/ProfilePage.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ ĐÃ ĐỔI: Chuyển từ 'final List' thành một danh sách động để truyền callback quay về Home
  List<Widget> _getPages() {
    return [
      const HomePage(),
      TemplatesPage(
          onBackToHome: () => _onItemTapped(0)), // Truyền lệnh về Home
      AiChatPage(onBackToHome: () => _onItemTapped(0)), // Truyền lệnh về Home
      AnalyticsPage(
          onBackToHome: () => _onItemTapped(0)), // Truyền lệnh về Home
      ProfilePage(onBackToHome: () => _onItemTapped(0)), // Truyền lệnh về Home
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedIndex != 0) {
          _onItemTapped(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _getPages(), // Gọi hàm lấy danh sách trang
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade900, width: 0.5),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF0B1423),
            selectedItemColor: const Color(0xFF1ABC9C),
            unselectedItemColor: Colors.grey.shade600,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                activeIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_toy_outlined),
                activeIcon: Icon(Icons.luggage),
                label: 'AI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.luggage_outlined),
                activeIcon: Icon(Icons.luggage),
                label: 'In Sight',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
