import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';

class TabLayout extends StatelessWidget {
  final Word word;

  const TabLayout({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          PreferredSize(
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
          Expanded(
            child: TabBarView(
              children: [
                _buildTimeline(
                  context: context,
                  title: 'Meanings',
                  items: word.meaning,
                ),
                _buildTimeline(
                  context: context,
                  title: 'Synonyms',
                  items: word.synonyms,
                ),
                _buildTimeline(
                  context: context,
                  title: 'Antonyms',
                  items: word.antonyms,
                ),
                _buildTimeline(
                  context: context,
                  title: 'Sentences',
                  items: word.sentences,
                ),
                _buildTimeline(
                  context: context,
                  title: 'Tenses',
                  items: word.tenses,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline({
    required BuildContext context,
    required String title,
    required List<String> items,
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8.0),
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[index],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
