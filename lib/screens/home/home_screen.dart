import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:meaning_mate/providers/search_provider.dart';
import 'package:meaning_mate/screens/quiz/quiz.dart';
import 'package:meaning_mate/screens/search/search_screen.dart';
import 'package:meaning_mate/screens/setting/setting.dart';
import 'package:meaning_mate/screens/words/word_screen.dart';
import 'package:meaning_mate/screens/chatbot/chatbot.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.fetchAllWords();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WordScreen(),
    const QuizScreen(),
    const SearchScreen(),
    const ChatbotScreen(),
    const SettingScreens(),
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
            gap: 5,
            tabs: [
              GButton(
                icon: LineIcons.book,
                text: 'Grammar',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: LineIcons.question,
                text: 'Quiz',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: LineIcons.search,
                text: 'Search',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: LineIcons.robot,
                text: 'LingoBot',
                iconColor: colorScheme.primary,
              ),
              GButton(
                icon: LineIcons.cog,
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
