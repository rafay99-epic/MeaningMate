import 'package:flutter/material.dart';

import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_meaning.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_synonym.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_tense.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_antonym.dart';

class QuizProvider extends ChangeNotifier {
  int _selectedTagIndex = 0;

  final List<String> quizTags = [
    'Meaning',
    'Synonym',
    'Tense',
    'Antonym',
  ];

  final List<Widget> _quizzes = [
    const QuizMeaning(),
    const QuizSynonym(),
    const QuizTense(),
    const QuizAntonym(),
  ];

  int get selectedTagIndex => _selectedTagIndex;

  Widget get currentQuiz => _quizzes[_selectedTagIndex];

  void updateQuiz(int index) {
    _selectedTagIndex = index;
    notifyListeners();
  }
}
