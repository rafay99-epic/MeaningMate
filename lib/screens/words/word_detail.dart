import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/widgets/word_card.dart';

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
              buildSection(
                title: 'Meaning',
                content: word.meaning,
                color: Colors.black,
                icon: Icons.book,
                theme: theme,
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
