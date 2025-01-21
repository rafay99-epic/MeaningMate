import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            "Word is: ${word.word}",
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.colorScheme.surface),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    tabBarTheme: TabBarTheme(
                      labelStyle: TextStyle(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  child: TabBar(
                    isScrollable: false,
                    labelColor: theme.colorScheme.surface,
                    unselectedLabelColor: Colors.white70,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: "Meanings"),
                      Tab(text: "Synonyms"),
                      Tab(text: "Antonyms"),
                      Tab(text: "Sentences"),
                      Tab(text: "Tenses"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTimeline(
              context: context,
              title: 'Meanings',
              items: word.meaning,
              icon: Icons.menu_book,
              color: Colors.black,
            ),
            _buildTimeline(
              context: context,
              title: 'Synonyms',
              items: word.synonyms,
              icon: Icons.cached,
              color: theme.colorScheme.secondary,
            ),
            _buildTimeline(
              context: context,
              title: 'Antonyms',
              items: word.antonyms,
              icon: Icons.compare_arrows,
              color: theme.colorScheme.error,
            ),
            _buildTimeline(
              context: context,
              title: 'Sentences',
              items: word.sentences,
              icon: Icons.format_quote,
              color: Colors.black,
            ),
            _buildTimeline(
              context: context,
              title: 'Tenses',
              items: word.tenses,
              icon: Icons.timeline,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline({
    required BuildContext context,
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Center(
        child: Text(
          "No $title available.",
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18.0),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(icon, color: color, size: 28),
                if (index != items.length - 1)
                  Container(
                    height: 40,
                    width: 2,
                    color: color.withOpacity(0.5),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                items[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}
