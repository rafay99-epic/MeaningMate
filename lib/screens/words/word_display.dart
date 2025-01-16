import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/word_repository.dart';
import 'package:meaning_mate/screens/words/word_detail.dart';
import 'package:page_transition/page_transition.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final WordRepository _wordRepository = WordRepository();
  late Future<List<Word>> _wordListFuture;

  @override
  void initState() {
    super.initState();
    _wordListFuture = _fetchWords();
  }

  Future<List<Word>> _fetchWords() async {
    return _wordRepository.getAllWords();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<List<Word>>(
        future: _wordListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    color: theme.colorScheme.onSurface,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No words found.',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          final words = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.6),
                  width: 1.5,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: WordDetailScreen(word: word),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            word.word,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
