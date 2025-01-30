import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_meaning.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_synonym.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_tense.dart';
import 'package:meaning_mate/screens/quiz/quizes_compoent/quiz_antonym.dart';
import 'package:provider/provider.dart';
import 'search_provider.dart';

class QuizProvider extends ChangeNotifier {
  int _selectedTagIndex = 0;
  Word? _currentWord;
  String? _selectedAnswer;
  bool? _isCorrect;

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
  Word? get currentWord => _currentWord;
  bool? get isCorrect => _isCorrect;
  String? get selectedAnswer => _selectedAnswer;

  Widget get currentQuiz => _quizzes[_selectedTagIndex];

  void updateQuiz(int index, BuildContext context) {
    _selectedTagIndex = index;
    _generateNewQuiz(context);
    notifyListeners();
  }

  void _generateNewQuiz(BuildContext context) {
    final words =
        Provider.of<SearchProvider>(context, listen: false).filteredWords;

    if (words.isNotEmpty) {
      _currentWord = words[Random().nextInt(words.length)];
    } else {
      _currentWord = null;
    }
    _isCorrect = null;
    _selectedAnswer = null;
    notifyListeners();
  }

  void checkAnswer(String answer) {
    switch (_selectedTagIndex) {
      case 0: // Meaning Quiz
        _isCorrect = _currentWord?.meaning.contains(answer) ?? false;
        break;
      case 1: // Synonym Quiz
        _isCorrect = _currentWord?.synonyms.contains(answer) ?? false;
        break;
      case 2: // Tense Quiz
        _isCorrect = _currentWord?.tenses.contains(answer) ?? false;
        break;
      case 3: // Antonym Quiz
        _isCorrect = _currentWord?.antonyms.contains(answer) ?? false;
        break;
    }
    _selectedAnswer = answer;
    notifyListeners();
  }
}
