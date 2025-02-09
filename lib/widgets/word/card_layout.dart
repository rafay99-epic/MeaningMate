import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';

class CardLayout extends StatelessWidget {
  final Word word;

  const CardLayout({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      children: [
        _buildCard(context, theme, "Meanings", word.meaning),
        _buildCard(context, theme, "Synonyms", word.synonyms),
        _buildCard(context, theme, "Antonyms", word.antonyms),
        _buildCard(context, theme, "Sentences", word.sentences),
        _buildCard(context, theme, "Tenses", word.tenses),
      ],
    );
  }

  Widget _buildCard(
      BuildContext context, ThemeData theme, String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
      child: Padding(
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
            if (items.isEmpty)
              Text(
                "No data available.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
