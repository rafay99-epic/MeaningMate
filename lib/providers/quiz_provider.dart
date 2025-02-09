import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meaning_mate/models/word_model.dart';
import 'package:meaning_mate/repositories/quiz_repository.dart';
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
  List<String> _answerOptions = [];
  String _correctAnswer = "";
  bool _isLoading = false;
  final QuizRepository _quizRepository;

  QuizProvider({required QuizRepository quizRepository})
      : _quizRepository = quizRepository;

  final List<String> quizTags = ['Meaning', 'Synonym', 'Tense', 'Antonym'];
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
  List<String> get answerOptions => _answerOptions;
  Widget get currentQuiz => _quizzes[_selectedTagIndex];
  bool get isLoading => _isLoading;

  void updateQuiz(int index, BuildContext context) {
    _selectedTagIndex = index;
    _generateNewQuiz(context);
  }

  Future<void> _generateNewQuiz(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final words =
          Provider.of<SearchProvider>(context, listen: false).filteredWords;
      if (words.isNotEmpty) {
        try {
          _currentWord = words[Random().nextInt(words.length)];
          await _generateAnswerOptions();
        } catch (e) {
          _currentWord = null;
          _answerOptions = [];
        }
      } else {
        _currentWord = null;
        _answerOptions = [];
      }

      _isCorrect = null;
      _selectedAnswer = null;
    } catch (e) {
      debugPrint('Error generating quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _generateAnswerOptions() async {
    try {
      if (_currentWord == null) {
        throw Exception("Current word is null.");
      }

      if (_selectedTagIndex < 0 || _selectedTagIndex > 3) {
        throw Exception("Invalid tag index: $_selectedTagIndex");
      }

      switch (_selectedTagIndex) {
        case 0: // Meaning Quiz
          _correctAnswer = _cleanAnswer(_currentWord!.meaning.toString());
          break;
        case 1: // Synonym Quiz
          _correctAnswer = _cleanAnswer(_currentWord!.synonyms.isNotEmpty
              ? _currentWord!.synonyms.first
              : "");
          break;
        case 2: // Tense Quiz
          _correctAnswer = _cleanAnswer(_currentWord!.tenses.isNotEmpty
              ? _currentWord!.tenses.first
              : "");
          break;
        case 3: // Antonym Quiz
          _correctAnswer = _cleanAnswer(_currentWord!.antonyms.isNotEmpty
              ? _currentWord!.antonyms.first
              : "");
          break;
        default:
          throw Exception("Unhandled tag index: $_selectedTagIndex");
      }

      if (_correctAnswer.isEmpty) {
        throw Exception("Correct answer could not be generated.");
      }

      _answerOptions = [_correctAnswer];

      // Generate fake options safely
      try {
        final fakeOptions = await _quizRepository.generateFakeOptions(
            _correctAnswer, _currentWord!.word, _selectedTagIndex);
        if (fakeOptions.isNotEmpty) {
          _answerOptions.addAll(fakeOptions);
          _answerOptions.shuffle();
        } else {
          throw Exception("Failed to generate fake options.");
        }
      } catch (e) {
        print("Error generating fake options: $e");
      }
    } catch (e) {
      print("Error in _generateAnswerOptions: $e");
      _correctAnswer = ""; // Reset answer to prevent incorrect data usage
      _answerOptions = [];
    }
  }

  void checkAnswer(String answer) {
    _isCorrect = _normalize(answer) == _normalize(_correctAnswer);
    _selectedAnswer = answer;
    notifyListeners();
  }

  String _normalize(String text) {
    return text.trim().toLowerCase();
  }

  String _cleanAnswer(String answer) {
    final keywordPattern = RegExp(r'^\*\*(\w+)\s*:\*\*', caseSensitive: false);
    return answer.replaceAll(keywordPattern, '').trim();
  }
}
