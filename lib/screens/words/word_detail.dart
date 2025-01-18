import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  Widget buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool multiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: multiline ? 1.5 : 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: Text(
          word.word,
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              if (word.meaning.isNotEmpty)
                buildSection(
                  title: 'Meanings',
                  content:
                      word.meaning.map((meaning) => '- $meaning').join('\n'),
                  color: Colors.black,
                  icon: Icons.book,
                  theme: theme,
                  multiline: true,
                ),
              const SizedBox(height: 16),
              if (word.synonyms.isNotEmpty)
                buildSection(
                  title: 'Synonyms',
                  content: word.synonyms.join(', '),
                  color: theme.colorScheme.secondary,
                  icon: Icons.swap_horiz,
                  theme: theme,
                ),
              const SizedBox(height: 16),
              if (word.antonyms.isNotEmpty)
                buildSection(
                  title: 'Antonyms',
                  content: word.antonyms.join(', '),
                  color: theme.colorScheme.error,
                  icon: Icons.do_not_disturb_alt,
                  theme: theme,
                ),
              const SizedBox(height: 16),
              if (word.sentences.isNotEmpty)
                buildSection(
                  title: 'Example Sentences',
                  content: word.sentences
                      .map((sentence) => '- $sentence')
                      .join('\n'),
                  color: Colors.black,
                  icon: Icons.format_quote,
                  theme: theme,
                  multiline: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
