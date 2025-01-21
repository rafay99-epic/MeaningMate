import 'package:flutter/material.dart';
import 'package:meaning_mate/screens/words/word_add.dart';
import 'package:meaning_mate/screens/words/word_display.dart';

class WordScreen extends StatefulWidget {
  const WordScreen({super.key});

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vocabulary',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.surface),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: const WordListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add word screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWordScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
