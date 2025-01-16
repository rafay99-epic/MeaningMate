import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          word.word,
          style: textTheme.headlineSmall?.copyWith(color: Colors.white),
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
              _buildSection(
                title: 'Meaning',
                content: word.meaning,
                color: Colors.black,
                icon: Icons.book,
                theme: theme,
              ),
              const SizedBox(height: 16),
              if (word.synonyms.isNotEmpty)
                _buildSection(
                  title: 'Synonyms',
                  content: word.synonyms.join(', '),
                  color: theme.colorScheme.secondary,
                  icon: Icons.swap_horiz,
                  theme: theme,
                ),
              const SizedBox(height: 16),
              if (word.antonyms.isNotEmpty)
                _buildSection(
                  title: 'Antonyms',
                  content: word.antonyms.join(', '),
                  color: theme.colorScheme.error,
                  icon: Icons.do_not_disturb_alt,
                  theme: theme,
                ),
              const SizedBox(height: 16),
              if (word.sentences.isNotEmpty)
                _buildSection(
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

  Widget _buildSection({
    required String title,
    required String content,
    required Color color,
    required IconData icon,
    required ThemeData theme,
    bool multiline = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: multiline ? 1.5 : 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
