import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/providers/layout_provider.dart';
import 'package:meaning_mate/widgets/word/card_layout.dart';
import 'package:meaning_mate/widgets/word/tab_layout.dart';
import 'package:provider/provider.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          word.word,
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.surface),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.surface,
        ),
        actions: [
          PopupMenuButton<LayoutType>(
            onSelected: (value) {
              Provider.of<LayoutProvider>(context, listen: false)
                  .switchLayout(value);
            },
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.surface,
            ),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: LayoutType.card,
                child: Text('Card Layout'),
              ),
              PopupMenuItem(
                value: LayoutType.tab,
                child: Text('Tab Layout'),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: Consumer<LayoutProvider>(
        builder: (context, layoutProvider, child) {
          switch (layoutProvider.layout) {
            case LayoutType.tab:
              return TabLayout(word: word);
            case LayoutType.card:
              return CardLayout(word: word);
          }
        },
      ),
    );
  }
}
