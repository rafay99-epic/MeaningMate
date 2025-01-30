import 'package:flutter/material.dart';
import 'package:meaning_mate/providers/quiz_provider.dart';
import 'package:meaning_mate/screens/quiz/quiz_ui.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:word_generator/word_generator.dart';

class QuizMeaning extends StatelessWidget {
  const QuizMeaning({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final word = quizProvider.currentWord;

    if (word == null) {
      return const Center(child: Text("No words available for quiz."));
    }

    // Generate random wrong answers using word_generator
    final wordGenerator = WordGenerator();
    final wrongAnswers = wordGenerator.randomNouns(3);

    final allOptions = [...word.meaning, ...wrongAnswers]..shuffle(Random());

    return Quizui(
      question: "What is the meaning of '${word.word}'?",
      options: allOptions,
      onOptionSelected: (answer) {
        quizProvider.checkAnswer(answer);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(quizProvider.isCorrect! ? "Correct!" : "Wrong!"),
            content: Text(quizProvider.isCorrect!
                ? "Well done!"
                : "The correct answer was: ${word.meaning[0]}"),
            actions: [
              TextButton(
                onPressed: () {
                  quizProvider.updateQuiz(
                      quizProvider.selectedTagIndex, context);
                  Navigator.pop(context);
                },
                child: const Text("Next"),
              )
            ],
          ),
        );
      },
    );
  }
}
