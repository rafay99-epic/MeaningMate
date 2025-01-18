import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/screens/words/word_detail.dart';
import 'package:page_transition/page_transition.dart';

class SearchResultsList extends StatelessWidget {
  final List<Word> results;

  const SearchResultsList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final word = results[index];

        final meaningText = word.meaning.isNotEmpty
            ? word.meaning.map((meaning) => '- $meaning').join('\n')
            : 'No meaning available';

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              word.word,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              meaningText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: WordDetailScreen(word: word),
              ),
            ),
          ),
        );
      },
    );
  }
}
