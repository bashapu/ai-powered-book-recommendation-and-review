import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'book_search_screen.dart';
import 'my_library_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    BookSearchScreen(),
    MyLibraryScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNav(currentIndex: _currentIndex, onTap: _onTabTapped),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Personalized Recommendations', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Placeholder(fallbackHeight: 100),
          SizedBox(height: 20),
          Text('Trending Books', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Placeholder(fallbackHeight: 100),
        ],
      ),
    );
  }
}
