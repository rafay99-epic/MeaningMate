import 'package:flutter/material.dart';
import 'package:meaning_mate/providers/quiz_provider.dart';
import 'package:meaning_mate/screens/quiz/quiz_ui.dart';
import 'package:provider/provider.dart';

class QuizAntonym extends StatelessWidget {
  const QuizAntonym({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final word = quizProvider.currentWord;

    if (quizProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (word == null || quizProvider.answerOptions.isEmpty) {
      return const Center(child: Text("No words available for quiz."));
    }

    return Quizui(
      question: "What is the Antonym of '${word.word}'?",
      options: quizProvider.answerOptions,
      onOptionSelected: (answer) {
        quizProvider.checkAnswer(answer);

        if (quizProvider.isCorrect != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(quizProvider.isCorrect! ? "Correct!" : "Wrong!"),
              content: Text(quizProvider.isCorrect!
                  ? "Well done!"
                  : "The correct answer was: ${quizProvider.answerOptions.first}"),
              actions: [
                TextButton(
                  onPressed: () {
                    quizProvider.updateQuiz(3, context);
                    Navigator.pop(context);
                  },
                  child: const Text("Next"),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
