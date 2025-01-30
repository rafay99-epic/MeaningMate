import 'package:flutter/material.dart';
import 'package:meaning_mate/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQuiz = quizProvider.currentQuiz;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: List.generate(
                quizProvider.quizTags.length,
                (index) => ChoiceChip(
                  label: Text(
                    quizProvider.quizTags[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: quizProvider.selectedTagIndex == index
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  selected: quizProvider.selectedTagIndex == index,
                  onSelected: (selected) {
                    quizProvider.updateQuiz(index);
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ),
          Expanded(child: currentQuiz),
        ],
      ),
    );
  }
}
