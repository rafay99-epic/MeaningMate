import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:meaning_mate/screens/home/add_word_screen.dart';
import 'package:meaning_mate/screens/home/quiz.dart';
import 'package:meaning_mate/screens/home/search_screen.dart';
import 'package:meaning_mate/screens/home/setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AddWordsPage(),
    const QuizScreen(),
    const SearchScreen(),
    SettingScreens(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            backgroundColor: colorScheme.surface,
            color: colorScheme.onSurface,
            activeColor: colorScheme.primary,
            tabBackgroundColor: colorScheme.primary.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            gap: 10,
            tabs: [
              GButton(
                icon: Icons.add,
                text: 'Add Word',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: Icons.quiz,
                text: 'Quiz',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: Icons.search,
                text: 'Search Word',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
